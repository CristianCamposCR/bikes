import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/bike_repository.dart';
import '../cubit/bike_cubit.dart';
import '../cubit/bike_state.dart';
import 'create_bike_screen.dart';

// Vista principal que contiene el BlocProvider para BikeCubit
class BikeListView extends StatelessWidget {
  const BikeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BikeCubit(
        bikeRepository: RepositoryProvider.of<BikeRepository>(context),
      )..getBikes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de bicicletas'),
        ),
        body: const BikeListScreen(),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<BikeCubit>(context),
                      child: const CreateBikeScreen(),
                    ),
                  ),
                );
                if (result == true) {
                  BlocProvider.of<BikeCubit>(context).getBikes();
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}

// Vista que muestra la lista de bicicletas
class BikeListScreen extends StatefulWidget {
  const BikeListScreen({super.key});

  @override
  _BikeListScreenState createState() => _BikeListScreenState();
}

class _BikeListScreenState extends State<BikeListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BikeCubit>(context).getBikes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BikeCubit, BikeState>(
      listener: (context, state) {
        if (state is BikeSuccess) {
          // Trigger a rebuild when the list of bikes is successfully updated
          setState(() {});
        }
      },
      child: BlocBuilder<BikeCubit, BikeState>(
        builder: (context, state) {
          if (state is BikeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BikeSuccess) {
            final bikes = state.bikes;
            return ListView.builder(
              itemCount: bikes.length,
              itemBuilder: (context, index) {
                final bike = bikes[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Marca: ${bike.brand}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Modelo: ${bike.model}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Tipo: ${bike.type}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Color: ${bike.color}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            BlocProvider.of<BikeCubit>(context).deleteBike(bike.id.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is BikeError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Loading bikes...'));
        },
      ),
    );
  }
}
