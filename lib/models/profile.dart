class Profile {
  final String name;
  final String email;
  final String image;
  final String phone;
  final String address;

  Profile({
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.address,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json["name"],
      email: json["email"],
      image: json["image"],
      phone: json["phone"],
      address: json["address"],
    );
  }
}
