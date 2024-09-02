class LakusaveCheckoutReq {
  final int? durationId;
  final int? extendedId;
  final double? goldWeight;
  final String? accountNumber;
  final String? accountNumberDest;

  LakusaveCheckoutReq({
    required this.durationId,
    required this.extendedId,
    required this.goldWeight,
    required this.accountNumber,
    required this.accountNumberDest,
  });

  Map<String, dynamic> toJson() => {
        'duration_id': durationId,
        'extend_id': extendedId,
        'gold_weight': goldWeight,
        'account_number': accountNumber,
        'account_number_dest': accountNumberDest,
      };
}
