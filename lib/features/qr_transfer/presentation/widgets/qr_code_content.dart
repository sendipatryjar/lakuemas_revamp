import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cores/constants/img_assets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../blocs/balance/balance_bloc.dart';

class QRCodeContent extends StatelessWidget {
  final ScreenshotController screenshotController;
  const QRCodeContent({super.key, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: clrBackgroundBlack,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Tunjukkan QR kamu untuk\nmemudahkan Transfer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: constraint.maxHeight / 3.5),
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 240,
                  height: 240,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: clrWhite,
                  ),
                  child: BlocBuilder<QRTransferBalanceBloc,
                      QRTransferBalanceState>(
                    builder: (context, state) {
                      if (state is QRTransferLoadingState) {
                        return Shimmer.fromColors(
                          baseColor: clrGreyShimmerBase,
                          highlightColor: clrGreyShimmerHighlight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: clrYellow,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      }
                      if (state is QRTransferSuccessState) {
                        return QrImageView(
                          data:
                              '${state.goldBalanceEntity?.accountNumber}|${state.name}|LAKUEMAS',
                          version: QrVersions.auto,
                          size: double.infinity,
                          gapless: false,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                          embeddedImage: const AssetImage(imgLogoVert),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(40, 40),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'Cannot Display QR Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: clrBackgroundBlack,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
