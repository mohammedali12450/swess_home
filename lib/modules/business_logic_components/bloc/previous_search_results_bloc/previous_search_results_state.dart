part of 'previous_search_results_bloc.dart';

@immutable
abstract class PreviousSearchResultsState {}

class PreviousSearchResultsFetchComplete extends PreviousSearchResultsState{
  final SearchResults searchResults;

  PreviousSearchResultsFetchComplete({required this.searchResults});

}
class PreviousSearchResultsFetchError extends PreviousSearchResultsState{}
class PreviousSearchResultsFetchProgress extends PreviousSearchResultsState{}
class PreviousSearchResultsFetchNone extends PreviousSearchResultsState{}
