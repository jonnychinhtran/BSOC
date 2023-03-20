class InforModel {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? password;
  List<Roles>? roles;
  List<Books>? books;
  List<Chapters>? chapters;
  String? avatar;
  String? fullname;
  bool? active;

  InforModel(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.roles,
      this.books,
      this.chapters,
      this.avatar,
      this.fullname,
      this.active});

  InforModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(new Chapters.fromJson(v));
      });
    }
    avatar = json['avatar'];
    fullname = json['fullname'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    if (this.chapters != null) {
      data['chapters'] = this.chapters!.map((v) => v.toJson()).toList();
    }
    data['avatar'] = this.avatar;
    data['fullname'] = this.fullname;
    data['active'] = this.active;
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Books {
  int? id;
  String? bookName;
  String? author;
  String? description;
  String? image;
  Null? rating;

  Books(
      {this.id,
      this.bookName,
      this.author,
      this.description,
      this.image,
      this.rating});

  Books.fromJson(Map<String, dynamic> json) {
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

class Chapters {
  int? id;
  int? chapterId;
  String? chapterTitle;
  String? filePath;
  Books? book;

  Chapters(
      {this.id, this.chapterId, this.chapterTitle, this.filePath, this.book});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterId = json['chapterId'];
    chapterTitle = json['chapterTitle'];
    filePath = json['filePath'];
    book = json['book'] != null ? new Books.fromJson(json['book']) : null;
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
