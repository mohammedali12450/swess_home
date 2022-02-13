import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_state.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/data/repositories/price_domains_repository.dart';

class PriceDomainsBloc extends Bloc<PriceDomainsEvent, PriceDomainsState> {
  PriceDomainsRepository priceDomainsRepository;
  List<PriceDomain>? priceDomains;



  PriceDomainsBloc(this.priceDomainsRepository) : super(PriceDomainsFetchNone()) {
    on<PriceDomainsFetchStarted>((event, emit) async {
      emit(PriceDomainsFetchProgress());
      try {
        priceDomains = await priceDomainsRepository.fetchData();
        emit(PriceDomainsFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
