import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'carousel_card.dart';
import 'carousel_item.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({Key? key}) : super(key: key);

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final PageController _pageController = PageController();
  int       _currentPage = 0 ;
  final int _totalImages = 10;

  final List<CarouselItem> _carouselItems = [
    CarouselItem(//first pic
      imageName: 'Mountain Landscape',
      description: 'Beautiful mountain peaks with snow in the early morning light.',
      color: Colors.blue.shade200,
      icon: Icons.landscape,
    ),
    CarouselItem(//second pic
      imageName: 'Beach Sunset',
      description: 'Golden sunset over a tropical beach with palm trees.',
      color: Colors.orange.shade300,
      icon: Icons.beach_access,
    ),
    CarouselItem(//third pic
      imageName: 'City Skyline',
      description: 'Modern city skyline with skyscrapers at night.',
      color: Colors.purple.shade300,
      icon: Icons.location_city,
    ),
    CarouselItem(//forth pic
      imageName: 'Forest Trail',
      description: 'Peaceful trail through a dense green forest.',
      color: Colors.green.shade400,
      icon: Icons.forest,
    ),
    CarouselItem(//fifth pic
      imageName: 'Desert Dunes',
      description: 'Vast desert landscape with golden sand dunes.',
      color: Colors.amber.shade300,
      icon: Icons.terrain,
    ),
    CarouselItem(//sixth pic
      imageName: 'Waterfall',
      description: 'Majestic waterfall cascading down rocky cliffs.',
      color: Colors.blue.shade400,
      icon: Icons.water,
    ),
    CarouselItem(//seventh pic
      imageName: 'Northern Lights',
      description: 'Colorful aurora borealis dancing in the night sky.',
      color: Colors.indigo.shade300,
      icon: Icons.nightlight_round,
    ),
    CarouselItem(//eighth pic
      imageName: 'Spring Flowers',
      description: 'Vibrant field of colorful spring flowers in bloom.',
      color: Colors.pink.shade200,
      icon: Icons.local_florist,
    ),
    CarouselItem(//ninth pic
      imageName: 'Snowy Winter',
      description: 'Peaceful winter scene with snow-covered trees.',
      color: Colors.blueGrey.shade200,
      icon: Icons.ac_unit,
    ),
    CarouselItem(//tenth pic
      imageName: 'Autumn Leaves',
      description: 'Pathway covered with colorful autumn leaves.',
      color: Colors.deepOrange.shade300,
      icon: Icons.eco,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Carousel'),
        centerTitle: true,
        elevation: 0,
      ),
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
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _carouselItems.length,
                  itemBuilder: (context, index) {
                    return CarouselCard(item: _carouselItems[index]);
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                    // Indicator dots
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalImages,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          height: 8,
                          width: _currentPage == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button with tooltip
                      Tooltip(
                        message: 'Go to previous image',
                        waitDuration: const Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          onPressed: goToPreviousPage,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          ),
                        ),
                      ),

                      // Next button with tooltip
                      Tooltip(
                        message: 'Go to next image',
                        waitDuration: const Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          onPressed: goToNextPage,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
