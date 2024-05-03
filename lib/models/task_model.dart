// ignore_for_file: public_member_api_docs, sort_constructors_first

class Task {
  String title;
  DateTime timestamp;
  bool done;
  Task({
    required this.title,
    required this.timestamp,
    required this.done,
  });
  factory Task.fromMap(Map task) {
    return Task(
        title: task["title"], timestamp: task["timestamp"], done: task["done"]);
  }
  Map toMap() {
    return {
      "title": title,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
