import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class MainMenuScreen extends StatelessWidget {
  final MiningShooter _game;

  MainMenuScreen({required MiningShooter game}) : _game = game {}

  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Stack(
        alignment:  Alignment.center,
        children: [

          SpriteWidget(
            sprite: _game.atlas.findSpriteByName('title-background') as Sprite
           ),
      
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [

          SpriteWidget(
            sprite: _game.atlas.findSpriteByName('title') as Sprite
            
          ),

          SpriteTextButton(
            onPressed: () => _game.router.pushReplacementNamed('Mining Select'),
            text: 'Mine',
            spriteName: 'button-blue',
            game: _game,
          ),

          SpriteTextButton(
            onPressed: () => _game.router.pushReplacementNamed('Battle Select'),
            text: 'Battle',
            spriteName: 'button-blue',
            game: _game,
          ),

          SpriteTextButton(
            onPressed: () => _game.router.pushReplacementNamed('Upgrade'), 
            text: 'Upgrade', 
            spriteName: 'button-blue', 
            game: _game
        ),

        SpriteTextButton(
          onPressed: () => _game.overlays.add('Settings Dialog'), 
          text: 'Settings', 
          spriteName: 'button-blue', 
        game: _game)
        ],
      )]),
    );
  }
}
