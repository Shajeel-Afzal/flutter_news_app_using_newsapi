class NewsModel {
  String? author;
  String title;
  String? description;
  String? url;
  String urlToImage;
  String? publishedAt;
  String? content;
  String source;

  NewsModel(
      {this.author,
      required this.title,
      this.description,
      this.url,
      required this.urlToImage,
      this.publishedAt,
      this.content,
      required this.source});
}
