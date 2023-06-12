part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool followUser; //creo que no se ocupa
  final Map<String, Marker> markers;

  const MapState({
    this.isMapInitialized = false,
    this.followUser = false,
    Map<String, Marker>? markers,
  })
  : markers = markers ?? const{};

  MapState copyWith({
    bool? isMapInitialized,
    bool? followUser, //creo que no se ocupa
    Map<String, Marker>? markers,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    followUser: followUser ?? this.followUser, //creo que no se ocupa
    markers: markers ?? this.markers,
  );

  
  @override
  List<Object> get props => [
    isMapInitialized,
    followUser,
    markers,
  ];
}

