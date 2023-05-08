import 'package:flutter/cupertino.dart';

import '../misc/enum_list.dart';

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
