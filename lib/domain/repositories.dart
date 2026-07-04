import 'models.dart';

abstract class PromoRepository {
  Future<List<Promo>> fetchPromos();
}

abstract class AccountRepository {
  Future<AccountInfo> fetchAccountInfo();
}

abstract class AnalyticsRepository {
  Future<void> logEvent(String eventName, Map<String, dynamic> payload);
}
