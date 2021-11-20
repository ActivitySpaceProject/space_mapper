class Survey {
  final int id;
  final String name;
  final String webUrl;
  final String imageUrl;
  final String summary;
  Survey(this.id, this.name, this.webUrl, this.imageUrl, this.summary);

  Survey.blank()
      : id = 0,
        name = ' ',
        webUrl = ' ',
        imageUrl = ' ',
        summary = ' ';

  static Future<List<Survey>> fetchAll() async {
    // TODO: In a future version we'll fetch data from a web app
    List<Survey> list = [];
    return list;
  }
}
