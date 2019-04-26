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
    registers_resources
    does_caching
    cache_per_process
    allow_undeclared_keys
    default_key
    key_argument
    add_key
    alias_key
);

sub fetch_method_name {
    my $factory = caller->factory();
    @_ = ( $factory, shift );
    goto &{ $factory->can('fetch_method_name') };
}

sub export_function_name {
    my $factory = caller->factory();
    @_ = ( $factory, shift );
    goto &{ $factory->can('export_function_name') };
}

sub always_export {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('always_export') };
}

sub resource_method_name {
    my $factory = caller->factory();
    @_ = ( $factory, shift );
    goto &{ $factory->can('resource_method_name') };
}

sub fetch_returns_resource {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('fetch_returns_resource') };
}

sub registers_resources {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('registers_resources') };
}

sub does_caching {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('does_caching') };
}

sub cache_per_process {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('cache_per_process') };
}

sub allow_undeclared_keys {
    my $factory = caller->factory();
    @_ = ( $factory, (@_ ? shift : 1) );
    goto &{ $factory->can('allow_undeclared_keys') };
}

sub default_key {
    my $factory = caller->factory();
    @_ = ( $factory, shift );
    goto &{ $factory->can('default_key') };
}

sub key_argument {
    my $factory = caller->factory();
    @_ = ( $factory, shift );
    goto &{ $factory->can('key_argument') };
}

sub add_key {
    my $class = caller;
    $class->factory->add_key( @_ );
    return;
}

sub alias_key {
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

=head2 registers_resources

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

