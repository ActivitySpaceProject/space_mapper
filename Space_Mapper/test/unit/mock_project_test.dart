import 'package:asm/mocks/mock_project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test fetchAny', () {
    final mockProject = MockProject.fetchFirst();
    expect(mockProject, isNotNull);
    expect(mockProject.name, isNotEmpty);
  });

  test('test fetchAll', () {
    final mockProject = MockProject.fetchAll();
    expect(mockProject.length, greaterThan(0));
    expect(mockProject[0].name, isNotEmpty);
  });

  test('test fetch', () {
    final mockProject = MockProject.fetchByID(0);
    expect(mockProject, isNotNull);
    expect(mockProject.name, isNotEmpty);
  });
}
