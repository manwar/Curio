package Vendor::Role;
our $VERSION = '0.01';

use Vendor::Meta;

use Moo::Role;
use strictures 2;
use namespace::clean;

use Exporter qw( import );

sub vendor {
    return Vendor::Meta->find_meta( shift );
}

1;
__END__

=encoding utf8

=head1 NAME

Vendor::Role - Role for Vendor classes.

=head1 DESCRIPTION

This L<Moo::Role>:

=over

=item *

Sets up L<Exporter> so that L<Vendor/export_name> and
L<Vendor/always_export> can work.

=item *

Provides the L</vendor> method, a convenient way to access
the underlying L<Vendor::Meta> object of a vendor class.

=item *

Enables C<$class-E<gt>does('Vendor::Role')> checks.

=back

=head1 CLASS METHODS

=head2 vendor

    my $vendor_meta = MyApp::Cache->vendor();

Returns the class's L<Vendor::Meta> object.

This method may also be called on instances of the class.

Calling this is equivalent to calling L<Vendor::Meta/find_meta>.

=head1 SUPPORT

See L<Vendor/SUPPORT>.

=head1 AUTHORS

See L<Vendor/AUTHORS>.

=head1 LICENSE

See L<Vendor/LICENSE>.

=cut

