import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/logger_service.dart';
import '../domain/models.dart';
import '../domain/facility_models.dart';
import '../data/mock_repositories.dart';

final loggerProvider = Provider<LoggerService>((ref) {
  final logger = LoggerService();
  ref.onDispose(() => logger.dispose());
  return logger;
});

final promoRepoProvider = Provider((ref) => MockPromoRepository());
final authRepoProvider = Provider((ref) => MockAuthRepository());
final facilityRepoProvider = Provider((ref) => MockFacilityRepository());

final promosProvider = FutureProvider<List<Promo>>(
    (ref) => ref.read(promoRepoProvider).fetchPromos());
final massageTypesProvider = FutureProvider<List<MassageType>>(
    (ref) => ref.read(promoRepoProvider).fetchMassageTypes());

final selectedLocationProvider = StateProvider<String>((ref) => 'Cevahir');
final facilitiesProvider = FutureProvider<List<FacilityCategory>>((ref) async {
  final location = ref.watch(selectedLocationProvider);
  return ref.read(facilityRepoProvider).fetchFacilitiesForLocation(location);
});

// --- Admin Analytics State ---
final adminStatsProvider =
    NotifierProvider<AdminStatsNotifier, AdminStats>(AdminStatsNotifier.new);

class AdminStatsNotifier extends Notifier<AdminStats> {
  @override
  AdminStats build() => AdminStats();

  void incrementMassage() =>
      state = state.copyWith(totalMassagesUsed: state.totalMassagesUsed + 1);
  void incrementHamam() =>
      state = state.copyWith(totalHamamUsed: state.totalHamamUsed + 1);
  void incrementPromo() =>
      state = state.copyWith(totalPromoClicks: state.totalPromoClicks + 1);

  void addAlert(String message) {
    final time = DateFormat('HH:mm').format(DateTime.now());
    state = state.copyWith(alerts: ['[$time] $message', ...state.alerts]);
  }
}

// --- Auth & User State ---
final authProvider =
    NotifierProvider<AuthNotifier, AccountInfo?>(AuthNotifier.new);

class AuthNotifier extends Notifier<AccountInfo?> {
  @override
  AccountInfo? build() => null;

  Future<void> login(UserRole role) async {
    state = await ref.read(authRepoProvider).login(role);
    ref
        .read(loggerProvider)
        .log('Logged in as ${state!.name}', level: LogLevel.info);
  }

  void logout() => state = null;

  void consumeMassage() {
    if (state == null ||
        state!.role == UserRole.admin ||
        state!.massageCount <= 0) return;

    final newCount = state!.massageCount - 1;
    state = state!.copyWith(massageCount: newCount);

    // Update Admin Stats
    ref.read(adminStatsProvider.notifier).incrementMassage();
    ref.read(loggerProvider).log('Guest used a massage.', level: LogLevel.info);

    // Trigger Admin Alert if quota is low
    if (newCount <= 1) {
      ref.read(adminStatsProvider.notifier).addAlert(
          'Guest ${state!.name} is running critically low on massages ($newCount left).');
      ref
          .read(loggerProvider)
          .log('RED ALERT: Guest quota low!', level: LogLevel.error);
    }
  }

  void consumeHamam() {
    if (state == null ||
        state!.role == UserRole.admin ||
        state!.hamamCount <= 0) return;

    state = state!.copyWith(hamamCount: state!.hamamCount - 1);
    ref.read(adminStatsProvider.notifier).incrementHamam();
    ref.read(loggerProvider).log('Guest entered Hamam.', level: LogLevel.info);
  }
}
