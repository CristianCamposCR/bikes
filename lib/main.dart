import 'package:bikes/data/repository/bike_repository.dart';
import 'package:bikes/presentation/screens/get_bikes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikes/presentation/cubit/bike_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => BikeRepository(
            apiUrl:
            'https://q2kecky3ka.execute-api.us-east-2.amazonaws.com/Prod/bikes',
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => BikeCubit(
          bikeRepository: RepositoryProvider.of<BikeRepository>(context),
        ),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const BikeListView(),
        ),
      ),
    );
  }
}
