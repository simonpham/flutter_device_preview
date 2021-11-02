import 'package:device_preview/src/state/store.dart';
import 'package:device_preview/src/views/tool_panel/sections/subsections/device_model.dart';
import 'package:device_preview/src/views/tool_panel/widgets/device_type_icon.dart';
import 'package:device_preview/src/views/tool_panel/widgets/target_platform_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'section.dart';

/// All the simulated properties for the device.
class DeviceSection extends StatelessWidget {
  /// Create a new menu section with simulated device properties.
  const DeviceSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceName = context.select(
      (DevicePreviewStore store) => store.deviceInfo.name,
    );
    final deviceIdentifier = context.select(
      (DevicePreviewStore store) => store.deviceInfo.identifier,
    );

    final canRotate = context.select(
      (DevicePreviewStore store) => store.deviceInfo.rotatedSafeAreas != null,
    );

    final orientation = context.select(
      (DevicePreviewStore store) => store.data.orientation,
    );

    final isVirtualKeyboardVisible = context.select(
      (DevicePreviewStore store) => store.data.isVirtualKeyboardVisible,
    );

    final isFrameVisible = context.select(
      (DevicePreviewStore store) => store.data.isFrameVisible,
    );

    return ToolPanelSection(
      title: 'Device',
      children: [
        ListTile(
          title: const Text('Model'),
          subtitle: Text(deviceName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TargetPlatformIcon(
                platform: deviceIdentifier.platform,
              ),
              const SizedBox(
                width: 8,
              ),
              DeviceTypeIcon(
                type: deviceIdentifier.type,
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          onTap: () {
            final theme = Theme.of(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Theme(
                  data: theme,
                  child: const DeviceModelPicker(),
                ),
              ),
            );
          },
        ),
        if (canRotate)
          ListTile(
            title: const Text('Orientation'),
            subtitle: Text(
              () {
                switch (orientation) {
                  case Orientation.landscape:
                    return 'Landscape';
                  case Orientation.portrait:
                    return 'Portrait';
                }
              }(),
            ),
            trailing: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transformAlignment: Alignment.center,
              transform: Matrix4.rotationZ(
                orientation == Orientation.landscape ? 2.35 : 0.75,
              ),
              child: const Icon(Icons.screen_rotation),
            ),
            onTap: () {
              final state = context.read<DevicePreviewStore>();
              state.rotate();
            },
          ),
        ListTile(
          title: const Text('Frame visibility'),
          subtitle: Text(isFrameVisible ? 'Visible' : 'Hidden'),
          trailing: Icon(
            isFrameVisible
                ? Icons.border_outer_rounded
                : Icons.border_clear_rounded,
          ),
          onTap: () {
            final state = context.read<DevicePreviewStore>();
            state.toggleFrame();
          },
        ),
        ListTile(
          title: const Text('Virtual keyboard preview'),
          subtitle: Text(isVirtualKeyboardVisible ? 'Visible' : 'Hidden'),
          trailing: Icon(
            isVirtualKeyboardVisible ? Icons.keyboard : Icons.keyboard_outlined,
          ),
          onTap: () {
            final state = context.read<DevicePreviewStore>();
            state.toggleVirtualKeyboard();
          },
        ),
      ],
    );
  }
}
