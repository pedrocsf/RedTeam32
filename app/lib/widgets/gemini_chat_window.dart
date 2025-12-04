import 'package:app/theme/cybersecurity_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/gemini_service.dart';
import '../screens/chat_screen.dart';

class GeminiChatWindow extends StatefulWidget {
  final GeminiService geminiService;
  final List<ChatMessage> espMessages;
  final VoidCallback onClose;

  const GeminiChatWindow({
    Key? key,
    required this.geminiService,
    required this.espMessages,
    required this.onClose,
  }) : super(key: key);

  @override
  _GeminiChatWindowState createState() => _GeminiChatWindowState();
}

class _GeminiChatWindowState extends State<GeminiChatWindow> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  double _windowWidth = 0;
  double _windowHeight = 0;
  double _windowX = 0;
  double _windowY = 0;
  bool _isDragging = false;
  bool _isResizing = false;

  // Opções de resposta
  bool _shortResponseMode = true; // Modo resposta curta ativado por padrão
  String _responseMode = 'normal'; // 'normal', 'short', 'command'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _windowWidth = screenSize.width * 0.8;
        _windowHeight = screenSize.height * 0.6;
        _windowX = (screenSize.width - _windowWidth) / 2;
        _windowY = (screenSize.height - _windowHeight) / 2;
      });
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add({'text': userMessage, 'isUser': 'true'});
    });

    // Mostrar indicador de carregamento
    setState(() {
      _messages.add({'text': 'Processando...', 'isUser': 'false'});
    });

    // Pegar as últimas 5 mensagens do chat ESP32 para contexto
    final recentESPContext = widget.espMessages.isNotEmpty
        ? widget.espMessages.reversed
              .take(5)
              .map((m) => "${m.isFromUser ? 'Usuário' : 'ESP32'}: ${m.message}")
              .join("\n")
        : "Nenhum contexto do ESP32 disponível";

    final contextMessage = widget.espMessages.isNotEmpty
        ? "Contexto recente do chat com ESP32:\n$recentESPContext\n\nPergunta do usuário: $userMessage"
        : "Pergunta do usuário: $userMessage";

    // Escolher método baseado no modo de resposta
    String response;
    switch (_responseMode) {
      case 'short':
        response = await widget.geminiService.getShortResponse(
          contextMessage,
          maxChars: 300,
        );
        break;
      case 'command':
        response = await widget.geminiService.getCommandOnly(contextMessage);
        break;
      default:
        response = await widget.geminiService.processUserMessage(
          contextMessage,
          "",
        );
    }

    // Remover o indicador de carregamento e adicionar a resposta
    setState(() {
      _messages.removeLast(); // Remove "Processando..."
      _messages.add({'text': response, 'isUser': 'false'});
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_windowWidth == 0 || _windowHeight == 0) {
      return Container(); // Aguarda inicialização
    }

    return Positioned(
      left: _windowX,
      top: _windowY,
      child: Container(
        width: _windowWidth,
        height: _windowHeight,
        child: Stack(
          children: [
            // Janela principal
            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  // Barra de título (área arrastável)
                  GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        setState(() {
                          _windowX += details.delta.dx;
                          _windowY += details.delta.dy;

                          // Limites da tela
                          final screenSize = MediaQuery.of(context).size;
                          _windowX = _windowX.clamp(
                            0.0,
                            screenSize.width - _windowWidth,
                          );
                          _windowY = _windowY.clamp(
                            0.0,
                            screenSize.height - _windowHeight,
                          );
                        });
                      }
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      color: CybersecurityTheme.primaryRed,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.drag_handle,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 16),
                              PopupMenuButton<String>(
                                icon: Icon(
                                  _responseMode == 'normal'
                                      ? Icons.chat_bubble_outline
                                      : _responseMode == 'short'
                                      ? Icons.short_text
                                      : Icons.code,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onSelected: (String value) {
                                  setState(() {
                                    _responseMode = value;
                                    _shortResponseMode = value != 'normal';
                                  });
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'normal',
                                    child: Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline),
                                        SizedBox(width: 8),
                                        Text('Resposta Normal'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'short',
                                    child: Row(
                                      children: [
                                        Icon(Icons.short_text),
                                        SizedBox(width: 8),
                                        Text('Resposta Curta'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'command',
                                    child: Row(
                                      children: [
                                        Icon(Icons.code),
                                        SizedBox(width: 8),
                                        Text('Apenas Comando'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Conteúdo do chat
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUser = message['isUser'] == 'true';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color.fromARGB(137, 224, 36, 36)
                                  : const Color.fromARGB(132, 0, 0, 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: _windowWidth * 0.7,
                            ),
                            child: Text(
                              message['text']!,
                              style: GoogleFonts.robotoMono(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Digite sua mensagem...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton(
                          mini: true,
                          child: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isResizing = true;
                    });
                  },
                  onPanUpdate: (details) {
                    if (_isResizing) {
                      setState(() {
                        _windowHeight += details.delta.dy;

                        _windowHeight = _windowHeight.clamp(
                          300.0,
                          MediaQuery.of(context).size.height - _windowY,
                        );
                      });
                    }
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isResizing = false;
                    });
                  },
                  child: Container(
                    height: 20,
                    color: _isResizing
                        ? CybersecurityTheme.primaryRed.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.1),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _isResizing
                              ? CybersecurityTheme.primaryRed
                              : Colors.grey[500],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
