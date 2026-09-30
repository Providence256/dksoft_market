import 'package:dksoft_market/common/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders an [AsyncValue] with sensible defaults.
///
/// Pass a skeleton as [loading] (see `common/skeleton/skeleton_layouts.dart`)
/// so the loading state mirrors the final layout. Without it, a centered
/// spinner is shown, as before.
class AsyncValueWidget<T> extends StatefulWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;

  /// Widget shown while the value is loading (typically a skeleton).
  final Widget? loading;

  @override
  State<AsyncValueWidget<T>> createState() => _AsyncValueWidgetState<T>();
}

class _AsyncValueWidgetState<T> extends State<AsyncValueWidget<T>> {
  // Fade the content in only when it replaces a loading state, so cached
  // data still appears instantly.
  bool _hasShownLoading = false;

  @override
  Widget build(BuildContext context) {
    return widget.value.when(
      data: (value) {
        final child = widget.data(value);
        return _hasShownLoading ? _FadeIn(child: child) : child;
      },
      error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
      loading: () {
        _hasShownLoading = true;
        return widget.loading ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: child,
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
    );
  }
}

/// Sliver equivalent of [AsyncValueWidget]
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;

  /// Box widget (not a sliver) shown while loading, e.g. a skeleton.
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => SliverToBoxAdapter(
        child: Center(child: ErrorMessageWidget(e.toString())),
      ),
      loading: () => SliverToBoxAdapter(
        child: loading ?? const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
