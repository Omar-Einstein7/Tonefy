import 'package:audio_service/audio_service.dart';

import 'package:flutter/material.dart';
import 'package:tonefy/presentation/Favourite_page.dart';
import 'package:tonefy/presentation/home_page.dart';
import 'package:tonefy/presentation/player_page.dart';

class AppRouter {
  // static const String splashRoute = '/';
  static const String homeRoute = '/';
  static const String favoritesRoute = '/favorites';
  static const String playerRoute = '/player';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );

      case favoritesRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const FavoritesPage(),
        );
      case playerRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => PlayerPage(
            mediaItem: settings.arguments as MediaItem,
          ),
        );

      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );
    }
  }
}
