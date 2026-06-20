import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/player.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/boss.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/core/engine/spawn_engine.dart';
import 'package:behabior/core/components/joystick_component.dart' show GameJoystick;
import 'package:behabior/core/systems/score_system.dart';
import 'package:behabior/core/systems/audio_system.dart';
import 'package:behabior/core/systems/wave_system.dart';
import 'package:behabior/core/systems/achievement_system.dart';
import 'package:behabior/data/providers/game_state.dart';

class CoreGame extends FlameGame {
  final GameState gameState;
  final SpawnEngine spawnEngine = SpawnEngine();
  late final CollisionSystem collisionSystem;
  late final AudioSystem audioSystem;
  late final ScoreSystem scoreSystem;
  late final WaveSystem waveSystem;
  late final AchievementSystem achievementSystem;

  final world = World();
  late final CameraComponent gameCamera;
  late final Player player;
  final List<Enemy> enemies = [];
  Boss? boss;

  bool _initialised = false;
  int _currentLevelId = 1;
  bool _gameOver = false;
  bool _levelComplete = false;

  CoreGame(this.gameState) {
    collisionSystem = CollisionSystem();
    audioSystem = AudioSystem();
    scoreSystem = ScoreSystem();
    waveSystem = WaveSystem();
    achievementSystem = AchievementSystem(gameState);
    player = Player(gameState);
  }

  @override
  Future<void> onLoad() async {
    if (_initialised) return;
    _initialised = true;

    gameCamera = CameraComponent.withFixedResolution(
      width: GameConfig.viewportWidth,
      height: GameConfig.viewportHeight,
    );
    gameCamera.viewfinder.anchor = Anchor.center;
    gameCamera.world = world;

    await audioSystem.init();

    world.add(player);

    gameCamera.follow(player);

    add(world);
    add(gameCamera);

    final joystick = GameJoystick(
      player: player,
      onFire: _fireProjectile,
    );
    add(joystick);
  }

  void startLevel(int levelId) {
    _currentLevelId = levelId;
    _gameOver = false;
    _levelComplete = false;
    waveSystem.initLevel(levelId, spawnEngine);
    player.reset();

    for (final e in enemies) {
      e.removeFromParent();
    }
    enemies.clear();
    boss?.removeFromParent();
    boss = null;
    collisionSystem.returnAll();
  }

  void _fireProjectile() {
    if (_gameOver || _levelComplete) return;
    final proj = collisionSystem.getProjectile();
    if (proj == null) return;

    final dir = player.lastDirection;
    if (dir.x == 0 && dir.y == 0) return;

    final bonuses = gameState.getSkillBonuses();
    final damage = 10.0 + (bonuses['damage'] ?? 0);

    proj.init(
      position: player.position.clone(),
      direction: dir.normalized(),
      damage: damage,
    );
    world.add(proj);
  }

  double _spawnTimer = 0;

  @override
  void update(double dt) {
    if (_gameOver || _levelComplete) return;

    super.update(dt);

    scoreSystem.update(dt);

    player.updatePhysics(dt);
    player.updateHealthBar();

    for (final e in enemies) {
      if (!e.active) continue;
      e.updateAI(player.position, dt);
      e.updatePhysics(dt);
      e.updateHealthBar();
    }

    final currentBoss = boss;
    if (currentBoss != null && currentBoss.active) {
      currentBoss.updateAI(player, dt);
      currentBoss.updatePhysics(dt);
      currentBoss.updateHealthBar();
    }

    for (final p in collisionSystem.activeProjectiles) {
      if (p.active) {
        p.move(dt);
        if (p.isExpired) {
          p.active = false;
        }
      }
    }

    enemies.removeWhere((e) => !e.active);

    if (currentBoss != null && !currentBoss.active && !currentBoss.hasDroppedLoot) {
      currentBoss.hasDroppedLoot = true;
      scoreSystem.addBossKill(currentBoss);
      gameState.addKill();
      gameState.bossesDefeated++;
      achievementSystem.checkBossAchievements(gameState.bossesDefeated);
      boss = null;
    }

    collisionSystem.checkCollisions(
      player,
      enemies,
      currentBoss,
      dt,
      (target) {
        scoreSystem.addKill(target);
        gameState.addKill();
        achievementSystem.checkKillAchievements(gameState.totalKills);
        audioSystem.playSfx('hit');
      },
      () {
        audioSystem.playSfx('player_hit');
      },
    );

    if (player.currentHealth <= 0) {
      _gameOver = true;
      audioSystem.playSfx('explosion');
      return;
    }

    _spawnTimer += dt;
    if (_spawnTimer >= 1.0) {
      _spawnTimer = 0;
      final wave = waveSystem.currentWave;
      if (wave != null) {
        final instructions = spawnEngine.generateWaveSpawns(wave);
        for (final inst in instructions) {
          if (enemies.length >= GameConfig.maxEnemies) break;
          if (inst.type == 'boss') {
            if (this.boss == null) {
              final newBoss = Boss(gameState.getSkillBonuses());
              newBoss.position.setValues(inst.x, inst.y);
              world.add(newBoss);
              boss = newBoss;
            }
          } else {
            final enemy = Enemy(inst.type, gameState.getSkillBonuses());
            enemy.position.setValues(inst.x, inst.y);
            enemies.add(enemy);
            world.add(enemy);
          }
        }
      }

      if (waveSystem.isLevelComplete()) {
        _levelComplete = true;
        audioSystem.playSfx('level_up');
      }
    }

    if (!_gameOver && _levelComplete) {
      scoreSystem.addTimeBonus();
    }
  }

  bool isGameOver() => _gameOver;
  bool isLevelComplete() => _levelComplete;

  void cleanup() {
    audioSystem.dispose();
    collisionSystem.returnAll();
    _initialised = false;
  }
}
