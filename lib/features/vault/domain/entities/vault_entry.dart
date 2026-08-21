import 'package:equatable/equatable.dart';

class VaultEntry extends Equatable {
  final String id;
  final String title;
  final String username;
  final String password;
  final String? url;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VaultEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  VaultEntry copyWith({
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    DateTime? updatedAt,
  }) {
    return VaultEntry(
      id: id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'url': url,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory VaultEntry.fromJson(Map<String, dynamic> json) => VaultEntry(
        id: json['id'],
        title: json['title'],
        username: json['username'],
        password: json['password'],
        url: json['url'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  @override
  List<Object?> get props => [id, title, username, password, url, notes];
}
