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

import 'package:base_repository/base_repository/base_repository.dart';
import 'package:base_repository/callback_handler/enum/callback_status.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';
import 'package:base_repository/callback_handler/typedef/json_type.dart';
import 'package:base_repository/interface/dto.dart';
import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/local_data_source/enum/entity_exception_type.dart';
import 'package:base_repository/local_data_source/exception/entity_exception.dart';
import 'package:base_repository/local_data_source/local_repository.dart';
import 'package:base_repository/local_data_source/model/local_data.dart';
import 'package:base_repository/remote_data_source/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';
import 'package:retrofit/dio.dart';

class GeneralResponseBody<T extends DTO> extends DTO {
  String? success;
  T? data;
  String? message;

  @override
  JSON_TYPE toJson() => {
        'success': success,
        'data': data,
        'message': message,
      };
}

class User extends DTOWithLocalIdentifier<int> {
  final int id;
  User({required this.id, required super.localId});

  factory User.fromJson(JSON_TYPE json) => User(
        id: json['id'],
        localId: json['localId'],
      );

  @override
  JSON_TYPE toJson() => {
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

class BaseRemoteRepository extends RemoteRepository<GeneralResponseBody<DTO>,
    String, BaseCbResult<DTO>, ProjectApiUrl> {
  @override
  Future<BaseCbResult<T>> request<T extends DTO>(
      ClientCallback<GeneralResponseBody<DTO>> callback) async {
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

// abstract class Payload {
//   const Payload();
// }

// abstract class LocalPayload extends Payload {
//   const LocalPayload();
// }

// abstract class RemotePayload extends Payload {
//   const RemotePayload();
// }

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

class UserLocalRepository extends LocalRepository<User, int>
    implements UserRepository {
  @override
  final String boxName = 'user';

  @override
  User fromJson(JSON_TYPE json) => User.fromJson(json);

  @override
  Future<BaseCbResult<User>> getUser(GetUserPayload payload) async {
    try {
      return BaseCbResult(
        callbackStatus: CallbackStatus.success,
        data: await read(payload.id),
      );
    } on EntityException catch (exception) {
      switch (exception.type) {
        case EntityExceptionType.alreadyExists:
        case EntityExceptionType.doNotExists:
          return const BaseCbResult(
            callbackStatus: CallbackStatus.fail,
          );
        case EntityExceptionType.fromJsonFail:
          return const BaseCbResult(
            callbackStatus: CallbackStatus.fail,
          );
      }
    } catch (e) {
      return const BaseCbResult(callbackStatus: CallbackStatus.fail);
    }
  }
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
