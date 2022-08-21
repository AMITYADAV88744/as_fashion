class OrderModel{
  OrderModel({
     required this.phone,
    required this.order_no,
    required this.or_status,
    required this.or_dtime,
    required this.pincode,
  });
  String phone='',or_status='',landmark='',pincode='',or_dtime='',order_no='',image='';


  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
      phone: json['phone'],
      order_no: json['order_no'],
      or_status:json ['or_status'],
      or_dtime:json ['or_dtime'],
      pincode: json['pincode']
  );

}