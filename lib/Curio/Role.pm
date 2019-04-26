package Curio::Role;
our $VERSION = '0.01';

use Curio::Factory;
use Curio::Util;
use Exporter qw();
use Package::Stash;

use Moo::Role;
use strictures 2;
use namespace::clean;

my %is_exporter_setup;

sub import {
    my ($class) = @_;

    my $factory = $class->factory();
    my $name = $factory->export_function_name();
    return if !defined $name;

    if (!$is_exporter_setup{ $class }) {
        my $sub = subname( $name, _build_exported_fetch( $factory ) );
        my $export = $factory->always_export() ? [$name] : [];
        my $export_ok = $factory->always_export() ? [] : [$name];

        my $stash = Package::Stash->new( $class );
        $stash->add_symbol( "&$name", $sub );
        $stash->add_symbol( '@EXPORT', $export );
        $stash->add_symbol( '@EXPORT_OK', $export_ok );

        $is_exporter_setup{ $class } = 1;
    }

    goto &Exporter::import;
}

sub _build_exported_fetch {
    my $factory = shift;
    return sub{ $factory->fetch( @_ ) },
}

sub factory {
    return Curio::Factory->find_factory( shift );
}

sub setup_curio {
    Curio::Factory->new( class => shift );
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

Sets up exporting of the L<Curio::Factory/export_function_name>.

=item *

Provides the L</factory> method, a convenient way to access
the underlying L<Curio::Factory> object of a curio class.

=item *

Enables C<$class-E<gt>does('Curio::Role')> checks.

=back

=head1 CLASS METHODS

=head2 factory

    my $factory = MyApp::Service::Cache->factory();

Returns the class's L<Curio::Factory> object.

This method may also be called on instances of the class.

Calling this is equivalent to calling L<Curio::Factory/find_factory>.

=head2 setup_curio

Sets up your class's L<Curio::Factory> object and is automatically
called when you C<use Curio;>.

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

