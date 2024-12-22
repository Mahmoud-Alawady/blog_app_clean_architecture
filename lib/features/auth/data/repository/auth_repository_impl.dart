import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.authRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left(Failure('No internet connection!'));
      }
      final user = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return Right(user);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left(Failure('No internet connection!'));
      }
      final user = await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      return Right(user);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return Left(Failure('user not logged in'));
        }
        return Right(UserModel(
          id: session.user.id,
          name: '',
          email: session.user.email ?? '',
        ));
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) return Left(Failure('user not logged in'));
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
