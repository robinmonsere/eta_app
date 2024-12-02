enum StatisticsFilter {
  all('All'),
  today('Today'),
  sevenDays('7 days'),
  twoWeeks('2 weeks'),
  oneMonth('1 month');

  final String displayText;
  const StatisticsFilter(this.displayText);

  String getDisplayText() => displayText;
}

enum PostFilterOption {
  all('All'),
  techPosted('Tech, posted'),
  techNotPosted('Tech, not posted'),
  replies('Replies'),
  quotes('Quotes'),
  posts('Posts'),
  reposts('Reposts');

  final String displayText;
  const PostFilterOption(this.displayText);

  String getDisplayText() => displayText;
}


