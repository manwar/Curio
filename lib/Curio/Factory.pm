package Curio::Factory;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Curio::Factory - Curio class core functionality and metadata.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

use Curio::Util;
use Package::Stash;
use Scalar::Util qw( blessed );
use Types::Common::String qw( NonEmptySimpleStr );
use Types::Standard qw( Bool Map HashRef );

use Moo;
use strictures 2;
use namespace::clean;

my %class_to_factory;

sub BUILD {
    my ($self) = @_;

    $self->_store_class_to_factory();
    $self->_trigger_fetch_method_name();

    return;
}

sub _store_class_to_factory {
    my ($self) = @_;

    my $class = $self->class();

    croak "Class already has a Curio::Factory object: $class" if $class_to_factory{ $class };

    $class_to_factory{ $class } = $self;

    return;
}

sub _process_key_arg {
    my $self = shift;

    my $caller_sub_name = (caller 1)[3];
    $caller_sub_name =~ s{^.*::}{};

    my $key;

    if ($self->does_keys()) {
        if (@_) {
            $key = shift;
            croak "Invalid key passed to $caller_sub_name()" if !NonEmptySimpleStr->check( $key );
        }
        elsif (defined $self->default_key()) {
            $key = $self->default_key();
        }
        else {
            croak "No key was passed to $caller_sub_name()";
        }

        if (!$self->allow_undeclared_keys()) {
            croak "Undeclared key passed to $caller_sub_name()" if !$self->_keys->{$key};
        }
    }

    croak "Too many arguments passed to $caller_sub_name()" if @_;

    $key = $self->_aliases->{$key}
        if defined($key) and defined($self->_aliases->{$key});

    return $key;
}

has _cache => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

my $undef_cache_key = '__UNDEF_KEY__';

sub _cache_set {
    my ($self, $key, $curio) = @_;
    $key = $self->_fixup_cache_key( $key );
    $self->_cache->{$key} = $curio;
    return;
}

sub _cache_get {
    my ($self, $key) = @_;
    $key = $self->_fixup_cache_key( $key );
    return $self->_cache->{$key};
}

sub _fixup_cache_key {
    my ($self, $key) = @_;

    $key = $undef_cache_key if !defined $key;
    return $key if !$self->cache_per_process();

    $key .= "-$$";
    $key .= '-' . threads->tid() if $INC{'threads.pm'};

    return $key;
}

has _keys => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

has _aliases => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

=head1 REQUIRED ARGUMENTS

=head2 class

=cut

has class => (
    is       => 'ro',
    isa      => NonEmptySimpleStr,
    required => 1,
);

=head1 OPTIONAL ARGUMENTS

=head2 fetch_method_name

=cut

has fetch_method_name => (
    is      => 'rw',
    isa     => NonEmptySimpleStr,
    default => 'fetch',
    trigger => 1,
);

has _installed_fetch_method_name => (
    is => 'rw',
);

sub _trigger_fetch_method_name {
    my ($self) = @_;

    my $stash = Package::Stash->new( $self->class() );
    my $new_name = $self->fetch_method_name();
    my $old_name = $self->_installed_fetch_method_name();

    $stash->remove_symbol( "&$old_name" ) if defined $old_name;

    $stash->add_symbol(
        "&$new_name",
        subname( $new_name, $self->_build_fetch_method() ),
    );

    $self->_installed_fetch_method_name( $new_name );

    return;
}

sub _build_fetch_method {
    my $self = shift;
    return sub{ shift; $self->fetch( @_ ) };
}

=head2 export_function_name

=cut

has export_function_name => (
    is  => 'rw',
    isa => NonEmptySimpleStr,
);

=head2 always_export

=cut

has always_export => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

=head2 resource_method_name

=cut

has resource_method_name => (
  is  => 'rw',
  isa => NonEmptySimpleStr,
);

=head2 fetch_returns_resource

=cut

has fetch_returns_resource => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

=head2 does_caching

=cut

has does_caching => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

=head2 cache_per_process

=cut

has cache_per_process => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

=head2 allow_undeclared_keys

=cut

has allow_undeclared_keys => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

=head2 default_key

=cut

has default_key => (
    is  => 'rw',
    isa => NonEmptySimpleStr,
);

=head2 key_argument

=cut

has key_argument => (
    is  => 'rw',
    isa => NonEmptySimpleStr,
);

=head1 ATTRIBUTES

=head2 does_keys

=cut

sub does_keys {
    my $self = shift;

    return 1 if %{ $self->_keys() };
    return 1 if %{ $self->_aliases() };
    return 1 if $self->allow_undeclared_keys();
    return 1 if defined $self->default_key();
    return 1 if defined $self->key_argument();

    return 0;
}

=head1 METHODS

=head2 fetch

=cut

sub fetch {
    my $self = shift;

    return(
        $self->fetch_returns_resource()
        ? $self->fetch_resource( @_ )
        : $self->fetch_curio( @_ )
    );
}

=head2 fetch_curio

=cut

sub fetch_curio {
    my $self = shift;

    my $key = $self->_process_key_arg( @_ );

    if ($self->does_caching()) {
        my $curio = $self->_cache_get( $key );
        return $curio if $curio;
    }

    my $curio = $self->create( defined($key) ? $key : () );

    if ($self->does_caching()) {
        $self->_cache_set( $key, $curio );
    }

    return $curio;
}

=head2 fetch_resource

=cut

sub fetch_resource {
    my $self = shift;

    my $method = $self->resource_method_name();
    croak 'Cannot call fetch_resource() without setting resource_method_name' if !defined $method;

    return $self->fetch_curio( @_ )->$method();
}

=head2 create

=cut

sub create {
    my $self = shift;

    my $key = $self->_process_key_arg( @_ );

    my $args = $self->arguments( defined($key) ? $key : () );

    my $curio = $self->class->new( $args );

    return $curio;
}

=head2 arguments

=cut

sub arguments {
    my $self = shift;

    my $key = $self->_process_key_arg( @_ );

    return {} if !defined $key;

    my %args = %{ $self->_keys->{$key} || {} };

    if (defined $self->key_argument()) {
        $args{ $self->key_argument() } = $key;
    }

    return \%args;
}

=head2 add_key

=cut

sub add_key {
    my ($self, $key, @args) = @_;

    croak 'Too few arguments to add_key()' if @_ < 2;
    croak 'Invalid key passed to add_key(): ' . NonEmptySimpleStr->get_message($key) if !NonEmptySimpleStr->check( $key );
    croak 'Odd number of key arguments passed to add_key()' if @args % 2 != 0;
    croak "Already declared key passed to add_key(): $key" if $self->_keys->{$key};

    $self->_keys->{$key} = { @args };

    return;
}

=head2 alias_key

=cut

sub alias_key {
    my ($self, $alias, $key) = @_;

    croak 'Too few arguments passed to alias_key()' if @_ < 3;
    croak 'Too many arguments passed to alias_key()' if @_ > 3;
    croak 'Invalid alias passed to alias_key(): ' . NonEmptySimpleStr->get_message($alias) if !NonEmptySimpleStr->check( $alias );
    croak 'Invalid key passed to alias_key(): ' . NonEmptySimpleStr->get_message($key) if !NonEmptySimpleStr->check( $key );
    croak "Already declared alias passed to alias_key(): $alias" if defined $self->_aliases->{$alias};
    croak "Undeclared key passed to alias_key(): $key" if !$self->allow_undeclared_keys() and !$self->_keys->{$key};

    $self->_aliases->{$alias} = $key;

    return;
}

=head1 CLASS METHODS

=head2 find_factory

=cut

sub find_factory {
    my ($class, $for_class) = @_;

    croak 'Too few arguments passed to find_factory()' if @_ < 2;
    croak 'Too many arguments passed to find_factory()' if @_ > 2;
    croak 'Undefined class passed to find_factory()' if !defined $for_class;

    $for_class = blessed( $for_class ) || $for_class;
    my $factory = $class_to_factory{ $for_class };

    croak "Unable to find an existing Curio::Factory object for $for_class" if !$factory;

    return $factory;
}

1;
__END__

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut
