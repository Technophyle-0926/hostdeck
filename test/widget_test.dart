import 'package:flutter_test/flutter_test.dart';
import 'package:hostdeck/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HostDeckApp());

    // Wait for bindings and animations
    await tester.pumpAndSettle();

    expect(find.text('HostDeck Dashboard'), findsOneWidget);
  });
}
