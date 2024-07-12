import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Query<Map<String, dynamic>>> find(
    String collection, {
    int? limit,
    DocumentSnapshot<Object?>? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> queryCollection =
          _firestore.collection(collection);

      if (limit != null) {
        queryCollection = queryCollection.limit(limit);
      }

      if (lastDocument != null) {
        queryCollection = queryCollection.startAfterDocument(lastDocument);
      }

      return queryCollection;
    } catch (e) {
      // log('Error in find: $e');
      throw Exception('Error fetching data from $collection: $e');
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
      final queryCollection = await find(
        collection,
        limit: 1,
      );

      final querySnapshot = await queryCollection
          .where(
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
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }

      return null;
    } catch (e) {
      // log('Error in findOne: $e');
      throw Exception('Error fetching single document from $collection: $e');
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
      // log('Error in findOneAndUpdate: $e');
      throw Exception('Error updating document in $collection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneAndDelete(
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
      // log('Error in findOneAndDelete: $e');
      throw Exception('Error deleting document in $collection: $e');
    }
  }

  CollectionReference<Map<String, dynamic>> getCollection(String collection) {
    return _firestore.collection(collection);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String documentId,
  ) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      // log('Error in getDocument: $e');
      throw Exception(
        'Error fetching document $documentId from $collection: $e',
      );
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
    String collection,
    String documentId, {
    int? limit,
  }) {
    try {
      if (limit != null) {
        return _firestore
            .collection(collection)
            .doc(documentId)
            .snapshots()
            .take(limit);
      } else {
        return _firestore.collection(collection).doc(documentId).snapshots();
      }
    } catch (e) {
      // log('Error in getDocumentStream: $e');
      throw Exception(
          'Error streaming document $documentId from $collection: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSubDocumentStream(
    String collection,
    String documentId,
    String subcollection, {
    required String subdocumentId,
    int? limit,
  }) {
    try {
      var collectionReference =
          FirebaseFirestore.instance.collection(collection);
      var documentReference = collectionReference.doc(documentId);
      var subcollectionReference = documentReference.collection(subcollection);

      if (limit != null) {
        return subcollectionReference
            .doc(subdocumentId)
            .snapshots()
            .take(limit);
      } else {
        return subcollectionReference.doc(subdocumentId).snapshots();
      }
    } catch (e) {
      // log('Error in getSubDocumentStream: $e');
      throw Exception(
          'Error streaming subdocument $subdocumentId from $subcollection: $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCollectionsStream(
    String collection,
    String documentId,
    String subcollection,
  ) {
    try {
      var collectionReference =
          FirebaseFirestore.instance.collection(collection);
      var documentReference = collectionReference.doc(documentId);
      var subcollectionReference = documentReference.collection(subcollection);

      return subcollectionReference.snapshots();
    } catch (e) {
      // log('Error in getSubCollectionStream: $e');
      throw Exception(
          'Error streaming subcollection $subcollection from document $documentId in $collection: $e');
    }
  }

  Future<bool> hasCollection(String collection) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(collection).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // log('Error checking collection: $e');
      return false;
    }
  }

  Future<bool> hasSubDocument(
    String parentCollection,
    String parentId,
    String subcollection,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(parentCollection)
          .doc(parentId)
          .collection(subcollection)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // log('Error in hasSubDocument: $e');
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
      // log('Error in addData: $e');
      throw Exception('Error adding data to $collection: $e');
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addDataToSubcollection(
    String parentCollection,
    String parentId,
    String subcollection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore
          .collection(parentCollection)
          .doc(parentId)
          .collection(subcollection)
          .add(data);
    } catch (e) {
      // log('Error in addDataToSubcollection: $e');
      throw Exception('Error adding data to $subcollection: $e');
    }
  }

  Future<Query<Map<String, dynamic>>> findSubcollection(
    String parentCollection,
    String parentId,
    String subcollection, {
    int? limit,
    DocumentSnapshot<Object?>? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> queryCollection = _firestore
          .collection(parentCollection)
          .doc(parentId)
          .collection(subcollection);

      if (limit != null) {
        queryCollection = queryCollection.limit(limit);
      }

      if (lastDocument != null) {
        queryCollection = queryCollection.startAfterDocument(lastDocument);
      }

      return queryCollection;
    } catch (e) {
      // log('Error in findSubcollection: $e');
      throw Exception(
          'Error fetching data from $parentCollection - ($subcollection): $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findOneSubcollection(
    String parentCollection,
    String parentId,
    String subcollection, {
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
      final queryCollection = await findSubcollection(
        parentCollection,
        parentId,
        subcollection,
        limit: 1,
      );

      final querySnapshot = await queryCollection
          .where(
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
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return doc;
      }

      throw Exception("Document not found");
    } catch (e) {
      // log('Error in findOneSubcollection: $e');
      throw Exception('Error fetching document in $subcollection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      findOneAndUpdateSubcollection(
    String parentCollection,
    String parentId,
    String subcollection, {
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
      final querySnapshot = await findOneSubcollection(
        parentCollection,
        parentId,
        subcollection,
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

      throw Exception("Document not found");
    } catch (e) {
      // log('Error in findOneAndUpdateSubcollection: $e');
      throw Exception('Error updating document in $subcollection: $e');
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      findOneAndDeleteSubcollection(
    String parentCollection,
    String parentId,
    String subcollection, {
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
      final querySnapshot = await findOneSubcollection(
        parentCollection,
        parentId,
        subcollection,
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

      throw Exception("Document not found");
    } catch (e) {
      // log('Error in findOneAndDeleteSubcollection: $e');
      throw Exception('Error deleting document in $subcollection: $e');
    }
  }
}
