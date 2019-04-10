#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_key_argument => sub{
    my $class = 'VT::no_key_argument';
    package VT::no_key_argument;
        use Vendor;
        does_keys;
        has foo => ( is=>'ro' );
    package main;

    my $object = $class->fetch('bar');

    is( $object->foo(), undef, 'key argument was not set' );
};

subtest key_argument => sub{
    my $class = 'VT::key_argument';
    package VT::key_argument;
        use Vendor;
        does_keys;
        key_argument 'foo';
        has foo => ( is=>'ro' );
    package main;

    my $object = $class->fetch('bar');

    is( $object->foo(), 'bar', 'key argument was set' );
};

done_testing;
