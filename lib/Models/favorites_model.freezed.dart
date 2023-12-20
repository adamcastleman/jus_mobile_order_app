// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FavoritesModel {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<dynamic> get ingredients => throw _privateConstructorUsedError;
  List<dynamic> get toppings => throw _privateConstructorUsedError;
  int get productID => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  List<dynamic> get allergies => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FavoritesModelCopyWith<FavoritesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesModelCopyWith<$Res> {
  factory $FavoritesModelCopyWith(
          FavoritesModel value, $Res Function(FavoritesModel) then) =
      _$FavoritesModelCopyWithImpl<$Res, FavoritesModel>;
  @useResult
  $Res call(
      {String uid,
      String name,
      List<dynamic> ingredients,
      List<dynamic> toppings,
      int productID,
      int size,
      List<dynamic> allergies});
}

/// @nodoc
class _$FavoritesModelCopyWithImpl<$Res, $Val extends FavoritesModel>
    implements $FavoritesModelCopyWith<$Res> {
  _$FavoritesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? ingredients = null,
    Object? toppings = null,
    Object? productID = null,
    Object? size = null,
    Object? allergies = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      toppings: null == toppings
          ? _value.toppings
          : toppings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      productID: null == productID
          ? _value.productID
          : productID // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      allergies: null == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritesModelImplCopyWith<$Res>
    implements $FavoritesModelCopyWith<$Res> {
  factory _$$FavoritesModelImplCopyWith(_$FavoritesModelImpl value,
          $Res Function(_$FavoritesModelImpl) then) =
      __$$FavoritesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      List<dynamic> ingredients,
      List<dynamic> toppings,
      int productID,
      int size,
      List<dynamic> allergies});
}

/// @nodoc
class __$$FavoritesModelImplCopyWithImpl<$Res>
    extends _$FavoritesModelCopyWithImpl<$Res, _$FavoritesModelImpl>
    implements _$$FavoritesModelImplCopyWith<$Res> {
  __$$FavoritesModelImplCopyWithImpl(
      _$FavoritesModelImpl _value, $Res Function(_$FavoritesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? ingredients = null,
    Object? toppings = null,
    Object? productID = null,
    Object? size = null,
    Object? allergies = null,
  }) {
    return _then(_$FavoritesModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      toppings: null == toppings
          ? _value._toppings
          : toppings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      productID: null == productID
          ? _value.productID
          : productID // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      allergies: null == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc

class _$FavoritesModelImpl implements _FavoritesModel {
  const _$FavoritesModelImpl(
      {required this.uid,
      required this.name,
      required final List<dynamic> ingredients,
      required final List<dynamic> toppings,
      required this.productID,
      required this.size,
      required final List<dynamic> allergies})
      : _ingredients = ingredients,
        _toppings = toppings,
        _allergies = allergies;

  @override
  final String uid;
  @override
  final String name;
  final List<dynamic> _ingredients;
  @override
  List<dynamic> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<dynamic> _toppings;
  @override
  List<dynamic> get toppings {
    if (_toppings is EqualUnmodifiableListView) return _toppings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toppings);
  }

  @override
  final int productID;
  @override
  final int size;
  final List<dynamic> _allergies;
  @override
  List<dynamic> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  @override
  String toString() {
    return 'FavoritesModel(uid: $uid, name: $name, ingredients: $ingredients, toppings: $toppings, productID: $productID, size: $size, allergies: $allergies)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality().equals(other._toppings, _toppings) &&
            (identical(other.productID, productID) ||
                other.productID == productID) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      name,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_toppings),
      productID,
      size,
      const DeepCollectionEquality().hash(_allergies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesModelImplCopyWith<_$FavoritesModelImpl> get copyWith =>
      __$$FavoritesModelImplCopyWithImpl<_$FavoritesModelImpl>(
          this, _$identity);
}

abstract class _FavoritesModel implements FavoritesModel {
  const factory _FavoritesModel(
      {required final String uid,
      required final String name,
      required final List<dynamic> ingredients,
      required final List<dynamic> toppings,
      required final int productID,
      required final int size,
      required final List<dynamic> allergies}) = _$FavoritesModelImpl;

  @override
  String get uid;
  @override
  String get name;
  @override
  List<dynamic> get ingredients;
  @override
  List<dynamic> get toppings;
  @override
  int get productID;
  @override
  int get size;
  @override
  List<dynamic> get allergies;
  @override
  @JsonKey(ignore: true)
  _$$FavoritesModelImplCopyWith<_$FavoritesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
