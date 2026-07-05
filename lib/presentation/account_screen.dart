import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/providers.dart';
import '../domain/models.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authProvider);
    final theme = Theme.of(context);

    // LOGIN VIEW
    if (account == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.spa_outlined,
                  size: 80, color: theme.colorScheme.secondary),
              const SizedBox(height: 24),
              Text('Welcome to Fabacco',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary)),
              const SizedBox(height: 8),
              Text('Sign in to manage your wellness journey.',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('Login as Admin',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  onPressed: () =>
                      ref.read(authProvider.notifier).login(UserRole.admin),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Login as Client',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  onPressed: () =>
                      ref.read(authProvider.notifier).login(UserRole.user),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // DASHBOARD ROUTER
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Hello, ${account.name}',
            style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () => ref.read(authProvider.notifier).logout()),
        ],
      ),
      // FIXED: We now pass 'context' into the helper functions
      body: account.role == UserRole.admin
          ? _buildAdminDashboard(context, ref, theme)
          : _buildUserDashboard(context, account, ref, theme),
    );
  }

  // --- ADMIN DASHBOARD ---
  // FIXED: Added BuildContext context to the parameters
  Widget _buildAdminDashboard(
      BuildContext context, WidgetRef ref, ThemeData theme) {
    final stats = ref.watch(adminStatsProvider);

    return SingleChildScrollView(
      // Now context works perfectly here!
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 100 + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Guest Analytics',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Massages\nUsed',
                      stats.totalMassagesUsed.toString(), Icons.spa, theme)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Hamam\nEntries',
                      stats.totalHamamUsed.toString(), Icons.hot_tub, theme)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      'Promo\nClicks',
                      stats.totalPromoClicks.toString(),
                      Icons.touch_app,
                      theme)),
            ],
          ),
          const SizedBox(height: 32),
          Text('System Notifications & Alerts',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary)),
          const SizedBox(height: 16),
          if (stats.alerts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Text('No new alerts. All quotas look good!',
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center),
            )
          else
            ...stats.alerts.map((alert) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200)),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(alert,
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.secondary, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary)),
          const SizedBox(height: 4),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // --- NORMAL USER DASHBOARD ---
  // FIXED: Added BuildContext context to the parameters
  Widget _buildUserDashboard(BuildContext context, AccountInfo account,
      WidgetRef ref, ThemeData theme) {
    final isCritical = account.massageCount < 2;

    return SingleChildScrollView(
      // Now context works perfectly here!
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 100 + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Your Wellness Quotas',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary)),
          const SizedBox(height: 16),

          // Massage Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
              border: Border.all(
                  color: isCritical ? Colors.red.shade300 : Colors.transparent,
                  width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Massages Left',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    Text('${account.massageCount}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isCritical
                                ? Colors.redAccent
                                : theme.colorScheme.primary)),
                  ],
                ),
                ElevatedButton(
                  onPressed: account.massageCount > 0
                      ? () => ref.read(authProvider.notifier).consumeMassage()
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Book Now'),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hamam Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hamam Entries',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    Text('${account.hamamCount}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary)),
                  ],
                ),
                ElevatedButton(
                  onPressed: account.hamamCount > 0
                      ? () => ref.read(authProvider.notifier).consumeHamam()
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Enter Hamam'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
