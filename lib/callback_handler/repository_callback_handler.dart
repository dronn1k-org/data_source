// ignore_for_file: public_member_api_docs, sort_constructors_first
library base_repository;

import 'dart:async';

import 'package:base_repository/interface/base_response_body.dart';
import 'package:base_repository/interface/dto.dart';
import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_type.dart';

class RepositoryCallbackHandler<BASE_TYPE extends BaseResponseBody,
    ERRORS_TYPE> {
  final FutureOr<void> Function()? _onBeforeCallback;

  final FutureOr<BaseCallbackResult<DTO, ERRORS_TYPE>> Function(
      ClientCallbackResult<BASE_TYPE> callbackResult) _onResponse;

  final FutureOr<void> Function()? _onAfterCallback;

  final FutureOr<BaseCallbackResult<DTO, ERRORS_TYPE>> Function(
      Object exception, StackTrace stackTrace) _frontExceptionHandler;

  Future<BaseCallbackResult<DTO, ERRORS_TYPE>> request(
      ClientCallback<BASE_TYPE> callback) async {
    await _onBeforeCallback?.call();
    try {
      return await _onResponse.call(await callback.call());
    } catch (e, st) {
      return await _frontExceptionHandler.call(e, st);
    } finally {
      await _onAfterCallback?.call();
    }
  }

  const RepositoryCallbackHandler({
    FutureOr<void> Function()? onBeforeCallback,
    required FutureOr<BaseCallbackResult<DTO, ERRORS_TYPE>> Function(
            ClientCallbackResult<BASE_TYPE> callbackResult)
        onResponse,
    FutureOr<void> Function()? onAfterCallback,
    required FutureOr<BaseCallbackResult<DTO, ERRORS_TYPE>> Function(
            Object exception, StackTrace stackTrace)
        frontExceptionHandler,
  })  : _onBeforeCallback = onBeforeCallback,
        _onResponse = onResponse,
        _onAfterCallback = onAfterCallback,
        _frontExceptionHandler = frontExceptionHandler;
}
