#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_cache => sub{
    my $class = 'CC::no_cache';
    package CC::no_cache;
        use Curio;
    package main;

    my $object1 = $class->fetch();
    my $object2 = $class->fetch();

    ref_is_not( $object1, $object2, 'caching is disabled' );
};

subtest cache => sub{
    my $class = 'CC::cache';
    package CC::cache;
        use Curio;
        does_caching;
    package main;

    my $object1 = $class->fetch();
    my $object2 = $class->fetch();
    my $object3 = $class->factory->create();

    ref_is( $object1, $object2, 'caching is enabled' );
    ref_is_not( $object1, $object3, 'create bypassed caching' );
};

subtest no_cache_with_keys => sub{
    my $class = 'CC::no_cache_with_keys';
    package CC::no_cache_with_keys;
        use Curio;
        add_key 'key1';
        add_key 'key2';
    package main;

    my $object1 = $class->fetch('key1');
    my $object2 = $class->fetch('key2');
    my $object3 = $class->fetch('key1');

    ref_is_not( $object1, $object2, 'different keys' );
    ref_is_not( $object1, $object3, 'caching is disabled' );
};

subtest cache_with_keys => sub{
    my $class = 'CC::cache_with_keys';
    package CC::cache_with_keys;
        use Curio;
        does_caching;
        add_key 'key1';
        add_key 'key2';
    package main;

    my $object1 = $class->fetch('key1');
    my $object2 = $class->fetch('key2');
    my $object3 = $class->fetch('key1');
    my $object4 = $class->factory->create('key1');

    ref_is_not( $object1, $object2, 'different keys' );
    ref_is( $object1, $object3, 'caching is enabled' );
    ref_is_not( $object1, $object4, 'create bypassed caching' );
};

done_testing;
