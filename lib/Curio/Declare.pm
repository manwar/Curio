package Curio::Declare;
our $VERSION = '0.01';

use Package::Stash;

use strictures 2;
use namespace::clean;

my %EXPORTS = (
    fetch_method_name      => 'string',
    export_function_name   => 'string',
    always_export          => 'bool',
    resource_method_name   => 'string',
    fetch_returns_resource => 'bool',
    registers_resources    => 'bool',
    does_caching           => 'bool',
    cache_per_process      => 'bool',
    does_keys              => 'bool',
    allow_undeclared_keys  => 'bool',
    default_key            => 'string',
    key_argument           => 'string',
    add_key                => 'method',
    alias_key              => 'method',
);

sub import {
    my $target = caller;

    my $stash = Package::Stash->new( $target );

    foreach my $sub_name (sort keys %EXPORTS) {
        my $type = $EXPORTS{ $sub_name };
        my $builder = "_build_$type\_sub";
        my $sub = __PACKAGE__->can( $builder )->( $target, $sub_name );
        $stash->add_symbol( "&$sub_name", $sub );
    }

    return;
}

sub _build_string_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, shift );
        goto &{ $factory->can( $sub_name ) };
    };
}

sub _build_bool_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, (@_ ? shift : 1 ) );
        goto &{ $factory->can( $sub_name ) };
    };
}

sub _build_method_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, @_ );
        goto &{ $factory->can( $sub_name ) };
    };
}

1;
__END__

=encoding utf8

=head1 NAME

Curio::Declare - Provider of Curio's declarative interface.

=head1 DESCRIPTION

...

=head1 EXPORTED FUNCTIONS

=head2 fetch_method_name

=head2 export_function_name

=head2 always_export

=head2 resource_method_name

=head2 fetch_returns_resource

=head2 registers_resources

=head2 does_caching

=head2 cache_per_process

=head2 does_keys

=head2 allow_undeclared_keys

=head2 default_key

=head2 key_argument

=head2 add_key

=head2 alias_key

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

