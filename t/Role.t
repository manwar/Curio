#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Curio::Meta;

my $class = 'VT';
package VT;
    use Moo;
    with 'Curio::Role';
package main;

isnt( dies{ $class->curio_meta() }, undef, 'curio_meta() failed' );

Curio::Meta->new( class=>$class );

isa_ok( $class->curio_meta(), ['Curio::Meta'], 'curio_meta() returned meta' );

done_testing;
