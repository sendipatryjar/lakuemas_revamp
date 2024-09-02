import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import 'page_indicator/effects/expanding_dots_effect.dart';
import 'page_indicator/smooth_page_indicator.dart';

class MainCarousel extends StatefulWidget {
  final PageController controller;
  final List<Widget> contents;
  final bool isAutoScroll;
  final int autoScrollDelayInSec;
  final bool isArrow;
  final bool isDots;
  final bool isDotsInStack;
  final bool isElite;
  const MainCarousel({
    super.key,
    required this.controller,
    this.contents = const [],
    this.isAutoScroll = false,
    this.autoScrollDelayInSec = 10,
    this.isArrow = true,
    this.isDots = true,
    this.isDotsInStack = true,
    this.isElite = false,
  });

  @override
  State<MainCarousel> createState() => _MainCarouselState();
}

class _MainCarouselState extends State<MainCarousel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.isAutoScroll) {
      _timer = Timer.periodic(
        Duration(seconds: widget.autoScrollDelayInSec),
        (Timer timer) {
          nextPage();
        },
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: widget.controller,
                itemCount: widget.contents.length,
                itemBuilder: (context, index) {
                  return widget.contents[index];
                },
              ),
              if (widget.isDotsInStack && widget.isDots)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SmoothPageIndicator(
                      controller: widget.controller,
                      count: widget.contents.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        dotColor: clrGrey666.withOpacity(0.4),
                        activeDotColor: (widget.isElite ? clrWhite : clrGrey666)
                            .withOpacity(0.75),
                      ),
                    ),
                  ),
                ),
              if (widget.isArrow)
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: clrGrey666.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                      child: InkWell(
                        onTap: nextPage,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: clrGrey666,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.isArrow)
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: clrGrey666.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: InkWell(
                        onTap: previousPage,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, bottom: 10),
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: clrGrey666,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        if (widget.isDotsInStack == false && widget.isDots)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: SmoothPageIndicator(
                controller: widget.controller,
                count: widget.contents.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  dotColor: clrGrey666.withOpacity(0.4),
                  activeDotColor: (widget.isElite ? clrWhite : clrGrey666)
                      .withOpacity(0.75),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void nextPage() {
    final lastPage = widget.contents.length - 1;
    final currPage = widget.controller.page ?? lastPage;
    if (currPage < lastPage) {
      widget.controller.animateToPage((widget.controller.page ?? 0).toInt() + 1,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    } else {
      widget.controller.animateToPage((0).toInt(),
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  void previousPage() {
    final lastPage = widget.contents.length - 1;
    final currPage = widget.controller.page ?? 0;
    if (currPage <= 0) {
      widget.controller.animateToPage((lastPage).toInt(),
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    } else {
      widget.controller.animateToPage((widget.controller.page ?? 0).toInt() - 1,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }
}
