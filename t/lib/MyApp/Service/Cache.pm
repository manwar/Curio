package MyApp::Service::Cache;

use CHI;
use Types::Standard qw( InstanceOf );

use Curio;
use strictures 2;

with 'MooX::BuildArgs';

does_caching;
cache_per_process;

does_registry;
resource_method_name 'chi';
installs_curio_method;

use Exporter qw( import );
our @EXPORT = qw( myapp_cache );

sub myapp_cache {
    return __PACKAGE__->fetch( @_ )->chi();
}

add_key geo_ip => (
    driver => 'Memory',
    global => 0,
);

has chi => (
    is  => 'lazy',
    isa => InstanceOf[ 'CHI::Driver' ],
);

sub _build_chi {
    my ($self) = @_;
    my $chi = CHI->new( %{ $self->build_args() } );
    $self->clear_build_args();
    return $chi;
}

1;
