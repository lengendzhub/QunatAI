// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'execution_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExecutionResult _$ExecutionResultFromJson(Map<String, dynamic> json) {
  return _ExecutionResult.fromJson(json);
}

/// @nodoc
mixin _$ExecutionResult {
  String get contractId => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;
  double get filledPrice => throw _privateConstructorUsedError;
  double get stopLoss => throw _privateConstructorUsedError;
  double get takeProfit => throw _privateConstructorUsedError;
  double get lotSize => throw _privateConstructorUsedError;
  DateTime get executedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get raw => throw _privateConstructorUsedError;

  /// Serializes this ExecutionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExecutionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExecutionResultCopyWith<ExecutionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExecutionResultCopyWith<$Res> {
  factory $ExecutionResultCopyWith(
          ExecutionResult value, $Res Function(ExecutionResult) then) =
      _$ExecutionResultCopyWithImpl<$Res, ExecutionResult>;
  @useResult
  $Res call(
      {String contractId,
      String symbol,
      String direction,
      double filledPrice,
      double stopLoss,
      double takeProfit,
      double lotSize,
      DateTime executedAt,
      Map<String, dynamic> raw});
}

/// @nodoc
class _$ExecutionResultCopyWithImpl<$Res, $Val extends ExecutionResult>
    implements $ExecutionResultCopyWith<$Res> {
  _$ExecutionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExecutionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? symbol = null,
    Object? direction = null,
    Object? filledPrice = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? lotSize = null,
    Object? executedAt = null,
    Object? raw = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      filledPrice: null == filledPrice
          ? _value.filledPrice
          : filledPrice // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      raw: null == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExecutionResultImplCopyWith<$Res>
    implements $ExecutionResultCopyWith<$Res> {
  factory _$$ExecutionResultImplCopyWith(_$ExecutionResultImpl value,
          $Res Function(_$ExecutionResultImpl) then) =
      __$$ExecutionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String symbol,
      String direction,
      double filledPrice,
      double stopLoss,
      double takeProfit,
      double lotSize,
      DateTime executedAt,
      Map<String, dynamic> raw});
}

/// @nodoc
class __$$ExecutionResultImplCopyWithImpl<$Res>
    extends _$ExecutionResultCopyWithImpl<$Res, _$ExecutionResultImpl>
    implements _$$ExecutionResultImplCopyWith<$Res> {
  __$$ExecutionResultImplCopyWithImpl(
      _$ExecutionResultImpl _value, $Res Function(_$ExecutionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExecutionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? symbol = null,
    Object? direction = null,
    Object? filledPrice = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? lotSize = null,
    Object? executedAt = null,
    Object? raw = null,
  }) {
    return _then(_$ExecutionResultImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      filledPrice: null == filledPrice
          ? _value.filledPrice
          : filledPrice // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      raw: null == raw
          ? _value._raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExecutionResultImpl extends _ExecutionResult {
  const _$ExecutionResultImpl(
      {required this.contractId,
      required this.symbol,
      required this.direction,
      required this.filledPrice,
      required this.stopLoss,
      required this.takeProfit,
      required this.lotSize,
      required this.executedAt,
      required final Map<String, dynamic> raw})
      : _raw = raw,
        super._();

  factory _$ExecutionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExecutionResultImplFromJson(json);

  @override
  final String contractId;
  @override
  final String symbol;
  @override
  final String direction;
  @override
  final double filledPrice;
  @override
  final double stopLoss;
  @override
  final double takeProfit;
  @override
  final double lotSize;
  @override
  final DateTime executedAt;
  final Map<String, dynamic> _raw;
  @override
  Map<String, dynamic> get raw {
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_raw);
  }

  @override
  String toString() {
    return 'ExecutionResult(contractId: $contractId, symbol: $symbol, direction: $direction, filledPrice: $filledPrice, stopLoss: $stopLoss, takeProfit: $takeProfit, lotSize: $lotSize, executedAt: $executedAt, raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExecutionResultImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.filledPrice, filledPrice) ||
                other.filledPrice == filledPrice) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt) &&
            const DeepCollectionEquality().equals(other._raw, _raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contractId,
      symbol,
      direction,
      filledPrice,
      stopLoss,
      takeProfit,
      lotSize,
      executedAt,
      const DeepCollectionEquality().hash(_raw));

  /// Create a copy of ExecutionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExecutionResultImplCopyWith<_$ExecutionResultImpl> get copyWith =>
      __$$ExecutionResultImplCopyWithImpl<_$ExecutionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExecutionResultImplToJson(
      this,
    );
  }
}

abstract class _ExecutionResult extends ExecutionResult {
  const factory _ExecutionResult(
      {required final String contractId,
      required final String symbol,
      required final String direction,
      required final double filledPrice,
      required final double stopLoss,
      required final double takeProfit,
      required final double lotSize,
      required final DateTime executedAt,
      required final Map<String, dynamic> raw}) = _$ExecutionResultImpl;
  const _ExecutionResult._() : super._();

  factory _ExecutionResult.fromJson(Map<String, dynamic> json) =
      _$ExecutionResultImpl.fromJson;

  @override
  String get contractId;
  @override
  String get symbol;
  @override
  String get direction;
  @override
  double get filledPrice;
  @override
  double get stopLoss;
  @override
  double get takeProfit;
  @override
  double get lotSize;
  @override
  DateTime get executedAt;
  @override
  Map<String, dynamic> get raw;

  /// Create a copy of ExecutionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExecutionResultImplCopyWith<_$ExecutionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
