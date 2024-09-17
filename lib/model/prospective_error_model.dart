enum NextAction {
  retry_guide_creation,
  retry_video_upload,
  retry_image_upload,
  retry;

  static NextAction fromString(String index) {
    switch (index) {
      case 'retry_guide_creation':
        return retry_guide_creation;
      case 'retry_video_upload':
        return retry_video_upload;
      case 'retry_image_upload':
        return retry_image_upload;
      default:
        return retry;
    }
  }
}

class ProspectiveError {
  final String error;
  final String resolution;
  final NextAction nextAction;

  const ProspectiveError(
      {this.error = "An unknown error occurred",
      this.resolution = "Please try again",
      this.nextAction = NextAction.retry});

  static ProspectiveError fromMap(Map<String, dynamic> map) {
    return ProspectiveError(
        error: map['error'] ?? "An unknown error occurred",
        resolution: map['resolution'] ?? "Please try again later",
        nextAction: map['nextAction'] == null
            ? NextAction.fromString(map['nextAction'] ?? '')
            : NextAction.retry);
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'resolution': resolution,
      'nextAction': nextAction.name
    };
  }

  @override
  String toString() {
    return "$error. $resolution";
  }
}
