import 'package:flutter/material.dart';
import 'package:my_video_player/src/sample_feature/video_file.dart';

import 'sample_feature/video_player_view.dart';
import 'sample_feature/video_list_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case VideoPlayerView.routeName:
                {
                  final args = routeSettings.arguments as Map<String, dynamic>;
                  VideoFile file = VideoFile.fromJson(args);

                  return VideoPlayerView(
                    key: context.widget.key,
                    file: file,
                  );
                }
              case VideoListView.routeName:
              default:
                return const VideoListView();
            }
          },
        );
      },
    );
  }
}
