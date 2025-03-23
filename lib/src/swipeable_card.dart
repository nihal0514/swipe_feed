import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../swipe_feed.dart';

class SwipeableCard extends StatefulWidget {
  final FeedItem item;
  final SwipeFeedController controller;
  final Widget swipeWidget;
  Function(FeedItem) onDislike;
  Function(FeedItem) onLike;
  final SwipeableCardController cardController;

  SwipeableCard({
    Key? key,
    required this.item,
    required this.controller,
    required this.swipeWidget,
    required this.onDislike,
    required this.onLike,
    required this.cardController
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  double _angle = 0;
  BorderSide _borderSide = BorderSide.none;
  late AnimationController _dragAnimationController;
  bool _isDragging = false;

  VoidCallback? _animationListener;
  AnimationStatusListener? _animationStatusListener;

  @override
  void initState() {
    super.initState();
    _dragAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    widget.cardController.swipeLeft = swipeLeft;
    widget.cardController.swipeRight = swipeRight;
  }


  void swipeRight() {
    // Get the current screen size
    final Size size = MediaQuery.of(context).size;
    // Store the current position before animation starts
    final startPosition = _position;

    // Reset the animation controller
    _dragAnimationController.reset();

    // Clear listeners properly
    if (_animationListener != null) {
      _dragAnimationController.removeListener(_animationListener!);
    }
    if (_animationStatusListener != null) {
      _dragAnimationController.removeStatusListener(_animationStatusListener!);
    }

    // Define the animation listener function
    _animationListener = () {
      if (mounted) {
        setState(() {
          double progress = _dragAnimationController.value;
          // Use a slower ease-out curve for more natural movement
          double curvedProgress = Curves.easeOut.transform(progress);

          // Move from current position to off-screen right
          _position = Offset(
            startPosition.dx + (size.width - startPosition.dx) * curvedProgress,
            startPosition.dy, // Keep vertical position the same
          );

          // Gradually increase rotation angle as it moves
          _angle = 10 * curvedProgress;

          // Apply green border
          _borderSide = BorderSide(
              color: Colors.green,
              width: 4
          );

        });
      }
    };

    // Define the animation status listener function
    _animationStatusListener = (status) {
      if (status == AnimationStatus.completed) {
        widget.controller.likeItem(widget.item,widget.onLike);
      }
    };

    // Add the listeners
    _dragAnimationController.addListener(_animationListener!);
    _dragAnimationController.addStatusListener(_animationStatusListener!);

    // Make the animation much slower for better visibility
    _dragAnimationController.duration = const Duration(milliseconds: 1000);
    _dragAnimationController.forward();
  }

  void swipeLeft() {
    // Get the current screen size
    final Size size = MediaQuery.of(context).size;

    // Store the current position before animation starts
    final startPosition = _position;

    // Reset the animation controller
    _dragAnimationController.reset();

    // Clear listeners properly
    if (_animationListener != null) {
      _dragAnimationController.removeListener(_animationListener!);
    }
    if (_animationStatusListener != null) {
      _dragAnimationController.removeStatusListener(_animationStatusListener!);
    }

    // Define the animation listener function
    _animationListener = () {
      if (mounted) {
        setState(() {
          double progress = _dragAnimationController.value;
          // Use a slower ease-out curve for more natural movement
          double curvedProgress = Curves.easeOut.transform(progress);

          // Move from current position to off-screen left
          _position = Offset(
            startPosition.dx + (-size.width - startPosition.dx) * curvedProgress,
            startPosition.dy, // Keep vertical position the same
          );

          // Gradually increase rotation angle as it moves
          _angle = -10 * curvedProgress;

          // Apply red border
          _borderSide = BorderSide(
              color: Colors.red,
              width: 4
          );
        });
      }
    };

    // Define the animation status listener function
    _animationStatusListener = (status) {
      if (status == AnimationStatus.completed) {
        widget.controller.dislikeItem(widget.item,widget.onDislike);
      }
    };

    // Add the listeners
    _dragAnimationController.addListener(_animationListener!);
    _dragAnimationController.addStatusListener(_animationStatusListener!);

    // Make the animation much slower for better visibility
    _dragAnimationController.duration = const Duration(milliseconds: 1000);
    _dragAnimationController.forward();
  }
  @override
  void dispose() {
    if (_animationListener != null) {
      _dragAnimationController.removeListener(_animationListener!);
    }
    if (_animationStatusListener != null) {
      _dragAnimationController.removeStatusListener(_animationStatusListener!);
    }
    _dragAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final rotationAngle = _angle * math.pi / 180;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: rotationAngle,
          child: Container(
            height: size.height * 0.7,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.fromBorderSide(_borderSide),

            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  widget.swipeWidget,
                  // Like/Dislike indicators
                  if (_position.dx > 0 && _isDragging)
                    Positioned(
                      top: 40,
                      left: 40,
                      child: Transform.rotate(
                        angle: -0.5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'LIKE',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_position.dx < 0 && _isDragging)
                    Positioned(
                      top: 40,
                      right: 40,
                      child: Transform.rotate(
                        angle: 0.5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'NOPE',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _borderSide = BorderSide.none;
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      _angle = (_position.dx / 20).clamp(-10, 10);

      // Set border color based on drag direction
      if (_position.dx > 0) {
        _borderSide = BorderSide(color: Colors.green, width: 4);
      } else if (_position.dx < 0) {
        _borderSide = BorderSide(color: Colors.red, width: 4);
      } else {
        _borderSide = BorderSide.none;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    final double swipeThreshold = MediaQuery.of(context).size.width * 0.2;

    if (_position.dx > swipeThreshold) {
      // Swiped right - like
      _animateSwipe(MediaQuery.of(context).size.width, 0, () {
        widget.controller.likeItem(widget.item,widget.onLike);
      });
    } else if (_position.dx < -swipeThreshold) {
      // Swiped left - dislike
      _animateSwipe(-MediaQuery.of(context).size.width, 0, () {
        widget.controller.dislikeItem(widget.item,widget.onDislike);
      });
    } else {
      // Return to center
      _animateSwipe(0, 0, () {
        setState(() {
          _borderSide = BorderSide.none;
        });
      });
    }
  }

  void _animateSwipe(double targetX, double targetY, VoidCallback onComplete) {
    _dragAnimationController.reset();

    // Initial position
    Offset startPosition = _position;

    // On animation update
    _dragAnimationController.addListener(() {
      if (mounted) {
        setState(() {
          double progress = _dragAnimationController.value;
          _position = Offset(
            startPosition.dx + (targetX - startPosition.dx) * progress,
            startPosition.dy + (targetY - startPosition.dy) * progress,
          );
        });
      }
    });

    // On animation complete
    _dragAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _angle=0;
        onComplete();
      }
    });

    // Start animation
    _dragAnimationController.forward();
  }
}