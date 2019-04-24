package Curio::Role;
our $VERSION = '0.01';

use Curio::Meta;
use Curio::Util;
use Exporter qw();
use Package::Stash;

use Moo::Role;
use strictures 2;
use namespace::clean;

my %is_exporter_setup;

sub import {
    my ($class) = @_;
    my $target = caller;

    my $meta = $class->curio_meta();
    my $export_name = $meta->export_name();
    return if !defined $export_name;

    if (!$is_exporter_setup{ $class }) {
        my $sub = subname( $export_name, _build_exported_fetch( $meta ) );
        my $export = $meta->always_export() ? [$export_name] : [];
        my $export_ok = $meta->always_export() ? [] : [$export_name];

        my $stash = Package::Stash->new( $class );
        $stash->add_symbol( "&$export_name", $sub );
        $stash->add_symbol( '@EXPORT', $export );
        $stash->add_symbol( '@EXPORT_OK', $export_ok );

        $is_exporter_setup{ $class } = 1;
    }

    goto &Exporter::import;
}

sub _build_exported_fetch {
    my $meta = shift;
    return sub{ $meta->fetch( @_ ) },
}

sub curio_meta {
    return Curio::Meta->class_to_meta( shift );
}

sub setup_curio {
    Curio::Meta->new( class => shift );
    return;
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

Sets up exporting of the L<Curio::Meta/export_name>.

=item *

Provides the L</curio_meta> method, a convenient way to access
the underlying L<Curio::Meta> object of a curio class.

=item *

Enables C<$class-E<gt>does('Curio::Role')> checks.

=back

=head1 CLASS METHODS

=head2 curio_meta

    my $curio_meta = MyApp::Service::Cache->curio_meta();

Returns the class's L<Curio::Meta> object.

This method may also be called on instances of the class.

Calling this is equivalent to calling L<Curio::Meta/class_to_meta>.

=head2 setup_curio

Sets up your class's L<Curio::Meta> object and is automatically
called when you use L<Curio>.

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

