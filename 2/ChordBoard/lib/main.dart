import 'package:flutter/material.dart';
import 'package:custom_flutter_chord/custom_flutter_chord.dart';
// import 'package:device_info_plus/device_info_plus.dart'; // Removido por não ser o foco da solicitação atual

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chord Pro',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        hintColor: Colors.greenAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[800],
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.greenAccent, width: 3.0),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final chordStyle = TextStyle(fontSize: 20, color: Colors.greenAccent);
  final textStyle = TextStyle(fontSize: 18, color: Colors.white);
  String _lyrics = '';
  int transposeIncrement = 0;
  int scrollSpeed = 0;
  bool _isVerticalLayout = true;

  final TextEditingController _lyricsEditingController = TextEditingController();

  String? _selectedChordToAdd; // Acorde selecionado para ser adicionado

  // Novo: Controla a proporção do editor no layout vertical
  double _editorFlex = 0.5; // Começa com 50% do espaço

  final List<String> commonChords = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
    'Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m', 'Bm',
    'C7', 'D7', 'E7', 'F7', 'G7', 'A7', 'B7',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _lyrics = '''
[G]Me sinto [C]muito bem,
[G]Me sinto [C]muito bem,
[G]Me sinto [C]muito bem.
[D]Caminhando sob o [G]sol.

[G]Quero paz pra [C]vida,
[G]Quero amor sem [C]fim.
[G]Quero um novo [C]dia,
[D]Sempre perto de [G]mim.

{soc}
[C]Sei que a [G]vida [D]continua,
[C]E o [G]vento [D]vai soprar.
[C]Novos [G]caminhos [D]abrirão,
[Am]Pra gente [D]poder [G]andar.
{eoc}

[G]Nas [C]ondas do [G]mar,
[C]Eu encontro a [G]liberdade.
[C]O [D]coração a [G]cantar,
[Am]Cheio de [D]pura [G]felicidade.
''';
    _lyricsEditingController.text = _lyrics;
    _selectedChordToAdd = commonChords.first; // Define o primeiro acorde como padrão
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lyricsEditingController.dispose();
    super.dispose();
  }

  void _insertChord(String chord) {
    final text = _lyricsEditingController.text;
    final selection = _lyricsEditingController.selection;
    final newText = text.replaceRange(selection.start, selection.end, '[$chord]');
    _lyricsEditingController.text = newText;
    _lyricsEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.start + chord.length + 2),
    );
    setState(() {
      _lyrics = _lyricsEditingController.text;
    });
  }

  // Função para mostrar o diálogo de seleção de acordes
  void _showChordSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850], // Fundo escuro para o diálogo
          title: Text('Selecionar Acorde', style: TextStyle(color: Colors.white)),
          content: Container(
            width: double.maxFinite, // Permite que o diálogo seja largo
            child: GridView.builder(
              shrinkWrap: true, // Importante para o GridView dentro de um diálogo
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 4, // Ajusta o número de colunas
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.0, // Ajuste para dar mais largura para os itens (antes era 1.5)
              ),
              itemCount: commonChords.length,
              itemBuilder: (context, index) {
                final chord = commonChords[index];
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedChordToAdd = chord; // Define o acorde selecionado
                    });
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedChordToAdd == chord
                        ? Colors.green[700] // Cor diferente se for o selecionado
                        : Colors.teal[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4.0), // Ajuste de padding
                  ),
                  child: FittedBox( // Garante que o texto se ajuste ao espaço
                    fit: BoxFit.scaleDown,
                    child: Text(chord, style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Apenas fecha o diálogo
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chord Pro'),
        actions: [
          IconButton(
            icon: Icon(_isVerticalLayout ? Icons.horizontal_split : Icons.vertical_split),
            tooltip: _isVerticalLayout ? 'Mudar para Layout Horizontal' : 'Mudar para Layout Vertical',
            onPressed: () {
              setState(() {
                _isVerticalLayout = !_isVerticalLayout;
              });
            },
          ),
        ],
        bottom: _isVerticalLayout ? null : TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Editor'),
            Tab(text: 'Preview'),
          ],
        ),
      ),
      body: _isVerticalLayout ? _buildVerticalLayout() : _buildHorizontalLayout(),
    );
  }

  // --- Layout Vertical com Redimensionamento ---
  Widget _buildVerticalLayout() {
    return Column(
      children: [
        // Editor com flexibilidade ajustável
        Expanded(
          flex: (_editorFlex * 100).toInt(), // Multiplica por 100 para usar como int
          child: _buildEditorTab(),
        ),
        // Divisor arrastável
        GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              // Calcula a nova proporção com base no movimento do dedo
              _editorFlex += details.primaryDelta! / context.size!.height;
              // Garante que a proporção esteja entre 0.1 e 0.9 para evitar painéis muito pequenos
              _editorFlex = _editorFlex.clamp(0.1, 0.9);
            });
          },
          child: Container(
            height: 10, // Altura da "alça" do divisor
            color: Colors.grey[700], // Cor da alça
            child: Center(
              child: Icon(Icons.drag_handle, color: Colors.white54), // Ícone para indicar que é arrastável
            ),
          ),
        ),
        // Preview com flexibilidade ajustável (o restante do espaço)
        Expanded(
          flex: ((1.0 - _editorFlex) * 100).toInt(), // O resto do espaço
          child: _buildPreviewContent(),
        ),
      ],
    );
  }
  // --- Fim do Layout Vertical com Redimensionamento ---


  Widget _buildHorizontalLayout() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildEditorTab(),
        _buildPreviewContent(),
      ],
    );
  }

  Widget _buildEditorTab() {
    return Column(
      children: [
        Container(
          //color: Colors.grey[900],
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _selectedChordToAdd == null
                      ? null
                      : () {
                    _insertChord(_selectedChordToAdd!);
                  },
                  icon: Icon(Icons.add),
                  label: Text('Adicionar: ${_selectedChordToAdd ?? 'Nenhum'}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showChordSelectionDialog,
                  icon: Icon(Icons.arrow_drop_down),
                  label: Text('Escolher Acorde'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.grey[850],
            child: TextField(
              controller: _lyricsEditingController,
              style: textStyle,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Comece a escrever suas cifras aqui...',
                hintStyle: textStyle.copyWith(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _lyrics = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTransposeControl(),
              _buildScrollControl(),
            ],
          ),
        ),
        Divider(color: Colors.white38),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.black,
            child: LyricsRenderer(
              lyrics: _lyrics,
              textStyle: textStyle,
              chordStyle: chordStyle,
              onTapChord: (String chord) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Acorde tocado: $chord'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              onLyricsProcessed: (ChordLyricsDocument document) {
                // Lógica de processamento de letras/acordes pode ser adicionada aqui
              },
              transposeIncrement: transposeIncrement,
              scrollSpeed: scrollSpeed,
              widgetPadding: 24,
              lineHeight: 4,
              showText: true,
              showChord: true,
              minorScale: false,
              horizontalAlignment: CrossAxisAlignment.start,
              leadingWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Início da Música', style: chordStyle.copyWith(fontSize: 16)),
              ),
              trailingWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Fim da Música', style: chordStyle.copyWith(fontSize: 16)),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTransposeControl() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  transposeIncrement--;
                });
              },
              child: Text('-'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text('$transposeIncrement', style: textStyle),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  transposeIncrement++;
                });
              },
              child: Text('+'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text('Transpor', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildScrollControl() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: scrollSpeed <= 0
                  ? null
                  : () {
                setState(() {
                  scrollSpeed--;
                });
              },
              child: Text('-'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text('$scrollSpeed', style: textStyle),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scrollSpeed++;
                });
              },
              child: Text('+'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text('Rolagem Automática', style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}