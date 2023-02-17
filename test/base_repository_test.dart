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
import 'package:base_repository/callback_handler/api_callback_result.dart';
import 'package:base_repository/callback_handler/repository_callback_handler.dart';
import 'package:base_repository/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';

class General<T extends DTO> extends BaseResponseBody {
  String? success;
  T? data;
  String? message;
}

class GeneralRepository extends BaseRepository<General<DTO>, String> {
  @override
  late RepositoryCallbackHandler<General<DTO>, String> callbackHandler =
      RepositoryCallbackHandler(
    onResponse: _onResponse,
    frontExceptionHandler: _frontExceptionHandler,
  );

  FutureOr<ApiCallbackResult<DTO, String>> _onResponse(
      ClientCallbackResult<General<DTO>> callbackResult) {
    return const ApiCallbackResult<DTO, String>(
        callbackStatus: ApiCallbackStatus.success);
  }

  FutureOr<ApiCallbackResult<DTO, String>> _frontExceptionHandler<String>(
      Object exception, StackTrace stackTrace) {
    return ApiCallbackResult<DTO, String>(
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
  prod('asdas', _temp);

  const ProjectApiUrl(this.url, this.title);

  @override
  final String url;
  @override
  final String Function() title;
}

String _temp() => 'dasdas';

void main() {}
