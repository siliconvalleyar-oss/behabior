import 'package:equatable/equatable.dart';

enum EnemyType {
  basic,
  fast,
  tank,
  ranged,
  healer,
  explosive,
}

class EnemyModel extends Equatable {
  final EnemyType type;
  final String name;
  final double health;
  final double speed;
  final double damage;
  final double size;
  final double experienceReward;
  final String riveAnimation;
  final String? projectileType;
  final double attackRange;
  final double attackCooldown;

  const EnemyModel({
    required this.type,
    required this.name,
    required this.health,
    required this.speed,
    required this.damage,
    this.size = 28.0,
    this.experienceReward = 10.0,
    this.riveAnimation = 'enemy_basic',
    this.projectileType,
    this.attackRange = 50.0,
    this.attackCooldown = 1.0,
  });

  static const Map<EnemyType, EnemyModel> presets = {
    EnemyType.basic: EnemyModel(
      type: EnemyType.basic,
      name: 'Grunt',
      health: 30.0,
      speed: 80.0,
      damage: 10.0,
      size: 28.0,
      experienceReward: 10.0,
      riveAnimation: 'enemy_basic',
    ),
    EnemyType.fast: EnemyModel(
      type: EnemyType.fast,
      name: 'Runner',
      health: 15.0,
      speed: 160.0,
      damage: 5.0,
      size: 22.0,
      experienceReward: 15.0,
      riveAnimation: 'enemy_fast',
    ),
    EnemyType.tank: EnemyModel(
      type: EnemyType.tank,
      name: 'Brute',
      health: 120.0,
      speed: 40.0,
      damage: 25.0,
      size: 40.0,
      experienceReward: 30.0,
      riveAnimation: 'enemy_tank',
    ),
    EnemyType.ranged: EnemyModel(
      type: EnemyType.ranged,
      name: 'Sniper',
      health: 20.0,
      speed: 50.0,
      damage: 15.0,
      size: 26.0,
      experienceReward: 20.0,
      riveAnimation: 'enemy_ranged',
      projectileType: 'bullet',
      attackRange: 250.0,
    ),
    EnemyType.healer: EnemyModel(
      type: EnemyType.healer,
      name: 'Medic',
      health: 25.0,
      speed: 70.0,
      damage: 0.0,
      size: 28.0,
      experienceReward: 25.0,
      riveAnimation: 'enemy_healer',
    ),
    EnemyType.explosive: EnemyModel(
      type: EnemyType.explosive,
      name: 'Bomber',
      health: 10.0,
      speed: 90.0,
      damage: 50.0,
      size: 30.0,
      experienceReward: 20.0,
      riveAnimation: 'enemy_explosive',
    ),
  };

  @override
  List<Object?> get props => [
        type,
        name,
        health,
        speed,
        damage,
        size,
        experienceReward,
        riveAnimation,
        projectileType,
        attackRange,
        attackCooldown,
      ];
}
