library base_repository;

import 'dart:async';

import 'package:base_repository/callback_handler/model/api_callback_misc.dart';
import 'package:base_repository/callback_handler/model/api_callback_result.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';

mixin ApiCallbackHandler {
  static late FutureOr<ApiCallbackResult<DTO, ERRORS_TYPE>>
          Function<DTO, ERRORS_TYPE>(ClientCallbackResult callbackResult)
      resultHandler;

  static late FutureOr<ApiCallbackResult<DTO, ERROR_TYPE>>
          Function<DTO, ERROR_TYPE>(Object exception, StackTrace stackTrace)
      frontExceptionHandler;

  static ApiCallbackMisc? misc;

  Future<ApiCallbackResult<DTO, ERRORS_TYPE>> request<DTO, ERRORS_TYPE>(
      ClientCallback<DTO> callback) async {
    await misc?.onBeforeCallback?.call();
    try {
      return await resultHandler.call(await callback.call());
    } catch (e, st) {
      return await frontExceptionHandler.call(e, st);
    } finally {
      await misc?.onAfterCallback?.call();
    }
  }
}
