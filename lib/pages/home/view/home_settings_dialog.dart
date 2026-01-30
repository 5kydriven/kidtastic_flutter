import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';

class HomeSettingsDialog extends StatelessWidget {
  final BuildContext context;

  const HomeSettingsDialog({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeBloc>(this.context),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final bloc = context.read<HomeBloc>();

          return AlertDialog(
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.volume_up),
                    title: Text(
                      'Sound Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Background Music'),
                    trailing: Switch(
                      value: !state.isBgmMuted,
                      onChanged: (value) =>
                          bloc.add(const HomeBgmToggled()),
                    ),
                  ),
                  ListTile(
                    minTileHeight: 0.0,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.volume_mute),
                    title: Slider(
                      value: state.bgmVolume,
                      onChanged: (value) {
                        if (state.isBgmMuted) return;
                        bloc.add(
                          HomeBgmVolumeChanged(
                            volume: value,
                          ),
                        );
                      },
                      activeColor: state.isBgmMuted
                          ? Colors.grey.shade600
                          : null,
                    ),
                    enabled: !state.isBgmMuted,
                    trailing: Icon(Icons.volume_up),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Sound Effects'),
                    trailing: Switch(
                      value: !state.isSfxMuted,
                      onChanged: (value) =>
                          bloc.add(const HomeSfxToggled()),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.volume_mute),
                    title: Slider(
                      value: state.sfxVolume,
                      activeColor: state.isSfxMuted
                          ? Colors.grey.shade600
                          : null,
                      onChanged: (value) {
                        if (state.isSfxMuted) return;
                        bloc.add(
                          HomeSfxVolumeChanged(
                            volume: value,
                          ),
                        );
                      },
                    ),
                    enabled: !state.isSfxMuted,
                    trailing: Icon(Icons.volume_up),
                  ),

                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        bloc.add(const HomeSfxButtonPressed());
                        context.pop();
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
