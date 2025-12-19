class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromApiJson(Map<String, dynamic> json) {
    return Quote(
      text: (json['q'] ?? '').toString(),
      author: (json['a'] ?? 'Unknown').toString(),
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: (json['text'] ?? '').toString(),
      author: (json['author'] ?? 'Unknown').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'author': author};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.text == text && other.author == author;
  }

  @override
  int get hashCode => Object.hash(text, author);
}
