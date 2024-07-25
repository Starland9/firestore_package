import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_package/src/interfaces/firestore_data_interface.dart';
import 'package:firestore_package/src/models/firestore_data.dart';

abstract class FirestoreDataRepository<T extends FirestoreData<T>>
    implements FirestoreDataInterface<T> {
  final FirebaseFirestore _firestore;

  FirestoreDataRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  T fromJson(Map<String, dynamic> json);

  String get collectionName;

  // Saves the provided data to Firestore.
  @override
  Future<DocumentReference?> saveData(T data) async {
    await _firestore.collection(collectionName).doc(data.id).set(data.toJson());
    return _firestore.collection(collectionName).doc(data.id);
  }

  /// Deletes the specified [data] from Firestore.
  ///
  /// The [data] parameter represents the data to be deleted. It must be of type [T],
  /// which extends [FirestoreData<T>].
  ///
  /// This function deletes the [data] from the Firestore collection specified by
  /// [collectionName]. The deletion is performed asynchronously, and the function
  /// does not return any value.
  ///
  /// Throws a [FirebaseException] if there is an error deleting the data.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = FirestoreDataRepository<MyData>(firestore: Firestore.instance);
  /// final data = MyData(id: '123', name: 'John Doe');
  /// await repository.deleteData(data);
  /// ```
  @override
  Future<void> deleteData(T data) async {
    await _firestore.collection(collectionName).doc(data.id).delete();
  }

  @override

  /// Updates the specified [data] in Firestore.
  ///
  /// The [data] parameter represents the data to be updated. It must be of type [T],
  /// which extends [FirestoreData<T>].
  ///
  /// This function updates the [data] in the Firestore collection specified by
  /// [collectionName]. The update is performed asynchronously, and the function
  /// does not return any value.
  ///
  /// Throws a [FirebaseException] if there is an error updating the data.
  Future<void> updateData(T data) async {
    final map = data.toJson();
    map['updatedAt'] = Timestamp.now();

    await _firestore.collection(collectionName).doc(data.id).update(map);
  }

  /// Retrieves data from Firestore based on the provided [id].
  ///
  /// This function asynchronously retrieves the data from the Firestore collection
  /// specified by [collectionName] based on the provided [id]. If the data exists,
  /// it is converted from JSON to the type [T] using the [fromJson] method
  /// and returned. Otherwise, it returns null.
  ///
  /// Returns a [Future] that completes with the retrieved data of type [T] or
  /// null if the data does not exist.
  ///
  /// Throws a [FirebaseException] if there is an error retrieving the data.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = FirestoreDataRepository<MyData>(firestore: Firestore.instance);
  /// final id = '123';
  /// final data = await repository.getData(id);
  /// ```
  @override
  Future<T?> getData(String id) async {
    final snapshot = await _firestore.collection(collectionName).doc(id).get();
    if (snapshot.exists) {
      return fromJson(snapshot.data()!);
    }
    return null;
  }

  /// Asynchronously checks if a document with the given [id] exists in the Firestore collection.
  ///
  /// Returns a [Future] that completes with a boolean value.
  ///
  /// - `true` if the document exists.
  /// - `false` if the document does not exist.
  ///
  /// Throws a [FirebaseException] if there is an error retrieving the data.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = FirestoreDataRepository<MyData>(firestore: Firestore.instance);
  /// final id = '123';
  /// final exists = await repository.existsData(id);
  /// ```
  @override
  Future<bool> existsData(String id) async {
    final snapshot = await _firestore.collection(collectionName).doc(id).get();
    return snapshot.exists;
  }

  @override

  /// Asynchronously retrieves all data from the Firestore collection.
  /// Returns a [Future] that completes with a list of [T] objects.
  Future<List<T>> getAllData() async {
    final snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }

  @override
  Future<void> deleteAllData() async {
    await _firestore.collection(collectionName).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  @override
  Future<void> deleteDataById(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }

  @override
  Future<List<T>> getAllDataByField(String field, String value) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .get();
    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }

  @override
  Future<T?> getDataByField(String field, String value) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return fromJson(snapshot.docs.first.data());
    }
    return null;
  }

  @override
  Future<List<T>> getAllDataByFieldsMap(Map<String, String> fieldsMap) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(fieldsMap.keys.first, isEqualTo: fieldsMap.values.first)
        .get();

    return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
  }
}
