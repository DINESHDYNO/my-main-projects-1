class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'], name: json['name']);
  }
}


// class RegisterScreen extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Future<void> register() async {
//     final String name = nameController.text;
//     final String email = emailController.text;
//     final String password = passwordController.text;
//
//     final response = await http.post(
//       Uri.parse('http://172.23.112.1:3000/register'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'name': name,
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       print('User registered successfully');
//     } else {
//       print('Failed to register user');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextFormField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: register,
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
