import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Auth{
  final FirebaseAuth auth = FirebaseAuth.instance;

  // create user with email and password
  Future<User?> createUserWithEmailAndPassword({required String email, required String password}) async{
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    return user;
  }

  // sign in with email and password
  Future<User?> signInWithEmailAndPassword({required String email, required String password}) async {
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = userCredential.user;
    return user;
  }

  // sign in with google
  Future<User?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    return user;
  }

  // send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async{
    await auth.sendPasswordResetEmail(email: email);
  }

  // verify email
  Future<void> verifyEmail() async{
    User? user = auth.currentUser;
    if(user != null && !user.emailVerified){
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async{
    await auth.signOut();
  }
}