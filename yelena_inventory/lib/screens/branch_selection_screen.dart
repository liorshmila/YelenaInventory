import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import 'employee_selection_screen.dart';

class BranchSelectionScreen extends ConsumerWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('בחר סניף')),
      body: branchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'לא הצלחנו לטעון את רשימת הסניפים.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'בדוק שהשרת פעיל ונסה שוב.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(branchesProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return const Center(child: Text('אין סניפים להצגה'));
          }

          return ListView.builder(
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];

              return _BranchTile(
                branch: branch,
                onTap: () {
                  ref
                      .read(selectedBranchProvider.notifier)
                      .selectBranch(branch);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeSelectionScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _BranchTile extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;

  const _BranchTile({required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.business),
      title: Text(branch.name),
      subtitle: Text('Id: ${branch.id}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
