import 'package:swesshome/utils/helpers/numbers_helper.dart';

class PriceDomainSearch {
  static Map<int, String> getPriceListFormat(List<int> priceDomain) {
    Map<int, String> priceFormat = <int, String>{};
    for (int i = 0; i < priceDomain.length; i++) {
      priceFormat[i] = NumbersHelper.getMoneyFormat(priceDomain.elementAt(i));
    }

    return priceFormat;
  }

  static Map<int, String> getMinPriceList(
      {int? maxPriceChoose, required Map<int, String> minPrice}) {
    Map<int, String> minPriceFiltered = <int, String>{};
    //print("ghina107 : $maxPriceChoose");
    if (maxPriceChoose == null) {
      return minPrice;
    }
    for (int i = 0; i < minPrice.length; i++) {
      if (maxPriceChoose > i) {
        minPriceFiltered[i] = minPrice[i]!;
      }
    }

    // minPrice.forEach((key, value) {
    //   print('Key = $key : Value = $value');
    // });

    return minPriceFiltered;
  }

  static Map<int, String> getMaxPriceList(
      {int? minPriceChoose, required Map<int, String> maxPrice}) {
    Map<int, String> maxPriceFiltered = <int, String>{};

    if (minPriceChoose == null) {
      return maxPrice;
    }
    for (int i = 0; i < maxPrice.length; i++) {
      if (minPriceChoose < i) {
        maxPriceFiltered[i] = maxPrice[i]!;
      }
    }

    // maxPrice.forEach((key, value) {
    //   print('Key1 = $key : Value1 = $value');
    // });

    return maxPriceFiltered;
  }
}
