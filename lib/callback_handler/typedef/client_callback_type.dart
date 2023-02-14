library base_repository;

import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';

typedef ClientCallback<T> = Future<ClientCallbackResult<T>> Function();
