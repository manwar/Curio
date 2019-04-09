#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

{
    package Foo;
    use Moo;
    with 'Vendor::Role';
    use Vendor::Declare;
}

ok( Foo->vendor() );

done_testing;
