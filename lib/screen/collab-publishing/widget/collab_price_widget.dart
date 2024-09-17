import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/bloc/monetization_bloc/monetization_bloc.dart';

import '../../../app_constants/app_colors.dart';
import '../../../app_constants/app_text_style.dart';
import '../../../app_constants/size_constants.dart';
import '../../../utils/enums.dart';
import '../../../utils/utility.dart';
import '../../../widgets/common_edit_text_field.dart';
import '../../../widgets/common_text.dart';
import '../../../widgets/tempo_change_button.dart';
import '../../../widgets/tempo_text_button.dart';

class CollabPriceWidget extends StatelessWidget {
  const CollabPriceWidget({super.key});

  Future<void> showPriceSelectorBottomSheet(BuildContext context, {double price = 0.0}) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => PriceBottomSheet(
        price: price,
        onPriceChanged: (value) {
          final monetizationBloc = BlocProvider.of<MonetizationBloc>(context);
          monetizationBloc.add(AddPriceEvent(price: value));
          context.read<ExploreBloc>().onPriceChange!(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonetizationBloc, MonetizationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: TText('Add Price', variant: TypographyVariant.h1),
                      ),
                      state.runtimeType != NoMonetizationState && state.runtimeType != FreeGuideState
                          ? TempoChangeButton(
                              text: 'Remove',
                              onPressed: () {
                                context.read<MonetizationBloc>().add(ResetPriceEvent());
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                  heightBox10(),
                  const TText(
                    'You can choose to put a price to your guide, it can be free too!',
                    variant: TypographyVariant.caption,
                    maxLines: 3,
                  ),
                  heightBox10(),
                  (state.runtimeType == FreeGuideState)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TText(
                              'Free guide',
                              variant: TypographyVariant.titleSmall,
                              style: TextStyle(fontFamily: TStyles.fontPacifico),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryDarkColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: const TText(
                                  'Change Price',
                                  variant: TypographyVariant.h2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.read<MonetizationBloc>().add(ResetPriceEvent());
                              },
                            )
                          ],
                        )
                      : state is PriceAddedState
                          ? TText('\$ ${state.price}0', variant: TypographyVariant.titleSmall)
                          : const SizedBox(),
                  heightBox10(),
                  state.runtimeType == FreeGuideState
                      ? const SizedBox()
                      : ((state is PriceAddedState && state.price > 10)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  widthBox10(),
                                  const Expanded(
                                    child: TText(
                                      'We recommend keeping the price below \$10',
                                      //  'Only free guides available. Stay tuned for updates on the availability of paid content',
                                      variant: TypographyVariant.h2,
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox())
                ],
              ),
            ),
            Row(children: [
              state.runtimeType == NoMonetizationState
                  ? TempoTextButton(
                      text: 'Add price',
                      width: 0,
                      radius: 8,
                      height: 0,
                      isButtonEnabled: true,
                      onPressed: () async {
                        await showPriceSelectorBottomSheet(context,
                            price: state is PriceAddedState ? state.price : 0.0);
                      },
                    )
                  : const SizedBox(),
              widthBox10(),
              state.runtimeType == NoMonetizationState
                  ? const Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(child: Divider()),
                          SizedBox(width: 8),
                          Text("OR"),
                          SizedBox(width: 8),
                          Flexible(child: Divider()),
                        ],
                      ),
                    )
                  : const SizedBox(),
              widthBox10(),
              state.runtimeType == NoMonetizationState
                  ? GestureDetector(
                      onTap: () {
                        context.read<MonetizationBloc>().add(MakeGuideFreeEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryDarkColor),
                        ),
                        child: const Center(
                          child: Text(
                            'Keep it free',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryDarkColor,
                              fontFamily: TStyles.fontAlata,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ]),
          ],
        );
      },
    );
  }
}

class PriceBottomSheet extends StatefulWidget {
  const PriceBottomSheet({
    super.key,
    this.price = 1.00,
    required this.onPriceChanged,
  });

  final double price;
  final Function(double) onPriceChanged;

  @override
  State<PriceBottomSheet> createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<PriceBottomSheet> {
  final ValueNotifier<double> _price = ValueNotifier<double>(1.0);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.price != 0) {
      _price.value = widget.price;
    }
    _controller.text = '\$ 1.00';
  }

  @override
  void dispose() {
    _price.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: [
          heightBox20(),
          Container(
            height: TSizeConstants.padding5,
            width: TSizeConstants.width56,
            decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(100)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: TSizeConstants.padding16,
              horizontal: TSizeConstants.padding16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox20(),
                const TText(
                  'Add price',
                  variant: TypographyVariant.titleSmall,
                ),
                heightBox30(),
                TTextField(
                  label: 'Price',
                  choice: ChoiceEnum.text,
                  controller: _controller,
                  isEnabled: true,
                ),
                PriceSlider(
                  onPriceChanged: (double value) {
                    _controller.text = '\$ ${value}0';
                    _price.value = value;
                  },
                  price: _price.value,
                ),
                TempoTextButton(
                    text: 'Done',
                    onPressed: () {
                      widget.onPriceChanged(_price.value);

                      // final authState = Provider.of<AuthState>(context, listen: false);
                      // final isSubscribed = authState.user?.subscription?.isSubscribed ?? false;
                      // if (isSubscribed) {
                      //   Navigator.pop(context, _price.value);
                      // } else {
                      //   getIt<NavigationHelpers>().push(context, CollabChoosePlanScreen(price: _price.value));
                      // }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PriceSlider extends StatefulWidget {
  const PriceSlider({super.key, required this.onPriceChanged, required this.price});

  final double price;
  final ValueChanged<double> onPriceChanged;

  @override
  State<PriceSlider> createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  double priceValue = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        priceValue = widget.price;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Slider(
        value: priceValue,
        max: 100,
        min: 1.0,
        activeColor: primaryDarkColor,
        inactiveColor: secondaryColor,
        onChanged: (double value) {
          setState(() {
            priceValue = int.tryParse(value.toStringAsFixed(0))!.toDouble();
          });
          widget.onPriceChanged(priceValue);
        },
      ),
    );
  }
}
