class Person {
  final String name;
  final String roleOrStatus;

  Person({required this.name, required this.roleOrStatus});
}

class FacilityItem {
  final String id;
  final String title;
  final String description;
  final String
      imageAsset; // Changed to load local images like assets/single1.png

  final List<Person> staff;
  final List<Person> occupants;

  FacilityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.staff = const [],
    this.occupants = const [],
  });
}

class FacilityCategory {
  final String title;
  final List<FacilityItem> items;

  FacilityCategory({required this.title, required this.items});
}
