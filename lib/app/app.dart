import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/app/constants/app_constants.dart';
import 'package:reddit_app/app/models/user_model.dart';
import 'package:reddit_app/app/router/app_router.dart';
import 'package:reddit_app/app/shared/utils.dart';
import 'package:reddit_app/app/theme/theme_notifier.dart';
import 'package:reddit_app/app/widgets/error_text_widget.dart';
import 'package:reddit_app/app/widgets/loader.dart';
import 'package:reddit_app/features/auth/controllers/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  UserModel? previousUserModel;
  UserModel? userModel;

  Future<void> getData(WidgetRef ref, String uid) async {
    userModel = await ref.read(authControllerProvider.notifier).getUserData(uid).first;
    ref.read(userProvider.notifier).update((_) => userModel);
    if (previousUserModel != userModel) {
      previousUserModel = userModel;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    changeSystemOverlayUI(ref);
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appTitle,
              theme: ref.watch(themeProvider),
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (_) {
                  if (data != null) {
                    getData(ref, data.uid);
                    if (userModel != null) {
                      return loggedInRoute;
                    }
                  }
                  return loggedOutRoute;
                },
              ),
              routeInformationParser: const RoutemasterParser(),
            );
          },
          error: (error, _) => ErrorTextWidget(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
