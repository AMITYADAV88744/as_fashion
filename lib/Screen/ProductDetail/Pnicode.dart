
class PostOffice {
  PostOffice({
    required this.name,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  String name='';
  String description='';
  String deliveryStatus='';
  String circle='';
  String district='';
  String division='';
  String region='';
  String block='';
  String state='';
  String country='';
  String pincode='';

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
    name: json["Name"],
    deliveryStatus:json["DeliveryStatus"],
    circle: json["Circle"],
    district:json["District"],
    division: json["Division"],
    region: json["Region"],
    block: json["Block"],
    state: json["State"],
    country: json["Country"],
    pincode: json["Pincode"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Description": description,
   "DeliveryStatus": deliveryStatusValues.reverse[deliveryStatus],
    "Circle": circleValues.reverse[circle],
    "District": blockValues.reverse[district],
    "Division": divisionValues.reverse[division],
    "Region": circleValues.reverse[region],
    "Block": blockValues.reverse[block],
    "State": circleValues.reverse[state],
    "Country": countryValues.reverse[country],
    "Pincode": pincode,
  };
}

enum Block { CENTRAL_DELHI, NEW_DELHI }

final blockValues = EnumValues({
  "Central Delhi": Block.CENTRAL_DELHI,
  "New Delhi": Block.NEW_DELHI
});

enum BranchType { SUB_POST_OFFICE, HEAD_POST_OFFICE }

final branchTypeValues = EnumValues({
  "Head Post Office": BranchType.HEAD_POST_OFFICE,
  "Sub Post Office": BranchType.SUB_POST_OFFICE
});

enum Circle { DELHI }

final circleValues = EnumValues({
  "Delhi": Circle.DELHI
});

enum Country { INDIA }

final countryValues = EnumValues({
  "India": Country.INDIA
});

enum DeliveryStatus { NON_DELIVERY, DELIVERY }

final deliveryStatusValues = EnumValues({
  "Delivery": DeliveryStatus.DELIVERY,
  "Non-Delivery": DeliveryStatus.NON_DELIVERY
});

enum Division { NEW_DELHI_CENTRAL, NEW_DELHI_GPO }

final divisionValues = EnumValues({
  "New Delhi Central": Division.NEW_DELHI_CENTRAL,
  "New Delhi GPO": Division.NEW_DELHI_GPO
});

class EnumValues<T> {
 late Map<String, T> map;
late   Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
