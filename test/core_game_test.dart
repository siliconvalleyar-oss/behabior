import 'package:flutter_test/flutter_test.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/player.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/projectile.dart';
import 'package:behabior/core/entities/boss.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/core/utils/math_utils.dart';
import 'package:behabior/data/models/enemy_model.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

void main() {
  group('GameConfig', () {
    test('world size is correct', () {
      expect(GameConfig.worldWidth, 1600.0);
      expect(GameConfig.worldHeight, 1200.0);
    });

    test('default volumes within range', () {
      expect(GameConfig.defaultMusicVolume, inInclusiveRange(0.0, 1.0));
      expect(GameConfig.defaultSfxVolume, inInclusiveRange(0.0, 1.0));
    });
  });

  group('MathUtils', () {
    test('randomBetween returns values in range', () {
      for (int i = 0; i < 100; i++) {
        final val = MathUtils.randomBetween(10.0, 20.0);
        expect(val, inInclusiveRange(10.0, 20.0));
      }
    });

    test('randomDirection returns unit vector', () {
      for (int i = 0; i < 100; i++) {
        final dir = MathUtils.randomDirection();
        expect(dir.length, closeTo(1.0, 0.01));
      }
    });

    test('distanceBetween works correctly', () {
      final a = Vector2(0, 0);
      final b = Vector2(3, 4);
      expect(MathUtils.distanceBetween(a, b), 5.0);
    });

    test('chance returns bool', () {
      final results = <bool>[];
      for (int i = 0; i < 100; i++) {
        results.add(MathUtils.chance(0.5));
      }
      expect(results.any((r) => r), true);
      expect(results.any((r) => !r), true);
    });
  });

  group('Player', () {
    test('initializes with correct defaults', () {
      final player = Player();
      expect(player.health, GameConfig.playerMaxHealth);
      expect(player.maxHealth, GameConfig.playerMaxHealth);
      expect(player.speed, GameConfig.playerSpeed);
      expect(player.hitboxRadius, GameConfig.playerSize / 2);
    });

    test('takes damage correctly', () {
      final player = Player();
      player.takeDamage(30);
      expect(player.health, GameConfig.playerMaxHealth - 30);
    });

    test('becomes invincible after damage', () {
      final player = Player();
      player.takeDamage(10);
      expect(player.isInvincible, true);
    });

    test('invincibility prevents damage', () {
      final player = Player();
      player.takeDamage(10);
      final hpAfterFirstHit = player.health;
      player.takeDamage(50);
      expect(player.health, hpAfterFirstHit); // Should not change
    });

    test('dies when health reaches 0', () {
      final player = Player();
      player.takeDamage(player.maxHealth);
      expect(player.isDead, true);
    });

    test('moveDirection normalizes', () {
      final player = Player();
      player.moveDirection = Vector2(5, 5);
      expect(player.moveDirection.length, closeTo(1.0, 0.01));
    });
  });

  group('Enemy', () {
    test('creates from EnemyModel', () {
      final enemy = Enemy(model: EnemyModel.presets[EnemyType.basic]!);
      expect(enemy.health, 30.0);
      expect(enemy.speed, 80.0);
      expect(enemy.damage, 10.0);
    });

    test('moves toward target', () {
      final enemy = Enemy(
        model: EnemyModel.presets[EnemyType.fast]!,
        position: Vector2(0, 0),
      );
      enemy.setTarget(Vector2(100, 0));
      enemy.updatePhysics(0.1);
      expect(enemy.position.x, greaterThan(0));
    });
  });

  group('Boss', () {
    test('initializes with high HP', () {
      final boss = Boss(bossType: 'test');
      expect(boss.health, 500.0);
      expect(boss.hitboxRadius, 48.0);
    });

    test('enters enraged phase at low HP', () {
      final boss = Boss(bossType: 'test');
      boss.takeDamage(400);
      expect(boss.isEnraged, true);
    });
  });

  group('Projectile', () {
    test('moves in direction', () {
      final proj = Projectile(
        position: Vector2(0, 0),
        direction: Vector2(1, 0),
      );
      proj.updatePhysics(0.1);
      expect(proj.position.x, greaterThan(0));
    });

    test('expires after lifetime', () {
      final proj = Projectile(
        position: Vector2(0, 0),
        direction: Vector2(1, 0),
      );
      // Override lifetime for testing
      proj.lifetime = 0.5;
      proj.updatePhysics(1.0);
      expect(proj.isActive, false);
    });
  });

  group('CollisionSystem', () {
    test('detects overlapping circles', () {
      final a = _TestCollidable(
        position: Vector2(0, 0),
        hitboxRadius: 10,
      );
      final b = _TestCollidable(
        position: Vector2(5, 0),
        hitboxRadius: 10,
      );
      expect(a.overlaps(b), true);
    });

    test('does not detect distant circles', () {
      final a = _TestCollidable(
        position: Vector2(0, 0),
        hitboxRadius: 10,
      );
      final b = _TestCollidable(
        position: Vector2(50, 0),
        hitboxRadius: 10,
      );
      expect(a.overlaps(b), false);
    });
  });

  group('SkillModel', () {
    test('default skills have correct structure', () {
      expect(SkillModel.defaults.length, 6);
      expect(SkillModel.defaults[0].id, 'health_boost');
    });

    test('upgrade increases level', () {
      final skill = SkillModel.defaults[0];
      final upgraded = skill.upgrade();
      expect(upgraded.currentLevel, 1);
    });

    test('isMaxed prevents upgrade', () {
      final skill = SkillModel.defaults[0].copyWith(currentLevel: 5);
      expect(skill.isMaxed, true);
    });

    test('currentValue scales with level', () {
      final skill = SkillModel.defaults[0].copyWith(currentLevel: 2);
      expect(skill.currentValue, 150.0); // baseValue(100) + 2 * valuePerLevel(25)
    });
  });

  group('AchievementModel', () {
    test('default achievements have correct count', () {
      expect(AchievementModel.defaults.length, 8);
    });

    test('progress updates correctly', () {
      final achievement = AchievementModel.defaults[0];
      expect(achievement.isComplete, false);
      final updated = achievement.copyWith(progress: 1.0);
      expect(updated.isComplete, true);
    });
  });
}

class _TestCollidable extends HasHitboxCollision {
  @override
  final Vector2 position;
  @override
  final double hitboxRadius;

  _TestCollidable({
    required this.position,
    required this.hitboxRadius,
  });

  @override
  CollisionLayer get collisionLayer => CollisionLayer.obstacle;

  @override
  bool get isActive => true;

  @override
  void onCollision(CollisionInfo info) {}
}
