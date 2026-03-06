import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';

class DocumentUploadResult {
  final int successCount;
  final int totalCount;
  // FIX: Added per-file status list so the UI can show ✅/❌ on each thumbnail.
  final List<bool> fileResults;

  const DocumentUploadResult({
    required this.successCount,
    required this.totalCount,
    required this.fileResults,
  });

  bool get allSuccess     => successCount == totalCount;
  bool get partialSuccess => successCount > 0 && successCount < totalCount;
  bool get failed         => successCount == 0;
}

class DocumentService {
  DocumentService._();
  static final DocumentService instance = DocumentService._();

  /// Uploads documents to OTM one by one.
  /// [onProgress] is called AFTER each file completes (not before),
  /// so the progress bar reflects actual completed uploads.
  Future<DocumentUploadResult> uploadDocuments({
    required String shipGroupGid,
    required List<DocumentFile> files,
    // FIX: onProgress now passes (completedCount, totalCount) called AFTER
    // each file finishes — previously it was called BEFORE, making the bar
    // jump ahead before any work was done on that file.
    void Function(int done, int total)? onProgress,
  }) async {
    final baseUrl    = await SessionService.instance.instanceUrl;
    final authHeader = await SessionService.instance.authHeader;
    final domain     = await SessionService.instance.domain;

    int successCount = 0;
    // FIX: Track per-file result so UI can show ✅/❌ on each thumbnail.
    final fileResults = List<bool>.filled(files.length, false);

    for (int i = 0; i < files.length; i++) {
      final file = files[i];

      try {
        final bytes         = await file.file.readAsBytes();
        final base64Content = base64Encode(bytes);

        final now         = DateTime.now();
        final documentXid = '${DateFormat('yyyyMMdd-HHmmss').format(now)}-$i';
        final ext         = file.file.path.split('.').last.toLowerCase();
        final mimeType    = _resolveMimeType(ext);

        final payload = {
          'documentXid':               documentXid,
          'documentType':              'BLOB',
          'documentMimeType':          mimeType,
          'documentFilename':          file.file.uri.pathSegments.last,
          'ownerDataQueryTypeGid':     'SHIPMENT GROUP',
          'ownerObjectGid':            shipGroupGid,
          'domainName':                domain,
          'contentManagementSystemGid':'DATABASE',
          'usedAs':                    'I',
          'contents': {
            'items': [
              {
                'documentContentGid': '$domain.$documentXid',
                'blobContent':        base64Content,
              }
            ]
          },
        };

        final response = await http.post(
          Uri.parse('$baseUrl${AppConstants.pathDocuments}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authHeader,
          },
          body: jsonEncode(payload),
        ).timeout(const Duration(seconds: 90));

        if (response.statusCode == 200 || response.statusCode == 201) {
          successCount++;
          fileResults[i] = true;
        } else {
          fileResults[i] = false;
          if (kDebugMode) {
            debugPrint('Upload failed [${response.statusCode}]: ${response.body}');
          }
        }
      } catch (e) {
        fileResults[i] = false;
        if (kDebugMode) debugPrint('Upload exception for file $i: $e');
      }

      // FIX: onProgress called AFTER the file completes, not before.
      // This means the bar accurately reflects how many files are truly done.
      onProgress?.call(i + 1, files.length);
    }

    return DocumentUploadResult(
      successCount: successCount,
      totalCount:   files.length,
      fileResults:  fileResults,
    );
  }

  /// Resolves correct MIME type from file extension.
  /// 'jpg' → 'image/jpeg' (not 'image/jpg' which is invalid).
  static String _resolveMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':  return 'image/jpeg';
      case 'png':   return 'image/png';
      case 'gif':   return 'image/gif';
      case 'webp':  return 'image/webp';
      case 'heic':  return 'image/heic';
      default:      return 'image/$ext';
    }
  }
}

class DocumentFile {
  final File   file;
  final String docType;
  const DocumentFile({required this.file, required this.docType});
}
