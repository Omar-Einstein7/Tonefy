import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:tonefy/bloc/Homebloc/home_bloc.dart';
import 'package:tonefy/bloc/Songbloc/song_bloc.dart';
import 'package:tonefy/data/repo/song_repository.dart';
import 'package:tonefy/data/services/hive_box.dart';
import 'package:tonefy/presentation/home_page.dart';
import 'package:tonefy/utils/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

  // ask for permission to access media if not granted
  if (!await Permission.mediaLibrary.isGranted) {
    await Permission.mediaLibrary.request();
  }

  // ask for notification permission if not granted
  if (!await Permission.notification.isGranted) {
    await Permission.notification.request();
  }

  // initialize hive
  await Hive.initFlutter();
  //await Hive.openBox(HiveBox.boxName);
  //WidgetsFlutterBinding.ensureInitialized();
  // final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDir.path);
  await Hive.openBox('fav_songs'); // Open your Hive box

  // initialize audio service

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.shokhrukhbek.meloplay.channel.audio',
    androidNotificationChannelName: 'Tonefy',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );

  runApp(
    RepositoryProvider(
      create: (context) => SongRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => SongBloc(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
    );
  }
}
