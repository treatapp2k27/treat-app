class BangladeshLocations {
  static const String defaultDistrict = 'Feni';
  static const String defaultUpazila = 'Feni Sadar';

  /// All 64 Districts of Bangladesh grouped by Division
  static const Map<String, List<String>> districtsByDivision = {
    'Chattogram': [
      'Feni',
      'Chattogram',
      'Cumilla',
      'Noakhali',
      'Cox\'s Bazar',
      'Brahmanbaria',
      'Chandpur',
      'Lakshmipur',
      'Rangamati',
      'Bandarban',
      'Khagrachhari',
    ],
    'Dhaka': [
      'Dhaka',
      'Gazipur',
      'Narayanganj',
      'Tangail',
      'Kishoreganj',
      'Narsingdi',
      'Manikganj',
      'Munshiganj',
      'Faridpur',
      'Gopalganj',
      'Madaripur',
      'Rajbari',
      'Shariatpur',
    ],
    'Sylhet': [
      'Sylhet',
      'Moulvibazar',
      'Habiganj',
      'Sunamganj',
    ],
    'Rajshahi': [
      'Rajshahi',
      'Bogura',
      'Pabna',
      'Sirajganj',
      'Naogaon',
      'Natore',
      'Chapainawabganj',
      'Joypurhat',
    ],
    'Khulna': [
      'Khulna',
      'Jashore',
      'Kushtia',
      'Jhenaidah',
      'Satkhira',
      'Bagerhat',
      'Chuadanga',
      'Meherpur',
      'Narail',
      'Magura',
    ],
    'Barishal': [
      'Barishal',
      'Bhola',
      'Patuakhali',
      'Pirojpur',
      'Barguna',
      'Jhalokati',
    ],
    'Rangpur': [
      'Rangpur',
      'Dinajpur',
      'Gaibandha',
      'Kurigram',
      'Lalmonirhat',
      'Nilphamari',
      'Panchagarh',
      'Thakurgaon',
    ],
    'Mymensingh': [
      'Mymensingh',
      'Jamalpur',
      'Netrokona',
      'Sherpur',
    ],
  };

  /// Flat list of all 64 districts in Bangladesh
  static List<String> get allDistricts {
    final list = <String>[];
    for (final districts in districtsByDivision.values) {
      list.addAll(districts);
    }
    return list;
  }

  /// Upazilas of Feni District
  static const List<String> feniUpazilas = [
    'Feni Sadar',
    'Chhagalnaiya',
    'Daganbhuiyan',
    'Parshuram',
    'Fulgazi',
    'Sonagazi',
  ];

  /// Upazilas / Areas for major Bangladesh districts
  static const Map<String, List<String>> upazilasByDistrict = {
    'Feni': feniUpazilas,
    'Dhaka': [
      'Dhanmondi',
      'Gulshan',
      'Banani',
      'Uttara',
      'Mirpur',
      'Mohammadpur',
      'Motijheel',
      'Old Dhaka',
      'Badda',
      'Bashundhara',
    ],
    'Chattogram': [
      'Kotwali',
      'Panchlaish',
      'Agrabad',
      'Nasirabad',
      'Khulshi',
      'Halishahar',
      'GEC Circle',
      'Chawkbazar',
    ],
    'Cumilla': [
      'Cumilla Sadar',
      'Kandirpar',
      'Laksam',
      'Daudkandi',
      'Chauddagram',
      'Burichang',
    ],
    'Noakhali': [
      'Noakhali Sadar',
      'Begumganj',
      'Maijdee',
      'Chowmuhani',
      'Senbagh',
      'Companyganj',
    ],
    'Sylhet': [
      'Sylhet Sadar',
      'Zindabazar',
      'Amberkhana',
      'Shahi Eidgah',
      'Kumarpara',
      'Subidbazar',
    ],
  };

  /// Multiple buttons / Preferable road locations under Feni Sadar:
  /// 'Mizan Road, SSK Road, Hospital Road, Doctorpara Road, Mohipal Road, Trunk Road, Masterpara Road, Najir Road, Hazari Road, etc.'
  static const List<String> feniSadarRoads = [
    'Mizan Road',
    'SSK Road',
    'Hospital Road',
    'Doctorpara Road',
    'Mohipal Road',
    'Trunk Road',
    'Masterpara Road',
    'Najir Road',
    'Hazari Road',
    'College Road',
    'Station Road',
    'Rampur Road',
    'Boro Bazar Road',
    'Ukils Para Road',
    'Shaheen Academy Road',
    'Grand Trunk Road',
  ];

  /// Road descriptions or landmarks for richer UI hints
  static const Map<String, String> feniRoadSubtitles = {
    'Mizan Road': 'Central Food & Shopping Hub',
    'SSK Road': 'Shaheed Shahidullah Kaiser Rd • Popular Cafes',
    'Hospital Road': 'Medical Zone • Quick Bites',
    'Doctorpara Road': 'Residential Foodie Lane',
    'Mohipal Road': 'Transit Gateway • Street Food Hub',
    'Trunk Road': 'Heart of Feni Town • Historic Market',
    'Masterpara Road': 'Community Gathering Spots',
    'Najir Road': 'Cozy Eateries & Bakeries',
    'Hazari Road': 'Local Delights & Snack Bars',
    'College Road': 'Student Hangouts & Tea Stalls',
    'Station Road': 'Railway Station Corridor',
    'Rampur Road': 'Neighborhood Food Points',
    'Boro Bazar Road': 'Traditional Sweet & Platter Shops',
    'Ukils Para Road': 'Peaceful Town Quarter',
    'Shaheen Academy Road': 'Academy Area • Youth Cafes',
    'Grand Trunk Road': 'Highway Feasts & Dhabas',
  };
}
