import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tindahan_natin/core/network/connectivity_provider.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/notifications/models/announcement.dart';

part 'announcement_service.g.dart';

@riverpod
class AnnouncementService extends _$AnnouncementService {
  static const _dismissedKey = 'dismissed_announcements';
  static const _cacheKey = 'announcements_cache';

  @override
  FutureOr<List<Announcement>> build() async {
    final isOnline = ref.watch(isOnlineProvider);
    final box = await Hive.openBox('entity_cache');
    
    debugPrint('AnnouncementService: build(isOnline: $isOnline)');

    if (isOnline) {
      try {
        final dio = ref.read(dioClientProvider);
        debugPrint('AnnouncementService: Fetching from ${dio.options.baseUrl}/announcements');
        final response = await dio.get('/announcements');
        
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          final announcements = data.map((e) => Announcement.fromJson(e)).toList();
          debugPrint('AnnouncementService: Fetched ${announcements.length} announcements');
          
          // Cache to Hive
          await box.put(_cacheKey, data);
          
          final filtered = await _filterDismissed(announcements);
          debugPrint('AnnouncementService: ${filtered.length} announcements after filtering dismissed');
          return filtered;
        }
      } catch (e) {
        debugPrint('AnnouncementService: Error fetching announcements: $e');
      }
    }

    // Offline or error: load from cache
    final cachedData = box.get(_cacheKey);
    if (cachedData != null && cachedData is List) {
      final announcements = cachedData.map((e) => Announcement.fromJson(Map<String, dynamic>.from(e))).toList();
      debugPrint('AnnouncementService: Loaded ${announcements.length} from cache');
      return _filterDismissed(announcements);
    }
    
    debugPrint('AnnouncementService: No announcements found');
    return [];
  }

  Future<List<Announcement>> _filterDismissed(List<Announcement> announcements) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedKey) ?? [];
    return announcements.where((a) => !dismissedIds.contains(a.id)).toList();
  }

  void addAnnouncement(Announcement announcement) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedKey) ?? [];
    
    if (dismissedIds.contains(announcement.id)) return;

    state.whenData((announcements) {
      if (announcements.any((a) => a.id == announcement.id)) return;
      state = AsyncData([announcement, ...announcements]);
    });
  }

  Future<void> dismissAnnouncement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedKey) ?? [];
    
    if (!dismissedIds.contains(id)) {
      await prefs.setStringList(_dismissedKey, [...dismissedIds, id]);
    }

    state.whenData((announcements) {
      state = AsyncData(announcements.where((a) => a.id != id).toList());
    });
  }
}
