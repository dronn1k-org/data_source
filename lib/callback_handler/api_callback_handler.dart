library base_repository;

import 'dart:async';

import 'package:base_repository/callback_handler/interface/api_endpoint.dart';
import 'package:base_repository/callback_handler/interface/dto.dart';
import 'package:base_repository/callback_handler/model/api_callback_misc.dart';
import 'package:base_repository/callback_handler/model/api_callback_result.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';

mixin ApiCallbackHandler {
  static late FutureOr<ApiCallbackResult<DTO, ERRORS_TYPE>> Function<
      T extends BaseApiEndpoint,
      ERRORS_TYPE>(ClientCallbackResult<T> callbackResult) _resultHandler;

  static set resultHandler(
          FutureOr<ApiCallbackResult<DTO, ERRORS_TYPE>> Function<
                  T extends BaseApiEndpoint,
                  ERRORS_TYPE>(ClientCallbackResult<T> callbackResult)
              resultHandler) =>
      _resultHandler = resultHandler;

  static late FutureOr<ApiCallbackResult<DTO, ERROR_TYPE>> Function<ERROR_TYPE>(
      Object exception, StackTrace stackTrace) _frontExceptionHandler;

  static set frontExceptionHandler(
          FutureOr<ApiCallbackResult<DTO, ERROR_TYPE>> Function<ERROR_TYPE>(
                  Object exception, StackTrace stackTrace)
              frontExceptionHandler) =>
      _frontExceptionHandler = frontExceptionHandler;

  static ApiCallbackMisc? misc;

  Future<ApiCallbackResult<DTO, ERRORS_TYPE>> request<ERRORS_TYPE>(
      ClientCallback callback) async {
    await misc?.onBeforeCallback?.call();
    try {
      return await _resultHandler.call(await callback.call());
    } catch (e, st) {
      return await _frontExceptionHandler.call(e, st);
    } finally {
      await misc?.onAfterCallback?.call();
    }
  }
}
