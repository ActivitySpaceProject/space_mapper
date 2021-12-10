import 'package:asm/mocks/mock_survey.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test fetchAny', () {
    final mockSurvey = MockSurvey.fetchFirst();
    expect(mockSurvey, isNotNull);
    expect(mockSurvey.name, isNotEmpty);
  });

  test('test fetchAll', () {
    final mockSurvey = MockSurvey.fetchAll();
    expect(mockSurvey.length, greaterThan(0));
    expect(mockSurvey[0].name, isNotEmpty);
  });

  test('test fetch', () {
    final mockSurvey = MockSurvey.fetchByID(0);
    expect(mockSurvey, isNotNull);
    expect(mockSurvey.name, isNotEmpty);
  });
}
