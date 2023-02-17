library base_repository;

import 'package:base_repository/interface/base_response_body.dart';
import 'package:base_repository/callback_handler/repository_callback_handler.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';
import 'package:base_repository/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../interface/dto.dart';
import '../callback_handler/api_callback_result.dart';

abstract class BaseRepository<BASE_TYPE extends BaseResponseBody, ERRORS_TYPE> {
  final Dio dio = Dio();

  @protected
  abstract ApiUrl currentUrl;

  String get _baseUrl => currentUrl.url;

  @protected
  abstract HeadersType headers;

  @protected
  abstract OnRequestDioInterceptor onRequest;

  @protected
  abstract OnResponseDioInterceptor onResponse;

  @protected
  abstract OnErrorDioInterceptor onError;

  BaseOptions baseDioOptions = BaseOptions(
    validateStatus: (_) => true,
    connectTimeout: const Duration(seconds: 15),
  );

  Interceptor get _interceptor =>
      InterceptorsWrapper(onRequest: (request, handler) {
        request.baseUrl = _baseUrl;
        request.headers = headers;
        return onRequest.call(request, handler);
      }, onResponse: (response, handler) {
        return onResponse.call(response, handler);
      }, onError: (error, handler) {
        return onError.call(error, handler);
      });

  @mustCallSuper
  BaseRepository() {
    dio.options = baseDioOptions;
    dio.interceptors.add(_interceptor);
  }

  @protected
  abstract RepositoryCallbackHandler<BASE_TYPE, ERRORS_TYPE> callbackHandler;

  @protected
  Future<ApiCallbackResult<DTO, ERRORS_TYPE>> Function(
          ClientCallback<BASE_TYPE> callback)
      get request => callbackHandler.request;
}
