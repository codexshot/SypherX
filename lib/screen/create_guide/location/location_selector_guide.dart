import 'package:flutter/material.dart';
import 'package:moonbase_explore/widgets/base_tempo_screen.dart';

import 'package:tempo_location_service/tempo_location_service.dart';

import '../../../app_constants/app_text_style.dart';
import '../../../utils/common_no_data_widget.dart';
import '../../../utils/utility.dart';
import '../../../widgets/common_header_text.dart';
import 'add_location_form.dart';

class LocationSelectorGuide extends StatefulWidget {
  const LocationSelectorGuide({super.key, required this.onSelectedLocation});

  final ValueChanged<PlaceModel?> onSelectedLocation;

  @override
  State<LocationSelectorGuide> createState() => _LocationSelectorGuideState();
}

class _LocationSelectorGuideState extends State<LocationSelectorGuide>  {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  PlaceModel? placeModel;

  String formattedText = '';
  bool isSearchTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        isSearchTextEmpty = _searchController.text.isEmpty;
      });
    });
  }

  void clearValuesForNewSelection() {
    formattedText = '';
    venueController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    if (placeModel != null) {
      _formKey.currentState!.reset();
    }
  }

  void addValuesToControllers(PlaceModel model) {
    formattedText = model.placeName;
    venueController.text = model.venue;
    placeModel = model;
    if (model.city != null) cityController.text = model.city!.name;
    if (model.state != null) stateController.text = model.state!.name;
    if (model.country != null) countryController.text = model.country!.name;
  }

  void changeUserSelectedLocation(PlaceModel model) {
    setState(() {
      clearValuesForNewSelection();
      addValuesToControllers(model);
    });
  }

  void validateForm() {
    if (_formKey.currentState!.validate() && placeModel != null) {
      _formKey.currentState!.save();
      _saveLocation();
    } else {
      return;
    }
  }

  Future<void> _onUserPressSaveButton() async {
    try {
      validateForm();
    } catch (e) {
      rethrow;
    }
  }

  void _saveLocation() {
    widget.onSelectedLocation(placeModel);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      resizeToAvoidBottomInset: true,
      pageTitle: 'Location',
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const THeaderTitle('Search & add location'),
            heightBox20(),
            TempoAutoFillPlaces(
              controller: _searchController,
              onSelected: (value) {
                if (value != null) {
                  changeUserSelectedLocation(value);
                }
              },
              decoration: searchLocationInputDecoration(formattedText, isSearchTextEmpty, _searchController),
            ),
            Expanded(
              child: formattedText.isNotEmpty
                  ? Form(
                      key: _formKey,
                      child: AddLocationForm(
                        placeModel: placeModel,
                        venueController: venueController,
                        cityController: cityController,
                        stateController: stateController,
                        countryController: countryController,
                        onSave: _onUserPressSaveButton,
                        buttonText: 'Confirm',
                      ),
                    )
                  : isSearchTextEmpty
                      ? const Center(child: TempoNoDataWidget(text: 'Search locations to add address'))
                      : const SizedBox(),
            ),
          ],
        ),
      )
    );
  }
}
