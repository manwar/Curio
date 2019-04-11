#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Vendor::Meta;

isnt(
    dies{
        my $meta1 = Vendor::Meta->new( class=>'VT::same' );
        my $meta2 = Vendor::Meta->new( class=>'VT::same' );
    },
    undef,
    'two meta objects with the same class failed',
);

is(
    dies{
        my $meta1 = Vendor::Meta->new( class=>'VT::first' );
        my $meta2 = Vendor::Meta->new( class=>'VT::second' );
    },
    undef,
    'two meta objects with different classes worked',
);

done_testing;
