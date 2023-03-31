class AllBookModel {
  int? id;
  String? bookName;
  String? author;
  String? description;
  String? image;
  double? rating;

  AllBookModel(
      {this.id,
      this.bookName,
      this.author,
      this.description,
      this.image,
      this.rating});

  AllBookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookName = json['bookName'];
    author = json['author'];
    description = json['description'];
    image = json['image'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookName'] = this.bookName;
    data['author'] = this.author;
    data['description'] = this.description;
    data['image'] = this.image;
    data['rating'] = this.rating;
    return data;
  }
}
