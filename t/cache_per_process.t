#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest no_per_process => sub{
    my $class = 'CC::no_per_process';
    package CC::no_per_process;
        use Curio;
        does_caching;
    package main;

    is(
        $class->factory->_fixup_cache_key(),
        '__UNDEF_KEY__',
        'cache key has no process info',
    );
};

subtest per_process => sub{
    my $class = 'CC::per_process';
    package CC::per_process;
        use Curio;
        does_caching;
        cache_per_process;
    package main;

    my $expected_key = "__UNDEF_KEY__-$$";
    $expected_key .= threads->tid() if $INC{'threads.pm'};

    is(
        $class->factory->_fixup_cache_key(),
        $expected_key,
        'cache key has process info',
    );
};

done_testing;
