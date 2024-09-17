import 'package:flutter/material.dart';

import 'package:tempo_location_service/tempo_location_service.dart';

import '../../../utils/enums.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_edit_text_field.dart';

class AddLocationForm extends StatelessWidget {
  const AddLocationForm({
    Key? key,
    required this.placeModel,
    required this.venueController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.onSave,
    this.buttonText,
  }) : super(key: key);

  final PlaceModel? placeModel;
  final TextEditingController venueController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final VoidCallback onSave;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: GoogleMapTempo(
              placeModel: placeModel!,
            ),
          ),
          const SizedBox(height: 50),
          TTextField(
            choice: ChoiceEnum.address,
            controller: venueController,
            label: 'Venue',
            isMandatory: true,
            hintText: 'Venue',
          ),
          const SizedBox(height: 20),
          TTextField(
            choice: ChoiceEnum.text,
            controller: cityController,
            label: 'City',
            isMandatory: true,
            hintText: 'City',
          ),
          const SizedBox(height: 20),
          TTextField(
            choice: ChoiceEnum.optionalText,
            controller: stateController,
            label: 'State/Province',
            hintText: 'State/Province',
          ),
          const SizedBox(height: 20),
          TTextField(
            choice: ChoiceEnum.text,
            controller: countryController,
            label: 'Country',
            isMandatory: true,
            isEnabled: false,
            hintText: 'Country',
          ),
          const SizedBox(height: 20),
          TButton(
            text: buttonText ?? 'Next',
            buttonType: ButtonType.textButton,
            onPressed: onSave,
            minbuttonWidth: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
