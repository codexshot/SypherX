part of 'hastags_bloc.dart';

@immutable
abstract class HastagsEvent {}

class AddHashTagsToListEvent extends HastagsEvent {
  final List<HashTags> hashTags;

  AddHashTagsToListEvent({required this.hashTags});
}
class ClearHashTagsEvent extends HastagsEvent {}
