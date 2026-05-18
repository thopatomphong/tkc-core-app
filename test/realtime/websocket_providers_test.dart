import 'package:core_app/realtime/websocket_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('new email events records the received email id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(newEmailEventsProvider), isNull);

    container.read(newEmailEventsProvider.notifier).received(99);

    expect(container.read(newEmailEventsProvider), 99);
  });
}
