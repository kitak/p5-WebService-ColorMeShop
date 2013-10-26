requires 'perl', '5.008001';
requires 'LWP::UserAgent';
requires 'LWP::Protocol::https';
requires 'JSON';
requires 'HTTP::Request';
requires 'Class::Accessor::Lite';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

