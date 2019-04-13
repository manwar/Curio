package Vendor::Meta;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Vendor::Meta - Vendor class metadata and core functionality.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

use Carp qw();
use Package::Stash;
use Scalar::Util qw( blessed );
use Types::Common::String qw( NonEmptySimpleStr );
use Types::Standard qw( Bool Map HashRef );

sub croak {
    local $Carp::Internal{'Vendor'} = 1;
    local $Carp::Internal{'Vendor::Meta'} = 1;
    local $Carp::Internal{'Vendor::Role'} = 1;

    return Carp::croak( @_ );
}

use Moo;
use strictures 2;
use namespace::clean;

my %class_to_meta;

sub BUILD {
    my ($self) = @_;

    $self->_store_class_to_meta();
    $self->_trigger_fetch_method_name();
    $self->_trigger_export_name();
    $self->_trigger_always_export();

    return;
}

sub _store_class_to_meta {
    my ($self) = @_;

    my $class = $self->class();

    croak "Class already has a Vendor::Meta object: $class" if $class_to_meta{ $class };

    $class_to_meta{ $class } = $self;

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
    my ($self, $key, $object) = @_;
    $key = $self->_fixup_cache_key( $key );
    $self->_cache->{$key} = $object;
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

    if (defined $old_name) {
        $stash->remove_symbol( "&$old_name" )
    }

    $stash->add_symbol(
        "&$new_name",
        sub{ shift; $self->fetch(@_) },
    );

    $self->_installed_fetch_method_name( $new_name );

    return;
}

=head2 export_name

=cut

has export_name => (
    is      => 'rw',
    isa     => NonEmptySimpleStr,
    trigger => 1,
);

has _installed_export_name => (
    is => 'rw',
);

sub _trigger_export_name {
    my ($self) = @_;

    return if !defined $self->export_name();

    my $stash = Package::Stash->new( $self->class() );
    my $new_name = $self->export_name();
    my $old_name = $self->_installed_export_name();

    if (defined $old_name) {
        $stash->remove_symbol( "&$old_name" )
    }

    $stash->add_symbol(
        "&$new_name",
        sub{ $self->fetch( @_ ) },
    );

    $self->_trigger_always_export();

    $self->_installed_export_name( $new_name );

    return;
}

=head2 always_export

=cut

has always_export => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
    trigger => 1,
);

has _installed_always_export => (
    is => 'rw',
);

sub _trigger_always_export {
    my ($self) = @_;

    return if !defined $self->export_name();

    my $stash = Package::Stash->new( $self->class() );
    my $new_always = $self->always_export();
    my $old_always = $self->_installed_always_export();

    if (defined $old_always) {
        $stash->remove_symbol( '@EXPORT' );
        $stash->remove_symbol( '@EXPORT_OK' );
    }

    if ($new_always) {
        $stash->add_symbol( '@EXPORT', [ $self->export_name() ] );
        $stash->add_symbol( '@EXPORT_OK', [] );
    }
    else {
        $stash->add_symbol( '@EXPORT', [] );
        $stash->add_symbol( '@EXPORT_OK', [ $self->export_name() ] );
    }

    $self->_installed_always_export( $new_always );

    return;
}

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

has _does_keys => (
    is       => 'rw',
    isa      => Bool,
    init_arg => 'does_keys',
);

sub does_keys {
    my $self = shift;

    return $self->_does_keys( @_ ) if @_;

    my $existing = $self->_does_keys();
    return $existing if defined $existing;

    return 1 if %{ $self->_keys() };
    return 1 if %{ $self->_aliases() };
    return 0;
}

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

=head1 METHODS

=head2 fetch

=cut

sub fetch {
    my $self = shift;

    my $key = $self->_process_key_arg( @_ );

    if ($self->does_caching()) {
        my $object = $self->_cache_get( $key );
        return $object if $object;
    }

    my $object = $self->create( defined($key) ? $key : () );

    if ($self->does_caching()) {
        $self->_cache_set( $key, $object );
    }

    return $object;
}

=head2 create

=cut

sub create {
    my $self = shift;

    my $key = $self->_process_key_arg( @_ );

    my $args = $self->arguments( defined($key) ? $key : () );

    my $object = $self->class->new( $args );

    return $object;
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

=head2 find_meta

=cut

sub find_meta {
    my ($class, $for_class) = @_;

    croak 'Too few arguments passed to find_meta()' if @_ < 2;
    croak 'Too many arguments passed to find_meta()' if @_ > 2;

    $for_class = blessed( $for_class ) || $for_class;

    return $class_to_meta{ $for_class };
}

1;
__END__

=head1 SUPPORT

See L<Vendor/SUPPORT>.

=head1 AUTHORS

See L<Vendor/AUTHORS>.

=head1 LICENSE

See L<Vendor/LICENSE>.

=cut

