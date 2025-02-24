import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_assessment/tech_assessment.dart';

void main() {
  group('TechRouter', () {
    testWidgets('Initial route should be rendered correctly', (tester) async {
      final router = TechRouter(
        initialRoute: Location(path: 'page1', builder: (context) => Page1()),
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));

      // Verify the initial route is rendered
      expect(find.byType(Page1), findsOneWidget);
    });

    testWidgets('Router should handle push navigation correctly',
        (tester) async {
      final router = TechRouter(
        initialRoute: Location(path: 'page1', builder: (context) => Page1()),
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));

      // Push a new route
      router.push(Location(path: 'page2', builder: (context) => Page2()));
      await tester.pumpAndSettle();

      // Verify the new route is rendered
      expect(find.byType(Page2), findsOneWidget);
    });

    testWidgets('Router should handle back navigation correctly',
        (tester) async {
      final router = TechRouter(
        initialRoute: Location(path: 'page1', builder: (context) => Page1()),
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));

      router.push(Location(path: 'page2', builder: (context) => Page2()));
      await tester.pumpAndSettle();

      // Trigger back navigation
      router.pop();
      await tester.pumpAndSettle();

      // Verify we're back at page 1
      expect(find.byType(Page1), findsOneWidget);
    });
  });
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Text('Page 1'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Page 2'),
        ),
        body: const Center(
          child: Text('Page 2'),
        ));
  }
}
