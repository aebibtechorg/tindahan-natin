import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/dashboard/dashboard_service.dart';
import 'package:tindahan_natin/features/lista/lista_service.dart';

import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/public_store/public_store_service.dart';
import 'package:tindahan_natin/features/notifications/models/announcement.dart';
import 'package:tindahan_natin/features/notifications/providers/announcement_service.dart';

part 'signalr_service.g.dart';

@riverpod
class RealtimeClient extends _$RealtimeClient {
  HubConnection? _connection;
  String? _currentStoreId;

  @override
  void build() {
    ref.onDispose(() {
      _connection?.stop();
    });
  }

  Future<void> connectGlobal() async {
    if (_connection?.state == HubConnectionState.Connected) {
      return;
    }

    if (_connection != null) {
      await _connection!.stop();
    }

    final baseUrl = ref.read(apiBaseUrlProvider);
    final hubUrl = '$baseUrl/hubs/tindahan';

    debugPrint('Connecting to SignalR Hub (Global): $hubUrl');

    _connection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .configureLogging(Logger('SignalR'))
        .build();

    _connection!.on('ReceiveAnnouncement', (arguments) {
      debugPrint('SignalR: ReceiveAnnouncement received');
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        final announcement = Announcement.fromJson(data);
        ref.read(announcementServiceProvider.notifier).addAnnouncement(announcement);
      }
    });

    try {
      await _connection!.start();
      debugPrint('SignalR: Connected (Global)');
    } catch (e) {
      debugPrint('SignalR Error: $e');
    }
  }

  Future<void> connect(String storeId) async {
    if (_connection?.state != HubConnectionState.Connected) {
      await connectGlobal();
    }

    if (_currentStoreId == storeId) return;

    if (_currentStoreId != null) {
      try {
        await _connection!.invoke('LeaveStoreGroup', args: [_currentStoreId!]);
      } catch (_) {}
    }

    _currentStoreId = storeId;

    _connection!.off('ListaUpdated');
    _connection!.off('InventoryUpdated');

    _connection!.on('ListaUpdated', (arguments) {
      debugPrint('SignalR: ListaUpdated received for store $storeId');
      _handleListaUpdated(storeId);
    });

    _connection!.on('InventoryUpdated', (arguments) {
      debugPrint('SignalR: InventoryUpdated received for store $storeId');
      _handleInventoryUpdated(storeId);
    });

    try {
      await _connection!.invoke('JoinStoreGroup', args: [storeId]);
      debugPrint('SignalR: Joined group $storeId');
    } catch (e) {
      debugPrint('SignalR Group Join Error: $e');
    }
  }

  void _handleListaUpdated(String storeId) {
    ref.invalidate(publicListaHistoryProvider(storeId));
    ref.invalidate(listaHistoryProvider(storeId));
    ref.invalidate(storeStatsProvider(storeId));
  }

  void _handleInventoryUpdated(String storeId) {
    ref.read(localStorageProvider).cacheProducts(storeId, []);
    ref.invalidate(productsProvider(storeId));
    ref.invalidate(publicProductSearchProvider(storeId, ''));
    ref.invalidate(storeStatsProvider(storeId));
  }
}
