// Unit tests for models, formatters and status-color logic. Pure logic with
// no widget tree — fast, deterministic coverage for the quality gate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/utils/formatters.dart';
import 'package:society_app/core/widgets/status_chip.dart';
import 'package:society_app/features/complaints/models/complaint.dart';
import 'package:society_app/features/family/models/family_member.dart';
import 'package:society_app/features/guests/models/guest.dart';
import 'package:society_app/features/notices/models/notice.dart';
import 'package:society_app/features/staff/models/staff_member.dart';
import 'package:society_app/features/vehicles/models/vehicle.dart';

void main() {
  group('formatRupees', () {
    test('groups thousands in the Indian format', () {
      expect(formatRupees(4850), '₹ 4,850');
      expect(formatRupees(0), '₹ 0');
      expect(formatRupees(125000), '₹ 1,25,000');
    });
  });

  group('StatusChip.colorForStatus', () {
    test('maps known statuses to semantic colors', () {
      expect(StatusChip.colorForStatus('Urgent'), AppColors.error);
      expect(StatusChip.colorForStatus('Completed'), AppColors.success);
      expect(StatusChip.colorForStatus('In Progress'), AppColors.warning);
      expect(StatusChip.colorForStatus('Submitted'), AppColors.primary);
      expect(StatusChip.colorForStatus('Events'), AppColors.accent);
    });

    test('is case-insensitive', () {
      expect(StatusChip.colorForStatus('present'), AppColors.success);
      expect(StatusChip.colorForStatus('ABSENT'), AppColors.error);
    });

    test('falls back to a neutral color for unknown statuses', () {
      expect(StatusChip.colorForStatus('Whatever'), AppColors.textSecondary);
    });
  });

  group('Notice', () {
    test('exposes a priority-specific icon', () {
      const notice = Notice(
        title: 't',
        description: 'd',
        priority: 'Urgent',
        date: 'x',
        author: 'a',
      );
      expect(notice.priorityIcon, Icons.warning_amber_rounded);
    });
  });

  group('Complaint', () {
    test('maps status to a tracking icon', () {
      const complaint = Complaint(
        id: 'C1',
        title: 't',
        description: 'd',
        category: 'Lift',
        status: 'Completed',
        date: 'x',
        icon: Icons.elevator,
      );
      expect(complaint.statusIcon, Icons.check_circle_outline);
    });
  });

  group('StaffMember', () {
    const present = StaffMember(
      name: 'A',
      role: 'Maid',
      phone: 'p',
      timings: 't',
      status: 'Present',
      icon: Icons.cleaning_services_outlined,
      daysPresent: 20,
      totalDays: 25,
    );

    test('isPresent reflects status', () {
      expect(present.isPresent, isTrue);
    });

    test('attendanceFraction is days/total and safe when total is zero', () {
      expect(present.attendanceFraction, 0.8);
      const none = StaffMember(
        name: 'B',
        role: 'Cook',
        phone: 'p',
        timings: 't',
        status: 'Absent',
        icon: Icons.kitchen,
        daysPresent: 0,
        totalDays: 0,
      );
      expect(none.attendanceFraction, 0);
    });
  });

  group('FamilyMember', () {
    test('derives kyc, phone and accent color from data', () {
      const self = FamilyMember(
        name: 'Rahul',
        relation: 'Self',
        age: 35,
        gender: 'Male',
        phone: '+91 99999 99999',
        kyc: 'Verified',
        avatar: 'R',
      );
      expect(self.isKycVerified, isTrue);
      expect(self.hasPhone, isTrue);
      expect(self.accentColor, AppColors.primary);

      const child = FamilyMember(
        name: 'Aryan',
        relation: 'Son',
        age: 8,
        gender: 'Male',
        phone: '—',
        kyc: 'Pending',
        avatar: 'A',
      );
      expect(child.isKycVerified, isFalse);
      expect(child.hasPhone, isFalse);
      expect(child.accentColor, AppColors.warning);
    });
  });

  group('Guest', () {
    test('detects a vehicle and computes an initial', () {
      const guest = Guest(
        name: 'ankit',
        relation: 'Friend',
        checkIn: 'i',
        checkOut: 'o',
        flat: '301',
        vehicleNo: 'MH12',
        status: 'Exited',
      );
      expect(guest.hasVehicle, isTrue);
      expect(guest.initial, 'A');
    });

    test('handles a missing vehicle', () {
      const guest = Guest(
        name: '',
        relation: 'x',
        checkIn: 'i',
        checkOut: 'o',
        flat: '301',
        vehicleNo: '—',
        status: 'Exited',
      );
      expect(guest.hasVehicle, isFalse);
      expect(guest.initial, '?');
    });
  });

  group('Vehicle', () {
    test('builds a display name from make and model', () {
      const vehicle = Vehicle(
        type: 'Car',
        make: 'Maruti',
        model: 'Swift',
        numberPlate: 'MH12AB1234',
        color: 'White',
        parkingSlot: 'B-14',
        icon: Icons.directions_car,
        accentColor: AppColors.primary,
      );
      expect(vehicle.displayName, 'Maruti Swift');
    });
  });
}
