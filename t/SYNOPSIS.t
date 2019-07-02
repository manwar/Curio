#!/usr/bin/env perl
BEGIN { $ENV{PERL_STRICTURES_EXTRA} = 0 }
use strictures 2;
use Test2::V0;

use Test2::Require::Module 'CHI' => '0.60';
use Test2::Require::Module 'MooX::BuildArgs' => '0.08';

use lib 't/lib';
use MyApp::Service::Cache;

my $chi = myapp_cache('geo_ip');
$chi->set('foo' => 62);

is(
    $chi->get('foo'), 62,
    'cache set and get working',
);

is( $chi->curio->chi(), $chi, 'curio method installed and working' );

done_testing;
