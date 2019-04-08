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
    fetch_method_name
    export_name
    always_export
    does_caching
    does_keys
    requires_key_declaration
    default_key
    key_argument
    has_key
    install
);

my %meta_args;

=head1 EXPORTED FUNCTIONS

=head2 fetch_method_name

=cut

sub fetch_method_name ($) {
    my $class = caller;
    $meta_args{$class}->{fetch_method_name} = shift;
    return;
}

=head2 export_name

=cut

sub export_name ($) {
    my $class = caller;
    $meta_args{$class}->{export_name} = shift;
    return;
}

=head2 always_export

=cut

sub always_export (;$) {
    my $class = caller;
    $meta_args{$class}->{always_export} = @_ ? shift : 1;
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

=head2 requires_key_declaration

=cut

sub requires_key_declaration (;$) {
    my $class = caller;
    $meta_args{$class}->{requires_key_declaration} = @_ ? shift : 1;
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

    my $args = $meta_args{$class} ||= {};
    my $keys = $args->{keys} ||= {};

    if (%$keys) {
        $args->{does_keys} = 1 if !defined $args->{does_keys};
        $args->{requires_key_declaration} = 1 if !defined $args->{requires_key_declaration};
    }

    $class->install_vendor( $args );

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

