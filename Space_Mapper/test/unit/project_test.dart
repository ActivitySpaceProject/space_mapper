import 'package:asm/models/project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Project.blank', () {
    Project project = Project.blank();

    expect(project.id, 0);
    expect(project.name, ' ');
    expect(project.webUrl, null);
    expect(project.projectScreen, null);
    expect(project.imageUrl, '');
    expect(project.summary, ' ');
  });

  test('Project: fetchAll', () async {
    List<Project> ret = await Project.fetchAll();

    expect(ret.length,
        0); //This function hasn't been implemented yet. So for the moment it has to return a list of length 0.
  });
}
