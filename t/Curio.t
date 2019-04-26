#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'CC';
package CC;
    use Curio;
package main;

isa_ok( $class->factory(), ['Curio::Factory'] );

done_testing;
