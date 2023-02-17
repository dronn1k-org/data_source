<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

```yaml
base_repository:
  version: ^0.1.0
  git:
    url: git@github.com:dronn1k-org/base_repository.git
    ref: master
```

## Usage

### Specify your own ApiUrls

```dart
enum ProjectApiUrl implements ApiUrl {
  prod('https://prod.template.com', _prod),
  dev('https://dev.template.com', _dev);

  const ProjectApiUrl(this.url, this.title);

  @override
  final String url;
  @override
  final String Function() title;
}

String _prod() => 'PROD';
String _dev() => 'DEV';
```

### Specify General response body (if needed)

```dart
class General<T extends DTO> extends BaseResponseBody {
  String? success;
  T? data;
  String? message;
}
```

### Setting up yor General Repository

```dart
class GeneralRepository extends BaseRepository<General<DTO>, String> {
  @override
  late RepositoryCallbackHandler<General<DTO>, String> callbackHandler =
      RepositoryCallbackHandler(
    onResponse: _onResponse,
    frontExceptionHandler: _frontExceptionHandler,
  );

  FutureOr<ApiCallbackResult<DTO, String>> _onResponse(
      ClientCallbackResult<General<DTO>> callbackResult) {
    return const ApiCallbackResult<DTO, String>(
        callbackStatus: ApiCallbackStatus.success);
  }

  FutureOr<ApiCallbackResult<DTO, String>> _frontExceptionHandler<String>(
      Object exception, StackTrace stackTrace) {
    return ApiCallbackResult<DTO, String>(
        callbackStatus: ApiCallbackStatus.frontException);
  }

  @override
  covariant ProjectApiUrl currentUrl = ProjectApiUrl.prod;

  @override
  HeadersType headers = {
    'accept' : 'application/json',
    'content' : 'application/json',
  };

  @override
  OnErrorDioInterceptor onError =(error, handler) {
    return handler.next(error);
  };

  @override
  OnRequestDioInterceptor onRequest =(request, handler) {
    return handler.next(request);
  };

  @override
  OnResponseDioInterceptor onResponse =(response, handler) {
    return handler.next(response);
  };
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
