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
            'Indulge in a 90-minute full-body aromatherapy massage side-by-side with your partner. This exclusive package includes complimentary access to the thermal suite and a glass of detox champagne upon arrival. Perfect for anniversaries or a weekend escape.',
        imageAsset: 'assets/promos/1.png',
        endTime: now.add(const Duration(days: 3, hours: 5)),
        remainingQuota: 4,
      ),
      Promo(
        id: 'p_002',
        title: 'Royal Ottoman Hamam',
        description: 'Complimentary scrub with VIP booking.',
        detailedDescription:
            'Upgrade your standard booking to a VIP Royal Hamam experience. Enjoy a traditional kese (scrub), luxurious foam massage, and a soothing scalp massage in our private marble suite. Wash away the stress of the city.',
        imageAsset: 'assets/promos/2.png',
        endTime: now.add(const Duration(days: 1, hours: 12)),
        remainingQuota: 12,
      ),
      Promo(
        id: 'p_003',
        title: 'Detox & Glow Package',
        description: 'Unlimited organic herbal teas & fresh juices.',
        detailedDescription:
            'Revitalize your body from the inside out. Book any facial treatment today and enjoy unlimited access to our signature infused waters and organic herbal teas in the Oasis Relaxation Lounge after your session.',
        imageAsset: 'assets/promos/3.png',
        endTime: now.add(const Duration(days: 7)),
        remainingQuota: 25,
      ),
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
        hamamCount: 999,
        massageCount: 999,
      ));
    } else {
      return Future.value(AccountInfo(
        userId: 'usr_102',
        name: 'Normal User',
        role: UserRole.user,
        hamamCount: 2,
        massageCount: 4,
      ));
    }
  }
}

class MockFacilityRepository {
  Future<List<FacilityCategory>> fetchFacilitiesForLocation(String location) {
    return Future.value([
      FacilityCategory(title: 'Single Rooms', items: [
        FacilityItem(
            id: 'sr_1',
            title: 'Single Room 1',
            description: 'Cozy private treatment room.',
            imageAsset: 'assets/facilities/single1.png'),
        FacilityItem(
            id: 'sr_2',
            title: 'Single Room 2',
            description: 'Cozy private treatment room.',
            imageAsset: 'assets/facilities/single2.png'),
        FacilityItem(
            id: 'sr_3',
            title: 'Single Room 3',
            description: 'Cozy private treatment room.',
            imageAsset: 'assets/facilities/single3.png'),
      ]),
      FacilityCategory(title: 'Couple Rooms', items: [
        FacilityItem(
            id: 'cr_1',
            title: 'Couple Room 1',
            description: 'Shared experience room with twin beds.',
            imageAsset: 'assets/facilities/couple1.png'),
        FacilityItem(
            id: 'cr_2',
            title: 'Couple Room 2',
            description: 'Shared experience room with twin beds.',
            imageAsset: 'assets/facilities/couple2.png'),
      ]),
      FacilityCategory(title: 'VIP Suites', items: [
        FacilityItem(
            id: 'vip_1',
            title: 'VIP Suite 1',
            description: 'Luxury suite with private jacuzzi.',
            imageAsset: 'assets/facilities/vip1.png'),
        FacilityItem(
            id: 'vip_2',
            title: 'VIP Suite 2',
            description: 'Luxury suite with private jacuzzi.',
            imageAsset: 'assets/facilities/vip2.png'),
      ]),
      FacilityCategory(title: 'Spa & Thermal', items: [
        FacilityItem(
            id: 'hm_1',
            title: 'Traditional Hamam 1',
            description: 'Authentic Turkish marble bath.',
            imageAsset: 'assets/facilities/hamam1.png'),
        FacilityItem(
            id: 'hm_2',
            title: 'Traditional Hamam 2',
            description: 'Authentic Turkish marble bath.',
            imageAsset: 'assets/facilities/hamam2.png'),
        FacilityItem(
            id: 'sn_1',
            title: 'Cedar Sauna',
            description: 'High-temperature dry heat therapy.',
            imageAsset: 'assets/facilities/sauna.png'),
        FacilityItem(
            id: 'st_1',
            title: 'Eucalyptus Steam Room',
            description: 'Moist heat therapy for deep detox.',
            imageAsset: 'assets/facilities/steam.png'),
      ]),
      FacilityCategory(title: 'Relaxation Zone', items: [
        FacilityItem(
            id: 'rl_1',
            title: 'Oasis Lounge & Vitamin Bar',
            description:
                'Chilling zone with sun loungers and fresh detox drinks.',
            imageAsset: 'assets/facilities/lounge.png'),
      ]),
      FacilityCategory(title: 'Our Team', items: [
        FacilityItem(
          id: 'tm_1',
          title: 'Massage Therapists',
          description: 'Our certified professional therapists.',
          imageAsset: 'assets/facilities/therapists.png',
          staff: [
            Person(name: 'Ayse Y.', roleOrStatus: 'Thai Specialist'),
            Person(name: 'Fatma K.', roleOrStatus: 'Deep Tissue'),
            Person(name: 'Elena V.', roleOrStatus: 'Aromatherapy'),
          ],
        ),
        FacilityItem(
          id: 'tm_2',
          title: 'Reception & Guest Relations',
          description: 'Welcoming you to Fabacco Spa.',
          imageAsset: 'assets/facilities/reception.png',
          staff: [
            Person(name: 'Caner B.', roleOrStatus: 'Front Desk'),
            Person(name: 'Selin M.', roleOrStatus: 'Spa Manager'),
          ],
        ),
      ]),
    ]);
  }
}
