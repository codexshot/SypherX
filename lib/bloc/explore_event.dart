part of 'explore_bloc.dart';

@immutable
abstract class ExploreEvent {}

class ExploreChooseVideoEvent extends ExploreEvent {
  final BuildContext context;

  ExploreChooseVideoEvent(this.context);
}

class InitializeCollabByTypeEvent extends ExploreEvent {
  final String collabJson;
  final BuildContext context;

  InitializeCollabByTypeEvent(this.collabJson, this.context);
}

class ResetEvent extends ExploreEvent {
  ResetEvent();
}
