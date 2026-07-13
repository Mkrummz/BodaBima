import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bima/services/offline_service.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  List<Map<String, dynamic>> plans(List<String> names) {
    return [
      for (final name in names)
        {
          'plan_name': name,
          'description': 'desc $name',
          'coverage_amount': 'KES 1,000',
          'monthly_premium': 'KES 100',
        }
    ];
  }

  group('OfflineService', () {
    late OfflineService service;

    setUp(() {
      service = OfflineService();
    });

    test('initDB creates the expected tables', () async {
      final db = await service.initDB();
      addTearDown(db.close);

      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'");
      final names = tables.map((row) => row['name']).toSet();

      expect(names, containsAll(['insurance_plans', 'pending_transactions']));
    });

    test('saveInsurancePlans inserts rows and getOfflinePlans reads them back',
        () async {
      await service.saveInsurancePlans(plans(['A', 'B']), 'medical');

      final stored = await service.getOfflinePlans('medical');
      expect(stored, hasLength(2));
      expect(stored.map((p) => p['plan_name']), containsAll(['A', 'B']));
      expect(stored.first['type'], 'medical');
      expect(stored.first['last_synced'], isNotNull);
    });

    test('saveInsurancePlans clears existing rows of the same type only',
        () async {
      await service.saveInsurancePlans(plans(['old1', 'old2']), 'motor');
      await service.saveInsurancePlans(plans(['home1']), 'home');

      await service.saveInsurancePlans(plans(['new1']), 'motor');

      final motor = await service.getOfflinePlans('motor');
      final home = await service.getOfflinePlans('home');

      expect(motor.map((p) => p['plan_name']), ['new1']);
      expect(home.map((p) => p['plan_name']), ['home1']);
    });

    test('getOfflinePlans returns an empty list for an unknown type', () async {
      final result = await service.getOfflinePlans('travel');
      expect(result, isEmpty);
    });
  });
}
