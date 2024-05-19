class MapScreenController {
  static const chooseBeginingPoint = 0;
  static const chooseEndPoint = 1;
  static const requestTrip = 2;
  int curentState = 0;
  List screenStates = [chooseBeginingPoint];

  chooseStateOnForward() {
    switch (screenStates.last) {
      case chooseBeginingPoint:
        screenStates.add(chooseEndPoint);

        break;

      case chooseEndPoint:
        screenStates.add(requestTrip);

        break;

      case requestTrip:
        break;
    }
    curentState = screenStates.last;
  }

  chooseStateOnBack() {
    if (screenStates.length > 1) {
      screenStates.removeLast();
      curentState = screenStates.last;
    }
  }
}
