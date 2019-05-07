#!/usr/bin/env perl
BEGIN { $ENV{PERL_STRICTURES_EXTRA} = 0 }
use strictures 2;
use Test2::V0;

use Test2::Require::Module 'CHI' => '0.60';
use Test2::Require::Module 'MooX::BuildArgs' => '0.08';

open( my $fh, '<', 'lib/Curio.pm' );
my $content = do { local $/; <$fh> };
close $fh;

if ($content =~ m{=head1 SYNOPSIS\n\n\S.+?:\n\n(.+?)\n\S.+?:\n\n(.+?)\n=head1}s) {
    my @blocks = ($1, $2);
    my $count = 0;
    foreach my $block (@blocks) {
        $count++;
        local $@;
        my $ok = eval "$block; 1";
        die "Failed to run SYNOPSIS block #$count:\n$@" if !$ok;
    }
}

my $chi = myapp_cache('sessions');
$chi->set('foo' => 62);

is(
    $chi->get('foo'), 62,
    'seems to work',
);

done_testing;
