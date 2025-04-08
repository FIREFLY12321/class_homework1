import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'carousel_item.dart';

class CarouselCard extends StatefulWidget {
  final CarouselItem item;
  final Function(bool) onFavoriteToggle;
  final bool isActive; // To know if this is the current card
  final Animation<double>? animation; // For advanced animations

  const CarouselCard({
    Key? key,
    required this.item,
    required this.onFavoriteToggle,
    this.isActive = false,
    this.animation,
  }) : super(key: key);

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> with SingleTickerProviderStateMixin {
  bool _showFacts = false;
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;
  late Animation<double> _cardElevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _cardElevationAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CarouselCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? 1.0 : 0.9, // Slight scale difference for inactive cards
          child: Card(
            margin: EdgeInsets.all(widget.isActive ? 16.0 : 24.0),
            elevation: _cardElevationAnimation.value,
            shadowColor: widget.item.color.withOpacity(0.6), // Colored shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: widget.isActive
                  ? BorderSide(color: widget.item.color, width: 2.0)
                  : BorderSide.none,
            ),
            child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
          ),
        );
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Background with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.item.color, widget.item.color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
              ),
              // Animated Icon
              Center(
                child: AnimatedBuilder(
                  animation: _iconAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconAnimation.value,
                      child: Icon(
                        widget.item.icon,
                        size: 100,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.item.isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    widget.onFavoriteToggle(!widget.item.isFavorite);
                  },
                ),
              ),
              // Info button for facts
              if (widget.item.facts.isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: Icon(
                      _showFacts ? Icons.info : Icons.info_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFacts = !_showFacts;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.item.imageName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _showFacts && widget.item.facts.isNotEmpty
                      ? _buildFactsList()
                      : SingleChildScrollView(
                    child: Text(
                      widget.item.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        // Icon part
        Container(
          width: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.item.color, widget.item.color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _iconAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconAnimation.value,
                      child: Icon(
                        widget.item.icon,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.item.isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    widget.onFavoriteToggle(!widget.item.isFavorite);
                  },
                ),
              ),
              // Info button for facts
              if (widget.item.facts.isNotEmpty)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      _showFacts ? Icons.info : Icons.info_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFacts = !_showFacts;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        // Text content part
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.imageName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _showFacts && widget.item.facts.isNotEmpty
                      ? _buildFactsList()
                      : SingleChildScrollView(
                    child: Text(
                      widget.item.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFactsList() {
    return ListView.builder(
      itemCount: widget.item.facts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: widget.item.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.item.facts[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}