import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_2023_presentation/main.dart';
import 'package:fluttercon_2023_presentation/pages/01_title/view/title_slide.dart';
import 'package:fluttercon_2023_presentation/pages/02_agenda/view/agenda_slide.dart';
import 'package:fluttercon_2023_presentation/presentation/view/presentation_slides.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helper/pump_timer.dart';

void main() {
  testWidgets('Test render presentation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyPresentation()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(PresentationSlides), findsOneWidget);
  });

  testWidgets('Test presentation go to next slide', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyPresentation()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PresentationSlides), findsOneWidget);
    expect(find.byType(TitleSlide), findsOneWidget);

    await tester.tap(find.byType(PresentationSlides));
    await pumpTimer(tester);

    expect(find.byType(AgendaSlide), findsOneWidget);
  });
}
