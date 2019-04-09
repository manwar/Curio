#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Import::Into;
use Vendor;

my $new_vendor_counter = 0;

subtest default => sub{
    my $class = new_vendor();
    ok( $class->can('fetch'), 'fetch installed' );
};

subtest custom => sub{
    my $class = new_vendor(
        fetch_method_name => 'connect',
    );

    ok( !$class->can('fetch'), 'fetch not installed' );
    ok( $class->can('connect'), 'connect installed' );

    $class->vendor->fetch_method_name('foo');

    ok( !$class->can('fetch'), 'fetch not installed' );
    ok( !$class->can('connect'), 'connect not installed' );
    ok( $class->can('foo'), 'foo installed' );
};

done_testing;

sub new_vendor {
    my %args = @_;

    $new_vendor_counter++;

    my $class = "Vendor::Test$new_vendor_counter";

    Vendor->import::into( $class );

    foreach my $key (keys %args) {
        $class->vendor->$key( $args{$key} );
    }

    note "$class created";

    return $class;
}
