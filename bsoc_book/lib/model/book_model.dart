class Book {
  String imageUrl;
  String title;
  String author;

  Book({
    required this.imageUrl,
    required this.title,
    required this.author,
  });
}

final List<Book> book = [
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/1LGtb6QljrmklbvIafU9WA/60f01dbc1e44037547d0104f8f56d812/image10.png?q=90&w=1646',
      title: 'The Personal MBA',
      author: 'Josh Kaufman'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/2TdKWPMKROmS7fvzizxL02/247a2a7f4fd66846c35aed531720aea1/image6.jpg?q=90&w=1646',
      title: 'Everybody Writes',
      author: 'Ann Handley'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/3Js6xghEhHq6BN7mMNhQv4/4418d6c69a9689a3a900281f60b7b5cc/image7.png?q=90&w=1646',
      title: 'The Art of Gathering',
      author: 'Priya Parker'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/5uasBCZnRHTlJVJHPkn2hs/288dd92edccd9e8e954bbf72a3b1be8c/image2.png?q=90&w=1646',
      title: 'DotCom Secrets',
      author: 'Russell Brunson'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/1SBU5hgMWJpRedTwaIRc2U/43d3545546aa6d1e752a64e6c088aa6c/image1.png?q=90&w=1646',
      title: 'Supermaker',
      author: 'Jaime Schmidt'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/7sBuLHEYDVqDv4tvsHRj5o/67cbdb000a81f56bf5faf6c764de2b99/image4.jpg?q=90&w=1646',
      title: 'Building a Story Brand',
      author: 'Donald Miller'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/1CQFelPTgCtZ5CGDkSt29a/36e79d81465e92c019cd818cd5c125ea/image3.png?q=90&w=1646',
      title: 'Atomic Habits',
      author: 'James Clear'),
  Book(
      imageUrl:
          'https://images.ctfassets.net/17o2epk8ivh7/3ad3YMuoQgutiwnpLwYdv5/cf3ba3d74d9fd6811ee25e81e0ec36e5/image5.png?q=90&w=1646',
      title: 'The 7 Habits of Highly Effective People',
      author: 'Stephen R. Covey'),
];
