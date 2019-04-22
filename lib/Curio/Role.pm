package Curio::Role;
our $VERSION = '0.01';

use Curio::Meta;

use Moo::Role;
use strictures 2;
use namespace::clean;

use Exporter qw( import );

sub curio {
    return Curio::Meta->find_meta( shift );
}

1;
__END__

=encoding utf8

=head1 NAME

Curio::Role - Role for Curio classes.

=head1 DESCRIPTION

This L<Moo::Role>:

=over

=item *

Sets up L<Exporter> so that L<Curio/export_name> and
L<Curio/always_export> can work.

=item *

Provides the L</curio> method, a convenient way to access
the underlying L<Curio::Meta> object of a curio class.

=item *

Enables C<$class-E<gt>does('Curio::Role')> checks.

=back

=head1 CLASS METHODS

=head2 curio

    my $curio_meta = MyApp::Cache->curio();

Returns the class's L<Curio::Meta> object.

This method may also be called on instances of the class.

Calling this is equivalent to calling L<Curio::Meta/find_meta>.

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

