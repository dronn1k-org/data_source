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
import 'package:base_repository/callback_handler/enum/api_callback_status.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';
import 'package:base_repository/interface/base_response_body.dart';
import 'package:base_repository/interface/dto.dart';
import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/callback_handler/repository_callback_handler.dart';
import 'package:base_repository/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';

class GeneralResponseBody<T extends DTO> extends BaseResponseBody {
  String? success;
  T? data;
  String? message;
}

class GeneralCbResult<T> extends BaseCallbackResult<T, String> {
  const GeneralCbResult({
    required super.callbackStatus,
    super.statusCode,
    super.data,
    super.errors,
  });
}

class GeneralRepository
    extends BaseRepository<GeneralResponseBody<DTO>, String> {
  @override
  late RepositoryCallbackHandler<GeneralResponseBody<DTO>, String>
      callbackHandler = RepositoryCallbackHandler(
    onResponse: _onResponse,
    frontExceptionHandler: _frontExceptionHandler,
  );

  // With modified callback result
  FutureOr<GeneralCbResult<DTO>> _onResponse(
      ClientCallbackResult<GeneralResponseBody<DTO>> callbackResult) {
    return const GeneralCbResult<DTO>(
        callbackStatus: ApiCallbackStatus.success);
  }

  // Without modified callback result
  FutureOr<BaseCallbackResult<DTO, String>> _frontExceptionHandler(
      Object exception, StackTrace stackTrace) {
    return const BaseCallbackResult<DTO, String>(
        callbackStatus: ApiCallbackStatus.frontException);
  }

  @override
  covariant ProjectApiUrl currentUrl = ProjectApiUrl.prod;

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

enum ProjectApiUrl implements ApiUrl {
  prod('asdas');

  const ProjectApiUrl(this.url);

  @override
  final String url;
}

void main() {}
