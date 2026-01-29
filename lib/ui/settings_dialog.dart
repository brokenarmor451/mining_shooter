import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class SettingsDialog extends StatefulWidget {
  final MiningShooter _game;

  SettingsDialog({required MiningShooter game}) : _game = game;

  @override
  State<StatefulWidget> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Stack(
        alignment: Alignment.center,

        children: [
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.5),
            dismissible: false,
          ),

          Image(
            image: AssetImage('assets/images/green-background.png'),
            width: 144,
            height: 96,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.none,
            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
          ),

          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpriteTextButton(
                onPressed: () =>
                    widget._game.overlays.remove('Settings Dialog'),
                text: 'Close',
                spriteName: 'button-blue',
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: _changeSoundOption,
                text: _getSoundText(),
                spriteName: 'button-blue',
                game: widget._game,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSoundText() {
    if (widget._game.saveManager.settings.soundOn) {
      return 'Sound On';
    }

    return 'Sound Off';
  }

  void _changeSoundOption() {
    setState(() {
      if (widget._game.saveManager.settings.soundOn) {
        widget._game.saveManager.settings.soundOn = false;
      } else {
        widget._game.saveManager.settings.soundOn = true;
      }
    });
  }
}
