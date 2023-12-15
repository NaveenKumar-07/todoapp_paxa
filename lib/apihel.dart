import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todom.dart';
import 'userm.dart';

class AuthService {
  

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/todos/user/$userId'));
    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body)['todos'];
      return jsonList.map((model) => Todo.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> addTodos(Todo todo) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/todos/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      print("REsponseeee ${response.body.toString()} ${response.statusCode}");
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Todo.fromJson(json);
    } else {
      throw Exception('Failed to login');
    }
  }

}
