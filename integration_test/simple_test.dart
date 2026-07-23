import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:battery_app/src/rust/api/battery.dart';
import 'package:battery_app/src/rust/frb_generated.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('bridge loads', () {
    // Just verifies the Rust library links and a sync call works.
    hasSerialSupport();
  });
}
