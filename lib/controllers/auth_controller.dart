import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final Rxn<User> user = Rxn();
  // Text controllers for login page
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Login method
  Future<UserCredential?> loginMethod({required BuildContext context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      user.value = userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // Signup method
  Future<UserCredential?> signupMethod(
      {required String email,
      required String password,
      required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // Storing data method
  void storeUserData(
      {required String name,
      required String password,
      required String email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(auth.currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'email': email,
      'id': auth.currentUser!.uid,
      'imageUrl': '',
      'cart_count': "00",
      'wishlist_count': "00",
      'order_count': "00",
    });
  }

  // Signout method
  Future<void> signoutMethod(BuildContext context) async {
    try {
      await auth.signOut();
      Get.offAll(() => const Wrapper());
    } catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
  }
}
