import 'package:test/test.dart';
import '../../lib/util/spacemapper_auth.dart';

void main() {
  test('TransistorAuth.register()', () {
    final user = TransistorAuth.register();
    expect(user, isNotNull);
  });

  /*test('TransistorAuth.register() fails on invalid input', () {
    final user = TransistorAuth.register();
  });*/
}
