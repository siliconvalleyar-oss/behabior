import 'package:equatable/equatable.dart';

class EnemyModel extends Equatable {
  final String id;
  final String name;
  final double health;
  final double speed;
  final double damage;
  final double spriteSize;
  final double contactDamage;
  final int expReward;
  final int coinReward;
  final bool isBoss;
  final bool isRanged;

  const EnemyModel({
    required this.id,
    required this.name,
    required this.health,
    required this.speed,
    required this.damage,
    this.spriteSize = 28.0,
    this.contactDamage = 5.0,
    this.expReward = 10,
    this.coinReward = 1,
    this.isBoss = false,
    this.isRanged = false,
  });

  @override
  List<Object?> get props => [id, name, health, speed, damage, spriteSize, contactDamage, expReward, coinReward, isBoss, isRanged];

  static const Map<String, EnemyModel> presets = {
    'grunt': EnemyModel(id: 'grunt', name: 'Grunt', health: 30, speed: 80, damage: 8, contactDamage: 5),
    'runner': EnemyModel(id: 'runner', name: 'Runner', health: 15, speed: 160, damage: 5, contactDamage: 3, expReward: 15),
    'brute': EnemyModel(id: 'brute', name: 'Brute', health: 120, speed: 40, damage: 20, spriteSize: 40, contactDamage: 12, expReward: 25),
    'sniper': EnemyModel(id: 'sniper', name: 'Sniper', health: 20, speed: 50, damage: 12, isRanged: true, expReward: 20),
    'medic': EnemyModel(id: 'medic', name: 'Medic', health: 25, speed: 70, damage: 3, expReward: 20),
    'bomber': EnemyModel(id: 'bomber', name: 'Bomber', health: 10, speed: 90, damage: 25, contactDamage: 15, expReward: 8),
  };
}
