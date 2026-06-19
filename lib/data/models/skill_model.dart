import 'package:equatable/equatable.dart';

enum SkillType {
  passive,
  active,
  ultimate,
}

class SkillModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final int maxLevel;
  final int currentLevel;
  final int costPerLevel;
  final double baseValue;
  final double valuePerLevel;
  final String iconAsset;
  final bool isUnlocked;
  final List<String> prerequisites;

  const SkillModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.maxLevel = 5,
    this.currentLevel = 0,
    this.costPerLevel = 1,
    this.baseValue = 0.0,
    this.valuePerLevel = 1.0,
    this.iconAsset = 'skills/default',
    this.isUnlocked = true,
    this.prerequisites = const [],
  });

  double get currentValue => baseValue + (currentLevel * valuePerLevel);

  bool get isMaxed => currentLevel >= maxLevel;

  int get nextCost => costPerLevel * (currentLevel + 1);

  String get levelDisplay => '$currentLevel/$maxLevel';

  SkillModel upgrade() {
    if (isMaxed) return this;
    return copyWith(currentLevel: currentLevel + 1);
  }

  SkillModel copyWith({
    String? id,
    String? name,
    String? description,
    SkillType? type,
    int? maxLevel,
    int? currentLevel,
    int? costPerLevel,
    double? baseValue,
    double? valuePerLevel,
    String? iconAsset,
    bool? isUnlocked,
    List<String>? prerequisites,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      maxLevel: maxLevel ?? this.maxLevel,
      currentLevel: currentLevel ?? this.currentLevel,
      costPerLevel: costPerLevel ?? this.costPerLevel,
      baseValue: baseValue ?? this.baseValue,
      valuePerLevel: valuePerLevel ?? this.valuePerLevel,
      iconAsset: iconAsset ?? this.iconAsset,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        maxLevel,
        currentLevel,
        costPerLevel,
        baseValue,
        valuePerLevel,
        iconAsset,
        isUnlocked,
        prerequisites,
      ];

  static const List<SkillModel> defaults = [
    SkillModel(
      id: 'health_boost',
      name: 'Vitality',
      description: 'Increase max health',
      type: SkillType.passive,
      baseValue: 100.0,
      valuePerLevel: 25.0,
    ),
    SkillModel(
      id: 'speed_boost',
      name: 'Swift',
      description: 'Increase movement speed',
      type: SkillType.passive,
      baseValue: 200.0,
      valuePerLevel: 15.0,
    ),
    SkillModel(
      id: 'damage_boost',
      name: 'Power',
      description: 'Increase attack damage',
      type: SkillType.passive,
      baseValue: 10.0,
      valuePerLevel: 5.0,
    ),
    SkillModel(
      id: 'shield',
      name: 'Barrier',
      description: 'Temporary damage immunity',
      type: SkillType.active,
      maxLevel: 3,
      costPerLevel: 2,
      baseValue: 2.0,
      valuePerLevel: 1.0,
    ),
    SkillModel(
      id: 'rage',
      name: 'Berserker',
      description: 'Attack speed increase',
      type: SkillType.active,
      maxLevel: 3,
      costPerLevel: 2,
      baseValue: 1.5,
      valuePerLevel: 0.5,
    ),
    SkillModel(
      id: 'nova',
      name: 'Nova Blast',
      description: 'Area damage explosion',
      type: SkillType.ultimate,
      maxLevel: 3,
      costPerLevel: 3,
      baseValue: 50.0,
      valuePerLevel: 25.0,
      prerequisites: ['damage_boost'],
    ),
  ];
}
