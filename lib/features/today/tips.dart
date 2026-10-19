import '../../domain/engine/status.dart';
import '../../domain/modes.dart';
import '../learn/articles.dart';

class Tip {
  const Tip(this.text, this.articleId);
  final String text;
  final String articleId;
}

/// A short, relevant tip for where the user is in their cycle.
Tip? tipFor(CycleStatus? status, {TrackingMode mode = TrackingMode.standard}) {
  if (status == null) return null;
  if (status.phase == Phase.period) {
    return const Tip(
      'Cramps? Heat on your lower belly and an anti-inflammatory '
      'painkiller taken early often help.',
      ArticleIds.periodPain,
    );
  }
  if (mode == TrackingMode.perimenopause) {
    return const Tip(
      'Irregular cycles are common in perimenopause, so predictions are '
      'rougher. Here\'s what else to expect.',
      ArticleIds.perimenopause,
    );
  }
  if (status.daysUntilPeriod case final d? when d < -7) {
    return const Tip(
      'Your period is more than a week late. A pregnancy test is most '
      'reliable from now on.',
      ArticleIds.pregnancyTests,
    );
  }
  if (status.phase == Phase.fertile || status.phase == Phase.ovulation) {
    return mode == TrackingMode.ttc
        ? const Tip(
            'Having sex every 1 to 2 days during your fertile window gives '
            'the best chance of getting pregnant.',
            ArticleIds.fertileWindow,
          )
        : const Tip(
            'You may be in your fertile window. Remember, predictions are '
            'estimates and not contraception.',
            ArticleIds.fertileWindow,
          );
  }
  if (status.daysUntilPeriod case final d? when d >= 0 && d <= 5) {
    return const Tip(
      'Mood or body changes before your period are common. Here\'s what '
      'can help.',
      ArticleIds.pms,
    );
  }
  return null;
}
