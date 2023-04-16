class Messages {
  Messages({
    required this.toid,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromid,
    required this.sent,
  });
  late final String toid;
  late final String msg;
  late final String read;
  late final String fromid;
  late final String sent;
  late final Type type;

  Messages.fromJson(Map<String, dynamic> json) {
    // this is converted to string cuz dont want to face null errors
    // enum is better than raw string comparison
    // Enum stands for enumerated type, a type of data where only a set of predefined values exist. In Dart,
    // Enum is simply a special kind of class used to represent a fixed number of constant values.
    toid = json['toid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    // the type will either be a text or an image
    // so check type.image and type.name are same it will work
    // if type image then enum returns  true in this case type is imae or text is set
    // 'image' == typeimage.name --> true
    // 'image == type.image --> false
    // when we are sending the message at that time too i send it as ".name" 
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromid = json['fromid'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toid'] = toid;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type;
    data['fromid'] = fromid;
    data['sent'] = sent;
    return data;
  }
}

// if type is kept as it is we have to check always == type
// so we use the enum(can be done without enum)
// Enum stands for enumerated type, a type of data where only a set of predefined values exist. In Dart,
// Enum is simply a special kind of class used to represent a fixed number of constant values.
// An enum is something that is representing the same data in Dart:
enum Type { text, image }


// More reference """https://www.waldo.com/blog/flutter-enum"""
