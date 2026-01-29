class SettingsData {
  bool soundOn;

  SettingsData._({
    required this.soundOn
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData._(
      soundOn: json['sound_on'] as bool,
    
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'sound_on': soundOn,
    };
  }
}