#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    sub resource { {5=>7} }
package main;

isnt(
    dies{ $class->factory->fetch_resource() },
    undef,
    'cannot fetch resource',
);

package VT;
    resource_method_name 'resource';
package main;

is(
    $class->factory->fetch_resource(),
    {5=>7},
    'able to fetch resource',
);

done_testing;
