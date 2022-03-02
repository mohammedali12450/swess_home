abstract class VisitState {}

class VisitError extends VisitState {
  String error;

  VisitError({required this.error});
}

class VisitProgress extends VisitState {}

class VisitComplete extends VisitState {}

class VisitNone extends VisitState {}
