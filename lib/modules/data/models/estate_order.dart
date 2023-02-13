import 'package:swesshome/modules/data/models/price_domain.dart';

import 'estate.dart';
import 'estate_offer_type.dart';
import 'estate_type.dart';
import 'location.dart';

class EstateOrder {
  // Receive state :
  int? id;

  EstateType? estateType;

  EstateOfferType? estateOfferType;

  Location? location;

  PriceDomain? priceDomain;

  String? createdAt;

  List<Estate>? candidatesEstates;

  // Send state :

  int? locationId;

  int? estateTypeId;

  int? estateOfferId;

  int? priceMin;

  int? priceMax;

  // Both states:

  String description;

  EstateOrder(
      {this.id,
      this.estateType,
      this.estateOfferType,
      this.priceDomain,
      required this.description,
      this.createdAt,
      this.location,
      this.candidatesEstates,
      this.estateTypeId,
      this.estateOfferId,
      this.locationId,
      this.priceMax,
      this.priceMin});

  factory EstateOrder.fromJson(json) {
    List<Estate>? candidatesEstates;
    if (json["office_candidates"] != null) {
      var candidates = json["office_candidates"]["data"] as List;
      for (var element in candidates) {
        if (element["estate"] != null) {
          candidatesEstates ??= [];
          candidatesEstates.add(Estate.fromJson(element["estate"]));
        }
      }
    }

    return EstateOrder(
      id: json["id"],
      estateType: EstateType.fromJson(json["estate_type"]),
      estateOfferType: EstateOfferType.fromJson(json["estate_offer_type"]),
      priceDomain: (json["price_domain"] != null)
          ? PriceDomain.fromJson(json["price_domain"])
          : null,
      description: json["notes"],
      createdAt: json["created_at"],
      location: Location.fromJson(json["location"]),
      candidatesEstates: candidatesEstates,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["estate_type_id"] = estateTypeId;
    map["estate_offer_type_id"] = estateOfferId;
    map["location_id"] = locationId;
    map["min_price"] = priceMin;
    map["max_price"] = priceMax;
    map["notes"] = description;
    return map;
  }
}
