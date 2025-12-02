class Product {
  final String title;
  final String price;
  final String? imageUrl;
  final String url;
  final String site;

  Product({
    required this.title,
    required this.price,
    this.imageUrl,
    required this.url,
    required this.site,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'],
      url: json['url'] ?? '',
      site: json['site'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'url': url,
      'site': site,
    };
  }
}
