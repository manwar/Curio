package Curio::Util;
our $VERSION = '0.01';

use Carp qw();

use strictures 2;
use namespace::clean;

use Exporter qw( import );

our @EXPORT = qw(
    croak
    subname
);

sub croak {
    local $Carp::Internal{'Curio'} = 1;
    local $Carp::Internal{'Curio::Meta'} = 1;
    local $Carp::Internal{'Curio::Role'} = 1;
    local $Carp::Internal{'Curio::Util'} = 1;

    return Carp::croak( @_ );
}

BEGIN {
    if (eval{ require Sub::Name; 1 }) {
        *subname = \&Sub::Name::subname;
    }
    elsif (eval{ require Sub::Util; 1 } and defined &Sub::Util::set_subname) {
        *subname = \&Sub::Util::set_subname;
    }
    else {
        *subname = sub{ return $_[1] };
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Curio::Util - Internal utility functions.

=head1 EXPORTED FUNCTIONS

=head2 croak

    croak '...';

Internalizes all the Curio modules and then calls L<Carp>'s C<croak()>
so that any stack traces start outside of the Curio namespace.

=head2 subname

    my $sub = subname( $name, sub{ ... } );

Calls L<Sub::Name/subname> or L<Sub::Util/set_subname>, if either
is installed, otherwise the unnamed code ref is returned.

=head1 SUPPORT

See L<Curio/SUPPORT>.

=head1 AUTHORS

See L<Curio/AUTHORS>.

=head1 LICENSE

See L<Curio/LICENSE>.

=cut

