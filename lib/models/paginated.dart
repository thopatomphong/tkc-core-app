/// The mock server returns list endpoints as { total, data: [...] }.
class Paginated<T> {
  const Paginated({required this.total, required this.items});

  final int total;
  final List<T> items;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final raw = (json['data'] as List<dynamic>? ?? <dynamic>[]);
    return Paginated<T>(
      total: json['total'] as int? ?? raw.length,
      items: raw
          .map((dynamic e) => fromItem(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
