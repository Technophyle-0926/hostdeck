import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmerLoading extends StatelessWidget {
  const DashboardShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar placeholder
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2x Account Overviews placeholder
          Row(
            children: [
              Expanded(
                child: _buildSkeletonCard(baseColor, highlightColor, 120),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSkeletonCard(baseColor, highlightColor, 120),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // "Aggregated Builds" Title placeholder
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 24,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List of Build placeholders
          _buildSkeletonCard(baseColor, highlightColor, 80),
          _buildSkeletonCard(baseColor, highlightColor, 80),
          _buildSkeletonCard(baseColor, highlightColor, 80),
          _buildSkeletonCard(baseColor, highlightColor, 80),
          _buildSkeletonCard(baseColor, highlightColor, 80),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard(
    Color baseColor,
    Color highlightColor,
    double height,
  ) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(16),
          // Add dummy internal blocks for realism
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 12,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(height: 12, width: 80, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsShimmerLoading extends StatelessWidget {
  const SettingsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  title: Container(height: 14, width: 120, color: Colors.white),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 12,
                      width: 200,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Container(
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          childCount: 5, // Show 5 dummy rows
        ),
      ),
    );
  }
}
