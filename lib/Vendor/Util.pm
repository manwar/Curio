package Vendor::Util;
our $VERSION = '0.01';

use Carp qw();

use Exporter qw( import );

our @EXPORT_OK = qw(
    croak
);

sub croak {
    local $Carp::Internal{'Vendor'} = 1;
    local $Carp::Internal{'Vendor::Declare'} = 1;
    local $Carp::Internal{'Vendor::Meta'} = 1;
    local $Carp::Internal{'Vendor::Role'} = 1;
    local $Carp::Internal{'Vendor::Util'} = 1;

    return Carp::croak( @_ );
}

1;
