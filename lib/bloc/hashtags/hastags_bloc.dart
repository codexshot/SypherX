
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/hash_tag_model.dart';

part 'hastags_event.dart';

part 'hastags_state.dart';

class HastagsBloc extends Bloc<HastagsEvent, HastagsState> {
  HastagsBloc() : super(const HastagsState(hashTags: [])) {
    on<HastagsEvent>((event, emit) {
      if (event is AddHashTagsToListEvent) {
        final List<HashTags> list = List.from(event.hashTags);
        emit(state.copyWith(hashTags: list));
      }
      else if(event is ClearHashTagsEvent){
        emit(state.copyWith(hashTags: []));
      }
    });
  }
}
