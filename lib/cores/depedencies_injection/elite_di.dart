import '../../features/elite/data/data_sources/elite_remote_data_source.dart';
import '../../features/elite/data/data_sources/interfaces/i_elite_remote_data_source.dart';
import '../../features/elite/data/repositories/elite_repository.dart';
import '../../features/elite/domain/repositories/i_elite_repository.dart';
import '../../features/elite/domain/usecases/elite_history_uc.dart';
import '../../features/elite/domain/usecases/elite_me_uc.dart';
import '../../features/elite/domain/usecases/elite_uc.dart';
import '../../features/elite/domain/usecases/get_list_referral_uc.dart';
import '../../features/elite/domain/usecases/get_my_offer_uc.dart';
import '../../features/elite/domain/usecases/get_my_offers_uc.dart';
import '../../features/elite/domain/usecases/get_offer_uc.dart';
import '../../features/elite/domain/usecases/get_offers_uc.dart';
import '../../features/elite/domain/usecases/get_social_media_config_uc.dart';
import '../../features/elite/domain/usecases/get_voucher_referral_uc.dart';
import '../../features/elite/domain/usecases/redeem_offer_uc.dart';
import '../../features/elite/domain/usecases/unsub_elite_uc.dart';
import '../../features/elite/presentation/blocs/elite_blocs.dart';
import '../../features/elite/presentation/blocs/elite_history/elite_history_bloc.dart';
import '../../features/elite/presentation/blocs/elite_me/elite_me_bloc.dart';
import '../../features/elite/presentation/blocs/get_my_offers/get_my_offers_bloc.dart';
import '../../features/elite/presentation/blocs/get_offer/get_offer_bloc.dart';
import '../../features/elite/presentation/blocs/get_offers/get_offers_bloc.dart';
import '../../features/elite/presentation/blocs/get_social_media_config/get_social_media_config_bloc.dart';
import '../../features/elite/presentation/blocs/get_voucher_referral/get_voucher_referral_bloc.dart';
import '../../features/elite/presentation/blocs/redeem_offer/redeem_offer_bloc.dart';
import '../../features/elite/presentation/blocs/unsub_elite/unsub_elite_bloc.dart';
import '../../features/elite/presentation/cubits/elite_cubits.dart';
import '../../features/elite/presentation/cubits/elite_history/elite_history_cubit.dart';
import '../../features/elite/presentation/cubits/elite_unsub_validation/elite_unsub_validation_cubit.dart';
import '../services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IEliteRemoteDataSource>(
      () => EliteRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IEliteRepository>(() => EliteRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetFaqUc(repository: sl()));
  sl.registerFactory(() => GetTermsConditionsUc(repository: sl()));
  sl.registerFactory(() => GetMarketingOptionUc(repository: sl()));
  sl.registerFactory(() => SubscriptionPackagesUc(repository: sl()));
  sl.registerFactory(() => EliteStartRegisterUc(repository: sl()));
  sl.registerFactory(() => ElitePaymentMethodUc(repository: sl()));
  sl.registerFactory(() => EliteRegisterUc(repository: sl()));
  sl.registerFactory(() => EliteConfirmRegisterUc(repository: sl()));
  sl.registerFactory(() => EliteReferalValidationUc(repository: sl()));
  sl.registerFactory(() => EliteActivationCodeValidationUc(repository: sl()));
  sl.registerFactory(() => EliteMeUc(repository: sl()));
  sl.registerFactory(() => EliteHistoryUc(repository: sl()));
  sl.registerFactory(() => GetOffersUc(repository: sl()));
  sl.registerFactory(() => GetOfferUc(repository: sl()));
  sl.registerFactory(() => GetMyOffersUc(repository: sl()));
  sl.registerFactory(() => GetMyOfferUc(repository: sl()));
  sl.registerFactory(() => RedeemOfferUc(repository: sl()));
  sl.registerFactory(() => UnsubEliteUc(repository: sl()));
  sl.registerFactory(() => GetVoucherReferralUc(repository: sl()));
  sl.registerFactory(() => GetSocialMediaConfigUc(repository: sl()));
  sl.registerFactory(() => GetListReferralUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => GetFaqBloc(getFaqUc: sl()));
  sl.registerFactory(() => GetTermsConditionsBloc(getTermsConditionsUc: sl()));
  sl.registerFactory(() => GetMarketingOptionBloc(getMarketingOptionUc: sl()));
  sl.registerFactory(
      () => SubscriptionPackagesBloc(getSubscriptionPackagesUc: sl()));
  sl.registerFactory(() => EliteStartRegisterBloc(eliteStartRegisterUc: sl()));
  sl.registerFactory(() => ElitePaymentMethodBloc(elitePaymentMethodUc: sl()));
  sl.registerFactory(() => EliteRegisterBloc(eliteRegisterUc: sl()));
  sl.registerFactory(
      () => EliteConfirmRegisterBloc(eliteConfirmRegisterUc: sl()));
  sl.registerFactory(
      () => EliteReferalValidationBloc(eliteReferalValidationUc: sl()));
  sl.registerFactory(
      () => EliteActivationCodeBloc(eliteActivationCodeValidationUc: sl()));
  sl.registerFactory(() => EliteMeBloc(eliteMeUc: sl()));
  sl.registerFactory(() => EliteHistoryBloc(
        eliteHistoryUc: sl(),
        getListReferralUc: sl(),
      ));
  sl.registerFactory(() => GetOffersBloc(getOffersUc: sl()));
  sl.registerFactory(() => GetOfferBloc(
        getOfferUc: sl(),
        getMyOfferUc: sl(),
      ));
  sl.registerFactory(() => GetMyOffersBloc(getMyOffersUc: sl()));
  sl.registerFactory(() => RedeemOfferBloc(redeemOfferUc: sl()));
  sl.registerFactory(() => UnsubEliteBloc(unsubEliteUc: sl()));
  sl.registerFactory(() => GetVoucherReferralBloc(getVoucherReferralUc: sl()));
  sl.registerFactory(
      () => GetSocialMediaConfigBloc(getSocialMediaConfigUc: sl()));

  //! cubit
  sl.registerFactory(() => HelperDataEliteCubit());
  sl.registerFactory(() => SubscriptionMethodCubit());
  sl.registerFactory(() => SubscriptionPackagesCubit());
  sl.registerFactory(() => SelectPaymentCubit());
  sl.registerFactory(() => EliteReferalValidationCubit());
  sl.registerFactory(() => EliteActivationCodeValidationCubit());
  sl.registerFactory(() => EliteOrderDetailsValidationCubit());
  sl.registerFactory(() => EliteUnsubValidationCubit());
  sl.registerFactory(() => EliteHistoryCubit());
}
