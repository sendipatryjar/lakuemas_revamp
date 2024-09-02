import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../features/pin/presentation/blocs/pin/pin_bloc.dart';

import '../cubits/pin_typing/pin_typing_cubit.dart';
import 'numpad_button_widget.dart';

class NumpadWidget extends StatelessWidget {
  const NumpadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double widthSpace = 24;
    const double heightSpace = 0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "1",
                        onPressed: () => context.read<PinTypingCubit>().add(1),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "2",
                        onPressed: () => context.read<PinTypingCubit>().add(2),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "3",
                        onPressed: () => context.read<PinTypingCubit>().add(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: heightSpace),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "4",
                        onPressed: () => context.read<PinTypingCubit>().add(4),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "5",
                        onPressed: () => context.read<PinTypingCubit>().add(5),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "6",
                        onPressed: () => context.read<PinTypingCubit>().add(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: heightSpace),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "7",
                        onPressed: () => context.read<PinTypingCubit>().add(7),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "8",
                        onPressed: () => context.read<PinTypingCubit>().add(8),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "9",
                        onPressed: () => context.read<PinTypingCubit>().add(9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: heightSpace),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: NumpadButtonWidget(
                        num: "0",
                        onPressed: () => context.read<PinTypingCubit>().add(0),
                      ),
                    ),
                    const SizedBox(width: widthSpace),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.backspace_outlined,
                          color: clrWhite,
                        ),
                        onPressed: () {
                          context.read<PinTypingCubit>().erase();
                          context
                              .read<PinBloc>()
                              .add(PinInitialFromErrorEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: heightSpace),
          ],
        ),
      ),
    );
  }
}
