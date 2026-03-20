// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proposal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TradeProposal _$TradeProposalFromJson(Map<String, dynamic> json) {
  return _TradeProposal.fromJson(json);
}

/// @nodoc
mixin _$TradeProposal {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get timeframe => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;
  double get entry => throw _privateConstructorUsedError;
  double get stopLoss => throw _privateConstructorUsedError;
  double get takeProfit => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  MarketRegime get regime => throw _privateConstructorUsedError;
  int get po3Phase => throw _privateConstructorUsedError;
  bool get oteConfluence => throw _privateConstructorUsedError;
  bool get mtfAligned => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this TradeProposal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TradeProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeProposalCopyWith<TradeProposal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeProposalCopyWith<$Res> {
  factory $TradeProposalCopyWith(
          TradeProposal value, $Res Function(TradeProposal) then) =
      _$TradeProposalCopyWithImpl<$Res, TradeProposal>;
  @useResult
  $Res call(
      {String id,
      String symbol,
      String timeframe,
      String direction,
      double entry,
      double stopLoss,
      double takeProfit,
      double confidence,
      String explanation,
      MarketRegime regime,
      int po3Phase,
      bool oteConfluence,
      bool mtfAligned,
      DateTime generatedAt,
      String status});
}

/// @nodoc
class _$TradeProposalCopyWithImpl<$Res, $Val extends TradeProposal>
    implements $TradeProposalCopyWith<$Res> {
  _$TradeProposalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeProposal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? timeframe = null,
    Object? direction = null,
    Object? entry = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? confidence = null,
    Object? explanation = null,
    Object? regime = null,
    Object? po3Phase = null,
    Object? oteConfluence = null,
    Object? mtfAligned = null,
    Object? generatedAt = null,
    Object? status = null,
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
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      entry: null == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as MarketRegime,
      po3Phase: null == po3Phase
          ? _value.po3Phase
          : po3Phase // ignore: cast_nullable_to_non_nullable
              as int,
      oteConfluence: null == oteConfluence
          ? _value.oteConfluence
          : oteConfluence // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfAligned: null == mtfAligned
          ? _value.mtfAligned
          : mtfAligned // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeProposalImplCopyWith<$Res>
    implements $TradeProposalCopyWith<$Res> {
  factory _$$TradeProposalImplCopyWith(
          _$TradeProposalImpl value, $Res Function(_$TradeProposalImpl) then) =
      __$$TradeProposalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String symbol,
      String timeframe,
      String direction,
      double entry,
      double stopLoss,
      double takeProfit,
      double confidence,
      String explanation,
      MarketRegime regime,
      int po3Phase,
      bool oteConfluence,
      bool mtfAligned,
      DateTime generatedAt,
      String status});
}

/// @nodoc
class __$$TradeProposalImplCopyWithImpl<$Res>
    extends _$TradeProposalCopyWithImpl<$Res, _$TradeProposalImpl>
    implements _$$TradeProposalImplCopyWith<$Res> {
  __$$TradeProposalImplCopyWithImpl(
      _$TradeProposalImpl _value, $Res Function(_$TradeProposalImpl) _then)
      : super(_value, _then);

  /// Create a copy of TradeProposal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? timeframe = null,
    Object? direction = null,
    Object? entry = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? confidence = null,
    Object? explanation = null,
    Object? regime = null,
    Object? po3Phase = null,
    Object? oteConfluence = null,
    Object? mtfAligned = null,
    Object? generatedAt = null,
    Object? status = null,
  }) {
    return _then(_$TradeProposalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      entry: null == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as MarketRegime,
      po3Phase: null == po3Phase
          ? _value.po3Phase
          : po3Phase // ignore: cast_nullable_to_non_nullable
              as int,
      oteConfluence: null == oteConfluence
          ? _value.oteConfluence
          : oteConfluence // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfAligned: null == mtfAligned
          ? _value.mtfAligned
          : mtfAligned // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeProposalImpl extends _TradeProposal {
  const _$TradeProposalImpl(
      {required this.id,
      required this.symbol,
      required this.timeframe,
      required this.direction,
      required this.entry,
      required this.stopLoss,
      required this.takeProfit,
      required this.confidence,
      required this.explanation,
      required this.regime,
      required this.po3Phase,
      required this.oteConfluence,
      required this.mtfAligned,
      required this.generatedAt,
      this.status = 'pending'})
      : super._();

  factory _$TradeProposalImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeProposalImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String timeframe;
  @override
  final String direction;
  @override
  final double entry;
  @override
  final double stopLoss;
  @override
  final double takeProfit;
  @override
  final double confidence;
  @override
  final String explanation;
  @override
  final MarketRegime regime;
  @override
  final int po3Phase;
  @override
  final bool oteConfluence;
  @override
  final bool mtfAligned;
  @override
  final DateTime generatedAt;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'TradeProposal(id: $id, symbol: $symbol, timeframe: $timeframe, direction: $direction, entry: $entry, stopLoss: $stopLoss, takeProfit: $takeProfit, confidence: $confidence, explanation: $explanation, regime: $regime, po3Phase: $po3Phase, oteConfluence: $oteConfluence, mtfAligned: $mtfAligned, generatedAt: $generatedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeProposalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.entry, entry) || other.entry == entry) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.regime, regime) || other.regime == regime) &&
            (identical(other.po3Phase, po3Phase) ||
                other.po3Phase == po3Phase) &&
            (identical(other.oteConfluence, oteConfluence) ||
                other.oteConfluence == oteConfluence) &&
            (identical(other.mtfAligned, mtfAligned) ||
                other.mtfAligned == mtfAligned) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      timeframe,
      direction,
      entry,
      stopLoss,
      takeProfit,
      confidence,
      explanation,
      regime,
      po3Phase,
      oteConfluence,
      mtfAligned,
      generatedAt,
      status);

  /// Create a copy of TradeProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeProposalImplCopyWith<_$TradeProposalImpl> get copyWith =>
      __$$TradeProposalImplCopyWithImpl<_$TradeProposalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeProposalImplToJson(
      this,
    );
  }
}

abstract class _TradeProposal extends TradeProposal {
  const factory _TradeProposal(
      {required final String id,
      required final String symbol,
      required final String timeframe,
      required final String direction,
      required final double entry,
      required final double stopLoss,
      required final double takeProfit,
      required final double confidence,
      required final String explanation,
      required final MarketRegime regime,
      required final int po3Phase,
      required final bool oteConfluence,
      required final bool mtfAligned,
      required final DateTime generatedAt,
      final String status}) = _$TradeProposalImpl;
  const _TradeProposal._() : super._();

  factory _TradeProposal.fromJson(Map<String, dynamic> json) =
      _$TradeProposalImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get timeframe;
  @override
  String get direction;
  @override
  double get entry;
  @override
  double get stopLoss;
  @override
  double get takeProfit;
  @override
  double get confidence;
  @override
  String get explanation;
  @override
  MarketRegime get regime;
  @override
  int get po3Phase;
  @override
  bool get oteConfluence;
  @override
  bool get mtfAligned;
  @override
  DateTime get generatedAt;
  @override
  String get status;

  /// Create a copy of TradeProposal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeProposalImplCopyWith<_$TradeProposalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
