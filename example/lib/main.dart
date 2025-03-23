import 'package:flutter/material.dart';
import 'package:swipe_feed/swipe_feed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tinder-like Swipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  List<FeedItem> feedItems = [];

  @override
  void initState() {
    super.initState();
    generateFeedItems(false);
  }

  Future<List<FeedItem>> reloadFeed() async {
    return generateFeedItems(true);
  }

  List<FeedItem> generateFeedItems(bool isNext) {
    setState(() {
      debugPrint("called");
      feedItems.clear();
      feedItems = List.generate(5, (index) {
        return FeedItem(
          id: isNext ? index + 6 : index + 1,
          title: "User ${isNext ? index + 6 : index + 1}",
          imageUrl:
              "https://source.unsplash.com/random/200x200/?face,portrait&sig=$index",
          color: Colors.primaries[index + 1 % Colors.primaries.length],
        );
      });
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tinder swipe")),
      body: SwipeWidgetInitialization(
        feedItems: feedItems,
        swipeWidget:
            (item, cardController) =>
                SwipeWidget(item: item, cardController: cardController),
        onDislike: (item) {
          debugPrint("dislike called  ${item.title}");
        },
        onLike: (item) {
          debugPrint("like called  ${item.title}");
        },
        onReload: reloadFeed,
      ),
    );
  }
}

class SwipeWidget extends StatelessWidget {
  final FeedItem item;
  final SwipeableCardController cardController;
  const SwipeWidget({
    super.key,
    required this.item,
    required this.cardController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [item.color.withOpacity(0.7), item.color],
            ),
          ),
        ),
        // Card content
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
                SizedBox(height: 20),
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    if (cardController.swipeLeft != null) {
                      cardController.swipeLeft!();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ), // Red border
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Rounded corners
                      color: Colors.transparent, // No background color
                    ),
                    child: Icon(Icons.cancel_outlined),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (cardController.swipeRight != null) {
                      cardController.swipeRight!();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ), // Red border
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Rounded corners
                      color: Colors.transparent, // No background color
                    ),
                    child: Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
