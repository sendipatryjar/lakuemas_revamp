import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_color.dart';
import '../../constants/img_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/cubits/elite/elite_cubit.dart';
import '../../utils/text_utils.dart';
import '../main_button.dart';

class ServerErrorScreen extends StatelessWidget {
  final Function()? onTryAgainPressed;
  const ServerErrorScreen({super.key, this.onTryAgainPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isElite ? clrBlack101 : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "500",
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 64,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Server Error",
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              Image.asset(
                imgErrorServer,
                height: 200,
                width: 335,
              ),
              const SizedBox(height: 32),
              Text(
                "Maaf, terjadi kesalahan internal pada server. Kami sedang berusaha memperbaiki masalah ini secepat mungkin.",
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(height: 32),
              if (onTryAgainPressed != null) ...[
                MainButton(
                  label: "coba lagi",
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: clrBackgroundBlack,
                  ),
                  bgColor: clrWhite,
                  border: BorderSide(
                    width: 2,
                    color: clrYellow,
                  ),
                  onPressed: onTryAgainPressed,
                ),
                const SizedBox(height: 16),
              ],
              MainButton(
                label: "kembali ke beranda",
                onPressed: () {
                  context.goNamed(AppRoutes.beranda);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
