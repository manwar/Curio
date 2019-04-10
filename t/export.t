#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest export => sub{
    subtest no_always => sub{
        my $class = 'VT::no_always';
        package VT::no_always;
        use Vendor;
        export_name 'get_foo';
        package main;

        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import();
        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import('get_foo');
        is( dies{ get_foo() }, undef, 'export installed' );

        my $object = get_foo();
        isa_ok( $object, $class );

        $class->vendor->export_name( 'get_foo2' );
        $class->import('get_foo2');
        ok( !$class->can('get_foo'), 'old export removed' );
        ok( $class->can('get_foo2'), 'new export installed' );
    };

    subtest always => sub{
        my $class = 'VT::always';
        package VT::always;
        use Vendor;
        export_name 'get_bar';
        always_export;
        package main;

        isnt( dies{ get_bar() }, undef, 'export not yet installed' );
        $class->import();
        is( dies{ get_bar() }, undef, 'export installed' );
    };
};

done_testing;
