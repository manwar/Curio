#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest 'no_keys' => sub{
    my $class = 'CC::no_keys';
    package CC::no_keys;
        use Curio;
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
    my $class = 'CC::keys';
    package CC::keys;
        use Curio;
        add_key 'key';
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
