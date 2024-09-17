enum CollabType {
  routine,
  guide;

  static CollabType fromString(String value) =>
      {
        'routine': CollabType.routine,
        'guide': CollabType.guide,
      }[value] ??
      CollabType.guide;

  String? asString() => {
        CollabType.routine: 'routine',
        CollabType.guide: 'guide',
      }[this];
}
