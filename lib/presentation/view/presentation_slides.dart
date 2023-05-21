import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttercon_2023_presentation/presentation/model/enum/key_actions.dart';
import 'package:fluttercon_2023_presentation/presentation/model/enum/pages_of_presentation.dart';
import 'package:fluttercon_2023_presentation/presentation/provider/presentation_controller_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PresentationSlides extends HookConsumerWidget {
  const PresentationSlides({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = FocusNode();
    final keyPressed = useState(false);
    final pageController = useState(PageController());

    void toNextPage() {
      ref
          .read<PresentationController>(presentationController.notifier)
          .nextPage();
      pageController.value.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    KeyEventResult handleKeyEvent(RawKeyEvent event) {
      if (event is RawKeyDownEvent && !keyPressed.value) {
        if (KeyActions.goToLastSlide.keybindings
            .any((key) => key == event.physicalKey)) {
          ref
              .read<PresentationController>(presentationController.notifier)
              .toLastPage();
          pageController.value.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          keyPressed.value = true;
          return KeyEventResult.handled;
        }

        if (KeyActions.goNextSlide.keybindings
            .any((key) => key == event.physicalKey)) {
          toNextPage();
          keyPressed.value = true;
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      } else if (event is RawKeyUpEvent) {
        keyPressed.value = false;
      }
      return KeyEventResult.ignored;
    }

    void onSlidePress() {
      if (!focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }

      toNextPage();
    }

    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: handleKeyEvent,
      child: GestureDetector(
        onTap: onSlidePress,
        onSecondaryTap: () => ref
            .read<PresentationController>(presentationController.notifier)
            .toLastPage(),
        child: CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: PageView.builder(
            itemCount: PagesOfPresentation.values.length,
            controller: pageController.value,
            itemBuilder: (context, index) =>
                PagesOfPresentation.values[index].slide,
          ),
        ),
      ),
    );
  }
}
