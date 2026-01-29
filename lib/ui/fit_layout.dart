import 'package:flutter/cupertino.dart';

class FitLayout extends StatelessWidget {
  final Widget child;

  FitLayout({required this.child}) {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 144).clamp(
          0.0,
          constraints.maxHeight / 256,
        );

        return Center(
          child: Transform.scale(
            scale: scale,
            child: SizedBox(width: 144, height: 256, child: child),
          ),
        );
      },
    );
  }
}

class FitSizedBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  FitSizedBox({required this.child, required this.width, required this.height}) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}

