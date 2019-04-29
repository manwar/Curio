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
use Scalar::Util qw( blessed refaddr );
use Types::Common::String qw( NonEmptySimpleStr );
use Types::Standard qw( Bool Map HashRef );

use Moo;
use strictures 2;
use namespace::clean;

my %class_to_factory;

my $undef_key = '__UNDEF_KEY__';

sub BUILD {
    my ($self) = @_;

    $self->_store_class_to_factory();
    $self->_trigger_fetch_method_name();

    return;
}

sub _store_class_to_factory {
    my ($self) = @_;

    my $class = $self->class();

    croak "Class already has a Curio::Factory object: $class"
        if $class_to_factory{ $class };

    $class_to_factory{ $class } = $self;

    return;
}

sub _process_key_arg {
    my ($self, $args) = @_;

    my $caller_sub_name = (caller 1)[3];
    $caller_sub_name =~ s{^.*::}{};

    my $key;

    if ($self->does_keys()) {
        if (@$args) {
            $key = shift @$args;
            croak "Invalid key passed to $caller_sub_name()"
                if !NonEmptySimpleStr->check( $key );
        }
        elsif (defined $self->default_key()) {
            $key = $self->default_key();
        }
        else {
            croak "No key was passed to $caller_sub_name()";
        }

        if (!$self->allow_undeclared_keys()) {
            croak "Undeclared key passed to $caller_sub_name()"
                if !$self->_keys->{$key};
        }
    }

    $key = $self->_aliases->{$key}
        if defined( $key )
        and defined( $self->_aliases->{$key} );

    return $key;
}

has _cache => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

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

    $key = $undef_key if !defined $key;
    return $key if !$self->cache_per_process();

    $key .= "-$$";
    $key .= '-' . threads->tid() if $INC{'threads.pm'};

    return $key;
}

has _registry => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

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

has _injections => (
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
    my ($self) = @_;
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

=head2 registers_resources

=cut

has registers_resources => (
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

=head2 does_keys

=cut

has does_keys => (
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

=head2 keys

=cut

sub keys {
    my ($self) = @_;
    return [ keys %{ $self->_keys() } ];
}

=head1 METHODS

=head2 fetch

=cut

sub fetch {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );
    croak 'Too many arguments passed to fetch()' if @_;

    return(
        $self->fetch_returns_resource()
        ? $self->_fetch_resource( $key )
        : $self->_fetch_curio( $key )
    );
}

=head2 fetch_curio

=cut

sub fetch_curio {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );
    croak 'Too many arguments passed to fetch_curio()' if @_;

    return $self->_fetch_curio( $key );
}

sub _fetch_curio {
    my ($self, $key) = @_;

    if ($self->does_caching()) {
        my $curio = $self->_cache_get( $key );
        return $curio if $curio;
    }

    my $curio = $self->_create( $key );

    if ($self->does_caching()) {
        $self->_cache_set( $key, $curio );
    }

    return $curio;
}

=head2 fetch_resource

=cut

sub fetch_resource {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );
    croak 'Too many arguments passed to fetch_resource()' if @_;

    return $self->_fetch_resource( $key );
}

sub _fetch_resource {
    my ($self, $key) = @_;

    my $method = $self->resource_method_name();

    croak 'Cannot call fetch_resource() without first setting resource_method_name'
        if !defined $method;

    return $self->_fetch_curio( $key )->$method();
}

=head2 create

=cut

sub create {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );
    croak 'Too many arguments passed to create()' if @_;

    return $self->_create( $key );
}

sub _create {
    my ($self, $key) = @_;

    my $args = $self->_arguments( $key );

    my $curio = $self->class->new( $args );

    if ($self->registers_resources()) {
        my $method = $self->resource_method_name();
        if (defined($method) and $curio->can($method)) {
            my $resource = $curio->$method();
            $self->_registry->{ refaddr $resource } = $curio if ref $resource;
        }
    }

    return $curio;
}

=head2 arguments

=cut

sub arguments {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );
    croak 'Too many arguments passed to arguments()' if @_;

    return $self->_arguments( $key );
}

sub _arguments {
    my ($self, $key) = @_;

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

    croakf(
        'Invalid key passed to add_key(): %s',
        NonEmptySimpleStr->get_message( $key ),
    ) if !NonEmptySimpleStr->check( $key );

    croak "Already declared key passed to add_key(): $key"
        if $self->_keys->{$key};

    croak 'Odd number of key arguments passed to add_key()'
        if @args % 2 != 0;

    $self->_keys->{$key} = { @args };

    $self->does_keys( 1 );

    return;
}

=head2 alias_key

=cut

sub alias_key {
    my ($self, $alias, $key) = @_;

    croakf(
        'Invalid alias passed to alias_key(): %s',
        NonEmptySimpleStr->get_message( $alias ),
    ) if !NonEmptySimpleStr->check( $alias );

    croakf(
        'Invalid key passed to alias_key(): %s',
        NonEmptySimpleStr->get_message( $key ),
    ) if !NonEmptySimpleStr->check( $key );

    croak "Already declared alias passed to alias_key(): $alias"
        if defined $self->_aliases->{$alias};

    croak "Undeclared key passed to alias_key(): $key"
        if !$self->allow_undeclared_keys() and !$self->_keys->{$key};

    $self->_aliases->{$alias} = $key;

    return;
}

=head2 inject

=cut

sub inject {
    my $self = shift;
    my $object = shift;
    my $key = $self->_process_key_arg( \@_ );

    $key = $undef_key if !defined $key;

    croak 'No object passed to inject()'
        if !blessed( $object );

    croakf(
        'Object of an incorrect class passed to inject(): %s (want %s)',
        ref( $object ), $self->class(),
    ) if !$object->isa( $self->class() );

    croak 'Cannot inject a Curio object where one has already been injected'
        if $self->_injections->{$key};

    $self->_injections->{$key} = $object;

    return;
}

=head1 uninject

=cut

sub uninject {
    my $self = shift;
    my $key = $self->_process_key_arg( \@_ );

    $key = $undef_key if !defined $key;

    croak 'Cannot uninject a Curio object where none has been injected'
        if !$self->_injections->{$key};

    delete $self->_injections->{$key};

    return;
}

=head2 find_curio

=cut

sub find_curio {
    my ($self, $resource) = @_;

    croak 'Non-reference resource passed to find_curio()'
        if !ref $resource;

    return $self->_registry->{ refaddr $resource };
}

=head1 CLASS METHODS

=head2 find_factory

=cut

sub find_factory {
    my ($class, $curio_class) = @_;

    croak 'Undefined Curio class passed to find_factory()'
        if !defined $curio_class;

    $curio_class = blessed( $curio_class ) || $curio_class;

    return $class_to_factory{ $curio_class };
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

