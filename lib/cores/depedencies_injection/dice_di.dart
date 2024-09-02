import '../../features/dice/data/data_sources/dice_remote_data_source.dart';
import '../../features/dice/data/data_sources/interfaces/i_dice_remote_data_source.dart';
import '../../features/dice/data/repositories/dice_repository.dart';
import '../../features/dice/domain/repositories/i_dice_repository.dart';
import '../../features/dice/domain/usecases/dice_gatcha_uc.dart';
import '../../features/dice/presentation/blocs/bloc/dice_gatcha_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IDiceRemoteDataSource>(() => DiceRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IDiceRepository>(() => DiceRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => DiceGatchaUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => DiceGatchaBloc(diceGatchaUc: sl()));

  //! cubit
}
