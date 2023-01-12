
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/modules/data/models/message.dart';

import '../../../core/exceptions/general_exception.dart';
import '../providers/send_message_provider.dart';

class MessageRepository {
  final MessageProvider _messageProvider = MessageProvider();

  Future<List<Message>> getMessages(String token, int page) async {
    Response response = await _messageProvider.getMessages(token, page);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    var jsonReports = jsonDecode(response.toString())["data"] as List;
    List<Message> messages = jsonReports.map((e) => Message.fromJson(e)).toList();
    return messages;
  }

  Future<bool> sendMessage(String? token, message) async {
    Response response = await _messageProvider.sendMessage(token, message);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}
