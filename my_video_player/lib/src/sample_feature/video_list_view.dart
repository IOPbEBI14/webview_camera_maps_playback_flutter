import 'package:flutter/material.dart';
import 'video_file.dart';
import 'video_player_view.dart';

/// Displays a list of SampleItems.
class VideoListView extends StatelessWidget {
  const VideoListView({
    Key? key,
    this.items = const [
      VideoFile(1, 'Хоп-Хоп', 'Rzja-qJgSX4'),
      VideoFile(2, 'Южный парк', 'w-yduJfPSwg'),
      VideoFile(3, 'Люк, я твой отец', 'nEMwOUKDM_I')
    ],
  }) : super(key: key);

  static const routeName = '/';

  final List<VideoFile> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.name),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  VideoPlayerView.routeName,
                  arguments: item.toJson(),
                );
              });
        },
      ),
    );
  }
}
