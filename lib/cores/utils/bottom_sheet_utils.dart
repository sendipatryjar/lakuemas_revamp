import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_color.dart';
import '../routes/app_routes.dart';
import '../services/cubits/elite/elite_cubit.dart';
import '../widgets/main_button.dart';
import 'app_utils.dart';

class BottomSheetUtils {
  static Future<T?> general<T>({
    required BuildContext context,
    bool useRootNavigator = true,
    bool isDismissible = true,
    double topBorder = 30,
    double? height,
    Color? bgColor,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 32,
    ),
    String? titleText,
    Color? titleTextColor,
    required Widget content,
  }) async {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topBorder),
        ),
      ),
      builder: (context) {
        return Container(
          padding: padding,
          // height: height ?? MediaQuery.of(context).size.height * 0.5,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(topBorder),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (titleText != null) ...[
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleTextColor,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              content,
            ],
          ),
        );
      },
    );
  }

  static verification({
    required BuildContext context,
    String? words,
  }) {
    return general(
      context: context,
      height: 240,
      titleText: 'Verifikasi akun kamu belum lengkap nih!',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            words ??
                'Ayo verifikasi akunmu sekarang agar dapat menggunakan seluruh fitur di aplikasi LakuEmas',
          ),
          // const Spacer(),
          const SizedBox(height: 32),
          MainButton(
            label: 'Verifikasi Sekarang',
            // bgColor: clrYellow,
            onPressed: () {
              context.goNamed(
                AppRoutes.accountVerification,
                extra: {
                  'isElite': context.read<EliteCubit>().state.toString(),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  static contactUs({
    required BuildContext context,
    String? titleText,
    String? bodyText,
    String? phoneNumber,
  }) {
    return general(
      context: context,
      titleText: titleText,
      content: Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bodyText ?? '',
              ),
              // const Spacer(),
              const SizedBox(height: 32),
              MainButton(
                label: 'Hubungi Customer Service',
                // bgColor: clrYellow,
                leadingWidget: Icon(
                  Icons.headphones,
                  color: clrBackgroundBlack,
                ),
                onPressed: () {
                  AppUtils.phoneCall(phoneNumber ?? '021-21243873');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static underConstruction({
    required BuildContext context,
  }) {
    return general(
      context: context,
      height: 240,
      titleText: 'Dalam Pengembangan',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Mohon maaf saat ini fitur yang kamu pilih sedang dalam pengembangan. Silahkan coba fitur lain',
          ),
          // const Spacer(),
          const SizedBox(height: 32),
          MainButton(
            label: 'Tutup',
            // bgColor: clrYellow,
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
