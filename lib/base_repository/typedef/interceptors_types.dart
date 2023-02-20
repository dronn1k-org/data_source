library base_repository;

import 'package:dio/dio.dart';

typedef OnRequestDioInterceptor = void Function(
    RequestOptions request, RequestInterceptorHandler handler);

typedef OnResponseDioInterceptor = void Function(
    Response<dynamic> response, ResponseInterceptorHandler handler);

typedef OnErrorDioInterceptor = void Function(
    DioError error, ErrorInterceptorHandler handler);
