library base_repository;

import 'package:base_repository/callback_handler/enum/callback_status.dart';
import 'package:flutter/cupertino.dart';

class CallbackResult<RESULT_TYPE, ERRORS_TYPE> {
  final CallbackStatus callbackStatus;

  bool get isSuccess => callbackStatus == CallbackStatus.success;
  bool get isFail => callbackStatus == CallbackStatus.fail;

  final RESULT_TYPE? data;
  final ERRORS_TYPE? errors;

  @mustCallSuper
  const CallbackResult({
    required this.callbackStatus,
    this.data,
    this.errors,
  });
}
