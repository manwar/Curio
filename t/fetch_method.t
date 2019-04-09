#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest default => sub{
    {
        package VT::default;
        use Vendor;
    }

    can_ok( 'VT::default', 'fetch' );
    ok( VT::default->can('fetch'), 'fetch installed' );
};

subtest custom => sub{
    {
        package VT::custom;
        use Vendor;
        fetch_method_name 'connect';
    }

    ok( !VT::custom->can('fetch'), 'fetch not installed' );
    ok( VT::custom->can('connect'), 'connect installed' );

    VT::custom->vendor->fetch_method_name('foo');
    note 'switched fetch_method_name to foo';

    ok( !VT::custom->can('fetch'), 'fetch not installed' );
    ok( !VT::custom->can('connect'), 'connect not installed' );
    ok( VT::custom->can('foo'), 'foo installed' );
};

done_testing;
