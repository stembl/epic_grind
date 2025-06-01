import 'package:flutter_test/flutter_test.dart';
import 'package:epic_grind/main.dart';

void main() {
  testWidgets('EpicGrindApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(EpicGrindApp());

    // Verify that at least one known screen label is present
    expect(find.text('Quests'), findsOneWidget); // Confirm quest screen loads
  });
}
