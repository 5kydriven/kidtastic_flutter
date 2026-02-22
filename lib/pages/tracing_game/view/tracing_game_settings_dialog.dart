import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';

class TracingGameSettingsDialog extends StatelessWidget {
  final BuildContext context;

  const TracingGameSettingsDialog({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TracingGameBloc>(this.context),
      child: BlocBuilder<TracingGameBloc, TracingGameState>(
        builder: (context, state) {
          final bloc = context.read<TracingGameBloc>();

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
                          bloc.add(const TracingGameBgmToggled()),
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
                          TracingGameBgmVolumeChanged(
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
                          bloc.add(const TracingGameSfxToggled()),
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
                          TracingGameSfxVolumeChanged(
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
                        bloc.add(const TracingGameSfxButtonPressed());
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
