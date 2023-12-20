// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MembershipDetailsModel {
  String get uid => throw _privateConstructorUsedError;
  List<dynamic> get perks => throw _privateConstructorUsedError;
  List<dynamic> get subscriptionPrice => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get signUpText => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MembershipDetailsModelCopyWith<MembershipDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipDetailsModelCopyWith<$Res> {
  factory $MembershipDetailsModelCopyWith(MembershipDetailsModel value,
          $Res Function(MembershipDetailsModel) then) =
      _$MembershipDetailsModelCopyWithImpl<$Res, MembershipDetailsModel>;
  @useResult
  $Res call(
      {String uid,
      List<dynamic> perks,
      List<dynamic> subscriptionPrice,
      String description,
      String signUpText,
      String name});
}

/// @nodoc
class _$MembershipDetailsModelCopyWithImpl<$Res,
        $Val extends MembershipDetailsModel>
    implements $MembershipDetailsModelCopyWith<$Res> {
  _$MembershipDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? perks = null,
    Object? subscriptionPrice = null,
    Object? description = null,
    Object? signUpText = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      perks: null == perks
          ? _value.perks
          : perks // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      subscriptionPrice: null == subscriptionPrice
          ? _value.subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      signUpText: null == signUpText
          ? _value.signUpText
          : signUpText // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipDetailsModelImplCopyWith<$Res>
    implements $MembershipDetailsModelCopyWith<$Res> {
  factory _$$MembershipDetailsModelImplCopyWith(
          _$MembershipDetailsModelImpl value,
          $Res Function(_$MembershipDetailsModelImpl) then) =
      __$$MembershipDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      List<dynamic> perks,
      List<dynamic> subscriptionPrice,
      String description,
      String signUpText,
      String name});
}

/// @nodoc
class __$$MembershipDetailsModelImplCopyWithImpl<$Res>
    extends _$MembershipDetailsModelCopyWithImpl<$Res,
        _$MembershipDetailsModelImpl>
    implements _$$MembershipDetailsModelImplCopyWith<$Res> {
  __$$MembershipDetailsModelImplCopyWithImpl(
      _$MembershipDetailsModelImpl _value,
      $Res Function(_$MembershipDetailsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? perks = null,
    Object? subscriptionPrice = null,
    Object? description = null,
    Object? signUpText = null,
    Object? name = null,
  }) {
    return _then(_$MembershipDetailsModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      perks: null == perks
          ? _value._perks
          : perks // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      subscriptionPrice: null == subscriptionPrice
          ? _value._subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      signUpText: null == signUpText
          ? _value.signUpText
          : signUpText // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MembershipDetailsModelImpl implements _MembershipDetailsModel {
  const _$MembershipDetailsModelImpl(
      {required this.uid,
      required final List<dynamic> perks,
      required final List<dynamic> subscriptionPrice,
      required this.description,
      required this.signUpText,
      required this.name})
      : _perks = perks,
        _subscriptionPrice = subscriptionPrice;

  @override
  final String uid;
  final List<dynamic> _perks;
  @override
  List<dynamic> get perks {
    if (_perks is EqualUnmodifiableListView) return _perks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_perks);
  }

  final List<dynamic> _subscriptionPrice;
  @override
  List<dynamic> get subscriptionPrice {
    if (_subscriptionPrice is EqualUnmodifiableListView)
      return _subscriptionPrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscriptionPrice);
  }

  @override
  final String description;
  @override
  final String signUpText;
  @override
  final String name;

  @override
  String toString() {
    return 'MembershipDetailsModel(uid: $uid, perks: $perks, subscriptionPrice: $subscriptionPrice, description: $description, signUpText: $signUpText, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipDetailsModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._perks, _perks) &&
            const DeepCollectionEquality()
                .equals(other._subscriptionPrice, _subscriptionPrice) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.signUpText, signUpText) ||
                other.signUpText == signUpText) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      const DeepCollectionEquality().hash(_perks),
      const DeepCollectionEquality().hash(_subscriptionPrice),
      description,
      signUpText,
      name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipDetailsModelImplCopyWith<_$MembershipDetailsModelImpl>
      get copyWith => __$$MembershipDetailsModelImplCopyWithImpl<
          _$MembershipDetailsModelImpl>(this, _$identity);
}

abstract class _MembershipDetailsModel implements MembershipDetailsModel {
  const factory _MembershipDetailsModel(
      {required final String uid,
      required final List<dynamic> perks,
      required final List<dynamic> subscriptionPrice,
      required final String description,
      required final String signUpText,
      required final String name}) = _$MembershipDetailsModelImpl;

  @override
  String get uid;
  @override
  List<dynamic> get perks;
  @override
  List<dynamic> get subscriptionPrice;
  @override
  String get description;
  @override
  String get signUpText;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$MembershipDetailsModelImplCopyWith<_$MembershipDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
