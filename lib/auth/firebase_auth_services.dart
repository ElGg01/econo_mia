import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        print('Wrong password');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithGoogleService() async {
    try {
      // Trigger the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Obtain the GoogleSignInAuthentication object
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create a new credential using the Google sign-in authentication
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle error
    }
    return null;
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future<void> reAuthenticateWithEmailAndPassword(
      String? email, String password) async {

    if (email == null) return;
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password
    );
    await _auth.currentUser?.reauthenticateWithCredential(credential);
  }
}
