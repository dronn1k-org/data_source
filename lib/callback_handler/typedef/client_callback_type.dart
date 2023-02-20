library base_repository;

import 'package:base_repository/interface/base_response_body.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';

typedef ClientCallback<T extends BaseResponseBody>
    = Future<ClientCallbackResult<T>> Function();
