// class Infor {
//   int? id;
//   String? username;
//   String? email;
//   String? phone;
//   List<Roles>? roles;
//   List<Books>? books;
//   List<Chapters>? chapters;
//   bool? active;

//   Infor(
//       {this.id,
//       this.username,
//       this.email,
//       this.phone,
//       this.roles,
//       this.books,
//       this.chapters,
//       this.active});

//   Infor.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     phone = json['phone'];
//     if (json['roles'] != null) {
//       roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(new Roles.fromJson(v));
//       });
//     }
//     if (json['books'] != null) {
//       books = <Books>[];
//       json['books'].forEach((v) {
//         books!.add(new Books.fromJson(v));
//       });
//     }
//     if (json['chapters'] != null) {
//       chapters = <Chapters>[];
//       json['chapters'].forEach((v) {
//         chapters!.add(new Chapters.fromJson(v));
//       });
//     }
//     active = json['active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     if (this.roles != null) {
//       data['roles'] = this.roles!.map((v) => v.toJson()).toList();
//     }
//     if (this.books != null) {
//       data['books'] = this.books!.map((v) => v.toJson()).toList();
//     }
//     if (this.chapters != null) {
//       data['chapters'] = this.chapters!.map((v) => v.toJson()).toList();
//     }
//     data['active'] = this.active;
//     return data;
//   }

//   void add(Infor infor) {}
// }

// class Roles {
//   int? id;
//   String? name;

//   Roles({this.id, this.name});

//   Roles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

// class Books {
//   int? id;
//   String? bookName;
//   String? author;
//   String? description;
//   List<Chapters>? chapters;

//   Books({this.id, this.bookName, this.author, this.description, this.chapters});

//   Books.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     bookName = json['bookName'];
//     author = json['author'];
//     description = json['description'];
//     if (json['chapters'] != null) {
//       chapters = <Chapters>[];
//       json['chapters'].forEach((v) {
//         chapters!.add(new Chapters.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['bookName'] = this.bookName;
//     data['author'] = this.author;
//     data['description'] = this.description;
//     if (this.chapters != null) {
//       data['chapters'] = this.chapters!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Chapters {
//   int? id;
//   String? chapterTitle;
//   String? filePath;
//   String? book;

//   Chapters({this.id, this.chapterTitle, this.filePath, this.book});

//   Chapters.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     chapterTitle = json['chapterTitle'];
//     filePath = json['filePath'];
//     book = json['book'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['chapterTitle'] = this.chapterTitle;
//     data['filePath'] = this.filePath;
//     data['book'] = this.book;
//     return data;
//   }
// }
