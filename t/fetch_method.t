#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest default => sub{
    my $class = 'CC::default';
    package CC::default;
        use Curio;
    package main;

    ok( $class->can('fetch'), 'fetch installed' );
};

subtest custom => sub{
    my $class = 'CC::custom';
    package CC::custom;
        use Curio;
        fetch_method_name 'connect';
    package main;

    ok( !$class->can('fetch'), 'fetch not installed' );
    ok( $class->can('connect'), 'connect installed' );

    $class->factory->fetch_method_name('foo');
    note 'switched fetch_method_name to foo';

    ok( !$class->can('fetch'), 'fetch not installed' );
    ok( !$class->can('connect'), 'connect not installed' );
    ok( $class->can('foo'), 'foo installed' );
};

done_testing;
