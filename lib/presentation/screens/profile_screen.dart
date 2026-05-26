import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_providers.dart';
import '../providers/prediction_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authState = ref.watch(authNotifierProvider);
    final isAuthLoading = user == null &&
        ref.watch(authStateChangesProvider) is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: isAuthLoading
          ? const Center(child: CircularProgressIndicator())
          : user != null
              ? _buildLoggedIn(context, ref, user)
              : _buildLoggedOut(context, ref, authState),
    );
  }

  Widget _buildLoggedIn(BuildContext context, WidgetRef ref, User user) {
    final predictionsAsync = ref.watch(userPredictionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 48,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : null,
            child: user.photoURL == null
                ? Text(
                    (user.displayName ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 36),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? 'Usuario',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? '',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.edit_note, size: 28, color: Colors.green),
                  const SizedBox(width: 16),
                  const Text('Total de palpites',
                      style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  predictionsAsync.when(
                    data: (predictions) => Text(
                      '${predictions.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const Text('-'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Sair',
                  style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOut(
      BuildContext context, WidgetRef ref, AsyncValue<void> authState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              'Entre para registrar seus palpites\ne acompanhar seu desempenho',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            if (authState.isLoading)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      ref.read(authNotifierProvider.notifier).signInWithGoogle(),
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Entrar com Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      ref.read(authNotifierProvider.notifier).signInWithApple(),
                  icon: const Icon(Icons.apple, size: 24),
                  label: const Text('Entrar com Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],

            if (authState.hasError) ...[
              const SizedBox(height: 16),
              Text(
                'Erro ao fazer login: ${authState.error}',
                style: const TextStyle(color: Colors.red, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
