#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Vendor;
package main;

isa_ok( $class->vendor(), ['Vendor::Meta'] );

done_testing;
