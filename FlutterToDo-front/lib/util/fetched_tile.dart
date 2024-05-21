import 'dart:convert';

class FetchedTile {
  final int id;
  final String name;
  final bool isComplete;

  FetchedTile({
    required this.id,
    required this.name,
    required this.isComplete,
  });

  factory FetchedTile.fromJson(Map<String, dynamic> json) {
    return FetchedTile(
      id: json['id'],
      name: json['name'],
      isComplete: json['isComplete'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isComplete': isComplete,
    };
  }
}
