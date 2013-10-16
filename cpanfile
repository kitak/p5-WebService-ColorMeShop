requires 'perl', '5.008001';
requires 'WebService::Simple';
requires 'LWP::Protocol::https';
requires 'JSON';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

