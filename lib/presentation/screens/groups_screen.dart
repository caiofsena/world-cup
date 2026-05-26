import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../providers/tournament_providers.dart';
import '../widgets/group_standing_card.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Copa do Mundo 2026'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
            tooltip: 'Calendário',
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('Nenhum grupo encontrado'));
          }

          final sortedGroups = List.of(groups)
            ..sort((a, b) => a.letter.compareTo(b.letter));

          return RefreshIndicator(
            onRefresh: () => ref.refresh(groupsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: sortedGroups.length,
              itemBuilder: (context, index) {
                final group = sortedGroups[index];
                return GroupStandingCard(
                  groupLetter: group.letter,
                  onTap: () => context.push(
                    '/home/group/${group.letter}',
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar dados: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(groupsProvider.future),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
