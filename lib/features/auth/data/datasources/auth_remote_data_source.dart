import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );

      if (res.user == null) {
        throw const ServerException('User is null!');
      }
      return UserModel.fromJson(res.user!.toJson()).copyWith(email: email);
    } catch (e) {
      debugPrint(e.toString());
      if (e is AuthException) {
        throw ServerException(e.message);
      } else {
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (res.user == null) {
        throw const ServerException('User is null!');
      }
      return UserModel.fromJson(res.user!.toJson()).copyWith(email: email);
    } catch (e) {
      debugPrint(e.toString());
      if (e is AuthException) {
        throw ServerException(e.message);
      } else {
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) return null;

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', currentUserSession!.user.id);
      return UserModel.fromJson(userData.first).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
