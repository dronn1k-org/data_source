library base_repository;

import 'package:base_repository/callback_handler/model/base_callback_result.dart';
import 'package:base_repository/callback_handler/misc/typedef_list.dart';
import 'package:base_repository/repository/domain/remote_repository/misc/typedef_list.dart';
import 'package:base_repository/repository/domain/model/dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

abstract class RemoteRepository<BaseBody extends DTO> {
  final Dio dio = Dio();

  @protected
  abstract final String baseUrl;

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
        request.baseUrl = baseUrl;
        request.headers = headers;
        return onRequest.call(request, handler);
      }, onResponse: (response, handler) {
        return onResponse.call(response, handler);
      }, onError: (error, handler) {
        return onError.call(error, handler);
      });

  @mustCallSuper
  RemoteRepository() {
    dio.options = baseDioOptions;
    dio.interceptors.add(_interceptor);
  }

  @protected
  Future<CallbackResult> request<T extends DTO>(
      ClientCallback<BaseBody> callback);
}
