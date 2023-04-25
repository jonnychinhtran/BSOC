// class BookModel {
//   List<Content>? content;
//   Pageable? pageable;
//   bool? last;
//   int? totalElements;
//   int? totalPages;
//   int? size;
//   int? number;
//   Sort? sort;
//   bool? first;
//   int? numberOfElements;
//   bool? empty;

//   BookModel(
//       {this.content,
//       this.pageable,
//       this.last,
//       this.totalElements,
//       this.totalPages,
//       this.size,
//       this.number,
//       this.sort,
//       this.first,
//       this.numberOfElements,
//       this.empty});

//   BookModel.fromJson(Map<String, dynamic> json) {
//     if (json['content'] != null) {
//       content = <Content>[];
//       json['content'].forEach((v) {
//         content!.add(new Content.fromJson(v));
//       });
//     }
//     pageable = json['pageable'] != null
//         ? new Pageable.fromJson(json['pageable'])
//         : null;
//     last = json['last'];
//     totalElements = json['totalElements'];
//     totalPages = json['totalPages'];
//     size = json['size'];
//     number = json['number'];
//     sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
//     first = json['first'];
//     numberOfElements = json['numberOfElements'];
//     empty = json['empty'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.content != null) {
//       data['content'] = this.content!.map((v) => v.toJson()).toList();
//     }
//     if (this.pageable != null) {
//       data['pageable'] = this.pageable!.toJson();
//     }
//     data['last'] = this.last;
//     data['totalElements'] = this.totalElements;
//     data['totalPages'] = this.totalPages;
//     data['size'] = this.size;
//     data['number'] = this.number;
//     if (this.sort != null) {
//       data['sort'] = this.sort!.toJson();
//     }
//     data['first'] = this.first;
//     data['numberOfElements'] = this.numberOfElements;
//     data['empty'] = this.empty;
//     return data;
//   }
// }

class Content {
  int? id;
  String? bookName;
  String? author;
  String? description;
  String? image;
  double? rating;

  Content(
      {this.id,
      this.bookName,
      this.author,
      this.description,
      this.image,
      this.rating});

  Content.fromJson(Map<String, dynamic> json) {
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

// class Pageable {
//   Sort? sort;
//   int? offset;
//   int? pageNumber;
//   int? pageSize;
//   bool? paged;
//   bool? unpaged;

//   Pageable(
//       {this.sort,
//       this.offset,
//       this.pageNumber,
//       this.pageSize,
//       this.paged,
//       this.unpaged});

//   Pageable.fromJson(Map<String, dynamic> json) {
//     sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
//     offset = json['offset'];
//     pageNumber = json['pageNumber'];
//     pageSize = json['pageSize'];
//     paged = json['paged'];
//     unpaged = json['unpaged'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.sort != null) {
//       data['sort'] = this.sort!.toJson();
//     }
//     data['offset'] = this.offset;
//     data['pageNumber'] = this.pageNumber;
//     data['pageSize'] = this.pageSize;
//     data['paged'] = this.paged;
//     data['unpaged'] = this.unpaged;
//     return data;
//   }
// }

// class Sort {
//   bool? empty;
//   bool? unsorted;
//   bool? sorted;

//   Sort({this.empty, this.unsorted, this.sorted});

//   Sort.fromJson(Map<String, dynamic> json) {
//     empty = json['empty'];
//     unsorted = json['unsorted'];
//     sorted = json['sorted'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['empty'] = this.empty;
//     data['unsorted'] = this.unsorted;
//     data['sorted'] = this.sorted;
//     return data;
//   }
// }
