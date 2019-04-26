#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_require => sub{
    my $class = 'CC::no_require';
    package CC::no_require;
        use Curio;
        allow_undeclared_keys;
        add_key 'foo';
    package main;

    is( dies{ $class->fetch('foo') }, undef, 'known key worked' );
    is( dies{ $class->fetch('bar') }, undef, 'unknown key worked' );
};

subtest require => sub{
    my $class = 'CC::require';
    package CC::require;
        use Curio;
        add_key 'foo';
    package main;

    is( dies{ $class->fetch('foo') }, undef, 'known key worked' );
    isnt( dies{ $class->fetch('bar') }, undef, 'unknown key failed' );
};

done_testing;
