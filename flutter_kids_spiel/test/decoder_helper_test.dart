import 'dart:convert';

import 'package:flutter_kids_spiel/service/decoder_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("decoder helper test-suit", () {
    test("should singleton utf8 decoder", () {
      final dynamic instance1 = DecoderHelper.getUtf8Decoder();
      final dynamic instance2 = DecoderHelper.getUtf8Decoder();
      expect(instance1 is Utf8Decoder, true);
      expect(identical(instance1, instance2), true);
    });
    test("should singleton json decoder", () {
      final dynamic instance1 = DecoderHelper.getJsonDecoder();
      final dynamic instance2 = DecoderHelper.getJsonDecoder();
      expect(instance1 is JsonDecoder, true);
      expect(identical(instance1, instance2), true);
    });
  });
}
