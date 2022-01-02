class CategoryModel{

  int? id;
  String? category;

  CategoryModel({this.id,this.category});

  factory CategoryModel.fromjson(Map<String,dynamic> json)=>
      CategoryModel(
        id: json['id'],
        category: json['category'],
      );

  toJson() => {
    'id': id,
    'category':category
  };

}