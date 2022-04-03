import 'package:asm/models/project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Survey.blank', () {
    Project survey = Project.blank();

    expect(survey.id, 0);
    expect(survey.name, ' ');
    expect(survey.webUrl, ' ');
    expect(survey.imageUrl, '');
    expect(survey.summary, ' ');
  });

  test('Survey: fetchAll', () async {
    List<Project> ret = await Project.fetchAll();

    expect(ret.length,
        0); //This function hasn't been implemented yet. So for the moment it has to return a list of length 0.
  });
}
