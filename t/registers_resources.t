#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

my $class = 'VT';
package VT;
    use Curio;
    resource_method_name 'resource';
    our $RESOURCE = [2,5];
    sub resource { $RESOURCE }
package main;

my $curio = VT->fetch();

is(
    $class->factory->find_curio( $VT::RESOURCE ),
    undef,
    'resource was not registered',
);

package VT;
    registers_resources;
package main;

$curio = VT->fetch();

is(
    $class->factory->find_curio( $VT::RESOURCE ),
    $curio,
    'resource was registered',
);

done_testing;
