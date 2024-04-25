// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'points_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PointsActivityModel {
  String get userId => throw _privateConstructorUsedError;
  int? get pointsEarned => throw _privateConstructorUsedError;
  int? get pointsRedeemed => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PointsActivityModelCopyWith<PointsActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointsActivityModelCopyWith<$Res> {
  factory $PointsActivityModelCopyWith(
          PointsActivityModel value, $Res Function(PointsActivityModel) then) =
      _$PointsActivityModelCopyWithImpl<$Res, PointsActivityModel>;
  @useResult
  $Res call(
      {String userId, int? pointsEarned, int? pointsRedeemed, int? timestamp});
}

/// @nodoc
class _$PointsActivityModelCopyWithImpl<$Res, $Val extends PointsActivityModel>
    implements $PointsActivityModelCopyWith<$Res> {
  _$PointsActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pointsEarned = freezed,
    Object? pointsRedeemed = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pointsEarned: freezed == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      pointsRedeemed: freezed == pointsRedeemed
          ? _value.pointsRedeemed
          : pointsRedeemed // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PointsActivityModelImplCopyWith<$Res>
    implements $PointsActivityModelCopyWith<$Res> {
  factory _$$PointsActivityModelImplCopyWith(_$PointsActivityModelImpl value,
          $Res Function(_$PointsActivityModelImpl) then) =
      __$$PointsActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId, int? pointsEarned, int? pointsRedeemed, int? timestamp});
}

/// @nodoc
class __$$PointsActivityModelImplCopyWithImpl<$Res>
    extends _$PointsActivityModelCopyWithImpl<$Res, _$PointsActivityModelImpl>
    implements _$$PointsActivityModelImplCopyWith<$Res> {
  __$$PointsActivityModelImplCopyWithImpl(_$PointsActivityModelImpl _value,
      $Res Function(_$PointsActivityModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pointsEarned = freezed,
    Object? pointsRedeemed = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$PointsActivityModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pointsEarned: freezed == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      pointsRedeemed: freezed == pointsRedeemed
          ? _value.pointsRedeemed
          : pointsRedeemed // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$PointsActivityModelImpl implements _PointsActivityModel {
  const _$PointsActivityModelImpl(
      {required this.userId,
      this.pointsEarned,
      this.pointsRedeemed,
      this.timestamp});

  @override
  final String userId;
  @override
  final int? pointsEarned;
  @override
  final int? pointsRedeemed;
  @override
  final int? timestamp;

  @override
  String toString() {
    return 'PointsActivityModel(userId: $userId, pointsEarned: $pointsEarned, pointsRedeemed: $pointsRedeemed, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointsActivityModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.pointsRedeemed, pointsRedeemed) ||
                other.pointsRedeemed == pointsRedeemed) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, pointsEarned, pointsRedeemed, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PointsActivityModelImplCopyWith<_$PointsActivityModelImpl> get copyWith =>
      __$$PointsActivityModelImplCopyWithImpl<_$PointsActivityModelImpl>(
          this, _$identity);
}

abstract class _PointsActivityModel implements PointsActivityModel {
  const factory _PointsActivityModel(
      {required final String userId,
      final int? pointsEarned,
      final int? pointsRedeemed,
      final int? timestamp}) = _$PointsActivityModelImpl;

  @override
  String get userId;
  @override
  int? get pointsEarned;
  @override
  int? get pointsRedeemed;
  @override
  int? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$PointsActivityModelImplCopyWith<_$PointsActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
