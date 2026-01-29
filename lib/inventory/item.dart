class Item {
  final String id;
  final String name;
  int count;

  Item({required this.id, required this.count, required this.name}) {

  }


  /// Factory constructor to create an Item from a JSON object.
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      count: json['count'] as int,
      name: json['name'] as String,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}