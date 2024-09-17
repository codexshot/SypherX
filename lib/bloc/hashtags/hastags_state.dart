part of 'hastags_bloc.dart';


class HastagsState extends Equatable {
  final List<HashTags> hashTags;

  @override
  // TODO: implement props
  List<Object?> get props => [hashTags];

  HastagsState copyWith({
    List<HashTags>? hashTags,
  }) {
    return HastagsState(
      hashTags: hashTags ?? this.hashTags,
    );
  }

  const HastagsState({
    required this.hashTags,
  });
}
