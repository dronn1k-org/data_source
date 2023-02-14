// import 'package:flutter_test/flutter_test.dart';

// import 'package:base_repository/base_repository.dart';

// void main() {
//   test('adds one to input values', () {
//     final calculator = Calculator();
//     expect(calculator.addOne(2), 3);
//     expect(calculator.addOne(-7), -6);
//     expect(calculator.addOne(0), 1);
//   });
// }

import 'dart:async';

import 'package:base_repository/callback_handler/api_callback_handler.dart';
import 'package:base_repository/callback_handler/interface/api_endpoint.dart';
import 'package:base_repository/callback_handler/interface/dto.dart';
import 'package:base_repository/callback_handler/model/api_callback_result.dart';
import 'package:retrofit/retrofit.dart';

abstract class General<T> implements BaseApiEndpoint<T> {}

FutureOr<ApiCallbackResult<DTO, ERRORS_TYPE>> _apiHandler<ERRORS_TYPE>(
    HttpResponse<General<DTO>> response) {}

void main() {
  ApiCallbackHandler.resultHandler = _apiHandler;
}
