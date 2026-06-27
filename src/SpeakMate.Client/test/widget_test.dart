import 'package:flutter_test/flutter_test.dart';

import 'package:speak_mate_app/app.dart';

void main() {
  testWidgets('SpeakMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SpeakMateApp());
    await tester.pumpAndSettle();

    // Verify the speech screen renders with mic button hint text
    expect(find.text('TAP TO SPEAK'), findsOneWidget);
    expect(find.text('SPEAK MATE'), findsOneWidget);
  });
}
