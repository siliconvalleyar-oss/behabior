import 'package:flame_audio/flame_audio.dart';
import 'package:logger/logger.dart';

class AudioSystem {
  bool _initialized = false;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.7;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  String? _currentMusic;
  final Logger _log = Logger();

  Future<void> init() async {
    if (_initialized) return;
    try {
      await FlameAudio.audioCache.loadAll(<String>[
        'music/theme.mp3',
        'music/battle.mp3',
        'music/boss.mp3',
        'sfx/shoot.wav',
        'sfx/hit.wav',
        'sfx/explosion.wav',
        'sfx/enemy_death.wav',
        'sfx/player_hit.wav',
        'sfx/level_up.wav',
        'sfx/achievement.wav',
        'sfx/button_click.wav',
        'sfx/glass_break.wav',
        'sfx/wave_start.wav',
        'sfx/boss_warning.wav',
        'sfx/pickup.wav',
      ]);
      _initialized = true;
    } catch (e) {
      _log.w('AudioSystem: Some audio files not found (expected in dev)');
      _initialized = true;
    }
  }

  void playMusic(String key, {bool loop = true}) {
    if (!_musicEnabled || !_initialized) return;
    try {
      if (_currentMusic == key) return;
      stopMusic();
      if (loop) {
        FlameAudio.bgm.play('music/$key', volume: _musicVolume);
      } else {
        FlameAudio.play('music/$key', volume: _musicVolume);
      }
      _currentMusic = key;
    } catch (e) {
      _log.w('AudioSystem: Could not play music $key');
    }
  }

  void stopMusic() {
    if (_currentMusic == null) return;
    try {
      FlameAudio.bgm.stop();
      _currentMusic = null;
    } catch (_) {}
  }

  void playSfx(String key, {double? volume}) {
    if (!_sfxEnabled || !_initialized) return;
    try {
      FlameAudio.play('sfx/$key', volume: (volume ?? _sfxVolume));
    } catch (e) {
      // Silently fail - audio may not be loaded in dev
    }
  }

  void playShoot() => playSfx('shoot.wav');
  void playHit() => playSfx('hit.wav');
  void playExplosion() => playSfx('explosion.wav');
  void playEnemyDeath() => playSfx('enemy_death.wav');
  void playPlayerHit() => playSfx('player_hit.wav');
  void playLevelUp() => playSfx('level_up.wav');
  void playAchievement() => playSfx('achievement.wav');
  void playButtonClick() => playSfx('button_click.wav');
  void playGlassBreak() => playSfx('glass_break.wav');
  void playWaveStart() => playSfx('wave_start.wav');
  void playBossWarning() => playSfx('boss_warning.wav');
  void playPickup() => playSfx('pickup.wav');

  void playMenuMusic() => playMusic('theme.mp3');
  void playBattleMusic() => playMusic('battle.mp3');
  void playBossMusic() => playMusic('boss.mp3');

  void setMusicVolume(double vol) {
    _musicVolume = vol.clamp(0.0, 1.0);
    FlameAudio.bgm.setVolume(_musicVolume);
  }

  void setSfxVolume(double vol) {
    _sfxVolume = vol.clamp(0.0, 1.0);
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      stopMusic();
    }
  }

  void toggleSfx() {
    _sfxEnabled = !_sfxEnabled;
  }

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get isInitialized => _initialized;
}
