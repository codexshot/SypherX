import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:tempo_location_service/tempo_location_service.dart';

import '../../app_constants/app_colors.dart';

import '../../app_constants/extensions.dart';
import '../../widgets/common_text.dart';
import 'location/location_selector_guide.dart';

class LocationSelector extends StatefulWidget {

  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  PlaceModel? _location;
  int number =0;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
  builder: (context, state) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryDarkColor, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: state.exploreLocation?.location != null
          ? TText(
        state.exploreLocation!.placeName,
              variant: TypographyVariant.body,
            )
          :  const Row(
              children: [
                TText(
                  'Location',
                  variant: TypographyVariant.body,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TText(
                    '(Optional)',
                    variant: TypographyVariant.h2,
                    style: TextStyle(color: greyColor),
                  ),
                ),
              ],
            ),
    );
  },
).onUserTap(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LocationSelectorGuide(
                onSelectedLocation: (value) {
                  if (value != null) {
                    log(value.toJson().toString());
                    setState(() {
                      _location = value;
                      context.read<ExploreBloc>().setGuideLocation(_location!);
                    });
                  }
                },
              )));
    });

    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
  }
}
