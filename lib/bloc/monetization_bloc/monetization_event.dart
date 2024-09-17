part of 'monetization_bloc.dart';

@immutable
abstract class MonetizationEvent {}

class AddPriceEvent extends MonetizationEvent {
  final double price;
  AddPriceEvent({required this.price});
}

class ResetPriceEvent extends MonetizationEvent {}

class MakeGuideFreeEvent extends MonetizationEvent {}
