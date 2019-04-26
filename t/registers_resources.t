#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

package CC;
    use Curio;
    resource_method_name 'resource';
    our $RESOURCE = [2,5];
    sub resource { $RESOURCE }
package main;

my $curio = CC->fetch();

is(
    CC->factory->find_curio( $CC::RESOURCE ),
    undef,
    'resource was not registered',
);

package CC;
    registers_resources;
package main;

$curio = CC->fetch();

is(
    CC->factory->find_curio( $CC::RESOURCE ),
    $curio,
    'resource was registered',
);

done_testing;
