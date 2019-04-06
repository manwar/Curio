package Vendor;
use 5.008001;
our $VERSION = '0.01';

use Import::Into;
use Vendor::Declare qw();
use Moo::Role qw();

use strictures;
use namespace::clean;

sub import {
    my $class = caller;

    shift;
    my $args = {
        map { $_ => 1 }
        @_
    };

    Vendor::Declare->import::into( $class )
        if !$args->{no_declare};

    Moo::Role->import::into( $class );

    strictures->import::into({
        level   => 1,
        version => 2,
    }) if !$args->{no_strictures};

    namespace::clean->import::into( $class )
        if !$args->{no_clean};

    $class->can( 'with' )->( 'Vendor::Role' );

    return;
}

1;
__END__

=encoding utf8

=head1 NAME

Vendor - Procurer of fine resources and services.

=head1 SYNOPSIS

    package MyApp::Service::Cache;
    
    use Vendor;
    
    ...

=head1 DESCRIPTION

Calling C<use Vendor;> is the same as:

    use Vendor::Declare;
    
    use Moo::Role;
    use strictures 2;
    use namespace::clean;
    
    with 'Vendor::Role';

This can be adjusted by setting import flags, as in:

    use Vendor qw( no_strictures );

Available flags are C<no_declare> which disables L<Vendor::Declare>,
C<no_strictures> which disables L<strictures>, and C<no_clean> which
disables L<namespace::clean>.

=head1 SUPPORT

Please submit bugs and feature requests to the
Vendor GitHub issue tracker:

L<https://github.com/bluefeet/Vendor/issues>

=head1 AUTHORS

    Aran Clary Deltac <bluefeet@gmail.com>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

