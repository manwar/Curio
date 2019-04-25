#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Curio::Factory;

isnt(
    dies{
        my $factory1 = Curio::Factory->new( class=>'VT::same' );
        my $factory2 = Curio::Factory->new( class=>'VT::same' );
    },
    undef,
    'two factory objects with the same class failed',
);

is(
    dies{
        my $factory1 = Curio::Factory->new( class=>'VT::first' );
        my $factory2 = Curio::Factory->new( class=>'VT::second' );
    },
    undef,
    'two factory objects with different classes worked',
);

done_testing;
