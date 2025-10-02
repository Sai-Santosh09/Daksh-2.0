import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/search_service.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final VoidCallback? onTap;

  const SearchResultCard({
    super.key,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Type icon
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    decoration: BoxDecoration(
                      color: _getTypeColor(result.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getTypeIcon(result.type),
                      size: 20,
                      color: _getTypeColor(result.type),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  
                  // Title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              _getTypeLabel(result.type),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getTypeColor(result.type),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_getRelevanceText().isNotEmpty) ...[
                              const Text(' • ', style: TextStyle(color: Colors.grey)),
                              Text(
                                _getRelevanceText(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Thumbnail if available
                  if (result.thumbnailUrl != null)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(result.thumbnailUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Description
              if (result.description.isNotEmpty)
                Text(
                  result.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Metadata row
              Wrap(
                spacing: AppTheme.spacingM,
                runSpacing: AppTheme.spacingS,
                children: _buildMetadataChips(context),
              ),
              
              // Tags if available
              if (result.tags.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacingS),
                Wrap(
                  spacing: AppTheme.spacingS,
                  runSpacing: AppTheme.spacingS,
                  children: result.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMetadataChips(BuildContext context) {
    final chips = <Widget>[];

    // Add type-specific metadata
    switch (result.type) {
      case 'lesson':
        // Duration
        final duration = result.metadata['duration'] as int?;
        if (duration != null && duration > 0) {
          chips.add(_buildMetadataChip(
            context,
            Icons.access_time,
            '${duration}min',
          ));
        }

        // Difficulty
        final difficulty = result.metadata['difficulty'] as String?;
        if (difficulty != null) {
          chips.add(_buildMetadataChip(
            context,
            _getDifficultyIcon(difficulty),
            difficulty.toUpperCase(),
          ));
        }

        // Category
        final category = result.metadata['category'] as String?;
        if (category != null) {
          chips.add(_buildMetadataChip(
            context,
            Icons.category,
            category,
          ));
        }

        // Progress indicator
        final progress = result.metadata['progress'] as double?;
        final isCompleted = result.metadata['isCompleted'] as bool?;
        if (isCompleted == true) {
          chips.add(_buildMetadataChip(
            context,
            Icons.check_circle,
            'Completed',
            color: Colors.green,
          ));
        } else if (progress != null && progress > 0) {
          chips.add(_buildMetadataChip(
            context,
            Icons.play_circle_outline,
            '${(progress * 100).round()}%',
            color: Colors.blue,
          ));
        }
        break;

      case 'asset':
        // Asset type
        final assetType = result.metadata['type'] as String?;
        if (assetType != null) {
          chips.add(_buildMetadataChip(
            context,
            _getAssetTypeIcon(assetType),
            assetType,
          ));
        }

        // Duration for media assets
        final assetDuration = result.metadata['duration'] as int?;
        if (assetDuration != null && assetDuration > 0) {
          chips.add(_buildMetadataChip(
            context,
            Icons.access_time,
            _formatDuration(assetDuration),
          ));
        }
        break;

      case 'chapter':
        // Subject
        final subject = result.metadata['subject'] as String?;
        if (subject != null) {
          chips.add(_buildMetadataChip(
            context,
            Icons.subject,
            subject,
          ));
        }

        // Completion status
        final chapterCompleted = result.metadata['isCompleted'] as bool?;
        if (chapterCompleted == true) {
          chips.add(_buildMetadataChip(
            context,
            Icons.check_circle,
            'Completed',
            color: Colors.green,
          ));
        }
        break;
    }

    return chips;
  }

  Widget _buildMetadataChip(
    BuildContext context,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color ?? Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'lesson':
        return Icons.school;
      case 'asset':
        return Icons.play_circle_outline;
      case 'chapter':
        return Icons.menu_book;
      default:
        return Icons.search;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'lesson':
        return Colors.blue;
      case 'asset':
        return Colors.green;
      case 'chapter':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'lesson':
        return 'Lesson';
      case 'asset':
        return 'Media';
      case 'chapter':
        return 'Chapter';
      default:
        return type.toUpperCase();
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Icons.star_border;
      case 'intermediate':
        return Icons.star_half;
      case 'advanced':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getAssetTypeIcon(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      default:
        return Icons.attachment;
    }
  }

  String _getRelevanceText() {
    final score = (result.relevanceScore * 100).round();
    if (score >= 80) {
      return 'Excellent match';
    } else if (score >= 60) {
      return 'Good match';
    } else if (score >= 40) {
      return 'Fair match';
    }
    return '';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }
}
