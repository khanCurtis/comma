/// Built-in symptoms and moods. Keys are stored in the database and must
/// never change; labels can.
class SymptomDef {
  const SymptomDef(this.key, this.label);
  final String key;
  final String label;
}

const physicalSymptoms = [
  SymptomDef('cramps', 'Cramps'),
  SymptomDef('headache', 'Headache'),
  SymptomDef('bloating', 'Bloating'),
  SymptomDef('breast_tenderness', 'Tender breasts'),
  SymptomDef('acne', 'Acne'),
  SymptomDef('back_pain', 'Back pain'),
  SymptomDef('nausea', 'Nausea'),
  SymptomDef('fatigue', 'Fatigue'),
  SymptomDef('cravings', 'Cravings'),
  SymptomDef('insomnia', 'Insomnia'),
  SymptomDef('diarrhea', 'Diarrhea'),
  SymptomDef('constipation', 'Constipation'),
  SymptomDef('unusual_discharge', 'Unusual discharge'),
  SymptomDef('pelvic_pain', 'Pelvic pain'),
  SymptomDef('dizziness', 'Dizziness'),
  SymptomDef('hot_flashes', 'Hot flushes'),
  SymptomDef('night_sweats', 'Night sweats'),
];

const moods = [
  SymptomDef('mood.calm', 'Calm'),
  SymptomDef('mood.happy', 'Happy'),
  SymptomDef('mood.energetic', 'Energetic'),
  SymptomDef('mood.irritable', 'Irritable'),
  SymptomDef('mood.anxious', 'Anxious'),
  SymptomDef('mood.sad', 'Sad'),
  SymptomDef('mood.mood_swings', 'Mood swings'),
  SymptomDef('mood.low_energy', 'Low energy'),
];

const severityLabels = ['', 'mild', 'moderate', 'severe'];

String symptomLabel(String key) {
  for (final s in [...physicalSymptoms, ...moods]) {
    if (s.key == key) return s.label;
  }
  return key.replaceFirst('custom.', '');
}
