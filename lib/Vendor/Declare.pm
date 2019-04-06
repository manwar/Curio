package Vendor::Declare;
use 5.008001;
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
    does_key_as_arg
    does_key_to_args
    requires_key
    key_arg_name
    key_args_is_optional
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

=head2 does_key_as_arg

=cut

sub does_key_as_arg (;$) {
    my $class = caller;
    $meta_args{$class}->{does_key_as_arg} = @_ ? shift : 1;
    return;
}

=head2 does_key_to_args

=cut

sub does_key_to_args (;$) {
    my $class = caller;
    $meta_args{$class}->{does_key_to_args} = @_ ? shift : 1;
    return;
}

=head2 requires_key

=cut

sub requires_key (;$) {
    my $class = caller;
    $meta_args{$class}->{requires_key} = @_ ? shift : 1;
    return;
}

=head2 key_arg_name

=cut

sub key_arg_name ($) {
    my $class = caller;
    $meta_args{$class}->{key_arg_name} = shift;
    return;
}

=head2 key_args_is_optional

=cut

sub key_args_is_optional (;$) {
    my $class = caller;
    $meta_args{$class}->{requires_key_args} = @_ ? shift : 0;
    return;
}

=head2 has_key

=cut

sub has_key ($;@) {
    my $class = caller;
    my $key = shift;
    $meta_args{$class}->{key_args}->{$key} = { @_ };
    return;
}

=head2 install

=cut

sub install () {
    my $class = caller;

    my $args = $meta_args{$class} ||= {};
    my $key_args = $args->{key_args} ||= {};

    if (%$key_args) {
        $args->{does_key_to_args} = 1 if !defined $args->{does_key_to_args};
        $args->{requires_key} = 1 if !defined $args->{requires_key};
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

