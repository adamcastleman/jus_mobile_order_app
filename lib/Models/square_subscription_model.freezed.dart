// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SquareSubscriptionModel _$SquareSubscriptionModelFromJson(
    Map<String, dynamic> json) {
  return _SquareSubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$SquareSubscriptionModel {
  String get subscriptionId => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String? get canceledDate => throw _privateConstructorUsedError;
  int? get monthlyBillingAnchorDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SquareSubscriptionModelCopyWith<SquareSubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquareSubscriptionModelCopyWith<$Res> {
  factory $SquareSubscriptionModelCopyWith(SquareSubscriptionModel value,
          $Res Function(SquareSubscriptionModel) then) =
      _$SquareSubscriptionModelCopyWithImpl<$Res, SquareSubscriptionModel>;
  @useResult
  $Res call(
      {String subscriptionId,
      String startDate,
      String? canceledDate,
      int? monthlyBillingAnchorDate});
}

/// @nodoc
class _$SquareSubscriptionModelCopyWithImpl<$Res,
        $Val extends SquareSubscriptionModel>
    implements $SquareSubscriptionModelCopyWith<$Res> {
  _$SquareSubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
    Object? startDate = null,
    Object? canceledDate = freezed,
    Object? monthlyBillingAnchorDate = freezed,
  }) {
    return _then(_value.copyWith(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      canceledDate: freezed == canceledDate
          ? _value.canceledDate
          : canceledDate // ignore: cast_nullable_to_non_nullable
              as String?,
      monthlyBillingAnchorDate: freezed == monthlyBillingAnchorDate
          ? _value.monthlyBillingAnchorDate
          : monthlyBillingAnchorDate // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SquareSubscriptionModelImplCopyWith<$Res>
    implements $SquareSubscriptionModelCopyWith<$Res> {
  factory _$$SquareSubscriptionModelImplCopyWith(
          _$SquareSubscriptionModelImpl value,
          $Res Function(_$SquareSubscriptionModelImpl) then) =
      __$$SquareSubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String subscriptionId,
      String startDate,
      String? canceledDate,
      int? monthlyBillingAnchorDate});
}

/// @nodoc
class __$$SquareSubscriptionModelImplCopyWithImpl<$Res>
    extends _$SquareSubscriptionModelCopyWithImpl<$Res,
        _$SquareSubscriptionModelImpl>
    implements _$$SquareSubscriptionModelImplCopyWith<$Res> {
  __$$SquareSubscriptionModelImplCopyWithImpl(
      _$SquareSubscriptionModelImpl _value,
      $Res Function(_$SquareSubscriptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
    Object? startDate = null,
    Object? canceledDate = freezed,
    Object? monthlyBillingAnchorDate = freezed,
  }) {
    return _then(_$SquareSubscriptionModelImpl(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      canceledDate: freezed == canceledDate
          ? _value.canceledDate
          : canceledDate // ignore: cast_nullable_to_non_nullable
              as String?,
      monthlyBillingAnchorDate: freezed == monthlyBillingAnchorDate
          ? _value.monthlyBillingAnchorDate
          : monthlyBillingAnchorDate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SquareSubscriptionModelImpl implements _SquareSubscriptionModel {
  const _$SquareSubscriptionModelImpl(
      {required this.subscriptionId,
      required this.startDate,
      this.canceledDate,
      this.monthlyBillingAnchorDate});

  factory _$SquareSubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SquareSubscriptionModelImplFromJson(json);

  @override
  final String subscriptionId;
  @override
  final String startDate;
  @override
  final String? canceledDate;
  @override
  final int? monthlyBillingAnchorDate;

  @override
  String toString() {
    return 'SquareSubscriptionModel(subscriptionId: $subscriptionId, startDate: $startDate, canceledDate: $canceledDate, monthlyBillingAnchorDate: $monthlyBillingAnchorDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SquareSubscriptionModelImpl &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.canceledDate, canceledDate) ||
                other.canceledDate == canceledDate) &&
            (identical(
                    other.monthlyBillingAnchorDate, monthlyBillingAnchorDate) ||
                other.monthlyBillingAnchorDate == monthlyBillingAnchorDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, subscriptionId, startDate,
      canceledDate, monthlyBillingAnchorDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SquareSubscriptionModelImplCopyWith<_$SquareSubscriptionModelImpl>
      get copyWith => __$$SquareSubscriptionModelImplCopyWithImpl<
          _$SquareSubscriptionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SquareSubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _SquareSubscriptionModel implements SquareSubscriptionModel {
  const factory _SquareSubscriptionModel(
      {required final String subscriptionId,
      required final String startDate,
      final String? canceledDate,
      final int? monthlyBillingAnchorDate}) = _$SquareSubscriptionModelImpl;

  factory _SquareSubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SquareSubscriptionModelImpl.fromJson;

  @override
  String get subscriptionId;
  @override
  String get startDate;
  @override
  String? get canceledDate;
  @override
  int? get monthlyBillingAnchorDate;
  @override
  @JsonKey(ignore: true)
  _$$SquareSubscriptionModelImplCopyWith<_$SquareSubscriptionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
