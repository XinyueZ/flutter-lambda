import 'dart:convert';

class DecoderHelper {
  static const utf8Decoder = Utf8Decoder();
  static const jsonDecoder = JsonDecoder();

  static Utf8Decoder getUtf8Decoder() => utf8Decoder;

  static JsonDecoder getJsonDecoder() => jsonDecoder;
}
