import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/support_contact_model.dart';
import '../../models/support_faq_model.dart';

abstract class ISupportRemoteDataSource {
  Future<BaseListResp<SupportFaqModel>> getFaq({
    String? accessToken,
    String? refreshToken,
    String? keyword,
  });
  Future<BaseResp<SupportContactModel>> getSupportContacts({
    String? accessToken,
    String? refreshToken,
  });
}
