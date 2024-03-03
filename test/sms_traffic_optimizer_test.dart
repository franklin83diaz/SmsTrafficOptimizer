import 'dart:convert';
import 'dart:io';

import 'package:sms_traffic_optimizer/sms_traffic_optimizer.dart';
import 'package:sms_traffic_optimizer/src/dictionary.dart';
import 'package:test/test.dart';

void main() {
  group('test compress', () {
    final smsTrafficOptimizer = SmsTrafficOptimizerBase(defaultDictionary);
    final msgForTest =
        "hola te digo mi punto, asi es la cosa, hay mas que decir pero...";
    test('compress', () {
      final result = smsTrafficOptimizer.compress(2825899, msgForTest);
      final msg = '2825899$msgForTest';
      print(msg.length);
      print(result.length);
      print("Rate STO: ${((result.length / msg.length) * 100).round()}%");

      print(String.fromCharCodes(result));
      // expect(result, [49, 50, 51, 52, 53, 54, 55, 128, 135]);
      print(smsTrafficOptimizer.decompress(result));
    });

    test("best rate of gzip", () {
      final result = smsTrafficOptimizer.compress(2825899, msgForTest);

      List<int> originalBytes = utf8.encode('2825899te $msgForTest');

      List<int> compressedBytes = gzip.encode(originalBytes);
      print(
          "Rate gzip: ${((compressedBytes.length / originalBytes.length) * 100).round()}%");
      expect(result.length < compressedBytes.length, true);
    });
  });
}
