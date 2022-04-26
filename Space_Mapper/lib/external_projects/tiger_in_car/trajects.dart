class TigerInCarRoute {
  DateTime? _startDate;
  late List<DateTime> _mosquitoAlive = []; //
  // ignore: unused_field
  DateTime? _mosquitoDeath;

  void setStartDate(DateTime startDate) {
    if (_startDate == null)
    {
      _startDate = startDate;
    }      
  }

  void addMosquitoAlive(DateTime date) {
    if (_startDate == null) setStartDate(date);

    _mosquitoAlive.add(date);
  }

  void finishExperiment(DateTime date) {
    _mosquitoDeath = date;
    sendReport();
  }

  Future<void> sendReport() async {
    // Get all locations from history

    // Filter to save only the locations recorded in_vehicle

    // Send the json with car positions
  }
}
