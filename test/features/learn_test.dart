import 'package:comma/domain/engine/status.dart';
import 'package:comma/features/learn/articles.dart';
import 'package:comma/features/today/tips.dart';
import 'package:flutter_test/flutter_test.dart';

CycleStatus status(Phase phase, int? daysUntil) =>
    CycleStatus(cycleDay: 10, phase: phase, daysUntilPeriod: daysUntil);

void main() {
  group('articles', () {
    test('ids are unique', () {
      final ids = articles.map((a) => a.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every linked id exists', () {
      for (final id in [
        ArticleIds.periodPain,
        ArticleIds.heavyPeriods,
        ArticleIds.pms,
        ArticleIds.seeADoctor,
        ArticleIds.emergencyContraception,
        ArticleIds.stiTesting,
        ArticleIds.fertileWindow,
        ArticleIds.pregnancyTests,
        ArticleIds.pregnancyWarningSigns,
        ArticleIds.pregnancyLoss,
        ArticleIds.afterBirth,
        ArticleIds.perimenopause,
      ]) {
        expect(articleById(id), isNotNull, reason: id);
      }
    });

    test('every article cites sources and has content', () {
      for (final a in articles) {
        expect(a.sources, isNotEmpty, reason: a.id);
        expect(a.blocks, isNotEmpty, reason: a.id);
      }
    });

    test('every category has articles', () {
      for (final c in ArticleCategory.values) {
        expect(articles.where((a) => a.category == c), isNotEmpty);
      }
    });
  });

  group('tips', () {
    test('no status, no tip', () => expect(tipFor(null), isNull));

    test('period links to pain relief', () {
      expect(
        tipFor(status(Phase.period, 25))!.articleId,
        ArticleIds.periodPain,
      );
    });

    test('just before a period links to PMS', () {
      expect(tipFor(status(Phase.luteal, 3))!.articleId, ArticleIds.pms);
    });

    test('very late period suggests a test', () {
      expect(
        tipFor(status(Phase.luteal, -8))!.articleId,
        ArticleIds.pregnancyTests,
      );
    });

    test('fertile window reminds predictions are estimates', () {
      expect(
        tipFor(status(Phase.fertile, 14))!.articleId,
        ArticleIds.fertileWindow,
      );
    });

    test('quiet follicular days have no tip', () {
      expect(tipFor(status(Phase.follicular, 20)), isNull);
    });
  });
}
