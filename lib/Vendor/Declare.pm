package Vendor::Declare;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Vendor::Declare - Define vendor classes using declarative functions.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

use Vendor::Meta;

use strictures 2;
use namespace::clean;

use Exporter qw();

our @EXPORT = qw(
    fetch_method_name
    export_name
    always_export
    does_caching
    does_keys
    require_key_declaration
    default_key
    key_argument
    add_key
);

sub import {
    my ($class) = @_;

    my $target = caller;
    Vendor::Meta->new( class=>$target );

    goto &Exporter::import;
}

=head1 EXPORTED FUNCTIONS

=head2 fetch_method_name

=cut

sub fetch_method_name ($) {
    my $class = caller;
    $class->vendor->fetch_method_name( shift );
    return;
}

=head2 export_name

=cut

sub export_name ($) {
    my $class = caller;
    $class->vendor->export_name( shift );
    return;
}

=head2 always_export

=cut

sub always_export (;$) {
    my $class = caller;
    $class->vendor->always_export( @_ ? shift : 1 );
    return;
}

=head2 does_caching

=cut

sub does_caching (;$) {
    my $class = caller;
    $class->vendor->does_caching( @_ ? shift : 1 );
    return;
}

=head2 does_keys

=cut

sub does_keys (;$) {
    my $class = caller;
    $class->vendor->does_keys( @_ ? shift : 1 );
    return;
}

=head2 require_key_declaration

=cut

sub require_key_declaration (;$) {
    my $class = caller;
    $class->vendor->require_key_declaration( @_ ? shift : 1 );
    return;
}

=head2 default_key

=cut

sub default_key ($) {
    my $class = caller;
    $class->vendor->default_key( shift );
    return;
}

=head2 key_argument

=cut

sub key_argument ($) {
    my $class = caller;
    $class->vendor->key_argument( shift );
    return;
}

=head2 add_key

=cut

sub add_key ($;@) {
    my $class = caller;
    $class->vendor->add_key( @_ );
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

