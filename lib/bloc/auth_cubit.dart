import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(const AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthFailure(message: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(const AuthFailure(
            message: "Wrong password provided for that user."));
      }
    } catch (error) {
      emit(const AuthFailure(message: "Error..."));
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userID': userCredential.user!.uid,
        'userName': username,
        'email': email,
      });

      userCredential.user!.updateDisplayName(username);

      emit(const AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const AuthFailure(message: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthFailure(
            message: "The account already exists for that email."));
      }
    } catch (error) {
      emit(const AuthFailure(message: "Error..."));
    }
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}
