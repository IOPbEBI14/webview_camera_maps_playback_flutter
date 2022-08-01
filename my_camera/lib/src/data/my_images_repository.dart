class MyImagesRepository {
  late List<String> _filenames;

  MyImagesRepository() {
    _filenames = [];
  }

  MyImagesRepository add(String filename) {
    _filenames.add(filename);
    return this;
  }

  List<String> get filenames => _filenames;
}
