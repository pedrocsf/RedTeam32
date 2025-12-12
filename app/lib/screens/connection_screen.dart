import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import '../services/gemini_service.dart';
import '../widgets/gemini_chat_window.dart';
import '../widgets/welcome_overlay.dart';
import '../theme/cybersecurity_theme.dart';
import 'package:app/l10n/app_localizations.dart';
class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with TickerProviderStateMixin {
  String _status = "";
  List<UsbDevice> _devices = [];
  bool _showWelcomeOverlay = false;
  bool _showGeminiChat = false;
  bool _isScanning = false;
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;
  String? _apiKey;
  GeminiService? _geminiService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _promptApiKey(context);
      _getPorts(); // Movido para cá para ter acesso ao contexto seguro
    });
    // Animações
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_status.isEmpty) {
      _status = AppLocalizations.of(context)!.statusDisconnected;
    }
  }

  Future<void> _promptApiKey(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedApiKey = prefs.getString('gemini_api_key');

    final apiKeyController = TextEditingController(text: storedApiKey);

    final newApiKey = await showDialog<String>(
      context: context,
      barrierDismissible: false, // O usuário deve fornecer uma chave
      builder: (context) => AlertDialog(
        backgroundColor: CybersecurityTheme.surfaceDark,
        title: Text(
          AppLocalizations.of(context)!.geminiApiKeyTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        content: TextField(
          controller: apiKeyController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterKeyHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (apiKeyController.text.isNotEmpty) {
                Navigator.of(context).pop(apiKeyController.text);
              }
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );

    if (newApiKey != null && newApiKey.isNotEmpty) {
      await prefs.setString('gemini_api_key', newApiKey);
      setState(() {
        _apiKey = newApiKey;
        _geminiService = GeminiService(apiKey: _apiKey!);
      });
    } else {
      // Se o usuário fechar ou não inserir, podemos fechar o app ou desabilitar a IA.
      // Por enquanto, vamos manter o estado sem a chave.
      setState(() {
        _status = AppLocalizations.of(context)!.apiKeyNeededStatus;
      });
    }
  }

  void _closeWelcomeOverlay() {
    setState(() {
      _showWelcomeOverlay = false;
    });
  }

  void _openWelcomeOverlay() {
    setState(() {
      _showWelcomeOverlay = true;
    });
  }

  void _getPorts() async {
    setState(() {
      _isScanning = true;
      _status = AppLocalizations.of(context)!.scanning;
    });

    _scanController.forward().then((_) {
      _scanController.reset();
    });

    List<UsbDevice> devices = await UsbSerial.listDevices();

    setState(() {
      _devices = devices;
      _isScanning = false;
      _status = devices.isEmpty
          ? AppLocalizations.of(context)!.noDevices
          : AppLocalizations.of(context)!.devicesFound;
    });
  }

  Future<void> _connectTo(UsbDevice device) async {
    try {
      setState(() {
        _status = AppLocalizations.of(context)!.connecting;
      });

      final port = await device.create();
      if (port == null || !await port.open()) {
        setState(() {
          _status = AppLocalizations.of(context)!.connectionFailed;
        });
        return;
      }

      await port.setDTR(true);
      await port.setRTS(true);
      await port.setPortParameters(
        115200,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      setState(() {
        _status = AppLocalizations.of(context)!.connectionEstablished;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatScreen(port: port, geminiService: _geminiService),
        ),
      );
    } catch (e) {
      setState(() {
        _status = AppLocalizations.of(context)!.errorPrefix(e.toString());
      });
    }
  }

  void _toggleGeminiChat() {
    setState(() {
      _showGeminiChat = !_showGeminiChat;
    });
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    IconData statusIcon;

    if (_status == AppLocalizations.of(context)!.connecting ||
        _status == AppLocalizations.of(context)!.scanning) {
      statusColor = CybersecurityTheme.accentRed;
      statusIcon = Icons.sync;
    } else if (_status == AppLocalizations.of(context)!.connectionEstablished) {
      statusColor = CybersecurityTheme.successGreen;
      statusIcon = Icons.check_circle;
    } else if (_status == AppLocalizations.of(context)!.connectionFailed) {
      statusColor = CybersecurityTheme.warningRed;
      statusIcon = Icons.error;
    } else if (_status == AppLocalizations.of(context)!.noDevices) {
      statusColor = CybersecurityTheme.textSecondary;
      statusIcon = Icons.search_off;
    } else if (_status == AppLocalizations.of(context)!.apiKeyNeededStatus) {
      statusColor = CybersecurityTheme.warningRed;
      statusIcon = Icons.vpn_key_off;
    } else {
      statusColor = CybersecurityTheme.primaryRed;
      statusIcon = Icons.devices;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: CybersecurityTheme.backgroundGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.3),
                blurRadius: 15 * _pulseAnimation.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.systemStatus,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceCard(UsbDevice device, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CybersecurityTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CybersecurityTheme.primaryRed.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: CybersecurityTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: CybersecurityTheme.neonGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.memory, color: Colors.black, size: 24),
        ),
        title: Text(
          device.productName ?? AppLocalizations.of(context)!.unknownDevice,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: CybersecurityTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          device.manufacturerName ??
              AppLocalizations.of(context)!.unknownManufacturer,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CybersecurityTheme.textSecondary,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            gradient: CybersecurityTheme.neonGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: CybersecurityTheme.primaryRed.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _connectTo(device),
            child: Text(
              AppLocalizations.of(context)!.connect.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RedTeam32'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.smart_toy_outlined,
              color: CybersecurityTheme.primaryRed,
            ),
            onPressed: _toggleGeminiChat,
            tooltip: _geminiService == null
                ? AppLocalizations.of(context)!.configureApiKey
                : AppLocalizations.of(context)!.aiAssistant,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CybersecurityTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Indicador de status
                _buildStatusIndicator(),

                // Título da seção de dispositivos
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.devices,
                        color: CybersecurityTheme.primaryRed,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.availableDevices,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),

                // Lista de dispositivos
                Expanded(
                  child: _devices.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            return _buildDeviceCard(_devices[index], index);
                          },
                        ),
                ),
              ],
            ),

            // Chat Gemini sobreposto
            if (_showGeminiChat && _geminiService != null)
              GeminiChatWindow(
                geminiService: _geminiService!,
                espMessages: [],
                onClose: _toggleGeminiChat,
              )
            else if (_showGeminiChat && _geminiService == null)
              _buildApiKeyNeededOverlay(),

            // Overlay de boas-vindas
            if (_showWelcomeOverlay)
              WelcomeOverlay(onClose: _closeWelcomeOverlay),

            // Botão de Informações
            Positioned(
              left: 16,
              bottom: 60,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                color: CybersecurityTheme.textSecondary,
                tooltip: AppLocalizations.of(context)!.aboutApp,
                onPressed: _openWelcomeOverlay,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: CybersecurityTheme.neonGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: CybersecurityTheme.neonShadow,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: _getPorts,
          child: AnimatedBuilder(
            animation: _scanController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _scanAnimation.value * 2 * 3.14159,
                child: const Icon(Icons.radar, color: Colors.black, size: 28),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildApiKeyNeededOverlay() {
    return GestureDetector(
      onTap: _toggleGeminiChat, // Fecha ao tocar fora
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CybersecurityTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CybersecurityTheme.warningRed),
            ),
            child: Text(
              AppLocalizations.of(context)!.apiKeyNeededMessage,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: CybersecurityTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noDevicesFoundTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: CybersecurityTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.connectDevicePrompt,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
