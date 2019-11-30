import 'dart:async';

extension StreamControllerExtension<T> on StreamController<T> {
  setStreamListener(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    if (!this.hasListener) {
      this.stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    }
  }
}
