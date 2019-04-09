package Vendor::Role;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Vendor::Role - Role for Vendor classes.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

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

=head1 SUPPORT

See L<Vendor/SUPPORT>.

=head1 AUTHORS

See L<Vendor/AUTHORS>.

=head1 LICENSE

See L<Vendor/LICENSE>.

=cut

