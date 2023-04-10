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
  version: ^0.1.1
  git: git@github.com:dronn1k-org/base_repository.git
```

## Usage

### Specify your own ApiUrls

```dart
enum ProjectApiUrl implements ApiUrl {
  prod('https://prod.template.com',),
  dev('https://dev.template.com');

  const ProjectApiUrl(this.url);

  @override
  final String url;
}
```

### Specify your response body (if needed)

```dart
class GeneralResponseBody<T extends DTO> extends BaseResponseBody {
  String? success;
  T? data;
  String? message;
}
```

### Specify your Callback result

```dart
class GeneralCbResult<T> extends BaseCallbackResult<T, String> {
  const GeneralCbResult({
    required super.callbackStatus,
    super.statusCode,
    super.data,
    super.errors,
  });
}
```

### Setting up your General Repository

```dart
class GeneralRepository extends BaseRepository<GeneralResponseBody<DTO>, String,
    GeneralCbResult<DTO>> {
  @override
  Future<GeneralCbResult<T>> request<T extends DTO>(
      ClientCallback<GeneralResponseBody<DTO>> callback) async {
    return GeneralCbResult<T>(
      callbackStatus: ApiCallbackStatus.success,
      data: (await callback()).data.data as T,
    );
  }

  @override
  ProjectApiUrl currentUrl = ProjectApiUrl.prod;

  @override
  HeadersType headers = {
    'accept': 'application/json',
    'content': 'application/json',
  };

  @override
  OnErrorDioInterceptor onError = (error, handler) {
    return handler.next(error);
  };

  @override
  OnRequestDioInterceptor onRequest = (request, handler) {
    return handler.next(request);
  };

  @override
  OnResponseDioInterceptor onResponse = (response, handler) {
    return handler.next(response);
  };
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
