class LivenessUrlModel {
  final String? userLandingUrl;

  LivenessUrlModel({this.userLandingUrl});

  static LivenessUrlModel fromJson(Map<String, dynamic> json) =>
      LivenessUrlModel(
        userLandingUrl: json['user_landing_url'],
      );

  Map<String, dynamic> toJson() => {
        'user_landing_url': userLandingUrl,
      };
}
