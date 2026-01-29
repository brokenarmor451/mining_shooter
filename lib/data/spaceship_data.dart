class SpaceshipData {
  int attack;
  int bullet;
  int health;
  int attackLevel;
  int healthLevel;
  int bulletLevel;
  final speed = 5.0;

  SpaceshipData._({
    required this.attack,
    required this.health,
    required this.attackLevel,
    required this.healthLevel,
    required this.bullet,
    required this.bulletLevel
  });

  factory SpaceshipData.fromJson(Map<String, dynamic> json) {
    return SpaceshipData._(
      attack: json['attack'] as int,
      health: json['health'] as int,
      attackLevel: json['attack_level'] as int,
      healthLevel: json['health_level'] as int,
      bulletLevel: json['bullet_level'] as int,
      bullet: json['bullet'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attack': attack,
      'health': health,
      'bullet':bullet,
      'attack_level': attackLevel,
      'health_level': healthLevel,
      'bullet_level': bulletLevel,
    };
  }
}
