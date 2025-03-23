import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_feed/swipe_feed.dart';

class SwipeFeedScreen extends StatelessWidget {
  final Widget Function(CardState, SwipeableCardController) swipeWidget;
  final Widget emptyWidget;
  final SwipeFeedController controller;
  final Map<int, SwipeableCardController> cardControllers;

  const SwipeFeedScreen({
    super.key,
    required this.swipeWidget,
    required this.controller,
    required this.emptyWidget,
    required this.cardControllers,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (controller.items.isEmpty) {
          return emptyWidget;
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            ...controller.cardStates.reversed.map((cardState) {
              if (!cardControllers.containsKey(cardState.item.id)) {
                cardControllers[cardState.item.id] = SwipeableCardController();
              }

              return swipeWidget(
                cardState,
                cardControllers[cardState.item.id]!,
              );
            }),
          ],
        );
      }),
    );
  }
}
