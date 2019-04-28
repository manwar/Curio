#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest resource_method_name => sub{
    package CC::rmn;
        use Curio;
        sub resource { {5=>7} }
    package main;

    isnt(
        dies{ CC::rmn->factory->fetch_resource() },
        undef,
        'cannot fetch resource',
    );

    package CC::rmn;
        resource_method_name 'resource';
    package main;

    is(
        CC::rmn->factory->fetch_resource(),
        {5=>7},
        'able to fetch resource',
    );
};

subtest registers_resources => sub{
    package CC::rr;
        use Curio;
        resource_method_name 'resource';
        our $RESOURCE = [2,5];
        sub resource { $RESOURCE }
    package main;

    my $curio = CC::rr->fetch();

    is(
        CC::rr->factory->find_curio( $CC::rr::RESOURCE ),
        undef,
        'resource was not registered',
    );

    package CC::rr;
        registers_resources;
    package main;

    $curio = CC::rr->fetch();

    is(
        CC::rr->factory->find_curio( $CC::rr::RESOURCE ),
        $curio,
        'resource was registered',
    );
};

subtest fetch_returns_resource => sub{
    package CC::frr;
        use Curio;
        sub resource { [8,9] }
    package main;

    isa_ok(
        CC::frr->factory->fetch(),
        ['CC::frr'],
        'fetch returns curio object',
    );

    package CC::frr;
        fetch_returns_resource;
        resource_method_name 'resource';
    package main;

    is(
        CC::frr->factory->fetch(),
        [8,9],
        'fetch returns resource',
    );
};

done_testing;
