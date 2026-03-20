// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ict_features.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderBlockZone _$OrderBlockZoneFromJson(Map<String, dynamic> json) {
  return _OrderBlockZone.fromJson(json);
}

/// @nodoc
mixin _$OrderBlockZone {
  String get direction => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get midpoint => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;

  /// Serializes this OrderBlockZone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderBlockZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderBlockZoneCopyWith<OrderBlockZone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderBlockZoneCopyWith<$Res> {
  factory $OrderBlockZoneCopyWith(
          OrderBlockZone value, $Res Function(OrderBlockZone) then) =
      _$OrderBlockZoneCopyWithImpl<$Res, OrderBlockZone>;
  @useResult
  $Res call(
      {String direction,
      double high,
      double low,
      double midpoint,
      double strength,
      bool isValid});
}

/// @nodoc
class _$OrderBlockZoneCopyWithImpl<$Res, $Val extends OrderBlockZone>
    implements $OrderBlockZoneCopyWith<$Res> {
  _$OrderBlockZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderBlockZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
    Object? high = null,
    Object? low = null,
    Object? midpoint = null,
    Object? strength = null,
    Object? isValid = null,
  }) {
    return _then(_value.copyWith(
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      midpoint: null == midpoint
          ? _value.midpoint
          : midpoint // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderBlockZoneImplCopyWith<$Res>
    implements $OrderBlockZoneCopyWith<$Res> {
  factory _$$OrderBlockZoneImplCopyWith(_$OrderBlockZoneImpl value,
          $Res Function(_$OrderBlockZoneImpl) then) =
      __$$OrderBlockZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String direction,
      double high,
      double low,
      double midpoint,
      double strength,
      bool isValid});
}

/// @nodoc
class __$$OrderBlockZoneImplCopyWithImpl<$Res>
    extends _$OrderBlockZoneCopyWithImpl<$Res, _$OrderBlockZoneImpl>
    implements _$$OrderBlockZoneImplCopyWith<$Res> {
  __$$OrderBlockZoneImplCopyWithImpl(
      _$OrderBlockZoneImpl _value, $Res Function(_$OrderBlockZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderBlockZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
    Object? high = null,
    Object? low = null,
    Object? midpoint = null,
    Object? strength = null,
    Object? isValid = null,
  }) {
    return _then(_$OrderBlockZoneImpl(
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      midpoint: null == midpoint
          ? _value.midpoint
          : midpoint // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderBlockZoneImpl extends _OrderBlockZone {
  const _$OrderBlockZoneImpl(
      {required this.direction,
      required this.high,
      required this.low,
      required this.midpoint,
      required this.strength,
      required this.isValid})
      : super._();

  factory _$OrderBlockZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderBlockZoneImplFromJson(json);

  @override
  final String direction;
  @override
  final double high;
  @override
  final double low;
  @override
  final double midpoint;
  @override
  final double strength;
  @override
  final bool isValid;

  @override
  String toString() {
    return 'OrderBlockZone(direction: $direction, high: $high, low: $low, midpoint: $midpoint, strength: $strength, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderBlockZoneImpl &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.midpoint, midpoint) ||
                other.midpoint == midpoint) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, direction, high, low, midpoint, strength, isValid);

  /// Create a copy of OrderBlockZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderBlockZoneImplCopyWith<_$OrderBlockZoneImpl> get copyWith =>
      __$$OrderBlockZoneImplCopyWithImpl<_$OrderBlockZoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderBlockZoneImplToJson(
      this,
    );
  }
}

abstract class _OrderBlockZone extends OrderBlockZone {
  const factory _OrderBlockZone(
      {required final String direction,
      required final double high,
      required final double low,
      required final double midpoint,
      required final double strength,
      required final bool isValid}) = _$OrderBlockZoneImpl;
  const _OrderBlockZone._() : super._();

  factory _OrderBlockZone.fromJson(Map<String, dynamic> json) =
      _$OrderBlockZoneImpl.fromJson;

  @override
  String get direction;
  @override
  double get high;
  @override
  double get low;
  @override
  double get midpoint;
  @override
  double get strength;
  @override
  bool get isValid;

  /// Create a copy of OrderBlockZone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderBlockZoneImplCopyWith<_$OrderBlockZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FairValueGapZone _$FairValueGapZoneFromJson(Map<String, dynamic> json) {
  return _FairValueGapZone.fromJson(json);
}

/// @nodoc
mixin _$FairValueGapZone {
  String get direction => throw _privateConstructorUsedError;
  double get upper => throw _privateConstructorUsedError;
  double get lower => throw _privateConstructorUsedError;
  bool get isFilled => throw _privateConstructorUsedError;

  /// Serializes this FairValueGapZone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FairValueGapZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FairValueGapZoneCopyWith<FairValueGapZone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FairValueGapZoneCopyWith<$Res> {
  factory $FairValueGapZoneCopyWith(
          FairValueGapZone value, $Res Function(FairValueGapZone) then) =
      _$FairValueGapZoneCopyWithImpl<$Res, FairValueGapZone>;
  @useResult
  $Res call({String direction, double upper, double lower, bool isFilled});
}

/// @nodoc
class _$FairValueGapZoneCopyWithImpl<$Res, $Val extends FairValueGapZone>
    implements $FairValueGapZoneCopyWith<$Res> {
  _$FairValueGapZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FairValueGapZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
    Object? upper = null,
    Object? lower = null,
    Object? isFilled = null,
  }) {
    return _then(_value.copyWith(
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      upper: null == upper
          ? _value.upper
          : upper // ignore: cast_nullable_to_non_nullable
              as double,
      lower: null == lower
          ? _value.lower
          : lower // ignore: cast_nullable_to_non_nullable
              as double,
      isFilled: null == isFilled
          ? _value.isFilled
          : isFilled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FairValueGapZoneImplCopyWith<$Res>
    implements $FairValueGapZoneCopyWith<$Res> {
  factory _$$FairValueGapZoneImplCopyWith(_$FairValueGapZoneImpl value,
          $Res Function(_$FairValueGapZoneImpl) then) =
      __$$FairValueGapZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String direction, double upper, double lower, bool isFilled});
}

/// @nodoc
class __$$FairValueGapZoneImplCopyWithImpl<$Res>
    extends _$FairValueGapZoneCopyWithImpl<$Res, _$FairValueGapZoneImpl>
    implements _$$FairValueGapZoneImplCopyWith<$Res> {
  __$$FairValueGapZoneImplCopyWithImpl(_$FairValueGapZoneImpl _value,
      $Res Function(_$FairValueGapZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of FairValueGapZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
    Object? upper = null,
    Object? lower = null,
    Object? isFilled = null,
  }) {
    return _then(_$FairValueGapZoneImpl(
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      upper: null == upper
          ? _value.upper
          : upper // ignore: cast_nullable_to_non_nullable
              as double,
      lower: null == lower
          ? _value.lower
          : lower // ignore: cast_nullable_to_non_nullable
              as double,
      isFilled: null == isFilled
          ? _value.isFilled
          : isFilled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FairValueGapZoneImpl extends _FairValueGapZone {
  const _$FairValueGapZoneImpl(
      {required this.direction,
      required this.upper,
      required this.lower,
      required this.isFilled})
      : super._();

  factory _$FairValueGapZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$FairValueGapZoneImplFromJson(json);

  @override
  final String direction;
  @override
  final double upper;
  @override
  final double lower;
  @override
  final bool isFilled;

  @override
  String toString() {
    return 'FairValueGapZone(direction: $direction, upper: $upper, lower: $lower, isFilled: $isFilled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FairValueGapZoneImpl &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.upper, upper) || other.upper == upper) &&
            (identical(other.lower, lower) || other.lower == lower) &&
            (identical(other.isFilled, isFilled) ||
                other.isFilled == isFilled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, direction, upper, lower, isFilled);

  /// Create a copy of FairValueGapZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FairValueGapZoneImplCopyWith<_$FairValueGapZoneImpl> get copyWith =>
      __$$FairValueGapZoneImplCopyWithImpl<_$FairValueGapZoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FairValueGapZoneImplToJson(
      this,
    );
  }
}

abstract class _FairValueGapZone extends FairValueGapZone {
  const factory _FairValueGapZone(
      {required final String direction,
      required final double upper,
      required final double lower,
      required final bool isFilled}) = _$FairValueGapZoneImpl;
  const _FairValueGapZone._() : super._();

  factory _FairValueGapZone.fromJson(Map<String, dynamic> json) =
      _$FairValueGapZoneImpl.fromJson;

  @override
  String get direction;
  @override
  double get upper;
  @override
  double get lower;
  @override
  bool get isFilled;

  /// Create a copy of FairValueGapZone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FairValueGapZoneImplCopyWith<_$FairValueGapZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FibLevels _$FibLevelsFromJson(Map<String, dynamic> json) {
  return _FibLevels.fromJson(json);
}

/// @nodoc
mixin _$FibLevels {
  double get swingHigh => throw _privateConstructorUsedError;
  double get swingLow => throw _privateConstructorUsedError;
  Map<String, double> get levels => throw _privateConstructorUsedError;

  /// Serializes this FibLevels to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FibLevels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FibLevelsCopyWith<FibLevels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FibLevelsCopyWith<$Res> {
  factory $FibLevelsCopyWith(FibLevels value, $Res Function(FibLevels) then) =
      _$FibLevelsCopyWithImpl<$Res, FibLevels>;
  @useResult
  $Res call({double swingHigh, double swingLow, Map<String, double> levels});
}

/// @nodoc
class _$FibLevelsCopyWithImpl<$Res, $Val extends FibLevels>
    implements $FibLevelsCopyWith<$Res> {
  _$FibLevelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FibLevels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? swingHigh = null,
    Object? swingLow = null,
    Object? levels = null,
  }) {
    return _then(_value.copyWith(
      swingHigh: null == swingHigh
          ? _value.swingHigh
          : swingHigh // ignore: cast_nullable_to_non_nullable
              as double,
      swingLow: null == swingLow
          ? _value.swingLow
          : swingLow // ignore: cast_nullable_to_non_nullable
              as double,
      levels: null == levels
          ? _value.levels
          : levels // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FibLevelsImplCopyWith<$Res>
    implements $FibLevelsCopyWith<$Res> {
  factory _$$FibLevelsImplCopyWith(
          _$FibLevelsImpl value, $Res Function(_$FibLevelsImpl) then) =
      __$$FibLevelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double swingHigh, double swingLow, Map<String, double> levels});
}

/// @nodoc
class __$$FibLevelsImplCopyWithImpl<$Res>
    extends _$FibLevelsCopyWithImpl<$Res, _$FibLevelsImpl>
    implements _$$FibLevelsImplCopyWith<$Res> {
  __$$FibLevelsImplCopyWithImpl(
      _$FibLevelsImpl _value, $Res Function(_$FibLevelsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FibLevels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? swingHigh = null,
    Object? swingLow = null,
    Object? levels = null,
  }) {
    return _then(_$FibLevelsImpl(
      swingHigh: null == swingHigh
          ? _value.swingHigh
          : swingHigh // ignore: cast_nullable_to_non_nullable
              as double,
      swingLow: null == swingLow
          ? _value.swingLow
          : swingLow // ignore: cast_nullable_to_non_nullable
              as double,
      levels: null == levels
          ? _value._levels
          : levels // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FibLevelsImpl extends _FibLevels {
  const _$FibLevelsImpl(
      {required this.swingHigh,
      required this.swingLow,
      required final Map<String, double> levels})
      : _levels = levels,
        super._();

  factory _$FibLevelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FibLevelsImplFromJson(json);

  @override
  final double swingHigh;
  @override
  final double swingLow;
  final Map<String, double> _levels;
  @override
  Map<String, double> get levels {
    if (_levels is EqualUnmodifiableMapView) return _levels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_levels);
  }

  @override
  String toString() {
    return 'FibLevels(swingHigh: $swingHigh, swingLow: $swingLow, levels: $levels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FibLevelsImpl &&
            (identical(other.swingHigh, swingHigh) ||
                other.swingHigh == swingHigh) &&
            (identical(other.swingLow, swingLow) ||
                other.swingLow == swingLow) &&
            const DeepCollectionEquality().equals(other._levels, _levels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, swingHigh, swingLow,
      const DeepCollectionEquality().hash(_levels));

  /// Create a copy of FibLevels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FibLevelsImplCopyWith<_$FibLevelsImpl> get copyWith =>
      __$$FibLevelsImplCopyWithImpl<_$FibLevelsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FibLevelsImplToJson(
      this,
    );
  }
}

abstract class _FibLevels extends FibLevels {
  const factory _FibLevels(
      {required final double swingHigh,
      required final double swingLow,
      required final Map<String, double> levels}) = _$FibLevelsImpl;
  const _FibLevels._() : super._();

  factory _FibLevels.fromJson(Map<String, dynamic> json) =
      _$FibLevelsImpl.fromJson;

  @override
  double get swingHigh;
  @override
  double get swingLow;
  @override
  Map<String, double> get levels;

  /// Create a copy of FibLevels
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FibLevelsImplCopyWith<_$FibLevelsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IctFeatures _$IctFeaturesFromJson(Map<String, dynamic> json) {
  return _IctFeatures.fromJson(json);
}

/// @nodoc
mixin _$IctFeatures {
  MarketRegime get regime => throw _privateConstructorUsedError;
  TradingSession get session => throw _privateConstructorUsedError;
  OrderBlockZone? get ob => throw _privateConstructorUsedError;
  FairValueGapZone? get fvg => throw _privateConstructorUsedError;
  String get liquiditySweep => throw _privateConstructorUsedError;
  bool get mss => throw _privateConstructorUsedError;
  bool get bos => throw _privateConstructorUsedError;
  bool get displacementBull => throw _privateConstructorUsedError;
  bool get displacementBear => throw _privateConstructorUsedError;
  FibLevels get fibLevels => throw _privateConstructorUsedError;
  int get po3Phase => throw _privateConstructorUsedError;
  double get pdZone => throw _privateConstructorUsedError;
  double get pdDistance => throw _privateConstructorUsedError;
  double get inducement => throw _privateConstructorUsedError;
  bool get inducementSwept => throw _privateConstructorUsedError;
  double get oteZoneUpper => throw _privateConstructorUsedError;
  double get oteZoneLower => throw _privateConstructorUsedError;
  bool get oteConfluence => throw _privateConstructorUsedError;
  bool get mtfAligned => throw _privateConstructorUsedError;
  String? get mtfBias4h => throw _privateConstructorUsedError;
  String? get mtfBias1h => throw _privateConstructorUsedError;

  /// Serializes this IctFeatures to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IctFeaturesCopyWith<IctFeatures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IctFeaturesCopyWith<$Res> {
  factory $IctFeaturesCopyWith(
          IctFeatures value, $Res Function(IctFeatures) then) =
      _$IctFeaturesCopyWithImpl<$Res, IctFeatures>;
  @useResult
  $Res call(
      {MarketRegime regime,
      TradingSession session,
      OrderBlockZone? ob,
      FairValueGapZone? fvg,
      String liquiditySweep,
      bool mss,
      bool bos,
      bool displacementBull,
      bool displacementBear,
      FibLevels fibLevels,
      int po3Phase,
      double pdZone,
      double pdDistance,
      double inducement,
      bool inducementSwept,
      double oteZoneUpper,
      double oteZoneLower,
      bool oteConfluence,
      bool mtfAligned,
      String? mtfBias4h,
      String? mtfBias1h});

  $OrderBlockZoneCopyWith<$Res>? get ob;
  $FairValueGapZoneCopyWith<$Res>? get fvg;
  $FibLevelsCopyWith<$Res> get fibLevels;
}

/// @nodoc
class _$IctFeaturesCopyWithImpl<$Res, $Val extends IctFeatures>
    implements $IctFeaturesCopyWith<$Res> {
  _$IctFeaturesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regime = null,
    Object? session = null,
    Object? ob = freezed,
    Object? fvg = freezed,
    Object? liquiditySweep = null,
    Object? mss = null,
    Object? bos = null,
    Object? displacementBull = null,
    Object? displacementBear = null,
    Object? fibLevels = null,
    Object? po3Phase = null,
    Object? pdZone = null,
    Object? pdDistance = null,
    Object? inducement = null,
    Object? inducementSwept = null,
    Object? oteZoneUpper = null,
    Object? oteZoneLower = null,
    Object? oteConfluence = null,
    Object? mtfAligned = null,
    Object? mtfBias4h = freezed,
    Object? mtfBias1h = freezed,
  }) {
    return _then(_value.copyWith(
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as MarketRegime,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TradingSession,
      ob: freezed == ob
          ? _value.ob
          : ob // ignore: cast_nullable_to_non_nullable
              as OrderBlockZone?,
      fvg: freezed == fvg
          ? _value.fvg
          : fvg // ignore: cast_nullable_to_non_nullable
              as FairValueGapZone?,
      liquiditySweep: null == liquiditySweep
          ? _value.liquiditySweep
          : liquiditySweep // ignore: cast_nullable_to_non_nullable
              as String,
      mss: null == mss
          ? _value.mss
          : mss // ignore: cast_nullable_to_non_nullable
              as bool,
      bos: null == bos
          ? _value.bos
          : bos // ignore: cast_nullable_to_non_nullable
              as bool,
      displacementBull: null == displacementBull
          ? _value.displacementBull
          : displacementBull // ignore: cast_nullable_to_non_nullable
              as bool,
      displacementBear: null == displacementBear
          ? _value.displacementBear
          : displacementBear // ignore: cast_nullable_to_non_nullable
              as bool,
      fibLevels: null == fibLevels
          ? _value.fibLevels
          : fibLevels // ignore: cast_nullable_to_non_nullable
              as FibLevels,
      po3Phase: null == po3Phase
          ? _value.po3Phase
          : po3Phase // ignore: cast_nullable_to_non_nullable
              as int,
      pdZone: null == pdZone
          ? _value.pdZone
          : pdZone // ignore: cast_nullable_to_non_nullable
              as double,
      pdDistance: null == pdDistance
          ? _value.pdDistance
          : pdDistance // ignore: cast_nullable_to_non_nullable
              as double,
      inducement: null == inducement
          ? _value.inducement
          : inducement // ignore: cast_nullable_to_non_nullable
              as double,
      inducementSwept: null == inducementSwept
          ? _value.inducementSwept
          : inducementSwept // ignore: cast_nullable_to_non_nullable
              as bool,
      oteZoneUpper: null == oteZoneUpper
          ? _value.oteZoneUpper
          : oteZoneUpper // ignore: cast_nullable_to_non_nullable
              as double,
      oteZoneLower: null == oteZoneLower
          ? _value.oteZoneLower
          : oteZoneLower // ignore: cast_nullable_to_non_nullable
              as double,
      oteConfluence: null == oteConfluence
          ? _value.oteConfluence
          : oteConfluence // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfAligned: null == mtfAligned
          ? _value.mtfAligned
          : mtfAligned // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfBias4h: freezed == mtfBias4h
          ? _value.mtfBias4h
          : mtfBias4h // ignore: cast_nullable_to_non_nullable
              as String?,
      mtfBias1h: freezed == mtfBias1h
          ? _value.mtfBias1h
          : mtfBias1h // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderBlockZoneCopyWith<$Res>? get ob {
    if (_value.ob == null) {
      return null;
    }

    return $OrderBlockZoneCopyWith<$Res>(_value.ob!, (value) {
      return _then(_value.copyWith(ob: value) as $Val);
    });
  }

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FairValueGapZoneCopyWith<$Res>? get fvg {
    if (_value.fvg == null) {
      return null;
    }

    return $FairValueGapZoneCopyWith<$Res>(_value.fvg!, (value) {
      return _then(_value.copyWith(fvg: value) as $Val);
    });
  }

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FibLevelsCopyWith<$Res> get fibLevels {
    return $FibLevelsCopyWith<$Res>(_value.fibLevels, (value) {
      return _then(_value.copyWith(fibLevels: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IctFeaturesImplCopyWith<$Res>
    implements $IctFeaturesCopyWith<$Res> {
  factory _$$IctFeaturesImplCopyWith(
          _$IctFeaturesImpl value, $Res Function(_$IctFeaturesImpl) then) =
      __$$IctFeaturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MarketRegime regime,
      TradingSession session,
      OrderBlockZone? ob,
      FairValueGapZone? fvg,
      String liquiditySweep,
      bool mss,
      bool bos,
      bool displacementBull,
      bool displacementBear,
      FibLevels fibLevels,
      int po3Phase,
      double pdZone,
      double pdDistance,
      double inducement,
      bool inducementSwept,
      double oteZoneUpper,
      double oteZoneLower,
      bool oteConfluence,
      bool mtfAligned,
      String? mtfBias4h,
      String? mtfBias1h});

  @override
  $OrderBlockZoneCopyWith<$Res>? get ob;
  @override
  $FairValueGapZoneCopyWith<$Res>? get fvg;
  @override
  $FibLevelsCopyWith<$Res> get fibLevels;
}

/// @nodoc
class __$$IctFeaturesImplCopyWithImpl<$Res>
    extends _$IctFeaturesCopyWithImpl<$Res, _$IctFeaturesImpl>
    implements _$$IctFeaturesImplCopyWith<$Res> {
  __$$IctFeaturesImplCopyWithImpl(
      _$IctFeaturesImpl _value, $Res Function(_$IctFeaturesImpl) _then)
      : super(_value, _then);

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regime = null,
    Object? session = null,
    Object? ob = freezed,
    Object? fvg = freezed,
    Object? liquiditySweep = null,
    Object? mss = null,
    Object? bos = null,
    Object? displacementBull = null,
    Object? displacementBear = null,
    Object? fibLevels = null,
    Object? po3Phase = null,
    Object? pdZone = null,
    Object? pdDistance = null,
    Object? inducement = null,
    Object? inducementSwept = null,
    Object? oteZoneUpper = null,
    Object? oteZoneLower = null,
    Object? oteConfluence = null,
    Object? mtfAligned = null,
    Object? mtfBias4h = freezed,
    Object? mtfBias1h = freezed,
  }) {
    return _then(_$IctFeaturesImpl(
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as MarketRegime,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TradingSession,
      ob: freezed == ob
          ? _value.ob
          : ob // ignore: cast_nullable_to_non_nullable
              as OrderBlockZone?,
      fvg: freezed == fvg
          ? _value.fvg
          : fvg // ignore: cast_nullable_to_non_nullable
              as FairValueGapZone?,
      liquiditySweep: null == liquiditySweep
          ? _value.liquiditySweep
          : liquiditySweep // ignore: cast_nullable_to_non_nullable
              as String,
      mss: null == mss
          ? _value.mss
          : mss // ignore: cast_nullable_to_non_nullable
              as bool,
      bos: null == bos
          ? _value.bos
          : bos // ignore: cast_nullable_to_non_nullable
              as bool,
      displacementBull: null == displacementBull
          ? _value.displacementBull
          : displacementBull // ignore: cast_nullable_to_non_nullable
              as bool,
      displacementBear: null == displacementBear
          ? _value.displacementBear
          : displacementBear // ignore: cast_nullable_to_non_nullable
              as bool,
      fibLevels: null == fibLevels
          ? _value.fibLevels
          : fibLevels // ignore: cast_nullable_to_non_nullable
              as FibLevels,
      po3Phase: null == po3Phase
          ? _value.po3Phase
          : po3Phase // ignore: cast_nullable_to_non_nullable
              as int,
      pdZone: null == pdZone
          ? _value.pdZone
          : pdZone // ignore: cast_nullable_to_non_nullable
              as double,
      pdDistance: null == pdDistance
          ? _value.pdDistance
          : pdDistance // ignore: cast_nullable_to_non_nullable
              as double,
      inducement: null == inducement
          ? _value.inducement
          : inducement // ignore: cast_nullable_to_non_nullable
              as double,
      inducementSwept: null == inducementSwept
          ? _value.inducementSwept
          : inducementSwept // ignore: cast_nullable_to_non_nullable
              as bool,
      oteZoneUpper: null == oteZoneUpper
          ? _value.oteZoneUpper
          : oteZoneUpper // ignore: cast_nullable_to_non_nullable
              as double,
      oteZoneLower: null == oteZoneLower
          ? _value.oteZoneLower
          : oteZoneLower // ignore: cast_nullable_to_non_nullable
              as double,
      oteConfluence: null == oteConfluence
          ? _value.oteConfluence
          : oteConfluence // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfAligned: null == mtfAligned
          ? _value.mtfAligned
          : mtfAligned // ignore: cast_nullable_to_non_nullable
              as bool,
      mtfBias4h: freezed == mtfBias4h
          ? _value.mtfBias4h
          : mtfBias4h // ignore: cast_nullable_to_non_nullable
              as String?,
      mtfBias1h: freezed == mtfBias1h
          ? _value.mtfBias1h
          : mtfBias1h // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IctFeaturesImpl extends _IctFeatures {
  const _$IctFeaturesImpl(
      {required this.regime,
      required this.session,
      required this.ob,
      required this.fvg,
      required this.liquiditySweep,
      required this.mss,
      required this.bos,
      required this.displacementBull,
      required this.displacementBear,
      required this.fibLevels,
      required this.po3Phase,
      required this.pdZone,
      required this.pdDistance,
      required this.inducement,
      required this.inducementSwept,
      required this.oteZoneUpper,
      required this.oteZoneLower,
      required this.oteConfluence,
      required this.mtfAligned,
      required this.mtfBias4h,
      required this.mtfBias1h})
      : super._();

  factory _$IctFeaturesImpl.fromJson(Map<String, dynamic> json) =>
      _$$IctFeaturesImplFromJson(json);

  @override
  final MarketRegime regime;
  @override
  final TradingSession session;
  @override
  final OrderBlockZone? ob;
  @override
  final FairValueGapZone? fvg;
  @override
  final String liquiditySweep;
  @override
  final bool mss;
  @override
  final bool bos;
  @override
  final bool displacementBull;
  @override
  final bool displacementBear;
  @override
  final FibLevels fibLevels;
  @override
  final int po3Phase;
  @override
  final double pdZone;
  @override
  final double pdDistance;
  @override
  final double inducement;
  @override
  final bool inducementSwept;
  @override
  final double oteZoneUpper;
  @override
  final double oteZoneLower;
  @override
  final bool oteConfluence;
  @override
  final bool mtfAligned;
  @override
  final String? mtfBias4h;
  @override
  final String? mtfBias1h;

  @override
  String toString() {
    return 'IctFeatures(regime: $regime, session: $session, ob: $ob, fvg: $fvg, liquiditySweep: $liquiditySweep, mss: $mss, bos: $bos, displacementBull: $displacementBull, displacementBear: $displacementBear, fibLevels: $fibLevels, po3Phase: $po3Phase, pdZone: $pdZone, pdDistance: $pdDistance, inducement: $inducement, inducementSwept: $inducementSwept, oteZoneUpper: $oteZoneUpper, oteZoneLower: $oteZoneLower, oteConfluence: $oteConfluence, mtfAligned: $mtfAligned, mtfBias4h: $mtfBias4h, mtfBias1h: $mtfBias1h)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IctFeaturesImpl &&
            (identical(other.regime, regime) || other.regime == regime) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.ob, ob) || other.ob == ob) &&
            (identical(other.fvg, fvg) || other.fvg == fvg) &&
            (identical(other.liquiditySweep, liquiditySweep) ||
                other.liquiditySweep == liquiditySweep) &&
            (identical(other.mss, mss) || other.mss == mss) &&
            (identical(other.bos, bos) || other.bos == bos) &&
            (identical(other.displacementBull, displacementBull) ||
                other.displacementBull == displacementBull) &&
            (identical(other.displacementBear, displacementBear) ||
                other.displacementBear == displacementBear) &&
            (identical(other.fibLevels, fibLevels) ||
                other.fibLevels == fibLevels) &&
            (identical(other.po3Phase, po3Phase) ||
                other.po3Phase == po3Phase) &&
            (identical(other.pdZone, pdZone) || other.pdZone == pdZone) &&
            (identical(other.pdDistance, pdDistance) ||
                other.pdDistance == pdDistance) &&
            (identical(other.inducement, inducement) ||
                other.inducement == inducement) &&
            (identical(other.inducementSwept, inducementSwept) ||
                other.inducementSwept == inducementSwept) &&
            (identical(other.oteZoneUpper, oteZoneUpper) ||
                other.oteZoneUpper == oteZoneUpper) &&
            (identical(other.oteZoneLower, oteZoneLower) ||
                other.oteZoneLower == oteZoneLower) &&
            (identical(other.oteConfluence, oteConfluence) ||
                other.oteConfluence == oteConfluence) &&
            (identical(other.mtfAligned, mtfAligned) ||
                other.mtfAligned == mtfAligned) &&
            (identical(other.mtfBias4h, mtfBias4h) ||
                other.mtfBias4h == mtfBias4h) &&
            (identical(other.mtfBias1h, mtfBias1h) ||
                other.mtfBias1h == mtfBias1h));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        regime,
        session,
        ob,
        fvg,
        liquiditySweep,
        mss,
        bos,
        displacementBull,
        displacementBear,
        fibLevels,
        po3Phase,
        pdZone,
        pdDistance,
        inducement,
        inducementSwept,
        oteZoneUpper,
        oteZoneLower,
        oteConfluence,
        mtfAligned,
        mtfBias4h,
        mtfBias1h
      ]);

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IctFeaturesImplCopyWith<_$IctFeaturesImpl> get copyWith =>
      __$$IctFeaturesImplCopyWithImpl<_$IctFeaturesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IctFeaturesImplToJson(
      this,
    );
  }
}

abstract class _IctFeatures extends IctFeatures {
  const factory _IctFeatures(
      {required final MarketRegime regime,
      required final TradingSession session,
      required final OrderBlockZone? ob,
      required final FairValueGapZone? fvg,
      required final String liquiditySweep,
      required final bool mss,
      required final bool bos,
      required final bool displacementBull,
      required final bool displacementBear,
      required final FibLevels fibLevels,
      required final int po3Phase,
      required final double pdZone,
      required final double pdDistance,
      required final double inducement,
      required final bool inducementSwept,
      required final double oteZoneUpper,
      required final double oteZoneLower,
      required final bool oteConfluence,
      required final bool mtfAligned,
      required final String? mtfBias4h,
      required final String? mtfBias1h}) = _$IctFeaturesImpl;
  const _IctFeatures._() : super._();

  factory _IctFeatures.fromJson(Map<String, dynamic> json) =
      _$IctFeaturesImpl.fromJson;

  @override
  MarketRegime get regime;
  @override
  TradingSession get session;
  @override
  OrderBlockZone? get ob;
  @override
  FairValueGapZone? get fvg;
  @override
  String get liquiditySweep;
  @override
  bool get mss;
  @override
  bool get bos;
  @override
  bool get displacementBull;
  @override
  bool get displacementBear;
  @override
  FibLevels get fibLevels;
  @override
  int get po3Phase;
  @override
  double get pdZone;
  @override
  double get pdDistance;
  @override
  double get inducement;
  @override
  bool get inducementSwept;
  @override
  double get oteZoneUpper;
  @override
  double get oteZoneLower;
  @override
  bool get oteConfluence;
  @override
  bool get mtfAligned;
  @override
  String? get mtfBias4h;
  @override
  String? get mtfBias1h;

  /// Create a copy of IctFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IctFeaturesImplCopyWith<_$IctFeaturesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
