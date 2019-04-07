package Vendor::Util;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Vendor::Util - Utilities used internally by Vendor modules.

=cut

use Carp qw();

use Exporter qw( import );

our @EXPORT_OK = qw(
    croak
);

=head1 EXPORTABLE FUNCTIONS

=head2 croak

A custom L<Carp> C<croak()> which interalizes all Vendor modules.

=cut

sub croak {
    local $Carp::Internal{'Vendor'} = 1;
    local $Carp::Internal{'Vendor::Declare'} = 1;
    local $Carp::Internal{'Vendor::Meta'} = 1;
    local $Carp::Internal{'Vendor::Role'} = 1;
    local $Carp::Internal{'Vendor::Util'} = 1;

    return Carp::croak( @_ );
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

