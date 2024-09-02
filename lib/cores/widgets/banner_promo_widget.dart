import 'package:flutter/material.dart';

import '../../features/beranda/presentation/widgets/register_elite_banner.dart';
import '../constants/img_assets.dart';
import 'main_carousel.dart';

class BannerPromoWidget extends StatelessWidget {
  final bool isEliteMode;
  final double height;
  final List<Widget> contents;
  final bool isAutoScroll;
  final int autoScrollDelayInSec;
  final bool isFromGrafik;
  const BannerPromoWidget({
    super.key,
    this.isEliteMode = false,
    this.height = 192,
    this.contents = const [],
    this.isAutoScroll = true,
    this.autoScrollDelayInSec = 10,
    this.isFromGrafik = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 1, keepPage: true);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isEliteMode ? imgBackgroundBlack : imgBackgroundGold,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: MainCarousel(
        controller: controller,
        isAutoScroll: isAutoScroll,
        autoScrollDelayInSec: autoScrollDelayInSec,
        contents: [
          RegisterEliteBanner(
            isElite: isEliteMode,
            isFromGrafik: isFromGrafik,
          ),
          ...contents,
        ],
      ),
    );
  }
}
