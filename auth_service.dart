import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/

  Future<Map<String, dynamic>?> signInWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        return userDoc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<User?> registerWithEmail(
      String email, String password, String userType) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection(userType).doc(result.user!.uid).set({
        'email': email,
      });

      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> registerProfessional({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthdate,
    required String phone,
    required String username,
    required String address,
    required String businessName,
    required String description,
    required String category,
    required List<String> subCategories,
    required dynamic quality, // Experiencia
    required dynamic cost, // Pago
    required dynamic speed, // Disponibilidad
    required dynamic generalRating, // Calificación general
    required dynamic jobsCompleted, // Pago
    required dynamic latitude, // Disponibilidad
    required dynamic longitude, // Calificación general
  }) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Crear documento del usuario en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'secondLastName': secondLastName,
          'birthdate': birthdate,
          'phone': phone,
          'username': username,
          'address': address,
          'businessName': businessName,
          'description': description,
          'category': category,
          'subCategories': subCategories,
          'userType': 'professional',
          // Campos de calificación
          'quality': null, // Experiencia
          'cost': null, // Pago
          'speed': null, // Disponibilidad
          'generalRating': null, // Calificación general
          'jobsCompleted': null, // Pago
          'latitude': null, // Disponibilidad
          'longitude': null, // Calificación general
        });
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> registerClient({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthdate,
    required String phone,
    required String username,
    required String address,
    required String category,
    required List<String> subCategories,
    required dynamic experience, // Experiencia
    required dynamic payment, // Pago
    required dynamic availability, // Disponibilidad
    required dynamic generalRating, // Calificación general
    required dynamic jobsCompleted, // Pago
    required dynamic latitude, // Disponibilidad
    required dynamic longitude, // Calificación general
  }) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Crear documento del usuario en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'secondLastName': secondLastName,
          'birthdate': birthdate,
          'phone': phone,
          'username': username,
          'address': address,
          'category': category,
          'subCategories': subCategories,
          'userType': 'client',
          // Campos de calificación
          'experience': null, // Experiencia
          'payment': null, // Pago
          'availability': null, // Disponibilidad
          'generalRating': null, // Calificación general
          'jobsCompleted': null, // Pago
          'latitude': null, // Disponibilidad
          'longitude': null, // Calificación general
        });
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Método para verificar si el correo electrónico ya está en uso
  Future<bool> checkEmailExists(String email) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  // Método para verificar si el nombre de usuario ya está en uso
  Future<bool> checkUsernameExists(String username) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }
}
