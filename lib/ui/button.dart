import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';

class SpriteTextButton extends StatelessWidget {
  final VoidCallback _onPressed;

  final MiningShooter _game;

  final String _text;

  final String _spriteName;

  SpriteTextButton({
    required VoidCallback onPressed,
    required String text,
    required String spriteName,
    required MiningShooter game,
  }) : _onPressed = onPressed,
       _game = game,
       _text = text,
       _spriteName = spriteName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SpriteWidget(
          sprite: _game.atlas.findSpriteByName(_spriteName) as Sprite,
        ),

        SizedBox(
          width: 32,
          height: 16,
          child: TextButton(
            onPressed: () {
              if (_game.saveManager.settings.soundOn) {
                _game.audioManager.soloud.play(
                  _game.audioManager.clickSoundSource,
                );
              }

              _onPressed();
            },

            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              overlayColor: Colors.black.withValues(alpha: 0.2),
            ),
            child: Text(_text, style: smallBlack, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
