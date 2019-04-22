package Curio;
our $VERSION = '0.01';

use Exporter qw();
use Import::Into;
use Moo qw();
use Moo::Role qw();

use strictures 2;
use namespace::clean;

sub import {
    my ($class) = @_;

    my $target = caller;

    Moo->import::into( 1 );

    Moo::Role->apply_roles_to_package(
        $target,
        'Curio::Role',
    );

    Curio::Meta->new( class=>$target );

    goto &Exporter::import;
}

our @EXPORT = qw(
    fetch_method_name
    export_name
    always_export
    does_caching
    cache_per_process
    does_keys
    allow_undeclared_keys
    default_key
    key_argument
    add_key
    alias_key
);

sub fetch_method_name ($) {
    my $class = caller;
    $class->curio->fetch_method_name( shift );
    return;
}

sub export_name ($) {
    my $class = caller;
    $class->curio->export_name( shift );
    return;
}

sub always_export (;$) {
    my $class = caller;
    $class->curio->always_export( @_ ? shift : 1 );
    return;
}

sub does_caching (;$) {
    my $class = caller;
    $class->curio->does_caching( @_ ? shift : 1 );
    return;
}

sub cache_per_process (;$) {
    my $class = caller;
    $class->curio->cache_per_process( @_ ? shift : 1 );
    return;
}

sub does_keys (;$) {
    my $class = caller;
    $class->curio->does_keys( @_ ? shift : 1 );
    return;
}

sub allow_undeclared_keys (;$) {
    my $class = caller;
    $class->curio->allow_undeclared_keys( @_ ? shift : 1 );
    return;
}

sub default_key ($) {
    my $class = caller;
    $class->curio->default_key( shift );
    return;
}

sub key_argument ($) {
    my $class = caller;
    $class->curio->key_argument( shift );
    return;
}

sub add_key ($;@) {
    my $class = caller;
    $class->curio->add_key( @_ );
    return;
}

sub alias_key ($$) {
    my $class = caller;
    $class->curio->alias_key( @_ );
    return;
}

1;
__END__

=encoding utf8

=head1 NAME

Curio - Procurer of fine resources and services.

=head1 SYNOPSIS

    package MyApp::Service::Cache;
    
    use Curio;
    
    ...

=head1 DESCRIPTION

Calling C<use Curio;> is the same as:

    package MyApp::Service::Cache;
    use Moo;
    with 'Curio::Role';
    Curio::Meta->new( class=>__PACKAGE__ );

Also, all the L</EXPORTED FUNCTIONS> are exported to the calling
package.

=head1 EXPORTED FUNCTIONS

=head2 fetch_method_name

=head2 export_name

=head2 always_export

=head2 does_caching

=head2 cache_per_process

=head2 does_keys

=head2 allow_undeclared_keys

=head2 default_key

=head2 key_argument

=head2 add_key

=head2 alias_key

=head1 SUPPORT

Please submit bugs and feature requests to the
Curio GitHub issue tracker:

L<https://github.com/bluefeet/Curio/issues>

=head1 AUTHORS

    Aran Clary Deltac <bluefeet@gmail.com>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
