abstract class PriceDomainsEvent{}
class PriceDomainsFetchStarted extends PriceDomainsEvent{
  String type;

  PriceDomainsFetchStarted(this.type);
}