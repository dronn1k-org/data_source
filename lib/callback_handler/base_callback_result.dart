library base_repository;

import 'package:base_repository/callback_handler/enum/api_callback_status.dart';
import 'package:flutter/cupertino.dart';

class BaseCallbackResult<RESULT_TYPE, ERRORS_TYPE> {
  final ApiCallbackStatus callbackStatus;

  bool get isSuccess => callbackStatus == ApiCallbackStatus.success;
  bool get isBackException => callbackStatus == ApiCallbackStatus.backException;

  final RESULT_TYPE? data;
  final ERRORS_TYPE? errors;

  final int? statusCode;

  @mustCallSuper
  const BaseCallbackResult({
    required this.callbackStatus,
    this.data,
    this.errors,
    this.statusCode,
  });
}
