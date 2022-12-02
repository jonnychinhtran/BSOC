class AddBookmarkModel {
  int? id;
  Chapter? chapter;

  AddBookmarkModel({this.id, this.chapter});

  AddBookmarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapter =
        json['chapter'] != null ? new Chapter.fromJson(json['chapter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.chapter != null) {
      data['chapter'] = this.chapter!.toJson();
    }
    return data;
  }
}

class Chapter {
  int? id;
  int? chapterId;
  String? chapterTitle;
  String? filePath;
  Book? book;

  Chapter(
      {this.id, this.chapterId, this.chapterTitle, this.filePath, this.book});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterId = json['chapterId'];
    chapterTitle = json['chapterTitle'];
    filePath = json['filePath'];
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chapterId'] = this.chapterId;
    data['chapterTitle'] = this.chapterTitle;
    data['filePath'] = this.filePath;
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    return data;
  }
}

class Book {
  int? id;
  String? bookName;
  String? author;
  String? description;
  String? image;
  int? rating;

  Book(
      {this.id,
      this.bookName,
      this.author,
      this.description,
      this.image,
      this.rating});

  Book.fromJson(Map<String, dynamic> json) {
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
