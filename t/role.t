#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Vendor::Meta;

{
    package Foo;
    use Moo;
    with 'Vendor::Role';
}

is( Foo->vendor(), undef, 'vendor() returned undef' );

Vendor::Meta->new( class=>'Foo' );

isnt( Foo->vendor(), undef, 'vendor() returned meta' );

done_testing;
