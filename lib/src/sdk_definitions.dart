part of situm_flutter_sdk;

class OnLocationChangedResult {
  final String buildingId;

  const OnLocationChangedResult({
    required this.buildingId,
  });
}

class OnEnteredGeofenceResult {
  final List<Geofence> geofences;

  const OnEnteredGeofenceResult({
    required this.geofences,
  });
}

class OnExitedGeofenceResult {
  final List<Geofence> geofences;

  const OnExitedGeofenceResult({
    required this.geofences,
  });
}

class NamedResource {
  final String id;
  final String name;

  const NamedResource({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return "$name:$id";
  }
}

class Geofence extends NamedResource {
  Geofence({
    required super.id,
    required super.name,
  });
}

class Poi extends NamedResource {
  final String buildingId;

  Poi({
    required super.id,
    required super.name,
    required this.buildingId,
  });
}

class PoiCategory extends NamedResource {
  PoiCategory({
    required super.id,
    required super.name,
  });
}

class ConfigurationOptions {
  final bool useRemoteConfig;
  final CacheMaxAge setCacheMaxAge;

  ConfigurationOptions({
    this.useRemoteConfig = false,
    this.setCacheMaxAge =
        const CacheMaxAge(value: 15, timeUnit: TimeUnit.MINUTES),
  });
}

class CacheMaxAge {
  final int value;
  final TimeUnit timeUnit;

  const CacheMaxAge({
    required this.value,
    required this.timeUnit,
  });

  @override
  String toString() {
    return "value = $value: timeUnit = $timeUnit";
  }
}

enum TimeUnit { DAYS, HOURS, MINUTES, SECONDS }

class PrefetchOptions {
  final bool preloadImages;

  PrefetchOptions({
    this.preloadImages = false,
  });
}

class Error {
  final Int code;
  final String message;

  const Error({required this.code, required this.message});
}

// Result callbacks.

// Location updates.

abstract class LocationListener {
  void onError(Error error);

  void onLocationChanged(OnLocationChangedResult locationChangedResult);

  void onStatusChanged(String status);
}

// On enter geofences.
typedef OnEnteredGeofencesCallback = void Function(
    OnEnteredGeofenceResult onEnterGeofenceResult);

// On exit geofences.
typedef OnExitedGeofencesCallback = void Function(
    OnExitedGeofenceResult onExitGeofenceResult);
