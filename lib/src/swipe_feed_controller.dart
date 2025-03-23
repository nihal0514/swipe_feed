import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../swipe_feed.dart';

class SwipeableCardController {
  Function? swipeLeft;
  Function? swipeRight;
}

class SwipeFeedController extends GetxController
    with GetTickerProviderStateMixin {
  final List<FeedItem> feedItems;
  var items = <FeedItem>[].obs;
  var cardStates = <CardState>[].obs;
  var isAnimating = false.obs;

  late AnimationController _stackAnimationController;
  SwipeFeedController({required this.feedItems});

  @override
  void onInit() {
    super.onInit();
    _stackAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    items.assignAll(feedItems);
    // Initialize card states
    _updateCardStates();
  }

  @override
  void onClose() {
    _stackAnimationController.dispose();
    super.onClose();
  }

  void onReload(List<FeedItem> newFeedItems) {
    items.assignAll(newFeedItems);
    _updateCardStates();
  }

  void _updateCardStates() {
    cardStates.clear();

    for (int i = 0; i < items.length; i++) {
      // Calculate positioning values based on stack position
      double scale = i == 0 ? 1.0 : (1.0 - (i * 0.05)).clamp(0.8, 1.0);
      double yOffset = i == 0 ? 0.0 : (i * 10.0).clamp(0.0, 30.0);
      double opacity = i == 0 ? 1.0 : (1.0 - (i * 0.1)).clamp(0.5, 1.0);

      cardStates.add(
        CardState(
          item: items[i],
          scale: scale,
          yOffset: yOffset,
          opacity: opacity,
        ),
      );
    }
  }

  void likeItem(FeedItem item, Function(FeedItem)? onLike) {
    isAnimating.value = true;
    items.remove(item);
    _updateCardStates();
    if (onLike != null) {
      onLike(item);
    }

    isAnimating.value = false;
  }

  void dislikeItem(FeedItem item, Function(FeedItem)? onDislike) {
    isAnimating.value = true;

    items.remove(item);
    _updateCardStates();
    if (onDislike != null) {
      onDislike(item);
    }
    isAnimating.value = false;
  }
}
