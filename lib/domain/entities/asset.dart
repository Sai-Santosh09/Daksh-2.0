import 'package:equatable/equatable.dart';
import '../../data/services/download_manager.dart';

enum AssetType {
  image,
  audio,
  video,
  document,
  animation,
  interactive,
}

enum AssetStatus {
  notDownloaded,
  downloading,
  downloaded,
  failed,
  corrupted,
}

class Asset extends Equatable {
  final String id;
  final String lessonId;
  final String name;
  final String description;
  final AssetType type;
  final String url;
  final String? localPath;
  final int sizeBytes;
  final String mimeType;
  final String? checksum;
  final AssetStatus status;
  final DateTime? downloadedAt;
  final DateTime? lastModified;
  final Map<String, dynamic> metadata;

  const Asset({
    required this.id,
    required this.lessonId,
    required this.name,
    required this.description,
    required this.type,
    required this.url,
    this.localPath,
    required this.sizeBytes,
    required this.mimeType,
    this.checksum,
    this.status = AssetStatus.notDownloaded,
    this.downloadedAt,
    this.lastModified,
    this.metadata = const {},
  });

  Asset copyWith({
    String? id,
    String? lessonId,
    String? name,
    String? description,
    AssetType? type,
    String? url,
    String? localPath,
    int? sizeBytes,
    String? mimeType,
    String? checksum,
    AssetStatus? status,
    DateTime? downloadedAt,
    DateTime? lastModified,
    Map<String, dynamic>? metadata,
  }) {
    return Asset(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      mimeType: mimeType ?? this.mimeType,
      checksum: checksum ?? this.checksum,
      status: status ?? this.status,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      lastModified: lastModified ?? this.lastModified,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isDownloaded => status == AssetStatus.downloaded;
  bool get isDownloading => status == AssetStatus.downloading;
  bool get hasFailed => status == AssetStatus.failed || status == AssetStatus.corrupted;
  
  // Convert AssetStatus to AssetDownloadStatus for compatibility
  AssetDownloadStatus get downloadStatus {
    switch (status) {
      case AssetStatus.notDownloaded:
        return AssetDownloadStatus.notDownloaded;
      case AssetStatus.downloading:
        return AssetDownloadStatus.downloading;
      case AssetStatus.downloaded:
        return AssetDownloadStatus.downloaded;
      case AssetStatus.failed:
        return AssetDownloadStatus.failed;
      case AssetStatus.corrupted:
        return AssetDownloadStatus.corrupted;
    }
  }
  
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  List<Object?> get props => [
        id,
        lessonId,
        name,
        description,
        type,
        url,
        localPath,
        sizeBytes,
        mimeType,
        checksum,
        status,
        downloadedAt,
        lastModified,
        metadata,
      ];
}


