import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../application/providers.dart';
import '../domain/models.dart';
import '../core/logger_service.dart';

class PromosScreen extends ConsumerStatefulWidget {
  const PromosScreen({super.key});

  @override
  ConsumerState<PromosScreen> createState() => _PromosScreenState();
}

class _PromosScreenState extends ConsumerState<PromosScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Start at a high number (3000) so the user can immediately swipe left.
    // viewportFraction 0.88 makes the cards slightly wider and bigger.
    _pageController = PageController(initialPage: 3000, viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPromoDetails(BuildContext context, Promo promo, ThemeData theme) {
    ref
        .read(loggerProvider)
        .log('Viewed Promo Details: ${promo.title}', level: LogLevel.info);
    final formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(promo.endTime);

    showDialog(
        context: context,
        barrierColor:
            Colors.black.withOpacity(0.2), // Lighter background shadow
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Lighter blur
            child: Dialog(
              backgroundColor:
                  Colors.white.withOpacity(0.65), // More transparent glass
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: Colors.white.withOpacity(0.8), width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Image.asset(
                            promo.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.white.withOpacity(0.5),
                              child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 50, color: Colors.grey)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.4),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white.withOpacity(
                          0.85), // Solidify the text area slightly for readability
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
                          Row(
                            children: [
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
                              child: Divider()),
                          Text('About this offer',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary)),
                          const SizedBox(height: 8),
                          Text(promo.detailedDescription,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.5)),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(loggerProvider).log(
                                    'Promo Claimed: ${promo.title}',
                                    level: LogLevel.warning);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            const Text(
                                                'Offer claimed successfully!'),
                                        backgroundColor:
                                            theme.colorScheme.secondary,
                                        behavior: SnackBarBehavior.floating));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('Claim Offer Now',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final promosAsync = ref.watch(promosProvider);
    final massageTypesAsync = ref.watch(massageTypesProvider);
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text('Exclusive Offers',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary)),
          ),
        ),

        // 1. Infinite Netflix-Style Horizontal Carousel (Bigger)
        promosAsync.when(
          loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
          data: (promos) {
            if (promos.isEmpty)
              return const SliverToBoxAdapter(child: SizedBox());

            return SliverToBoxAdapter(
              child: SizedBox(
                height: 420, // Increased height for bigger cards
                child: PageView.builder(
                  controller: _pageController,
                  // Removed itemCount to allow infinite scrolling
                  itemBuilder: (context, index) {
                    // Modulo math trick to loop through the list infinitely
                    final promo = promos[index % promos.length];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Card(
                        elevation:
                            6, // Slightly higher elevation for bigger cards
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(adminStatsProvider.notifier)
                                .incrementPromo();
                            _showPromoDetails(context, promo, theme);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.asset(promo.imageAsset,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        Container(color: Colors.grey.shade200)),
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(
                                    24.0), // More padding for the bigger card
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(promo.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: theme.colorScheme.primary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Text(promo.description,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 15),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        // 2. Massage Types Vertical List
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: Text('Our Massage Therapies',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary)),
          ),
        ),
        massageTypesAsync.when(
          loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
          data: (types) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final type = types[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                theme.colorScheme.secondary.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.colorScheme.secondary)),
                          const SizedBox(height: 6),
                          Text(type.benefits,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  );
                },
                childCount: types.length,
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 100 + MediaQuery.of(context).padding.bottom),
        ),
      ],
    );
  }
}
