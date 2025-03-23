import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../swipe_feed.dart';

class SwipeWidgetInitialization extends StatefulWidget {
  final List<FeedItem> feedItems;
  final Widget Function(FeedItem, SwipeableCardController) swipeWidget;
  final Function(FeedItem) onDislike;
  final Function(FeedItem) onLike;
  final Future<List<FeedItem>> Function() onReload;

  const SwipeWidgetInitialization({
    super.key,
    required this.feedItems,
    required this.swipeWidget,
    required this.onDislike,
    required this.onLike,
    required this.onReload,
  });

  @override
  State<SwipeWidgetInitialization> createState() =>
      _SwipeWidgetInitializationState();
}

class _SwipeWidgetInitializationState extends State<SwipeWidgetInitialization> {
  late final SwipeFeedController controller;
  final Map<int, SwipeableCardController> cardControllers = {};

  @override
  void initState() {
    super.initState();
    controller = Get.put(SwipeFeedController(feedItems: widget.feedItems));
  }

  @override
  Widget build(BuildContext context) {
    return SwipeFeedScreen(
      swipeWidget: (cardState, swipeCardController) {
        return _buildCardWidget(cardState);
      },
      controller: controller,
      emptyWidget: _buildEmptyState(),
      cardControllers: cardControllers,
    );
  }

  Widget _buildCardWidget(CardState cardState) {
    if (!cardControllers.containsKey(cardState.item.id)) {
      cardControllers[cardState.item.id] = SwipeableCardController();
    }
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: cardState.yOffset,
      child: Opacity(
        opacity: cardState.opacity,
        child: AnimatedScale(
          duration: Duration(milliseconds: 300),
          scale: cardState.scale,
          child: SwipeableCard(
            key: ValueKey(cardState.item.id),
            item: cardState.item,
            controller: controller,
            swipeWidget: widget.swipeWidget(
              cardState.item,
              cardControllers[cardState.item.id]!,
            ),
            onDislike: widget.onDislike,
            onLike: widget.onLike,
            cardController: cardControllers[cardState.item.id]!,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 100, color: Colors.grey),
        SizedBox(height: 20),
        Text(
          'No more items to swipe!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            widget.onReload().then((value) => {controller.onReload(value)});
          },
          child: Text('Reload'),
        ),
      ],
    );
  }
}
