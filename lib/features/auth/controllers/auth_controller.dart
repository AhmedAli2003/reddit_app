import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/app/shared/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

final authStateChangeProvider = StreamProvider<User?>(
  (ref) => ref.watch(authControllerProvider.notifier).authStateChange,
);

final getUserDataProvider = StreamProvider.family<UserModel, String>(
  (ref, uid) => ref.watch(authControllerProvider.notifier).getUserData(uid),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // for loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true; // start loading
    final either = await _authRepository.signInWithGoogle();
    state = false; // end loading
    either.fold(
      (failure) => showSnackBar(context, failure.message),
      (userModel) => _ref.read(userProvider.notifier).update((_) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logout() async {
    state = true;
    await _authRepository.logout();
    state = false;
  }
}
