// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_activities_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalletActivitiesModel {
  String get userID => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get gan => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get activity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WalletActivitiesModelCopyWith<WalletActivitiesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletActivitiesModelCopyWith<$Res> {
  factory $WalletActivitiesModelCopyWith(WalletActivitiesModel value,
          $Res Function(WalletActivitiesModel) then) =
      _$WalletActivitiesModelCopyWithImpl<$Res, WalletActivitiesModel>;
  @useResult
  $Res call(
      {String userID,
      String orderNumber,
      DateTime createdAt,
      String gan,
      int amount,
      String activity});
}

/// @nodoc
class _$WalletActivitiesModelCopyWithImpl<$Res,
        $Val extends WalletActivitiesModel>
    implements $WalletActivitiesModelCopyWith<$Res> {
  _$WalletActivitiesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = null,
    Object? orderNumber = null,
    Object? createdAt = null,
    Object? gan = null,
    Object? amount = null,
    Object? activity = null,
  }) {
    return _then(_value.copyWith(
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gan: null == gan
          ? _value.gan
          : gan // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletActivitiesModelImplCopyWith<$Res>
    implements $WalletActivitiesModelCopyWith<$Res> {
  factory _$$WalletActivitiesModelImplCopyWith(
          _$WalletActivitiesModelImpl value,
          $Res Function(_$WalletActivitiesModelImpl) then) =
      __$$WalletActivitiesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userID,
      String orderNumber,
      DateTime createdAt,
      String gan,
      int amount,
      String activity});
}

/// @nodoc
class __$$WalletActivitiesModelImplCopyWithImpl<$Res>
    extends _$WalletActivitiesModelCopyWithImpl<$Res,
        _$WalletActivitiesModelImpl>
    implements _$$WalletActivitiesModelImplCopyWith<$Res> {
  __$$WalletActivitiesModelImplCopyWithImpl(_$WalletActivitiesModelImpl _value,
      $Res Function(_$WalletActivitiesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = null,
    Object? orderNumber = null,
    Object? createdAt = null,
    Object? gan = null,
    Object? amount = null,
    Object? activity = null,
  }) {
    return _then(_$WalletActivitiesModelImpl(
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gan: null == gan
          ? _value.gan
          : gan // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$WalletActivitiesModelImpl implements _WalletActivitiesModel {
  const _$WalletActivitiesModelImpl(
      {required this.userID,
      required this.orderNumber,
      required this.createdAt,
      required this.gan,
      required this.amount,
      required this.activity});

  @override
  final String userID;
  @override
  final String orderNumber;
  @override
  final DateTime createdAt;
  @override
  final String gan;
  @override
  final int amount;
  @override
  final String activity;

  @override
  String toString() {
    return 'WalletActivitiesModel(userID: $userID, orderNumber: $orderNumber, createdAt: $createdAt, gan: $gan, amount: $amount, activity: $activity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletActivitiesModelImpl &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.gan, gan) || other.gan == gan) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.activity, activity) ||
                other.activity == activity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, userID, orderNumber, createdAt, gan, amount, activity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletActivitiesModelImplCopyWith<_$WalletActivitiesModelImpl>
      get copyWith => __$$WalletActivitiesModelImplCopyWithImpl<
          _$WalletActivitiesModelImpl>(this, _$identity);
}

abstract class _WalletActivitiesModel implements WalletActivitiesModel {
  const factory _WalletActivitiesModel(
      {required final String userID,
      required final String orderNumber,
      required final DateTime createdAt,
      required final String gan,
      required final int amount,
      required final String activity}) = _$WalletActivitiesModelImpl;

  @override
  String get userID;
  @override
  String get orderNumber;
  @override
  DateTime get createdAt;
  @override
  String get gan;
  @override
  int get amount;
  @override
  String get activity;
  @override
  @JsonKey(ignore: true)
  _$$WalletActivitiesModelImplCopyWith<_$WalletActivitiesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
