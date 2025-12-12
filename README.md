# RedTeam32
Chat serial para pentest mobile por meio de microcontrolador externo (ex.: ESP32) e auxílio de IA (Gemini API).

O RedTeam32 é um aplicativo desenvolvido em Flutter que permite a comunicação direta entre o dispositivo
móvel e um microcontrolador conectado via cabo OTG. O aplicativo exibe um chat serial, possibilitando que
o usuário envie e receba comandos do microcontrolador. Além disso, o app oferece uma janela flutuante
opcional de assistência baseada na API Gemini, permitindo que o usuário obtenha ajuda na interpretação e
criação de comandos.
O RedTeam32 não coleta, armazena, compartilha ou transmite quaisquer dados pessoais do usuário.
Todas as informações trafegadas pelo aplicativo permanecem exclusivamente no dispositivo, salvo aquilo
que o próprio usuário decide enviar manualmente para o microcontrolador ou para a API Gemini.

Para debugar: 
flutter run -t app/lib/main.dart


<img width="120" height="120" alt="Gemini_Generated_Image_ikcnmmikcnmmikcn" src="https://github.com/user-attachments/assets/7d774955-7b5e-45d7-97af-f73be68cc327" />


## Estrutura da aplicação


lib/   
├── l10n/                          # Internacionalização (i18n)   
│   ├── app_en.arb                 # Strings em Inglês   
│   └── app_pt.arb                 # Strings em Português   
│      
├── screens/                       # Telas principais (Páginas)   
│   ├── chat_screen.dart           # Interface do terminal serial   
│   └── connection_screen.dart     # Escaneamento e conexão USB   
│  
├── services/                      # Lógica de Negócios e Integrações  
│   └── gemini_service.dart        # Integração com Google Gemini AI  
│  
├── theme/                         # Design System  
│   └── cybersecurity_theme.dart   # Estilos, cores e temas (Dark/Neon)  
│  
├── widgets/                       # Componentes Reutilizáveis  
│   ├── gemini_chat_window.dart    # Janela flutuante do assistente IA   
│   └── welcome_overlay.dart       # Modal de informações / boas-vindas  
│  
└── main.dart                      # Ponto de entrada e configuração do App  
