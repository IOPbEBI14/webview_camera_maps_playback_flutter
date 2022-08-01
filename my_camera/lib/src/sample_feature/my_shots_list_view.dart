import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera/src/data/my_images_repository.dart';

import '../domain/my_image_list.dart';

/// Displays a list of SampleItems.
class MyShotsListView extends StatelessWidget {
  const MyShotsListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Images gallery'),
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: BlocBuilder<MyImageList, MyImagesRepository>(
        builder: (_, state) {
          List<String> filenames = state.filenames;
          return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'sampleItemListView',
              itemCount: filenames.length,
              itemBuilder: (BuildContext context, int index) {
                final item = filenames[index];

                return SizedBox(
                  height: 150,
                  // title: Text('SampleItem ${item.id}'),
                  child: Image.file(
                    File(item),
                    fit: BoxFit.fitWidth,
                  ),
                );
              });
        },
      ),
    );
  }
}
