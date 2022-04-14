import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class Task extends Equatable {
  /// Unique id
  final String id;
  final String details;
  final bool isCompleted;

  Task({String? id, this.details = '', this.isCompleted = false})
      : this.id = id ?? Uuid().v4();

  @override
  List<Object?> get props => [id, details, isCompleted];

  static Task fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String?,
      details: json['details'] as String,
      isCompleted: json['isCompleted'] as bool);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'details': details,
        'isCompleted': isCompleted
      };

  Task copyWith({String? details, bool? isCompleted}) {
    return Task(
      id: this.id,
      details: details ?? this.details,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
