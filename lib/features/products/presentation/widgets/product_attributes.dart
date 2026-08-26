import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/helpers/attribute_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductAttributes extends ConsumerStatefulWidget {
  const ProductAttributes({super.key, required this.product});

  final ProductModal product;

  @override
  ConsumerState<ProductAttributes> createState() => _ProductAttributesState();
}

class _ProductAttributesState extends ConsumerState<ProductAttributes> {
  @override
  void initState() {
    super.initState();
    final attributes = widget.product.attributs;
    if (attributes.isNotEmpty) {
      final defaultSelection = <String, String>{};
      for (final attribute in attributes) {
        if (attribute.values != null && attribute.values!.isNotEmpty) {
          defaultSelection[attribute.name!] = attribute.values!.first;
        }
      }

      // Defer until after the first frame so we're not writing to a
      // provider mid-build.
      Future.microtask(() {
        final selectedAttributes = ref.read(
          selectedAttributesProvider.notifier,
        );
        final variationProvider = ref.read(selectedVariationProvider.notifier);

        selectedAttributes.state = defaultSelection;
        variationProvider.onAttributeSelected(widget.product, defaultSelection);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attributes = widget.product.attributs;
    if (attributes.isEmpty) return const SizedBox.shrink();

    final selectedAttributes = ref.watch(selectedAttributesProvider);
    final selectedVariations = ref.watch(selectedVariationProvider.notifier);
    final variations = widget.product.variations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: attributes.map((attribute) {
        final name = attribute.name!;
        final values = attribute.values ?? [];
        final availableValues = selectedVariations.getAttributesAvailability(
          variations,
          name,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: values.map((value) {
                final swatch = AttributeColor.getColor(value);
                final selected = selectedAttributes[name] == value;
                final available = availableValues.contains(value);

                void select(bool _) {
                  final updated = Map<String, String>.from(selectedAttributes);
                  updated[name] = value;
                  ref.read(selectedAttributesProvider.notifier).state = updated;
                  selectedVariations.onAttributeSelected(
                    widget.product,
                    updated,
                  );
                }

                return swatch != null
                    ? _ColorOption(
                        color: swatch,
                        label: value,
                        selected: selected,
                        available: available,
                        onSelected: available ? select : null,
                      )
                    : _ChipOption(
                        label: value,
                        selected: selected,
                        available: available,
                        onSelected: available ? select : null,
                      );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Rounded-rect chip for non-color attribute values (Size, Storage,
/// Material, ...).
class _ChipOption extends StatelessWidget {
  const _ChipOption({
    required this.label,
    required this.selected,
    required this.available,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final bool available;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: available ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: onSelected == null ? null : () => onSelected!(true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              decoration: available ? null : TextDecoration.lineThrough,
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular swatch for color attribute values, with a tooltip so the
/// color name is still accessible.
class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.color,
    required this.label,
    required this.selected,
    required this.available,
    required this.onSelected,
  });

  final Color color;
  final String label;
  final bool selected;
  final bool available;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: available ? label : '$label — out of stock',
      child: Opacity(
        opacity: available ? 1.0 : 0.35,
        child: GestureDetector(
          onTap: onSelected == null ? null : () => onSelected!(true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withValues(alpha: 0.4),
                width: selected ? 3 : 1,
              ),
            ),
            child: !available
                ? const Icon(Icons.close, size: 16, color: Colors.white70)
                : null,
          ),
        ),
      ),
    );
  }
}
