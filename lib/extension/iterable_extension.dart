extension IterableExtension<T> on Iterable<T> {
  Iterable<S> whereMap<S>({
    required bool Function(S element) where,
    required S Function(T element) map,
  }) sync* {
    for (final element in this) {
      final mappedEntity = map(element);
      if (where(mappedEntity)) {
        yield mappedEntity;
      }
    }
  }
}
