class Voucher {
  final String code;
  final String title;
  final String description;
  final String tag;
  final double discountAmount;
  final bool isPercentage;
  final double minSpend;
  final bool isCopied;

  const Voucher({
    required this.code,
    required this.title,
    required this.description,
    required this.tag,
    required this.discountAmount,
    this.isPercentage = true,
    this.minSpend = 15.0,
    this.isCopied = false,
  });

  static const List<Voucher> sampleVouchers = [
    Voucher(
      code: 'TREAT50',
      title: '50% Off First Treat',
      description: 'Min spend \$15 • All Bakeries',
      tag: 'HOT',
      discountAmount: 50.0,
      isPercentage: true,
      minSpend: 15.0,
    ),
    Voucher(
      code: 'WEEKENDVIBE',
      title: '\$20 Weekend Chill',
      description: 'Table of 3+ • Drink Lounges',
      tag: 'NEW',
      discountAmount: 20.0,
      isPercentage: false,
      minSpend: 50.0,
    ),
    Voucher(
      code: 'SWEETPOT',
      title: 'Free Donut Drops',
      description: 'Group BOGO Pot Unlock',
      tag: 'BOOST',
      discountAmount: 100.0,
      isPercentage: true,
      minSpend: 25.0,
    ),
  ];
}
