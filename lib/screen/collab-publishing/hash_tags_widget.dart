import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:moonbase_explore/app_constants/size_constants.dart';

import '../../app_constants/app_colors.dart';
import '../../bloc/hashtags/hastags_bloc.dart';
import '../../model/hash_tag_model.dart';
import '../../utils/date_utils.dart';
import '../../utils/utility.dart';
import '../../widgets/common_text.dart';
import '../../widgets/tempo_change_button.dart';
import '../../widgets/tempo_text_button.dart';

const int maxHashTagsLimit = 6;

class CollabHashTagWidget extends StatelessWidget {
  const CollabHashTagWidget({super.key});

  Future<void> showHashTagBottomSheet(BuildContext context, {List<HashTags> tags = const []}) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => HashTagBottomSheet(tags: tags),
    ).then((value) {
      if (value != null) {
        context.read<HastagsBloc>().add(AddHashTagsToListEvent(hashTags: value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HastagsBloc, HastagsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: TText('Add hashtags', variant: TypographyVariant.h1),
                  ),
                  state.hashTags.isNotEmpty
                      ? TempoChangeButton(
                          text: 'Edit',
                          onPressed: () async => await showHashTagBottomSheet(context, tags: state.hashTags),
                        )
                      : const SizedBox(),
                ],
              ),
              heightBox10(),
              const TText(
                'Add some hashtags to your guide, to make it more visible to the users',
                variant: TypographyVariant.caption,
                maxLines: 3,
              ),
              heightBox10(),
              state.hashTags.isNotEmpty
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 5,
                      children: state.hashTags.map((e) => HashTagChip.withBorder(hashTag: e)).toList(),
                    )
                  : const SizedBox(),
              TempoTextButton(
                text: 'Add hashtags',
                radius: 8,
                height: 0,
                width: 0,
                onPressed: () async {
                  await showHashTagBottomSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class HashTagBottomSheet extends StatefulWidget {
  const HashTagBottomSheet({super.key, this.tags});

  final List<HashTags>? tags;

  @override
  State<HashTagBottomSheet> createState() => _HashTagBottomSheetState();
}

class _HashTagBottomSheetState extends State<HashTagBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<HashTags> _tags = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.tags != null) {
        setState(() {
          _tags = List.from(widget.tags ?? []);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizeConstants.padding20, vertical: TSizeConstants.padding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: _tags.length < maxHashTagsLimit,
            controller: _controller,
            cursorColor: primaryDarkColor,
            decoration: const InputDecoration(
                focusColor: primaryDarkColor,
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryDarkColor))),
            onChanged: (value) {
              if (value.endsWith(',')) {
                final parts = value.split(',');
                for (final part in parts) {
                  final tag = part.trim();
                  if (tag.isNotEmpty) {
                    final hashTag = HashTags(id: tag, text: tag, count: 0);
                    if (!_tags.contains(hashTag)) {
                      setState(() {
                        _tags.add(hashTag);
                      });
                    }
                  }
                  _controller.clear();
                }
                // final tag = value.trim().replaceFirst(',', '');
                // final hashTag = HashTags(id: tag, text: tag, count: 0);
                // if (tag.isNotEmpty && !_tags.contains(hashTag)) {
                //   setState(() {
                //     _tags.add(hashTag);
                //   });
                // }
                // _controller.clear();
              }
            },
          ),
          heightBox10(),
          const TText(
            'Use comma(,) to seprate hashtags. You can only add upto $maxHashTagsLimit hashtags.',
            variant: TypographyVariant.caption,
            maxLines: 3,
          ),
          heightBox20(),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                children: _tags
                    .map(
                      (e) => HashTagChip.withBorder(
                        hashTag: e,
                        onDeleted: () {
                          _tags.removeWhere((element) => element == e);
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          TempoTextButton(
            text: 'Cancel',
            enabledBackgroundColor: buttonRedColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TempoTextButton(
            text: 'Done',
            isButtonEnabled: _tags.isNotEmpty,
            onPressed: () {
              Navigator.pop(context, _tags);
            },
          )
        ],
      ),
    );
  }
}

class HashTagChip extends StatelessWidget {
  const HashTagChip.withBorder({
    super.key,
    required this.hashTag,
    this.onDeleted,
    this.backgroundColor = Colors.white,
    this.borderColor = primaryDarkColor,
    this.textColor = primaryDarkColor,
    this.deleteIconColor = primaryDarkColor,
  });

  const HashTagChip.withBackground({
    super.key,
    required this.hashTag,
    this.onDeleted,
    this.backgroundColor = secondaryColor,
    this.borderColor = secondaryColor,
    this.textColor = Colors.white,
    this.deleteIconColor = Colors.white,
  });

  final HashTags hashTag;
  final void Function()? onDeleted;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color deleteIconColor;

  @override
  Widget build(BuildContext context) {
    return Chip(
      key: ValueKey('$hashTag$TempoDateUtils.timestamp()'),
      label: TText(
        '#${hashTag.text}',
        variant: TypographyVariant.h2,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide(color: borderColor),
      deleteIcon: onDeleted != null
          ? Icon(
              Icons.clear,
              color: deleteIconColor,
              size: 18,
            )
          : null,
      onDeleted: onDeleted,
    );
  }
}
