import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'lista_settings.g.dart';

@riverpod
class ListaStaffName extends _$ListaStaffName {
  static const _key = 'lista_staff_name';

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> set(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
    state = AsyncData(name);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const AsyncData(null);
  }
}
