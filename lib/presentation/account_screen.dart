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
                    backgroundColor:
                        theme.colorScheme.primary, // Navy for Admin
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
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
                    backgroundColor:
                        theme.colorScheme.secondary, // Teal for User
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () =>
                      ref.read(authProvider.notifier).login(UserRole.user),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // LOGGED IN DASHBOARD VIEW
    final isCritical =
        account.massageCount < 2 && account.role != UserRole.admin;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello,',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  Text(account.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: 'Logout',
                onPressed: () => ref.read(authProvider.notifier).logout(),
              )
            ],
          ),
          const SizedBox(height: 32),

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
                    Text(
                        account.role == UserRole.admin
                            ? 'Unlimited'
                            : '${account.massageCount}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isCritical
                                ? Colors.redAccent
                                : theme.colorScheme.primary)),
                  ],
                ),
                ElevatedButton(
                  onPressed: (account.massageCount > 0 ||
                          account.role == UserRole.admin)
                      ? () => ref.read(authProvider.notifier).consumeMassage()
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12)),
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
                    Text(
                        account.role == UserRole.admin
                            ? 'Unlimited'
                            : '${account.hamamCount}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary)),
                  ],
                ),
                ElevatedButton(
                  onPressed:
                      (account.hamamCount > 0 || account.role == UserRole.admin)
                          ? () => ref.read(authProvider.notifier).consumeHamam()
                          : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12)),
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
