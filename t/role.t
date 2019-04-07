#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

{
    package Foo;
    use Moo;
    with 'Vendor::Role';
    __PACKAGE__->install_vendor();
}

ok( Foo->vendor_meta() );

done_testing;
