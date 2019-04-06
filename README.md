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
use Vendor::Declare;

use Moo;
use strictures 2;
use namespace::clean;

with 'Vendor::Role';
```

This can be adjusted by setting import flags, as in:

```perl
use Vendor qw( no_strictures );
```

Available flags are `no_declare` which disables [Vendor::Declare](https://metacpan.org/pod/Vendor::Declare),
`no_strictures` which disables [strictures](https://metacpan.org/pod/strictures), and `no_clean` which
disables [namespace::clean](https://metacpan.org/pod/namespace::clean).

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
