#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

use Vendor::Role qw();
use Moo qw();
use Import::Into;

my $new_class_counter = 0;

subtest basic => sub{
    my $class = new_class(
        fetch_method_name => 'connect',
    );

    is(
        $class->vendor_meta->class(),
        $class,
        'vendor_meta was installed and works',
    );

    is(
        $class->vendor_meta->fetch_method_name(),
        'connect',
        'argument to install_vendor made it to the meta',
    );
};

subtest export => sub{
    subtest no_always => sub{
        my $class = new_class(
            export_name => 'get_foo',
        );

        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import();
        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import('get_foo');
        is( dies{ get_foo() }, undef, 'export installed' );

        my $object = get_foo();
        isa_ok( $object, $class );
    };

    subtest always => sub{
        my $class = new_class(
            export_name => 'get_bar',
            always_export => 1,
        );

        isnt( dies{ get_bar() }, undef, 'export not yet installed' );
        $class->import();
        is( dies{ get_bar() }, undef, 'export installed' );
    };
};

done_testing;

sub new_class {
    $new_class_counter++;

    my $class = "Vendor::Test$new_class_counter";

    Moo->import::into( $class );
    $class->can( 'with' )->( 'Vendor::Role' );
    $class->install_vendor( @_ );

    note "$class created";

    return $class;
}
