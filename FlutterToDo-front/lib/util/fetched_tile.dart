import 'dart:convert';

class FetchedTile {
  final String name;
  final bool isComplete;

  FetchedTile({
    required this.name,
    required this.isComplete,
  });

  factory FetchedTile.fromJson(Map<String, dynamic> json) {
    return FetchedTile(
      name: json['name'],
      isComplete: json['isComplete'],
    );
  }
}
