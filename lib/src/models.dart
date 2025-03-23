import 'dart:ui';

class FeedItem {
  final int id;
  final String title;
  final String imageUrl;
  final Color color;

  FeedItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.color,
  });
}

class CardState {
  final FeedItem item;
  final double scale;
  final double yOffset;
  final double opacity;

  CardState({
    required this.item,
    required this.scale,
    required this.yOffset,
    required this.opacity,
  });
}
