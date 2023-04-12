library base_repository;

import 'package:base_repository/interface/dto.dart';
import 'package:base_repository/callback_handler/typedef/client_callback_result_type.dart';

typedef ClientCallback<T extends DTO> = Future<ClientCallbackResult<T>>
    Function();
