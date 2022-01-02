class NoteModel{

  int? id;
  String? note;
  var completed;
  String? date;
  int? categoryId;

  NoteModel({this.id,this.note,this.completed,this.date,this.categoryId});

  factory NoteModel.fromjson(Map<String,dynamic> json)=>
      NoteModel(
        id: json['id'],
        note: json['note'],
        completed: json['completed'],
        date: json['date'],
        categoryId: json['categoryId'],
      );

  toJson() => {
    'id': id,
    'note':note,
    'completed':completed,
    'date':date,
    'categoryId':categoryId
  };

  toJsonCompletedNot() => {
    'id': id,
    'note':note,
    'date':date,
    'categoryId':categoryId
  };

}