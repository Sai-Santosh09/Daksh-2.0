class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.daksh.com/v1';
  static const String manifestEndpoint = '/content/manifest';
  static const String healthEndpoint = '/health';
  
  // Download Configuration
  static const int maxConcurrentDownloads = 3;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 5);
  static const Duration networkTimeout = Duration(seconds: 30);
  
  // Cache Configuration
  static const Duration manifestCacheDuration = Duration(hours: 24);
  static const int maxCacheSize = 1024 * 1024 * 1024; // 1GB
  
  // Media Player Configuration
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  static const double defaultVolume = 1.0;
  static const double defaultPlaybackSpeed = 1.0;
  
  // UI Configuration
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Storage Configuration
  static const String cacheDirectoryName = 'content_cache';
  static const String downloadsDirectoryName = 'downloads';
  static const String preferencesKeyPrefix = 'daksh_';
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAutoDownload = false;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
  
  // Debug Configuration
  static const bool enableDebugLogs = true;
  static const bool enablePerformanceMonitoring = false;
  
  // Localization Configuration
  static const List<String> supportedLanguages = ['en', 'hi', 'te'];
  static const String defaultLanguage = 'en';
  
  // Accessibility Configuration
  static const double minTapTargetSize = 44.0;
  static const double maxFontScale = 2.0;
  
  // Network Configuration
  static const bool requireWifiForDownloads = false;
  static const bool enableBackgroundSync = true;
  
  // Security Configuration
  static const bool enableCertificatePinning = false;
  static const bool enableEncryption = true;
  
  // Performance Configuration
  static const int maxImageCacheSize = 100;
  static const Duration imageCacheExpiration = Duration(days: 7);
  
  // Error Handling Configuration
  static const int maxErrorRetries = 3;
  static const Duration errorRetryDelay = Duration(seconds: 2);
  
  // Development Configuration
  static const bool isDevelopment = true;
  static const bool enableHotReload = true;
  static const bool enableDevTools = true;
}


