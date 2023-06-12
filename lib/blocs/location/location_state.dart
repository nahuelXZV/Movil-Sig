part of 'location_bloc.dart';

class LocationState extends Equatable {

  final bool followingUser;
  final LatLng? lastKnowLocation;
  // final List<LatLng> myLocationHistory;

  final String? locationPlace;


  const LocationState({
    this.followingUser = false,
    this.lastKnowLocation,
    // myLocationHistory, 
    this.locationPlace,
  });
  // const LocationState({
  //   this.followingUser = false,
  //   this.lastKnowLocation,
  //   myLocationHistory, 
  //   this.locationPlace,
  // }): myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith ({
    final bool? followingUser,
    final LatLng? lastKnowLocation,
    final List<LatLng>? myLocationHistory,
    final String? locationPlace,
  }) => LocationState(
    followingUser: followingUser ?? this.followingUser,
    lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
    // myLocationHistory: myLocationHistory ?? this.myLocationHistory,  
    locationPlace: locationPlace ?? this.locationPlace, 
  );
  
  @override
  List<Object?> get props => [followingUser, lastKnowLocation, locationPlace];
  // List<Object?> get props => [followingUser, lastKnowLocation, myLocationHistory, locationPlace];
}
