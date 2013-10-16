package WebService::ColorMeShop;
use 5.008005;
use strict;
use warnings;
use utf8;
use WebService::Simple;

our $VERSION = "0.01";
our $BASE_URL = 'https://api.shop-pro.jp';

sub new {
  my ($class, %option) = @_;
  my $access_token = $option{'access_token'};
  my $agent = WebService::Simple->new(
    base_url        => $BASE_URL,
    response_parser => 'JSON',
  );
  $agent->add_handler(request_send => sub {
    my ($req, $agent) = @_;
    $req->header('Authorization' => "Bearer ${access_token}");
    return;
  });

  bless {_agent => $agent}, $class;
}

sub shop {
  my $self = shift;
  my $res = $self->{_agent}->get('/v1/shop.json', {});
  return $res->parse_response->{shop};
}

sub sales_stat {
  my $self = shift;
  my $res = $self->{_agent}->get('/v1/sales/stat.json', {});
  return $res->parse_response->{sales_stat};
}

sub sales {
  my $self = shift;
  my $res = $self->{_agent}->get('/v1/sales.json', {});
  return $res->parse_response->{sales};
}

sub categories {
  my $self = shift;
  my $res = $self->{_agent}->get('/v1/categories.json', {});
  return @{ $res->parse_response->{categories} };
}

sub deliveries {
  my $self = shift;
  my $res = $self->{_agent}->get('/v1/deliveries.json', {});
  return $res->parse_response->{deliveries};
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::ColorMeShop - It's new $module

=head1 SYNOPSIS

    use WebService::ColorMeShop;

=head1 DESCRIPTION

WebService::ColorMeShop is ...

=head1 LICENSE

Copyright (C) Keisuke KITA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Keisuke KITA E<lt>kei.kita2501@gmail.comE<gt>

=cut

