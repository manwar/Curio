#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Vendor::Meta;

my $class = 'VT';
package VT;
    use Moo;
    with 'Vendor::Role';
package main;

is( $class->vendor(), undef, 'vendor() returned undef' );

Vendor::Meta->new( class=>$class );

isa_ok( $class->vendor(), ['Vendor::Meta'], 'vendor() returned meta' );

done_testing;
