import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalLoadingProvider = NotifierProvider<GlobalLoadingController, int>(
  GlobalLoadingController.new,
);

final globalLoadingActiveProvider = Provider<bool>((ref) {
  return ref.watch(globalLoadingProvider) > 0;
});

class GlobalLoadingController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  bool get isLoading => state > 0;

  Future<T> runWithLoading<T>(Future<T> Function() callback) async {
    _increment();

    try {
      return await callback();
    } finally {
      _decrement();
    }
  }

  void _increment() {
    state = state + 1;
  }

  void _decrement() {
    state = state <= 1 ? 0 : state - 1;
  }
}
