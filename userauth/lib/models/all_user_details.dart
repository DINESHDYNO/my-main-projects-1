class AllUserData {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  int? iV;

  AllUserData(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.phone,
        this.image,
        this.iV});

  AllUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    image = json['image'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['__v'] = this.iV;
    return data;
  }
}
