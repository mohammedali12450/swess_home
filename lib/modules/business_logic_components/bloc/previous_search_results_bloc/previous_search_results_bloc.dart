import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../data/models/previous_search_zone.dart';
import '../../../data/repositories/previous_search_results_repository.dart';

part 'previous_search_results_event.dart';
part 'previous_search_results_state.dart';

class PreviousSearchResultsBloc extends Bloc<PreviousSearchResultsEvent, PreviousSearchResultsState> {
  PreviousSearchResultsRepository previousSearchResultsRepository=PreviousSearchResultsRepository();
  PreviousSearchResultsBloc() : super(PreviousSearchResultsFetchNone()) {
    on<PreviousSearchResultsFetchStarted>((event, emit) async{
      {
        emit(PreviousSearchResultsFetchProgress());
        try {
          SearchResults searchResults = await previousSearchResultsRepository.fetchData();
          emit(PreviousSearchResultsFetchComplete(searchResults: searchResults));
        } catch (e, stack) {
          debugPrint(e.toString());
          debugPrint(stack.toString());
        }
      }
    });
  }
}
