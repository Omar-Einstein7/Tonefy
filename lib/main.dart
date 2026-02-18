import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tonefy/presentation/home/bloc/home_cubit.dart';
import 'package:Tonefy/presentation/home/bloc/song_player_cubit.dart';

import 'presentation/home/page/home_page.dart';
import 'service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HomeCubit>()..fetchSongs()),
        BlocProvider(create: (context) => getIt<SongPlayerCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tonefy',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          cardTheme: CardThemeData(
            color: Colors.white.withOpacity(0.3),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
