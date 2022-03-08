import '../../lib/ui/report_issues.dart';
import 'package:test/test.dart';

void main() {
  group('Report an Issue Screen - Unit Tests', () {
    group('launchMailto', () {
      test('launchMailto: Return false if there is at least on invalid email',
          () {
        List<String> emails = [
          'test@test.com',
          'test2@gmail.com',
          'thisfails.com', //This email will make the function return false
        ];
        Future<bool> ret = launchMailto(emails, '', '');
        expect(ret, completion(equals(false)));
      });
    });
  });
}
