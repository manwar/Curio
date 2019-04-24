package Curio;
our $VERSION = '0.01';

use Curio::Declare qw();
use Curio::Meta;
use Curio::Role qw();
use Import::Into;
use Moo qw();
use Moo::Role qw();

use strictures 2;
use namespace::clean;

sub import {
    my $target = caller;

    Moo->import::into( 1 );
    Curio::Declare->import::into( 1 );
    namespace::clean->import::into( 1 );

    Moo::Role->apply_roles_to_package(
        $target,
        'Curio::Role',
    );

    $target->setup_curio();

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

    use Moo;
    use Curio::Declare;
    use namespace::clean;
    with 'Curio::Role';
    __PACKAGE__->setup_curio();

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

