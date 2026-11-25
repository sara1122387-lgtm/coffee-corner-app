import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_corner_app/main.dart';

void main() {
  testWidgets('Coffee Corner app loads successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoffeeCornerApp());

    expect(find.text('Coffee Corner'), findsOneWidget);
    expect(find.text('Welcome to Coffee Corner'), findsOneWidget);
  });
}
