import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  static DocumentReference<Map<String, dynamic>> getCurrentUserDocRef() {
    // Returns a DocumentReference with the provided path.
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      // Reads the document referenced by this [DocumentReference].
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await getCurrentUserDocRef().get();

      // Contains all the data of this document snapshot
      Map<String, dynamic>? fields = docSnapshot.data();

      return fields;
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> setCurrentUserData(Map<String, dynamic> data) async {
    try {
      await getCurrentUserDocRef().set(
        data,
        SetOptions(merge: true),
      );
    } catch (error) {
      rethrow;
    }
  }
}