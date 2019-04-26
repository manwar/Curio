#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Test2::Require::Module 'CHI' => '0.60';
use Test2::Require::Module 'MooX::BuildArgs' => '0.08';

open( my $fh, '<', 'lib/Curio.pm' );
my $content = do { local $/; <$fh> };
close $fh;

if ($content =~ m{Create a Curio class:\n\n(.+?)\nThen use it elsewhere:\n\n(.+?)\n=head1}s) {
    eval $1;
    eval $2;
}

my $chi = myapp_cache('sessions');
$chi->set('foo' => 62);

is(
    $chi->get('foo'), 62,
    'seems to work',
);

done_testing;
