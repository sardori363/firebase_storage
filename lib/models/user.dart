class PostModel{
  String? id;
  late String name;
  late String email;
  String? createdTime;
  String? img;


  PostModel({this.id, required this.name, required this.email, this.createdTime, this.img});

  PostModel.fromJson(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    email = json["email"];
    createdTime = json["createdTime"];
    img = json["img"];
  }

  Map<String, dynamic> toJson(){
    return {
      "id":id,
      "name":name,
      "email":email,
      "createdTime":createdTime,
      "img":img,
    };
  }

}