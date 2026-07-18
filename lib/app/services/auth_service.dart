import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    // If we are on the splash screen, the SplashController handles routing.
    // However, if the user logs out from Home, we should route them back to Login immediately.
    // If the user logs in from Login, we route them to Home.
    if (user == null) {
      if (Get.currentRoute != Routes.splash && Get.currentRoute != Routes.signup) {
        Get.offAllNamed(Routes.login);
      }
    } else {
      if (Get.currentRoute == Routes.login || Get.currentRoute == Routes.signup) {
        Get.offAllNamed(Routes.main);
      }
    }
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> registerWithEmail(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Failed', e.message ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(credential);
      
    } catch (e) {
      Get.snackbar('Google Sign-In Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
