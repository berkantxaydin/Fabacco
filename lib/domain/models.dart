class Promo {
  final String id;
  final String title;
  final String description;
  final String detailedDescription;
  final String imageAsset;
  final DateTime endTime;
  final int remainingQuota;

  Promo({
    required this.id,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.imageAsset,
    required this.endTime,
    required this.remainingQuota,
  });
}

class MassageType {
  final String name;
  final String benefits;

  MassageType({required this.name, required this.benefits});
}

// Global stats tracker for the Admin Panel
class AdminStats {
  final int totalMassagesUsed;
  final int totalHamamUsed;
  final int totalPromoClicks;
  final List<String> alerts; // Holds notifications like "User running low!"

  AdminStats({
    this.totalMassagesUsed = 0,
    this.totalHamamUsed = 0,
    this.totalPromoClicks = 0,
    this.alerts = const [],
  });

  AdminStats copyWith({
    int? totalMassagesUsed,
    int? totalHamamUsed,
    int? totalPromoClicks,
    List<String>? alerts,
  }) {
    return AdminStats(
      totalMassagesUsed: totalMassagesUsed ?? this.totalMassagesUsed,
      totalHamamUsed: totalHamamUsed ?? this.totalHamamUsed,
      totalPromoClicks: totalPromoClicks ?? this.totalPromoClicks,
      alerts: alerts ?? this.alerts,
    );
  }
}

enum UserRole { admin, user }

class AccountInfo {
  final String userId;
  final String name;
  final UserRole role;
  final int hamamCount;
  final int massageCount;

  AccountInfo({
    required this.userId,
    required this.name,
    required this.role,
    required this.hamamCount,
    required this.massageCount,
  });

  AccountInfo copyWith({int? hamamCount, int? massageCount}) {
    return AccountInfo(
      userId: userId,
      name: name,
      role: role,
      hamamCount: hamamCount ?? this.hamamCount,
      massageCount: massageCount ?? this.massageCount,
    );
  }
}
