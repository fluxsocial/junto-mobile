import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService with ChangeNotifier {
  static const _fileName = 'junto_audio_recording';
  static const _sampleRate = 16000;
  static const _maxDuration = Duration(seconds: 600);
  FlutterSoundPlayer _audioPlayer;
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _timer;
  Timer _playbackTimer;
  bool _isLocal = true;
  bool get _isWeb => !_isLocal;
  bool _mPlayerIsInited = false;

  AudioService() {
    _audioPlayer = FlutterSoundPlayer();

    _audioPlayer.openAudioSession().then((value) {
      _audioPlayer.setSubscriptionDuration(Duration(seconds: 1)).then((v) {
        _mPlayerIsInited = true;
        notifyListeners();
      });
    });

    _audioPlayer.onProgress?.listen((event) {
      _currentPosition = event.position;
      _duration = event.duration;
      notifyListeners();
    });
  }

  Duration get maxDuration => _maxDuration;

  Duration _currentPosition = Duration.zero;
  Duration get currentPosition => _currentPosition;

  double _currentPower;
  double get currentPower => _currentPower;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Duration _duration;
  Duration get recordingDuration => recordingAvailable
      ? _isLocal
          ? _recording.duration
          : _duration
      : Duration.zero;

  bool _recordingLoaded = false;
  bool get recordingAvailable =>
      _recording != null || (_isWeb && _recordingLoaded);
  bool get playBackAvailable => recordingAvailable && _isRecording == false;

  String _currentPath;
  String get recordingPath => _currentPath;

  void stopRecording() async {
    await _recorder.stop();
    _currentPosition = Duration.zero;
  }

  void resetRecording() async {
    stopPlayback();
    _recording = null;
    _recorder = null;
    _isRecording = false;
    _currentPosition = Duration.zero;
    _currentPower = 0.0;
    await File(_currentPath).delete();

    notifyListeners();
  }

  void startRecording(VoidCallback permissionPopup) async {
    logger.logDebug('Asking for permissions to record audio');

    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission != true) {
      logger.logWarning('User not granted permissions to record audio');
      permissionPopup();
      return;
    }

    final appDocDirectory = await _getTempDirectory();

    _currentPath = '${appDocDirectory.path}/$_fileName'
        '${DateTime.now().millisecondsSinceEpoch}'
        '.aac';
    _recorder = FlutterAudioRecorder(
      _currentPath,
      audioFormat: AudioFormat.AAC,
      sampleRate: _sampleRate,
    );

    await _recorder.initialized;

    logger.logDebug('Starting recording to $_currentPath');

    await _recorder.start();

    _recording = await _recorder.current(channel: 0);
    _startRecordingMonitoring();
  }

  void playRecording() async {
    _isPlaying = true;
    if (_audioPlayer.isStopped) {
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.startPlayer(
        fromURI: _currentPath,
        codec: Codec.aacADTS,
        whenFinished: () {
          _playbackTimer?.cancel();
          stopPlayback();
        },
      );
    } else {
      await _audioPlayer.resumePlayer();
    }

    notifyListeners();
  }

  void stopPlayback() async {
    if (_audioPlayer != null) {
      await _audioPlayer.stopPlayer();
    }
    _currentPosition = Duration.zero;
    _isPlaying = false;
    notifyListeners();
  }

  void pausePlayback() async {
    await _audioPlayer.pausePlayer();
    _isPlaying = false;
    notifyListeners();
  }

  void seek(double val) {
    if (recordingAvailable) {
      if (_isPlaying) {
        pausePlayback();
      }

      final milliseconds = ((val - val.floor()) * 1000).toInt();

      final duration =
          Duration(seconds: val.floor(), milliseconds: milliseconds);

      _audioPlayer?.seekToPlayer(duration);

      _currentPosition = duration;

      notifyListeners();
    }
  }

  Future<Directory> _getTempDirectory() async {
    Directory appDocDirectory;

    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    return appDocDirectory;
  }

  void _startRecordingMonitoring() async {
    _timer = Timer.periodic(
      Duration(milliseconds: 100),
      _onRecordingUpdate,
    );
  }

  void _onRecordingUpdate(Timer t) async {
    var current = await _recorder.current(channel: 0);

    if (current.status == RecordingStatus.Recording) {
      _isRecording = true;
      _currentPower = current.metering.averagePower;
      _currentPosition = current.duration;
      if (_currentPosition >= _maxDuration) {
        await stopRecording();
      }
      notifyListeners();
    }

    if (current.status == RecordingStatus.Stopped) {
      _isRecording = false;
      _timer.cancel();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.closeAudioSession();
    _audioPlayer = null;
    _playbackTimer?.cancel();
    _recorder?.stop();
    super.dispose();
  }

  initializeFromWeb(String audio) async {
    _currentPath = audio;
    _isLocal = false;

    _duration = Duration.zero;
    _recordingLoaded = true;
    notifyListeners();
  }
}
