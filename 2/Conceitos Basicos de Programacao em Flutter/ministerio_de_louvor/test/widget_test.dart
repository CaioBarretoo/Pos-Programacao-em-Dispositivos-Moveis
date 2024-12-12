import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ministerio_de_louvor/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testes de Transição de Telas', () {
    testWidgets('Navegação entre Escalas, Ministério e Repertório', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verifica se a tela inicial é Ministério (pela AppBar)
      expect(find.text('Ministério'), findsOneWidget);
      await tester.pumpAndSettle();

      // Toque no ícone de Escalas
      await tester.tap(find.byIcon(Icons.list));
      await tester.pumpAndSettle();

      // Verifica se a tela de Escalas foi exibida (pela AppBar)
      expect(find.text('Escalas'), findsOneWidget);

      // Toque no ícone de Repertório
      await tester.tap(find.byIcon(Icons.music_note));
      await tester.pumpAndSettle();

      // Verifica se a tela de Repertório foi exibida (pela AppBar)
      expect(find.text('Repertório'), findsOneWidget);

      // Toque no ícone de Ministério
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Verifica se a tela de Ministério foi exibida novamente (pela AppBar)
      expect(find.text('Ministério'), findsOneWidget);
    });
  });
}