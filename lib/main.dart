import 'package:flutter/material.dart';

void main() {
  runApp(const EnRangoApp());
}

class EnRangoApp extends StatefulWidget {
  const EnRangoApp({super.key});

  @override
  State<EnRangoApp> createState() => _EnRangoAppState();
}

class _EnRangoAppState extends State<EnRangoApp> {
  bool loggedIn = false;
  String userName = 'María';
  String email = 'maria@ejemplo.com';

  final List<MedicalRecord> records = [
    MedicalRecord(
      type: 'Analítica',
      parameter: 'Colesterol total',
      value: 198,
      unit: 'mg/dL',
      date: DateTime(2026, 6, 20),
    ),
    MedicalRecord(
      type: 'Analítica',
      parameter: 'Colesterol total',
      value: 188,
      unit: 'mg/dL',
      date: DateTime(2026, 10, 14),
    ),
    MedicalRecord(
      type: 'Glucosa',
      parameter: 'Glucosa',
      value: 92,
      unit: 'mg/dL',
      date: DateTime(2026, 11, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnRango',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7E57C2)),
        scaffoldBackgroundColor: const Color(0xFFF7F6FA),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0xFFE8E2EF)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: loggedIn
          ? MainShell(
              userName: userName,
              email: email,
              records: records,
              onAddRecord: (record) => setState(() => records.add(record)),
              onDeleteRecord: (record) => setState(() => records.remove(record)),
              onLogout: () => setState(() => loggedIn = false),
            )
          : LoginPage(
              onLogin: (name, mail) {
                setState(() {
                  loggedIn = true;
                  userName = name.isEmpty ? 'María' : name;
                  email = mail.isEmpty ? 'maria@ejemplo.com' : mail;
                });
              },
            ),
    );
  }
}

class MedicalRecord {
  MedicalRecord({
    required this.type,
    required this.parameter,
    required this.value,
    required this.unit,
    required this.date,
    this.notes = '',
  });

  final String type;
  final String parameter;
  final double value;
  final String unit;
  final DateTime date;
  final String notes;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final void Function(String name, String email) onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: 'maria@ejemplo.com');
  final passwordController = TextEditingController(text: '123456');
  bool registerMode = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: EnRangoLogo()),
                    const SizedBox(height: 18),
                    Text(
                      registerMode ? 'Crear cuenta' : 'Bienvenido a EnRango',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Comprende tu salud',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 26),
                    if (registerMode) ...[
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => hidePassword = !hidePassword),
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => widget.onLogin(
                        nameController.text.trim(),
                        emailController.text.trim(),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: Text(
                        registerMode ? 'Crear cuenta' : 'Iniciar sesión',
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => registerMode = !registerMode),
                      child: Text(
                        registerMode
                            ? '¿Ya tienes cuenta? Inicia sesión'
                            : '¿No tienes cuenta? Regístrate',
                      ),
                    ),
                    const Text(
                      'Versión de demostración. Firebase se añadirá después.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.userName,
    required this.email,
    required this.records,
    required this.onAddRecord,
    required this.onDeleteRecord,
    required this.onLogout,
  });

  final String userName;
  final String email;
  final List<MedicalRecord> records;
  final ValueChanged<MedicalRecord> onAddRecord;
  final ValueChanged<MedicalRecord> onDeleteRecord;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 900;

    final pages = [
      HomePage(
        userName: widget.userName,
        records: widget.records,
        onOpenRegister: () => _openRegister(context),
        onOpenHistory: () => setState(() => index = 1),
      ),
      HistoryPage(
        records: widget.records,
        onDeleteRecord: widget.onDeleteRecord,
      ),
      ProfilePage(
        userName: widget.userName,
        email: widget.email,
        onLogout: widget.onLogout,
      ),
    ];

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (value) => setState(() => index = value),
              extended: MediaQuery.of(context).size.width >= 1150,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 22),
                child: EnRangoLogo(compact: true),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Perfil'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: pages[index]),
          ],
        ),
      );
    }

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterDataPage(
          onSave: (record) {
            widget.onAddRecord(record);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro guardado correctamente')),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.userName,
    required this.records,
    required this.onOpenRegister,
    required this.onOpenHistory,
  });

  final String userName;
  final List<MedicalRecord> records;
  final VoidCallback onOpenRegister;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EnRangoLogo(compact: true),
                const SizedBox(height: 26),
                Text(
                  'Hola, $userName',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '¿Qué quieres consultar hoy?',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 760 ? 4 : 2;
                    final width =
                        (constraints.maxWidth - (columns - 1) * 14) / columns;
                    return Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        ActionCard(
                          width: width,
                          icon: Icons.add_chart,
                          title: 'Registrar datos',
                          subtitle: 'Añade un nuevo resultado',
                          onTap: onOpenRegister,
                        ),
                        ActionCard(
                          width: width,
                          icon: Icons.history,
                          title: 'Historial',
                          subtitle: 'Consulta tus registros',
                          onTap: onOpenHistory,
                        ),
                        ActionCard(
                          width: width,
                          icon: Icons.menu_book_outlined,
                          title: 'Diccionario',
                          subtitle: 'Entiende términos médicos',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DictionaryPage(),
                            ),
                          ),
                        ),
                        ActionCard(
                          width: width,
                          icon: Icons.favorite_outline,
                          title: 'Consejos',
                          subtitle: 'Hábitos saludables',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdvicePage(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 26),
                Text(
                  'Resumen',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.monitor_heart_outlined),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            records.isEmpty
                                ? 'Todavía no tienes registros.'
                                : 'Tienes ${records.length} registros guardados.',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 165,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(child: Icon(icon)),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterDataPage extends StatefulWidget {
  const RegisterDataPage({super.key, required this.onSave});

  final ValueChanged<MedicalRecord> onSave;

  @override
  State<RegisterDataPage> createState() => _RegisterDataPageState();
}

class _RegisterDataPageState extends State<RegisterDataPage> {
  String type = 'Analítica';
  String parameter = 'Colesterol total';
  final valueController = TextEditingController();
  final notesController = TextEditingController();

  final parameters = const {
    'Colesterol total': 'mg/dL',
    'Glucosa': 'mg/dL',
    'Triglicéridos': 'mg/dL',
    'Hemoglobina': 'g/dL',
    'Presión sistólica': 'mmHg',
    'Presión diastólica': 'mmHg',
  };

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Registrar datos',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(labelText: 'Tipo de prueba'),
              items: const ['Analítica', 'Presión arterial', 'Glucosa', 'Otros']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => type = value!),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: parameter,
              decoration: const InputDecoration(labelText: 'Parámetro'),
              items: parameters.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => parameter = value!),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: valueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor',
                suffixText: parameters[parameter],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notas opcionales'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                final value =
                    double.tryParse(valueController.text.replaceAll(',', '.'));
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Introduce un valor válido')),
                  );
                  return;
                }
                widget.onSave(
                  MedicalRecord(
                    type: type,
                    parameter: parameter,
                    value: value,
                    unit: parameters[parameter]!,
                    date: DateTime.now(),
                    notes: notesController.text.trim(),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Guardar'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.records,
    required this.onDeleteRecord,
  });

  final List<MedicalRecord> records;
  final ValueChanged<MedicalRecord> onDeleteRecord;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.records]
      ..sort((a, b) => b.date.compareTo(a.date));

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Text(
                  'Historial',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Registros'),
              Tab(text: 'Gráficas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = sorted[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.description_outlined),
                        ),
                        title: Text(record.parameter),
                        subtitle: Text(
                          '${dateText(record.date)} · ${numberText(record.value)} ${record.unit}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              widget.onDeleteRecord(record);
                              setState(() {});
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ChartView(records: widget.records),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartView extends StatelessWidget {
  const ChartView({super.key, required this.records});

  final List<MedicalRecord> records;

  @override
  Widget build(BuildContext context) {
    final cholesterol = records
        .where((e) => e.parameter == 'Colesterol total')
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evolución · Colesterol total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 230,
                    child: cholesterol.isEmpty
                        ? const Center(child: Text('Sin datos disponibles'))
                        : CustomPaint(
                            painter: SimpleLineChartPainter(cholesterol),
                            child: Container(),
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (cholesterol.isNotEmpty)
                    Text(
                      'Último valor: ${numberText(cholesterol.last.value)} ${cholesterol.last.unit}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Esta información es orientativa y no sustituye la valoración de un profesional sanitario.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  SimpleLineChartPainter(this.records);

  final List<MedicalRecord> records;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    final line = Paint()
      ..color = const Color(0xFF7E57C2)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final dot = Paint()..color = const Color(0xFF7E57C2);

    canvas.drawLine(
      Offset(25, size.height - 25),
      Offset(size.width - 10, size.height - 25),
      axis,
    );
    canvas.drawLine(
      const Offset(25, 10),
      Offset(25, size.height - 25),
      axis,
    );

    final values = records.map((e) => e.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs() < 0.1 ? 1.0 : maxValue - minValue;

    final path = Path();
    for (var i = 0; i < records.length; i++) {
      final x = records.length == 1
          ? size.width / 2
          : 25 + i * (size.width - 45) / (records.length - 1);
      final normalized = (records[i].value - minValue) / range;
      final y = (size.height - 35) - normalized * (size.height - 65);
      final point = Offset(x, y);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(point, 5, dot);
    }
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) => true;
}

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String query = '';

  final terms = const {
    'Colesterol':
        'Sustancia grasa presente en la sangre que el organismo necesita para funcionar correctamente.',
    'Glucosa':
        'Azúcar que circula por la sangre y que el cuerpo utiliza como fuente de energía.',
    'Hipertensión':
        'Situación en la que la presión arterial se mantiene elevada de forma persistente.',
    'Triglicéridos':
        'Tipo de grasa presente en la sangre que procede de los alimentos y de la producción del propio organismo.',
    'Hemoglobina':
        'Proteína de los glóbulos rojos encargada de transportar oxígeno.',
    'Presión arterial':
        'Fuerza que ejerce la sangre sobre las paredes de las arterias.',
    'Saturación de oxígeno':
        'Porcentaje aproximado de hemoglobina que transporta oxígeno en la sangre.',
  };

  @override
  Widget build(BuildContext context) {
    final filtered = terms.entries
        .where((e) => e.key.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SimplePage(
      title: 'Diccionario médico',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                hintText: 'Buscar término...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 18),
            ...filtered.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Información educativa. No sustituye una consulta médica.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('Alimentación', Icons.restaurant_outlined,
          'Mantén una alimentación variada, incluye frutas y verduras y limita el exceso de ultraprocesados.'),
      ('Ejercicio', Icons.directions_run,
          'Realiza actividad física regular adaptada a tu situación y evita periodos muy largos de inactividad.'),
      ('Sueño', Icons.nightlight_outlined,
          'Intenta mantener horarios regulares y reduce pantallas y cafeína antes de dormir.'),
      ('Salud general', Icons.favorite_outline,
          'Mantén controles periódicos y consulta a un profesional ante síntomas o dudas importantes.'),
    ];

    return SimplePage(
      title: 'Consejos',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          children: [
            ...categories.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(18),
                    leading: CircleAvatar(child: Icon(item.$2)),
                    title: Text(
                      item.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(item.$3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Estos consejos son generales y no sustituyen las recomendaciones de un profesional sanitario.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
    required this.onLogout,
  });

  final String userName;
  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 44),
                ),
                const SizedBox(height: 14),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(email, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),
                const Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Editar perfil'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.tune),
                        title: Text('Preferencias'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.privacy_tip_outlined),
                        title: Text('Privacidad'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('Acerca de EnRango'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Center(child: child),
      ),
    );
  }
}

class EnRangoLogo extends StatelessWidget {
  const EnRangoLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 46 : 64,
          height: compact ? 46 : 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFFEC6FA8)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.favorite, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text(
          'EnRango',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
        ),
      ],
    );
  }
}

String dateText(DateTime date) {
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String numberText(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
