import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/input.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/core/engine/spawn_engine.dart';
import 'package:behabior/core/entities/player.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/boss.dart';
import 'package:behabior/core/entities/projectile.dart';
import 'package:behabior/core/components/joystick_component.dart';
import 'package:behabior/core/components/particle_component.dart';
import 'package:behabior/core/components/camera_shake.dart';
import 'package:behabior/core/components/damage_flash.dart';
import 'package:behabior/core/components/screen_transition.dart';
import 'package:behabior/core/components/health_bar.dart';
import 'package:behabior/core/effects/liquid_effect.dart';
import 'package:behabior/core/effects/glass_effect.dart';
import 'package:behabior/core/effects/fluid_squad.dart';
import 'package:behabior/core/systems/audio_system.dart';
import 'package:behabior/core/systems/score_system.dart';
import 'package:behabior/core/systems/wave_system.dart';
import 'package:behabior/core/systems/achievement_system.dart';
import 'package:behabior/core/systems/skill_system.dart';
import 'package:behabior/data/models/level_model.dart';

class CoreGame extends FlameGame with HasTappables, HasDraggables {
  // Systems
  final AudioSystem audioSystem;
  final ScoreSystem scoreSystem;
  final WaveSystem waveSystem;
  final AchievementSystem achievementSystem;
  final SkillSystem skillSystem;

  // Engine
  final CollisionSystem collisionSystem = CollisionSystem();
  final SpawnEngine spawnEngine = SpawnEngine();

  // Entities
  Player? player;
  final List<Enemy> enemies = [];
  final List<Boss> bosses = [];
  final List<Projectile> projectiles = [];

  // Components
  late JoystickComponent joystick;
  late ParticleComponent particleComponent;
  late DamageFlashComponent damageFlash;
  late ScreenTransition screenTransition;
  late LiquidEffectComponent liquidEffect;
  late GlassEffectComponent glassEffect;
  late FluidSquadEffectComponent fluidSquad;
  late HealthBarComponent playerHealthBar;
  late CameraShakeEffect cameraShakeEffect;

  // State
  bool _isPaused = false;
  bool _gameOver = false;
  bool _levelComplete = false;
  int _currentLevelId = 1;
  double _gameTime = 0.0;

  // Callbacks
  void Function(int levelId, int stars)? onLevelComplete;
  void Function()? onGameOver;

  CoreGame({
    required this.audioSystem,
    required this.scoreSystem,
    required this.waveSystem,
    required this.achievementSystem,
    required this.skillSystem,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Camera setup
    camera = CameraComponent.withFixedSize(
      world: this,
      viewport: Viewport(
        size: Vector2(800, 600),
      ),
    );
    camera.viewfinder.zoom = GameConfig.cameraZoom;

    // Camera shake
    cameraShakeEffect = CameraShakeEffect(camera);

    // Screen transition
    screenTransition = ScreenTransition();
    add(screenTransition);

    // Particle system
    particleComponent = ParticleComponent();
    add(particleComponent);

    // Damage flash
    damageFlash = DamageFlashComponent();
    add(damageFlash);

    // Effects
    liquidEffect = LiquidEffectComponent();
    add(liquidEffect);

    glassEffect = GlassEffectComponent();
    add(glassEffect);

    fluidSquad = FluidSquadEffectComponent();
    add(fluidSquad);

    // Spawn engine callbacks
    spawnEngine.enemyFactory = _createEnemy;
    spawnEngine.bossFactory = _createBoss;
    spawnEngine.onEnemySpawned = _onEnemySpawned;
    spawnEngine.onBossSpawned = _onBossSpawned;
    spawnEngine.onWaveStarted = _onWaveStarted;
    spawnEngine.onWaveComplete = _onWaveComplete;
    spawnEngine.onAllWavesComplete = _onAllWavesComplete;
  }

  void initializeLevel(int levelId, LevelModel level) {
    _currentLevelId = levelId;
    _gameOver = false;
    _levelComplete = false;
    _gameTime = 0.0;

    // Clear existing
    enemies.clear();
    bosses.clear();
    projectiles.clear();
    collisionSystem.clear();

    // Create player
    player = Player(
      position: Vector2(GameConfig.worldWidth / 2, GameConfig.worldHeight / 2),
    );
    player!.onShoot = _onPlayerShoot;
    add(player!);
    collisionSystem.add(player!);

    // Player health bar
    playerHealthBar = HealthBarComponent(
      position: Vector2(-20, -30),
      currentHealth: player!.health,
      maxHealth: player!.maxHealth,
      width: 60,
      height: 6,
    );
    player!.add(playerHealthBar);

    // Joystick
    final screenSize = camera.viewport.size;
    joystick = JoystickComponent(
      position: Vector2(120, screenSize.y - 120),
    );
    joystick.onDirectionChanged = _onJoystickMove;
    add(joystick);

    // Setup waves
    final waves = level.waveConfigs.map((w) => SpawnWave(
      waveNumber: w.waveNumber,
      enemyCount: w.enemyCount,
      enemyType: w.enemyType,
      spawnInterval: w.spawnInterval,
      hasBoss: w.hasBoss,
      bossType: w.bossType,
    )).toList();
    spawnEngine.loadWaves(waves);
    spawnEngine.start();

    // Systems
    scoreSystem.reset();
    waveSystem.start(level.waves);

    // Transition in
    screenTransition.startFadeIn(onComplete: () {
      audioSystem.playBattleMusic();
    });
  }

  void _onJoystickMove(Vector2 direction) {
    if (player != null && !_gameOver && !_isPaused) {
      player!.moveDirection = direction;
    }
  }

  void _onPlayerShoot(Projectile projectile) {
    projectiles.add(projectile);
    add(projectile);
    collisionSystem.add(projectile);
    audioSystem.playShoot();
  }

  Enemy _createEnemy(String type, Vector2 position) {
    final enemyModel = EnemyModel.presets.entries
        .firstWhere(
          (e) => e.value.name.toLowerCase().contains(type.toLowerCase()),
          orElse: () => EnemyModel.presets.entries.first,
        )
        .value;

    final enemy = Enemy(model: enemyModel, position: position);
    enemy.onDeath = (e) {
      enemies.remove(e);
      spawnEngine.currentWave?.enemies.remove(e);
      scoreSystem.addKill(enemyModel.health);
      achievementSystem.onEnemyKilled();
      particleComponent.emitBlood(e.position);
      audioSystem.playEnemyDeath();
    };
    enemy.onRangedAttack = (pos, dir) {
      final proj = Projectile(
        position: pos,
        direction: dir,
        projectileSpeed: 250.0,
        damage: enemyModel.damage * 0.5,
        team: EntityTeam.enemy,
      );
      projectiles.add(proj);
      add(proj);
      collisionSystem.add(proj);
    };
    enemies.add(enemy);
    return enemy;
  }

  Boss _createBoss(String type, Vector2 position) {
    final boss = Boss(
      bossType: type,
      position: position,
      healthMultiplier: 1.0 + (_currentLevelId * 0.2),
    );
    boss.onDeath = (b) {
      bosses.remove(b);
      scoreSystem.addBossKill(b.maxHealth);
      achievementSystem.onBossKilled();
      particleComponent.emitExplosion(b.position, color: Colors.purple, radius: 30);
      audioSystem.playExplosion();
      audioSystem.playBattleMusic();
    };
    boss.onAttack = (pos, dir, attackType) {
      _handleBossAttack(boss, pos, dir, attackType);
    };
    boss.onPhaseChange = (b, phase) {
      particleComponent.emitExplosion(b.position, color: Colors.red, radius: 20);
    };
    boss.setTarget(player?.position ?? Vector2.zero());
    bosses.add(boss);
    add(boss);
    collisionSystem.add(boss);
    audioSystem.playBossWarning();
    audioSystem.playBossMusic();
    return boss;
  }

  void _handleBossAttack(Boss boss, Vector2 pos, Vector2 dir, String attackType) {
    switch (attackType) {
      case 'shockwave':
        particleComponent.emitExplosion(pos, color: Colors.amber, radius: 40);
        cameraShakeEffect.shake(intensity: 8.0, duration: 0.3);
        audioSystem.playExplosion();
        break;
      case 'spread_shot':
        for (int i = -2; i <= 2; i++) {
          final angle = atan2(dir.y, dir.x) + i * 0.3;
          final spreadDir = Vector2(cos(angle), sin(angle));
          final proj = Projectile(
            position: pos,
            direction: spreadDir,
            projectileSpeed: 200.0,
            damage: 15.0,
            team: EntityTeam.enemy,
          );
          projectiles.add(proj);
          add(proj);
          collisionSystem.add(proj);
        }
        audioSystem.playShoot();
        break;
      case 'laser_beam':
        particleComponent.emit(
          position: pos,
          type: ParticleEmitterType.stream,
          color: Colors.red,
          speed: 300.0,
          lifetime: 0.5,
        );
        audioSystem.playShoot();
        break;
      case 'meteor_storm':
        for (int i = 0; i < 5; i++) {
          Future.delayed(Duration(milliseconds: i * 200), () {
            final meteorPos = Vector2(
              pos.x + (i - 2) * 50,
              pos.y - 100,
            );
            particleComponent.emitExplosion(meteorPos, color: Colors.orange, radius: 25);
            cameraShakeEffect.shake(intensity: 5.0, duration: 0.1);
          });
        }
        audioSystem.playExplosion();
        break;
    }
  }

  void _onEnemySpawned(Enemy enemy) {
    add(enemy);
    collisionSystem.add(enemy);
    enemy.setTarget(player?.position ?? Vector2.zero());
  }

  void _onBossSpawned(Boss boss) {
    // Already added in _createBoss
  }

  void _onWaveStarted(int wave) {
    waveSystem.onWaveStarted(wave);
    audioSystem.playWaveStart();
  }

  void _onWaveComplete(int wave) {
    waveSystem.onWaveCompleted(wave);
    scoreSystem.addTimeBonus(60.0);
  }

  void _onAllWavesComplete() {
    _levelComplete = true;
    final stars = _calculateStars();
    onLevelComplete?.call(_currentLevelId, stars);
    audioSystem.playLevelUp();
    screenTransition.startFadeOut();
  }

  int _calculateStars() {
    int stars = 1;
    if (player!.healthPercent > 0.7) stars = 3;
    else if (player!.healthPercent > 0.3) stars = 2;
    return stars;
  }

  @override
  void update(double dt) {
    if (_isPaused || _gameOver) return;

    super.update(dt);

    _gameTime += dt;

    // Update systems
    cameraShakeEffect.update(dt);
    scoreSystem.update(dt);

    // Update player
    player?.updatePhysics(dt);
    if (player != null) {
      playerHealthBar.updateHealth(player!.health, player!.maxHealth);
    }

    // Update enemies
    for (final enemy in enemies) {
      if (player != null) {
        enemy.setTarget(player!.position);
      }
      enemy.updatePhysics(dt);
    }

    // Update bosses
    for (final boss in bosses) {
      if (player != null) {
        boss.setTarget(player!.position);
      }
      boss.updatePhysics(dt);
    }

    // Update projectiles
    for (final proj in projectiles.toList()) {
      proj.updatePhysics(dt);
      if (!proj.isActive || proj.hasHit) {
        projectiles.remove(proj);
        collisionSystem.remove(proj);
        proj.removeFromParent();
        if (proj.hasHit) {
          particleComponent.emitExplosion(proj.position, color: Colors.yellow, radius: 8);
        }
      }
    }

    // Remove dead enemies
    enemies.removeWhere((e) => e.isDead);
    bosses.removeWhere((b) => b.isDead);

    // Collision detection
    collisionSystem.update(dt);

    // Spawn engine
    spawnEngine.update(dt, player?.position ?? Vector2.zero());
    waveSystem.updateEnemyCount(enemies.length + bosses.length);

    // Camera follows player
    if (player != null && !cameraShakeEffect.isShaking) {
      camera.moveTo(player!.position);
    }

    // Check game over
    if (player != null && player!.isDead && !_gameOver) {
      _gameOver = true;
      audioSystem.stopMusic();
      audioSystem.playExplosion();
      screenTransition.startFadeOut(onComplete: () {
        onGameOver?.call();
      });
    }
  }

  // Attack action
  void performAttack(Vector2 targetDirection) {
    if (player != null && !_gameOver && !_isPaused) {
      player!.tryAttack(targetDirection);
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;
  }

  bool get isPaused => _isPaused;
  bool get isGameOver => _gameOver;
  bool get isLevelComplete => _levelComplete;

  void dispose() {
    audioSystem.stopMusic();
    collisionSystem.clear();
    spawnEngine.reset();
    enemies.clear();
    bosses.clear();
    projectiles.clear();
  }
}
