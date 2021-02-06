extension SecondRounder on Duration {
  Duration secondCeilRounder(Duration max) {
    int roundedDuration;

    if (inMilliseconds > (inSeconds * 1000)) {
      roundedDuration = inSeconds + 1;
    } else {
      roundedDuration = inSeconds;
    }

    return Duration(seconds: roundedDuration).compareTo(max) < 1
        ? Duration(seconds: roundedDuration)
        : max;
  }

  Duration secondFloorRounder() {
    return Duration(seconds: inSeconds);
  }
}
