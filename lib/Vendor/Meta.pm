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
use Vendor::Util qw( croak );

use Moo;
use strictures 2;
use namespace::clean;

sub _process_key_arg {
    my $self = shift;

    my $key;

    if ($self->does_keys()) {
        if (@_) {
            $key = shift;
            croak 'Invalid key' if !NonEmptySimpleStr->check( $key );
        }
        elsif (defined $self->default_key()) {
            $key = $self->default_key();
        }
        else {
            croak 'A key is required';
        }

        if ($self->requires_declared_key()) {
            croak 'Key is not declared' if !$self->keys->{$key};
        }
    }

    croak 'Too many arguments' if @_;

    return $key;
}

has _cache => (
    is       => 'ro',
    init_arg => undef,
    isa      => HashRef,
    default  => sub{ {} },
);

my $undef_cache_key = '__UNDEF_KEY__';

sub _cache_set {
    my ($self, $key, $object) = @_;
    $key = $undef_cache_key if !defined $key;
    $self->_cache->{$key} = $object;
    return;
}

sub _cache_get {
    my ($self, $key) = @_;
    $key = $undef_cache_key if !defined $key;
    return $self->_cache->{$key};
}

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

=head2 does_keys

=cut

has does_keys => (
    is      => 'lazy',
    isa     => Bool,
);
sub _build_does_keys {
    my ($self) = @_;
    return 1 if %{ $self->keys() };
    return 0;
}

=head2 keys

=cut

has keys => (
    is      => 'ro',
    isa     => Map[ NonEmptySimpleStr, HashRef ],
    default => sub{ {} },
);

=head2 requires_declared_key

=cut

has requires_declared_key => (
    is      => 'ro',
    isa     => Bool,
    default => 1,
);

=head2 default_key

=cut

has default_key => (
    is  => 'ro',
    isa => NonEmptySimpleStr,
);

=head2 key_argument

=cut

has key_argument => (
    is  => 'ro',
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

    my %args = %{ $self->keys->{$key} || {} };

    if (defined $self->key_argument()) {
        $args{ $self->key_argument() } = $key;
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

