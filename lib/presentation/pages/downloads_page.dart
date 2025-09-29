import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/download_progress_widget.dart';
import '../providers/download_provider.dart';
import '../../data/services/download_manager.dart';

class DownloadsPage extends ConsumerWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            onPressed: () {
              _showDownloadSettings(context, ref);
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Download settings',
          ),
        ],
      ),
      body: const DownloadsContent(),
    );
  }

  void _showDownloadSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Clear Completed Downloads'),
              subtitle: const Text('Remove all completed downloads'),
              leading: const Icon(Icons.clear_all),
              onTap: () {
                Navigator.pop(context);
                ref.read(downloadManagerProvider.notifier).clearCompletedDownloads();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completed downloads cleared')),
                );
              },
            ),
            ListTile(
              title: const Text('Download over Wi-Fi only'),
              subtitle: const Text('Save mobile data'),
              leading: const Icon(Icons.wifi),
              onTap: () {
                Navigator.pop(context);
                // TODO: Toggle Wi-Fi only setting
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DownloadsContent extends ConsumerWidget {
  const DownloadsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Storage overview
          _buildStorageOverview(context, ref),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Subject-based downloads
          Text(
            'Subject Downloads',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          // English Downloads
          _buildSubjectDownloadSection(
            context,
            'English',
            Icons.language,
            Colors.blue,
            [
              _buildDownloadItem('English Grammar Guide', 'Complete grammar rules and examples', '150 MB', Icons.book),
              _buildDownloadItem('Reading Comprehension Pack', 'Practice passages and questions', '200 MB', Icons.article),
              _buildDownloadItem('Creative Writing Templates', 'Story and essay writing guides', '100 MB', Icons.edit),
              _buildDownloadItem('Vocabulary Builder', 'Word lists and flashcards', '80 MB', Icons.style),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Gujarati Downloads
          _buildSubjectDownloadSection(
            context,
            'ગુજરાતી (Gujarati)',
            Icons.book,
            Colors.green,
            [
              _buildDownloadItem('ગુજરાતી વ્યાકરણ', 'Complete Gujarati grammar guide', '120 MB', Icons.menu_book),
              _buildDownloadItem('કવિતા સંગ્રહ', 'Collection of Gujarati poems', '180 MB', Icons.auto_stories),
              _buildDownloadItem('વાર્તા સંગ્રહ', 'Gujarati stories collection', '250 MB', Icons.library_books),
              _buildDownloadItem('શબ્દકોશ', 'Gujarati dictionary and vocabulary', '90 MB', Icons.translate),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Hindi Downloads
          _buildSubjectDownloadSection(
            context,
            'हिंदी (Hindi)',
            Icons.menu_book,
            Colors.orange,
            [
              _buildDownloadItem('हिंदी व्याकरण', 'Complete Hindi grammar guide', '140 MB', Icons.book),
              _buildDownloadItem('कहानी संग्रह', 'Collection of Hindi stories', '220 MB', Icons.auto_stories),
              _buildDownloadItem('कविता संग्रह', 'Hindi poetry collection', '160 MB', Icons.article),
              _buildDownloadItem('शब्दकोश', 'Hindi dictionary and vocabulary', '95 MB', Icons.translate),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Math Downloads
          _buildSubjectDownloadSection(
            context,
            'Mathematics',
            Icons.calculate,
            Colors.red,
            [
              _buildDownloadItem('Math Formulas Guide', 'Complete formula reference', '60 MB', Icons.functions),
              _buildDownloadItem('Problem Solving Pack', 'Step-by-step solutions', '180 MB', Icons.psychology),
              _buildDownloadItem('Geometry Visual Guide', 'Interactive geometry concepts', '120 MB', Icons.shape_line),
              _buildDownloadItem('Math Practice Sheets', 'Printable worksheets', '90 MB', Icons.description),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Science Downloads
          _buildSubjectDownloadSection(
            context,
            'Science',
            Icons.science,
            Colors.purple,
            [
              _buildDownloadItem('Science Experiments', 'Lab experiments and procedures', '200 MB', Icons.science),
              _buildDownloadItem('Biology Diagrams', 'Anatomy and plant diagrams', '150 MB', Icons.eco),
              _buildDownloadItem('Chemistry Periodic Table', 'Interactive periodic table', '40 MB', Icons.grid_view),
              _buildDownloadItem('Physics Simulations', 'Physics concept animations', '180 MB', Icons.play_circle),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Social Studies Downloads
          _buildSubjectDownloadSection(
            context,
            'Social Studies',
            Icons.public,
            Colors.brown,
            [
              _buildDownloadItem('Indian History Timeline', 'Complete historical timeline', '160 MB', Icons.timeline),
              _buildDownloadItem('Geography Maps', 'Political and physical maps', '120 MB', Icons.map),
              _buildDownloadItem('Civics Guide', 'Government and constitution', '100 MB', Icons.account_balance),
              _buildDownloadItem('Cultural Heritage', 'Indian culture and traditions', '140 MB', Icons.temple_hindu),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Quick download options
          Text(
            'Quick Downloads',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildQuickDownloadCard(
            context,
            'All Subjects Complete Pack',
            'Download all subjects at once',
            '2.5 GB',
            Icons.download,
            Colors.indigo,
            () {
              _showDownloadConfirmation(context, 'All Subjects Complete Pack', '2.5 GB');
            },
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          _buildQuickDownloadCard(
            context,
            'Offline Quiz Pack',
            'All quizzes for offline practice',
            '800 MB',
            Icons.quiz,
            Colors.teal,
            () {
              _showDownloadConfirmation(context, 'Offline Quiz Pack', '800 MB');
            },
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Downloaded content
          Text(
            'Downloaded Content',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildDownloadedContent(context, ref),
        ],
      ),
    );
  }

  Widget _buildStorageOverview(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storage Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildStorageItem(
                    context,
                    'Downloaded',
                    '1.2 GB',
                    Icons.download_done,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStorageItem(
                    context,
                    'Available',
                    '8.8 GB',
                    Icons.storage,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageItem(
    BuildContext context,
    String title,
    String size,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          size,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectDownloadSection(
    BuildContext context,
    String subjectName,
    IconData subjectIcon,
    Color subjectColor,
    List<Widget> downloadItems,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(subjectIcon, color: subjectColor, size: 24),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  subjectName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: subjectColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...downloadItems,
            const SizedBox(height: AppTheme.spacingM),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showDownloadConfirmation(context, '$subjectName Complete Pack', '500 MB');
                },
                icon: const Icon(Icons.download),
                label: Text('Download All $subjectName Content'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: subjectColor,
                  side: BorderSide(color: subjectColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadItem(
    String title,
    String description,
    String size,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            size,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          IconButton(
            onPressed: () {
              // TODO: Download individual item
            },
            icon: const Icon(Icons.download, size: 18),
            tooltip: 'Download',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDownloadCard(
    BuildContext context,
    String title,
    String description,
    String size,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    size,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const Icon(Icons.download, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadedContent(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadManagerProvider);
    
    if (downloads.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            children: [
              Icon(
                Icons.download_done,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'No Downloads Yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Download content to access it offline',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: downloads.values.map((download) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(download.status).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(download.status),
                color: _getStatusColor(download.status),
              ),
            ),
            title: Text(download.asset.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${download.progress.toStringAsFixed(1)}%'),
                if (download.status == DownloadStatus.downloading)
                  LinearProgressIndicator(
                    value: download.progress / 100,
                    backgroundColor: Colors.grey.shade300,
                  ),
              ],
            ),
            trailing: Text(
              _getStatusText(download.status),
              style: TextStyle(
                color: _getStatusColor(download.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.downloading:
        return Colors.blue;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.paused:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.downloading:
        return Icons.download;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.paused:
        return Icons.pause_circle;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.completed:
        return 'Completed';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.paused:
        return 'Paused';
      default:
        return 'Unknown';
    }
  }

  void _showDownloadConfirmation(BuildContext context, String title, String size) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Download'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Download: $title'),
            const SizedBox(height: AppTheme.spacingS),
            Text('Size: $size'),
            const SizedBox(height: AppTheme.spacingS),
            const Text('This will download content for offline use.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting download: $title')),
              );
              // TODO: Start actual download
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}