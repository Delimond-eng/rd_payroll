import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class GxdCryptor{
  static String bytesToBase64(Uint8List data)=> base64Encode(data);
  static Uint8List base64Tobytes(String b64) => base64Decode(b64);

  static String encrypt(String value){
    String strEncoded = value.codeUnits.map((v) => v.toRadixString(2).padLeft(8, '0')).join(" ");
    Uint8List uint8list = Uint8List.fromList(strEncoded.codeUnits);
    var compressedByte = GZipCodec().encode(uint8list);
    String s = bytesToBase64(compressedByte);
    return s;
  }

  static String decrypt(String value){
    var d = base64Tobytes(value);
    var decompressedByte = GZipCodec().decode(d);
    String s = String.fromCharCodes(decompressedByte);
    String decoded = String.fromCharCodes(s.split(" ").map((v) => int.parse(v, radix: 2)));
    return decoded;
  }
}