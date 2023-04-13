// import 'package:flutter_test/flutter_test.dart';

// import 'package:base_repository/base_repository.dart';

// void main() {
//   test('adds one to input values', () {
//     final calculator = Calculator();
//     expect(calculator.addOne(2), 3);
//     expect(calculator.addOne(-7), -6);
//     expect(calculator.addOne(0), 1);
//   });
// }

import 'dart:async';

import 'package:base_repository/callback_handler/misc/enum_list.dart';
import 'package:base_repository/callback_handler/misc/typedef_list.dart';
import 'package:base_repository/repository/domain/local_repository/exception/local_repository_exception.dart';
import 'package:base_repository/repository/domain/local_repository/model/box_type.dart';
import 'package:base_repository/repository/domain/remote_repository/misc/typedef_list.dart';
import 'package:base_repository/repository/domain/remote_repository/remote_repository.dart';
import 'package:base_repository/repository/domain/model/dto.dart';
import 'package:base_repository/callback_handler/model/base_callback_result.dart';
import 'package:base_repository/repository/domain/local_repository/local_repository.dart';
import 'package:base_repository/repository/domain/local_repository/model/local_data.dart';
import 'package:base_repository/repository/domain/remote_repository/model/api_url.dart';
import 'package:retrofit/dio.dart';

class GeneralResponseBody<T extends DTO> extends DTO {
  String? success;
  T? data;
  String? message;

  @override
  Json toJson() => {
        'success': success,
        'data': data,
        'message': message,
      };
}

class User extends DTOWithLocalIdentifier<int> {
  final int id;
  User({required this.id, required super.localId});

  factory User.fromJson(Json json) => User(
        id: json['id'],
        localId: json['localId'],
      );

  @override
  Json toJson() => {
        'id': id,
      };
}

class BaseCbResult<T> extends CallbackResult<T, String> {
  const BaseCbResult({
    required super.callbackStatus,
    super.data,
    super.errors,
  });
}

enum ProjectApiUrl implements ApiUrl {
  prod('prod', 'prod.com');

  const ProjectApiUrl(this.typeName, this.url);

  @override
  final String typeName;

  @override
  final String url;
}

abstract class BaseRemoteRepository
    extends RemoteRepository<GeneralResponseBody, ProjectApiUrl> {
  BaseRemoteRepository([super.subType = ProjectApiUrl.prod]);

  @override
  Future<BaseCbResult<T>> request<T extends DTO>(
      ClientCallback<GeneralResponseBody> callback) async {
    return BaseCbResult<T>(
      callbackStatus: CallbackStatus.success,
      data: (await callback()).data.data as T,
    );
  }

  @override
  HeadersType headers = {
    'accept': 'application/json',
    'content': 'application/json',
  };

  @override
  OnErrorDioInterceptor onError = (error, handler) {
    return handler.next(error);
  };

  @override
  OnRequestDioInterceptor onRequest = (request, handler) {
    return handler.next(request);
  };

  @override
  OnResponseDioInterceptor onResponse = (response, handler) {
    return handler.next(response);
  };
}

class GetUserPayload {
  final int id;
  const GetUserPayload(this.id);
}

abstract class UserRepository {
  Future<BaseCbResult<User>> getUser(GetUserPayload payload);
}

abstract class UserRetrofitClient {
  Future<HttpResponse<GeneralResponseBody<User>>> getUser(int id);
}

class UserRemoteRepository extends BaseRemoteRepository
    implements UserRepository {
  late UserRetrofitClient _client;

  @override
  Future<BaseCbResult<User>> getUser(GetUserPayload payload) =>
      request(() => _client.getUser(payload.id));
}

enum BoxType implements BoxSubType {
  dev('dev');

  const BoxType(this.typeName);

  @override
  final String typeName;

  @override
  String toString() => typeName;
}

abstract class BaseLocalRepository<Entity extends DTOWithLocalIdentifier<int>>
    extends LocalRepository<Entity, int, BoxType> {
  BaseLocalRepository([super.subType = BoxType.dev]);

  @override
  Future<BaseCbResult<DataType>> request<DataType>(
      Future<DataType> Function() callback) async {
    try {
      final result = await callback();
      return BaseCbResult(callbackStatus: CallbackStatus.success, data: result);
    } on EntityAlreadyExists {
      return const BaseCbResult(
        callbackStatus: CallbackStatus.fail,
        errors: 'Entity is already exists',
      );
    } on EntityDoNotExists {
      return const BaseCbResult(
        callbackStatus: CallbackStatus.fail,
        errors: 'Entity do not exists',
      );
    } on FromJsonFail {
      rethrow;
    } catch (e) {
      return const BaseCbResult(callbackStatus: CallbackStatus.fail);
    }
  }
}

class UserLocalRepository extends BaseLocalRepository<User>
    implements UserRepository {
  @override
  final String boxName = 'user';

  @override
  User fromJson(Json json) => User.fromJson(json);

  @override
  Future<BaseCbResult<User>> getUser(GetUserPayload payload) =>
      request(() => read(payload.id));
}

Future<User?> getUser({
  required UserRepository repository,
  required GetUserPayload payload,
}) async =>
    (await repository.getUser(payload)).data;

void main() {
  getUser(
    repository: UserRemoteRepository(),
    payload: const GetUserPayload(0),
  );
}
