package Curio::Role;
our $VERSION = '0.01';

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

=cut

use Curio::Factory;
use Curio::Util;
use Exporter qw();
use Package::Stash;

use Moo::Role;
use strictures 2;
use namespace::clean;

=head1 EXPORTED FETCH FUNCTION

If L<Curio::Factory/export_function_name> is set then this
role will install an C<import> method in your class which uses
L<Exporter> to export the function to consumers of your Curio
class.

Read more at
L<Curio::Factory/export_function_name>,
L<Curio::Factory/always_export>, and
L<Curio::Factory/fetch_returns_resource>.

=cut

my %is_exporter_setup;

sub import {
    my ($class) = @_;

    my $factory = $class->factory();
    my $name = $factory->export_function_name();
    return if !defined $name;

    if (!$is_exporter_setup{ $class }) {
        my $stash = Package::Stash->new( $class );

        $stash->add_symbol(
            "&$name",
            subname( $name, _build_exported_fetch( $factory ) ),
        );

        $stash->add_symbol(
            $factory->always_export() ? '@EXPORT' : '@EXPORT_OK',
            [ $name ],
        );

        $is_exporter_setup{ $class } = 1;
    }

    goto &Exporter::import;
}

sub _build_exported_fetch {
    my $factory = shift;
    return sub{ $factory->fetch( @_ ) },
}

=head1 CLASS METHODS

=head2 fetch

    # Generic example:
    my $curio = Some::Curio::Class->fetch();

    # Or, from the Curio SYNOPSIS:
    my $chi = MyApp::Service::Cache->connect( 'sessions' );

This method proxies to L<Curio::Factory/fetch>.

The actual method name defaults to C<fetch> but may be different
based on the value of L<Curio::Factory/fetch_method_name>.

=cut

# Installed by Curio::Factory->_trigger_fetch_method_name().

=head2 inject

    MyApp::Service::Cache->inject( $curio_object );
    MyApp::Service::Cache->inject( $key, $curio_object );

This method proxies to L<Curio::Factory/inject>.

=cut

sub inject {
    my $class = shift;
    return $class->factory->inject( @_ );
}

=head2 uninject

    my $curio_object = MyApp::Service::Cache->uninject();
    my $curio_object = MyApp::Service::Cache->uninject( $key );

This method proxies to L<Curio::Factory/uninject>.

=cut

sub uninject {
    my $class = shift;
    return $class->factory->uninject( @_ );
}

=head2 factory

    my $factory = MyApp::Service::Cache->factory();

Returns the class's L<Curio::Factory> object.

This method may also be called on instances of the class.

Calling this is equivalent to calling L<Curio::Factory/find_factory>.

=cut

sub factory {
    return Curio::Factory->find_factory( shift );
}

=head2 initialize

Sets up your class's L<Curio::Factory> object and is automatically
called when you C<use Curio;>.  This is generally not called
directly by end-user code.

=cut

sub initialize {
    Curio::Factory->new( class => shift );
    return;
}

=head1 CLASS ATTRIBUTES

=head2 keys

    my $keys = MyApp::Service::Cache->keys();
    foreach my $key (@$keys) { ... }

This method proxies to L<Curio::Factory/keys>.

=cut

sub keys {
    my $class = shift;
    return $class->factory->keys( @_ );
}

1;
__END__

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

