#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

{
    package Foo;
    use Vendor;
    install;
}

ok( Foo->vendor() );

done_testing;
