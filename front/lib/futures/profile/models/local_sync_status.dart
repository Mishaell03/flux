class LocalSyncStatus {
  final int localItemsCount;
  final int pendingItemsCount;

  const LocalSyncStatus({
    required this.localItemsCount,
    required this.pendingItemsCount,
  });

  const LocalSyncStatus.empty()
      : localItemsCount = 0,
        pendingItemsCount = 0;

  bool get hasPendingChanges => pendingItemsCount > 0;
}
