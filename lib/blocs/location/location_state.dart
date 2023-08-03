part of 'location_bloc.dart';

class LocationState extends Equatable {

  final bool followingUser;
  final LatLng? lastKnowLocation;

  const LocationState({
    this.followingUser = false,
    this.lastKnowLocation,
  });


  LocationState copyWith ({
    final bool? followingUser,
    final LatLng? lastKnowLocation,
  }) => LocationState(
    followingUser: followingUser ?? this.followingUser,
    lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation, 
  );
  
  @override
  List<Object?> get props => [followingUser, lastKnowLocation ];
  
}
