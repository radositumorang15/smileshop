import 'package:flutter/material.dart';

class VerticalCarousel extends StatefulWidget {
  const VerticalCarousel({Key? key}) : super(key: key);

  @override
  State<VerticalCarousel> createState() => _VerticalCarouselState();
}

class _VerticalCarouselState extends State<VerticalCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> banners = [
    BannerWidget(
      title: "New items with \nFree shipping",
      buttonText: "Shop now",
      imageUrl: "https://i.ibb.co.com/mHKM5c2/banner1.png", // Ganti URL gambar
    ),
    BannerWidget(
      title: "Christmast\nSpecial Deals",
      buttonText: "Shop now",
      imageUrl: "https://i.ibb.co.com/mHKM5c2/banner1.png" // Ganti URL gambar
    ),
    BannerWidget(
      title: "Limited Time \nOffer!",
      buttonText: "Discover",
      imageUrl: "https://i.ibb.co.com/mHKM5c2/banner1.png", // Ganti URL gambar
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: banners.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return banners[index];
          },
        ),
        Positioned(
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 8),
                height: _currentIndex == index ? 12 : 8,
                width: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.white
                      : Colors.white54,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String title;
  final String buttonText;
  final String imageUrl;

  const BannerWidget({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
