import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/app/constants/firebase_constants.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
import 'package:reddit_app/app/shared/type_defs.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firebaseFirestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  const AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel.fromCredential(userCredential.user!);
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return Right(userModel);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message!));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
