import 'package:core_app/models/paginated.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('map converts item type preserving total and order', () {
    final page = Paginated<int>(total: 5, items: [1, 2, 3]);
    final mapped = page.map((n) => n * 10);
    expect(mapped.total, 5);
    expect(mapped.items, [10, 20, 30]);
  });
}
