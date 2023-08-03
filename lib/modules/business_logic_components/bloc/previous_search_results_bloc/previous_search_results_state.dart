part of 'previous_search_results_bloc.dart';

@immutable
abstract class PreviousSearchResultsState {}

class PreviousSearchResultsFetchComplete extends PreviousSearchResultsState{
  final List<Zone> zones;

  PreviousSearchResultsFetchComplete({required this.zones});

}
class PreviousSearchResultsFetchError extends PreviousSearchResultsState{}
class PreviousSearchResultsFetchProgress extends PreviousSearchResultsState{}
class PreviousSearchResultsFetchNone extends PreviousSearchResultsState{}
