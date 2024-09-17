import 'package:flutter/material.dart';

import '../app_constants/app_colors.dart';
import '../app_constants/app_text_style.dart';
import '../app_constants/size_constants.dart';
import 'common_app_bar.dart';

class BgTempoScreen extends StatelessWidget {
  const BgTempoScreen(
      {Key? key,
      required this.pageTitle,
      required this.child,
      this.actions,
      this.floatingActionButton,
      this.onBackButtonPressed,
      this.buildBackButton = true,
      this.resizeToAvoidBottomInset = false})
      : super(key: key);

  final String pageTitle;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final void Function()? onBackButtonPressed;
  final bool buildBackButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: TSizeConstants.prefferdSize,
        child: TAppBar(
          title: pageTitle,
          actions: actions,
          buildBackButton: buildBackButton,
          onPressed: onBackButtonPressed,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ClipRRect(
          borderRadius: TStyles.borderRadius30,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: collabBuilderBackgroundColor,
              borderRadius: TStyles.borderRadius30,
            ),
            child: child,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
