import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:app/l10n/app_localizations.dart';
class GeminiService {
  final GenerativeModel _model;
  late ChatSession _chat;
  final String initialPrompt = """
Você é um assistente inteligente especializado em pentest usando o firmware Marauder do ESP32. Seu objetivo é auxiliar o usuário a operar o Marauder, sugerindo comandos apropriados e explicando suas funções, sempre considerando o contexto do pentest que está sendo realizado no momento.

IMPORTANTE: Mantenha suas respostas CONCISAS e DIRETAS. Máximo de 3-4 frases por resposta, focando no essencial.
""";

  GeminiService({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          //maxOutputTokens:70,
          temperature: 0.7, // Controla criatividade
          topK: 40, // Considera apenas os 40 tokens mais prováveis
          topP:
              0.95, // Amostragem nucleus - considera tokens que somam 95% da probabilidade
        ),
      ) {
    _initializeChat();
  }

  void _initializeChat() {
    _chat = _model.startChat(history: [Content.text(initialPrompt)]);
  }

  Future<bool> testConnection() async {
    try {
      print("Testando conexão com Gemini...");
      print("Modelo: gemini-2.5-flash");

      final response = await _model.generateContent([Content.text("Teste")]);

      print("Resposta recebida: ${response.text?.isNotEmpty ?? false}");
      return response.text != null && response.text!.isNotEmpty;
    } on GenerativeAIException catch (e) {
      print("Erro da API Gemini: ${e.message}");
      return false;
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }

  Future<String> processUserMessage(
    String userMessage,
    String deviceResponse,
    AppLocalizations l10n,
  ) async {
    try {
      if (deviceResponse.isNotEmpty) {
        await _chat.sendMessage(
          Content.text("Resposta do ESP32: $deviceResponse"),
        );
      }

      // Adiciona instruções de brevidade ao prompt do usuário
      final enhancedUserMessage =
          "$userMessage\n\n[Responda de forma CONCISA em no máximo 3 frases]";

      final response = await _chat.sendMessage(
        Content.text(enhancedUserMessage),
      );

      final responseText =
          response.text ?? "Desculpe, não consegui processar sua solicitação.";

      // Limita o texto da resposta por caracteres como backup
      return _limitResponseLength(responseText, maxChars: 500);
    } on GenerativeAIException catch (e) {
      return l10n.geminiApiError(e.message);
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        return l10n.connectionErrorCheckInternet;
      } else if (e.toString().contains('API key')) {
        return l10n.geminiApiKeyInvalid;
      } else {
        return l10n.unexpectedError(e.toString());
      }
    }
  }

  // Método auxiliar para limitar o tamanho da resposta
  String _limitResponseLength(String text, {int maxChars = 500}) {
    if (text.length <= maxChars) return text;

    // Tenta cortar na última frase completa antes do limite
    String truncated = text.substring(0, maxChars);
    int lastPeriod = truncated.lastIndexOf('.');
    int lastExclamation = truncated.lastIndexOf('!');
    int lastQuestion = truncated.lastIndexOf('?');

    int lastSentenceEnd = [
      lastPeriod,
      lastExclamation,
      lastQuestion,
    ].reduce((a, b) => a > b ? a : b);

    if (lastSentenceEnd > maxChars * 0.7) {
      // Se encontrou uma frase a pelo menos 70% do limite
      return truncated.substring(0, lastSentenceEnd + 1);
    }

    // Caso contrário, corta e adiciona reticências
    return truncated.trim() + "...";
  }

  Future<String> getCommandForESP32(String assistantResponse) async {
    try {
      final response = await _chat.sendMessage(
        Content.text(
          "Por favor, gere apenas o comando que deve ser enviado ao ESP32 baseado na sua última resposta. "
          "Forneça apenas o comando, sem explicações adicionais.",
        ),
      );

      final command = response.text?.trim() ?? "";
      return command.endsWith('\\r\\n') ? command : command + '\\r\\n';
    } on GenerativeAIException catch (e) {
      print("Erro da API Gemini ao gerar comando: ${e.message}");
      return "";
    } catch (e) {
      print("Erro ao gerar comando para ESP32: $e");
      return "";
    }
  }

  void resetChat() {
    _initializeChat();
  }

  // Métodos para configurar limites dinamicamente
  void updateMaxTokens(int maxTokens) {
    // Nota: Para alterar maxTokens, seria necessário recriar o modelo
    // Este método serve como placeholder para futuras implementações
    print("Configurando limite máximo de tokens para: $maxTokens");
  }

  // Método para obter resposta com limite específico
  Future<String> getShortResponse(
    String userMessage, {
    required AppLocalizations l10n,
    int maxChars = 200,
  }) async {
    try {
      final shortPrompt =
          "$userMessage\n\n[RESPOSTA EM MÁXIMO 2 FRASES CURTAS]";
      final response = await _chat.sendMessage(Content.text(shortPrompt));
      final responseText = response.text ?? "Erro ao processar.";
      return _limitResponseLength(responseText, maxChars: maxChars);
    } catch (e) {
      return l10n.unexpectedError(e.toString());
    }
  }

  // Método para obter apenas comandos (muito curto)
  Future<String> getCommandOnly(String userMessage) async {
    try {
      final commandPrompt =
          "$userMessage\n\n[RESPONDA APENAS COM O COMANDO, SEM EXPLICAÇÕES]";
      final response = await _chat.sendMessage(Content.text(commandPrompt));
      final responseText = response.text?.trim() ?? "";

      // Para comandos, limite muito restritivo
      return _limitResponseLength(responseText, maxChars: 100);
    } catch (e) {
      return "";
    }
  }
}
