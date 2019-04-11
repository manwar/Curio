#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest 'no_keys' => sub{
    my $class = 'VT::no_keys';
    package VT::no_keys;
        use Vendor;
    package main;

    is(
        dies{ $class->fetch() }, undef,
        "no key worked",
    );

    isnt(
        dies{ $class->fetch('key') }, undef,
        "key failed",
    );
};

subtest 'keys' => sub{
    my $class = 'VT::keys';
    package VT::keys;
        use Vendor;
        does_keys;
    package main;

    isnt(
        dies{ $class->fetch() }, undef,
        "no key failed",
    );

    is(
        dies{ $class->fetch('key') }, undef,
        "key worked",
    );
};

done_testing;
