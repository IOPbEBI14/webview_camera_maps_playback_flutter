/// A placeholder class that represents an entity or model.
class VideoFile {
  const VideoFile(this.id, this.name, this.url);

  final int id;
  final String name;
  final String url;

  VideoFile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': url};
}
