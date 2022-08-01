import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera/src/data/my_images_repository.dart';

class MyImageList extends Cubit<MyImagesRepository> {
  MyImageList() : super(MyImagesRepository());

  void setFileName(String value) {
    emit(state.add(value));
  }
}
