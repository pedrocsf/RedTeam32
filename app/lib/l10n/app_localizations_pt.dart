// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'CERISE';

  @override
  String get welcome => 'Bem-vindo';

  @override
  String get connect => 'Conectar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get connectionStatus => 'Status da Conexão';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get send => 'Enviar';

  @override
  String get statusDisconnected => 'DESCONECTADO';

  @override
  String get geminiApiKeyTitle => 'Chave da API do Gemini';

  @override
  String get enterKeyHint => 'Insira sua chave aqui';

  @override
  String get confirm => 'Confirmar';

  @override
  String get apiKeyNeededStatus => 'CHAVE API NECESSÁRIA';

  @override
  String get scanning => 'ESCANEANDO...';

  @override
  String get noDevices => 'NENHUM DISPOSITIVO';

  @override
  String get devicesFound => 'DISPOSITIVOS ENCONTRADOS';

  @override
  String get connecting => 'CONECTANDO...';

  @override
  String get connectionFailed => 'FALHA NA CONEXÃO';

  @override
  String get connectionEstablished => 'CONEXÃO ESTABELECIDA';

  @override
  String get systemStatus => 'STATUS DO SISTEMA';

  @override
  String get unknownDevice => 'DISPOSITIVO DESCONHECIDO';

  @override
  String get unknownManufacturer => 'FABRICANTE DESCONHECIDO';

  @override
  String get configureApiKey => 'Configure a API Key';

  @override
  String get aiAssistant => 'Assistente IA';

  @override
  String get availableDevices => 'DISPOSITIVOS DISPONÍVEIS';

  @override
  String get apiKeyNeededMessage =>
      'A chave da API do Gemini é necessária.\nReinicie o aplicativo para inseri-la.';

  @override
  String get noDevicesFoundTitle => 'NENHUM DISPOSITIVO ENCONTRADO';

  @override
  String get connectDevicePrompt =>
      'Conecte um dispositivo USB e toque no botão de escaneamento';

  @override
  String get processing => 'Processando...';

  @override
  String get noEspContext => 'Nenhum contexto do ESP32 disponível';

  @override
  String recentContext(Object context, Object question) {
    return 'Contexto recente do chat com ESP32:\n$context\n\nPergunta do usuário: $question';
  }

  @override
  String userQuestion(Object question) {
    return 'Pergunta do usuário: $question';
  }

  @override
  String get normalResponse => 'Resposta Normal';

  @override
  String get shortResponse => 'Resposta Curta';

  @override
  String get commandOnly => 'Apenas Comando';

  @override
  String connectionError(Object error) {
    return 'ERRO DE CONEXÃO: $error';
  }

  @override
  String get mockResponse => 'Resposta mock do ESP32.';

  @override
  String sendFailure(Object error) {
    return 'FALHA AO ENVIAR: $error';
  }

  @override
  String get typeCommand => 'Digite um comando...';

  @override
  String get aiDisabled => 'Assistente IA desativado (sem chave de API)';

  @override
  String get openAiAssistant => 'Abrir assistente IA';

  @override
  String get aboutApp => 'Sobre o App';

  @override
  String errorPrefix(Object error) {
    return 'ERRO: $error';
  }

  @override
  String get aiSystemPrompt =>
      'Você é um assistente inteligente especializado em pentest usando o firmware Marauder do ESP32. Seu objetivo é auxiliar o usuário a operar o Marauder, sugerindo comandos apropriados e explicando suas funções, sempre considerando o contexto do pentest que está sendo realizado no momento.\n\nIMPORTANTE: Mantenha suas respostas CONCISAS e DIRETAS. Máximo de 3-4 frases por resposta, focando no essencial.';

  @override
  String geminiApiError(Object message) {
    return 'Erro da API Gemini: $message';
  }

  @override
  String get connectionErrorCheckInternet =>
      'Erro de conexão: Verifique sua conexão com a internet e tente novamente.';

  @override
  String get geminiApiKeyInvalid =>
      'Erro: Chave da API do Gemini inválida ou expirada.';

  @override
  String unexpectedError(Object message) {
    return 'Erro inesperado: $message';
  }
}
