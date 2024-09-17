import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonbase_explore/generated/assets.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/size_constants.dart';
import '../app_theme/themes.dart';
import 'common_back_arrow.dart';
import 'common_text.dart';

class TempoAppBar extends StatelessWidget {
  const TempoAppBar({Key? key, this.leadingIcon, this.backgroundColor, this.titleWidget, this.actions}) : super(key: key);

  final Widget? leadingIcon;
  final Color? backgroundColor;
  final Widget? titleWidget;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      leading: leadingIcon,
      automaticallyImplyLeading: false,
      elevation: 0,
      systemOverlayStyle: TempoThemes.systemOverlayStyle,
      title: titleWidget,
      actions: actions,
    );
  }
}

class TAppBar extends StatelessWidget {
  const TAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.onPressed,
    required this.buildBackButton,
    this.titleWidget,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;
  final void Function()? onPressed;
  final bool buildBackButton;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: TSizeConstants.prefferdSize,
      child: AppBar(
        centerTitle: false,
        actions: buildBackButton ? actions : null,
        backgroundColor: backgroundColor,
        titleSpacing: buildBackButton ? 0.0 : null,
        automaticallyImplyLeading: false,

        leading: buildBackButton
            ? TBackArrow(
                onTap: onPressed,

              )
            : null,
        elevation: 0.0,
        title: buildBackButton
            ? title.isNotEmpty
                ? TText(
                    title,
                    variant: TypographyVariant.header,
                  )
                : titleWidget
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(Assets.imagesAppBarPlanet),
                  ),
                  Positioned(
                    bottom: 5,
                    child: title.isNotEmpty
                        ? TText(
                            title,
                            variant: TypographyVariant.header,
                          )
                        : titleWidget!,
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                    child: actions != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: actions ?? [],
                          )
                        : null,
                  )
                ],
              ),
      ),
    );
  }
}
