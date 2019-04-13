# NAME

Vendor - Procurer of fine resources and services.

# SYNOPSIS

```perl
package MyApp::Service::Cache;

use Vendor;

...
```

# DESCRIPTION

Calling `use Vendor;` is the same as:

```perl
package MyApp::Service::Cache;
use Moo;
with 'Vendor::Role';
Vendor::Meta->new( class=>__PACKAGE__ );
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
Vendor GitHub issue tracker:

[https://github.com/bluefeet/Vendor/issues](https://github.com/bluefeet/Vendor/issues)

# AUTHORS

```
Aran Clary Deltac <bluefeet@gmail.com>
```

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
