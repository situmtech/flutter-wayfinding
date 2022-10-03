part of situm_flutter_wayfinding;

// The Widget!
class SitumMapView extends StatefulWidget {
  final String situmUser;
  final String situmApiKey;
  final String buildingIdentifier;
  final bool useHybridComponents;
  final bool enablePoiClustering;
  final String searchViewPlaceholder;
  final bool useDashboardTheme;
  final bool showPoiNames;
  final bool hasSearchView;
  final bool lockCameraToBuilding;
  final bool useRemoteConfig;

  const SitumMapView({
    required Key key,
    required this.situmUser,
    required this.situmApiKey,
    required this.buildingIdentifier,
    required this.loadCallback,
    this.useHybridComponents = true,
    this.enablePoiClustering = true,
    this.searchViewPlaceholder = "Situm Flutter Wayfinding",
    this.useDashboardTheme = false,
    this.showPoiNames = false,
    this.hasSearchView = true,
    this.lockCameraToBuilding = false,
    this.useRemoteConfig = false,
  }) : super(key: key);

  final SitumMapViewCallback loadCallback;

  @override
  State<StatefulWidget> createState() => _SitumMapViewState();
}

class _SitumMapViewState extends State<SitumMapView> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> platformViewParams = <String, dynamic>{
      // TODO: add view specific creation params.
    };
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _buildAndroidView(context, platformViewParams);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _buildiOS(context, platformViewParams);
    }
    return Text('$defaultTargetPlatform is not supported by the Situm plugin');
  }

  Future<void> _onPlatformViewCreated(int id) async {
    Map<String, dynamic> loadParams = <String, dynamic>{
      "situmUser": widget.situmUser,
      "situmApiKey": widget.situmApiKey,
      "buildingIdentifier": widget.buildingIdentifier,
      "enablePoiClustering": widget.enablePoiClustering,
      "useHybridComponents": widget.useHybridComponents,
      "searchViewPlaceholder": widget.searchViewPlaceholder,
      "useDashboardTheme": widget.useDashboardTheme,
      "showPoiNames": widget.showPoiNames,
      "hasSearchView": widget.hasSearchView,
      "lockCameraToBuilding": widget.lockCameraToBuilding,
      "useRemoteConfig": widget.useRemoteConfig,
    };
    var controller = SitumFlutterWayfinding(id);
    controller.load(widget.loadCallback, loadParams);
  }

  // ==========================================================================
  // iOS
  // ==========================================================================

  Widget _buildiOS(BuildContext context, Map<String, dynamic> creationParams) {
    const String viewType = '<platform-view-type>';

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  // ==========================================================================
  // ANDROID
  // ==========================================================================

  Widget _buildAndroidView(
      BuildContext context, Map<String, dynamic> creationParams) {
    if (widget.useHybridComponents) {
      return _buildHybrid(context, creationParams);
    }
    return _buildVirtualDisplay(context, creationParams);
  }

  Widget _buildHybrid(
      BuildContext context, Map<String, dynamic> creationParams) {
    log("Using hybrid components");
    return PlatformViewLink(
      viewType: CHANNEL_ID,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as ExpensiveAndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        final AndroidViewController controller =
            PlatformViewsService.initExpensiveAndroidView(
          id: params.id,
          viewType: CHANNEL_ID,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        );
        controller
            .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
        controller.addOnPlatformViewCreatedListener(_onPlatformViewCreated);
        controller.create();
        return controller;
      },
    );
  }

  Widget _buildVirtualDisplay(
      BuildContext context, Map<String, dynamic> creationParams) {
    log("Using virtual display");
    return AndroidView(
      viewType: CHANNEL_ID,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
