import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int myCurrentIndex = 0;

  List<String> notifications = [
    'Notification 1: Important update!',
    'Notification 2: New feature available.',
    'Notification 3: Reminder for event.',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final shadowColor = isDark ? Colors.black26 : Colors.black12;
    final dotActive = isDark ? Colors.white : Colors.black87;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: 110,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              autoPlayInterval: const Duration(seconds: 2),
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: notifications.map((notification) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    notification,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          AnimatedSmoothIndicator(
            activeIndex: myCurrentIndex,
            count: notifications.length,
            effect: WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              spacing: 4,
              dotColor: Colors.grey.shade400,
              activeDotColor: dotActive,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
