#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    sub resource { [8,9] }
package main;

isa_ok(
    $class->factory->fetch(),
    ['VT'],
    'fetch returns curio object',
);

package VT;
    fetch_returns_resource;
    resource_method_name 'resource';
package main;

is(
    $class->factory->fetch(),
    [8,9],
    'fetch returns resource',
);

done_testing;
