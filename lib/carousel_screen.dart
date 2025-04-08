import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prject1/share_service.dart';

import 'carousel_card.dart';
import 'carousel_item.dart';


class CarouselScreen extends StatefulWidget {
  const CarouselScreen({Key? key}) : super(key: key);

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalImages = 10;
  bool _autoPlay = false;
  bool _immersiveMode = false;
  int _displayMode = 0; // 0 = normal, 1 = 3D, 2 = zoom

  late AnimationController _animationController;
  late Animation<double> _pageAnimation;

  List<CarouselItem> _carouselItems = [];

  @override
  void initState() {
    super.initState();
    _initializeItems();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
          _animationController.reset();
          _animationController.forward();
        });

        // Add haptic feedback when changing pages
        HapticFeedback.lightImpact();
      }
    });
  }

  void _initializeItems() {
    _carouselItems = [
      CarouselItem(
        imageName: 'Mountain Landscape',
        description: 'Beautiful mountain peaks with snow in the early morning light. These mountains have been formed over millions of years through tectonic activity and erosion.',
        color: Colors.blue.shade200,
        icon: Icons.landscape,
        facts: [
          'The tallest mountain on Earth is Mount Everest at 29,032 feet',
          'The Himalayas grow about 5 millimeters per year',
          'The oldest mountains on Earth are the Barbertown Greenstone Belt in South Africa'
        ],
      ),
      CarouselItem(
        imageName: 'Beach Sunset',
        description: 'Golden sunset over a tropical beach with palm trees. The reflection on the water creates a magical atmosphere of colors in the sky.',
        color: Colors.orange.shade300,
        icon: Icons.beach_access,
        facts: [
          'No two sunsets look exactly the same',
          'The colors in a sunset are created when light is scattered by particles in the atmosphere',
          'The best sunsets often occur after storms'
        ],
      ),
      CarouselItem(
        imageName: 'City Skyline',
        description: 'Modern city skyline with skyscrapers at night, illuminated by thousands of lights that reflect the vibrant urban life below.',
        color: Colors.purple.shade300,
        icon: Icons.location_city,
        facts: [
          'The tallest building in the world is the Burj Khalifa in Dubai at 2,717 feet',
          'Hong Kong has more skyscrapers than any other city in the world',
          'The Empire State Building was the world\'s tallest building for nearly 40 years'
        ],
      ),
      CarouselItem(
        imageName: 'Forest Trail',
        description: 'Peaceful trail through a dense green forest. Sunlight filters through the canopy, creating patterns of light and shadow on the forest floor.',
        color: Colors.green.shade400,
        icon: Icons.forest,
        facts: [
          'Forests cover about 31% of the world\'s land surface',
          'A single large tree can provide a day\'s supply of oxygen for up to four people',
          'The world\'s oldest known living tree is over 5,000 years old'
        ],
      ),
      CarouselItem(
        imageName: 'Desert Dunes',
        description: 'Vast desert landscape with golden sand dunes shaped by the wind. The patterns formed on the sand create natural works of art visible from above.',
        color: Colors.amber.shade300,
        icon: Icons.terrain,
        facts: [
          'The largest hot desert in the world is the Sahara in Africa',
          'Desert dunes can reach heights of over 1,000 feet',
          'Despite their harsh conditions, deserts are home to about 20% of the world\'s plant species'
        ],
      ),
      CarouselItem(
        imageName: 'Waterfall',
        description: 'Majestic waterfall cascading down rocky cliffs, surrounded by lush vegetation. The mist created by the falling water creates rainbows when hit by sunlight.',
        color: Colors.blue.shade400,
        icon: Icons.water,
        facts: [
          'Angel Falls in Venezuela is the world\'s highest uninterrupted waterfall at 3,212 feet',
          'Niagara Falls\' erosion rate means it will disappear in about 50,000 years',
          'Some waterfalls actually flow underwater in ocean environments'
        ],
      ),
      CarouselItem(
        imageName: 'Northern Lights',
        description: 'Colorful aurora borealis dancing in the night sky. These natural light displays occur when charged particles from the sun collide with gases in our atmosphere.',
        color: Colors.indigo.shade300,
        icon: Icons.nightlight_round,
        facts: [
          'Auroras occur on other planets in our solar system, not just Earth',
          'The colors of the aurora depend on which atmospheric gases the particles collide with',
          'Indigenous cultures around the world have various myths about the aurora'
        ],
      ),
      CarouselItem(
        imageName: 'Spring Flowers',
        description: 'Vibrant field of colorful spring flowers in bloom. Butterflies and bees fly from flower to flower, pollinating the plants and ensuring next year\'s blooms.',
        color: Colors.pink.shade200,
        icon: Icons.local_florist,
        facts: [
          'There are more than 400,000 flowering plant species on Earth',
          'The world\'s smallest flowering plant is the watermeal, at less than 1mm in size',
          'Some flowers can detect and respond to sound vibrations'
        ],
      ),
      CarouselItem(
        imageName: 'Snowy Winter',
        description: 'Peaceful winter scene with snow-covered trees. The silence that comes with freshly fallen snow creates a serene atmosphere in the winter landscape.',
        color: Colors.blueGrey.shade200,
        icon: Icons.ac_unit,
        facts: [
          'No two snowflakes are exactly alike',
          'The largest snowflake ever recorded was 15 inches wide',
          'Snow isn\'t actually white - it\'s clear and reflects light'
        ],
      ),
      CarouselItem(
        imageName: 'Autumn Leaves',
        description: 'Pathway covered with colorful autumn leaves. The vibrant reds, oranges, and yellows create a natural tapestry that transforms landscapes every fall season.',
        color: Colors.deepOrange.shade300,
        icon: Icons.eco,
        facts: [
          'Leaves change color in autumn when they stop producing chlorophyll',
          'New England in the USA is famous for its spectacular fall foliage',
          'Some trees can have leaves that display multiple colors simultaneously'
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (_currentPage == _totalImages - 1) {
      // If at last page, go to the first page
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Go to next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (_currentPage == 0) {
      // If at first page, go to the last page
      _pageController.animateToPage(
        _totalImages - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Go to previous page
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleFavorite(int index, bool value) {
    setState(() {
      _carouselItems[index] = _carouselItems[index].copyWith(isFavorite: value);
    });
    // Show a snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            value
                ? '${_carouselItems[index].imageName} added to favorites'
                : '${_carouselItems[index].imageName} removed from favorites'
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void toggleAutoPlay() {
    setState(() {
      _autoPlay = !_autoPlay;
    });

    if (_autoPlay) {
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 3));
        if (_autoPlay) {
          goToNextPage();
          return true;
        }
        return false;
      });
    }
  }

  void toggleImmersiveMode() {
    setState(() {
      _immersiveMode = !_immersiveMode;
    });

    if (_immersiveMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    // Add this to ensure UI is rebuilt properly after toggling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void changeDisplayMode() {
    setState(() {
      _displayMode = (_displayMode + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Always show AppBar when not in immersive mode
    final appBar = _immersiveMode
        ? null
        : AppBar(
      title: const Text('Flutter Carousel', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      elevation: 0,
      actions: [
        // Autoplay toggle
        IconButton(
          icon: Icon(_autoPlay ? Icons.pause_circle : Icons.play_circle),
          tooltip: _autoPlay ? 'Stop Autoplay' : 'Start Autoplay',
          onPressed: toggleAutoPlay,
        ),
        // Display mode button
        IconButton(
          icon: Icon([Icons.view_carousel, Icons.view_in_ar, Icons.zoom_in][_displayMode]),
          tooltip: 'Change Display Mode',
          onPressed: changeDisplayMode,
        ),
        // Fullscreen toggle
        IconButton(
          icon: Icon(_immersiveMode ? Icons.fullscreen_exit : Icons.fullscreen),
          tooltip: _immersiveMode ? 'Exit Fullscreen' : 'Enter Fullscreen',
          onPressed: toggleImmersiveMode,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    goToPreviousPage();
                  } else if (details.primaryVelocity! < 0) {
                    goToNextPage();
                  }
                },
                // Double tap to favorite/unfavorite
                onDoubleTap: () {
                  toggleFavorite(_currentPage, !_carouselItems[_currentPage].isFavorite);
                },
                child: _buildCarouselView(),
              ),
            ),
            _buildNavigationControls(),
          ],
        ),
      ),
      // Add floating action button for sharing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_immersiveMode) {
            // Exit immersive mode if active
            toggleImmersiveMode();
          } else {
            // Show sharing options using the ShareService
            ShareService.showShareDialog(
              context,
              _carouselItems[_currentPage],
            );
          }
        },
        tooltip: _immersiveMode ? 'Exit Fullscreen' : 'Share this image',
        child: Icon(_immersiveMode ? Icons.fullscreen_exit : Icons.share),
      ),
    );
  }

  Widget _buildCarouselView() {
    switch (_displayMode) {
      case 1: // 3D mode
        return PageView.builder(
          controller: _pageController,
          itemCount: _carouselItems.length,
          itemBuilder: (context, index) {
            // Calculate distance from current page for 3D effect
            double distanceFromCenter = (index - _pageController.page!).abs();
            double rotation = distanceFromCenter * 0.3; // Max rotation of 0.3 radians

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(index > _pageController.page! ? rotation : -rotation),
              alignment: Alignment.center,
              child: CarouselCard(
                item: _carouselItems[index],
                isActive: index == _currentPage,
                onFavoriteToggle: (value) => toggleFavorite(index, value),
                animation: _pageAnimation,
              ),
            );
          },
        );

      case 2: // Zoom mode
        return AnimatedBuilder(
          animation: _pageAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + _pageAnimation.value * 0.1,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _carouselItems.length,
                itemBuilder: (context, index) {
                  return CarouselCard(
                    item: _carouselItems[index],
                    isActive: index == _currentPage,
                    onFavoriteToggle: (value) => toggleFavorite(index, value),
                    animation: _pageAnimation,
                  );
                },
              ),
            );
          },
        );

      default: // Normal mode
        return PageView.builder(
          controller: _pageController,
          itemCount: _carouselItems.length,
          itemBuilder: (context, index) {
            return CarouselCard(
              item: _carouselItems[index],
              isActive: index == _currentPage,
              onFavoriteToggle: (value) => toggleFavorite(index, value),
              animation: _pageAnimation,
            );
          },
        );
    }
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Column(
        children: [
          // Indicator dots with animation
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalImages,
                    (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _carouselItems[index].color
                          : _carouselItems[index].color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: _currentPage == index
                          ? [
                        BoxShadow(
                          color: _carouselItems[index].color.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation buttons with enhancements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button with tooltip and animation
              Tooltip(
                message: 'Go to previous image (${_currentPage == 0 ? _carouselItems.last.imageName : _carouselItems[_currentPage - 1].imageName})',
                waitDuration: const Duration(milliseconds: 800),
                child: ElevatedButton.icon(
                  onPressed: goToPreviousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    backgroundColor: _carouselItems[_currentPage == 0 ? _totalImages - 1 : _currentPage - 1].color.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: _carouselItems[_currentPage == 0 ? _totalImages - 1 : _currentPage - 1].color.withOpacity(0.5),
                  ),
                ),
              ),

              // Page counter
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: _carouselItems[_currentPage].color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalImages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _carouselItems[_currentPage].color,
                  ),
                ),
              ),

              // Next button with tooltip and animation
              Tooltip(
                message: 'Go to next image (${_currentPage == _totalImages - 1 ? _carouselItems.first.imageName : _carouselItems[_currentPage + 1].imageName})',
                waitDuration: const Duration(milliseconds: 800),
                child: ElevatedButton.icon(
                  onPressed: goToNextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    backgroundColor: _carouselItems[_currentPage == _totalImages - 1 ? 0 : _currentPage + 1].color.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: _carouselItems[_currentPage == _totalImages - 1 ? 0 : _currentPage + 1].color.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),

          // Show image name and favorite status
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _carouselItems[_currentPage].isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _carouselItems[_currentPage].isFavorite ? Colors.red : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _carouselItems[_currentPage].imageName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _carouselItems[_currentPage].color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}