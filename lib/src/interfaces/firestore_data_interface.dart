import 'package:firestore_package/src/models/firestore_data.dart';

abstract class FirestoreDataInterface<T extends FirestoreData> {
  Future<void> saveData(T data);

  Future<void> deleteData(T data);

  Future<void> updateData(T data);

  Future<T?> getData(String id);

  Future<bool> existsData(String id);

  Future<List<T>> getAllData();

  Future<void> deleteAllData();

  Future<void> deleteDataById(String id);

  Future<List<T>> getAllDataByField(String field, String value);

  Future<T?> getDataByField(String field, String value);

  Future<List<T>> getAllDataByFieldsMap(Map<String, String> fieldsMap);

  // Future<bool> existsDataByField(String field, String value);
}
