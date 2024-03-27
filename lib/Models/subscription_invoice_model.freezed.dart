// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionInvoiceModel {
  int get price => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get paymentDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionInvoiceModelCopyWith<SubscriptionInvoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionInvoiceModelCopyWith<$Res> {
  factory $SubscriptionInvoiceModelCopyWith(SubscriptionInvoiceModel value,
          $Res Function(SubscriptionInvoiceModel) then) =
      _$SubscriptionInvoiceModelCopyWithImpl<$Res, SubscriptionInvoiceModel>;
  @useResult
  $Res call({int price, String itemName, String paymentDate});
}

/// @nodoc
class _$SubscriptionInvoiceModelCopyWithImpl<$Res,
        $Val extends SubscriptionInvoiceModel>
    implements $SubscriptionInvoiceModelCopyWith<$Res> {
  _$SubscriptionInvoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? itemName = null,
    Object? paymentDate = null,
  }) {
    return _then(_value.copyWith(
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionInvoiceModelImplCopyWith<$Res>
    implements $SubscriptionInvoiceModelCopyWith<$Res> {
  factory _$$SubscriptionInvoiceModelImplCopyWith(
          _$SubscriptionInvoiceModelImpl value,
          $Res Function(_$SubscriptionInvoiceModelImpl) then) =
      __$$SubscriptionInvoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int price, String itemName, String paymentDate});
}

/// @nodoc
class __$$SubscriptionInvoiceModelImplCopyWithImpl<$Res>
    extends _$SubscriptionInvoiceModelCopyWithImpl<$Res,
        _$SubscriptionInvoiceModelImpl>
    implements _$$SubscriptionInvoiceModelImplCopyWith<$Res> {
  __$$SubscriptionInvoiceModelImplCopyWithImpl(
      _$SubscriptionInvoiceModelImpl _value,
      $Res Function(_$SubscriptionInvoiceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? itemName = null,
    Object? paymentDate = null,
  }) {
    return _then(_$SubscriptionInvoiceModelImpl(
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SubscriptionInvoiceModelImpl implements _SubscriptionInvoiceModel {
  const _$SubscriptionInvoiceModelImpl(
      {required this.price, required this.itemName, required this.paymentDate});

  @override
  final int price;
  @override
  final String itemName;
  @override
  final String paymentDate;

  @override
  String toString() {
    return 'SubscriptionInvoiceModel(price: $price, itemName: $itemName, paymentDate: $paymentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionInvoiceModelImpl &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, price, itemName, paymentDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionInvoiceModelImplCopyWith<_$SubscriptionInvoiceModelImpl>
      get copyWith => __$$SubscriptionInvoiceModelImplCopyWithImpl<
          _$SubscriptionInvoiceModelImpl>(this, _$identity);
}

abstract class _SubscriptionInvoiceModel implements SubscriptionInvoiceModel {
  const factory _SubscriptionInvoiceModel(
      {required final int price,
      required final String itemName,
      required final String paymentDate}) = _$SubscriptionInvoiceModelImpl;

  @override
  int get price;
  @override
  String get itemName;
  @override
  String get paymentDate;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionInvoiceModelImplCopyWith<_$SubscriptionInvoiceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
