class UpdateAddressEntity {
  final int? districtId;

  /// [type] is between 'home' and 'mailing'
  final String? type;
  final String? address;
  final String? postalCode;

  UpdateAddressEntity(
      {this.districtId, this.type, this.address, this.postalCode});
}
