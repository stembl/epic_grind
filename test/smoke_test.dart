import 'package:flutter_test/flutter_test.dart';
import 'package:epic_grind/main.dart';

void main() {
  testWidgets('EpicGrindApp shows QuestScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      EpicGrindApp(loadEmailOverride: 'test@example.com'),
    );

    await tester.pumpAndSettle(); // waits for FutureBuilder
    expect(find.text('Quests'), findsOneWidget);
  });
}
