// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'junto_notification_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
JuntoNotificationResults _$JuntoNotificationResultsFromJson(
    Map<String, dynamic> json) {
  return _JuntoNotificationResults.fromJson(json);
}

class _$JuntoNotificationResultsTearOff {
  const _$JuntoNotificationResultsTearOff();

  _JuntoNotificationResults call(
      {List<JuntoNotification> results,
      String lastTimestamp,
      int resultCount,
      bool wasSuccessful}) {
    return _JuntoNotificationResults(
      results: results,
      lastTimestamp: lastTimestamp,
      resultCount: resultCount,
      wasSuccessful: wasSuccessful,
    );
  }
}

// ignore: unused_element
const $JuntoNotificationResults = _$JuntoNotificationResultsTearOff();

mixin _$JuntoNotificationResults {
  List<JuntoNotification> get results;
  String get lastTimestamp;
  int get resultCount;
  bool get wasSuccessful;

  Map<String, dynamic> toJson();
  $JuntoNotificationResultsCopyWith<JuntoNotificationResults> get copyWith;
}

abstract class $JuntoNotificationResultsCopyWith<$Res> {
  factory $JuntoNotificationResultsCopyWith(JuntoNotificationResults value,
          $Res Function(JuntoNotificationResults) then) =
      _$JuntoNotificationResultsCopyWithImpl<$Res>;
  $Res call(
      {List<JuntoNotification> results,
      String lastTimestamp,
      int resultCount,
      bool wasSuccessful});
}

class _$JuntoNotificationResultsCopyWithImpl<$Res>
    implements $JuntoNotificationResultsCopyWith<$Res> {
  _$JuntoNotificationResultsCopyWithImpl(this._value, this._then);

  final JuntoNotificationResults _value;
  // ignore: unused_field
  final $Res Function(JuntoNotificationResults) _then;

  @override
  $Res call({
    Object results = freezed,
    Object lastTimestamp = freezed,
    Object resultCount = freezed,
    Object wasSuccessful = freezed,
  }) {
    return _then(_value.copyWith(
      results: results == freezed
          ? _value.results
          : results as List<JuntoNotification>,
      lastTimestamp: lastTimestamp == freezed
          ? _value.lastTimestamp
          : lastTimestamp as String,
      resultCount:
          resultCount == freezed ? _value.resultCount : resultCount as int,
      wasSuccessful: wasSuccessful == freezed
          ? _value.wasSuccessful
          : wasSuccessful as bool,
    ));
  }
}

abstract class _$JuntoNotificationResultsCopyWith<$Res>
    implements $JuntoNotificationResultsCopyWith<$Res> {
  factory _$JuntoNotificationResultsCopyWith(_JuntoNotificationResults value,
          $Res Function(_JuntoNotificationResults) then) =
      __$JuntoNotificationResultsCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<JuntoNotification> results,
      String lastTimestamp,
      int resultCount,
      bool wasSuccessful});
}

class __$JuntoNotificationResultsCopyWithImpl<$Res>
    extends _$JuntoNotificationResultsCopyWithImpl<$Res>
    implements _$JuntoNotificationResultsCopyWith<$Res> {
  __$JuntoNotificationResultsCopyWithImpl(_JuntoNotificationResults _value,
      $Res Function(_JuntoNotificationResults) _then)
      : super(_value, (v) => _then(v as _JuntoNotificationResults));

  @override
  _JuntoNotificationResults get _value =>
      super._value as _JuntoNotificationResults;

  @override
  $Res call({
    Object results = freezed,
    Object lastTimestamp = freezed,
    Object resultCount = freezed,
    Object wasSuccessful = freezed,
  }) {
    return _then(_JuntoNotificationResults(
      results: results == freezed
          ? _value.results
          : results as List<JuntoNotification>,
      lastTimestamp: lastTimestamp == freezed
          ? _value.lastTimestamp
          : lastTimestamp as String,
      resultCount:
          resultCount == freezed ? _value.resultCount : resultCount as int,
      wasSuccessful: wasSuccessful == freezed
          ? _value.wasSuccessful
          : wasSuccessful as bool,
    ));
  }
}

@JsonSerializable()
class _$_JuntoNotificationResults implements _JuntoNotificationResults {
  _$_JuntoNotificationResults(
      {this.results, this.lastTimestamp, this.resultCount, this.wasSuccessful});

  factory _$_JuntoNotificationResults.fromJson(Map<String, dynamic> json) =>
      _$_$_JuntoNotificationResultsFromJson(json);

  @override
  final List<JuntoNotification> results;
  @override
  final String lastTimestamp;
  @override
  final int resultCount;
  @override
  final bool wasSuccessful;

  @override
  String toString() {
    return 'JuntoNotificationResults(results: $results, lastTimestamp: $lastTimestamp, resultCount: $resultCount, wasSuccessful: $wasSuccessful)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _JuntoNotificationResults &&
            (identical(other.results, results) ||
                const DeepCollectionEquality()
                    .equals(other.results, results)) &&
            (identical(other.lastTimestamp, lastTimestamp) ||
                const DeepCollectionEquality()
                    .equals(other.lastTimestamp, lastTimestamp)) &&
            (identical(other.resultCount, resultCount) ||
                const DeepCollectionEquality()
                    .equals(other.resultCount, resultCount)) &&
            (identical(other.wasSuccessful, wasSuccessful) ||
                const DeepCollectionEquality()
                    .equals(other.wasSuccessful, wasSuccessful)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(results) ^
      const DeepCollectionEquality().hash(lastTimestamp) ^
      const DeepCollectionEquality().hash(resultCount) ^
      const DeepCollectionEquality().hash(wasSuccessful);

  @override
  _$JuntoNotificationResultsCopyWith<_JuntoNotificationResults> get copyWith =>
      __$JuntoNotificationResultsCopyWithImpl<_JuntoNotificationResults>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_JuntoNotificationResultsToJson(this);
  }
}

abstract class _JuntoNotificationResults implements JuntoNotificationResults {
  factory _JuntoNotificationResults(
      {List<JuntoNotification> results,
      String lastTimestamp,
      int resultCount,
      bool wasSuccessful}) = _$_JuntoNotificationResults;

  factory _JuntoNotificationResults.fromJson(Map<String, dynamic> json) =
      _$_JuntoNotificationResults.fromJson;

  @override
  List<JuntoNotification> get results;
  @override
  String get lastTimestamp;
  @override
  int get resultCount;
  @override
  bool get wasSuccessful;
  @override
  _$JuntoNotificationResultsCopyWith<_JuntoNotificationResults> get copyWith;
}
