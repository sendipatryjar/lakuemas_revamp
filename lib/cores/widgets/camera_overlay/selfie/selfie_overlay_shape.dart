import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../id_card/overlay_model.dart';

class SelfieOverlayShape extends StatelessWidget {
  const SelfieOverlayShape(this.model, {Key? key}) : super(key: key);

  final OverlayModel model;

  @override
  Widget build(BuildContext context) {
    final bgColor = clr000000.withOpacity(0.7);
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;

    double ratio = model.ratio as double;
    double height = width / ratio;
    double radius =
        model.cornerRadius == null ? 0 : model.cornerRadius! * height;
    double heightFace = (width / ratio) * 1.05;
    double widthFace = width / 2;
    double heightCard = width / ratio / 2;
    double widthCard = width / 2;
    if (media.orientation == Orientation.portrait) {}
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            // height: 24,
            width: double.infinity,
            color: bgColor,
          ),
        ),
        Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: widthFace,
                  height: heightFace,
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(360),
                      side: const BorderSide(width: 1, color: Colors.white),
                    ),
                  ),
                )),
            ColorFiltered(
              colorFilter: ColorFilter.mode(bgColor, BlendMode.srcOut),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: widthFace,
                        height: heightFace,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(360),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 40,
          width: double.infinity,
          color: bgColor,
        ),
        Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  width: widthCard,
                  height: heightCard,
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                      side: const BorderSide(width: 1, color: Colors.white),
                    ),
                  ),
                )),
            ColorFiltered(
              colorFilter: ColorFilter.mode(bgColor, BlendMode.srcOut),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: widthCard,
                        height: heightCard,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            color: bgColor,
          ),
        ),
      ],
    );
  }
}
