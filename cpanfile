requires 'perl' => '5.008001';

requires 'Class::Method::Modifiers' => '2.10';
requires 'Import::Into' => '1.002005';
requires 'Moo' => '2.003000';
requires 'Moo::Role' => '2.003000';
requires 'Types::Common::String' => '1.002001';
requires 'Types::Standard' => '1.002001';
requires 'namespace::clean' => '0.27';
requires 'strictures' => '2.000001';

requires 'Carp';
requires 'Exporter';
requires 'Scalar::Util';

on test => sub {
    requires 'Test2::V0' => '0.000094';
};
