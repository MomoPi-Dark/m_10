import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>?> find(
    String collection, {
    required Object field,
    required Object isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
    int? limit,
    DocumentSnapshot<Object?>? startAfter,
  }) async {
    try {
      var queryCollection = _firestore.collection(collection).where(
            field,
            isEqualTo: isEqualTo,
            arrayContains: arrayContains,
            arrayContainsAny: arrayContainsAny,
            whereIn: whereIn,
            whereNotIn: whereNotIn,
            isNull: isNull,
            isGreaterThan: isGreaterThan,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            isLessThan: isLessThan,
            isLessThanOrEqualTo: isLessThanOrEqualTo,
            isNotEqualTo: isNotEqualTo,
          );

      if (startAfter != null) {
        queryCollection = queryCollection.startAfterDocument(startAfter);
      }

      if (limit != null) {
        queryCollection = queryCollection.limit(limit);
      }

      return await queryCollection.get();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOne(
    String collection, {
    required Object field,
    required Object isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final querySnapshot = await find(
        collection,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
        limit: 1,
      );

      if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneAndUpdate(
    String collection, {
    required Object field,
    required Object isEqualTo,
    required Map<String, dynamic> data,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final querySnapshot = await findOne(
        collection,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      );

      if (querySnapshot != null && querySnapshot.exists) {
        await querySnapshot.reference.update(data);
        return querySnapshot;
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneAndDelete(
    String collection, {
    required String field,
    required Object isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    try {
      final querySnapshot = await findOne(
        collection,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      );

      if (querySnapshot != null && querySnapshot.exists) {
        await querySnapshot.reference.delete();
        return querySnapshot;
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  CollectionReference<Map<String, dynamic>> getCollection(String collection) {
    return _firestore.collection(collection);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String documentId,
  ) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
    String collection,
    String documentId, {
    int? limit,
  }) {
    if (limit != null) {
      return _firestore
          .collection(collection)
          .doc(documentId)
          .snapshots()
          .take(limit);
    } else {
      return _firestore.collection(collection).doc(documentId).snapshots();
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>?>> streamData(
    String collection, {
    required String field,
    required Object isEqualTo,
    int? limit,
  }) async {
    return find(collection, field: field, isEqualTo: isEqualTo, limit: limit)
        .asStream();
  }

  Future<bool> hasCollection(String collection) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(collection).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking collection: $e');
      return false;
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addData(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
