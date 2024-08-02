import 'package:bikes/data/model/bike_model.dart';
import 'package:bikes/data/repository/bike_repository.dart';
import 'package:bikes/presentation/cubit/bike_state.dart';
import 'package:bloc/bloc.dart';

class BikeCubit extends Cubit<BikeState> {
  final BikeRepository bikeRepository;
  BikeCubit({required this.bikeRepository}) : super(BikeInitial());
  Future<void> createBike(BikeModel bike) async {
    try {
      print('Iniciando createBike');
      emit(BikeLoading());
      await bikeRepository.createBike(bike);

      // Agregar un print para verificar si la función se llama correctamente
      print('Llamando a getBikes');
      final bikesList = await bikeRepository.getBikes();
      print('Lista de bicicletas: $bikesList');

      emit(BikeSuccess(bikes: bikesList));
    } catch (e) {
      print('Error en createBike: $e'); // Agregar un print para depuración de errores
      emit(BikeError(message: e.toString()));
    }
  }

  Future<void> updateBike(BikeModel bike) async {
    try {
      emit(BikeLoading());
      await bikeRepository.updateBike(bike);
      print("onta");
      final bikes = await bikeRepository.getBikes();
      emit(BikeSuccess(bikes: bikes));
    } catch (e) {
      emit(BikeError(message: e.toString()));
    }
  }
  Future<void> deleteBike(String id) async {
    try {
      emit(BikeLoading());
      await bikeRepository.deleteBike(id);
      final bikesList = await bikeRepository.getBikes();
      emit(BikeSuccess(bikes: bikesList));
    } catch (e) {
      emit(BikeError(message: e.toString()));
    }
  }
  Future<void> getBikes() async {
    try {
      print("Iniciando getBikes");
      emit(BikeLoading());

      final bikes = await bikeRepository.getBikes();

      if (bikes == null || bikes.isEmpty) {
        throw Exception('No bikes found');
      }

      print('Lista de bicicletas obtenida: $bikes');
      emit(BikeSuccess(bikes: bikes));
    } catch (e) {
      print('Error en getBikes: $e');
      emit(BikeError(message: e.toString()));
    }
  }
}