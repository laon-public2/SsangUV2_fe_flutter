class ChatListModel {
  int senderIdx;
  String senderNumber;
  String senderName;
  String senderType;
  String senderBusinessNum;
  String senderAddress;
  String senderAddressDetail;
  num senderLa;
  num senderLo;
  String senderFcmToken;
  int receiverIdx;
  String receiverNumber;
  String receiverName;
  String receiverType;
  String receiverBusinessNum;
  String receiverAddress;
  String receiverAddressDetail;
  num receiverLa;
  num receiverLo;
  String receiverFcmToken;
  int productIdx;
  String productTitle;
  String productDescription;
  int productPrice;
  int productMinPrice;
  int productMaxPrice;
  String productType;
  String productStatus;
  String status;
  String type;
  String uuid;
  int isNew;
  String startDate;
  String endDate;
  int categoryNum;
  List<ProductFile> productFiles;

  ChatListModel.fromJson(Map<String, dynamic> json)
      : senderIdx = json['sender_idx'],
        categoryNum = json['category_idx'],
        senderNumber = json['sender_username'],
        senderName = json['sender_name'],
        senderType = json['sender_userType'],
        senderBusinessNum = json['sender_businessIdentifyNum'],
        senderAddress = json['sender_address'],
        senderAddressDetail = json['sender_addressDetail'],
        senderLo = json['sender_location']['x'],
        senderLa = json['sender_location']['y'],
        senderFcmToken = json['sender_fcm_token'],
        receiverIdx = json['receiver_idx'],
        receiverNumber = json['receiver_username'],
        receiverName = json['receiver_name'],
        receiverType = json["receiver_userType"],
        receiverBusinessNum = json['receiver_businessIdentifyNum'],
        receiverAddress = json['receiver_address'],
        receiverAddressDetail = json['receiver_addressDetail'],
        receiverLo = json['receiver_location']['x'],
        receiverLa = json['receiver_location']['y'],
        receiverFcmToken = json['receiver_fcm_token'],
        productIdx = json['product_idx'],
        productTitle = json['product_title'],
        productDescription = json['product_description'],
        productPrice = json['product_price'],
        productMinPrice = json['product_min_price'],
        productMaxPrice = json['product_max_price'],
        productType = json['product_type'],
        productStatus = json['product_status'],
        type = json['type'],
        status = json['status'],
        uuid = json['UUID'],
        isNew = json['isNew'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        productFiles = json['image'] != null
            ? (json['image'] as List)
                .map((e) => ProductFile.fromJson(e))
                .toList()
            : List<ProductFile>.empty();
}

class ProductFile {
  int id;
  String path;

  ProductFile.fromJson(Map<String, dynamic> json)
      : id = json["file_idx"],
        path = json["file"];
}
