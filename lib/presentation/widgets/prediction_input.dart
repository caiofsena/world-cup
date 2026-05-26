import 'package:flutter/material.dart';

class PredictionInput extends StatefulWidget {
  final int? homeGoals;
  final int? awayGoals;
  final ValueChanged<(int, int)> onSave;

  const PredictionInput({
    this.homeGoals,
    this.awayGoals,
    required this.onSave,
  });

  @override
  State<PredictionInput> createState() => _PredictionInputState();
}

class _PredictionInputState extends State<PredictionInput> {
  late TextEditingController _homeController;
  late TextEditingController _awayController;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController(
      text: widget.homeGoals?.toString() ?? '',
    );
    _awayController = TextEditingController(
      text: widget.awayGoals?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu Palpite',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _homeController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'x',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _awayController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final home = int.tryParse(_homeController.text);
                  final away = int.tryParse(_awayController.text);
                  if (home != null && away != null) {
                    widget.onSave((home, away));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Salvar Palpite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
