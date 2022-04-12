import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefreshButton extends StatefulWidget {
  final Function() onPressed;

  const RefreshButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _RefreshButtonState createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(220.w, 56.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.refresh_outlined,
            size: 18.w,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          4.horizontalSpace,
          Text(
            AppLocalizations.of(context)!.refresh,
          ),
        ],
      ),
      onPressed: widget.onPressed,
    );
  }
}
