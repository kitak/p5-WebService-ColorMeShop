package WebService::ColorMeShop;
use 5.008005;
use strict;
use warnings;
use utf8;
use Carp;
use LWP::UserAgent;
use Http::Request;
use JSON;
use Class::Accessor::Lite (
    rw => [ qw/access_token/ ],
);

our $VERSION = "0.01";
our $BASE_URL = 'https://api.shop-pro.jp/v1/';

sub new {
    my ($class, %arg) = @_;

    bless {
        agent => $arg{aagent} || LWP::UserAgent->new(agent => "WebService::ColorMeShop/${VERSION}"),
        access_token => $arg{access_token},
    }, $class;
}

sub _get {
    my $self = shift;
    my $path = shift;
    my %param = @_;

    my $uri = URI->new("${BASE_URL}${path}");
    $uri->query_form(%param);
    my $req = HTTP::Request->new('GET', $uri->as_string,
        [Authorization => "Bearer $self->access_token"],
    );

    my $res = $self->{agent}->request($req);
    $self->_error_hundler($res);
    return decode_json($res->content);
}

sub _put {
    my $self = shift;
    my $path = shift;
    my $param = shift;

    my $uri = URI->new("${BASE_URL}${path}");
    my $req = HTTP::Request->new('POST', $uri->as_string,
        [Authorization => "Bearer $self->access_token",
         "X-Http-Method-Override" => "put",
         "Content-Type"           => "application/json"],
        encode_json($param)
    );

    my $res = $self->{agent}->request($req);
    $self->_error_hundler($res);
    return decode_json($res->content);
}

sub _error_hundler {
    my $self = shift;
    my $res  = shift;

    if (int($res->code / 100) == 4) {
        croak("API error\n${res->content}")
    }
}

sub shop {
    my $self = shift;
    my $res = $self->_get('shop.json');
    return $res->{shop};
}

sub sales_stat {
    my $self = shift;
    my $res = $self->_get('sales/stat.json');
    return $res->{sales_stat};
}

sub sales {
    my $self = shift;
    my %param = @_;
    my $res = $self->_get('sales.json', %param);
    return $res->{sales};
}

sub sale {
    my $self = shift;
    my $id = shift;
    my $res = $self->_get("sales/${id}.json");
    return $res->{sale};
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
    if (exists $param{"sale_deliveries"}) {
        for my $sale_delivery (@{ $param{"sale_deliveries"} }){
            if (exists $sale_delivery->{delivered} && $sale_delivery->{delivered}) {
                $sale_delivery->{delivered} = JSON::true;
            } else {
                $sale_delivery->{delivered} = JSON::false;
            }
        }
    }
    my $res = $self->_put("sales/${id}.json", {
            sale => \%param
    });
    return $res->{sale};
}

sub customers {
    my $self = shift;
    my $res = $self->_get('customers.json');
    return $res->{customers};
}

sub customer {
    my $self = shift;
    my $id = shift;
    my $res = $self->_get("customers/${id}.json");
    return $res->{customer};
}

sub products {
    my $self = shift;
    my %params = @_;
    my $res = $self->_get('products.json', %params);
    return $res->{products};
}

sub product {
    my $self = shift;
    my $id = shift;
    my $res = $self->_get("products/${id}.json");
    return $res->{product};
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
    my $res = $self->_put("sales/${id}.json", {
            product => \%param
    });
    return $res->{sale};
}

sub stocks {
    my $self = shift;
    my %params = @_;
    my $res = $self->_get('stocks.json', %params);
    return $res->{stocks};
}

sub categories {
    my $self = shift;
    my $res = $self->_get('categories.json');
    return $res->{categories};
}

sub payments {
    my $self = shift;
    my $res = $self->_get('payments.json');
    return $res->{payments};
}

sub deliveries {
    my $self = shift;
    my $res = $self->_get('deliveries.json');
    return $res->{deliveries};
}

sub deliveries_date {
    my $self = shift;
    my $res = $self->_get('deliveries/date.json');
    return $res->{delivery_date};
}

sub gifts {
    my $self = shift;
    my $res = $self->_get('gifts.json');
    return $res->{gifts};
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

