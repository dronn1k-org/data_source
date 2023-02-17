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



// class General<T extends DTO> extends BaseApiEndpoint {
//   String? success;
//   T? data;
//   String? message;
// }

// class TemplateEntity implements DTO {}

// void main() {}

// abstract class GeneralRepository extends BaseRepository<General<DTO>, String> {
//   @override
//   final RepositoryCallbackHandler<General<DTO>, String> callbackHandler =
//       RepositoryCallbackHandler(
//     onResponse: (HttpResponse<General<DTO>> callbackResult) async {
//       return const ApiCallbackResult<DTO, String>(
//           callbackStatus: ApiCallbackStatus.success);
//     },
//     frontExceptionHandler:
//         <String>(Object exception, StackTrace stackTrace) async {
//       return ApiCallbackResult<DTO, String>(
//           callbackStatus: ApiCallbackStatus.frontException);
//     },
//   );
// }

// class TemplateRepo extends GeneralRepository {
//   Future<ApiCallbackResult<TemplateEntity, String>> temp() =>
//       request(() => null);
// }
