import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/bloc/hashtags/hastags_bloc.dart';
import 'package:moonbase_explore/bloc/monetization_bloc/monetization_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/bloc/video_bloc/video_bloc.dart';
import 'package:moonbase_explore/hive/local_storage_manager.dart';
import 'package:moonbase_explore/model/collab_type.dart';
import 'package:moonbase_explore/screen/collab-publishing/collab_publish_screen.dart';
import 'package:moonbase_explore/screen/collab-publishing/hash_tags_widget.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_builder_screen.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_video_picker.dart';
import 'package:moonbase_explore/screen/drafts/saved_drafts_screen.dart';
import 'package:moonbase_theme/text_themes/moonbase_text_themes.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await LocalStorageManager().openInAppTutorialsBox();
  runApp(const TempoExplore());
}

class TempoExplore extends StatelessWidget {
  const TempoExplore({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExploreBloc>(
          create: (_) => ExploreBloc()..setDummyCategories(),
          child: const CreateGuideScreen(),
        ),
        BlocProvider<VideoBloc>(
          create: (_) => VideoBloc(),
          child: const UnitVideoPicker(),
        ),
        BlocProvider<DraftBloc>(
          create: (_) => DraftBloc(),
          child: const SavedDraftsScreen(),
        ),
        BlocProvider<MonetizationBloc>(
          create: (_) => MonetizationBloc(),
          child: const CollabPublishingScreen(collabType: CollabType.guide),
        ),
        BlocProvider<HastagsBloc>(
          create: (_) => HastagsBloc(),
          child: const CollabHashTagWidget(),
        ),
        BlocProvider<QuizzesBloc>(
          create: (_) => QuizzesBloc(),
      lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: MoonbaseTextTheme.lightTextTheme(context)),
        home: const CreateGuideScreen(),
      ),
    );
  }
}
