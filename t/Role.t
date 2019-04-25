#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Curio::Factory;

my $class = 'VT';
package VT;
    use Moo;
    with 'Curio::Role';
package main;

isnt( dies{ $class->factory() }, undef, 'factory() failed' );

Curio::Factory->new( class=>$class );

isa_ok( $class->factory(), ['Curio::Factory'], 'factory() returned a factory' );

done_testing;
