package WebService::ColorMeShop;
use 5.008005;
use strict;
use warnings;
use utf8;
use JSON;
use WebService::Simple;

our $VERSION = "0.01";
our $BASE_URL = 'https://api.shop-pro.jp/v1/';

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
  my $res = $self->{_agent}->get('shop.json', {});
  return %{ $res->parse_response->{shop} };
}

sub sales_stat {
  my $self = shift;
  my $res = $self->{_agent}->get('sales/stat.json', {});
  return %{ $res->parse_response->{sales_stat} };
}

sub sales {
  my $self = shift;
  my %param = @_;
  my $res = $self->{_agent}->get('sales.json', %param);
  return @{ $res->parse_response->{sales} };
}

sub sale {
  my $self = shift;
  my $id = shift;
  my $res = $self->{_agent}->get("sales/${id}.json", {});
  return %{ $res->parse_response->{sale} };
}

sub update_sale {
  my $self = shift;
  my $id = shift;
  my %param = @_;

  if (exists $param{paid} && $param{paid}) {
    $param{paid} = JSON::true;
  } elsif (exists $param{paid} && !$param{paid}) {
    $param{paid} = JSON::false;
  }
  for my $sale_delivery (@{ $param{"sale_deliveries"} }){
    if (exists $sale_delivery->{delivered} && $sale_delivery->{delivered}) {
      $sale_delivery->{delivered} = JSON::true;
    } else {
      $sale_delivery->{delivered} = JSON::false;
    }
  }
  my $res = $self->{_agent}->get("sales/${id}.json", {
    sale => \%param
  }, "X-Http-Method-Override" => "put",
     "Content-Type"           => "application/json");
  return %{ $res->parse_response->{sale} };
}

sub customers {
  my $self = shift;
  my $res = $self->{_agent}->get('customers.json');
  return @{ $res->parse_response->{customers} };
}

sub customer {
  my $self = shift;
  my $id = shift;
  my $res = $self->{_agent}->get("customers/${id}.json");
  return %{ $res->parse_response->{customer} };
}

sub products {
  my $self = shift;
  my %params = @_;
  my $res = $self->{_agent}->get('products.json', %params);
  return @{ $res->parse_response->{products} };
}

sub product {
  my $self = shift;
  my $id = shift;
  my $res = $self->{_agent}->get("products/${id}.json");
  return %{ $res->parse_response->{product} };
}

sub update_product {
  my $self = shift;
  my $id = shift;
  my %param = @_;

  if (exists $param{stock_managed} && $param{stock_manages}) {
    $param{paid} = JSON::true;
  } else {
    $param{paid} = JSON::false;
  }
  my $res = $self->{_agent}->post("sales/${id}.json", {
    product => \%param
  }, "X-Http-Method-Override" => "put");
  return %{ $res->parse_response->{sale} };
}

sub stocks {
  my $self = shift;
  my %params = @_;
  my $res = $self->{_agent}->get('stocks.json', %params);
  return @{ $res->parse_response->{stocks} };
}

sub categories {
  my $self = shift;
  my $res = $self->{_agent}->get('categories.json');
  return @{ $res->parse_response->{categories} };
}

sub payments {
  my $self = shift;
  my $res = $self->{_agent}->get('payments.json');
  return @{ $res->parse_response->{payments} };
}

sub deliveries {
  my $self = shift;
  my $res = $self->{_agent}->get('deliveries.json');
  return @{ $res->parse_response->{deliveries} };
}

sub deliveries_date {
  my $self = shift;
  my $res = $self->{_agent}->get('deliveries/date.json');
  return %{ $res->parse_response->{delivery_date} };
}

sub gifts {
  my $self = shift;
  my $res = $self->{_agent}->get('gifts.json');
  return @{ $res->parse_response->{gifts} };
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::ColorMeShop - A Perl interface to ColorMeShop API

=head1 SYNOPSIS

    use WebService::ColorMeShop;

    my $colorme = WebService::ColorMeShop->new(
        access_token => 'YOUR ACCESS TOKEN'
    )

    # retrieve shop data
    my $shop = $colorme->shop;

    # retrieve categories data
    my $categories = $colorme->categories;

=head1 DESCRIPTION

ColorMeShop is a website ... WebService::ColorMeShop provides
 an easy way to communicate with it using its API.

=head1 METHODS

=head2 new ( I<%args> )

=over 4

    my $colorme = WebService::ColorMeShop->new(
        access_token => 'YOUR SECRET TOKEN'
    )

This method creates and returns a new WebService::ColorMeShop 
object.

=back

=head2 shop

=over 4

    $colorme->shop

This method retrieves the data of the shop and returns a hash to them.

=head1 LICENSE

Copyright (C) Keisuke KITA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Keisuke KITA E<lt>kei.kita2501@gmail.comE<gt>

=cut

