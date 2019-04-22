#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Curio::Meta;

my $class = 'VT';
package VT;
    use Moo;
    with 'Curio::Role';
package main;

is( $class->curio(), undef, 'curio() returned undef' );

Curio::Meta->new( class=>$class );

isa_ok( $class->curio(), ['Curio::Meta'], 'curio() returned meta' );

done_testing;
