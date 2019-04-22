#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    export_name 'get_foo';
package main;

isnt( dies{ get_foo() }, undef, 'export not yet installed' );
$class->import();
isnt( dies{ get_foo() }, undef, 'export not yet installed' );
$class->import('get_foo');
is( dies{ get_foo() }, undef, 'export installed' );

my $object = get_foo();
isa_ok( $object, $class );

$class->curio->export_name( 'get_foo2' );
$class->import('get_foo2');
ok( !$class->can('get_foo'), 'old export removed' );
ok( $class->can('get_foo2'), 'new export installed' );

done_testing;
