// class UserDetails{
//
//   final String name;
//   final String phone;
//   final String email;
//   final String password;
//   final String uid;
//
//   UserDetails({
//     required this.name, required this.phone, required this.email, required this.password,
//     required this.uid
//   });
//
//
//   Map<String,dynamic> storeToFirebaseStore(){
//     return{
//       'name':name, 'phone number': phone, 'email':email, 'password': password, 'uid':uid,
//     };
//   }
//
//   factory UserDetails.fromMap(Map<String,dynamic> map){
//     //final map = doc.data();
//     return UserDetails(
//         name: map['name'], phone: map['phone number'],
//         email: map['email'], password: map['password']??'',
//         uid:map['uid']??'');
//   }
//
// }
