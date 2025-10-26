/// Represents a value of one of two possible types.
/// An instance of [Either] is either an instance of [Left] or [Right].
///
/// [Left] is conventionally used to represent a failure or an error,
/// while [Right] is used to represent a successful result.
sealed class Either<L, R> {
  /// Private constructor to prevent direct instantiation.
  const Either();

  /// Applies one of the given functions depending on whether this is a left or right.
  /// - [leftFn] is applied if this is a left.
  /// - [rightFn] is applied if this is a right.
  /// Returns the result of the applied function.
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    if (this is Left<L, R>) {
      return leftFn((this as Left<L, R>).value);
    } else if (this is Right<L, R>) {
      return rightFn((this as Right<L, R>).value);
    }
    // This should be unreachable due to the sealed class hierarchy.
    throw StateError('Unreachable');
  }

  /// Returns `true` if this is a [Left], `false` otherwise.
  bool get isLeft => this is Left<L, R>;

  /// Returns `true` if this is a [Right], `false` otherwise.
  bool get isRight => this is Right<L, R>;
}

/// Represents the left side of an [Either] type, typically a failure.
class Left<L, R> extends Either<L, R> {
  /// The value of this [Left].
  final L value;

  /// Creates a [Left] with the given [value].
  const Left(this.value);
}

/// Represents the right side of an [Either] type, typically a success.
class Right<L, R> extends Either<L, R> {
  /// The value of this [Right].
  final R value;

  /// Creates a [Right] with the given [value].
  const Right(this.value);
}

extension EitherX<L, R> on Either<L, R> {
  /// Returns the value from this [Right] or `null` if this is a [Left].
  R? getOrNull() {
    return fold((_) => null, (r) => r);
  }
}
