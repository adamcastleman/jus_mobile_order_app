// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MembershipStatsModel {
  int? get totalSaved => throw _privateConstructorUsedError;
  int? get bonusPoints => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MembershipStatsModelCopyWith<MembershipStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipStatsModelCopyWith<$Res> {
  factory $MembershipStatsModelCopyWith(MembershipStatsModel value,
          $Res Function(MembershipStatsModel) then) =
      _$MembershipStatsModelCopyWithImpl<$Res, MembershipStatsModel>;
  @useResult
  $Res call({int? totalSaved, int? bonusPoints});
}

/// @nodoc
class _$MembershipStatsModelCopyWithImpl<$Res,
        $Val extends MembershipStatsModel>
    implements $MembershipStatsModelCopyWith<$Res> {
  _$MembershipStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSaved = freezed,
    Object? bonusPoints = freezed,
  }) {
    return _then(_value.copyWith(
      totalSaved: freezed == totalSaved
          ? _value.totalSaved
          : totalSaved // ignore: cast_nullable_to_non_nullable
              as int?,
      bonusPoints: freezed == bonusPoints
          ? _value.bonusPoints
          : bonusPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipStatsModelImplCopyWith<$Res>
    implements $MembershipStatsModelCopyWith<$Res> {
  factory _$$MembershipStatsModelImplCopyWith(_$MembershipStatsModelImpl value,
          $Res Function(_$MembershipStatsModelImpl) then) =
      __$$MembershipStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? totalSaved, int? bonusPoints});
}

/// @nodoc
class __$$MembershipStatsModelImplCopyWithImpl<$Res>
    extends _$MembershipStatsModelCopyWithImpl<$Res, _$MembershipStatsModelImpl>
    implements _$$MembershipStatsModelImplCopyWith<$Res> {
  __$$MembershipStatsModelImplCopyWithImpl(_$MembershipStatsModelImpl _value,
      $Res Function(_$MembershipStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSaved = freezed,
    Object? bonusPoints = freezed,
  }) {
    return _then(_$MembershipStatsModelImpl(
      totalSaved: freezed == totalSaved
          ? _value.totalSaved
          : totalSaved // ignore: cast_nullable_to_non_nullable
              as int?,
      bonusPoints: freezed == bonusPoints
          ? _value.bonusPoints
          : bonusPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MembershipStatsModelImpl implements _MembershipStatsModel {
  const _$MembershipStatsModelImpl({this.totalSaved, this.bonusPoints});

  @override
  final int? totalSaved;
  @override
  final int? bonusPoints;

  @override
  String toString() {
    return 'MembershipStatsModel(totalSaved: $totalSaved, bonusPoints: $bonusPoints)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipStatsModelImpl &&
            (identical(other.totalSaved, totalSaved) ||
                other.totalSaved == totalSaved) &&
            (identical(other.bonusPoints, bonusPoints) ||
                other.bonusPoints == bonusPoints));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalSaved, bonusPoints);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipStatsModelImplCopyWith<_$MembershipStatsModelImpl>
      get copyWith =>
          __$$MembershipStatsModelImplCopyWithImpl<_$MembershipStatsModelImpl>(
              this, _$identity);
}

abstract class _MembershipStatsModel implements MembershipStatsModel {
  const factory _MembershipStatsModel(
      {final int? totalSaved,
      final int? bonusPoints}) = _$MembershipStatsModelImpl;

  @override
  int? get totalSaved;
  @override
  int? get bonusPoints;
  @override
  @JsonKey(ignore: true)
  _$$MembershipStatsModelImplCopyWith<_$MembershipStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
