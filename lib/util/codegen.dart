import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

const codeGranularityMs = 1000 * 60;       // 1 minute
const codeValidityMs    = 1000 * 60 * 60;  // 1 hour

Uint8List u64BigEndianFromInt(int n) {
  final bd = ByteData(8);
  bd.setUint32(0, (n >> 32) & 0xFFFFFFFF, Endian.big);
  bd.setUint32(4, n & 0xFFFFFFFF, Endian.big);
  return bd.buffer.asUint8List();
}

String generateFlCode(String sharedSecret, int customTimestamp) {
  final key = utf8.encode(sharedSecret.trim());
  final timestampMs = customTimestamp * 1000;

  final interval = timestampMs ~/ codeValidityMs;
  final intervalBeginningTimestampMs = interval * codeValidityMs;

  // minutes since epoch at the start of the current hour
  final adjustedTimestamp = intervalBeginningTimestampMs ~/ codeGranularityMs;

  final msg = u64BigEndianFromInt(adjustedTimestamp);

  final hmacSha1 = Hmac(sha1, key);
  final digest = hmacSha1.convert(msg).bytes;

  final offset = digest.last & 0x0f;
  final slice = digest.sublist(offset, offset + 4);
  final number =
      ByteData.sublistView(Uint8List.fromList(slice)).getInt32(0, Endian.big) &
      0x7fffffff;

  final code = number % 1000000;
  return code.toString().padLeft(6, '0');
}

int remainingTime(int customTimestamp) {
  final timestampMs = customTimestamp * 1000;
  final interval = timestampMs ~/ codeValidityMs;
  final intervalBeginningTimestampMs = interval * codeValidityMs;
  final validToMs = intervalBeginningTimestampMs + codeValidityMs;
  return (validToMs - timestampMs) ~/ 1000;
}
