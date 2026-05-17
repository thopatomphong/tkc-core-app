import 'package:core_app/core/utils/time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatRelativeTime returns correct strings', () {
    final now = DateTime.now();
    expect(formatRelativeTime(now.subtract(const Duration(seconds: 30))), 'Just now');
    expect(formatRelativeTime(now.subtract(const Duration(minutes: 2))), '2m ago');
    expect(formatRelativeTime(now.subtract(const Duration(hours: 1))), '1h ago');
    expect(formatRelativeTime(now.subtract(const Duration(days: 2))), '2d ago');
  });
}
