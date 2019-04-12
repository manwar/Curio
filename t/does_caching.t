#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_cache => sub{
    my $class = 'VT::no_cache';
    package VT::no_cache;
        use Vendor;
    package main;

    my $object1 = $class->fetch();
    my $object2 = $class->fetch();

    ref_is_not( $object1, $object2, 'caching is disabled' );
};

subtest cache => sub{
    my $class = 'VT::cache';
    package VT::cache;
        use Vendor;
        does_caching;
    package main;

    my $object1 = $class->fetch();
    my $object2 = $class->fetch();
    my $object3 = $class->vendor->create();

    ref_is( $object1, $object2, 'caching is enabled' );
    ref_is_not( $object1, $object3, 'create bypassed caching' );
};

subtest no_cache_with_keys => sub{
    my $class = 'VT::no_cache_with_keys';
    package VT::no_cache_with_keys;
        use Vendor;
        does_keys;
    package main;

    my $object1 = $class->fetch('key1');
    my $object2 = $class->fetch('key2');
    my $object3 = $class->fetch('key1');

    ref_is_not( $object1, $object2, 'different keys' );
    ref_is_not( $object1, $object3, 'caching is disabled' );
};

subtest cache_with_keys => sub{
    my $class = 'VT::cache_with_keys';
    package VT::cache_with_keys;
        use Vendor;
        does_caching;
        does_keys;
    package main;

    my $object1 = $class->fetch('key1');
    my $object2 = $class->fetch('key2');
    my $object3 = $class->fetch('key1');
    my $object4 = $class->vendor->create('key1');

    ref_is_not( $object1, $object2, 'different keys' );
    ref_is( $object1, $object3, 'caching is enabled' );
    ref_is_not( $object1, $object4, 'create bypassed caching' );
};

done_testing;