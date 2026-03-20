// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Trade _$TradeFromJson(Map<String, dynamic> json) {
  return _Trade.fromJson(json);
}

/// @nodoc
mixin _$Trade {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;
  double get entryPrice => throw _privateConstructorUsedError;
  double? get exitPrice => throw _privateConstructorUsedError;
  double get stopLoss => throw _privateConstructorUsedError;
  double get takeProfit => throw _privateConstructorUsedError;
  double get lotSize => throw _privateConstructorUsedError;
  DateTime get openedAt => throw _privateConstructorUsedError;
  DateTime? get closedAt => throw _privateConstructorUsedError;
  double get pnlMoney => throw _privateConstructorUsedError;
  double get pnlPips => throw _privateConstructorUsedError;
  double get riskRewardActual => throw _privateConstructorUsedError;
  String get contractId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get regime => throw _privateConstructorUsedError;
  String get session => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this Trade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeCopyWith<Trade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeCopyWith<$Res> {
  factory $TradeCopyWith(Trade value, $Res Function(Trade) then) =
      _$TradeCopyWithImpl<$Res, Trade>;
  @useResult
  $Res call(
      {String id,
      String symbol,
      String direction,
      double entryPrice,
      double? exitPrice,
      double stopLoss,
      double takeProfit,
      double lotSize,
      DateTime openedAt,
      DateTime? closedAt,
      double pnlMoney,
      double pnlPips,
      double riskRewardActual,
      String contractId,
      String status,
      String regime,
      String session,
      double confidence});
}

/// @nodoc
class _$TradeCopyWithImpl<$Res, $Val extends Trade>
    implements $TradeCopyWith<$Res> {
  _$TradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? direction = null,
    Object? entryPrice = null,
    Object? exitPrice = freezed,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? lotSize = null,
    Object? openedAt = null,
    Object? closedAt = freezed,
    Object? pnlMoney = null,
    Object? pnlPips = null,
    Object? riskRewardActual = null,
    Object? contractId = null,
    Object? status = null,
    Object? regime = null,
    Object? session = null,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      exitPrice: freezed == exitPrice
          ? _value.exitPrice
          : exitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
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
      openedAt: null == openedAt
          ? _value.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pnlMoney: null == pnlMoney
          ? _value.pnlMoney
          : pnlMoney // ignore: cast_nullable_to_non_nullable
              as double,
      pnlPips: null == pnlPips
          ? _value.pnlPips
          : pnlPips // ignore: cast_nullable_to_non_nullable
              as double,
      riskRewardActual: null == riskRewardActual
          ? _value.riskRewardActual
          : riskRewardActual // ignore: cast_nullable_to_non_nullable
              as double,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as String,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeImplCopyWith<$Res> implements $TradeCopyWith<$Res> {
  factory _$$TradeImplCopyWith(
          _$TradeImpl value, $Res Function(_$TradeImpl) then) =
      __$$TradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String symbol,
      String direction,
      double entryPrice,
      double? exitPrice,
      double stopLoss,
      double takeProfit,
      double lotSize,
      DateTime openedAt,
      DateTime? closedAt,
      double pnlMoney,
      double pnlPips,
      double riskRewardActual,
      String contractId,
      String status,
      String regime,
      String session,
      double confidence});
}

/// @nodoc
class __$$TradeImplCopyWithImpl<$Res>
    extends _$TradeCopyWithImpl<$Res, _$TradeImpl>
    implements _$$TradeImplCopyWith<$Res> {
  __$$TradeImplCopyWithImpl(
      _$TradeImpl _value, $Res Function(_$TradeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? direction = null,
    Object? entryPrice = null,
    Object? exitPrice = freezed,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? lotSize = null,
    Object? openedAt = null,
    Object? closedAt = freezed,
    Object? pnlMoney = null,
    Object? pnlPips = null,
    Object? riskRewardActual = null,
    Object? contractId = null,
    Object? status = null,
    Object? regime = null,
    Object? session = null,
    Object? confidence = null,
  }) {
    return _then(_$TradeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      exitPrice: freezed == exitPrice
          ? _value.exitPrice
          : exitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
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
      openedAt: null == openedAt
          ? _value.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pnlMoney: null == pnlMoney
          ? _value.pnlMoney
          : pnlMoney // ignore: cast_nullable_to_non_nullable
              as double,
      pnlPips: null == pnlPips
          ? _value.pnlPips
          : pnlPips // ignore: cast_nullable_to_non_nullable
              as double,
      riskRewardActual: null == riskRewardActual
          ? _value.riskRewardActual
          : riskRewardActual // ignore: cast_nullable_to_non_nullable
              as double,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as String,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeImpl extends _Trade {
  const _$TradeImpl(
      {required this.id,
      required this.symbol,
      required this.direction,
      required this.entryPrice,
      required this.exitPrice,
      required this.stopLoss,
      required this.takeProfit,
      required this.lotSize,
      required this.openedAt,
      required this.closedAt,
      required this.pnlMoney,
      required this.pnlPips,
      required this.riskRewardActual,
      required this.contractId,
      required this.status,
      required this.regime,
      required this.session,
      required this.confidence})
      : super._();

  factory _$TradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String direction;
  @override
  final double entryPrice;
  @override
  final double? exitPrice;
  @override
  final double stopLoss;
  @override
  final double takeProfit;
  @override
  final double lotSize;
  @override
  final DateTime openedAt;
  @override
  final DateTime? closedAt;
  @override
  final double pnlMoney;
  @override
  final double pnlPips;
  @override
  final double riskRewardActual;
  @override
  final String contractId;
  @override
  final String status;
  @override
  final String regime;
  @override
  final String session;
  @override
  final double confidence;

  @override
  String toString() {
    return 'Trade(id: $id, symbol: $symbol, direction: $direction, entryPrice: $entryPrice, exitPrice: $exitPrice, stopLoss: $stopLoss, takeProfit: $takeProfit, lotSize: $lotSize, openedAt: $openedAt, closedAt: $closedAt, pnlMoney: $pnlMoney, pnlPips: $pnlPips, riskRewardActual: $riskRewardActual, contractId: $contractId, status: $status, regime: $regime, session: $session, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.exitPrice, exitPrice) ||
                other.exitPrice == exitPrice) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.pnlMoney, pnlMoney) ||
                other.pnlMoney == pnlMoney) &&
            (identical(other.pnlPips, pnlPips) || other.pnlPips == pnlPips) &&
            (identical(other.riskRewardActual, riskRewardActual) ||
                other.riskRewardActual == riskRewardActual) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regime, regime) || other.regime == regime) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      direction,
      entryPrice,
      exitPrice,
      stopLoss,
      takeProfit,
      lotSize,
      openedAt,
      closedAt,
      pnlMoney,
      pnlPips,
      riskRewardActual,
      contractId,
      status,
      regime,
      session,
      confidence);

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeImplCopyWith<_$TradeImpl> get copyWith =>
      __$$TradeImplCopyWithImpl<_$TradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeImplToJson(
      this,
    );
  }
}

abstract class _Trade extends Trade {
  const factory _Trade(
      {required final String id,
      required final String symbol,
      required final String direction,
      required final double entryPrice,
      required final double? exitPrice,
      required final double stopLoss,
      required final double takeProfit,
      required final double lotSize,
      required final DateTime openedAt,
      required final DateTime? closedAt,
      required final double pnlMoney,
      required final double pnlPips,
      required final double riskRewardActual,
      required final String contractId,
      required final String status,
      required final String regime,
      required final String session,
      required final double confidence}) = _$TradeImpl;
  const _Trade._() : super._();

  factory _Trade.fromJson(Map<String, dynamic> json) = _$TradeImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get direction;
  @override
  double get entryPrice;
  @override
  double? get exitPrice;
  @override
  double get stopLoss;
  @override
  double get takeProfit;
  @override
  double get lotSize;
  @override
  DateTime get openedAt;
  @override
  DateTime? get closedAt;
  @override
  double get pnlMoney;
  @override
  double get pnlPips;
  @override
  double get riskRewardActual;
  @override
  String get contractId;
  @override
  String get status;
  @override
  String get regime;
  @override
  String get session;
  @override
  double get confidence;

  /// Create a copy of Trade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeImplCopyWith<_$TradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
