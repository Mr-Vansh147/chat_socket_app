class PassUserModel {
  final String id;
  final String name;
  final String? image;
  final String? email;

  PassUserModel({
    required this.id,
    required this.name,
    this.image,
    this.email,
  });
}
