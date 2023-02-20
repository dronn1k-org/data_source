library base_repository;

import 'package:base_repository/interface/base_response_body.dart';
import 'package:retrofit/dio.dart';

typedef ClientCallbackResult<T extends BaseResponseBody> = HttpResponse<T>;
