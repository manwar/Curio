package Curio::Declare;
our $VERSION = '0.02';

use Package::Stash;
use Curio::Util;

use strictures 2;
use namespace::clean;

my %EXPORTS = (
    resource_method_name   => 'string',
    registers_resources    => 'bool',
    does_caching           => 'bool',
    cache_per_process      => 'bool',
    does_keys              => 'bool',
    allow_undeclared_keys  => 'bool',
    default_key            => 'string',
    key_argument           => 'string',
    default_arguments      => 'hashref',
    add_key                => 'method',
    alias_key              => 'method',
);

sub import {
    my $target = caller;

    my $stash = Package::Stash->new( $target );

    foreach my $sub_name (sort keys %EXPORTS) {
        my $type = $EXPORTS{ $sub_name };
        my $builder = "_build_$type\_sub";
        my $sub = __PACKAGE__->can( $builder )->( $target, $sub_name );
        $sub = subname( $sub_name, $sub );
        $stash->add_symbol( "&$sub_name", $sub );
    }

    return;
}

sub _build_string_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, shift );
        goto &{ $factory->can( $sub_name ) };
    };
}

sub _build_bool_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, (@_ ? shift : 1 ) );
        goto &{ $factory->can( $sub_name ) };
    };
}

sub _build_hashref_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, {@_} );
        goto &{ $factory->can( $sub_name ) };
    };
}

sub _build_method_sub {
    my ($target, $sub_name) = @_;

    return sub{
        my $factory = $target->factory();
        @_ = ( $factory, @_ );
        goto &{ $factory->can( $sub_name ) };
    };
}

1;
__END__

=encoding utf8

=head1 NAME

Curio::Declare - Provider of Curio's declarative interface.

=head1 SYNOPSIS

    use Curio::Declare;
    
    resource_method_name 'name_of_method';
    registers_resources;
    
    does_caching;
    cache_per_process;
    
    does_keys;
    allow_undeclared_keys;
    default_key 'some_key';
    key_argument 'name_of_argument';
    
    default_arguments (
        arg => 'value',
        ...
    );
    
    add_key some_key => (
        arg => 'value',
        ...
    );
    
    alias_key some_alias => 'some_key';

=head1 DESCRIPTION

This module exports a bunch of candy functions as seen used in the
L<Curio/SYNOPSIS>.  These functions set corresponding flags and
fields of the same name in L<Curio::Factory> which are then used
to define the behaviors of Curio classes and objects.

There is a one-to-one match between functions listed here to
arguments and methods listed in L<Curio::Factory>, so these
functions are minimally documented.  Check out the linked
documentation for details.

=head1 EXPORTED FUNCTIONS

=head2 resource_method_name

    resource_method_name 'name_of_method';

See L<Curio::Factory/resource_method_name> for details.

=head2 registers_resources

    registers_resources;
    registers_resources 1; # same as above
    registers_resources 0; # default value

See L<Curio::Factory/registers_resources> for details.

=head2 does_caching

    does_caching;
    does_caching 1; # same as above
    does_caching 0; # default value

See L<Curio::Factory/does_caching> for details.

=head2 cache_per_process

    cache_per_process;
    cache_per_process 1; # same as above
    cache_per_process 0; # default value

See L<Curio::Factory/cache_per_process> for details.

=head2 does_keys

    does_keys;
    does_keys 1; # same as above
    does_keys 0; # default value

See L<Curio::Factory/does_keys> for details.

=head2 allow_undeclared_keys

    allow_undeclared_keys;
    allow_undeclared_keys 1; # same as above
    allow_undeclared_keys 0; # default value

See L<Curio::Factory/allow_undeclared_keys> for details.

=head2 default_key

    default_key 'some_key';

See L<Curio::Factory/default_key> for details.

=head2 key_argument

    key_argument 'name_of_argument';

See L<Curio::Factory/key_argument> for details.

=head2 default_arguments

    default_arguments (
        arg => 'value',
        ...
    );

See L<Curio::Factory/default_arguments> for details.

=head2 add_key

    add_key some_key => (
        arg => 'value',
        ...
    );
    
    add_key 'key_without_args';

See L<Curio::Factory/add_key> for details.

=head2 alias_key

    alias_key some_alias => 'some_key';

See L<Curio::Factory/alias_key> for details.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2019 Aran Clary Deltac

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>.

=cut

