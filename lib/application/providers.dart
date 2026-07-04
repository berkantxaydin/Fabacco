import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logger_service.dart';
import '../domain/models.dart';
import '../domain/facility_models.dart';
import '../data/mock_repositories.dart';

// --- Core Services ---
final loggerProvider = Provider<LoggerService>((ref) {
  final logger = LoggerService();
  ref.onDispose(() => logger.dispose());
  return logger;
});

// --- Repositories ---
final promoRepoProvider = Provider((ref) => MockPromoRepository());
final authRepoProvider = Provider((ref) => MockAuthRepository());
final facilityRepoProvider = Provider((ref) => MockFacilityRepository());

// --- Promos & Facilities State ---
final promosProvider = FutureProvider<List<Promo>>((ref) async {
  return ref.read(promoRepoProvider).fetchPromos();
});

final selectedLocationProvider = StateProvider<String>((ref) => 'Cevahir');

final facilitiesProvider = FutureProvider<List<FacilityCategory>>((ref) async {
  final location = ref.watch(selectedLocationProvider);
  return ref.read(facilityRepoProvider).fetchFacilitiesForLocation(location);
});

// --- Auth & Account State ---
// Holds the logged-in user. Null means not logged in.
final authProvider =
    NotifierProvider<AuthNotifier, AccountInfo?>(AuthNotifier.new);

class AuthNotifier extends Notifier<AccountInfo?> {
  @override
  AccountInfo? build() => null; // Start logged out

  Future<void> login(UserRole role) async {
    ref
        .read(loggerProvider)
        .log('Attempting login as ${role.name}...', level: LogLevel.info);
    state = await ref.read(authRepoProvider).login(role);
    ref
        .read(loggerProvider)
        .log('Login successful: ${state!.name}', level: LogLevel.info);
  }

  void logout() {
    state = null;
    ref.read(loggerProvider).log('User logged out.', level: LogLevel.warning);
  }

  void consumeMassage() {
    if (state == null || state!.massageCount <= 0) return;
    final newCount = state!.massageCount - 1;
    state = state!.copyWith(massageCount: newCount);

    ref
        .read(loggerProvider)
        .log('Massage consumed. $newCount left.', level: LogLevel.warning);
    if (newCount < 2 && state!.role != UserRole.admin) {
      ref.read(loggerProvider).log(
          'RED ALERT: Massage quota running critically low!',
          level: LogLevel.error);
    }
  }

  void consumeHamam() {
    if (state == null || state!.hamamCount <= 0) return;
    final newCount = state!.hamamCount - 1;
    state = state!.copyWith(hamamCount: newCount);
    ref
        .read(loggerProvider)
        .log('Hamam entry used. $newCount left.', level: LogLevel.info);
  }
}
