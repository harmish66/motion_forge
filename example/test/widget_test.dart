import 'package:flutter_test/flutter_test.dart';
import 'package:motion_forge_example/main.dart';

void main() {
  testWidgets('MotionForgeExampleApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MotionForgeExampleApp());
    expect(find.text('Motion Forge Animation Gallery'), findsOneWidget);
  });
}
