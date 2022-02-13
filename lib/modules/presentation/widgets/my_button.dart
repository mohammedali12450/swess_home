import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final double width;

  final double height;

  final Color color;

  final Widget? child;

  final Function()? onPressed;

  final double borderRadius;

  final List<BoxShadow>? shadow;

  final Border? border;

  final EdgeInsets? padding;

  const MyButton(
      {Key? key,
      this.shadow,
      this.border,
      this.padding,
      this.width = 100,
      this.height = 50,
      this.color = Colors.blue,
      this.child,
      this.onPressed,
      this.borderRadius = 10})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          color: widget.color,
          boxShadow: widget.shadow,
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
