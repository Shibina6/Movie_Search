
import 'dart:convert';

List<MoviePic> apiModelFromJson(String str) => List<MoviePic>.from(json.decode(str).map((x) => MoviePic.fromJson(x)));



class MoviePic
{
  String title;
  String photo;
  MoviePic({required this.photo,required this.title});

  factory MoviePic.fromJson(Map<String, dynamic> json) => MoviePic(
    title: json["title"],
    photo: json["poster_path"],

  );
}