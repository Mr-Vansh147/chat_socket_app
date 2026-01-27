import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class MultipartService {
  static Future<Map<String, dynamic>> request({
    required String url,
    required String method,
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<MultipartFileData>? files,
  }) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest(method, uri);

    request.headers.addAll({
      "Accept": "application/json",
      ...?headers,
    });

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      for (final file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(
            file.field,
            file.path,
            contentType: file.contentType,
          ),
        );
      }
    }

    /// 🔍 SIMPLE LOGS (IMPORTANT ONLY)
    if (kDebugMode) {
      print("➡️ URL: $url");
      print("➡️ METHOD: $method");
      if (fields != null && fields.isNotEmpty) {
        print("➡️ FIELDS: $fields");
      }
      if (files != null && files.isNotEmpty) {
        print(
          "➡️ FILES: ${files.map((e) => e.field).toList()}",
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (kDebugMode) {
      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ BODY: ${response.body}");
    }

    return {
      "statusCode": response.statusCode,
      "body": response.body,
      "json": _safeJson(response.body),
    };
  }

  static dynamic _safeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}

class MultipartFileData {
  final String field;
  final String path;
  final MediaType? contentType;

  MultipartFileData({
    required this.field,
    required this.path,
    this.contentType,
  });
}
