part of 'channel_filtering_bloc.dart';

@immutable
abstract class ChannelFilteringState {}

class ChannelsLoadingState extends ChannelFilteringState {}

class ChannelsPopulatedState extends ChannelFilteringState {
  ChannelsPopulatedState(this.channels, this.selectedChannel);
  final List<Channel> channels;
  final Channel selectedChannel;
}

class ChannelsErrorState extends ChannelFilteringState {}
