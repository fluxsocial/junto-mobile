part of 'channel_filtering_bloc.dart';

@immutable
abstract class ChannelFilteringState extends Equatable {
  const ChannelFilteringState(this.selectedChannel);
  final Channel selectedChannel;
}

class ChannelsInitialState extends ChannelFilteringState {
  const ChannelsInitialState() : super(null);

  @override
  List<Object> get props => [];
}

class ChannelsPopulatedState extends ChannelFilteringState {
  const ChannelsPopulatedState(this.channels, Channel selectedChannel)
      : super(selectedChannel);
  final List<Channel> channels;
  @override
  List<Object> get props => [selectedChannel, channels];
}

class ChannelsErrorState extends ChannelFilteringState {
  const ChannelsErrorState() : super(null);
  @override
  List<Object> get props => [];
}
