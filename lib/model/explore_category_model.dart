// ***************************************** Explore Model ******************************************

class ExploreCategory {
  final String id;
  final String name;
  final String description;
  final String? parentId;
  final String createdAt;
  final String updatedOn;

  ExploreCategory({
    required this.id,
    required this.name,
    required this.description,
    this.parentId,
    required this.createdAt,
    required this.updatedOn,
  });

  ExploreCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? createdAt,
    String? updatedOn,
  }) {
    return ExploreCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parentId': parentId,
      'createdAt': createdAt,
      'updatedOn': updatedOn,
    };
  }

  factory ExploreCategory.fromMap(Map<String, dynamic> map) {
    return ExploreCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      parentId: map['parentId'] as String,
      createdAt: map['createdAt'] as String,
      updatedOn: map['updatedOn'] as String,
    );
  }
}
