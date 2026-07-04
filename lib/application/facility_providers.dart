class Person {
  final String name;
  final String roleOrStatus;

  Person({required this.name, required this.roleOrStatus});
}

class FacilityItem {
  final String id;
  final String title;
  final int count;
  final String description;
  final String imageUrl;
  final List<Person> staff; // Only used for the Workers tab now

  FacilityItem({
    required this.id,
    required this.title,
    required this.count,
    required this.description,
    required this.imageUrl,
    this.staff = const [],
  });
}

class FacilityCategory {
  final String title;
  final List<FacilityItem> items;

  FacilityCategory({required this.title, required this.items});
}
