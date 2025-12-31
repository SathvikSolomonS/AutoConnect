import '../models/car_model.dart';

final List<CarModel> dummyCars = [

/* ========================== TATA (5) ========================== */

  CarModel(
    id: 'tata_nexon',
    brand: 'Tata',
    name: 'Tata Nexon',
    images: ['assets/images/nexon.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.6,
    basePrice: 1149000,
    offers: [],
    specs: {'Engine': '1497 cc', 'Mileage': '17 km/l', 'Seating': '5'},
    variants: [
      {'name': 'Smart', 'price': 1099000},
      {'name': 'Creative', 'price': 1399000},
    ],
  ),

  CarModel(
    id: 'tata_punch',
    brand: 'Tata',
    name: 'Tata Punch',
    images: ['assets/images/punch.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.4,
    basePrice: 650000,
    offers: [],
    specs: {'Engine': '1199 cc', 'Mileage': '20 km/l', 'Seating': '5'},
    variants: [
      {'name': 'Pure', 'price': 650000},
      {'name': 'Creative', 'price': 850000},
    ],
  ),

  CarModel(
    id: 'tata_harrier',
    brand: 'Tata',
    name: 'Tata Harrier',
    images: ['assets/images/harrier.jpeg'],
    fuel: 'Diesel',
    transmission: 'Automatic',
    rating: 4.7,
    basePrice: 1500000,
    offers: [],
    specs: {'Engine': '1956 cc', 'Mileage': '16 km/l', 'Seating': '5'},
    variants: [
      {'name': 'XM', 'price': 1500000},
      {'name': 'XZA+', 'price': 2200000},
    ],
  ),

  CarModel(
    id: 'tata_safari',
    brand: 'Tata',
    name: 'Tata Safari',
    images: ['assets/images/safari.jpeg'],
    fuel: 'Diesel',
    transmission: 'Automatic',
    rating: 4.6,
    basePrice: 1650000,
    offers: [],
    specs: {'Engine': '1956 cc', 'Mileage': '14 km/l', 'Seating': '7'},
    variants: [
      {'name': 'XE', 'price': 1650000},
      {'name': 'XZA+', 'price': 2600000},
    ],
  ),

  CarModel(
    id: 'tata_altroz',
    brand: 'Tata',
    name: 'Tata Altroz',
    images: ['assets/images/altroz.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.5,
    basePrice: 650000,
    offers: [],
    specs: {'Engine': '1199 cc', 'Mileage': '19 km/l', 'Seating': '5'},
    variants: [
      {'name': 'XE', 'price': 650000},
      {'name': 'XZ', 'price': 1000000},
    ],
  ),

/* ========================== MARUTI (5) ========================== */

  CarModel(
    id: 'maruti_swift',
    brand: 'Maruti Suzuki',
    name: 'Swift',
    images: ['assets/images/swift.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.3,
    basePrice: 600000,
    offers: [],
    specs: {'Engine': '1197 cc', 'Mileage': '22 km/l', 'Seating': '5'},
    variants: [
      {'name': 'LXi', 'price': 600000},
      {'name': 'ZXi', 'price': 850000},
    ],
  ),

  CarModel(
    id: 'maruti_baleno',
    brand: 'Maruti Suzuki',
    name: 'Baleno',
    images: ['assets/images/baleno.jpeg'],
    fuel: 'Petrol',
    transmission: 'Automatic',
    rating: 4.4,
    basePrice: 650000,
    offers: [],
    specs: {'Engine': '1197 cc', 'Mileage': '22 km/l', 'Seating': '5'},
    variants: [
      {'name': 'Sigma', 'price': 650000},
      {'name': 'Alpha', 'price': 980000},
    ],
  ),

  CarModel(
    id: 'maruti_brezza',
    brand: 'Maruti Suzuki',
    name: 'Brezza',
    images: ['assets/images/brezza.jpeg'],
    fuel: 'Petrol',
    transmission: 'Automatic',
    rating: 4.4,
    basePrice: 830000,
    offers: [],
    specs: {'Engine': '1462 cc', 'Mileage': '19 km/l', 'Seating': '5'},
    variants: [
      {'name': 'VXi', 'price': 830000},
      {'name': 'ZXi+', 'price': 1350000},
    ],
  ),

  CarModel(
    id: 'maruti_ertiga',
    brand: 'Maruti Suzuki',
    name: 'Ertiga',
    images: ['assets/images/ertiga.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.5,
    basePrice: 900000,
    offers: [],
    specs: {'Engine': '1462 cc', 'Mileage': '20 km/l', 'Seating': '7'},
    variants: [
      {'name': 'LXi', 'price': 900000},
      {'name': 'ZXi+', 'price': 1300000},
    ],
  ),

  CarModel(
    id: 'maruti_ciaz',
    brand: 'Maruti Suzuki',
    name: 'Ciaz',
    images: ['assets/images/ciaz.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.4,
    basePrice: 880000,
    offers: [],
    specs: {'Engine': '1462 cc', 'Mileage': '21 km/l', 'Seating': '5'},
    variants: [
      {'name': 'Sigma', 'price': 880000},
      {'name': 'Alpha', 'price': 1150000},
    ],
  ),

/* ========================== KIA (5) ========================== */

  CarModel(
    id: 'kia_seltos',
    brand: 'Kia',
    name: 'Seltos',
    images: ['assets/images/seltos.jpeg'],
    fuel: 'Petrol',
    transmission: 'Automatic',
    rating: 4.5,
    basePrice: 1090000,
    offers: [],
    specs: {'Engine': '1498 cc', 'Mileage': '16 km/l', 'Seating': '5'},
    variants: [
      {'name': 'HTE', 'price': 1090000},
      {'name': 'GTX+', 'price': 1850000},
    ],
  ),

  CarModel(
    id: 'kia_sonet',
    brand: 'Kia',
    name: 'Sonet',
    images: ['assets/images/sonet.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.4,
    basePrice: 800000,
    offers: [],
    specs: {'Engine': '1197 cc', 'Mileage': '18 km/l', 'Seating': '5'},
    variants: [
      {'name': 'HTE', 'price': 800000},
      {'name': 'HTX', 'price': 1200000},
    ],
  ),

  CarModel(
    id: 'kia_carens',
    brand: 'Kia',
    name: 'Carens',
    images: ['assets/images/carens.jpeg'],
    fuel: 'Petrol',
    transmission: 'Manual',
    rating: 4.5,
    basePrice: 1050000,
    offers: [],
    specs: {'Engine': '1497 cc', 'Mileage': '16 km/l', 'Seating': '7'},
    variants: [
      {'name': 'Premium', 'price': 1050000},
      {'name': 'Luxury', 'price': 1700000},
    ],
  ),

  CarModel(
    id: 'kia_ev6',
    brand: 'Kia',
    name: 'EV6',
    images: ['assets/images/kia_ev6.jpeg'],
    fuel: 'Electric',
    transmission: 'Automatic',
    rating: 4.7,
    basePrice: 6000000,
    offers: [],
    specs: {'Range': '528 km', 'Seating': '5'},
    variants: [
      {'name': 'GT Line', 'price': 6000000},
    ],
  ),

  CarModel(
    id: 'kia_carnival',
    brand: 'Kia',
    name: 'Carnival',
    images: ['assets/images/carnival.jpeg'],
    fuel: 'Diesel',
    transmission: 'Automatic',
    rating: 4.6,
    basePrice: 2500000,
    offers: [],
    specs: {'Engine': '2199 cc', 'Mileage': '13 km/l', 'Seating': '7'},
    variants: [
      {'name': 'Limousine', 'price': 3000000},
    ],
  ),

/* ========================== TOYOTA (5) ========================== */

  CarModel(
    id: 'toyota_fortuner',
    brand: 'Toyota',
    name: 'Fortuner',
    images: ['assets/images/fortuner.jpeg'],
    fuel: 'Diesel',
    transmission: 'Automatic',
    rating: 4.7,
    basePrice: 3300000,
    offers: [],
    specs: {'Engine': '2755 cc', 'Mileage': '14 km/l', 'Seating': '7'},
    variants: [
      {'name': '4x2', 'price': 3300000},
      {'name': '4x4', 'price': 3800000},
    ],
  ),

  CarModel(
    id: 'toyota_innova',
    brand: 'Toyota',
    name: 'Innova Crysta',
    images: ['assets/images/innova.jpeg'],
    fuel: 'Diesel',
    transmission: 'Manual',
    rating: 4.6,
    basePrice: 1900000,
    offers: [],
    specs: {'Engine': '2393 cc', 'Mileage': '15 km/l', 'Seating': '7'},
    variants: [
      {'name': 'GX', 'price': 1900000},
      {'name': 'ZX', 'price': 2500000},
    ],
  ),

  CarModel(
    id: 'toyota_glanza',
    brand: 'Toyota',
    name: 'Glanza',
    images: ['assets/images/glanza.jpeg'],
    fuel: 'Petrol',
    transmission: 'Automatic',
    rating: 4.4,
    basePrice: 650000,
    offers: [],
    specs: {'Engine': '1197 cc', 'Mileage': '22 km/l', 'Seating': '5'},
    variants: [
      {'name': 'G', 'price': 650000},
      {'name': 'V', 'price': 990000},
    ],
  ),

  CarModel(
    id: 'toyota_hycross',
    brand: 'Toyota',
    name: 'Innova Hycross',
    images: ['assets/images/hycross.jpeg'],
    fuel: 'Hybrid',
    transmission: 'Automatic',
    rating: 4.6,
    basePrice: 1970000,
    offers: [],
    specs: {'Mileage': '23 km/l', 'Seating': '7'},
    variants: [
      {'name': 'VX', 'price': 1970000},
      {'name': 'ZX', 'price': 3000000},
    ],
  ),

  CarModel(
    id: 'toyota_camry',
    brand: 'Toyota',
    name: 'Camry',
    images: ['assets/images/camry.jpeg'],
    fuel: 'Hybrid',
    transmission: 'Automatic',
    rating: 4.5,
    basePrice: 4800000,
    offers: [],
    specs: {'Mileage': '25 km/l', 'Seating': '5'},
    variants: [
      {'name': 'Hybrid', 'price': 4800000},
    ],
  ),
];
