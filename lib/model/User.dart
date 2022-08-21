class Users{


  late String id,name,dob,email,phone,gender;

  Users(this.id, this.name, this.dob, this.email, this.phone, this.gender);

  Users.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        phone = data['phone'],
        dob=data['dob'];

   Map<String, dynamic>toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
    };
  }


}