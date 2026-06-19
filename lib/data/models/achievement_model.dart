import 'package:equatable/equatable.dart';

enum AchievementCategory {
  combat,
  progression,
  collection,
  skill,
  secret,
}

class AchievementModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final int rewardPoints;
  final String iconAsset;
  final bool isUnlocked;
  final double progress;
  final double target;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.category = AchievementCategory.combat,
    this.rewardPoints = 10,
    this.iconAsset = 'achievements/default',
    this.isUnlocked = false,
    this.progress = 0.0,
    this.target = 1.0,
    this.unlockedAt,
  });

  bool get isComplete => progress >= target;

  double get progressPercent => (progress / target).clamp(0.0, 1.0);

  String get progressDisplay => '${progress.toInt()}/${target.toInt()}';

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    AchievementCategory? category,
    int? rewardPoints,
    String? iconAsset,
    bool? isUnlocked,
    double? progress,
    double? target,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      iconAsset: iconAsset ?? this.iconAsset,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        rewardPoints,
        iconAsset,
        isUnlocked,
        progress,
        target,
        unlockedAt,
      ];

  static const List<AchievementModel> defaults = [
    AchievementModel(
      id: 'first_kill',
      title: 'First Blood',
      description: 'Kill your first enemy',
      category: AchievementCategory.combat,
    ),
    AchievementModel(
      id: 'wave_5',
      title: 'Survivor',
      description: 'Survive 5 waves',
      category: AchievementCategory.combat,
      target: 5.0,
    ),
    AchievementModel(
      id: 'boss_kill',
      title: 'Giant Slayer',
      description: 'Defeat a boss',
      category: AchievementCategory.combat,
    ),
    AchievementModel(
      id: 'level_5',
      title: 'Rising Star',
      description: 'Reach player level 5',
      category: AchievementCategory.progression,
      target: 5.0,
    ),
    AchievementModel(
      id: 'skill_master',
      title: 'Student',
      description: 'Unlock your first skill',
      category: AchievementCategory.skill,
    ),
    AchievementModel(
      id: 'enemy_100',
      title: 'Butcher',
      description: 'Kill 100 enemies',
      category: AchievementCategory.combat,
      rewardPoints: 25,
      target: 100.0,
    ),
    AchievementModel(
      id: 'glass_walker',
      title: 'Glass Walker',
      description: 'Break 50 glass obstacles',
      category: AchievementCategory.collection,
      rewardPoints: 20,
      target: 50.0,
    ),
    AchievementModel(
      id: 'perfect_wave',
      title: 'Flawless',
      description: 'Complete a wave without taking damage',
      category: AchievementCategory.combat,
      rewardPoints: 30,
    ),
  ];
}
