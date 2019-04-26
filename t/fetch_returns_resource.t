#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

package CC;
    use Curio;
    sub resource { [8,9] }
package main;

isa_ok(
    CC->factory->fetch(),
    ['CC'],
    'fetch returns curio object',
);

package CC;
    fetch_returns_resource;
    resource_method_name 'resource';
package main;

is(
    CC->factory->fetch(),
    [8,9],
    'fetch returns resource',
);

done_testing;
