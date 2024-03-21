// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionModel {
  String get userId => throw _privateConstructorUsedError;
  String get subscriptionId => throw _privateConstructorUsedError;
  String get cardId => throw _privateConstructorUsedError;
  int? get bonusPoints => throw _privateConstructorUsedError;
  int? get totalSaved => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
          SubscriptionModel value, $Res Function(SubscriptionModel) then) =
      _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call(
      {String userId,
      String subscriptionId,
      String cardId,
      int? bonusPoints,
      int? totalSaved});
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? subscriptionId = null,
    Object? cardId = null,
    Object? bonusPoints = freezed,
    Object? totalSaved = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      bonusPoints: freezed == bonusPoints
          ? _value.bonusPoints
          : bonusPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      totalSaved: freezed == totalSaved
          ? _value.totalSaved
          : totalSaved // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(_$SubscriptionModelImpl value,
          $Res Function(_$SubscriptionModelImpl) then) =
      __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String subscriptionId,
      String cardId,
      int? bonusPoints,
      int? totalSaved});
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(_$SubscriptionModelImpl _value,
      $Res Function(_$SubscriptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? subscriptionId = null,
    Object? cardId = null,
    Object? bonusPoints = freezed,
    Object? totalSaved = freezed,
  }) {
    return _then(_$SubscriptionModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      bonusPoints: freezed == bonusPoints
          ? _value.bonusPoints
          : bonusPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      totalSaved: freezed == totalSaved
          ? _value.totalSaved
          : totalSaved // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SubscriptionModelImpl implements _SubscriptionModel {
  const _$SubscriptionModelImpl(
      {required this.userId,
      required this.subscriptionId,
      required this.cardId,
      this.bonusPoints,
      this.totalSaved});

  @override
  final String userId;
  @override
  final String subscriptionId;
  @override
  final String cardId;
  @override
  final int? bonusPoints;
  @override
  final int? totalSaved;

  @override
  String toString() {
    return 'SubscriptionModel(userId: $userId, subscriptionId: $subscriptionId, cardId: $cardId, bonusPoints: $bonusPoints, totalSaved: $totalSaved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.bonusPoints, bonusPoints) ||
                other.bonusPoints == bonusPoints) &&
            (identical(other.totalSaved, totalSaved) ||
                other.totalSaved == totalSaved));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, userId, subscriptionId, cardId, bonusPoints, totalSaved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
          this, _$identity);
}

abstract class _SubscriptionModel implements SubscriptionModel {
  const factory _SubscriptionModel(
      {required final String userId,
      required final String subscriptionId,
      required final String cardId,
      final int? bonusPoints,
      final int? totalSaved}) = _$SubscriptionModelImpl;

  @override
  String get userId;
  @override
  String get subscriptionId;
  @override
  String get cardId;
  @override
  int? get bonusPoints;
  @override
  int? get totalSaved;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
