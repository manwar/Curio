#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest invalid_key => sub{
    my $class = 'CC::invalid_key';
    package CC::invalid_key;
        use Curio;
        add_key 'foo';
    package main;

    is(
        $class->factory->_process_key_arg('foo'), 'foo',
        'valid key returned key',
    );

    like(
        dies{ $class->factory->_process_key_arg("foo\n") },
        qr{^Invalid key},
        'failed on invalid defined key',
    );

    like(
        dies{ $class->factory->_process_key_arg(undef) },
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
        $class->factory->_process_key_arg('foo'), 'foo',
        'valid key returned key',
    );

    like(
        dies{ $class->factory->_process_key_arg() },
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
        $class->factory->_process_key_arg('foo'), 'foo',
        'declared key returned key',
    );

    like(
        dies{ $class->factory->_process_key_arg('bar') },
        qr{^Undeclared key passed},
        'failed on undeclared key',
    );
};

subtest too_many_arguments => sub{
    subtest no_keys => sub{
        my $class = 'CC::too_many_arguments_no_keys';
        package CC::too_many_arguments_no_keys;
            use Curio;
        package main;

        is(
            $class->factory->_process_key_arg(), undef,
            'no key returned undef',
        );

        like(
            dies{ $class->factory->_process_key_arg('foo') },
            qr{^Too many arguments},
            'failed on too many arguments',
        );
    };

    subtest keys => sub{
        my $class = 'CC::too_many_arguments_keys';
        package CC::too_many_arguments_keys;
            use Curio;
            add_key 'foo';
        package main;

        is(
            $class->factory->_process_key_arg('foo'), 'foo',
            'key returned key',
        );

        like(
            dies{ $class->factory->_process_key_arg('foo', 'bar') },
            qr{^Too many arguments},
            'failed on too many arguments',
        );
    };
};

done_testing;
