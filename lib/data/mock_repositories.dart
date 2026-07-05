import '../domain/models.dart';
import '../domain/facility_models.dart';

class MockPromoRepository {
  Future<List<Promo>> fetchPromos() {
    final now = DateTime.now();
    return Future.value([
      Promo(
          id: 'p_001',
          title: 'Couples Serenity Retreat',
          description: '50% off side-by-side couples massage.',
          detailedDescription:
              'Indulge in a 90-minute full-body aromatherapy massage side-by-side with your partner. This exclusive package includes complimentary access to the thermal suite and a glass of detox champagne upon arrival.',
          imageAsset: 'assets/promos/1.png',
          endTime: now.add(const Duration(days: 3, hours: 5)),
          remainingQuota: 4),
      Promo(
          id: 'p_002',
          title: 'Royal Ottoman Hamam',
          description: 'Complimentary scrub with VIP booking.',
          detailedDescription:
              'Upgrade your standard booking to a VIP Royal Hamam experience. Enjoy a traditional kese (scrub), luxurious foam massage (köpük), and a soothing scalp massage in our private marble suite.',
          imageAsset: 'assets/promos/2.png',
          endTime: now.add(const Duration(days: 1, hours: 12)),
          remainingQuota: 12),
      Promo(
          id: 'p_003',
          title: 'Detox & Glow Package',
          description: 'Unlimited organic herbal teas & fresh juices.',
          detailedDescription:
              'Revitalize your body from the inside out. Book any facial treatment today and enjoy unlimited access to our signature infused waters and organic herbal teas in the Tranquility Lounge.',
          imageAsset: 'assets/promos/3.png',
          endTime: now.add(const Duration(days: 7)),
          remainingQuota: 25),
    ]);
  }

  Future<List<MassageType>> fetchMassageTypes() {
    return Future.value([
      MassageType(
          name: 'Traditional Turkish Bath (Kese & Köpük)',
          benefits:
              'Authentic Ottoman experience. Invigorating full-body exfoliation (kese) followed by a purifying cloud of warm, luxurious soap foam (köpük) massage.'),
      MassageType(
          name: 'Swedish Massage',
          benefits:
              'Best for overall relaxation. Uses long, gliding strokes to ease tension, improve circulation, and calm the nervous system.'),
      MassageType(
          name: 'Deep Tissue / Sports',
          benefits:
              'Perfect for athletes or chronic pain. Focuses on the deepest layers of muscle tissue, tendons, and fascia to release severe knots.'),
      MassageType(
          name: 'Traditional Thai',
          benefits:
              'An active "lazy yoga" massage. The therapist uses their hands, knees, legs, and feet to move you into a series of yoga-like stretches.'),
      MassageType(
          name: 'Hot Stone Therapy',
          benefits:
              'Smooth, heated stones are placed on specific parts of your body. The localized heat penetrates deep into muscles to melt away tension.'),
      MassageType(
          name: 'Reflexology',
          benefits:
              'Focuses on pressure points in the feet and hands that correspond to different body organs, promoting natural healing and stress relief.'),
      MassageType(
          name: 'Aromatherapy',
          benefits:
              'Ideal for emotional healing and stress relief. Combines gentle massage with highly concentrated, organic plant oils.'),
      MassageType(
          name: 'Balinese Massage',
          benefits:
              'A holistic treatment combining acupressure, reflexology, and aromatherapy to stimulate the flow of blood and energy.'),
    ]);
  }
}

class MockAuthRepository {
  Future<AccountInfo> login(UserRole role) async {
    if (role == UserRole.admin) {
      return Future.value(AccountInfo(
          userId: 'admin_1',
          name: 'Admin Manager',
          role: UserRole.admin,
          hamamCount: 0,
          massageCount: 0));
    } else {
      return Future.value(AccountInfo(
          userId: 'usr_102',
          name: 'Normal User',
          role: UserRole.user,
          hamamCount: 2,
          massageCount: 4));
    }
  }
}

class MockFacilityRepository {
  Future<List<FacilityCategory>> fetchFacilitiesForLocation(String location) {
    return Future.value([
      FacilityCategory(title: 'Solo Therapy Suites', items: [
        FacilityItem(
            id: 'sr_1',
            title: 'Therapy Suite 1',
            description: 'Cozy, soundproofed private treatment room.',
            imageAsset: 'assets/facilities/single1.png'),
        FacilityItem(
            id: 'sr_2',
            title: 'Therapy Suite 2',
            description: 'Cozy, soundproofed private treatment room.',
            imageAsset: 'assets/facilities/single2.png'),
        FacilityItem(
            id: 'sr_3',
            title: 'Therapy Suite 3',
            description: 'Cozy, soundproofed private treatment room.',
            imageAsset: 'assets/facilities/single3.png'),
      ]),
      FacilityCategory(title: 'Couples Sanctuary', items: [
        FacilityItem(
            id: 'cr_1',
            title: 'Couples Suite 1',
            description: 'Shared experience room with side-by-side twin beds.',
            imageAsset: 'assets/facilities/couple1.png'),
        FacilityItem(
            id: 'cr_2',
            title: 'Couples Suite 2',
            description: 'Shared experience room with side-by-side twin beds.',
            imageAsset: 'assets/facilities/couple2.png'),
      ]),
      FacilityCategory(title: 'VIP Spa Suites', items: [
        FacilityItem(
            id: 'vip_1',
            title: 'VIP Suite 1',
            description:
                'Luxury suite featuring a private hydrotherapy jacuzzi.',
            imageAsset: 'assets/facilities/vip1.png'),
        FacilityItem(
            id: 'vip_2',
            title: 'VIP Suite 2',
            description:
                'Luxury suite featuring a private hydrotherapy jacuzzi.',
            imageAsset: 'assets/facilities/vip2.png'),
      ]),
      FacilityCategory(title: 'Thermal & Aqua Therapy', items: [
        FacilityItem(
            id: 'hm_1',
            title: 'Authentic Hamam 1',
            description:
                'Traditional Turkish marble bath and heated göbektaşı.',
            imageAsset: 'assets/facilities/hamam1.png'),
        FacilityItem(
            id: 'hm_2',
            title: 'Authentic Hamam 2',
            description:
                'Traditional Turkish marble bath and heated göbektaşı.',
            imageAsset: 'assets/facilities/hamam2.png'),
        FacilityItem(
            id: 'sn_1',
            title: 'Cedar Wood Sauna',
            description:
                'High-temperature dry heat therapy for deep muscle relaxation.',
            imageAsset: 'assets/facilities/sauna.png'),
        FacilityItem(
            id: 'st_1',
            title: 'Eucalyptus Steam Room',
            description:
                'Moist heat therapy infused with eucalyptus for respiratory detox.',
            imageAsset: 'assets/facilities/steam.png'),
      ]),
      FacilityCategory(title: 'Tranquility Lounge', items: [
        FacilityItem(
            id: 'rl_1',
            title: 'Oasis Resting Area & Vitamin Bar',
            description:
                'Serene resting area with heated loungers and fresh detox infusions.',
            imageAsset: 'assets/facilities/lounge.png'),
      ]),

      // NEW: The Team Section (No Images, Just Data)
      FacilityCategory(title: 'Our Spa Professionals', items: [
        FacilityItem(
          id: 'tm_1',
          title: 'Master Therapists',
          description:
              'Our certified experts dedicated to your physical and mental well-being.',
          imageAsset: '', // Left empty so no photo loads
          staff: [
            Person(name: 'Ayşe Y.', roleOrStatus: 'Thai Specialist'),
            Person(name: 'Fatma K.', roleOrStatus: 'Deep Tissue'),
            Person(name: 'Elena V.', roleOrStatus: 'Aromatherapy'),
            Person(name: 'Zeynep B.', roleOrStatus: 'Balinese Massage'),
            Person(name: 'Merve T.', roleOrStatus: 'Hot Stone Therapy'),
            Person(name: 'Ceren S.', roleOrStatus: 'Reflexology'),
          ],
        ),
        FacilityItem(
          id: 'tm_2',
          title: 'Guest Relations & Reception',
          description:
              'Ensuring a seamless and luxurious experience from the moment you arrive.',
          imageAsset: '', // Left empty so no photo loads
          staff: [
            Person(name: 'Caner B.', roleOrStatus: 'Spa Manager'),
            Person(name: 'Selin M.', roleOrStatus: 'Front Desk'),
            Person(name: 'Burak A.', roleOrStatus: 'Guest Coordinator'),
            Person(name: 'Melis C.', roleOrStatus: 'Booking Specialist'),
          ],
        ),
      ]),
    ]);
  }
}
