import 'package:flame_audio/flame_audio.dart';

class AudioSystem {
  bool _initialised = false;

  Future<void> init() async {
    try {
      await FlameAudio.audioCache.loadAll([]);
      _initialised = true;
    } catch (_) {
      _initialised = false;
    }
  }

  void playMusic(String name, {double volume = 0.5}) {
    if (!_initialised) return;
    try {
      FlameAudio.bgm.play('music/$name', volume: volume);
    } catch (_) {}
  }

  void stopMusic() {
    if (!_initialised) return;
    try {
      FlameAudio.bgm.stop();
    } catch (_) {}
  }

  void playSfx(String name, {double volume = 0.7}) {
    if (!_initialised) return;
    try {
      FlameAudio.play('sfx/$name.wav', volume: volume);
    } catch (_) {}
  }

  void dispose() {
    if (!_initialised) return;
    try {
      FlameAudio.bgm.dispose();
    } catch (_) {}
  }
}
