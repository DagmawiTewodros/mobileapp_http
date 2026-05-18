class NoteModel {
  final int? id;
  final String title;
  final String body;
  final int? userId;

  NoteModel({
    this.id,
    required this.title,
    required this.body,
    this.userId = 1,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId ?? 1,
    };
  }
}