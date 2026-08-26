// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Brands {
  const Brands({required this.id, required this.name});
  final String id;
  final String name;

  Brands copyWith({String? id, String? name}) {
    return Brands(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Brands.fromMap(Map<String, dynamic> map) {
    return Brands(id: map['id'] as String, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Brands.fromJson(String source) =>
      Brands.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Brands(id: $id, name: $name)';

  @override
  bool operator ==(covariant Brands other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
