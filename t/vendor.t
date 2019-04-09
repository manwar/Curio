#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

{
    package Foo;
    use Vendor;
}

ok( Foo->vendor() );

done_testing;
