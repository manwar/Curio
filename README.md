# NAME

Curio - Procurer of fine resources and services.

# SYNOPSIS

```perl
package MyApp::Service::Cache;

use Curio;

...
```

# DESCRIPTION

Calling `use Curio;` is the same as:

```perl
package MyApp::Service::Cache;
use Moo;
with 'Curio::Role';
Curio::Meta->new( class=>__PACKAGE__ );
```

Also, all the ["EXPORTED FUNCTIONS"](#exported-functions) are exported to the calling
package.

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
