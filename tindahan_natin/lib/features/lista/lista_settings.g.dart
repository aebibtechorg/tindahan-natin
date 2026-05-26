// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ListaStaffName)
final listaStaffNameProvider = ListaStaffNameProvider._();

final class ListaStaffNameProvider
    extends $AsyncNotifierProvider<ListaStaffName, String?> {
  ListaStaffNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaStaffNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaStaffNameHash();

  @$internal
  @override
  ListaStaffName create() => ListaStaffName();
}

String _$listaStaffNameHash() => r'cb8151619ec192bf9ea06a1ba7c8fad49de12c85';

abstract class _$ListaStaffName extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
