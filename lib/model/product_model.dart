
class ProductModel {
  late String pid,pname,  brand,uploadtime,
      discrip,category, subcategory,fittype='',pattertyp='',
      necktyp='',faddedtyp='',fabrictyp='',sleevtyp='',collartyp='';
  late int price,discount,l_price,stock_qty,shipchrge;
  late List size,color,keywords ,image;

   // late Color color;

  ProductModel(
      {
        required this.pid,
        required this.pname,
        required this.image,
        required this.brand,
        required this.discrip,
        required this.color,
        required this.size,
        required this.keywords,
        required this.l_price,
        required this.discount,
        required this.price,
       required this.stock_qty,
        required this.shipchrge,
        required this.category,
        required this.subcategory,
        required this.fabrictyp,
        required this.pattertyp,
        required this.necktyp,
        required this.collartyp,
        required this.faddedtyp,
        required this.fittype,
        required this.sleevtyp,
        required this.uploadtime,
      });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    uploadtime=map['uploadtime'];
    pid=map['pid'];
    pname = map['pname'];
    image = map['image'];
    brand = map['brand'];
    discrip=map['descrip'];
    color = map['color'];
    size = map['size'];
    keywords=map['keywords'];
    l_price = map['l_price'];
    discount = map['discount'];
    price = map['price'];
    shipchrge=map['ship_char'];
    stock_qty=map['stock_qty'];
    category=map['category'];
    subcategory=map['subcategory'];
    fabrictyp=map['fabrictyp'];
    necktyp=map['necktyp'];
    collartyp=map['collartyp'];
    sleevtyp=map['sleevetyp'];
    pattertyp=map['patterntyp'];
    //faddedtyp=map['faddedtyp'];
    //fittype=map['fittingtyp'];

  }
  ProductModel.toJson(Map<dynamic,dynamic> map){
    pid=map['pid'];
    pname = map['pname'];
    image = map['image'];
    brand = map['brand'];
    //color = HexColor.fromHex(map['color']);
    size = map['size'];
    price = map['price'];
    l_price = map['l_price'];
    discount = map['discount'];
  }

}
