import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';

class NavigationScreen extends StatelessWidget {
  final Widget content;
  const NavigationScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBackgroundBlack : null,
          floatingActionButton: SizedBox(
            width: 72,
            height: 72,
            child: FittedBox(
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  // context.read<EliteCubit>().change(!state);
                  context.goNamed(
                    AppRoutes.qrTransfer,
                    extra: {
                      'isElite': isElite.toString(),
                      'berandaBalancesBloc':
                          context.read<BerandaBalancesBloc>(),
                    },
                  );
                },
                backgroundColor: clrYellow,
                child: Image.asset(
                  width: 32,
                  height: 32,
                  icMenuScan,
                  color: clrBackgroundBlack,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: isElite ? clrBlack080 : clrWhiteFef,
              notchMargin: 8,
              child: SizedBox(
                height: 72,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          // const Spacer(),
                          Expanded(
                            child: navbarIcon(
                              // iconData: Icons.home,
                              icon: icMenuHome,
                              title: 'Beranda',
                              isSelected:
                                  GoRouterState.of(context).uri.toString() ==
                                      '/${AppRoutes.beranda}',
                              onPressed: () {
                                context.goNamed(AppRoutes.beranda);
                              },
                            ),
                          ),
                          // const Spacer(),
                          Expanded(
                            child: navbarIcon(
                              icon: icMenuPortofolio,
                              title: 'Portofolio',
                              isSelected:
                                  GoRouterState.of(context).uri.toString() ==
                                      '/${AppRoutes.portofolio}',
                              onPressed: () {
                                context.goNamed(AppRoutes.portofolio);
                              },
                            ),
                          ),
                          // const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 6),
                          const SizedBox(height: 28),
                          const SizedBox(height: 4),
                          Text(
                            'QR Transfer',
                            style: TextStyle(
                              color: clrNeutralGrey999.withOpacity(0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: navbarIcon(
                              icon: icMenuElite,
                              title: 'Elite',
                              isSelected:
                                  GoRouterState.of(context).uri.toString() ==
                                      '/${AppRoutes.elite}',
                              onPressed: () {
                                context.goNamed(AppRoutes.elite);
                              },
                            ),
                          ),
                          Expanded(
                            child: navbarIcon(
                              icon: icMenuProfile,
                              title: 'Profile',
                              isSelected:
                                  GoRouterState.of(context).uri.toString() ==
                                      '/${AppRoutes.profile}',
                              onPressed: () {
                                context.goNamed(AppRoutes.profile);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: content,
        );
      },
    );
  }

  Widget navbarIcon({
    required String icon,
    required String title,
    bool isSelected = false,
    Function()? onPressed,
  }) {
    return MaterialButton(
      minWidth: 40,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 6),
          Image.asset(
            icon,
            height: 28,
            width: 28,
            color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: clrNeutralGrey999.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
