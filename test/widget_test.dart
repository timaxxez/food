import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // Загружаем приложение FoodDeliveryApp вместо MyApp
    await tester.pumpWidget(const FoodDeliveryApp());

    // Проверяем, что название сервиса отображается на экране
    expect(find.text('"ВКУСОМАНИЯ"'), findsOneWidget);
  });
}