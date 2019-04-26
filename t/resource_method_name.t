#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

package CC;
    use Curio;
    sub resource { {5=>7} }
package main;

isnt(
    dies{ CC->factory->fetch_resource() },
    undef,
    'cannot fetch resource',
);

package CC;
    resource_method_name 'resource';
package main;

is(
    CC->factory->fetch_resource(),
    {5=>7},
    'able to fetch resource',
);

done_testing;
