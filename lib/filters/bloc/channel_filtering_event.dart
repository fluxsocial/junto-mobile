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
  final ExpressionContextType contextType;
}

class FilterReset extends ChannelFilteringEvent {}
