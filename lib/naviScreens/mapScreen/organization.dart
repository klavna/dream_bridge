class SocialWelfareOrganization {
  final String address;
  final String id;
  final String name;
  final String phone;
  final String realm;
  final String website;

  SocialWelfareOrganization({
    required this.address,
    required this.id,
    required this.name,
    required this.phone,
    required this.realm,
    required this.website,
  });

  // JSON에서 객체로 변환하는 팩토리 생성자
  factory SocialWelfareOrganization.fromJson(Map<String, dynamic> json) {
    return SocialWelfareOrganization(
      address: json['address'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      realm: json['realm'],
      website: json['website'],
    );
  }

  // 객체에서 JSON으로 변환하는 메소드
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'id': id,
      'name': name,
      'phone': phone,
      'realm': realm,
      'website': website,
    };
  }
  @override
  String toString() {
    return 'SocialWelfareOrganization{id: $id, name: $name, address: $address, phone: $phone, realm: $realm, website: $website}';
  }
}