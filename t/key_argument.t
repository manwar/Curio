#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_key_argument => sub{
    my $class = 'CC::no_key_argument';
    package CC::no_key_argument;
        use Curio;
        add_key 'bar';
        has foo => ( is=>'ro' );
    package main;

    my $object = $class->fetch('bar');

    is( $object->foo(), undef, 'key argument was not set' );
};

subtest key_argument => sub{
    my $class = 'CC::key_argument';
    package CC::key_argument;
        use Curio;
        add_key 'foo';
        add_key 'bar';
        key_argument 'foo';
        has foo => ( is=>'ro' );
    package main;

    my $object = $class->fetch('bar');

    is( $object->foo(), 'bar', 'key argument was set' );
};

done_testing;
