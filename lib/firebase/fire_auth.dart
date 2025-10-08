import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(// devuelve un objeto
      String email, String password) async {
        //recibe email y password(2parametros)
    try {
      //Creacion de un objeto con las credenciales, si es correcto
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user!.sendEmailVerification(); //envia correo de verificacion

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }  
  Future<User?> signInWithEmailAndPassword(// devuelve un objeto
      String email, String password) async {
        //recibe email y password(2parametros)
    try {
      //Creacion de un objeto con las credenciales, si es correcto
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if(user != null && !user.emailVerified){
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before signing in.'
        );
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }  
}

