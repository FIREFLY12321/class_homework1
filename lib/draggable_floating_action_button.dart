import 'package:flutter/material.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final BuildContext appContext;
  final PreferredSizeWidget? appBar;

  const DraggableFloatingActionButton({
    Key? key,
    required this.child,
    required this.initialOffset,
    required this.onPressed,
    required this.appContext,
    this.appBar,
    this.tooltip,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<DraggableFloatingActionButton> createState() => _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState extends State<DraggableFloatingActionButton> {
  late Offset position;
  final double buttonSize = 56.0;

  @override
  void initState() {
    super.initState();
    position = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate valid screen boundaries
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = widget.appBar?.preferredSize.height ?? 0.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Ensure the position is within screen bounds
    double maxX = screenSize.width - buttonSize;
    double maxY = screenSize.height - buttonSize - bottomPadding;
    double minY = statusBarHeight + appBarHeight;

    position = Offset(
      position.dx.clamp(0.0, maxX),
      position.dy.clamp(minY, maxY),
    );

    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position = Offset(
                  (position.dx + details.delta.dx).clamp(0.0, maxX),
                  (position.dy + details.delta.dy).clamp(minY, maxY),
                );
              });
            },
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              tooltip: widget.tooltip,
              backgroundColor: widget.backgroundColor,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}