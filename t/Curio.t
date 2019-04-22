#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
package main;

isa_ok( $class->curio(), ['Curio::Meta'] );

done_testing;
