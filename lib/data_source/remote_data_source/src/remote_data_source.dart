import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/dto/dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'misc/typedef_list.dart';

abstract base class RemoteDataSource<BaseBody extends DTO> {
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

  RemoteDataSource() {
    dio.options = baseDioOptions;
    dio.interceptors.add(_interceptor);
  }

  @protected
  Future<CallbackResult> request<T extends DTO>(
      ClientCallback<BaseBody> callback);
}
