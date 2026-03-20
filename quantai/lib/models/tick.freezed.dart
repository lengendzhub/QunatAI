// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tick _$TickFromJson(Map<String, dynamic> json) {
  return _Tick.fromJson(json);
}

/// @nodoc
mixin _$Tick {
  String get symbol => throw _privateConstructorUsedError;
  double get bid => throw _privateConstructorUsedError;
  double get ask => throw _privateConstructorUsedError;
  double get spread => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this Tick to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TickCopyWith<Tick> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TickCopyWith<$Res> {
  factory $TickCopyWith(Tick value, $Res Function(Tick) then) =
      _$TickCopyWithImpl<$Res, Tick>;
  @useResult
  $Res call(
      {String symbol,
      double bid,
      double ask,
      double spread,
      DateTime timestamp});
}

/// @nodoc
class _$TickCopyWithImpl<$Res, $Val extends Tick>
    implements $TickCopyWith<$Res> {
  _$TickCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? bid = null,
    Object? ask = null,
    Object? spread = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      bid: null == bid
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      ask: null == ask
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      spread: null == spread
          ? _value.spread
          : spread // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TickImplCopyWith<$Res> implements $TickCopyWith<$Res> {
  factory _$$TickImplCopyWith(
          _$TickImpl value, $Res Function(_$TickImpl) then) =
      __$$TickImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      double bid,
      double ask,
      double spread,
      DateTime timestamp});
}

/// @nodoc
class __$$TickImplCopyWithImpl<$Res>
    extends _$TickCopyWithImpl<$Res, _$TickImpl>
    implements _$$TickImplCopyWith<$Res> {
  __$$TickImplCopyWithImpl(_$TickImpl _value, $Res Function(_$TickImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? bid = null,
    Object? ask = null,
    Object? spread = null,
    Object? timestamp = null,
  }) {
    return _then(_$TickImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      bid: null == bid
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      ask: null == ask
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      spread: null == spread
          ? _value.spread
          : spread // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TickImpl extends _Tick {
  const _$TickImpl(
      {required this.symbol,
      required this.bid,
      required this.ask,
      required this.spread,
      required this.timestamp})
      : super._();

  factory _$TickImpl.fromJson(Map<String, dynamic> json) =>
      _$$TickImplFromJson(json);

  @override
  final String symbol;
  @override
  final double bid;
  @override
  final double ask;
  @override
  final double spread;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'Tick(symbol: $symbol, bid: $bid, ask: $ask, spread: $spread, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TickImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.bid, bid) || other.bid == bid) &&
            (identical(other.ask, ask) || other.ask == ask) &&
            (identical(other.spread, spread) || other.spread == spread) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, symbol, bid, ask, spread, timestamp);

  /// Create a copy of Tick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TickImplCopyWith<_$TickImpl> get copyWith =>
      __$$TickImplCopyWithImpl<_$TickImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TickImplToJson(
      this,
    );
  }
}

abstract class _Tick extends Tick {
  const factory _Tick(
      {required final String symbol,
      required final double bid,
      required final double ask,
      required final double spread,
      required final DateTime timestamp}) = _$TickImpl;
  const _Tick._() : super._();

  factory _Tick.fromJson(Map<String, dynamic> json) = _$TickImpl.fromJson;

  @override
  String get symbol;
  @override
  double get bid;
  @override
  double get ask;
  @override
  double get spread;
  @override
  DateTime get timestamp;

  /// Create a copy of Tick
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TickImplCopyWith<_$TickImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
