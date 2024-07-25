import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class FirestoreData<T> extends Equatable {
  final String id;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const FirestoreData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson();

  String get documentName => id;

  T copyWith();

  @override
  List<Object?> get props;

  T fromJson(Map<String, dynamic> json);
}
