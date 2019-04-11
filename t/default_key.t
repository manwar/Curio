#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_key => sub{
    my $class = 'VT::no_key';
    package VT::no_key;
        use Vendor;
        does_keys;
    package main;

    isnt( dies{ $class->fetch() }, undef, 'no key failed' );
    is( dies{ $class->fetch('key') }, undef, 'key worked' );
};

subtest key => sub{
    my $class = 'VT::key';
    package VT::key;
        use Vendor;
        does_keys;
        default_key 'foo';
    package main;

    is( dies{ $class->fetch() }, undef, 'no key worked' );
    is( dies{ $class->fetch('key') }, undef, 'key worked' );
};

done_testing;