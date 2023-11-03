// class bookDetails {
//   int? id;
//   String? bookName;
//   String? author;
//   String? description;
//   String? image;
//   List<Chapters>? chapters;
//   double? rating;

//   bookDetails(
//       {this.id,
//       this.bookName,
//       this.author,
//       this.description,
//       this.image,
//       this.chapters,
//       this.rating});

//   bookDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     bookName = json['bookName'];
//     author = json['author'];
//     description = json['description'];
//     image = json['image'];
//     if (json['chapters'] != null) {
//       chapters = <Chapters>[];
//       json['chapters'].forEach((v) {
//         chapters!.add(new Chapters.fromJson(v));
//       });
//     }
//     rating = json['rating'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['bookName'] = this.bookName;
//     data['author'] = this.author;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     if (this.chapters != null) {
//       data['chapters'] = this.chapters!.map((v) => v.toJson()).toList();
//     }
//     data['rating'] = this.rating;
//     return data;
//   }
// }

// class Chapters {
//   int? id;
//   int? chapterId;
//   String? chapterTitle;
//   String? filePath;
//   bool? first;
//   bool? last;
//   bool? downloaded;

//   Chapters(
//       {this.id,
//       this.chapterId,
//       this.chapterTitle,
//       this.filePath,
//       this.first,
//       this.last,
//       this.downloaded});

//   Chapters.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     chapterId = json['chapterId'];
//     chapterTitle = json['chapterTitle'];
//     filePath = json['filePath'];
//     first = json['first'];
//     last = json['last'];
//     downloaded = json['downloaded'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['chapterId'] = this.chapterId;
//     data['chapterTitle'] = this.chapterTitle;
//     data['filePath'] = this.filePath;
//     data['first'] = this.first;
//     data['last'] = this.last;
//     data['downloaded'] = this.downloaded;
//     return data;
//   }
// }
