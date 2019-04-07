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

subtest does_caching => sub{
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
        my $object3 = $meta->create();

        ref_is( $object1, $object2, 'caching is enabled' );
        ref_is_not( $object1, $object3, 'create bypassed caching' );
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
        my $object4 = $meta->create('key1');

        ref_is_not( $object1, $object2, 'different keys' );
        ref_is( $object1, $object3, 'caching is enabled' );
        ref_is_not( $object1, $object4, 'create bypassed caching' );
    };
};

subtest does_keys => sub{
    subtest 'no_keys' => sub{
        my $meta = new_meta( 'no_does_keys' );

        foreach my $method (qw( fetch create arguments )) {
            is(
                dies{ $meta->$method() }, undef,
                "$method with no key worked",
            );
            isnt(
                dies{ $meta->$method('key') }, undef,
                "$method with key failed",
            );
        }
    };

    subtest 'keys' => sub{
        my $meta = new_meta(
            'does_keys',
            does_keys => 1,
        );

        foreach my $method (qw( fetch create arguments )) {
            isnt(
                dies{ $meta->$method() }, undef,
                "$method with no key failed",
            );
            is(
                dies{ $meta->$method('key') }, undef,
                "$method with key worked",
            );
        }
    };

    subtest 'keys_with_default' => sub{
        my $meta = new_meta(
            'does_keys_with_default',
            does_keys   => 1,
            default_key => 'foo',
        );

        foreach my $method (qw( fetch create arguments )) {
            is(
                dies{ $meta->$method() }, undef,
                "$method with no key worked",
            );
            is(
                dies{ $meta->$method('key') }, undef,
                "$method with key worked",
            );
        }
    };
};

subtest requires_key_declaration => sub{
    subtest no_requires => sub{
        my $meta = new_meta(
            'no_requires_declared_key',
            does_keys => 1,
            keys      => { foo=>{} },
            requires_key_declaration => 0,
        );

        is( dies{ $meta->fetch('foo') }, undef, 'known key worked' );
        is( dies{ $meta->fetch('bar') }, undef, 'unknown key worked' );
    };

    subtest requires => sub{
        my $meta = new_meta(
            'requires_declared_key',
            does_keys => 1,
            keys      => { foo=>{} },
        );

        is( dies{ $meta->fetch('foo') }, undef, 'known key worked' );
        isnt( dies{ $meta->fetch('bar') }, undef, 'unknown key failed' );
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
