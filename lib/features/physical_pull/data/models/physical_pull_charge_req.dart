class PhysicalPullChargeReq {
  final int? goldFragmentId;
  final double? goldFragment;
  final int? qty;

  PhysicalPullChargeReq({
    this.goldFragmentId,
    this.goldFragment,
    this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      "gold_fragment_id": goldFragmentId,
      "gold_fragment": goldFragment,
      "qty": qty,
    };
  }

  PhysicalPullChargeReq copyWith({
    int? goldFragmentId,
    double? goldFragment,
    int? qty,
  }) =>
      PhysicalPullChargeReq(
        goldFragmentId: goldFragmentId ?? this.goldFragmentId,
        goldFragment: goldFragment ?? this.goldFragment,
        qty: qty ?? this.qty,
      );
}
