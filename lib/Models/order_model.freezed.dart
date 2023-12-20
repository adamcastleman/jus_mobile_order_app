// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OrderModel {
  String? get userID => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  int get locationID => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<dynamic> get items => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get orderSource => throw _privateConstructorUsedError;
  DateTime? get pickupDate => throw _privateConstructorUsedError;
  DateTime? get pickupTime => throw _privateConstructorUsedError;
  String? get cardBrand => throw _privateConstructorUsedError;
  String? get last4 => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  int get originalSubtotalAmount => throw _privateConstructorUsedError;
  int get discountedSubtotalAmount => throw _privateConstructorUsedError;
  int get taxAmount => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  int get tipAmount => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;
  int get pointsRedeemed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String? userID,
      String orderNumber,
      int locationID,
      DateTime createdAt,
      List<dynamic> items,
      String paymentMethod,
      String orderSource,
      DateTime? pickupDate,
      DateTime? pickupTime,
      String? cardBrand,
      String? last4,
      int totalAmount,
      int originalSubtotalAmount,
      int discountedSubtotalAmount,
      int taxAmount,
      int discountAmount,
      int tipAmount,
      int pointsEarned,
      int pointsRedeemed});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = freezed,
    Object? orderNumber = null,
    Object? locationID = null,
    Object? createdAt = null,
    Object? items = null,
    Object? paymentMethod = null,
    Object? orderSource = null,
    Object? pickupDate = freezed,
    Object? pickupTime = freezed,
    Object? cardBrand = freezed,
    Object? last4 = freezed,
    Object? totalAmount = null,
    Object? originalSubtotalAmount = null,
    Object? discountedSubtotalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? tipAmount = null,
    Object? pointsEarned = null,
    Object? pointsRedeemed = null,
  }) {
    return _then(_value.copyWith(
      userID: freezed == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      locationID: null == locationID
          ? _value.locationID
          : locationID // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      orderSource: null == orderSource
          ? _value.orderSource
          : orderSource // ignore: cast_nullable_to_non_nullable
              as String,
      pickupDate: freezed == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickupTime: freezed == pickupTime
          ? _value.pickupTime
          : pickupTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cardBrand: freezed == cardBrand
          ? _value.cardBrand
          : cardBrand // ignore: cast_nullable_to_non_nullable
              as String?,
      last4: freezed == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      originalSubtotalAmount: null == originalSubtotalAmount
          ? _value.originalSubtotalAmount
          : originalSubtotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountedSubtotalAmount: null == discountedSubtotalAmount
          ? _value.discountedSubtotalAmount
          : discountedSubtotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as int,
      tipAmount: null == tipAmount
          ? _value.tipAmount
          : tipAmount // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      pointsRedeemed: null == pointsRedeemed
          ? _value.pointsRedeemed
          : pointsRedeemed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? userID,
      String orderNumber,
      int locationID,
      DateTime createdAt,
      List<dynamic> items,
      String paymentMethod,
      String orderSource,
      DateTime? pickupDate,
      DateTime? pickupTime,
      String? cardBrand,
      String? last4,
      int totalAmount,
      int originalSubtotalAmount,
      int discountedSubtotalAmount,
      int taxAmount,
      int discountAmount,
      int tipAmount,
      int pointsEarned,
      int pointsRedeemed});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = freezed,
    Object? orderNumber = null,
    Object? locationID = null,
    Object? createdAt = null,
    Object? items = null,
    Object? paymentMethod = null,
    Object? orderSource = null,
    Object? pickupDate = freezed,
    Object? pickupTime = freezed,
    Object? cardBrand = freezed,
    Object? last4 = freezed,
    Object? totalAmount = null,
    Object? originalSubtotalAmount = null,
    Object? discountedSubtotalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? tipAmount = null,
    Object? pointsEarned = null,
    Object? pointsRedeemed = null,
  }) {
    return _then(_$OrderModelImpl(
      userID: freezed == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      locationID: null == locationID
          ? _value.locationID
          : locationID // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      orderSource: null == orderSource
          ? _value.orderSource
          : orderSource // ignore: cast_nullable_to_non_nullable
              as String,
      pickupDate: freezed == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickupTime: freezed == pickupTime
          ? _value.pickupTime
          : pickupTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cardBrand: freezed == cardBrand
          ? _value.cardBrand
          : cardBrand // ignore: cast_nullable_to_non_nullable
              as String?,
      last4: freezed == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      originalSubtotalAmount: null == originalSubtotalAmount
          ? _value.originalSubtotalAmount
          : originalSubtotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountedSubtotalAmount: null == discountedSubtotalAmount
          ? _value.discountedSubtotalAmount
          : discountedSubtotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as int,
      tipAmount: null == tipAmount
          ? _value.tipAmount
          : tipAmount // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      pointsRedeemed: null == pointsRedeemed
          ? _value.pointsRedeemed
          : pointsRedeemed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {this.userID,
      required this.orderNumber,
      required this.locationID,
      required this.createdAt,
      required final List<dynamic> items,
      required this.paymentMethod,
      required this.orderSource,
      this.pickupDate,
      this.pickupTime,
      this.cardBrand,
      this.last4,
      required this.totalAmount,
      required this.originalSubtotalAmount,
      required this.discountedSubtotalAmount,
      required this.taxAmount,
      required this.discountAmount,
      required this.tipAmount,
      required this.pointsEarned,
      required this.pointsRedeemed})
      : _items = items;

  @override
  final String? userID;
  @override
  final String orderNumber;
  @override
  final int locationID;
  @override
  final DateTime createdAt;
  final List<dynamic> _items;
  @override
  List<dynamic> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String paymentMethod;
  @override
  final String orderSource;
  @override
  final DateTime? pickupDate;
  @override
  final DateTime? pickupTime;
  @override
  final String? cardBrand;
  @override
  final String? last4;
  @override
  final int totalAmount;
  @override
  final int originalSubtotalAmount;
  @override
  final int discountedSubtotalAmount;
  @override
  final int taxAmount;
  @override
  final int discountAmount;
  @override
  final int tipAmount;
  @override
  final int pointsEarned;
  @override
  final int pointsRedeemed;

  @override
  String toString() {
    return 'OrderModel(userID: $userID, orderNumber: $orderNumber, locationID: $locationID, createdAt: $createdAt, items: $items, paymentMethod: $paymentMethod, orderSource: $orderSource, pickupDate: $pickupDate, pickupTime: $pickupTime, cardBrand: $cardBrand, last4: $last4, totalAmount: $totalAmount, originalSubtotalAmount: $originalSubtotalAmount, discountedSubtotalAmount: $discountedSubtotalAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, tipAmount: $tipAmount, pointsEarned: $pointsEarned, pointsRedeemed: $pointsRedeemed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.locationID, locationID) ||
                other.locationID == locationID) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.orderSource, orderSource) ||
                other.orderSource == orderSource) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            (identical(other.pickupTime, pickupTime) ||
                other.pickupTime == pickupTime) &&
            (identical(other.cardBrand, cardBrand) ||
                other.cardBrand == cardBrand) &&
            (identical(other.last4, last4) || other.last4 == last4) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.originalSubtotalAmount, originalSubtotalAmount) ||
                other.originalSubtotalAmount == originalSubtotalAmount) &&
            (identical(
                    other.discountedSubtotalAmount, discountedSubtotalAmount) ||
                other.discountedSubtotalAmount == discountedSubtotalAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.tipAmount, tipAmount) ||
                other.tipAmount == tipAmount) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.pointsRedeemed, pointsRedeemed) ||
                other.pointsRedeemed == pointsRedeemed));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userID,
        orderNumber,
        locationID,
        createdAt,
        const DeepCollectionEquality().hash(_items),
        paymentMethod,
        orderSource,
        pickupDate,
        pickupTime,
        cardBrand,
        last4,
        totalAmount,
        originalSubtotalAmount,
        discountedSubtotalAmount,
        taxAmount,
        discountAmount,
        tipAmount,
        pointsEarned,
        pointsRedeemed
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {final String? userID,
      required final String orderNumber,
      required final int locationID,
      required final DateTime createdAt,
      required final List<dynamic> items,
      required final String paymentMethod,
      required final String orderSource,
      final DateTime? pickupDate,
      final DateTime? pickupTime,
      final String? cardBrand,
      final String? last4,
      required final int totalAmount,
      required final int originalSubtotalAmount,
      required final int discountedSubtotalAmount,
      required final int taxAmount,
      required final int discountAmount,
      required final int tipAmount,
      required final int pointsEarned,
      required final int pointsRedeemed}) = _$OrderModelImpl;

  @override
  String? get userID;
  @override
  String get orderNumber;
  @override
  int get locationID;
  @override
  DateTime get createdAt;
  @override
  List<dynamic> get items;
  @override
  String get paymentMethod;
  @override
  String get orderSource;
  @override
  DateTime? get pickupDate;
  @override
  DateTime? get pickupTime;
  @override
  String? get cardBrand;
  @override
  String? get last4;
  @override
  int get totalAmount;
  @override
  int get originalSubtotalAmount;
  @override
  int get discountedSubtotalAmount;
  @override
  int get taxAmount;
  @override
  int get discountAmount;
  @override
  int get tipAmount;
  @override
  int get pointsEarned;
  @override
  int get pointsRedeemed;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
