// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'collective_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$CollectiveStateTearOff {
  const _$CollectiveStateTearOff();

  CollectiveInitial initial() {
    return CollectiveInitial();
  }

  CollectivePopulated populated(List<ExpressionResponse> results,
      [bool loadingMore, String name = 'JUNTO', bool availableMore]) {
    return CollectivePopulated(
      results,
      loadingMore,
      name,
      availableMore,
    );
  }

  CollectiveLoading loading() {
    return CollectiveLoading();
  }

  CollectiveError error() {
    return CollectiveError();
  }
}

// ignore: unused_element
const $CollectiveState = _$CollectiveStateTearOff();

mixin _$CollectiveState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required
        Result populated(List<ExpressionResponse> results, bool loadingMore,
            String name, bool availableMore),
    @required Result loading(),
    @required Result error(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result populated(List<ExpressionResponse> results, bool loadingMore,
        String name, bool availableMore),
    Result loading(),
    Result error(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(CollectiveInitial value),
    @required Result populated(CollectivePopulated value),
    @required Result loading(CollectiveLoading value),
    @required Result error(CollectiveError value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(CollectiveInitial value),
    Result populated(CollectivePopulated value),
    Result loading(CollectiveLoading value),
    Result error(CollectiveError value),
    @required Result orElse(),
  });
}

abstract class $CollectiveStateCopyWith<$Res> {
  factory $CollectiveStateCopyWith(
          CollectiveState value, $Res Function(CollectiveState) then) =
      _$CollectiveStateCopyWithImpl<$Res>;
}

class _$CollectiveStateCopyWithImpl<$Res>
    implements $CollectiveStateCopyWith<$Res> {
  _$CollectiveStateCopyWithImpl(this._value, this._then);

  final CollectiveState _value;
  // ignore: unused_field
  final $Res Function(CollectiveState) _then;
}

abstract class $CollectiveInitialCopyWith<$Res> {
  factory $CollectiveInitialCopyWith(
          CollectiveInitial value, $Res Function(CollectiveInitial) then) =
      _$CollectiveInitialCopyWithImpl<$Res>;
}

class _$CollectiveInitialCopyWithImpl<$Res>
    extends _$CollectiveStateCopyWithImpl<$Res>
    implements $CollectiveInitialCopyWith<$Res> {
  _$CollectiveInitialCopyWithImpl(
      CollectiveInitial _value, $Res Function(CollectiveInitial) _then)
      : super(_value, (v) => _then(v as CollectiveInitial));

  @override
  CollectiveInitial get _value => super._value as CollectiveInitial;
}

class _$CollectiveInitial implements CollectiveInitial {
  _$CollectiveInitial();

  @override
  String toString() {
    return 'CollectiveState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is CollectiveInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required
        Result populated(List<ExpressionResponse> results, bool loadingMore,
            String name, bool availableMore),
    @required Result loading(),
    @required Result error(),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result populated(List<ExpressionResponse> results, bool loadingMore,
        String name, bool availableMore),
    Result loading(),
    Result error(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(CollectiveInitial value),
    @required Result populated(CollectivePopulated value),
    @required Result loading(CollectiveLoading value),
    @required Result error(CollectiveError value),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(CollectiveInitial value),
    Result populated(CollectivePopulated value),
    Result loading(CollectiveLoading value),
    Result error(CollectiveError value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CollectiveInitial implements CollectiveState {
  factory CollectiveInitial() = _$CollectiveInitial;
}

abstract class $CollectivePopulatedCopyWith<$Res> {
  factory $CollectivePopulatedCopyWith(
          CollectivePopulated value, $Res Function(CollectivePopulated) then) =
      _$CollectivePopulatedCopyWithImpl<$Res>;
  $Res call(
      {List<ExpressionResponse> results,
      bool loadingMore,
      String name,
      bool availableMore});
}

class _$CollectivePopulatedCopyWithImpl<$Res>
    extends _$CollectiveStateCopyWithImpl<$Res>
    implements $CollectivePopulatedCopyWith<$Res> {
  _$CollectivePopulatedCopyWithImpl(
      CollectivePopulated _value, $Res Function(CollectivePopulated) _then)
      : super(_value, (v) => _then(v as CollectivePopulated));

  @override
  CollectivePopulated get _value => super._value as CollectivePopulated;

  @override
  $Res call({
    Object results = freezed,
    Object loadingMore = freezed,
    Object name = freezed,
    Object availableMore = freezed,
  }) {
    return _then(CollectivePopulated(
      results == freezed ? _value.results : results as List<ExpressionResponse>,
      loadingMore == freezed ? _value.loadingMore : loadingMore as bool,
      name == freezed ? _value.name : name as String,
      availableMore == freezed ? _value.availableMore : availableMore as bool,
    ));
  }
}

class _$CollectivePopulated implements CollectivePopulated {
  _$CollectivePopulated(this.results,
      [this.loadingMore, this.name = 'JUNTO', this.availableMore])
      : assert(results != null),
        assert(name != null);

  @override
  final List<ExpressionResponse> results;
  @override
  final bool loadingMore;
  @JsonKey(defaultValue: 'JUNTO')
  @override
  final String name;
  @override
  final bool availableMore;

  @override
  String toString() {
    return 'CollectiveState.populated(results: $results, loadingMore: $loadingMore, name: $name, availableMore: $availableMore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CollectivePopulated &&
            (identical(other.results, results) ||
                const DeepCollectionEquality()
                    .equals(other.results, results)) &&
            (identical(other.loadingMore, loadingMore) ||
                const DeepCollectionEquality()
                    .equals(other.loadingMore, loadingMore)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.availableMore, availableMore) ||
                const DeepCollectionEquality()
                    .equals(other.availableMore, availableMore)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(results) ^
      const DeepCollectionEquality().hash(loadingMore) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(availableMore);

  @override
  $CollectivePopulatedCopyWith<CollectivePopulated> get copyWith =>
      _$CollectivePopulatedCopyWithImpl<CollectivePopulated>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required
        Result populated(List<ExpressionResponse> results, bool loadingMore,
            String name, bool availableMore),
    @required Result loading(),
    @required Result error(),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return populated(results, loadingMore, name, availableMore);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result populated(List<ExpressionResponse> results, bool loadingMore,
        String name, bool availableMore),
    Result loading(),
    Result error(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (populated != null) {
      return populated(results, loadingMore, name, availableMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(CollectiveInitial value),
    @required Result populated(CollectivePopulated value),
    @required Result loading(CollectiveLoading value),
    @required Result error(CollectiveError value),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return populated(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(CollectiveInitial value),
    Result populated(CollectivePopulated value),
    Result loading(CollectiveLoading value),
    Result error(CollectiveError value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (populated != null) {
      return populated(this);
    }
    return orElse();
  }
}

abstract class CollectivePopulated implements CollectiveState {
  factory CollectivePopulated(List<ExpressionResponse> results,
      [bool loadingMore,
      String name,
      bool availableMore]) = _$CollectivePopulated;

  List<ExpressionResponse> get results;
  bool get loadingMore;
  String get name;
  bool get availableMore;
  $CollectivePopulatedCopyWith<CollectivePopulated> get copyWith;
}

abstract class $CollectiveLoadingCopyWith<$Res> {
  factory $CollectiveLoadingCopyWith(
          CollectiveLoading value, $Res Function(CollectiveLoading) then) =
      _$CollectiveLoadingCopyWithImpl<$Res>;
}

class _$CollectiveLoadingCopyWithImpl<$Res>
    extends _$CollectiveStateCopyWithImpl<$Res>
    implements $CollectiveLoadingCopyWith<$Res> {
  _$CollectiveLoadingCopyWithImpl(
      CollectiveLoading _value, $Res Function(CollectiveLoading) _then)
      : super(_value, (v) => _then(v as CollectiveLoading));

  @override
  CollectiveLoading get _value => super._value as CollectiveLoading;
}

class _$CollectiveLoading implements CollectiveLoading {
  _$CollectiveLoading();

  @override
  String toString() {
    return 'CollectiveState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is CollectiveLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required
        Result populated(List<ExpressionResponse> results, bool loadingMore,
            String name, bool availableMore),
    @required Result loading(),
    @required Result error(),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result populated(List<ExpressionResponse> results, bool loadingMore,
        String name, bool availableMore),
    Result loading(),
    Result error(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(CollectiveInitial value),
    @required Result populated(CollectivePopulated value),
    @required Result loading(CollectiveLoading value),
    @required Result error(CollectiveError value),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(CollectiveInitial value),
    Result populated(CollectivePopulated value),
    Result loading(CollectiveLoading value),
    Result error(CollectiveError value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CollectiveLoading implements CollectiveState {
  factory CollectiveLoading() = _$CollectiveLoading;
}

abstract class $CollectiveErrorCopyWith<$Res> {
  factory $CollectiveErrorCopyWith(
          CollectiveError value, $Res Function(CollectiveError) then) =
      _$CollectiveErrorCopyWithImpl<$Res>;
}

class _$CollectiveErrorCopyWithImpl<$Res>
    extends _$CollectiveStateCopyWithImpl<$Res>
    implements $CollectiveErrorCopyWith<$Res> {
  _$CollectiveErrorCopyWithImpl(
      CollectiveError _value, $Res Function(CollectiveError) _then)
      : super(_value, (v) => _then(v as CollectiveError));

  @override
  CollectiveError get _value => super._value as CollectiveError;
}

class _$CollectiveError implements CollectiveError {
  _$CollectiveError();

  @override
  String toString() {
    return 'CollectiveState.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is CollectiveError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required
        Result populated(List<ExpressionResponse> results, bool loadingMore,
            String name, bool availableMore),
    @required Result loading(),
    @required Result error(),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return error();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result populated(List<ExpressionResponse> results, bool loadingMore,
        String name, bool availableMore),
    Result loading(),
    Result error(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(CollectiveInitial value),
    @required Result populated(CollectivePopulated value),
    @required Result loading(CollectiveLoading value),
    @required Result error(CollectiveError value),
  }) {
    assert(initial != null);
    assert(populated != null);
    assert(loading != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(CollectiveInitial value),
    Result populated(CollectivePopulated value),
    Result loading(CollectiveLoading value),
    Result error(CollectiveError value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CollectiveError implements CollectiveState {
  factory CollectiveError() = _$CollectiveError;
}
