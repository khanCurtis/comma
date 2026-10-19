/// Health information written for Comma. Keep it accurate, short and
/// non-judgmental, cite sources, and always point to professional care.
library;

enum ArticleCategory {
  periods('Periods'),
  sexualHealth('Sex & relationships'),
  fertility('Fertility & pregnancy'),
  lifeStages('After birth & menopause');

  const ArticleCategory(this.label);
  final String label;
}

sealed class Block {
  const Block();
}

class Heading extends Block {
  const Heading(this.text);
  final String text;
}

class Para extends Block {
  const Para(this.text);
  final String text;
}

class Bullets extends Block {
  const Bullets(this.items);
  final List<String> items;
}

/// A highlighted box. [urgent] is for "get help now" information.
class Callout extends Block {
  const Callout(this.text, {this.urgent = false});
  final String text;
  final bool urgent;
}

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.blocks,
    required this.sources,
  });

  final String id;
  final String title;
  final String summary;
  final ArticleCategory category;
  final List<Block> blocks;
  final List<String> sources;
}

/// Stable ids used to link to articles from elsewhere in the app.
abstract final class ArticleIds {
  static const periodPain = 'period-pain';
  static const heavyPeriods = 'heavy-periods';
  static const pms = 'pms';
  static const seeADoctor = 'see-a-doctor';
  static const emergencyContraception = 'emergency-contraception';
  static const stiTesting = 'sti-testing';
  static const fertileWindow = 'fertile-window';
  static const pregnancyTests = 'pregnancy-tests';
  static const pregnancyWarningSigns = 'pregnancy-warning-signs';
  static const pregnancyLoss = 'pregnancy-loss';
  static const afterBirth = 'after-birth';
  static const perimenopause = 'perimenopause';
}

Article? articleById(String id) {
  for (final a in articles) {
    if (a.id == id) return a;
  }
  return null;
}

const articles = <Article>[
  // ---------------------------------------------------------------- Periods
  Article(
    id: ArticleIds.periodPain,
    title: 'Easing period pain',
    summary: 'What helps with cramps, and when pain needs a doctor.',
    category: ArticleCategory.periods,
    blocks: [
      Para(
        'Cramps happen when the uterus contracts to shed its lining. Some '
        'discomfort is common, but pain that stops you doing everyday '
        'things is not something you have to put up with.',
      ),
      Heading('Things that often help'),
      Bullets([
        'Heat: a heating pad, hot water bottle or warm bath on your lower '
            'belly or back.',
        'Anti-inflammatory painkillers such as ibuprofen or naproxen. They '
            'work best taken as soon as pain starts. Follow the packet dose, '
            'and check with a pharmacist if you have asthma, stomach ulcers, '
            'kidney problems or are pregnant.',
        'Gentle movement: walking, stretching, yoga or swimming.',
        'Rest and sleep, and cutting down on alcohol and smoking.',
        'Hormonal birth control can make periods lighter and less painful. '
            'Ask a healthcare provider whether it suits you.',
      ]),
      Heading('See a doctor if'),
      Bullets([
        'Painkillers and heat don\'t help, or pain makes you miss school or '
            'work.',
        'Pain is new, or much worse than your usual periods.',
        'You also have pain during sex, pain with bowel movements, or pain '
            'between periods. These can be signs of conditions like '
            'endometriosis, which are treatable.',
      ]),
      Callout(
        'Get urgent care for sudden, severe pain in your lower belly, '
        'especially with fever, fainting, or if you could be pregnant.',
        urgent: true,
      ),
    ],
    sources: [
      'NHS: Period pain',
      'ACOG: Dysmenorrhea: Painful Periods (FAQ046)',
    ],
  ),
  Article(
    id: 'period-products',
    title: 'Choosing period products',
    summary: 'Pads, tampons, cups, discs and period underwear.',
    category: ArticleCategory.periods,
    blocks: [
      Para(
        'There is no single right choice. Many people use different '
        'products on different days.',
      ),
      Bullets([
        'Pads: worn in underwear. Change every few hours, or sooner if full.',
        'Tampons: change every 4 to 8 hours. Use the lowest absorbency that '
            'works for your flow, and never leave one in longer than 8 hours.',
        'Menstrual cups and discs: reusable, worn inside for up to 12 hours. '
            'Empty, rinse and sterilise them as the maker describes.',
        'Period underwear: absorbent and reusable. Good for lighter days or '
            'as backup.',
      ]),
      Heading('Toxic shock syndrome (TSS)'),
      Para(
        'TSS is rare but serious, and is linked to tampons and other '
        'internal products left in too long.',
      ),
      Callout(
        'If you get a sudden high fever, a sunburn-like rash, vomiting, '
        'diarrhoea, dizziness or confusion while using an internal product, '
        'remove it and get emergency medical help.',
        urgent: true,
      ),
    ],
    sources: ['NHS: Toxic shock syndrome', 'FDA: Menstrual tampons and pads'],
  ),
  Article(
    id: ArticleIds.heavyPeriods,
    title: 'Heavy periods',
    summary: 'How to tell if your bleeding is heavier than it should be.',
    category: ArticleCategory.periods,
    blocks: [
      Para(
        'Heavy bleeding is common and treatable, but it often goes '
        'unmentioned because people assume it\'s normal for them.',
      ),
      Heading('Your period may be heavy if you'),
      Bullets([
        'Soak through a pad or tampon every 1 to 2 hours, for several hours '
            'in a row.',
        'Need to use two products at once, or change during the night.',
        'Pass clots larger than about 2.5 cm (an inch).',
        'Bleed for more than 8 days.',
        'Feel tired, dizzy or short of breath. These can be signs of low '
            'iron (anaemia).',
      ]),
      Para(
        'A doctor can check for causes such as fibroids, polyps, thyroid '
        'problems or bleeding disorders, and test your iron. Treatments '
        'include medicines, hormonal options and iron supplements.',
      ),
      Callout(
        'Get urgent care if you are soaking through a pad every hour and '
        'feel faint, or if you could be pregnant.',
        urgent: true,
      ),
      Para(
        'Comma\'s report for doctors includes your period lengths and '
        'flow, which can help that conversation.',
      ),
    ],
    sources: [
      'NHS: Heavy periods',
      'CDC: Heavy Menstrual Bleeding',
      'FIGO System 1 (Munro et al., 2018)',
    ],
  ),
  Article(
    id: ArticleIds.pms,
    title: 'PMS and PMDD',
    summary: 'Mood and body changes before a period, and what helps.',
    category: ArticleCategory.periods,
    blocks: [
      Para(
        'In the week or two before a period, many people notice mood '
        'changes, bloating, sore breasts, headaches, tiredness or '
        'cravings. This is premenstrual syndrome (PMS).',
      ),
      Heading('Things that may help'),
      Bullets([
        'Regular exercise and enough sleep.',
        'Eating regularly, and cutting down on caffeine, alcohol and salt.',
        'Tracking symptoms in Comma, to see your pattern and plan around it.',
        'Some people benefit from hormonal birth control or other '
            'medicines. A healthcare provider can talk through options.',
      ]),
      Heading('PMDD'),
      Para(
        'Premenstrual dysphoric disorder (PMDD) is a more severe form, '
        'with strong depression, anxiety, anger or hopelessness that lifts '
        'once a period starts. It is a recognised medical condition and '
        'can be treated.',
      ),
      Callout(
        'If you have thoughts of harming yourself, at any point in your '
        'cycle, please reach out now. See "Get help" for support lines.',
        urgent: true,
      ),
    ],
    sources: [
      'NHS: PMS (premenstrual syndrome)',
      'ACOG: Premenstrual Syndrome (FAQ057)',
    ],
  ),
  Article(
    id: ArticleIds.seeADoctor,
    title: 'When to see a doctor',
    summary: 'Cycle changes worth getting checked.',
    category: ArticleCategory.periods,
    blocks: [
      Para(
        'Cycles vary from person to person, and can change with age, '
        'stress, illness and medication. Consider seeing a healthcare '
        'provider if:',
      ),
      Bullets([
        'Your cycles are regularly shorter than 24 days or longer than 38.',
        'Your cycle length varies by more than 7 to 9 days.',
        'Your period lasts more than 8 days, or is very heavy.',
        'You haven\'t had a period for 3 months and aren\'t pregnant.',
        'You bleed between periods, or after sex.',
        'Period pain stops you from doing everyday things.',
        'You have any bleeding after menopause.',
      ]),
      Para(
        'Comma flags some of these patterns under Insights. Bring the '
        'doctor report: it summarises your cycles and symptoms.',
      ),
    ],
    sources: [
      'FIGO System 1 (Munro et al., 2018)',
      'ACOG: Abnormal Uterine Bleeding (FAQ095)',
    ],
  ),

  // ------------------------------------------------------ Sexual health
  Article(
    id: ArticleIds.emergencyContraception,
    title: 'Emergency contraception',
    summary: 'Options after unprotected sex or if contraception failed.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'If you had sex without contraception, or something went wrong '
        '(a condom broke or slipped, or you missed pills), emergency '
        'contraception can lower the chance of pregnancy. The sooner, the '
        'better.',
      ),
      Heading('Options'),
      Bullets([
        'Copper IUD: the most effective option. It can be fitted up to 5 '
            'days after sex, and can then be kept as ongoing contraception.',
        'Ulipristal acetate pill: works up to 5 days (120 hours) after sex.',
        'Levonorgestrel pill: works up to 3 days (72 hours) after sex, and '
            'works best when taken as soon as possible.',
      ]),
      Para(
        'Pills may be less effective at higher body weights, and some '
        'medicines interact with them. A pharmacist or clinic can help you '
        'choose. In many countries, pills are available from a pharmacy '
        'without a prescription.',
      ),
      Para(
        'Emergency contraception does not end an existing pregnancy, and '
        'does not protect against STIs.',
      ),
      Callout(
        'Comma\'s fertile window is only an estimate. Don\'t use it to '
        'decide whether you need emergency contraception.',
      ),
    ],
    sources: [
      'NHS: Emergency contraception',
      'WHO: Emergency contraception fact sheet',
      'ACOG: Emergency Contraception (FAQ114)',
    ],
  ),
  Article(
    id: ArticleIds.stiTesting,
    title: 'STI testing',
    summary: 'Many infections have no symptoms. Testing is quick and normal.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'Sexually transmitted infections (STIs) are common, and many, '
        'such as chlamydia, often cause no symptoms at all. Most are easy '
        'to treat, and finding them early prevents problems later.',
      ),
      Heading('Consider testing'),
      Bullets([
        'Before having sex with a new partner, or after.',
        'Regularly, if you have more than one partner.',
        'If a partner tells you they have an STI.',
        'If you notice unusual discharge, sores, itching, burning when you '
            'pee, pelvic pain, or bleeding after sex.',
      ]),
      Heading('Lowering your risk'),
      Bullets([
        'External and internal condoms, and dental dams.',
        'HPV and hepatitis B vaccines.',
        'PrEP, a medicine that prevents HIV, for people at higher risk.',
      ]),
      Callout(
        'If you may have been exposed to HIV, PEP medicine can prevent '
        'infection. It must be started within 72 hours, and the sooner the '
        'better. Go to a sexual health clinic or emergency department.',
        urgent: true,
      ),
    ],
    sources: [
      'CDC: STI screening recommendations',
      'NHS: Sexually transmitted infections',
      'WHO: HIV post-exposure prophylaxis',
    ],
  ),
  Article(
    id: 'contraception',
    title: 'Contraception options',
    summary: 'An overview of methods and how well they work.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'How well a method works in real life ("typical use") depends a '
        'lot on how easy it is to use correctly every time. Approximate '
        'pregnancies per 100 people in a year of typical use:',
      ),
      Bullets([
        'Implant: fewer than 1',
        'Hormonal or copper IUD: fewer than 1',
        'Injection: about 4',
        'Pill, patch or ring: about 7',
        'External (male) condom: about 13',
        'Withdrawal: about 20',
        'Fertility awareness methods: about 2 to 23, depending on the method '
            'and training',
      ]),
      Para(
        'Condoms are the only method that also lowers the risk of STIs, '
        'so many people use them together with another method.',
      ),
      Callout(
        'Comma is not a contraceptive. Its predictions are estimates and '
        'must not be used to decide when sex is "safe".',
      ),
      Para(
        'A healthcare provider or sexual health clinic can help you find '
        'a method that fits your health and life.',
      ),
    ],
    sources: [
      'CDC: Contraception (effectiveness of family planning methods)',
      'NHS: Your contraception guide',
    ],
  ),
  Article(
    id: 'painful-sex',
    title: 'Pain during sex',
    summary: 'Common, often treatable, and not something to push through.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'Pain during or after sex is common, but it isn\'t something you '
        'should have to endure. It\'s okay to stop at any time.',
      ),
      Heading('Possible causes'),
      Bullets([
        'Not enough lubrication or arousal. More time and a water- or '
            'silicone-based lubricant can help.',
        'Infections such as thrush or STIs.',
        'Vaginismus: involuntary tightening of the vaginal muscles.',
        'Endometriosis, fibroids or ovarian cysts, especially with deep pain.',
        'Hormonal changes after childbirth, while breastfeeding, or around '
            'menopause.',
        'Stress, anxiety or past trauma.',
      ]),
      Para(
        'A doctor, sexual health clinic or pelvic floor physiotherapist '
        'can help find the cause. Most causes can be treated.',
      ),
    ],
    sources: ['NHS: Pain during sex', 'ACOG: When Sex Is Painful (FAQ020)'],
  ),
  Article(
    id: 'libido',
    title: 'Changes in sex drive',
    summary: 'Why desire goes up and down, and when to ask for help.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'Wanting more or less sex at different times is normal. Some '
        'people notice their desire changes across their cycle.',
      ),
      Heading('Things that can lower sex drive'),
      Bullets([
        'Stress, tiredness, depression or anxiety.',
        'Some medicines, including some antidepressants and hormonal '
            'contraceptives.',
        'Relationship problems, or pain during sex.',
        'Pregnancy, the time after giving birth, and menopause.',
      ]),
      Para(
        'If a change in your sex drive bothers you, talk to a healthcare '
        'provider. There is often a cause that can be addressed.',
      ),
    ],
    sources: ['NHS: Loss of libido'],
  ),
  Article(
    id: 'consent',
    title: 'Consent and safety',
    summary: 'Your right to say no, and what to do if something happened.',
    category: ArticleCategory.sexualHealth,
    blocks: [
      Para(
        'Consent means freely and clearly agreeing to sexual activity. You '
        'can change your mind at any time, including partway through. '
        'Someone who is asleep, very drunk or pressured cannot consent.',
      ),
      Para(
        'Controlling someone\'s contraception, such as hiding pills, '
        'damaging condoms or pressuring someone to get pregnant, is a form '
        'of abuse called reproductive coercion.',
      ),
      Heading('If you have been sexually assaulted'),
      Bullets([
        'It is not your fault.',
        'If you are in danger, call your local emergency number.',
        'Medical care can help even if you don\'t want to report it: '
            'emergency contraception, PEP to prevent HIV (within 72 hours), '
            'STI tests and treatment for injuries.',
        'Specialist services can collect evidence and support you, at your '
            'own pace.',
      ]),
      Callout('See "Get help" for confidential support lines.', urgent: true),
    ],
    sources: ['RAINN', 'NHS: Help after rape and sexual assault'],
  ),

  // ------------------------------------------------- Fertility & pregnancy
  Article(
    id: ArticleIds.fertileWindow,
    title: 'Understanding your fertile window',
    summary: 'What Comma\'s fertility estimates mean, and their limits.',
    category: ArticleCategory.fertility,
    blocks: [
      Para(
        'Pregnancy is possible on about 6 days of each cycle: the 5 days '
        'before ovulation and the day of ovulation. Sperm can survive for '
        'up to 5 days, and an egg for about a day.',
      ),
      Para(
        'Comma estimates ovulation from your past cycle lengths. Logging '
        'basal body temperature, ovulation (LH) tests and cervical mucus '
        'helps confirm when it actually happened, but ovulation can still '
        'arrive earlier or later than expected in any cycle.',
      ),
      Callout(
        'These estimates are not contraception. If you don\'t want to get '
        'pregnant, use a contraceptive method every time.',
      ),
      Heading('If you\'re trying to get pregnant'),
      Bullets([
        'Having sex every 1 to 2 days during the fertile window gives the '
            'best chance.',
        'Take folic acid (400 micrograms a day) from before conception until '
            '12 weeks of pregnancy.',
        'See a doctor if you aren\'t pregnant after 12 months of trying (or '
            '6 months if you are 35 or older), or sooner if your cycles are '
            'irregular.',
      ]),
    ],
    sources: [
      'Wilcox et al., NEJM 1995: Timing of sexual intercourse in relation to '
          'ovulation',
      'ACOG: Evaluating Infertility (FAQ136)',
      'NHS: Trying to get pregnant',
    ],
  ),
  Article(
    id: ArticleIds.pregnancyTests,
    title: 'Pregnancy tests',
    summary: 'When to test, and warning signs to know about.',
    category: ArticleCategory.fertility,
    blocks: [
      Para(
        'Home pregnancy tests detect the hormone hCG in urine. They are '
        'most reliable from the first day of a missed period. Testing '
        'earlier can give a negative result even if you are pregnant.',
      ),
      Bullets([
        'If your cycles are irregular, test 3 weeks after unprotected sex.',
        'If a test is negative but your period still hasn\'t come, test '
            'again a few days later.',
        'If a test is positive, contact a healthcare provider to talk about '
            'your options.',
      ]),
      Callout(
        'Get urgent care if you could be pregnant and have pain on one side '
        'of your lower belly, pain in the tip of your shoulder, vaginal '
        'bleeding, or feel faint. These can be signs of an ectopic '
        'pregnancy.',
        urgent: true,
      ),
    ],
    sources: ['NHS: Doing a pregnancy test', 'NHS: Ectopic pregnancy'],
  ),
  Article(
    id: ArticleIds.pregnancyWarningSigns,
    title: 'Pregnancy warning signs',
    summary: 'Symptoms that need a call to your midwife or doctor now.',
    category: ArticleCategory.fertility,
    blocks: [
      Para(
        'Most aches and changes in pregnancy are normal, but some need '
        'to be checked the same day. Trust your instincts: if something '
        'feels wrong, call.',
      ),
      Callout(
        'Contact your midwife, doctor or maternity unit straight away, or '
        'call emergency services, if you have:',
        urgent: true,
      ),
      Bullets([
        'Bleeding from the vagina.',
        'Severe or constant pain in your belly.',
        'A bad headache that won\'t go away, problems with your vision, or '
            'sudden swelling of your face, hands or feet. These can be signs '
            'of pre-eclampsia.',
        'A high temperature, or feeling very unwell.',
        'Your baby moving less than usual, or not at all, from about 24 '
            'weeks. Don\'t wait until the next day.',
        'Fluid leaking from your vagina before 37 weeks.',
        'Intense itching, especially on your hands and feet.',
        'Thoughts of harming yourself or your baby.',
      ]),
    ],
    sources: [
      'NHS: Pregnancy, when to get help',
      'NHS: Pre-eclampsia',
      'NHS: Your baby\'s movements',
    ],
  ),
  Article(
    id: ArticleIds.pregnancyLoss,
    title: 'Pregnancy loss',
    summary: 'Support after a miscarriage or other loss.',
    category: ArticleCategory.fertility,
    blocks: [
      Para(
        'Losing a pregnancy is common, but that doesn\'t make it any '
        'easier. Whatever you\'re feeling is valid, and it is not your '
        'fault. Most losses happen because of things nobody could have '
        'prevented.',
      ),
      Heading('Looking after your body'),
      Bullets([
        'Bleeding and cramps can continue for a couple of weeks.',
        'Your period usually returns within 4 to 8 weeks.',
        'You can get pregnant again before your next period, so use '
            'contraception if you don\'t want to.',
      ]),
      Callout(
        'Get urgent care for very heavy bleeding (soaking a pad every '
        'hour), severe pain, a high temperature, or smelly discharge.',
        urgent: true,
      ),
      Heading('Looking after yourself'),
      Para(
        'Grief can come in waves, for you and for a partner. Talking to '
        'someone you trust, your doctor, or a pregnancy loss charity can '
        'help. Comma has left this cycle out of your averages, so it '
        'won\'t affect your predictions.',
      ),
    ],
    sources: ['NHS: Miscarriage', 'ACOG: Early Pregnancy Loss (FAQ090)'],
  ),
  Article(
    id: ArticleIds.afterBirth,
    title: 'Your body after giving birth',
    summary: 'Bleeding, when periods return, and getting help.',
    category: ArticleCategory.lifeStages,
    blocks: [
      Para(
        'Bleeding after birth (lochia) is normal and can last up to six '
        'weeks. Comma doesn\'t count it as a period.',
      ),
      Heading('When will my period come back?'),
      Bullets([
        'If you\'re not breastfeeding, often within 5 to 6 weeks, but it '
            'varies.',
        'If you\'re breastfeeding, it can take months, sometimes until you '
            'stop or breastfeed less.',
        'Your first few cycles may be irregular. Predictions will improve '
            'once you\'ve logged a few.',
      ]),
      Callout(
        'You can get pregnant before your first period returns, as early '
        'as 3 weeks after birth. Talk to your midwife or doctor about '
        'contraception.',
      ),
      Heading('Get help'),
      Bullets([
        'Get urgent care for sudden heavy bleeding or large clots, a high '
            'temperature, severe headache, or pain or swelling in one leg.',
        'Feeling low, anxious or unable to cope for more than two weeks '
            'can be postnatal depression. It\'s common and treatable: talk '
            'to your doctor or health visitor.',
      ]),
    ],
    sources: [
      'NHS: Your post-pregnancy body',
      'NHS: Contraception after having a baby',
      'NHS: Postnatal depression',
    ],
  ),
  Article(
    id: ArticleIds.perimenopause,
    title: 'Perimenopause',
    summary: 'The years leading up to menopause, and what to expect.',
    category: ArticleCategory.lifeStages,
    blocks: [
      Para(
        'Perimenopause is the time when hormone levels start to change '
        'before periods stop for good. It usually begins in your 40s and '
        'can last several years.',
      ),
      Heading('Common changes'),
      Bullets([
        'Periods becoming irregular: closer together, further apart, '
            'heavier or lighter.',
        'Hot flushes and night sweats.',
        'Trouble sleeping, low mood, anxiety or brain fog.',
        'Vaginal dryness and lower sex drive.',
      ]),
      Para(
        'Menopause is reached 12 months after your last period. Until '
        'then, you can still get pregnant, so keep using contraception if '
        'you don\'t want to.',
      ),
      Para(
        'A doctor can talk to you about treatments such as hormone '
        'replacement therapy (HRT) if symptoms affect your life.',
      ),
      Callout(
        'See a doctor about any bleeding after menopause, very heavy '
        'periods, or bleeding between periods or after sex.',
        urgent: true,
      ),
    ],
    sources: ['NHS: Menopause', 'ACOG: The Menopause Years (FAQ047)'],
  ),
];

/// Support lines and services, grouped by region.
class HelpResource {
  const HelpResource(
    this.name,
    this.description, {
    this.phone,
    this.sms,
    this.url,
  });
  final String name;
  final String description;
  final String? phone;

  /// SMS number and optional body, e.g. ('88788', 'START').
  final (String, String?)? sms;
  final String? url;
}

const helpResources = <String, List<HelpResource>>{
  'Anywhere': [
    HelpResource(
      'Find a Helpline',
      'Free, confidential helplines in over 130 countries.',
      url: 'https://findahelpline.com',
    ),
  ],
  'United States': [
    HelpResource(
      '988 Suicide & Crisis Lifeline',
      'Call or text, 24/7.',
      phone: '988',
      sms: ('988', null),
    ),
    HelpResource(
      'RAINN National Sexual Assault Hotline',
      '24/7.',
      phone: '18006564673',
      url: 'https://rainn.org',
    ),
    HelpResource(
      'National Domestic Violence Hotline',
      '24/7. Text START to 88788.',
      phone: '18007997233',
      sms: ('88788', 'START'),
      url: 'https://www.thehotline.org',
    ),
    HelpResource(
      'Planned Parenthood',
      'Sexual and reproductive health care and information.',
      url: 'https://www.plannedparenthood.org',
    ),
  ],
  'United Kingdom': [
    HelpResource('NHS 111', 'Urgent medical advice, 24/7.', phone: '111'),
    HelpResource('Samaritans', 'Emotional support, 24/7.', phone: '116123'),
    HelpResource(
      'Rape Crisis (England & Wales)',
      '24/7 support line.',
      phone: '08085002222',
    ),
    HelpResource(
      'National Domestic Abuse Helpline',
      '24/7.',
      phone: '08082000247',
    ),
  ],
  'Canada': [
    HelpResource(
      '9-8-8 Suicide Crisis Helpline',
      'Call or text, 24/7.',
      phone: '988',
      sms: ('988', null),
    ),
  ],
  'Australia': [
    HelpResource(
      '1800RESPECT',
      'Sexual assault, domestic and family violence counselling, 24/7.',
      phone: '1800737732',
    ),
    HelpResource('Lifeline', 'Crisis support, 24/7.', phone: '131114'),
  ],
};
