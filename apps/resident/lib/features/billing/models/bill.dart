/// A single charge line on the monthly maintenance bill.
class BillItem {
  const BillItem({required this.label, required this.amount});

  final String label;
  final int amount;
}

/// A completed maintenance payment shown in the history list.
class Payment {
  const Payment({
    required this.month,
    required this.amount,
    required this.date,
    required this.status,
  });

  final String month;
  final int amount;
  final String date;
  final String status;
}
