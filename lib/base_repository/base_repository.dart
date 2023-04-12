library base_repository;

import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';
import 'package:base_repository/interface/data_source.dart';
import 'package:base_repository/remote_data_source/interface/api_url.dart';
import 'package:base_repository/base_repository/typedef/headers_type.dart';
import 'package:base_repository/base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/interface/dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

abstract class RemoteRepository<
    EntityType extends DTO,
    ErrorsType,
    CallbackResultType extends CallbackResult<DTO, ErrorsType>,
    RepoSubType extends ApiUrl> extends Repository<RepoSubType> {
  final Dio dio = Dio();

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
        request.baseUrl = subType.url;
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
  Future<CallbackResultType> request<T extends DTO>(
      ClientCallback<EntityType> callback);

  // @override
  // Future<void> changeSubType(ApiUrl newSubType) async {
  //   super.changeSubType(newSubType);
  // }
}
