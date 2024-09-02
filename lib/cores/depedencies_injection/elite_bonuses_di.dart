import '../../features/elite_bonuses/presentation/cubits/elite_bonuses_tab/elite_bonuses_tab_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources

  //! repositories

  //! usecases

  //! bloc

  //! cubit
  sl.registerFactory(() => EliteBonusesTabCubit());
}
