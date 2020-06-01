import 'package:flutter_test/flutter_test.dart';
import 'package:history_go/main.dart';

void main() {
  testWidgets('app builds test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(true, true);
  });
}
