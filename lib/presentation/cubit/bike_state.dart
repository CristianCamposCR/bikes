import 'package:equatable/equatable.dart';
import '../../data/model/bike_model.dart';

abstract class BikeState extends Equatable {
  @override
  List<Object> get props => [];
}

class BikeInitial extends BikeState {}

class BikeLoading extends BikeState {}


class BikeSuccess extends BikeState {
  final List<BikeModel> bikes;

  BikeSuccess({required this.bikes});

  @override
  List<Object> get props => [bikes];
}

class BikeError extends BikeState {
  final String message;

  BikeError({required this.message});

  @override
  List<Object> get props => [message];
}

