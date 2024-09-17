part of 'draft_bloc.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();
}

class SaveDraftEvent extends DraftEvent {
  final BuildContext context;
  const SaveDraftEvent( this.context);

  @override
  List<Object> get props => [context];
}
class GetAllSavedDraftEvent extends DraftEvent{
  final BuildContext context;
  const GetAllSavedDraftEvent(this.context);

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}


