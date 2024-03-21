import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'top_banner_model.freezed.dart';

@freezed
class TopBannerModel with _$TopBannerModel {
  const factory TopBannerModel({
    required String title,
    required String description,
    required String image,
    ProviderListenable<Color>? color,
  }) = _TopBannerModel;
}
