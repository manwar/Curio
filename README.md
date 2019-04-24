# NAME

Curio - Procurer of fine resources and services.

# SYNOPSIS

Create a Curio class:

```perl
package MyApp::Service::Cache;

use CHI;
use Types::Standard qw( InstanceOf );

use Curio;
use strictures 2;

with 'MooX::BuildArgs';

fetch_method_name 'connect';
export_name 'myapp_cache';
always_export;
does_caching;
cache_per_process;

add_key sessions => (
    driver => 'Memory',
    global => 0,
);

add_key users => (
    driver => 'File',
    root_dir => '/some/path',
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
```

Then use it elsewhere:

```perl
use MyApp::Service::Cache;

my $chi = myapp_cache('sessions')->chi();
```

# DESCRIPTION

Calling `use Curio;` is the same as:

```perl
use Moo;
use Curio::Declare;
use namespace::clean;
with 'Curio::Role';
__PACKAGE__->setup_curio();
```

# EXPORTED FUNCTIONS

## fetch\_method\_name

## export\_name

## always\_export

## does\_caching

## cache\_per\_process

## does\_keys

## allow\_undeclared\_keys

## default\_key

## key\_argument

## add\_key

## alias\_key

# SUPPORT

Please submit bugs and feature requests to the
Curio GitHub issue tracker:

[https://github.com/bluefeet/Curio/issues](https://github.com/bluefeet/Curio/issues)

# AUTHORS

```
Aran Clary Deltac <bluefeet@gmail.com>
```

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
