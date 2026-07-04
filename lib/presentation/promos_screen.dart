import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Used for formatting the date nicely
import '../application/providers.dart';
import '../domain/models.dart';
import '../core/logger_service.dart';

class PromosScreen extends ConsumerWidget {
  const PromosScreen({super.key});

  // Function to show the detailed pop-up
  void _showPromoDetails(
      BuildContext context, WidgetRef ref, Promo promo, ThemeData theme) {
    // Log that the user opened the details
    ref
        .read(loggerProvider)
        .log('Viewed Promo Details: ${promo.title}', level: LogLevel.info);

    // Format the date (e.g., "05 July 2026, 14:30")
    final formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(promo.endTime);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            clipBehavior: Clip.antiAlias,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pop-up Image Header
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.asset(
                          promo.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: theme.scaffoldBackgroundColor,
                            child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    size: 50, color: Colors.grey)),
                          ),
                        ),
                      ),
                      // Close Button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Pop-up Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(promo.title,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                        const SizedBox(height: 16),

                        // Quota and Time Badges Row
                        Row(
                          children: [
                            // Quota Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: promo.remainingQuota < 5
                                    ? Colors.red.shade50
                                    : theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: promo.remainingQuota < 5
                                        ? Colors.red.shade200
                                        : theme.colorScheme.secondary
                                            .withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.local_fire_department,
                                      size: 16,
                                      color: promo.remainingQuota < 5
                                          ? Colors.redAccent
                                          : theme.colorScheme.secondary),
                                  const SizedBox(width: 6),
                                  Text('${promo.remainingQuota} Spots Left',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: promo.remainingQuota < 5
                                              ? Colors.redAccent
                                              : theme.colorScheme.secondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Expiry Date
                        Row(
                          children: [
                            Icon(Icons.timer_outlined,
                                size: 18, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text('Ends: $formattedDate',
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(),
                        ),

                        // Detailed Description
                        Text('About this offer',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                        const SizedBox(height: 8),
                        Text(promo.detailedDescription,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.5)),

                        const SizedBox(height: 32),

                        // Claim Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(loggerProvider).log(
                                  'Promo Claimed: ${promo.title}',
                                  level: LogLevel.warning);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('Offer claimed successfully!'),
                                backgroundColor: theme.colorScheme.secondary,
                                behavior: SnackBarBehavior.floating,
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Claim Offer Now',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promosAsync = ref.watch(promosProvider);
    final theme = Theme.of(context);

    return promosAsync.when(
      loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.secondary)),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (promos) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: promos.length,
          itemBuilder: (context, index) {
            final promo = promos[index];
            return Card(
              elevation: 3,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(bottom: 24),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                // Trigger the pop-up on tap
                onTap: () => _showPromoDetails(context, ref, promo, theme),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        promo.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.scaffoldBackgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text('Image: ${promo.imageAsset}',
                                  style: TextStyle(color: Colors.grey.shade500))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(promo.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: theme.colorScheme.primary)),
                          const SizedBox(height: 8),
                          Text(promo.description,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
