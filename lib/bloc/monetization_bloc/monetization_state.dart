part of 'monetization_bloc.dart';

@immutable
abstract class MonetizationState extends Equatable {}

class NoMonetizationState extends MonetizationState {
  @override
  List<Object?> get props => [];
}

class PriceAddedState extends MonetizationState {
  final double price;

  PriceAddedState({required this.price});

  @override
  List<Object?> get props => [price];
}

class FreeGuideState extends MonetizationState {
  @override
  List<Object?> get props => [];
}
