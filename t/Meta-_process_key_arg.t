#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

subtest invalid_key => sub{
    my $class = 'VT::invalid_key';
    package VT::invalid_key;
        use Vendor;
        does_keys;
    package main;

    is(
        $class->vendor->_process_key_arg('foo'), 'foo',
        'valid key returned key',
    );

    like(
        dies{ $class->vendor->_process_key_arg("foo\n") },
        qr{^Invalid key},
        'failed on invalid defined key',
    );

    like(
        dies{ $class->vendor->_process_key_arg(undef) },
        qr{^Invalid key},
        'failed on invalid undef key',
    );
};

subtest requires_key => sub{
    my $class = 'VT::requires_key';
    package VT::requires_key;
        use Vendor;
        does_keys;
    package main;

    is(
        $class->vendor->_process_key_arg('foo'), 'foo',
        'valid key returned key',
    );

    like(
        dies{ $class->vendor->_process_key_arg() },
        qr{^A key is required},
        'failed on key requirement',
    );
};

subtest undeclared_key => sub{
    my $class = 'VT::undeclared_key';
    package VT::undeclared_key;
        use Vendor;
        add_key 'foo';
    package main;

    is(
        $class->vendor->_process_key_arg('foo'), 'foo',
        'declared key returned key',
    );

    like(
        dies{ $class->vendor->_process_key_arg('bar') },
        qr{^Key is not declared},
        'failed on undeclared key',
    );
};

subtest too_many_arguments => sub{
    subtest no_keys => sub{
        my $class = 'VT::too_many_arguments_no_keys';
        package VT::too_many_arguments_no_keys;
            use Vendor;
        package main;

        is(
            $class->vendor->_process_key_arg(), undef,
            'no key returned undef',
        );

        like(
            dies{ $class->vendor->_process_key_arg('foo') },
            qr{^Too many arguments},
            'failed on too many arguments',
        );
    };

    subtest keys => sub{
        my $class = 'VT::too_many_arguments_keys';
        package VT::too_many_arguments_keys;
            use Vendor;
            does_keys;
        package main;

        is(
            $class->vendor->_process_key_arg('foo'), 'foo',
            'key returned key',
        );

        like(
            dies{ $class->vendor->_process_key_arg('foo', 'bar') },
            qr{^Too many arguments},
            'failed on too many arguments',
        );
    };
};

done_testing;
