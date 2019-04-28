#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest export_function_name => sub{
    package CC::efn;
        use Curio;
        export_function_name 'get_foo';
    package main;

    isnt( dies{ get_foo() }, undef, 'export not yet installed' );
    CC::efn->import();
    isnt( dies{ get_foo() }, undef, 'export not yet installed' );
    CC::efn->import('get_foo');
    is( dies{ get_foo() }, undef, 'export installed' );

    my $object = get_foo();
    isa_ok( $object, ['CC::efn'], 'export works' );
};

subtest always_export => sub{
    package CC::ae;
        use Curio;
        export_function_name 'get_bar';
        always_export;
    package main;

    isnt( dies{ get_bar() }, undef, 'export not yet installed' );
    CC::ae->import();
    is( dies{ get_bar() }, undef, 'export installed' );
};

done_testing;
