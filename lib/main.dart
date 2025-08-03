import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';
import 'screens/upload_screen.dart';
import 'screens/job_info_screen.dart';
import 'screens/results_screen.dart';
import 'screens/cv_details_screen.dart';
import 'models/resume_result.dart';

void main() {
  runApp(const ResumeScannerApp());
}

class ResumeScannerApp extends StatelessWidget {
  const ResumeScannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.beige,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.burgundy,
          titleTextStyle: AppTextStyles.heading.copyWith(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.burgundy,
            textStyle: const TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UploadScreen(),
        '/job-info': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List;
          return JobInfoScreen(uploadedCVs: args);
        },
        '/results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List<ResumeResult>;
          return ResultsScreen(results: args);
        },
        '/cv-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as ResumeResult;
          return CVDetailsScreen(result: args);
        },
      },
    );
  }
}
