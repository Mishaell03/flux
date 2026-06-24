import 'package:flutter/material.dart';
import 'package:front/core/api/api_config.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/auth_token_storage.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/futures/profile/models/get_info.dart';
import 'package:front/futures/profile/services/get_info.dart';
import 'package:front/futures/profile/widgets/profile_card.dart';
import 'package:front/futures/profile/widgets/settings_list.dart';
import 'package:front/futures/profile/widgets/status_card.dart';
import 'package:front/futures/profile/widgets/sync_card.dart';

const double _kMaxContentWidth = 560;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadProfile();
  }

  Future<ProfileResponse> _loadProfile() async {
    final token = await AuthTokenStorage.read();

    return ProfileService.getProfile(
      url: ApiConfig.userProfile,
      token: token!,
    );
  }

  void _showError(Object error) {
    if (error is AppException) {
      AppNotice.error(
        context,
        message: error.code.localizedMessage(context),
      );
      return;
    }

    AppNotice.error(
      context,
      message: 'Unknown error',
    );
  }

  Future<void> _refresh() async {
    setState(() {
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
    return Scaffold(
      backgroundColor: context.colors.bg,
      body: RefreshIndicator(
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
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showError(snapshot.error!);
                      });

                      return const SizedBox();
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    final profile = snapshot.data!;

                    return Column(
                      children: [
                        ProfileUserCard(
                          profile: profile,
                        ),
                        const SizedBox(height: 16),
                        ProfileSyncCard(),
                        const SizedBox(height: 16),
                        ProfileStatsCard(
                          profile: profile,
                        ),
                        const SizedBox(height: 16),
                        ProfileSettingsList(
                          profile: profile,
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
