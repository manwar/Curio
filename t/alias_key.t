#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    allow_undeclared_keys;
    alias_key 'foo' => 'bar';
    key_argument 'actual_key';
    has actual_key => ( is=>'ro' );
package main;

is(
    $class->fetch('foo')->actual_key(),
    'bar',
    'key alias was used',
);

is(
    $class->fetch('bar')->actual_key(),
    'bar',
    'key alias was not used',
);

is(
    $class->fetch('baz')->actual_key(),
    'baz',
    'key alias was not used',
);

done_testing;
