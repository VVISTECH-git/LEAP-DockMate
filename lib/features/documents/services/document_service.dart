import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';

class DocumentUploadResult {
  final int successCount;
  final int totalCount;
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

  /// Uploads documents to OTM one by one via ApiClient so that:
  /// • 401 responses auto-redirect to login (session expiry handled)
  /// • updateLastActive() is called on every successful upload
  Future<DocumentUploadResult> uploadDocuments({
    required String shipGroupGid,
    required List<DocumentFile> files,
    void Function(int done, int total)? onProgress,
  }) async {
    final domain = await SessionService.instance.domain;

    int successCount = 0;
    final fileResults = List<bool>.filled(files.length, false);

    for (int i = 0; i < files.length; i++) {
      final file = files[i];

      try {
        final bytes         = await file.file.readAsBytes();
        final base64Content = base64Encode(bytes);

        final now         = DateTime.now();
        final documentXid = '${DateFormat('yyyyMMdd-HHmmss').format(now)}-$i';
        final ext         = file.file.path.split('.').last.toLowerCase();

        // Security: reject before reading file bytes or calling _resolveMimeType.
        if (!_allowedExtensions.contains(ext)) {
          fileResults[i] = false;
          if (kDebugMode) {
            debugPrint('Upload rejected for file $i: unsupported extension .$ext');
          }
          onProgress?.call(i + 1, files.length);
          continue;
        }

        final mimeType    = _resolveMimeType(ext);

        final payload = {
          'documentXid':                documentXid,
          'documentType':               'BLOB',
          'documentMimeType':           mimeType,
          'documentFilename':           file.file.uri.pathSegments.last,
          'ownerDataQueryTypeGid':      'SHIPMENT GROUP',
          'ownerObjectGid':             shipGroupGid,
          'domainName':                 domain,
          'contentManagementSystemGid': 'DATABASE',
          'usedAs':                     'I',
          'contents': {
            'items': [
              {
                'documentContentGid': '$domain.$documentXid',
                'blobContent':        base64Content,
              }
            ]
          },
        };

        // Route through ApiClient so 401 → auto-redirect and lastActive is updated.
        await ApiClient.instance.post(
          AppConstants.pathDocuments,
          body: payload,
        );

        successCount++;
        fileResults[i] = true;
      } on ApiException catch (e) {
        fileResults[i] = false;
        if (kDebugMode) debugPrint('Upload failed for file $i: ${e.message}');
      } catch (e) {
        fileResults[i] = false;
        final friendly = ApiClient.friendlyNetworkMessage(e);
        if (kDebugMode) debugPrint('Upload error for file $i: $friendly');
      }

      onProgress?.call(i + 1, files.length);
    }

    return DocumentUploadResult(
      successCount: successCount,
      totalCount:   files.length,
      fileResults:  fileResults,
    );
  }

  // Security: explicit allowlist of permitted upload extensions.
  static const _allowedExtensions = {
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic',
  };

  static String _resolveMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':  return 'image/jpeg';
      case 'png':   return 'image/png';
      case 'gif':   return 'image/gif';
      case 'webp':  return 'image/webp';
      case 'heic':  return 'image/heic';
      default:
        throw DocumentUploadException('Unsupported file type: .$ext');
    }
  }
}

class DocumentUploadException implements Exception {
  final String message;
  const DocumentUploadException(this.message);
  @override
  String toString() => message;
}

class DocumentFile {
  final File   file;
  final String docType;
  const DocumentFile({required this.file, required this.docType});
}
