import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'monetization_event.dart';

part 'monetization_state.dart';

class MonetizationBloc extends Bloc<MonetizationEvent, MonetizationState> {
  MonetizationBloc() : super(NoMonetizationState()) {
    on<MonetizationEvent>((event, emit) {
      if (event is AddPriceEvent) {
        emit(PriceAddedState(price: event.price));
      } else if (event is MakeGuideFreeEvent) {
        emit(FreeGuideState());
      } else {
        emit(NoMonetizationState());
      }
    });
  }
}
