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

use strictures 2;

use Exporter qw( import );

our @EXPORT = qw(
    fetch_method
    does_caching
    does_keys
    key_declaration_optional
    default_key
    key_argument
    has_key
    install
);

my %meta_args;

=head1 EXPORTED FUNCTIONS

=head2 fetch_method

=cut

sub fetch_method ($) {
    my $class = caller;
    $meta_args{$class}->{fetch_method} = shift;
    return;
}

=head2 does_caching

=cut

sub does_caching (;$) {
    my $class = caller;
    $meta_args{$class}->{does_caching} = @_ ? shift : 1;
    return;
}

=head2 does_keys

=cut

sub does_keys (;$) {
    my $class = caller;
    $meta_args{$class}->{does_keys} = @_ ? shift : 1;
    return;
}

=head2 key_declaration_optional

=cut

sub key_declaration_optional (;$) {
    my $class = caller;
    my $optional = @_ ? shift : 1;
    $meta_args{$class}->{requires_declared_key} = $optional ? 0 : 1;
    return;
}

=head2 default_key

=cut

sub default_key ($) {
    my $class = caller;
    $meta_args{$class}->{default_key} = shift;
    return;
}

=head2 key_argument

=cut

sub key_argument ($) {
    my $class = caller;
    $meta_args{$class}->{key_argument} = shift;
    return;
}

=head2 has_key

=cut

sub has_key ($;@) {
    my $class = caller;
    my $key = shift;
    $meta_args{$class}->{keys}->{$key} = { @_ };
    return;
}

=head2 install

=cut

sub install () {
    my $class = caller;

    $class->install_vendor( $meta_args{$class} || {} );

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

