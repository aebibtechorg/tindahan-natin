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

  Future<void> connect(String storeId) async {
    if (_connection?.state == HubConnectionState.Connected && _currentStoreId == storeId) {
      return;
    }

    if (_connection != null) {
      await _connection!.stop();
    }

    _currentStoreId = storeId;
    final baseUrl = ref.read(apiBaseUrlProvider);
    final hubUrl = '$baseUrl/hubs/tindahan';

    debugPrint('Connecting to SignalR Hub: $hubUrl');

    _connection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .configureLogging(Logger('SignalR'))
        .build();

    _connection!.on('ListaUpdated', (arguments) {
      debugPrint('SignalR: ListaUpdated received for store $storeId');
      _handleListaUpdated(storeId);
    });

    _connection!.on('InventoryUpdated', (arguments) {
      debugPrint('SignalR: InventoryUpdated received for store $storeId');
      _handleInventoryUpdated(storeId);
    });

    try {
      await _connection!.start();
      await _connection!.invoke('JoinStoreGroup', args: [storeId]);
      debugPrint('SignalR: Connected and joined group $storeId');
    } catch (e) {
      debugPrint('SignalR Error: $e');
    }
  }

  void _handleListaUpdated(String storeId) {
    // Invalidate relevant providers to trigger refresh
    ref.invalidate(publicListaHistoryProvider(storeId));
    ref.invalidate(listaHistoryProvider(storeId));
    ref.invalidate(storeStatsProvider(storeId));
  }

  void _handleInventoryUpdated(String storeId) {
    // Clear local cache for products
    ref.read(localStorageProvider).cacheProducts(storeId, []);
    
    // Invalidate providers
    ref.invalidate(productsProvider(storeId));
    ref.invalidate(publicProductSearchProvider(storeId, '')); // Assuming empty query for general search provider
    
    // Also might affect dashboard stats (top products)
    ref.invalidate(storeStatsProvider(storeId));
  }
}
