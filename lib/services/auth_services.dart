import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/verify_otp.dart';

// throw or rethrow to calling method
class AuthServices {
  static Future<void> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static int? forceResendingToken;

  static Future<void> phoneSignIn({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91 $phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException error) {
          throw error.message.toString();
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          Navigator.pop(context); // for loader
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtp(verificationId),
            ),
          );
        },
        forceResendingToken: forceResendingToken,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> verifyOtp(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      forceResendingToken = null;
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    } catch (error) {
      if (error.toString().contains("google_auth")) {
        throw "Google Sign In failed";
      }
      rethrow;
    }
  }
}
