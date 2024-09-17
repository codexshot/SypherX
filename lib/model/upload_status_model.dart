import 'dart:convert';

enum UploadStatus {
  initialised,
  inprogress,
  complete;

  String? asString() => {
        UploadStatus.initialised: 'initialised',
        UploadStatus.inprogress: 'inprogress',
        UploadStatus.complete: 'complete'
      }[this];

  UploadStatus? fromString(String text) => {
        'initialised': UploadStatus.initialised,
        'inprogress': UploadStatus.inprogress,
        'complete': UploadStatus.complete
      }[text];
}

class UploadStatsModel {
  UploadStatus status;
  int totalChunks;
  List<int> uploadedChunks;
  List<int> errorChunks;

  UploadStatsModel(
      {this.status = UploadStatus.initialised,
      this.totalChunks = 0,
      this.uploadedChunks = const [],
      this.errorChunks = const []});

  factory UploadStatsModel.fromMap(Map<dynamic, dynamic> map) {
    return UploadStatsModel(
      status: UploadStatus.values.byName(map['status']),
      totalChunks: map['totalChunks'],
      uploadedChunks: List<int>.from(map['uploadedChunks'] ?? <int>[]),
      errorChunks: List<int>.from(map['errorChunks'] ?? <int>[]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'totalChunks': totalChunks,
      'uploadedChunks': uploadedChunks,
      'errorChunks': errorChunks
    };
  }

  String toJson() => json.encode(toMap());

  factory UploadStatsModel.fromJson(String source) => UploadStatsModel.fromMap(json.decode(source));
}
