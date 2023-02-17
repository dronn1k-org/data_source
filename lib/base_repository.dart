library base_repository;

import 'package:base_repository/base_repo_settings.dart';
import 'package:base_repository/callback_handler/interface/api_endpoint.dart';
import 'package:base_repository/callback_handler/model/repository_callback_handler.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';
import 'package:base_repository/enum/api_url.dart';
import 'package:base_repository/typedef/headers_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'callback_handler/interface/dto.dart';
import 'callback_handler/model/api_callback_result.dart';

abstract class BaseRepository<BASE_TYPE extends BaseApiEndpoint, ERRORS_TYPE> {
  final Dio dio = Dio();

  String get _baseUrl {
    switch (BaseRepoSettings.currentUrl) {
      case ApiUrl.prod:
        return BaseRepoSettings.prodUrl;
      case ApiUrl.dev:
        return BaseRepoSettings.devUrl;
    }
  }

  HeadersType get _headers => BaseRepoSettings.headers;

  Interceptor get _interceptor =>
      InterceptorsWrapper(onRequest: (request, handler) {
        request.baseUrl = _baseUrl;
        request.headers = _headers;
        return BaseRepoSettings.onRequest?.call(request, handler);
      }, onResponse: (response, handler) {
        return BaseRepoSettings.onResponse?.call(response, handler);
      }, onError: (error, handler) {
        return BaseRepoSettings.onError?.call(error, handler);
      });

  @mustCallSuper
  BaseRepository() {
    dio.options = BaseRepoSettings.baseDioOptions;
    dio.interceptors.add(_interceptor);
    BaseRepoSettings.onRepoInit?.call(dio);
  }

  @protected
  abstract final RepositoryCallbackHandler<BASE_TYPE, ERRORS_TYPE>
      callbackHandler;

  @protected
  Future<ApiCallbackResult<DTO, ERRORS_TYPE>> Function(
          ClientCallback<BASE_TYPE> callback)
      get request => callbackHandler.request;
}
