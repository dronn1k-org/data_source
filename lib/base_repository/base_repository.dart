library base_repository;

import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/interface/base_response_body.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';
import 'package:base_repository/remote_data_source/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/interface/dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseRepository<BASE_TYPE extends BaseResponseBody, ERRORS_TYPE,
    CB_RESULT_TYPE extends BaseCallbackResult<DTO, ERRORS_TYPE>> {
  final Dio dio = Dio();

  @protected
  abstract final ApiUrl currentUrl;

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
  Future<CB_RESULT_TYPE> request<T extends DTO>(
      ClientCallback<BASE_TYPE> callback);
}
