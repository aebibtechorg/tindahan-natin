import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/notifications/models/announcement.dart';
import 'package:tindahan_natin/features/notifications/providers/announcement_service.dart';

class AnnouncementBanner extends ConsumerWidget {
  const AnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementServiceProvider);

    return announcementsAsync.when(
      data: (announcements) {
        debugPrint('AnnouncementBanner: Showing ${announcements.length} announcements');
        if (announcements.isEmpty) return const SizedBox.shrink();

        // Show the latest announcement
        final announcement = announcements.first;
        return _buildBanner(context, ref, announcement);
      },
      loading: () {
        debugPrint('AnnouncementBanner: Loading...');
        return const SizedBox.shrink();
      },
      error: (error, stack) {
        debugPrint('AnnouncementBanner: Error: $error');
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBanner(BuildContext context, WidgetRef ref, Announcement announcement) {
    Color backgroundColor;
    IconData icon;

    switch (announcement.type) {
      case 'warning':
      case 'maintenance':
        backgroundColor = Colors.orange.shade800;
        icon = Icons.warning_amber_rounded;
        break;
      case 'feature':
        backgroundColor = Colors.blue.shade800;
        icon = Icons.new_releases_rounded;
        break;
      default:
        backgroundColor = Theme.of(context).colorScheme.primary;
        icon = Icons.info_outline_rounded;
    }

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  announcement.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () {
              ref.read(announcementServiceProvider.notifier).dismissAnnouncement(announcement.id);
            },
          ),
        ],
      ),
    );
  }
}
