#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

use Vendor::Meta;
use Moo qw();
use Import::Into;
use Scalar::Util qw( blessed );

subtest basic => sub{
    my $meta = new_meta( 'basic' );
    $meta->install();

    my $object = $meta->fetch();

    is(
        blessed($object),
        $meta->class(),
        'fetch worked',
    );
};

subtest fetch_method => sub{
    subtest default => sub{
        my $meta = new_meta( 'default_fetch' );
        ok( !$meta->class->can('fetch'), 'fetch not installed' );
        $meta->install();
        ok( $meta->class->can('fetch'), 'fetch installed' );
    };

    subtest custom => sub{
        my $meta = new_meta(
            'custom_fetch',
            fetch_method => 'connect',
        );
        ok( !$meta->class->can('fetch'), 'fetch not installed' );
        ok( !$meta->class->can('connect'), 'connect not installed' );
        $meta->install();
        ok( !$meta->class->can('fetch'), 'fetch not installed' );
        ok( $meta->class->can('connect'), 'connect installed' );
    };
};

subtest caching => sub{
    subtest no_cache => sub{
        my $meta = new_meta( 'no_cache' );
        $meta->install();
        my $object1 = $meta->fetch();
        my $object2 = $meta->fetch();
        ref_is_not( $object1, $object2, 'caching is disabled' );
    };

    subtest cache => sub{
        my $meta = new_meta(
            'cache',
            does_caching => 1,
        );
        $meta->install();
        my $object1 = $meta->fetch();
        my $object2 = $meta->fetch();
        ref_is( $object1, $object2, 'caching is enabled' );
    };

    subtest no_cache_with_keys => sub{
        my $meta = new_meta(
            'no_cache_with_keys',
            does_keys => 1,
        );
        $meta->install();

        my $object1 = $meta->fetch('key1');
        my $object2 = $meta->fetch('key2');
        my $object3 = $meta->fetch('key1');

        ref_is_not( $object1, $object2, 'different keys' );
        ref_is_not( $object1, $object3, 'caching is disabled' );
    };

    subtest cache_with_keys => sub{
        my $meta = new_meta(
            'cache_with_keys',
            does_caching => 1,
            does_keys    => 1,
        );
        $meta->install();

        my $object1 = $meta->fetch('key1');
        my $object2 = $meta->fetch('key2');
        my $object3 = $meta->fetch('key1');

        ref_is_not( $object1, $object2, 'different keys' );
        ref_is( $object1, $object3, 'caching is enabled' );
    };
};

done_testing;

sub new_meta {
    my $name = shift;

    my $meta = Vendor::Meta->new(
        class=>"Vendor::Test::$name",
        @_,
    );

    Moo->import::into( $meta->class() );

    return $meta;
}
