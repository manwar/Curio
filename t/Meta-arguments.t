#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_keys => sub{
    my $class = 'VT::no_keys';
    package VT::no_keys;
        use Vendor;
    package main;

    is( $class->vendor->arguments(), {}, 'empty arguments' );
};

subtest keys => sub{
    my $class = 'VT::keys';
    package VT::keys;
        use Vendor;
        require_key_declaration 0;
        add_key key2 => ( foo=>'bar' );
    package main;

    is( $class->vendor->arguments('key1'), {}, 'empty arguments' );
    is( $class->vendor->arguments('key2'), {foo=>'bar'}, 'has arguments' );
};

subtest key_argument => sub{
    my $class = 'VT::key_argument';
    package VT::key_argument;
        use Vendor;
        key_argument 'foo2';
        add_key bar2 => ( foo1=>'bar1' );
        has foo1 => ( is=>'ro' );
        has foo2 => ( is=>'ro' );
    package main;

    my $object = $class->fetch('bar2');

    is( $object->foo1(), 'bar1', 'key argument was set' );
    is( $object->foo2(), 'bar2', 'key argument was set' );
};

done_testing;
