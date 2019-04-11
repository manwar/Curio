#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Import::Into;
use Moo qw();
use Moo::Role qw();
use Scalar::Util qw( blessed );
use Vendor::Meta;

my $new_meta_counter = 0;

subtest basic => sub{
    my $meta = new_meta();

    my $object = $meta->fetch();

    is(
        blessed($object),
        $meta->class(),
        'fetch worked',
    );
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

subtest arguments => sub{
    subtest no_keys => sub{
        my $meta = new_meta();
        is( $meta->arguments(), {}, 'empty arguments' );
    };

    subtest keys => sub{
        my $meta = new_meta(
            require_key_declaration => 0,
        );
        $meta->add_key( 'key2', foo=>'bar' );
        is( $meta->arguments('key1'), {}, 'empty arguments' );
        is( $meta->arguments('key2'), {foo=>'bar'}, 'has arguments' );
    };

    subtest key_argument => sub{
        my $meta = new_meta(
            key_argument => 'foo2',
        );
        $meta->add_key( 'bar2', foo1=>'bar1' );

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
};

done_testing;

sub new_meta {
    $new_meta_counter++;

    my $meta = Vendor::Meta->new(
        class => "Vendor::Test$new_meta_counter",
        @_,
    );

    Moo->import::into( $meta->class() );

    Moo::Role->apply_roles_to_package(
        $meta->class(),
        'Vendor::Role',
    );

    note $meta->class() . ' created';

    return $meta;
}
