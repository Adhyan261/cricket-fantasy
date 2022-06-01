import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class api
{
  late String url;
  api(this.url);
  Future getData() async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String _data = response.body;
        return jsonDecode(_data);
      }
      else {
        print(response.statusCode);
      }
    }
    catch (e) {
      print(e);
    }
  }
}
