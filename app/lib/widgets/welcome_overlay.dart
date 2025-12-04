import 'package:flutter/material.dart';
import '../theme/cybersecurity_theme.dart';

class WelcomeOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const WelcomeOverlay({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(24.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: CybersecurityTheme.backgroundGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CybersecurityTheme.primaryRed.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: CybersecurityTheme.neonShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bem-vindo ao RedTeam32',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: CybersecurityTheme.primaryRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '\nRedTeam32 é uma ferramenta open-source para pentest mobile usando do microcontrolador ESP32 e algum firmware auxiliar, bem como o Marauder. \n\n Essa ferramenta foi desenvolvida por pesquisadores do Centro de Excelência em Redes Inteligentes sem fio e Serviços Avançados da Universidade Federal de Goiás (CERISE-UFG). \n Para saber mais, acesse: github.com/pedrocsf/RedTeam32',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
