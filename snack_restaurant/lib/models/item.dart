class Item {
  String id;
  final String title;
  final String description;
  final int price;
  final String imgLink;

  Item({
    this.id = '',
    required this.title,
    this.description = '',
    required this.price,
    this.imgLink = '',
  });

  @override
  String toString() {
    return 'Item(id: $id ,title: $title, subTitle: $description, price: $price, imgLink: $imgLink)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imgLink': imgLink,
    };
  }

  static Item fromJson(Map<String, dynamic> json) => Item(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        imgLink: json['imgLink'],
      );
}
