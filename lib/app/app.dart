import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/calendar/calendar_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/lock/lock_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/today/today_screen.dart';
import 'providers.dart';
import 'theme.dart';

class CommaApp extends StatelessWidget {
  const CommaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comma',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      builder: (context, child) => LockGate(child: child!),
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(settingProvider(SettingKeys.onboarded));
    return switch (onboarded) {
      AsyncData(value: 'true') => const HomeShell(),
      AsyncData() => const OnboardingScreen(),
      AsyncError(:final error) => Scaffold(
        body: Center(child: Text('Could not open your data.\n$error')),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  var _index = 0;
  String? _scheduled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Keep OS reminders in step with the data; only reschedule on change.
    ref.listenManual(reminderPlanProvider, (_, plan) {
      final signature = plan
          .map((n) => '${n.id}@${n.when}:${n.title}:${n.body}')
          .join('|');
      if (signature == _scheduled) return;
      _scheduled = signature;
      ref.read(notificationServiceProvider).apply(plan);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reminders are planned two weeks ahead, so top them up on every return.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(todayProvider);
      ref.invalidate(reminderPlanProvider);
    }
  }

  static const _screens = [
    TodayScreen(),
    CalendarScreen(),
    InsightsScreen(),
    LearnScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
