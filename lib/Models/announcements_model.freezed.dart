// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AnnouncementsModel {
  String get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnnouncementsModelCopyWith<AnnouncementsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnnouncementsModelCopyWith<$Res> {
  factory $AnnouncementsModelCopyWith(
          AnnouncementsModel value, $Res Function(AnnouncementsModel) then) =
      _$AnnouncementsModelCopyWithImpl<$Res, AnnouncementsModel>;
  @useResult
  $Res call({String uid, String title, String description, bool isActive});
}

/// @nodoc
class _$AnnouncementsModelCopyWithImpl<$Res, $Val extends AnnouncementsModel>
    implements $AnnouncementsModelCopyWith<$Res> {
  _$AnnouncementsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? description = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnnouncementsModelImplCopyWith<$Res>
    implements $AnnouncementsModelCopyWith<$Res> {
  factory _$$AnnouncementsModelImplCopyWith(_$AnnouncementsModelImpl value,
          $Res Function(_$AnnouncementsModelImpl) then) =
      __$$AnnouncementsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String title, String description, bool isActive});
}

/// @nodoc
class __$$AnnouncementsModelImplCopyWithImpl<$Res>
    extends _$AnnouncementsModelCopyWithImpl<$Res, _$AnnouncementsModelImpl>
    implements _$$AnnouncementsModelImplCopyWith<$Res> {
  __$$AnnouncementsModelImplCopyWithImpl(_$AnnouncementsModelImpl _value,
      $Res Function(_$AnnouncementsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? description = null,
    Object? isActive = null,
  }) {
    return _then(_$AnnouncementsModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AnnouncementsModelImpl implements _AnnouncementsModel {
  const _$AnnouncementsModelImpl(
      {required this.uid,
      required this.title,
      required this.description,
      required this.isActive});

  @override
  final String uid;
  @override
  final String title;
  @override
  final String description;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'AnnouncementsModel(uid: $uid, title: $title, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnnouncementsModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, title, description, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnnouncementsModelImplCopyWith<_$AnnouncementsModelImpl> get copyWith =>
      __$$AnnouncementsModelImplCopyWithImpl<_$AnnouncementsModelImpl>(
          this, _$identity);
}

abstract class _AnnouncementsModel implements AnnouncementsModel {
  const factory _AnnouncementsModel(
      {required final String uid,
      required final String title,
      required final String description,
      required final bool isActive}) = _$AnnouncementsModelImpl;

  @override
  String get uid;
  @override
  String get title;
  @override
  String get description;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$AnnouncementsModelImplCopyWith<_$AnnouncementsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
