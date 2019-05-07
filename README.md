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

use Exporter qw( import );
our @EXPORT = qw( myapp_cache );

does_caching;
cache_per_process;

add_key sessions => (
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

sub myapp_cache {
    return __PACKAGE__->fetch( @_ )->chi();
}
```

Then use your new Curio class elsewhere:

```perl
use MyApp::Service::Cache;

my $chi = myapp_cache('sessions');
```

# DESCRIPTION

Curio is a library for creating [Moo](https://metacpan.org/pod/Moo) classes which encapsulate the
construction and retrieval of arbitrary objects.  As a user of this
library you've got two jobs.

First, you create classes in your application which use Curio.  You'll
have one class for each type of resource you want available to your
application as a whole.  So, for example, you'd have a Curio class for
your database connections, another for your graphite client, and perhaps
a third for your AWS IAM clients.

Your second job is to then modify your application to use your Curio
classes.  If your application uses an existing framework, such as
[Catalyst](https://metacpan.org/pod/Catalyst) or [Dancer2](https://metacpan.org/pod/Dancer2), then you'll want to take a look at the
available ["INTEGRATIONS"](#integrations).

Keep in mind that Curio doesn't just have to be used for connections
to remote services.  It can be used to make singleton classes, as a
ready to go generic object factory, a place to put global application
context information, etc.

# BOILERPLATE

Near the top of most Curio classes is this line:

```perl
use Curio;
```

Which is exactly the same as:

```perl
use Moo;
use Curio::Declare;
use namespace::clean;
with 'Curio::Role';
__PACKAGE__->initialize();
```

If you're not into the declarative interface, or have some
other reason to switch around this boilerplate, you may copy the
above and modify to fit your needs rather than using this module
directly.

Read more about [Moo](https://metacpan.org/pod/Moo) and [namespace::clean](https://metacpan.org/pod/namespace::clean) if you are not
familiar with them.

# MOTIVATION

The main drive behind using Curio is threefold.

1. To avoid the extra complexity of passing around references of shared
resources, such as connections to services.  Often times you'll see
code which passes a connection to a function, which then passes that
on to another function, which then creates an object with the connection
passed as an argument, etc.  This is what is being avoided; its a messy
way to writer code and prone to error.
2. To have a central place to put object creation logic.  When there is
no central place to put this sort of logic it tends to be haphazardly
copy-pasted and sprinkled all over a codebase making it difficult to
find and change.
3. To not be tied into any single framework as is commonly done today.
There is no reason this sort of logic needs to be framework dependent,
and once it is it makes all sorts of things more difficult, such as
migrating frameworks and writing in-house libraries that are framework
independent.  Yes, Curio is a framework itself, but it is a very slim
framework which gets out of your way quickly and is designed for this
one purpose.

These challenges can be solved by Curio and, by resolving them,
your applications will be more robust and resilient to change.

# INTEGRATIONS

Curio has not yet been integrated with any existing frameworks.  A
[Catalyst](https://metacpan.org/pod/Catalyst) model will be available quite soon though.

If you don't see your framework here ([Dancer2](https://metacpan.org/pod/Dancer2) I'm looking at
you) then head down to ["SUPPORT"](#support) and open up a ticket and lets
get started on making one.

# SEE ALSO

It is hard to find anything out there on CPAN which is similar to
Curio.

There is [Bread::Board](https://metacpan.org/pod/Bread::Board) but it has a very different take and solves
different problems.

[Catalyst](https://metacpan.org/pod/Catalyst) has its models, but that doesn't really apply since they
are baked into the framework.  The idea is similar though.

Someone started something that look vaguely similar called [Trinket](https://metacpan.org/pod/Trinket)
(this was one of the names I was considering and found it by accident)
but it never got any love since initial release in 2012 and is incomplete.

Since Curio can do singletons, you may want to check out
[MooX::Singleton](https://metacpan.org/pod/MooX::Singleton) and [MooseX::Singleton](https://metacpan.org/pod/MooseX::Singleton).

# SUPPORT

Please submit bugs and feature requests to the
Curio GitHub issue tracker:

[https://github.com/bluefeet/Curio/issues](https://github.com/bluefeet/Curio/issues)

# AUTHORS

```
Aran Clary Deltac <bluefeet@gmail.com>
```

# ACKNOWLEDGEMENTS

Thanks to [ZipRecruiter](https://www.ziprecruiter.com/)
for encouraging their employees to contribute back to the open
source ecosystem.  Without their dedication to quality software
development this distribution would not exist.

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
