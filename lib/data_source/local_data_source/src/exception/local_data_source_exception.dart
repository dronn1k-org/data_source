sealed class LocalDataSourceException implements Exception {}

class EntityDoNotExists implements LocalDataSourceException {
  const EntityDoNotExists(this.localId);

  final String localId;
}

class EntityAlreadyExists implements LocalDataSourceException {
  const EntityAlreadyExists(this.json);

  final Map<String, dynamic> json;
}

class FromJsonFail implements LocalDataSourceException {
  const FromJsonFail(this.json);

  final Map<String, dynamic> json;
}
