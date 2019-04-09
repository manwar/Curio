#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

use Import::Into;
use Moo qw();
use Moo::Role qw();
use Vendor::Meta;

my $new_class_counter = 0;

subtest basic => sub{
    my $class = new_class(
        fetch_method_name => 'connect',
    );

    is(
        $class->vendor->class(),
        $class,
        'vendor was installed and works',
    );

    is(
        $class->vendor->fetch_method_name(),
        'connect',
        'argument to install_vendor made it to the meta',
    );
};

subtest export => sub{
    subtest no_always => sub{
        my $class = new_class(
            export_name => 'get_foo',
        );

        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import();
        isnt( dies{ get_foo() }, undef, 'export not yet installed' );
        $class->import('get_foo');
        is( dies{ get_foo() }, undef, 'export installed' );

        my $object = get_foo();
        isa_ok( $object, $class );

        $class->vendor->export_name( 'get_foo2' );
        $class->import('get_foo2');
        ok( !$class->can('get_foo'), 'old export removed' );
        ok( $class->can('get_foo2'), 'new export installed' );
    };

    subtest always => sub{
        my $class = new_class(
            export_name => 'get_bar',
            always_export => 1,
        );

        isnt( dies{ get_bar() }, undef, 'export not yet installed' );
        $class->import();
        is( dies{ get_bar() }, undef, 'export installed' );
    };
};

done_testing;

sub new_class {
    $new_class_counter++;

    my $class = "Vendor::Test$new_class_counter";

    Moo->import::into( $class );

    Moo::Role->apply_roles_to_package(
        $class,
        'Vendor::Role',
    );

    Vendor::Meta->new(
        class => $class,
        @_,
    );

    note "$class created";

    return $class;
}
