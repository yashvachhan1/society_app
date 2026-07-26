// Unit tests for the domain models that mirror the database schema. Pure
// logic, no widget tree — fast, deterministic coverage for the quality gate.

import 'package:flutter_test/flutter_test.dart';
import 'package:society_app/core/data/demo_data.dart';
import 'package:society_app/core/models/models.dart';
import 'package:society_app/core/utils/formatters.dart';

void main() {
  group('formatRupees', () {
    test('groups thousands in the Indian format', () {
      expect(formatRupees(4850), '₹ 4,850');
      expect(formatRupees(0), '₹ 0');
      expect(formatRupees(125000), '₹ 1,25,000');
    });
  });

  group('AppUser', () {
    test('initials use the first and last name', () {
      const user = AppUser(phone: '+91 90000 00000', name: 'Rahul Sharma');
      expect(user.initials, 'RS');
    });

    test('initials fall back for one word and empty names', () {
      expect(const AppUser(phone: 'p', name: 'Rahul').initials, 'R');
      expect(const AppUser(phone: 'p', name: '').initials, '?');
    });

    test('hasEmail is false for null and blank values', () {
      const none = AppUser(phone: 'p', name: 'A');
      const blank = AppUser(phone: 'p', name: 'A', email: '  ');
      const some = AppUser(phone: 'p', name: 'A', email: 'a@b.com');
      expect(none.hasEmail, isFalse);
      expect(blank.hasEmail, isFalse);
      expect(some.hasEmail, isTrue);
    });

    test('copyWith replaces only what it is given', () {
      const user = AppUser(phone: 'p', name: 'Old', email: 'a@b.com');
      final updated = user.copyWith(name: 'New');
      expect(updated.name, 'New');
      expect(updated.email, 'a@b.com');
      expect(updated.phone, 'p');
    });

    test('language defaults to English', () {
      expect(const AppUser(phone: 'p', name: 'A').language, AppLanguage.en);
      expect(AppLanguage.hi.code, 'hi');
      expect(AppLanguage.mr.nativeLabel, 'मराठी');
    });
  });

  group('Membership', () {
    test('status helpers reflect the enum', () {
      const pending = Membership(societyId: 1, role: MembershipRole.owner);
      const active = Membership(
        societyId: 1,
        role: MembershipRole.owner,
        status: MembershipStatus.active,
      );
      expect(pending.isPending, isTrue);
      expect(pending.isActive, isFalse);
      expect(active.isActive, isTrue);
    });

    test('owners and tenants are residents, committee roles are not', () {
      const owner = Membership(societyId: 1, role: MembershipRole.owner);
      const tenant = Membership(societyId: 1, role: MembershipRole.tenant);
      const treasurer = Membership(societyId: 1, role: MembershipRole.treasurer);
      expect(owner.isResident, isTrue);
      expect(tenant.isResident, isTrue);
      expect(treasurer.isResident, isFalse);
    });
  });

  group('Unit and Society', () {
    test('unit label combines the wing letter and unit number', () {
      const tower = Tower(id: 1, name: 'A Wing');
      const unit = Unit(
        id: 1,
        towerId: 1,
        floor: 4,
        unitNo: '402',
        unitType: '2BHK',
        areaSqft: 985,
        parkingSlots: 1,
      );
      expect(unit.labelWith(tower), 'A-402');
    });

    test('society builds short and full address lines', () {
      const society = Society(
        id: 1,
        name: 'Sunrise Residency',
        registrationNo: 'R-1',
        address: 'Kothrud',
        city: 'Pune',
        state: 'Maharashtra',
        pincode: '411038',
      );
      expect(society.shortLocation, 'Kothrud, Pune');
      expect(society.fullAddress, 'Kothrud, Pune, Maharashtra - 411038');
    });
  });

  group('DemoData', () {
    test('the signed-in resident is wired to a real society and unit', () {
      expect(DemoData.currentMembership.isActive, isTrue);
      expect(DemoData.currentMembership.unitId, DemoData.currentUnit.id);
      expect(DemoData.currentTower.id, DemoData.currentUnit.towerId);
      expect(DemoData.currentSociety.id, DemoData.currentMembership.societyId);
    });

    test('every demo unit belongs to a known tower', () {
      final towerIds = DemoData.towers.map((t) => t.id).toSet();
      for (final unit in DemoData.units) {
        expect(towerIds, contains(unit.towerId));
      }
    });
  });
}
