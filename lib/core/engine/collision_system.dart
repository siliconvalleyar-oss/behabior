import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/entities/boss.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/player.dart';
import 'package:behabior/core/entities/projectile.dart';

class CollisionSystem {
  final int _maxProjectiles = 40;
  final List<Projectile> _projectilePool = [];
  int _poolIndex = 0;

  List<Projectile> get activeProjectiles => _projectilePool;

  CollisionSystem() {
    for (int i = 0; i < _maxProjectiles; i++) {
      _projectilePool.add(Projectile());
    }
  }

  Projectile? getProjectile() {
    for (int i = 0; i < _maxProjectiles; i++) {
      final idx = (_poolIndex + i) % _maxProjectiles;
      final p = _projectilePool[idx];
      if (!p.active) {
        _poolIndex = (idx + 1) % _maxProjectiles;
        return p;
      }
    }
    return null;
  }

  void returnProjectile(Projectile p) {
    p.active = false;
  }

  void returnAll() {
    for (final p in _projectilePool) {
      p.active = false;
    }
  }

  void checkCollisions(
    Player player,
    List<Enemy> enemies,
    Boss? boss,
    double dt,
    void Function(BaseEntity target) onEnemyHit,
    void Function() onPlayerHit,
  ) {
    final pr = player.position;
    final prRad = player.radius;

    for (final p in _projectilePool) {
      if (!p.active) continue;
      final pp = p.position;
      final dist = pr - pp;
      final projRadius = p.radius;
      for (final e in enemies) {
        if (!e.active) continue;
        if (pp.distanceTo(e.position) < projRadius + e.radius) {
          e.takeDamage(p.damage);
          if (!e.active) {
            onEnemyHit(e);
          }
          p.active = false;
          break;
        }
      }
      if (!p.active) continue;
      if (boss != null && boss.active) {
        if (pp.distanceTo(boss.position) < projRadius + boss.radius) {
          boss.takeDamage(p.damage);
          p.active = false;
        }
      }
    }

    for (final e in enemies) {
      if (!e.active) continue;
      if (pr.distanceTo(e.position) < prRad + e.radius) {
        if (player.canTakeDamage) {
          player.takeContactDamage(e.contactDamage);
          onPlayerHit();
        }
      }
    }

    if (boss != null && boss.active && boss.isContactAttacking) {
      if (pr.distanceTo(boss.position) < prRad + boss.radius + 10) {
        if (player.canTakeDamage) {
          player.takeContactDamage(boss.contactDamage);
          onPlayerHit();
        }
      }
    }
  }
}
