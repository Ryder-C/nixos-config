# Recyclarr configuration for nixarr
#
# Merged "best available quality" — 4K preferred, 1080p fallback.
#
# API keys:
#   The main radarr/sonarr use "!env_var RADARR_API_KEY" / "!env_var SONARR_API_KEY"
#   which nixarr auto-populates from the managed key files.
#
#   Anime instances use "!env_var RADARR_ANIME_API_KEY" / "!env_var SONARR_ANIME_API_KEY"
#   which are auto-populated from the instance key files.
let
  # Helper to reduce repetition in custom_formats
  cf = profile: trash_id: score: {
    trash_ids = [trash_id];
    assign_scores_to = [
      {
        name = profile;
        inherit score;
      }
    ];
  };

  # Audio format CFs — same scores across all non-anime profiles
  audioFormats = profile: audioIds: builtins.map (a: cf profile a.id a.score) audioIds;

  # Radarr audio trash IDs
  radarrAudio = [
    {
      id = "496f355514737f7d83bf7aa4d24f8169";
      score = 500;
    } # TrueHD ATMOS
    {
      id = "2f22d89048b01681dde8afe203bf2e95";
      score = 450;
    } # DTS X
    {
      id = "417804f7f2c4308c1f4c5d380d4c4475";
      score = 300;
    } # ATMOS (undefined)
    {
      id = "1af239278386be2919e1bcee0bde047e";
      score = 300;
    } # DDPlus ATMOS
    {
      id = "3cafb66171b47f226146a0770576870f";
      score = 275;
    } # TrueHD
    {
      id = "dcf3ec6938fa32445f590a4da84256cd";
      score = 250;
    } # DTS-HD MA
    {
      id = "a570d4a0e56a2874b64e5bfa55202a1b";
      score = 225;
    } # FLAC
    {
      id = "e7c2fcae07cbada050a0af3357491d7b";
      score = 225;
    } # PCM
    {
      id = "8e109e50e0a0b83a5098b056e13bf6db";
      score = 200;
    } # DTS-HD HRA
    {
      id = "185f1dd7264c4562b9022d963ac37424";
      score = 175;
    } # DDPlus
    {
      id = "f9f847ac70a0af62ea4a08280b859636";
      score = 150;
    } # DTS-ES
    {
      id = "1c1a4c5e823891c75bc50380a6866f73";
      score = 125;
    } # DTS
    {
      id = "240770601cc226190c367ef59aba7463";
      score = 100;
    } # AAC
    {
      id = "c2998bd0d90ed5621d8df281e839436e";
      score = 75;
    } # DD
  ];

  # Sonarr audio trash IDs (different IDs, same scores)
  sonarrAudio = [
    {
      id = "0d7824bb924701997f874e7ff7d4844a";
      score = 500;
    } # TrueHD ATMOS
    {
      id = "9d00418ba386a083fbf4d58235fc37ef";
      score = 450;
    } # DTS X
    {
      id = "b6fbafa7942952a13e17e2b1152b539a";
      score = 300;
    } # ATMOS (undefined)
    {
      id = "4232a509ce60c4e208d13825b7c06264";
      score = 300;
    } # DDPlus ATMOS
    {
      id = "1808e4b9cee74e064dfae3f1db99dbfe";
      score = 275;
    } # TrueHD
    {
      id = "c429417a57ea8c41d57e6990a8b0033f";
      score = 250;
    } # DTS-HD MA
    {
      id = "851bd64e04c9374c51102be3dd9ae4cc";
      score = 225;
    } # FLAC
    {
      id = "30f70576671ca933adbdcfc736a69718";
      score = 225;
    } # PCM
    {
      id = "cfa5fbd8f02a86fc55d8d223d06a5e1f";
      score = 200;
    } # DTS-HD HRA
    {
      id = "63487786a8b01b7f20dd2bc90dd4a477";
      score = 175;
    } # DDPlus
    {
      id = "c1a25cd67b5d2e08287c957b1eb903ec";
      score = 150;
    } # DTS-ES
    {
      id = "5964f2a8b3be407d083498e4459d05d0";
      score = 125;
    } # DTS
    {
      id = "a50b8a0c62274a7c38b09a9619ba9d86";
      score = 100;
    } # AAC
    {
      id = "dbe00161b08a25ac6154c55f95e6318d";
      score = 75;
    } # DD
  ];
in {
  radarr = {
    # Main Radarr — merged best available (4K preferred, 1080p fallback)
    radarr = {
      base_url = "http://127.0.0.1:7878";
      api_key = "!env_var RADARR_API_KEY";

      quality_profiles = [
        {
          name = "movies";
          reset_unmatched_scores.enabled = false;
          upgrade = {
            allowed = true;
            until_quality = "Remux-2160p";
            until_score = 20000;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {name = "Remux-2160p";}
            {name = "Bluray-2160p";}
            {
              name = "WEB 2160p";
              qualities = ["WEBDL-2160p" "WEBRip-2160p"];
            }
            {name = "Remux-1080p";}
            {name = "Bluray-1080p";}
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p"];
            }
            {name = "HDTV-1080p";}
          ];
        }
      ];

      delete_old_custom_formats = false;
      replace_existing_custom_formats = true;

      custom_formats =
        (audioFormats "movies" radarrAudio)
        ++ [
          # Release Group Tiers
          (cf "movies" "3a3ff47579026e76d6504ebea39390de" 1950) # Remux Tier 01
          (cf "movies" "9f98181fe5a3fbeb0cc29340da2a468a" 1900) # Remux Tier 02
          (cf "movies" "8baaf0b3142bf4d94c42a724f034e27a" 1850) # Remux Tier 03
          (cf "movies" "4d74ac4c4db0b64bff6ce0cffef99bf0" 1800) # UHD Bluray Tier 01
          (cf "movies" "a58f517a70193f8e578056642178419d" 1750) # UHD Bluray Tier 02
          (cf "movies" "e71939fae578037e7aed3ee219bbe7c1" 1700) # UHD Bluray Tier 03
          (cf "movies" "ed27ebfef2f323e964fb1f61391bcb35" 1800) # HD Bluray Tier 01
          (cf "movies" "c20c8647f2746a1f4c4262b0fbbeeeae" 1750) # HD Bluray Tier 02
          (cf "movies" "5608c71bcebba0a5e666223bae8c9227" 1700) # HD Bluray Tier 03
          (cf "movies" "c20f169ef63c5f40c2def54abaf4438e" 1700) # WEB Tier 01
          (cf "movies" "403816d65392c79236dcb6dd591aeda4" 1650) # WEB Tier 02
          (cf "movies" "af94e0fe497124d1f9ce732069ec8c3b" 1600) # WEB Tier 03

          # Misc
          (cf "movies" "e7718d7a3ce595f289bfee26adc178f5" 5) # Repack/Proper
          (cf "movies" "ae43b294509409a6a13919dedd4764c4" 6) # Repack2
          (cf "movies" "5caaaa1c08c1742aa4342d8c4cc463f2" 7) # Repack3

          # Unwanted
          (cf "movies" "cae4ca30163749b891686f95532519bd" (-20000)) # AV1
          (cf "movies" "b8cd450cbfa689c0259a01d9e29ba3d6" (-20000)) # 3D
          (cf "movies" "bfd8eb01832d646a0a89c4deb46f8564" (-20000)) # Upscaled
          (cf "movies" "0a3f082873eb454bde444150b70253cc" (-20000)) # Extras
          (cf "movies" "923b6abef9b17f937fab56cfcf89e1f1" (-20000)) # DV (w/o HDR fallback)

          # Movie Versions
          (cf "movies" "0f12c086e289cf966fa5948eac571f44" 200) # Hybrid
          (cf "movies" "eecf3a857724171f968a66cb5719e152" 200) # IMAX
          (cf "movies" "9f6cbff8cfe4ebbc1bde14c7b7bec0de" 200) # IMAX Enhanced

          # HDR (positive boost only, no SDR penalty)
          (cf "movies" "493b6d1dbec3c3364c59d7607f7e3405" 3000) # HDR
          (cf "movies" "b337d6812e06c200ec9a2d3cfa9d20a7" 1000) # DV Boost
          (cf "movies" "caa37d0df9c348912df1fb1d88f9273a" 100) # HDR10+ Boost
        ];
    };

    # Radarr Anime
    radarranime = {
      base_url = "http://127.0.0.1:7879";
      api_key = "!env_var RADARR_ANIME_API_KEY";

      quality_profiles = [
        {
          name = "animemovies";
          reset_unmatched_scores.enabled = false;
          upgrade = {
            allowed = true;
            until_quality = "Remux 1080p";
            until_score = 20000;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Remux 1080p";
              qualities = ["Remux-1080p" "Bluray-1080p"];
            }
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p" "HDTV-1080p"];
            }
            {name = "Bluray-720p";}
            {
              name = "WEB 720p";
              qualities = ["WEBDL-720p" "WEBRip-720p" "HDTV-720p"];
            }
            {name = "Bluray-576p";}
            {name = "Bluray-480p";}
            {
              name = "WEB 480p";
              qualities = ["WEBDL-480p" "WEBRip-480p"];
            }
            {name = "DVD";}
            {name = "SDTV";}
          ];
        }
      ];

      delete_old_custom_formats = false;
      replace_existing_custom_formats = true;

      custom_formats = [
        (cf "animemovies" "fb3ccc5d5cc8f77c9055d4cb4561dded" 1400) # Anime BD Tier 01
        (cf "animemovies" "66926c8fa9312bc74ab71bf69aae4f4a" 1300) # Anime BD Tier 02
        (cf "animemovies" "fa857662bad28d5ff21a6e611869a0ff" 1200) # Anime BD Tier 03
        (cf "animemovies" "f262f1299d99b1a2263375e8fa2ddbb3" 1100) # Anime BD Tier 04
        (cf "animemovies" "ca864ed93c7b431150cc6748dc34875d" 1000) # Anime BD Tier 05
        (cf "animemovies" "9dce189b960fddf47891b7484ee886ca" 900) # Anime BD Tier 06
        (cf "animemovies" "1ef101b3a82646b40e0cab7fc92cd896" 800) # Anime BD Tier 07
        (cf "animemovies" "6115ccd6640b978234cc47f2c1f2cadc" 700) # Anime BD Tier 08
        (cf "animemovies" "8167cffba4febfb9a6988ef24f274e7e" 600) # Anime Web Tier 01
        (cf "animemovies" "8526c54e36b4962d340fce52ef030e76" 500) # Anime Web Tier 02
        (cf "animemovies" "de41e72708d2c856fa261094c85e965d" 400) # Anime Web Tier 03
        (cf "animemovies" "9edaeee9ea3bcd585da9b7c0ac3fc54f" 300) # Anime Web Tier 04
        (cf "animemovies" "22d953bbe897857b517928f3652b8dd3" 200) # Anime Web Tier 05
        (cf "animemovies" "a786fbc0eae05afe3bb51aee3c83a9d4" 100) # Anime Web Tier 06
        (cf "animemovies" "3a3ff47579026e76d6504ebea39390de" 1050) # Remux Tier 01
        (cf "animemovies" "9f98181fe5a3fbeb0cc29340da2a468a" 1000) # Remux Tier 02
        (cf "animemovies" "8baaf0b3142bf4d94c42a724f034e27a" 950) # Remux Tier 03
        (cf "animemovies" "c20f169ef63c5f40c2def54abaf4438e" 350) # WEB Tier 01
        (cf "animemovies" "403816d65392c79236dcb6dd591aeda4" 250) # WEB Tier 02
        (cf "animemovies" "af94e0fe497124d1f9ce732069ec8c3b" 150) # WEB Tier 03
        (cf "animemovies" "c259005cbaeb5ab44c06eddb4751e70c" (-51)) # v0
        (cf "animemovies" "5f400539421b8fcf71d51e6384434573" 1) # v1
        (cf "animemovies" "3df5e6dfef4b09bb6002f732bed5b774" 2) # v2
        (cf "animemovies" "db92c27ba606996b146b57fbe6d09186" 3) # v3
        (cf "animemovies" "d4e5e842fad129a3c097bdb2d20d31a0" 4) # v4
        (cf "animemovies" "b0fdc5897f68c9a68c70c25169f77447" (-10000)) # Anime LQ Groups
        (cf "animemovies" "b23eae459cc960816f2d6ba84af45055" (-10000)) # Dubs Only
        (cf "animemovies" "9172b2f683f6223e3a1846427b417a3d" (-10000)) # VOSTFR
        (cf "animemovies" "cae4ca30163749b891686f95532519bd" (-10000)) # AV1
        (cf "animemovies" "a5d148168c4506b55cf53984107c396e" 10) # 10bit
        (cf "animemovies" "064af5f084a0a24458cc8ecd3220f93f" 10) # Uncensored
      ];
    };
  };

  sonarr = {
    # Main Sonarr — merged best available (4K preferred, 1080p fallback)
    sonarr = {
      base_url = "http://127.0.0.1:8989";
      api_key = "!env_var SONARR_API_KEY";

      quality_profiles = [
        {
          name = "shows";
          reset_unmatched_scores.enabled = false;
          upgrade = {
            allowed = true;
            until_quality = "Bluray-2160p Remux";
            until_score = 20000;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {name = "Bluray-2160p Remux";}
            {name = "Bluray-2160p";}
            {
              name = "WEB 2160p";
              qualities = ["WEBDL-2160p" "WEBRip-2160p"];
            }
            {name = "Bluray-1080p Remux";}
            {name = "Bluray-1080p";}
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p"];
            }
            {name = "HDTV-1080p";}
            {
              name = "WEB 720p";
              qualities = ["WEBDL-720p" "WEBRip-720p"];
            }
            {name = "HDTV-720p";}
            {name = "DVD";}
          ];
        }
      ];

      delete_old_custom_formats = false;
      replace_existing_custom_formats = true;

      custom_formats =
        (audioFormats "shows" sonarrAudio)
        ++ [
          # Release Group Tiers
          (cf "shows" "9965a052eb87b0d10313b1cea89eb451" 1900) # Remux Tier 01
          (cf "shows" "8a1d0c3d7497e741736761a1da866a2e" 1850) # Remux Tier 02
          (cf "shows" "d6819cba26b1a6508138d25fb5e32293" 1800) # HD Bluray Tier 01
          (cf "shows" "c2216b7b8aa545dc1ce8388c618f8d57" 1750) # HD Bluray Tier 02
          (cf "shows" "e6258996055b9fbab7e9cb2f75819294" 1700) # WEB Tier 01
          (cf "shows" "58790d4e2fdcd9733aa7ae68ba2bb503" 1650) # WEB Tier 02
          (cf "shows" "d84935abd3f8556dcd51d4f27e22d0a6" 1600) # WEB Tier 03
          (cf "shows" "d0c516558625b04b363fa6c5c2c7cfd4" 1600) # WEB Scene

          # Misc
          (cf "shows" "ec8fa7296b64e8cd390a1600981f3923" 5) # Repack/Proper
          (cf "shows" "eb3d5cc0a2be0db205fb823640db6a3c" 6) # Repack2
          (cf "shows" "44e7c4de10ae50265753082e5dc76047" 7) # Repack3

          # Unwanted
          (cf "shows" "15a05bc7c1a36e2b57fd628f8977e2fc" (-20000)) # AV1
          (cf "shows" "23297a736ca77c0fc8e70f8edd7ee56c" (-20000)) # Upscaled
          (cf "shows" "fbcb31d8dabd2a319072b84fc0b7249c" (-20000)) # Extras
          (cf "shows" "9b27ab6498ec0f31a3353992e19434ca" 0) # DV (WEBDL) — 0, not blocked

          # Extras
          (cf "shows" "3bc5f395426614e155e585a2f056cdf1" 1090) # Season Pack
          (cf "shows" "3a4127d8aa781b44120d907f2cd62627" 200) # Hybrid

          # HDR (positive boost only, no SDR penalty)
          (cf "shows" "505d871304820ba7106b693be6fe4a9e" 3000) # HDR
          (cf "shows" "7c3a61a9c6cb04f52f1544be6d44a026" 1000) # DV Boost
          (cf "shows" "0c4b99df9206d2cfac3c05ab897dd62a" 100) # HDR10+ Boost
        ];
    };

    # Sonarr Anime
    sonarranime = {
      base_url = "http://127.0.0.1:8990";
      api_key = "!env_var SONARR_ANIME_API_KEY";

      quality_profiles = [
        {
          name = "anime";
          reset_unmatched_scores.enabled = false;
          upgrade = {
            allowed = true;
            until_quality = "Bluray 1080p";
            until_score = 20000;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Bluray 1080p";
              qualities = ["Bluray-1080p Remux" "Bluray-1080p"];
            }
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p" "HDTV-1080p"];
            }
            {name = "Bluray-720p";}
            {
              name = "WEB 720p";
              qualities = ["WEBDL-720p" "WEBRip-720p" "HDTV-720p"];
            }
            {name = "Bluray-576p";}
            {name = "Bluray-480p";}
            {
              name = "WEB 480p";
              qualities = ["WEBDL-480p" "WEBRip-480p"];
            }
            {name = "DVD";}
            {name = "SDTV";}
          ];
        }
      ];

      delete_old_custom_formats = false;
      replace_existing_custom_formats = true;

      custom_formats = [
        (cf "anime" "949c16fe0a8147f50ba82cc2df9411c9" 1400) # Anime BD Tier 01
        (cf "anime" "ed7f1e315e000aef424a58517fa48727" 1300) # Anime BD Tier 02
        (cf "anime" "096e406c92baa713da4a72d88030c5ed" 1200) # Anime BD Tier 03
        (cf "anime" "30feba9da3030c5ed1e0f7d610bcadc4" 1100) # Anime BD Tier 04
        (cf "anime" "545a76b14ddc349b8b185a6344e28b04" 1000) # Anime BD Tier 05
        (cf "anime" "25d2afecab632b1582eaf03b63055f72" 900) # Anime BD Tier 06
        (cf "anime" "0329044e3d9137b08502a9f84a7e58db" 800) # Anime BD Tier 07
        (cf "anime" "c81bbfb47fed3d5a3ad027d077f889de" 700) # Anime BD Tier 08
        (cf "anime" "e0014372773c8f0e1bef8824f00c7dc4" 600) # Anime Web Tier 01
        (cf "anime" "19180499de5ef2b84b6ec59aae444696" 500) # Anime Web Tier 02
        (cf "anime" "c27f2ae6a4e82373b0f1da094e2489ad" 400) # Anime Web Tier 03
        (cf "anime" "4fd5528a3a8024e6b49f9c67053ea5f3" 300) # Anime Web Tier 04
        (cf "anime" "29c2a13d091144f63307e4a8ce963a39" 200) # Anime Web Tier 05
        (cf "anime" "dc262f88d74c651b12e9d90b39f6c753" 100) # Anime Web Tier 06
        (cf "anime" "9965a052eb87b0d10313b1cea89eb451" 1050) # Remux Tier 01
        (cf "anime" "8a1d0c3d7497e741736761a1da866a2e" 1000) # Remux Tier 02
        (cf "anime" "e6258996055b9fbab7e9cb2f75819294" 350) # WEB Tier 01
        (cf "anime" "58790d4e2fdcd9733aa7ae68ba2bb503" 150) # WEB Tier 02
        (cf "anime" "d84935abd3f8556dcd51d4f27e22d0a6" 150) # WEB Tier 03
        (cf "anime" "d2d7b8a9d39413da5f44054080e028a3" (-51)) # v0
        (cf "anime" "273bd326df95955e1b6c26527d1df89b" 1) # v1
        (cf "anime" "228b8ee9aa0a609463efca874524a6b8" 2) # v2
        (cf "anime" "0e5833d3af2cc5fa96a0c29cd4477feb" 3) # v3
        (cf "anime" "4fc15eeb8f2f9a749f918217d4234ad8" 4) # v4
        (cf "anime" "e3515e519f3b1360cbfc17651944354c" (-10000)) # Anime LQ Groups
        (cf "anime" "9c14d194486c4014d422adc64092d794" (-10000)) # Dubs Only
        (cf "anime" "07a32f77690263bb9fda1842db7e273f" (-10000)) # VOSTFR
        (cf "anime" "15a05bc7c1a36e2b57fd628f8977e2fc" (-10000)) # AV1
        (cf "anime" "3bc5f395426614e155e585a2f056cdf1" 0) # Season Pack
        (cf "anime" "b2550eb333d27b75833e25b8c2557b38" 10) # 10bit
        (cf "anime" "026d5aadd1a6b4e550b134cb6c72b3ca" 10) # Uncensored
      ];
    };
  };
}
