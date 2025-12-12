import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import '../services/gemini_service.dart';
import '../widgets/gemini_chat_window.dart';
import '../theme/cybersecurity_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage {
  final String message;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isFromUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatScreen extends StatefulWidget {
  final UsbPort? port;
  final GeminiService? geminiService;

  const ChatScreen({Key? key, this.port, this.geminiService}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  bool _showGeminiChat = false;
  bool _isConnected = true;
  late AnimationController _connectionController;
  late Animation<Color?> _connectionAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.port != null) {
      _setupCommunication();
    }

    _connectionController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _connectionAnimation = ColorTween(
      begin: CybersecurityTheme
          .successGreen, // Mantido, pois o nome da cor é o mesmo
      end: CybersecurityTheme.successGreen.withOpacity(0.5), // Mantido
    ).animate(_connectionController);
  }

  void _setupCommunication() {
    if (widget.port == null) {
      _isConnected = false;
      return;
    }
    _transaction = Transaction.stringTerminated(
      widget.port!.inputStream!,
      Uint8List.fromList([13, 10]),
    );

    _subscription = _transaction!.stream.listen(
      (String line) {
        setState(() {
          _messages.add(
            ChatMessage(message: "ESP32: ${line.trim()}", isFromUser: false),
          );
        });
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _isConnected = false;
          if (mounted) {
            _messages.add(
              ChatMessage(
                message: AppLocalizations.of(
                  context,
                )!.connectionError(error.toString()),
                isFromUser: false,
              ),
            );
          }
        });
        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(message: message, isFromUser: true));
    });
    _messageController.clear();
    _scrollToBottom();

    if (widget.port == null || !_isConnected) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
            ChatMessage(
              message: AppLocalizations.of(context)!.mockResponse,
              isFromUser: false,
            ),
          );
          _scrollToBottom();
        });
      });
      return;
    }

    // Fluxo normal: envia a mensagem pela porta USB.
    try {
      await widget.port!.write(Uint8List.fromList('$message\r\n'.codeUnits));
    } catch (e) {
      setState(() {
        _isConnected = false;
        _messages.add(
          ChatMessage(
            message: AppLocalizations.of(context)!.sendFailure(e.toString()),
            isFromUser: false,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _toggleGeminiChat() {
    setState(() {
      _showGeminiChat = !_showGeminiChat;
    });
  }

  @override
  void dispose() {
    if (widget.port != null) {
      _subscription?.cancel();
      _transaction?.dispose();
    }
    _messageController.dispose();
    _scrollController.dispose();
    _connectionController.dispose();
    super.dispose();
  }

  Widget _buildConnectionStatus() {
    return AnimatedBuilder(
      animation: _connectionAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CybersecurityTheme.mediumGray,
            border: Border(
              bottom: BorderSide(
                color: const Color.fromARGB(190, 224, 36, 36),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isConnected
                      ? _connectionAnimation.value
                      : CybersecurityTheme.warningRed, // Mantido
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessage(ChatMessage message, int index) {
    final isUser = message.isFromUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // Mantido, pois warningRed é uma cor apropriada
                    CybersecurityTheme.warningRed,
                    CybersecurityTheme.warningRed.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.memory, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? CybersecurityTheme
                          .neonGradient // Alterado para o novo gradiente vermelho
                    : LinearGradient(
                        colors: [
                          CybersecurityTheme
                              .surfaceDark, // Alterado para a nova cor de superfície
                          CybersecurityTheme
                              .lightGray, // Alterado para o novo cinza claro
                        ],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isUser
                                ? CybersecurityTheme
                                      .primaryRed // Alterado para a sombra vermelha
                                : CybersecurityTheme.surfaceDark) // Mantido
                            .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isUser
                          ? Colors
                                .black // Cor para mensagem do usuário mantida
                          : CybersecurityTheme
                                .textPrimary, // Alterado para a nova cor de texto primário
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors
                                .black54 // Cor para timestamp do usuário mantida
                          : CybersecurityTheme
                                .textSecondary, // Alterado para a nova cor de texto secundário
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: CybersecurityTheme
                    .neonGradient, // Alterado para o novo gradiente vermelho
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.black, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RedTeam32')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) =>
                      _buildMessage(_messages[index], index),
                  itemCount: _messages.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.typeCommand,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      FloatingActionButton(
                        child: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        mini: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Botão flutuante para abrir o chat do Gemini
          Positioned(
            right: 10,
            bottom: 120,
            child: Tooltip(
              message: widget.geminiService == null
                  ? AppLocalizations.of(context)!.aiDisabled
                  : AppLocalizations.of(context)!.openAiAssistant,
              child: FloatingActionButton(
                onPressed: widget.geminiService != null
                    ? _toggleGeminiChat
                    : null,
                backgroundColor: widget.geminiService == null
                    ? CybersecurityTheme.mediumGray
                    : Theme.of(
                        context,
                      ).floatingActionButtonTheme.backgroundColor,
                child: const Icon(Icons.smart_toy_outlined),
              ),
            ),
          ),
          if (_showGeminiChat && widget.geminiService != null)
            GeminiChatWindow(
              geminiService: widget
                  .geminiService!, // This was already correct, but I'm confirming it.
              espMessages: _messages,
              onClose: _toggleGeminiChat,
            ),
        ],
      ),
    );
  }
}
