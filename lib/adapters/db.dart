import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('users').where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data()!;

        userData["docId"] = userDoc.id;

        return userData;
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos de usuario: $e');
      return null;
    }
  }

  Future<void> updateUserData(String docId, Map<String, dynamic> data) async {
    try {
      DocumentReference userRef = _db.collection("users").doc(docId);
      DocumentSnapshot userDoc = await userRef.get();

      if (!userDoc.exists) {
        print("El usuario con ID $docId no existe en Firestore.");
        return;
      }

      data.remove("docId");
      data.remove("id");

      await userRef.update(data);
      print("Usuario actualizado correctamente en Firestore.");
    } catch (e) {
      print("Error actualizando datos del usuario: $e");
    }
  }
}
