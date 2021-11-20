class Survey {
  final int id;
  final String name;
  final String summary;
  Survey(this.id, this.name, this.summary);

  Survey.blank()
      : id = 0,
        name = ' ',
        summary = ' ';

  static Future<List<Survey>> fetchAll() async {
    // TODO: In a future version we'll fetch data from a web app
    List<Survey> list = [];
    return list;
  }
}
