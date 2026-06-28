import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/branch_provider.dart';

class BranchesScreen extends ConsumerWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('סניפים'),
      ),
      body: branchesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(error.toString()),
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return const Center(
              child: Text('אין סניפים'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(branchesProvider);
              await ref.read(branchesProvider.future);
            },
            child: ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];

                return ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(branch.name),
                  subtitle: Text('Id: ${branch.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}