import 'package:core_app/core/env/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('apiBaseUrl ends with port 3000 and has no trailing slash', () {
    expect(Env.apiBaseUrl.endsWith(':3000'), isTrue);
    expect(Env.apiBaseUrl.endsWith('/'), isFalse);
  });

  test('wsUrl points at the /ws namespace', () {
    expect(Env.wsUrl.endsWith('/ws'), isTrue);
  });
}
