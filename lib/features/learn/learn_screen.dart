import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'articles.dart';

void openArticle(BuildContext context, String id) {
  final article = articleById(id);
  if (article == null) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: article)),
  );
}

void openHelp(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const HelpScreen()));

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Learn', style: text.headlineSmall),
        const SizedBox(height: 16),
        Card(
          color: scheme.errorContainer,
          child: ListTile(
            leading: Icon(Icons.support_agent, color: scheme.onErrorContainer),
            title: Text(
              'Get help',
              style: TextStyle(color: scheme.onErrorContainer),
            ),
            subtitle: Text(
              'Confidential support lines and services',
              style: TextStyle(color: scheme.onErrorContainer),
            ),
            trailing: Icon(Icons.chevron_right, color: scheme.onErrorContainer),
            onTap: () => openHelp(context),
          ),
        ),
        for (final category in ArticleCategory.values) ...[
          const SizedBox(height: 24),
          Text(category.label, style: text.titleMedium),
          for (final a in articles.where((a) => a.category == category))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(a.title),
              subtitle: Text(a.summary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => openArticle(context, a.id),
            ),
        ],
        const SizedBox(height: 24),
        Text(
          'This information is general and is not a substitute for advice '
          'from a healthcare professional.',
          style: text.bodySmall,
        ),
      ],
    );
  }
}

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(article.category.label)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text(article.title, style: text.headlineSmall),
          const SizedBox(height: 16),
          for (final block in article.blocks)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: switch (block) {
                Heading(:final text) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Para(:final text) => Text(text),
                Bullets(:final items) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      ),
                  ],
                ),
                Callout(:final text, :final urgent) => Card(
                  color: urgent
                      ? scheme.errorContainer
                      : scheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          urgent ? Icons.warning_amber : Icons.info_outline,
                          color: urgent
                              ? scheme.onErrorContainer
                              : scheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: urgent
                                  ? scheme.onErrorContainer
                                  : scheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              },
            ),
          if (article.blocks.any((b) => b is Callout && b.urgent))
            OutlinedButton.icon(
              icon: const Icon(Icons.support_agent),
              label: const Text('Get help'),
              onPressed: () => openHelp(context),
            ),
          const SizedBox(height: 24),
          Text('Sources', style: text.titleSmall),
          for (final s in article.sources) Text(s, style: text.bodySmall),
          const SizedBox(height: 16),
          Text(
            'General information only, not medical advice. If you\'re '
            'worried about your health, contact a healthcare provider.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((_) => false);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not open ${uri.path}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Get help')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Card(
            color: scheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'In an emergency, call your local emergency number: 911 (US '
                'and Canada), 999 (UK), 112 (EU), 000 (Australia).',
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ),
          for (final MapEntry(key: region, value: resources)
              in helpResources.entries) ...[
            const SizedBox(height: 24),
            Text(region, style: text.titleMedium),
            for (final r in resources)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: text.titleSmall),
                    Text(r.description),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (r.phone case final phone?)
                          ActionChip(
                            avatar: const Icon(Icons.call, size: 18),
                            label: Text('Call ${_formatPhone(phone)}'),
                            onPressed: () =>
                                _open(context, Uri(scheme: 'tel', path: phone)),
                          ),
                        if (r.sms case (final number, final body))
                          ActionChip(
                            avatar: const Icon(Icons.sms_outlined, size: 18),
                            label: Text('Text $number'),
                            onPressed: () => _open(
                              context,
                              Uri(
                                scheme: 'sms',
                                path: number,
                                queryParameters: body == null
                                    ? null
                                    : {'body': body},
                              ),
                            ),
                          ),
                        if (r.url case final url?)
                          ActionChip(
                            avatar: const Icon(Icons.open_in_new, size: 18),
                            label: Text(Uri.parse(url).host),
                            onPressed: () => _open(context, Uri.parse(url)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 24),
          Text(
            'Comma has no connection to these services and shares nothing '
            'with them. Calls and links open in your phone\'s own apps.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }

  static String _formatPhone(String digits) => switch (digits) {
    '18006564673' => '1-800-656-4673',
    '18007997233' => '1-800-799-7233',
    '08085002222' => '0808 500 2222',
    '08082000247' => '0808 2000 247',
    '116123' => '116 123',
    '1800737732' => '1800 737 732',
    '131114' => '13 11 14',
    _ => digits,
  };
}
