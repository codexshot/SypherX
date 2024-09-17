///`ChoiceEnum`
enum ChoiceEnum { name, email, phone, password, confirmPassword, reset, text, optionalText, address }

enum AuthStatus { intial, existinguser, newuser, unloggedUser }

enum AppState { intial, loading, success, failure }

enum Screen { planner, social, explore, settings }

enum SwitchToAuthPage { login, register }

enum UserRole { admin, moderator, user }

enum TempoErrors { remoteConfigNotAvailable, unknownError }

enum OccasionType {
  occasion,
  task,
  reminder;


  static OccasionType? fromString(String value) => {
        'occasion': OccasionType.occasion,
        'task': OccasionType.task,
        'reminder': OccasionType.reminder,
      }[value];

  String? asString() => {
        OccasionType.occasion: 'occasion',
        OccasionType.task: 'task',
        OccasionType.reminder: 'reminder',
      }[this];
}

enum SplashScreenNavigation { registrationScreen, loginScreen }

enum RepeatOptions {
  once,
  daily,
  weekly,
  monthly;

  static RepeatOptions? fromString(String value) => {
        'once': RepeatOptions.once,
        'daily': RepeatOptions.daily,
        'weekly': RepeatOptions.weekly,
        'monthly': RepeatOptions.monthly,
      }[value];

  String? asString() => {
        RepeatOptions.once: 'once',
        RepeatOptions.daily: 'daily',
        RepeatOptions.weekly: 'weekly',
        RepeatOptions.monthly: 'monthly',
      }[this];
}

enum TempoEventType{ publicTempoEvent, privateTempoEvent;

  static TempoEventType? fromString(String value) => {
    'publicTempoEvent': TempoEventType.publicTempoEvent,
    'privateTempoEvent': TempoEventType.privateTempoEvent,
  }[value];

  String? asString() => {
    TempoEventType.publicTempoEvent: 'publicTempoEvent',
    TempoEventType.privateTempoEvent: 'privateTempoEvent',
  }[this];

  String? asDisplayString() => {
        TempoEventType.publicTempoEvent: 'Public Event',
        TempoEventType.privateTempoEvent: 'Private Event',
      }[this];
}

enum InviteType{inviteMembers, inviteGroups}

enum EventHashtagsNavigation{onEventList, onEventDetails}

enum UploadStatus { idle, uploading, finished, failed }
