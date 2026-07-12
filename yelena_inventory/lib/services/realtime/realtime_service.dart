import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef RealtimeTableChangeCallback = void Function();

class RealtimeService {
  final SupabaseClient _client;
  final Map<String, RealtimeChannel> _channels = {};

  RealtimeService(this._client);

  RealtimeTableSubscription subscribeToTableChanges({
    required String channelName,
    required String schema,
    required String table,
    required RealtimeTableChangeCallback onChange,
  }) {
    if (_channels.containsKey(channelName)) {
      return RealtimeTableSubscription._(this, channelName);
    }

    final channel = _client.channel(channelName)
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: schema,
        table: table,
        callback: (_) {
          onChange();
        },
      );

    _channels[channelName] = channel;
    channel.subscribe((status, error) {
      if (error != null) {
        debugPrint('Realtime channel $channelName status $status: $error');
      }
    });

    return RealtimeTableSubscription._(this, channelName);
  }

  Future<void> unsubscribe(String channelName) async {
    final channel = _channels.remove(channelName);

    if (channel == null) {
      return;
    }

    await _client.removeChannel(channel);
  }

  void dispose() {
    final channelNames = List<String>.from(_channels.keys);

    for (final channelName in channelNames) {
      unawaited(unsubscribe(channelName));
    }
  }
}

class RealtimeTableSubscription {
  final RealtimeService _service;
  final String channelName;

  RealtimeTableSubscription._(this._service, this.channelName);

  Future<void> cancel() {
    return _service.unsubscribe(channelName);
  }
}
