#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    export_name 'get_foo';
    always_export;
package main;

isnt( dies{ get_foo() }, undef, 'export not yet installed' );
$class->import();
is( dies{ get_foo() }, undef, 'export installed' );

done_testing;
