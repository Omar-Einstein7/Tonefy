import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tonefy/presentation/home/bloc/home_cubit.dart';

import 'presentation/home/page/home_page.dart';
import 'service_locator.dart';

void main() {
  setupServiceLocator();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return BlocProvider(
        create: (context) => getIt<HomeCubit>()..fetchSongs(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DevFolio Flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:  HomePage(),
        ));
  }
}