class PostResult {
  final Map<String, dynamic> twitter;
  final Map<String, dynamic> telegram;
  final Map<String, dynamic>? productData;

  PostResult({
    required this.twitter,
    required this.telegram,
    this.productData,
  });

  factory PostResult.fromJson(Map<String, dynamic> json) {
    return PostResult(
      twitter: json['twitter'] ?? {},
      telegram: json['telegram'] ?? {},
      productData: json['productData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'twitter': twitter,
      'telegram': telegram,
      if (productData != null) 'productData': productData,
    };
  }
}
