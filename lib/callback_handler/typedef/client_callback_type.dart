library base_repository;

import 'package:base_repository/callback_handler/interface/api_endpoint.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';

typedef ClientCallback<T extends BaseApiEndpoint>
    = Future<ClientCallbackResult<T>> Function();
