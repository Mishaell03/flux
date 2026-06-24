import 'package:flutter/material.dart';
import 'package:front/core/api/api_config.dart';
import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/futures/profile/models/get_info.dart';
import 'package:front/futures/profile/services/get_info.dart';
import 'package:front/futures/profile/widgets/profile_card.dart';
import 'package:front/futures/profile/widgets/settings_list.dart';
import 'package:front/futures/profile/widgets/status_card.dart';
import 'package:front/futures/profile/widgets/sync_card.dart';
import 'package:go_router/go_router.dart';

const double _kMaxContentWidth = 560;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<ProfileResponse> _future;
  bool _errorShown = false;

  @override
  void initState() {
    super.initState();
    _future = _loadProfile();
  }

  Future<ProfileResponse> _loadProfile() async {
    final token = await AuthTokenStorage.read();

    if (token == null || token.trim().isEmpty) {
      throw const AppException(code: AppErrorCode.errorProfileFailed);
    }

    return ProfileService.getProfile(
      url: ApiConfig.userProfile,
      token: token,
    );
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      return error.code.localizedMessage(context);
    }

    return 'Unknown error';
  }

  void _showError(Object error) {
    if (!mounted) return;

    AppNotice.error(
      context,
      message: _errorMessage(error),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _errorShown = false;
      _future = _loadProfile();
    });

    try {
      await _future;
    } catch (e) {
      _showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: AppVerticalScroll(
        paddingH: 20,
        paddingV: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FutureBuilder<ProfileResponse>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    if (!_errorShown) {
                      _errorShown = true;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showError(snapshot.error!);
                      });
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 42,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage(snapshot.error!),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _refresh,
                            child: const Text('Повторить'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            child: const Text('Войти заново'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          const Text('Нет данных профиля'),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _refresh,
                            child: const Text('Обновить'),
                          ),
                        ],
                      ),
                    );
                  }

                  final profile = snapshot.data!;

                  return Column(
                    children: [
                      ProfileUserCard(profile: profile),
                      const SizedBox(height: 16),
                      ProfileSyncCard(),
                      const SizedBox(height: 16),
                      ProfileStatsCard(profile: profile),
                      const SizedBox(height: 16),
                      ProfileSettingsList(profile: profile),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
