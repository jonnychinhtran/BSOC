class InforUser {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? password;
  List<Roles>? roles;
  List<Books>? books;
  List<Chapters>? chapters;
  bool? active;

  InforUser(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.roles,
      this.books,
      this.chapters,
      this.active});

  InforUser.fromJson(Map<String, dynamic> json) {
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

  Books({this.id, this.bookName, this.author, this.description});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookName = json['bookName'];
    author = json['author'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookName'] = this.bookName;
    data['author'] = this.author;
    data['description'] = this.description;
    return data;
  }
}

class Chapters {
  int? id;
  String? chapterTitle;
  String? filePath;
  Books? book;

  Chapters({this.id, this.chapterTitle, this.filePath, this.book});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterTitle = json['chapterTitle'];
    filePath = json['filePath'];
    book = json['book'] != null ? new Books.fromJson(json['book']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chapterTitle'] = this.chapterTitle;
    data['filePath'] = this.filePath;
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    return data;
  }
}
