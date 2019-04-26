package Curio::Declare;
our $VERSION = '0.01';

use strictures 2;

use Exporter qw( import );

our @EXPORT = qw(
    fetch_method_name
    export_function_name
    always_export
    resource_method_name
    fetch_returns_resource
    does_caching
    cache_per_process
    allow_undeclared_keys
    default_key
    key_argument
    add_key
    alias_key
);

sub fetch_method_name ($) {
    my $class = caller;
    $class->factory->fetch_method_name( shift );
    return;
}

sub export_function_name ($) {
    my $class = caller;
    $class->factory->export_function_name( shift );
    return;
}

sub always_export (;$) {
    my $class = caller;
    $class->factory->always_export( @_ ? shift : 1 );
    return;
}

sub resource_method_name ($) {
    my $class = caller;
    $class->factory->resource_method_name( shift );
    return;
}

sub fetch_returns_resource (;$) {
    my $class = caller;
    $class->factory->fetch_returns_resource( @_ ? shift : 1 );
    return;
}

sub does_caching (;$) {
    my $class = caller;
    $class->factory->does_caching( @_ ? shift : 1 );
    return;
}

sub cache_per_process (;$) {
    my $class = caller;
    $class->factory->cache_per_process( @_ ? shift : 1 );
    return;
}

sub allow_undeclared_keys (;$) {
    my $class = caller;
    $class->factory->allow_undeclared_keys( @_ ? shift : 1 );
    return;
}

sub default_key ($) {
    my $class = caller;
    $class->factory->default_key( shift );
    return;
}

sub key_argument ($) {
    my $class = caller;
    $class->factory->key_argument( shift );
    return;
}

sub add_key ($;@) {
    my $class = caller;
    $class->factory->add_key( @_ );
    return;
}

sub alias_key ($$) {
    my $class = caller;
    $class->factory->alias_key( @_ );
    return;
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

=head2 does_caching

=head2 cache_per_process

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
