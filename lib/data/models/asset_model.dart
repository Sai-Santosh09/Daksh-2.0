import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/asset.dart';

// part 'asset_model.g.dart';

@JsonSerializable()
class AssetModel extends Asset {
  const AssetModel({
    required super.id,
    required super.lessonId,
    required super.name,
    required super.description,
    required super.type,
    required super.url,
    super.localPath,
    required super.sizeBytes,
    required super.mimeType,
    super.checksum,
    super.status,
    super.downloadedAt,
    super.lastModified,
    super.metadata,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: AssetType.values.firstWhere((e) => e.name == json['type'], orElse: () => AssetType.document),
      url: json['url'] as String,
      localPath: json['localPath'] as String?,
      sizeBytes: json['sizeBytes'] as int? ?? 0,
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      checksum: json['checksum'] as String?,
      status: AssetStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => AssetStatus.notDownloaded),
      downloadedAt: json['downloadedAt'] != null ? DateTime.parse(json['downloadedAt'] as String) : null,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified'] as String) : null,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'name': name,
      'description': description,
      'type': type.name,
      'url': url,
      'localPath': localPath,
      'sizeBytes': sizeBytes,
      'mimeType': mimeType,
      'checksum': checksum,
      'status': status.name,
      'downloadedAt': downloadedAt?.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory AssetModel.fromEntity(Asset asset) {
    return AssetModel(
      id: asset.id,
      lessonId: asset.lessonId,
      name: asset.name,
      description: asset.description,
      type: asset.type,
      url: asset.url,
      localPath: asset.localPath,
      sizeBytes: asset.sizeBytes,
      mimeType: asset.mimeType,
      checksum: asset.checksum,
      status: asset.status,
      downloadedAt: asset.downloadedAt,
      lastModified: asset.lastModified,
      metadata: asset.metadata,
    );
  }

  Asset toEntity() {
    return Asset(
      id: id,
      lessonId: lessonId,
      name: name,
      description: description,
      type: type,
      url: url,
      localPath: localPath,
      sizeBytes: sizeBytes,
      mimeType: mimeType,
      checksum: checksum,
      status: status,
      downloadedAt: downloadedAt,
      lastModified: lastModified,
      metadata: metadata,
    );
  }
}

// Extension methods for enum serialization
extension AssetTypeExtension on AssetType {
  String get value {
    switch (this) {
      case AssetType.image:
        return 'image';
      case AssetType.audio:
        return 'audio';
      case AssetType.video:
        return 'video';
      case AssetType.document:
        return 'document';
      case AssetType.animation:
        return 'animation';
      case AssetType.interactive:
        return 'interactive';
    }
  }

  static AssetType fromString(String value) {
    switch (value) {
      case 'image':
        return AssetType.image;
      case 'audio':
        return AssetType.audio;
      case 'video':
        return AssetType.video;
      case 'document':
        return AssetType.document;
      case 'animation':
        return AssetType.animation;
      case 'interactive':
        return AssetType.interactive;
      default:
        throw ArgumentError('Unknown AssetType: $value');
    }
  }
}

extension AssetStatusExtension on AssetStatus {
  String get value {
    switch (this) {
      case AssetStatus.notDownloaded:
        return 'not_downloaded';
      case AssetStatus.downloading:
        return 'downloading';
      case AssetStatus.downloaded:
        return 'downloaded';
      case AssetStatus.failed:
        return 'failed';
      case AssetStatus.corrupted:
        return 'corrupted';
    }
  }

  static AssetStatus fromString(String value) {
    switch (value) {
      case 'not_downloaded':
        return AssetStatus.notDownloaded;
      case 'downloading':
        return AssetStatus.downloading;
      case 'downloaded':
        return AssetStatus.downloaded;
      case 'failed':
        return AssetStatus.failed;
      case 'corrupted':
        return AssetStatus.corrupted;
      default:
        throw ArgumentError('Unknown AssetStatus: $value');
    }
  }
}


