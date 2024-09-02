import '../../features/profile/data/data_sources/address_remote_data_source.dart';
import '../../features/profile/data/data_sources/interfaces/i_address_remote_data_source.dart';
import '../../features/profile/data/data_sources/interfaces/i_profile_local_data_source.dart';
import '../../features/profile/data/data_sources/interfaces/i_profile_remote_data_source.dart';
import '../../features/profile/data/data_sources/profile_local_data_source.dart';
import '../../features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/address_repository.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/i_address_repository.dart';
import '../../features/profile/domain/repositories/i_profile_repository.dart';
import '../../features/profile/domain/usecases/change_password_uc.dart';
import '../../features/profile/domain/usecases/change_pin_uc.dart';
import '../../features/profile/domain/usecases/get_cities_uc.dart';
import '../../features/profile/domain/usecases/get_countries_uc.dart';
import '../../features/profile/domain/usecases/get_detail_district_uc.dart';
import '../../features/profile/domain/usecases/get_districts_uc.dart';
import '../../features/profile/domain/usecases/get_provinces_uc.dart';
import '../../features/profile/domain/usecases/get_terms_and_conditions_profile_uc.dart';
import '../../features/profile/domain/usecases/get_user_data_uc.dart';
import '../../features/profile/domain/usecases/update_address_uc.dart';
import '../../features/profile/domain/usecases/update_user_data_uc.dart';
import '../../features/profile/presentation/blocs/change_password/change_password_bloc.dart';
import '../../features/profile/presentation/blocs/change_pin/change_pin_bloc.dart';
import '../../features/profile/presentation/blocs/city/home/home_city_bloc.dart';
import '../../features/profile/presentation/blocs/city/mail/mail_city_bloc.dart';
import '../../features/profile/presentation/blocs/country/country_bloc.dart';
import '../../features/profile/presentation/blocs/detail_district/detail_district_bloc.dart';
import '../../features/profile/presentation/blocs/detail_district/home/home_district_bloc.dart';
import '../../features/profile/presentation/blocs/detail_district/mail/mail_district_bloc.dart';
import '../../features/profile/presentation/blocs/district/home/home_district_bloc.dart';
import '../../features/profile/presentation/blocs/district/mail/mail_district_bloc.dart';
import '../../features/profile/presentation/blocs/profile/profile_bloc.dart';
import '../../features/profile/presentation/blocs/profile_address_update/profile_address_update_bloc.dart';
import '../../features/profile/presentation/blocs/profile_update/profile_update_bloc.dart';
import '../../features/profile/presentation/blocs/province/home/home_province_bloc.dart';
import '../../features/profile/presentation/blocs/province/mail/mail_province_bloc.dart';
import '../../features/profile/presentation/blocs/terms_and_conditions_profile/terms_and_conditions_profile_bloc.dart';
import '../../features/profile/presentation/cubits/address_data/address_data_cubit.dart';
import '../../features/profile/presentation/cubits/change_password_validation/change_password_validation_cubit.dart';
import '../../features/profile/presentation/cubits/change_pin_validation/change_pin_validation_cubit.dart';
import '../../features/profile/presentation/cubits/change_username_validation/change_username_validation_cubit.dart';
import '../../features/profile/presentation/cubits/income_data_update/income_data_update_cubit.dart';
import '../../features/profile/presentation/cubits/self_data_update/self_data_update_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IProfileRemoteDataSource>(() => ProfileRemoteDataSource(
        apiService: sl(),
      ));
  sl.registerFactory<IProfileLocalDataSource>(() => ProfileLocalDataSource(
        secureStorageService: sl(),
      ));
  sl.registerFactory<IAddressRemoteDataSource>(() => AddressRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<IProfileRepository>(() => ProfileRepository(
        remoteDataSource: sl(),
        localDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));
  sl.registerFactory<IAddressRepository>(() => AddressRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetUserDataUc(repository: sl()));
  sl.registerFactory(() => UpdateUserDataUc(repository: sl()));
  sl.registerFactory(() => ChangePasswordUc(repository: sl()));
  sl.registerFactory(() => ChangePinUc(repository: sl()));
  sl.registerFactory(() => GetCountriesUc(repository: sl()));
  sl.registerFactory(() => GetProvincesUc(repository: sl()));
  sl.registerFactory(() => GetCitiesUc(repository: sl()));
  sl.registerFactory(() => GetDistrictsUc(repository: sl()));
  sl.registerFactory(() => UpdateAddressUc(repository: sl()));
  sl.registerFactory(() => GetTermsAndConditionsProfileUc(repository: sl()));
  sl.registerFactory(() => GetDetailDistrictUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => ProfileBloc(
        // eliteCubit: sl(),
        getUserDataUc: sl(),
      ));
  sl.registerFactory(() => ProfileUpdateBloc(
        getUserDataUc: sl(),
        updateUserDataUc: sl(),
      ));
  sl.registerFactory(() => ChangePasswordBloc(
        changePasswordUc: sl(),
      ));
  sl.registerFactory(() => ChangePinBloc(
        changePinUc: sl(),
      ));
  sl.registerFactory(() => CountryBloc(
        getCountriesUc: sl(),
      ));
  sl.registerFactory(() => HomeProvinceBloc(
        getProvincesUc: sl(),
      ));
  sl.registerFactory(() => MailProvinceBloc(
        getProvincesUc: sl(),
      ));
  sl.registerFactory(() => HomeCityBloc(
        getCitiesUc: sl(),
      ));
  sl.registerFactory(() => MailCityBloc(
        getCitiesUc: sl(),
      ));

  sl.registerFactory(() => HomeDistrictBloc(
        getDistrictsUc: sl(),
      ));
  sl.registerFactory(() => MailDistrictBloc(
        getDistrictsUc: sl(),
      ));
  sl.registerFactory(() => ProfileAddressUpdateBloc(
        updateAddressUc: sl(),
      ));
  sl.registerFactory(() => TAndCProfileBloc(
        getTermsAndConditionsProfileUc: sl(),
      ));
  sl.registerFactory(() => DetailDistrictBloc(
        getDetailDistrictUc: sl(),
      ));
  sl.registerFactory(() => HomeDetailDistrictBloc(
        getDetailDistrictUc: sl(),
      ));
  sl.registerFactory(() => MailDetailDistrictBloc(
        getDetailDistrictUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => SelfDataUpdateCubit(
        getUserDataUc: sl(),
      ));
  sl.registerFactory(() => IncomeDataUpdateCubit(getUserDataUc: sl()));
  sl.registerFactory(() => ChangePasswordValidationCubit());
  sl.registerFactory(() => ChangePinValidationCubit());
  sl.registerFactory(() => AddressDataCubit());
  sl.registerFactory(() => ChangeUsernameValidationCubit());
}
