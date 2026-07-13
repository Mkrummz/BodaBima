/// Sample insurance plans used to run BodaBima as a self-contained demo when
/// the Supabase backend is unavailable or has no seeded data.
class DemoData {
  static const List<Map<String, dynamic>> medicalPlans = [
    {
      'plan_name': 'Boda Health Basic',
      'description': 'Outpatient cover and clinic visits for the rider.',
      'coverage_amount': 'KES 300,000',
      'monthly_premium': 'KES 450',
    },
    {
      'plan_name': 'Boda Health Plus',
      'description': 'Inpatient + outpatient cover for rider and one dependant.',
      'coverage_amount': 'KES 1,000,000',
      'monthly_premium': 'KES 1,200',
    },
    {
      'plan_name': 'Family Care',
      'description': 'Comprehensive family cover including maternity.',
      'coverage_amount': 'KES 2,500,000',
      'monthly_premium': 'KES 2,800',
    },
  ];

  static const List<Map<String, dynamic>> motorPlans = [
    {
      'plan_name': 'Boda Third Party',
      'description': 'Mandatory third-party liability cover for your motorcycle.',
      'coverage_amount': 'KES 500,000',
      'monthly_premium': 'KES 350',
    },
    {
      'plan_name': 'Boda Comprehensive',
      'description': 'Theft, accident and third-party cover for your boda.',
      'coverage_amount': 'KES 250,000',
      'monthly_premium': 'KES 900',
    },
  ];

  static const List<Map<String, dynamic>> homePlans = [
    {
      'plan_name': 'Home Shield',
      'description': 'Fire and theft cover for your home and belongings.',
      'coverage_amount': 'KES 1,500,000',
      'monthly_premium': 'KES 600',
    },
    {
      'plan_name': 'Home Shield Pro',
      'description': 'All-risk cover including natural disasters.',
      'coverage_amount': 'KES 5,000,000',
      'monthly_premium': 'KES 1,600',
    },
  ];

  static const List<Map<String, dynamic>> travelPlans = [
    {
      'plan_name': 'Regional Traveller',
      'description': 'East Africa travel cover with medical evacuation.',
      'coverage_amount': 'KES 2,000,000',
      'monthly_premium': 'KES 750',
    },
    {
      'plan_name': 'Global Traveller',
      'description': 'Worldwide travel and medical cover for up to 30 days.',
      'coverage_amount': 'KES 6,000,000',
      'monthly_premium': 'KES 2,100',
    },
  ];
}
