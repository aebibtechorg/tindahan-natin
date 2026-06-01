// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnnouncementService)
final announcementServiceProvider = AnnouncementServiceProvider._();

final class AnnouncementServiceProvider
    extends $AsyncNotifierProvider<AnnouncementService, List<Announcement>> {
  AnnouncementServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementServiceHash();

  @$internal
  @override
  AnnouncementService create() => AnnouncementService();
}

String _$announcementServiceHash() =>
    r'5ac55babbab7b86f491cc659e245b4dbf0aa19db';

abstract class _$AnnouncementService
    extends $AsyncNotifier<List<Announcement>> {
  FutureOr<List<Announcement>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Announcement>>, List<Announcement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Announcement>>, List<Announcement>>,
              AsyncValue<List<Announcement>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
