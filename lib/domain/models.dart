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
