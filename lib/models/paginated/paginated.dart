// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated.freezed.dart';
part 'paginated.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class Paginated<T> with _$Paginated<T> {
  const factory Paginated({
    @JsonKey(name: 'data') final T? dataList,
    @JsonKey(name: 'current_page') @Default(0) final int currentPage,
    @JsonKey(name: 'last_page') @Default(0) final int lastPage,
    @JsonKey(name: 'per_page') @Default(0) final int perPage,
    @Default(0) final int total,
  }) = _Paginated;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginatedFromJson(json, fromJsonT);
}
