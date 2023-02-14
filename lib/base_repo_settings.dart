library base_repository;

import 'package:base_repository/enum/api_url.dart';
import 'package:base_repository/typedef/headers_type.dart';
import 'package:base_repository/typedef/interceptors_types.dart';
import 'package:base_repository/typedef/repo_init_type.dart';
import 'package:dio/dio.dart';

abstract class BaseRepoSettings {
  static String _prodUrl = '';
  static String get prodUrl => _prodUrl;

  static String _devUrl = '';
  static String get devUrl => _devUrl;

  static ApiUrl _currentUrl = ApiUrl.prod;
  static ApiUrl get currentUrl => _currentUrl;

  static HeadersType _headers = {};
  static HeadersType get headers => _headers;

  static BaseOptions _baseDioOptions = BaseOptions(
    validateStatus: (_) => true,
    connectTimeout: const Duration(seconds: 15),
  );
  static BaseOptions get baseDioOptions => _baseDioOptions;

  static OnRepositoryInit? _onRepoInit;
  static OnRepositoryInit? get onRepoInit => _onRepoInit;

  static OnRequestDioInterceptor? _onRequest;
  static OnRequestDioInterceptor? get onRequest => _onRequest;

  static OnResponseDioInterceptor? _onResponse;
  static OnResponseDioInterceptor? get onResponse => _onResponse;

  static OnErrorDioInterceptor? _onError;
  static OnErrorDioInterceptor? get onError => _onError;

  static void change({
    String? prodUrl,
    String? devUrl,
    ApiUrl? currentUrl,
    HeadersType? headers,
    BaseOptions? baseDioOptions,
    OnRepositoryInit? onRepositoryInit,
    OnRequestDioInterceptor? onRequest,
    OnResponseDioInterceptor? onResponse,
    OnErrorDioInterceptor? onError,
  }) {
    if (prodUrl != null) _prodUrl = prodUrl;
    if (devUrl != null) _devUrl = devUrl;
    if (currentUrl != null) _currentUrl = currentUrl;
    if (headers != null) _headers = headers;
    if (baseDioOptions != null) _baseDioOptions = baseDioOptions;
    _onRepoInit = onRepoInit;
    if (onRequest != null) _onRequest = onRequest;
    if (onResponse != null) _onResponse = onResponse;
    if (onError != null) _onError = onError;
  }
}
