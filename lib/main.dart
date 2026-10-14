import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

void main() => runApp(const StudentPortfolioApp());

const purple = Color(0xFF7138C8);
const pink = Color(0xFFE83EE8);
const background = Color(0xFFFFF8FF);

class StudentPortfolioApp extends StatelessWidget {
  const StudentPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student E-Portfolio',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: purple),
          scaffoldBackgroundColor: background,
          appBarTheme: const AppBarTheme(
            backgroundColor: purple,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(email: email.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [purple, pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        ClipOval(
  child: Image.asset(
    'assets/profile_new.png',
    width: 108,
    height: 108,
    fit: BoxFit.cover,
  ),
),
                        const SizedBox(height: 22),
                        const Text(
                          'Geetha Jahnavi Maddala',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'STUDENT E-PORTFOLIO',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: inputDecoration(
                            'Email address',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            final text = (value ?? '').trim();
                            if (text.isEmpty) return 'Enter your email';
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(text)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: password,
                          obscureText: hidePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => login(),
                          decoration:
                              inputDecoration('Password', Icons.lock_outline)
                                  .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(
                                  () => hidePassword = !hidePassword),
                            ),
                          ),
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Enter a password';
                            }
                            if (value!.length < 4) {
                              return 'Use at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: purple,
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Use any valid email address and a password of at least 4 characters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

InputDecoration inputDecoration(String label, IconData icon) =>
    InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );

class DashboardPage extends StatelessWidget {
  final String email;
  const DashboardPage({super.key, required this.email});

  static const sections = [
    ('About Me & Education', Icons.person_outline),
    ('Technical Skills', Icons.computer_outlined),
    ('Projects', Icons.code_outlined),
    ('Certifications', Icons.workspace_premium_outlined),
    ('Activities & Volunteering', Icons.groups_outlined),
  ];

  static const pages = [
    AboutPage(),
    SkillsPage(),
    ProjectsPage(),
    CertificatesPage(),
    ActivitiesPage(),
  ];

  Future<void> logout(BuildContext context) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
    if (answer == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('My Portfolio'),
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 8),
               ClipOval(
  child: Image.asset(
    'assets/profile_new.png',
    width: 90,
    height: 90,
    fit: BoxFit.contain,
  ),
),
                const SizedBox(height: 14),
                const Text(
                  'Welcome, Geetha!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'B.Tech CSE Student',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(email,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 12)),
                const SizedBox(height: 24),
                for (int i = 0; i < sections.length; i++)
                  Card(
                    elevation: 3,
                    color: const Color(0xFFF8EFFB),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      leading: Icon(sections[i].$2, color: purple, size: 28),
                      title: Text(sections[i].$1,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => pages[i]),
                      ),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      );
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: purple, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(description,
                        style: const TextStyle(fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

Widget pageList(List<Widget> children) => ListView(
      padding: const EdgeInsets.all(18),
      children: children,
    );

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('About Me & Education')),
        body: pageList(const [
          InfoCard(
            title: 'About Me',
            icon: Icons.person,
            description:
                'I am Geetha Jahnavi Maddala, a B.Tech Computer Science and Engineering student. I enjoy learning programming, building practical applications, exploring new technologies, and collaborating on technical activities.',
          ),
          InfoCard(
            title: 'B.Tech — Computer Science and Engineering',
            icon: Icons.school,
            description:
                'Currently pursuing B.Tech in Computer Science and Engineering. Interested in software development, application development, problem solving, and emerging technologies.',
          ),
          InfoCard(
            title: 'Intermediate — 91%',
            icon: Icons.menu_book,
            description: 'Completed Intermediate education with 91%.',
          ),
          InfoCard(
            title: '10th Standard — 96%',
            icon: Icons.school_outlined,
            description: 'Completed 10th standard with 96%.',
          ),
          InfoCard(
            title: 'Career Objective',
            icon: Icons.flag_outlined,
            description:
                'To improve my technical skills through continuous learning and contribute to useful software projects while growing as a computer science professional.',
          ),
        ]),
      );
}

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  Widget group(String title, List<String> skills, IconData icon) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, color: purple),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills
                    .map((s) => Chip(
                        label: Text(s),
                        backgroundColor: const Color(0xFFF0E3FF)))
                    .toList(),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Technical Skills')),
        body: pageList([
          group('Programming Languages', ['Java', 'C', 'Python', 'Dart'],
              Icons.code),
          group('Web Technologies', ['HTML', 'CSS', 'JavaScript'], Icons.web),
          group('Frameworks & App Development', ['Flutter'],
              Icons.phone_android),
          group('Tools & Platforms', ['Git', 'GitHub', 'Docker'], Icons.build),
          group('Areas of Interest', [
            'Object-Oriented Programming',
            'Problem Solving',
            'Mobile App Development',
            'Web Development'
          ], Icons.lightbulb_outline),
          const Text(
              'Add any other databases or cloud platforms listed on your resume.'),
        ]),
      );
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Projects')),
        body: pageList(const [
          InfoCard(
            title: 'AI-Driven Smart Band for Women’s Safety',
            icon: Icons.health_and_safety_outlined,
            description:
                'Overview: A wearable safety solution designed to help a user request assistance quickly during an emergency. The proposed band combines a panic button with location sharing and alert messaging.\n\n'
                'Key features:\n'
                '• Panic-button activation to trigger an emergency alert.\n'
                '• GPS-based location capture and a location link for trusted contacts.\n'
                '• GSM/SIM-based SMS alerts that can work without mobile internet.\n'
                '• Proposed audio recording and app-based monitoring features, depending on final hardware and implementation.\n\n'
                'My contribution: Add the exact modules you personally implemented, such as the Flutter interface, alert workflow, GPS integration, testing, documentation, or hardware integration.',
          ),
          InfoCard(
            title: 'Geometry Space Analyzer',
            icon: Icons.architecture_outlined,
            description:
                'Overview: An application for working with geometric shapes and analysing their measurements in a clear, user-friendly interface.\n\n'
                'Possible features:\n'
                '• Accept dimensions for supported geometric shapes.\n'
                '• Calculate measurements such as area, perimeter, or volume where applicable.\n'
                '• Display results in an organised format.\n'
                '• Validate inputs and show helpful messages for missing or invalid dimensions.\n\n'
                'My contribution: Replace this note with the exact shapes, formulas, technologies, interface components, and features you implemented.',
          ),
        ]),
      );
}

class CertificateItem {
  final String title;
  final String path;
  const CertificateItem(this.title, this.path);
}

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  static const certificates = [
    CertificateItem('Scaler Certificate', 'assets/certificates/scaler.pdf'),
    CertificateItem('CSS3 Certificate', 'assets/certificates/css3.pdf'),
    CertificateItem('HTML5 Certificate', 'assets/certificates/html5.pdf'),
    CertificateItem(
        'Simplilearn Certificate', 'assets/certificates/simpleLearn.pdf'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Certifications')),
        body: pageList([
          const Text('Tap a certificate to open its PDF.'),
          const SizedBox(height: 14),
          for (final item in certificates) _CertificateCard(item: item),
        ]),
      );
}

class _CertificateCard extends StatefulWidget {
  final CertificateItem item;
  const _CertificateCard({required this.item});
  @override
  State<_CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<_CertificateCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) => AnimatedScale(
        scale: pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        child: Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTapDown: (_) => setState(() => pressed = true),
            onTapCancel: () => setState(() => pressed = false),
            onTap: () {
              setState(() => pressed = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CertificateViewerPage(
                      title: widget.item.title, path: widget.item.path),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 38),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(widget.item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const Icon(Icons.open_in_new, color: purple),
              ]),
            ),
          ),
        ),
      );
}

class CertificateViewerPage extends StatelessWidget {
  final String title;
  final String path;
  const CertificateViewerPage(
      {super.key, required this.title, required this.path});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: PdfViewer.asset(path),
      );
}

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Activities & Volunteering')),
        body: pageList(const [
          InfoCard(
            title: 'DEMUX 2.0',
            icon: Icons.event,
            description:
                'Participated in DEMUX 2.0, gaining exposure to technology-focused activities, learning from peers, and engaging with collaborative problem solving.',
          ),
          InfoCard(
            title: 'GDG Events',
            icon: Icons.groups,
            description:
                'Participated in Google Developer Groups (GDG) events to explore developer technologies, learn about current technical topics, and connect with the developer community.',
          ),
          InfoCard(
            title: 'Hackathons',
            icon: Icons.emoji_events_outlined,
            description:
                'Interested in hackathons and collaborative technical challenges. Add the specific event names, dates, problem statements, and your team contribution here.',
          ),
          InfoCard(
            title: 'Orientation Programme Volunteering',
            icon: Icons.volunteer_activism,
            description:
                'Volunteered during the college orientation programme, helping with event coordination and supporting the smooth flow of programme activities.',
          ),
          InfoCard(
            title: 'Graduation Ceremony Volunteering',
            icon: Icons.school,
            description:
                'Volunteered during the graduation ceremony and supported event arrangements and coordination to help the programme run smoothly.',
          ),
          InfoCard(
            title: 'Skills Developed',
            icon: Icons.star_outline,
            description:
                'Teamwork, communication, event coordination, collaboration, time management, and willingness to learn from new experiences.',
          ),
        ]),
      );
}