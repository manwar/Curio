package MyApp::Config;

use Types::Standard qw( HashRef );

use Curio;
use strictures 2;

use Exporter qw( import );
our @EXPORT = qw( myapp_config );

does_caching;

my $default_config = {
    foo => 3,
    bar => 'green',
};

has config => (
    is      => 'ro',
    isa     => HashRef,
    default => sub{ $default_config },
);

sub myapp_config {
    return __PACKAGE__->fetch( @_ )->config();
}

1;
