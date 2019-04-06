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

use Types::Standard qw( Bool Map HashRef );
use Types::Common::String qw( NonEmptySimpleStr );
use Class::Method::Modifiers qw( install_modifier );
use Carp qw();

sub croak {
    local $Carp::Internal{'Vendor'} = 1;
    local $Carp::Internal{'Vendor::Declare'} = 1;
    local $Carp::Internal{'Vendor::Meta'} = 1;
    local $Carp::Internal{'Vendor::Role'} = 1;
    return Carp::croak( @_ );
}

use Moo;
use strictures 2;
use namespace::clean;

=head1 REQUIRED ARGUMENTS

=head2 class

=cut

has class => (
    is       => 'ro',
    isa      => NonEmptySimpleStr,
    required => 1,
);

=head1 OPTIONAL ARGUMENTS

=head2 fetch_method

=cut

has fetch_method => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    default => 'fetch',
);

=head2 does_caching

=cut

has does_caching => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

=head2 does_key_as_arg

=cut

has does_key_as_arg => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

=head2 does_kay_to_args

=cut

has does_key_to_args => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

=head2 requires_key

=cut

has requires_key => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

=head2 key_arg_name

=cut

has key_arg_name => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    default => 'key',
);

=head2 requires_key_args

=cut

has requires_key_args => (
    is      => 'ro',
    isa     => Bool,
    default => 1,
);

=head2 key_args

=cut

has key_args => (
    is      => 'ro',
    isa     => Map[ NonEmptySimpleStr, HashRef ],
    default => sub{ {} },
);

=head1 ATTRIBUTES

=head2 cache

=cut

has cache => (
    is       => 'ro',
    init_arg => undef,
    isa      => HashRef,
    default  => sub{ {} },
);

=head2 does_keys

=cut

sub does_keys {
    my ($self) = @_;
    return 1 if $self->does_key_as_arg();
    return 1 if $self->does_key_to_args();
    return 0;
}

=head1 METHODS

=head2 fetch

=cut

sub fetch {
    my $self = shift;

    my $key;
    if ($self->does_keys()) {
        croak 'No key passed' if $self->requires_key() and !@_;
        if (@_) {
            $key = shift;
            croak 'Key not defined' if !defined $key;
        }
    }

    croak 'Too many arguments' if @_;

    if ($self->does_caching()) {
        my $object = $self->cache->{$key};
        return $object if $object;
    }

    my $object = $self->create( defined($key) ? $key : () );

    if ($self->does_caching()) {
        $self->cache->{$key} = $object;
    }

    return $object;
}

=head2 create

=cut

sub create {
    my $self = shift;

    my $key;
    if ($self->does_keys()) {
        croak 'A key is required' if $self->requires_key() and !@_;
        if (@_) {
            $key = shift;
            croak 'Key not defined' if !defined $key;
        }
    }

    croak 'Too many arguments' if @_;

    my $args = defined($key) ? $self->key_to_args( $key ) : {};

    my $object = $self->class->new( $args );

    return $object;
}

=head2 key_to_args

=cut

sub key_to_args {
    my $self = shift;

    croak 'No key passed' if !@_;
    my $key = shift;
    croak 'Key not defined' if !defined $key;
    croak 'Too many arguments' if @_;

    my %args;

    if ($self->does_key_as_arg()) {
        $args{ $self->key_arg_name() } = $key;
    }

    if ($self->does_key_to_args()) {
        my $key_args = $self->key_args->{$key};
        croak 'Unknown key' if $self->requires_key_args() and !$key_args;
        %args = ( %args, %$key_args );
    }

    return \%args;
}

=head2 install

=cut

sub _fetch_sub {
    my $class = shift;
    return $class->vendor->fetch( @_ );
}

sub install {
    my $self = shift;

    croak 'Too many arguments' if @_;

    install_modifier(
        $self->class(),
        'fresh',
        $self->fetch_method(),
        \&_fetch_sub,
    );

    return;
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

