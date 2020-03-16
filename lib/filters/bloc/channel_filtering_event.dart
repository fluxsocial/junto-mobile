part of 'channel_filtering_bloc.dart';

@immutable
abstract class ChannelFilteringEvent {}

class FilterQueryUpdated extends ChannelFilteringEvent {
  FilterQueryUpdated(this.term);
  final String term;
}

// user taps on a filter and this is applied to the feed
class FilterSelected extends ChannelFilteringEvent {
  FilterSelected(this.item, this.contextType);
  final Channel item;
  //TODO: change to some enum e.g. ExpressionContextType
  final String contextType;
}

class FilterReset extends ChannelFilteringEvent {}
