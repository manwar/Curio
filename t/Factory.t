#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use Curio::Factory;

subtest _process_key_args => sub{
    subtest invalid_key => sub{
        my $class = 'CC::invalid_key';
        package CC::invalid_key;
            use Curio;
            add_key 'foo';
        package main;

        is(
            $class->factory->_process_key_arg(['foo']), 'foo',
            'valid key returned key',
        );

        like(
            dies{ $class->factory->_process_key_arg(["foo\n"]) },
            qr{^Invalid key},
            'failed on invalid defined key',
        );

        like(
            dies{ $class->factory->_process_key_arg([undef]) },
            qr{^Invalid key},
            'failed on invalid undef key',
        );
    };

    subtest requires_key => sub{
        my $class = 'CC::requires_key';
        package CC::requires_key;
            use Curio;
            add_key 'foo';
        package main;

        is(
            $class->factory->_process_key_arg(['foo']), 'foo',
            'valid key returned key',
        );

        like(
            dies{ $class->factory->_process_key_arg([]) },
            qr{^No key was passed},
            'failed on key requirement',
        );
    };

    subtest undeclared_key => sub{
        my $class = 'CC::undeclared_key';
        package CC::undeclared_key;
            use Curio;
            add_key 'foo';
        package main;

        is(
            $class->factory->_process_key_arg(['foo']), 'foo',
            'declared key returned key',
        );

        like(
            dies{ $class->factory->_process_key_arg(['bar']) },
            qr{^Undeclared key passed},
            'failed on undeclared key',
        );
    };
};

subtest _store_class_to_factory => sub{
    isnt(
        dies{
            my $factory1 = Curio::Factory->new( class=>'CC::same' );
            my $factory2 = Curio::Factory->new( class=>'CC::same' );
        },
        undef,
        'two factory objects with the same class failed',
    );

    is(
        dies{
            my $factory1 = Curio::Factory->new( class=>'CC::first' );
            my $factory2 = Curio::Factory->new( class=>'CC::second' );
        },
        undef,
        'two factory objects with different classes worked',
    );
};

subtest arguments => sub{
    subtest no_keys => sub{
        my $class = 'CC::no_keys';
        package CC::no_keys;
            use Curio;
        package main;

        is( $class->factory->arguments(), {}, 'empty arguments' );
    };

    subtest keys => sub{
        my $class = 'CC::keys';
        package CC::keys;
            use Curio;
            allow_undeclared_keys;
            add_key key2 => ( foo=>'bar' );
        package main;

        is( $class->factory->arguments('key1'), {}, 'empty arguments' );
        is( $class->factory->arguments('key2'), {foo=>'bar'}, 'has arguments' );
    };

    subtest key_argument => sub{
        my $class = 'CC::key_argument';
        package CC::key_argument;
            use Curio;
            key_argument 'foo2';
            add_key bar2 => ( foo1=>'bar1' );
            has foo1 => ( is=>'ro' );
            has foo2 => ( is=>'ro' );
        package main;

        my $object = $class->fetch('bar2');

        is( $object->foo1(), 'bar1', 'key argument was set' );
        is( $object->foo2(), 'bar2', 'key argument was set' );
    };
};

done_testing;
