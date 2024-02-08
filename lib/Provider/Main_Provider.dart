import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Model Class/MovieModel.dart';

class Main_Provider extends ChangeNotifier
{
  TextEditingController Movienamecontroller = TextEditingController();
  String url = "https://api.themoviedb.org/3/search/movie";
  String key = "b944d6eba2d3f434fdb9d98457345ae8";
  int page = 1;
  int CURRENT_page = 0;

  List<MoviePic> api_picList = [];

  Future get_api(String name, int pagecount) async
  {
    http.Response response;
    response = await http.get(Uri.parse("$url?api_key=$key&query=$name&page=$pagecount"));
    print(response.body);

    if (response.statusCode == 200)
    {
      api_picList.clear();
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      CURRENT_page = data['page'];

      api_picList = results.map((e) => MoviePic(
        title: e['title'],
        photo: e['poster_path'].toString(),)).toList();

      notifyListeners();
    }
    else
    {
      // If the server did not return a 200 OK response,then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}