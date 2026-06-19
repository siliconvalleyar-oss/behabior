import 'dart:math';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/boss.dart';
import 'package:behabior/core/utils/math_utils.dart';

class SpawnWave {
  final int waveNumber;
  final int enemyCount;
  final String enemyType;
  final double spawnInterval;
  final bool hasBoss;
  final String? bossType;
  final List<Enemy> enemies;
  final List<Boss> bosses;
  bool isComplete;

  SpawnWave({
    required this.waveNumber,
    required this.enemyCount,
    this.enemyType = 'basic',
    this.spawnInterval = 2.0,
    this.hasBoss = false,
    this.bossType,
    List<Enemy>? enemies,
    List<Boss>? bosses,
    this.isComplete = false,
  })  : enemies = enemies ?? [],
        bosses = bosses ?? [];
}

typedef EnemyFactory = Enemy Function(String type, Vector2 position);
typedef BossFactory = Boss Function(String type, Vector2 position);

class SpawnEngine {
  final Random _random = Random();
  EnemyFactory? enemyFactory;
  BossFactory? bossFactory;
  Vector2? _playerPosition;

  final List<SpawnWave> _waves = [];
  int _currentWaveIndex = 0;
  double _spawnTimer = 0.0;
  int _spawnedInWave = 0;
  bool _isSpawning = false;
  bool _allWavesComplete = false;

  // Callbacks
  void Function(Enemy enemy)? onEnemySpawned;
  void Function(Boss boss)? onBossSpawned;
  void Function(int wave)? onWaveStarted;
  void Function(int wave)? onWaveComplete;
  void Function()? onAllWavesComplete;

  void loadWaves(List<SpawnWave> waves) {
    _waves.clear();
    _waves.addAll(waves);
    _currentWaveIndex = 0;
    _allWavesComplete = false;
    _isSpawning = false;
  }

  void start() {
    if (_waves.isEmpty) return;
    _isSpawning = true;
    _currentWaveIndex = 0;
    _spawnedInWave = 0;
    _spawnTimer = 0.0;
    _startCurrentWave();
  }

  void _startCurrentWave() {
    if (_currentWaveIndex >= _waves.length) {
      _allWavesComplete = true;
      onAllWavesComplete?.call();
      return;
    }
    final wave = _waves[_currentWaveIndex];
    _spawnedInWave = 0;
    _spawnTimer = 0.0;
    wave.isComplete = false;
    onWaveStarted?.call(wave.waveNumber);
  }

  void update(double dt, Vector2 playerPosition) {
    _playerPosition = playerPosition;
    if (!_isSpawning || _allWavesComplete) return;
    if (_currentWaveIndex >= _waves.length) return;

    final wave = _waves[_currentWaveIndex];
    if (wave.isComplete) {
      _currentWaveIndex++;
      _startCurrentWave();
      return;
    }

    _spawnTimer += dt;
    if (_spawnedInWave < wave.enemyCount && _spawnTimer >= wave.spawnInterval) {
      _spawnTimer = 0.0;
      _spawnEnemy(wave);
      _spawnedInWave++;
    }

    // Check if all enemies in wave are dead
    wave.enemies.removeWhere((e) => !e.isActive);
    wave.bosses.removeWhere((b) => !b.isActive);

    if (_spawnedInWave >= wave.enemyCount &&
        wave.enemies.isEmpty &&
        wave.bosses.isEmpty) {
      wave.isComplete = true;
      onWaveComplete?.call(wave.waveNumber);
    }
  }

  void _spawnEnemy(SpawnWave wave) {
    if (_playerPosition == null) return;

    final spawnPos = _getSpawnPosition();
    final enemy = enemyFactory?.call(wave.enemyType, spawnPos);
    if (enemy != null) {
      wave.enemies.add(enemy);
      onEnemySpawned?.call(enemy);
    }
  }

  void _spawnBoss(SpawnWave wave) {
    if (_playerPosition == null) return;

    final spawnPos = _getSpawnPosition();
    final boss = bossFactory?.call(wave.bossType ?? 'boss', spawnPos);
    if (boss != null) {
      wave.bosses.add(boss);
      onBossSpawned?.call(boss);
    }
  }

  Vector2 _getSpawnPosition() {
    if (_playerPosition == null) return Vector2.zero();
    final angle = _random.nextDouble() * 2 * pi;
    final distance = MathUtils.randomBetween(
      GameConfig.worldWidth * 0.4,
      GameConfig.worldWidth * 0.5,
    );
    final v = Vector2(
      _playerPosition!.x + cos(angle) * distance,
      _playerPosition!.y + sin(angle) * distance,
    );
    return Vector2(
      v.x.clamp(32.0, GameConfig.worldWidth - 32),
      v.y.clamp(32.0, GameConfig.worldHeight - 32),
    );
  }

  SpawnWave? get currentWave {
    if (_currentWaveIndex >= _waves.length) return null;
    return _waves[_currentWaveIndex];
  }

  int get currentWaveNumber => _currentWaveIndex + 1;
  int get totalWaves => _waves.length;
  bool get isSpawning => _isSpawning;
  bool get allWavesComplete => _allWavesComplete;
  int get currentWaveIndex => _currentWaveIndex;

  void pause() => _isSpawning = false;
  void resume() => _isSpawning = true;

  void reset() {
    _waves.clear();
    _currentWaveIndex = 0;
    _spawnTimer = 0.0;
    _spawnedInWave = 0;
    _isSpawning = false;
    _allWavesComplete = false;
  }
}
