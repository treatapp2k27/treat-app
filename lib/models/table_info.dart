enum TableStatus {
  free,
  dining,
  reserved,
  cleaning,
}

class TableInfo {
  final String id;
  final String name; // e.g. Table P-01
  final String area; // 'Main Hall', 'Outdoor Patio', 'Bar Counter'
  final int capacity;
  final TableStatus status;
  final String? activeReservationCode;

  const TableInfo({
    required this.id,
    required this.name,
    required this.area,
    required this.capacity,
    required this.status,
    this.activeReservationCode,
  });

  TableInfo copyWith({
    String? id,
    String? name,
    String? area,
    int? capacity,
    TableStatus? status,
    String? activeReservationCode,
  }) {
    return TableInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      activeReservationCode: activeReservationCode ?? this.activeReservationCode,
    );
  }

  static const List<TableInfo> initialTables = [
    TableInfo(id: 't-1', name: 'Table P-01', area: 'Outdoor Patio', capacity: 4, status: TableStatus.reserved, activeReservationCode: '#TR-88219'),
    TableInfo(id: 't-2', name: 'Table P-02', area: 'Outdoor Patio', capacity: 4, status: TableStatus.free),
    TableInfo(id: 't-3', name: 'Table P-03', area: 'Outdoor Patio', capacity: 2, status: TableStatus.dining),
    TableInfo(id: 't-4', name: 'Table P-04', area: 'Outdoor Patio', capacity: 6, status: TableStatus.free),
    TableInfo(id: 't-5', name: 'Table M-01', area: 'Main Hall', capacity: 4, status: TableStatus.free),
    TableInfo(id: 't-6', name: 'Table M-02', area: 'Main Hall', capacity: 4, status: TableStatus.dining),
    TableInfo(id: 't-7', name: 'Table M-03', area: 'Main Hall', capacity: 2, status: TableStatus.free),
    TableInfo(id: 't-8', name: 'Table M-04', area: 'Main Hall', capacity: 8, status: TableStatus.free),
    TableInfo(id: 't-9', name: 'Table M-05', area: 'Main Hall', capacity: 4, status: TableStatus.cleaning),
    TableInfo(id: 't-10', name: 'Bar Stool 1-4', area: 'Bar Counter', capacity: 4, status: TableStatus.free),
    TableInfo(id: 't-11', name: 'Bar Stool 5-8', area: 'Bar Counter', capacity: 4, status: TableStatus.dining),
  ];
}
