part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser; //creo que no se ocupa
  // final bool isMarkerSearched;
  // final Marker? markerSearched;
  final bool isEdificioSearched;
  final Edificio? edificioSearched;

  final RouteDestination? routeDriving;
  final RouteDestination? routeWalking;

  final bool isDriving;
  final Map<String, Marker> markers;
  final Map<String, Polyline> polylines;

  const MapState({
    this.isMapInitialized = false,
    this.followUser = false,
    // this.isMarkerSearched = false,
    // this.markerSearched,
    this.isEdificioSearched = false,
    this.edificioSearched,
    this.routeDriving,
    this.routeWalking,
    this.isDriving = true,
    Map<String, Marker>? markers,
    Map<String, Polyline>? polylines,
  })
  : markers = markers ?? const{},
    polylines = polylines ?? const{};

  MapState copyWith({
    bool? isMapInitialized,
    bool? followUser, //creo que no se ocupa
    // bool? isMarkerSearched,
    // Marker? markerSearched,
    bool? isEdificioSearched,
    Edificio? edificioSearched,
    RouteDestination? routeDriving,
    RouteDestination? routeWalking,
    bool? isDriving,
    Map<String, Marker>? markers,
    Map<String, Polyline>? polylines,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    followUser: followUser ?? this.followUser, //creo que no se ocupa
    // isMarkerSearched: isMarkerSearched ?? this.isMarkerSearched,
    // markerSearched: markerSearched ?? this.markerSearched,
    isEdificioSearched: isEdificioSearched ?? this.isEdificioSearched,
    edificioSearched: edificioSearched ?? this.edificioSearched,
    routeDriving: routeDriving ?? this.routeDriving,
    routeWalking: routeWalking ?? this.routeWalking,
    isDriving: isDriving ?? this.isDriving,
    markers: markers ?? this.markers,
    polylines: polylines ?? this.polylines,
  );

  
  @override
  List<Object?> get props => [
    isMapInitialized,
    followUser,
    // isMarkerSearched,
    // markerSearched,
    isEdificioSearched,
    edificioSearched,
    routeDriving,
    routeWalking,
    isDriving,
    markers,
    polylines,
  ];
}

