class AppAssets {
  AppAssets._();

  static const String homeHero =
      'assets/images/home/home_hero.jpg';

  static const String mistTea =
      'assets/images/programs/mist_tea.jpg';

  static const String blindYoga =
      'assets/images/programs/blind_yoga.jpg';

  static const String aufgussSaunaBus =
      'assets/images/programs/aufguss_sauna_bus.jpg';

  static const String secretMap =
      'assets/images/exploration/secret_map.png';

  static String? programImageById(String programId) {
    switch (programId) {
      case 'mist_tea':
        return mistTea;
      case 'blind_yoga':
        return blindYoga;
      case 'aufguss_sauna_bus':
        return aufgussSaunaBus;
      default:
        return null;
    }
  }
}
