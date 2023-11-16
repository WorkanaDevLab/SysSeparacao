import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  int? id;
  String? title;
  String? body;
  int? userId;

  Post(
      {this.id, this.title, this.body, this.userId});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

}
