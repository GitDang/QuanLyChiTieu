class CategoryModel {
  int id;
  String name;
  String icon;
  String color;
  int type;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon = "",
    this.color = "",
    this.type = 1,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        color: json['color'],
        type: json['type'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'type': type,
      };
}
