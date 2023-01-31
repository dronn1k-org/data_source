library base_repository;

import 'package:base_repository/base_repo_settings.dart';
import 'package:base_repository/enum/api_url.dart';
import 'package:base_repository/typedef/headers_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository {
  @protected
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
        BaseRepoSettings.onRequest?.call(request, handler);
        return handler.next(request);
      }, onResponse: (response, handler) {
        BaseRepoSettings.onResponse?.call(response, handler);
        return handler.next(response);
      }, onError: (error, handler) {
        BaseRepoSettings.onError?.call(error, handler);
        return handler.next(error);
      });

  BaseRepository() {
    dio.options = BaseRepoSettings.baseDioOptions;
    dio.interceptors.add(_interceptor);
    BaseRepoSettings.onRepoInit?.call(dio);
  }
}
