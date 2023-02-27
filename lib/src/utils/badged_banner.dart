import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

class BadgedBanner extends StatelessWidget {
  final Widget? child;
  final AdSize adSize;
  const BadgedBanner({this.child, this.adSize = AdSize.banner, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: adSize.height.toDouble(),
      width: double.infinity,
      alignment: Alignment.center,
      child: Badge(
        label: const Text('Ad'),
        backgroundColor: Theme.of(context).primaryColor,
        alignment: AlignmentDirectional.topStart,
        child: Container(
          height: adSize.height.toDouble(),
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          child: child,
        ),
      ),
    );
  }
}
