import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/app/shared/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
