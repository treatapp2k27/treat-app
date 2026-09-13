import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/treat_theme.dart';
import 'screens/app_shell.dart';
import 'services/treat_mock_backend.dart';
import 'state/booking_state.dart';
import 'state/budget_planner_state.dart';
import 'state/diner_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the mock backend singleton with rich default demo state
  TreatMockBackend.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DinerState>(
          create: (_) => DinerState(),
        ),
        ChangeNotifierProvider<BudgetPlannerState>(
          create: (_) => BudgetPlannerState(),
        ),
        ChangeNotifierProvider<BookingState>(
          create: (_) => BookingState(),
        ),
      ],
      child: const TreatApp(),
    ),
  );
}

class TreatAppScrollBehavior extends MaterialScrollBehavior {
  const TreatAppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class TreatApp extends StatelessWidget {
  const TreatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treat - Culinary Social & Food Deals',
      theme: TreatTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const TreatAppScrollBehavior(),
      home: const AppShell(),
    );
  }
}

