import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/providers.dart';
import '../domain/facility_models.dart';
import '../core/logger_service.dart';

class FacilitiesScreen extends ConsumerWidget {
  const FacilitiesScreen({super.key});
  final List<String> _locations = const ['Cevahir', 'Kavacik', 'Izmir'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final facilitiesAsync = ref.watch(facilitiesProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedLocation,
            decoration: InputDecoration(
              labelText: 'Select Branch Location',
              labelStyle: TextStyle(color: theme.colorScheme.primary),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              prefixIcon:
                  Icon(Icons.location_city, color: theme.colorScheme.secondary),
            ),
            dropdownColor: Colors.white,
            items: _locations
                .map((loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc,
                        style: const TextStyle(fontWeight: FontWeight.w500))))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(selectedLocationProvider.notifier).state = value;
                ref
                    .read(loggerProvider)
                    .log('Location changed to $value', level: LogLevel.warning);
              }
            },
          ),
        ),
        Expanded(
          child: facilitiesAsync.when(
            loading: () => Center(
                child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary)),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (categories) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: Text(category.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            fontSize: 16)),
                    leading: Icon(Icons.folder_open,
                        color: theme.colorScheme.secondary),
                    // We map through the items to show the new large image cards
                    children: category.items
                        .map((item) => _buildFacilityCard(item, theme, ref))
                        .toList(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityCard(FacilityItem item, ThemeData theme, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior:
          Clip.antiAlias, // Ensures the image respects the rounded corners
      color: Colors.white,
      child: InkWell(
        onTap: () {
          ref
              .read(loggerProvider)
              .log('Viewed Facility: ${item.title}', level: LogLevel.info);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large Image Header
            SizedBox(
              height: 160,
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported,
                          size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(item.imageAsset,
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12))
                    ],
                  ),
                ),
              ),
            ),
            // Text & Staff Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.colorScheme.primary)),
                  const SizedBox(height: 6),
                  Text(item.description,
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.4)),

                  // Staff Section (Only shows if there are staff, e.g., the Workers category)
                  if (item.staff.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200, height: 1),
                    const SizedBox(height: 12),
                    Text('Team Members:',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.staff
                          .map((person) => Chip(
                                side: BorderSide.none,
                                backgroundColor: theme.scaffoldBackgroundColor,
                                avatar: CircleAvatar(
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Text(person.name[0],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10))),
                                label: Text(
                                    '${person.name} (${person.roleOrStatus})',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.primary)),
                              ))
                          .toList(),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
