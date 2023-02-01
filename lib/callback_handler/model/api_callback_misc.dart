// ignore_for_file: public_member_api_docs, sort_constructors_first
library base_repository;

import 'dart:async';

class ApiCallbackMisc {
  final FutureOr<void> Function()? onBeforeCallback;

  final FutureOr<void> Function()? onAfterCallback;

  const ApiCallbackMisc({
    this.onBeforeCallback,
    this.onAfterCallback,
  });
}
