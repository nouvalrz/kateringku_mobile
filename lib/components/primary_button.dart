import 'package:flutter/material.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

enum ButtonState { idle, loading, disabled }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    Key? key,
    required this.title,
    this.titleStyle,
    this.state = ButtonState.idle,
    this.leadingIcon,
    this.color,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final TextStyle? titleStyle;
  final ButtonState state;
  final Widget? leadingIcon;
  final Color? color;
  final Function()? onTap;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    TextStyle? defaultTextStyle = AppTheme.textTheme.labelLarge;
    return InkWell(
      child: Container(
        height: AppTheme.buttonHeight,
        decoration: BoxDecoration(
            color: widget.color ?? AppTheme.primaryGreen,
            borderRadius: AppTheme.buttonRadius),
        child: widget.state == ButtonState.loading
            ? Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      'Loading',
                      style: AppTheme.textTheme.labelLarge,
                    ),
                  )
                ],
              ))
            : Row(
                children: [
                  if (widget.leadingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: widget.leadingIcon,
                    ),
                  Text(
                    widget.title,
                    style: widget.titleStyle ?? defaultTextStyle,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
      ),
      onTap: widget.onTap,
    );
  }
}
