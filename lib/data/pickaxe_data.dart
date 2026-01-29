class PickaxeData {
  int damage;
  int level;

  PickaxeData._({required this.damage, required this.level}) {

  }

  factory  PickaxeData.fromJson(Map<String, dynamic> json) {
    return  PickaxeData._(damage: json['damage'] as int, level:  json['level'] as int);
  }


  Map<String, dynamic> toJson() {
    return {
      'damage': damage,
      'level': level
    };
  }
}