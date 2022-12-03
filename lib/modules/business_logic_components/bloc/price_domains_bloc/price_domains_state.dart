import '../../../data/models/price_domain.dart';

abstract class PriceDomainsState{}

class PriceDomainsFetchComplete extends PriceDomainsState{
  PriceDomain? priceDomains;

  PriceDomainsFetchComplete(this.priceDomains);
}
class PriceDomainsFetchError extends PriceDomainsState{}
class PriceDomainsFetchProgress extends PriceDomainsState{}
class PriceDomainsFetchNone extends PriceDomainsState{}