import 'package:equatable/equatable.dart';

class AchievementModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final int targetProgress;
  final int currentProgress;
  final bool isUnlocked;

  const AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconAsset = 'achievements/default',
    this.targetProgress = 1,
    this.currentProgress = 0,
    this.isUnlocked = false,
  });

  AchievementModel copyWith({int? currentProgress, bool? isUnlocked}) {
    return AchievementModel(
      id: id,
      name: name,
      description: description,
      iconAsset: iconAsset,
      targetProgress: targetProgress,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  double get progressFraction => (currentProgress / targetProgress).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [id, name, description, iconAsset, targetProgress, currentProgress, isUnlocked];

  static const List<AchievementModel> defaults = [
    AchievementModel(id: 'first_kill', name: 'First Blood', description: 'Kill your first enemy', targetProgress: 1),
    AchievementModel(id: 'kills_100', name: 'Centurion', description: 'Kill 100 enemies', targetProgress: 100),
    AchievementModel(id: 'kills_500', name: 'War Machine', description: 'Kill 500 enemies', targetProgress: 500),
    AchievementModel(id: 'kills_1000', name: 'Annihilator', description: 'Kill 1000 enemies', targetProgress: 1000),
    AchievementModel(id: 'waves_25', name: 'Survivor', description: 'Complete 25 waves', targetProgress: 25),
    AchievementModel(id: 'waves_100', name: 'Veteran', description: 'Complete 100 waves', targetProgress: 100),
    AchievementModel(id: 'bosses_10', name: 'Boss Slayer', description: 'Defeat 10 bosses', targetProgress: 10),
    AchievementModel(id: 'all_skills', name: 'Master', description: 'Max all skills', targetProgress: 1),
  ];
}
