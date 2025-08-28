class Task {
  int id; 
  String title;
  String? description;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted ? 1 : 0,
    'dueDate': dueDate?.toIso8601String(),
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    isCompleted: map['isCompleted'] == 1,
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
  );
}
