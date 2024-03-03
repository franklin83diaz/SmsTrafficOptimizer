import 'dart:convert';

/// Base class for SMS traffic optimizer
///
/// dictionary - map of 128 words most frequently used in SMS messages
/// the id from is 128 to 255
///
///
class SmsTrafficOptimizerBase {
  final Map<int, String> dictionary;

  SmsTrafficOptimizerBase(this.dictionary);

  /// Compresses the message
  ///
  /// this method compresses the message by replacing the words with their ids
  /// return the 3 first bytes is for number abd the rest is for the message
  List<int> compress(int number, String message) {
    if (number < 0 || number > 0xFFFFFF) {
      throw ArgumentError(
          'The number no is correct, the number must be 0-9999999');
    }
    if (message.length > 128) {
      throw ArgumentError('The message must be less than 128 characters');
    }

    final List<int> result = [];
    final bytesNumber = [
      (number >> 16) & 0xFF, // Byte more significative
      (number >> 8) & 0xFF, // next Byte
      number & 0xFF, // Byte less significative
    ];

    final splitSpaceMessage = message.split(' ');

    for (var word in splitSpaceMessage) {
      final id = dictionary.entries.firstWhere(
          (element) => element.value == word,
          orElse: () => MapEntry(0, ''));
      if (id.key != 0) {
        result.add(id.key);
      } else {
        result.addAll(utf8.encode("$word "));
      }
    }
    return [message.length, ...bytesNumber, ...result];
  }

  /// Decompress the message
  /// return the message
  Map<String, String> decompress(List<int> bytesMessages) {
    final Map<String, String> mapResult = {};
    String messages = "";

    final number =
        (bytesMessages[1] << 16) | (bytesMessages[2] << 8) | bytesMessages[3];

    final bytesText = bytesMessages.sublist(4);
    for (var byte in bytesText) {
      if (byte < 128) {
        messages = messages + String.fromCharCode(byte);
      } else {
        messages = messages + (" ${dictionary[byte] ?? ''} ");
      }
    }
    messages = messages.replaceAll("  ", " ");
    mapResult['message'] = messages.trim();

    mapResult['number'] = number.toString();

    return mapResult;
  }

  /// Join the messages for sending for socket
  ///  the first byte is the length of message (max length is 128)
  ///  the 2,3 and 4 bytes is for number max 9999999
  List<int> joinBytesMessages(List<List<int>> bytesMessages) {
    List<int> result = [];
    for (var bytesMessage in bytesMessages) {
      result.addAll(bytesMessage);
    }
    return result;
  }

  //split the message
  List<List<int>> splitMessage(List<int> bytesMessages) {
    final List<List<int>> result = [];
    while (bytesMessages.isNotEmpty) {
      final length = bytesMessages.first;
      final bytesSMS = bytesMessages.sublist(0, length + 4);
      //remove the message from the list
      bytesMessages.removeRange(0, length + 4);
      //add the message to the result
      result.add(bytesSMS);
    }

    return result;
  }
}
