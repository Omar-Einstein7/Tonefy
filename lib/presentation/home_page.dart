import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:tonefy/data/repo/song_repository.dart';
import 'package:tonefy/presentation/songs_view.dart';
import 'package:tonefy/presentation/widgets/bottom_music.dart';
import 'package:tonefy/presentation/widgets/home_card.dart';
import 'package:tonefy/utils/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late final SongRepository songRepository;
  late TabController _tabController;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
    // _tabController = TabController(length: tabs.length, vsync: this);
  }

  Future checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : checkAndRequestPermissions(retry: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purpleAccent, Colors.blue])),
      child: Scaffold(
        bottomNavigationBar: const PlayerBottomAppBar(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Tonefy',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: Ink(
          child: _hasPermission
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          HomeCard(
                            title: 'Favorites',
                            icon: Icons.favorite_rounded,
                            color: const Color(0xFF5D2285),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRouter.favoritesRoute,
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          HomeCard(
                            title: 'Playlists',
                            icon: Icons.playlist_play,
                            color: const Color(0xFF136327),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                "AppRouter.favoritesRoute",
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          HomeCard(
                            title: 'Recents',
                            icon: Icons.history,
                            color: const Color(0xFFD4850D),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                " AppRouter.favoritesRoute",
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SongsView(),
                    ),
                  ],
                )
              : const Center(
                  child: Text('No permission to access library'),
                ),
        ),
      ),
    );
  }
}
