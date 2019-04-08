#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

use Vendor::Meta;
use Moo qw();
use Import::Into;
use Scalar::Util qw( blessed );

my $new_meta_counter = 0;

subtest basic => sub{
    my $meta = new_meta();
    $meta->install();

    my $object = $meta->fetch();

    is(
        blessed($object),
        $meta->class(),
        'fetch worked',
    );
};

subtest fetch_method_name => sub{
    subtest default => sub{
        my $meta = new_meta();

        ok( !$meta->class->can('fetch'), 'fetch not installed' );

        $meta->install();

        ok( $meta->class->can('fetch'), 'fetch installed' );
    };

    subtest custom => sub{
        my $meta = new_meta(
            fetch_method_name => 'connect',
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
        my $meta = new_meta();
        $meta->install();

        my $object1 = $meta->fetch();
        my $object2 = $meta->fetch();

        ref_is_not( $object1, $object2, 'caching is disabled' );
    };

    subtest cache => sub{
        my $meta = new_meta(
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
            does_caching => 1,
            does_keys => 1,
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
        my $meta = new_meta();

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
            does_keys => 1,
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

subtest require_key_declaration => sub{
    subtest no_require => sub{
        my $meta = new_meta(
            does_keys => 1,
            keys => { foo=>{} },
        );

        is( dies{ $meta->fetch('foo') }, undef, 'known key worked' );
        is( dies{ $meta->fetch('bar') }, undef, 'unknown key worked' );
    };

    subtest require => sub{
        my $meta = new_meta(
            does_keys => 1,
            keys => { foo=>{} },
            require_key_declaration => 1,
        );

        is( dies{ $meta->fetch('foo') }, undef, 'known key worked' );
        isnt( dies{ $meta->fetch('bar') }, undef, 'unknown key failed' );
    };
};

subtest default_key => sub{
    subtest no_key => sub{
        my $meta = new_meta(
            does_keys => 1,
        );

        isnt( dies{ $meta->fetch() }, undef, 'no key failed' );
        is( dies{ $meta->fetch('key') }, undef, 'key worked' );
    };

    subtest key => sub{
        my $meta = new_meta(
            does_keys => 1,
            default_key => 'foo',
        );

        is( dies{ $meta->fetch() }, undef, 'no key worked' );
        is( dies{ $meta->fetch('key') }, undef, 'key worked' );
    };
};

subtest key_argument => sub{
    subtest no_key_argument => sub{
        my $meta = new_meta(
            does_keys => 1,
        );

        $meta->class->can('has')->('foo', is=>'ro');
        my $object = $meta->fetch('bar');

        is( $object->foo(), undef, 'key argument was not set' );
    };

    subtest no_key_argument => sub{
        my $meta = new_meta(
            does_keys => 1,
            key_argument => 'foo',
        );

        $meta->class->can('has')->('foo', is=>'ro');
        my $object = $meta->fetch('bar');

        is( $object->foo(), 'bar', 'key argument was set' );
    };
};

subtest arguments => sub{
    subtest no_keys => sub{
        my $meta = new_meta();
        is( $meta->arguments(), {}, 'empty arguments' );
    };

    subtest keys => sub{
        my $meta = new_meta(
            does_keys => 1,
            keys => { key2 => {foo=>'bar'} },
        );
        is( $meta->arguments('key1'), {}, 'empty arguments' );
        is( $meta->arguments('key2'), {foo=>'bar'}, 'has arguments' );
    };

    subtest key_argument => sub{
        my $meta = new_meta(
            does_keys => 1,
            keys => { bar2 => {foo1=>'bar1'} },
            key_argument => 'foo2',
        );

        $meta->class->can('has')->('foo1', is=>'ro');
        $meta->class->can('has')->('foo2', is=>'ro');
        my $object = $meta->fetch('bar2');

        is( $object->foo1(), 'bar1', 'key argument was set' );
        is( $object->foo2(), 'bar2', 'key argument was set' );
    };
};

subtest multi_meta_guard => sub{
    isnt(
        dies{
            my $meta1 = Vendor::Meta->new( class=>'Vendor::TestGuard' );
            my $meta2 = Vendor::Meta->new( class=>'Vendor::TestGuard' );
        },
        undef,
        'two meta objects with the same class failed',
    );

    is(
        dies{
            my $meta1 = Vendor::Meta->new( class=>'Vendor::TestGuard1' );
            my $meta2 = Vendor::Meta->new( class=>'Vendor::TestGuard2' );
        },
        undef,
        'two meta objects with different classes worked',
    );

    is(
        dies{
            Vendor::Meta->new( class=>'Vendor::TestGuard' );
            Vendor::Meta->new( class=>'Vendor::TestGuard' );
        },
        undef,
        'meta objects were properly weakened',
    );
};

done_testing;

sub new_meta {
    $new_meta_counter++;

    my $meta = Vendor::Meta->new(
        class => "Vendor::Test$new_meta_counter",
        @_,
    );

    Moo->import::into( $meta->class() );

    note $meta->class() . ' created';

    return $meta;
}
