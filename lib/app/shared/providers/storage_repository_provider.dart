import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/shared/failure.dart';
import 'package:reddit_app/app/shared/providers/shared_providers.dart';
import 'package:reddit_app/app/shared/type_defs.dart';

final firebaseStorageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.read(firebaseStorageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  const StorageRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      final uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return Right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
