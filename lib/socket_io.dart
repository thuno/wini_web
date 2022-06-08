import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wini_web/config.dart';

class StreamSocket {
  final _socketResponse = StreamController<IOItem>();

  void Function(IOItem) get addResponse => _socketResponse.sink.add;

  Stream<IOItem> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class WiniIO {
  StreamSocket streamSocket = StreamSocket();
  static IO.Socket socket = IO.io(
    Config.urlSocketIO,
    IO.OptionBuilder().setTransports(['websocket']).build(),
  );

  static void connect() {
    socket.onConnect((_) {});
  }

  static void emitGoogle({String? accessToken, String? idToken, String? socketId}) {
    print('client-google');
    socket.emit('client-google', {
      "url": 'Customer/GoogleCallback?accesstoken=$accessToken&token=$idToken',
      "data": null,
      "userId": socketId,
    });
  }
}

enum DataType {
  wBase,
  style,
  attribute,
  variant,
  project,
}

class IOItem {
  int? status;
  String? key;
  String? oldKey;
  int? customerId;
  dynamic data;
  int? projectId;

  IOItem({
    this.status,
    this.key,
    this.oldKey,
    this.customerId,
    this.data,
    this.projectId,
  });

  factory IOItem.fromJson(Map<String, dynamic> json) {
    return IOItem(
      status: json['Status'],
      key: json['Key'],
      oldKey: json['OldKey'],
      customerId: json['CustomerID'],
      data: json['Data'],
      projectId: json['ProjectID'],
    );
  }

  static toJson(IOItem obj) => {
        'Status': obj.status,
        'Key': obj.key,
        'OldKey': obj.oldKey,
        'CustomerID': obj.customerId,
        'Data': obj.data,
        'ProjectID': obj.projectId,
      };
}
