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
