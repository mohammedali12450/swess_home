import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/data/providers/price_domains_provider.dart';

class PriceDomainsRepository {
  PriceDomainProvider priceDomainProvider = PriceDomainProvider();

  Future<List<PriceDomain>> fetchData() async {
    Response response = await priceDomainProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var priceDomainsJson = jsonDecode(response.toString())['data'] as List;
    List<PriceDomain> priceDomains =
    priceDomainsJson.map<PriceDomain>((e) => PriceDomain.fromJson(e)).toList();
    return priceDomains;
  }
}
