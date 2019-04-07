package Vendor::Role;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Vendor::Role - Role for creating Vendor classes.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

use Vendor::Meta;
use Scalar::Util qw( blessed );
use Vendor::Util qw( croak );

use Moo::Role;
use strictures 2;
use namespace::clean;

=head1 CLASS METHODS

=head2 install_vendor

=cut

sub install_vendor {
    my $class = shift;

    my $args = Vendor::Meta->BUILDARGS( @_ );

    my $meta = Vendor::Meta->new(
        %$args,
        class => $class,
    );

    $meta->install();

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

