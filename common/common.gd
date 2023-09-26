extends Node2D

const STARTSCREEN = 0
const GAMESCREEN = 1
const TEACHERSSCREEN = 2

var autoplay_timer = 0
var autoplay_running = false
var current_scene = STARTSCREEN
var has_difficulty = false
var curr_aspect=1.0
var base_viewport_size = Vector2()
var true_base_viewport_size = Vector2()
var window_size=Vector2()

var file_to_load= "./game.cfg"
var alt_file_to_load= "./gamealt.cfg"
var file_to_load_local_config= ""
var config_file=null
var local_config_file=null
var options = {}
var timer = 0.0
var lockscreen_timer = 0.0
var lockscreen_increment_timer = 0.0
var newgame_timer = 0.0
var fileops
var loaded_csv_language=""
var aspect_ratio=1.6
# for arabic language
const comm=0
const isolated=1
const final=2
const initial=3
const medial=4
const connects=5
const diacritic=6

var charinfos={
	'ـ':[  'ـ', 'ـ', 'ـ', 'ـ', 'ـ',true,false ],
	'ح':[  'ح', 'ﺡ', 'ﺢ', 'ﺣ', 'ﺤ',true,false ],
	'خ':[  'خ', 'ﺥ', 'ﺦ', 'ﺧ', 'ﺨ',true,false ],
	'د':[  'د', 'ﺩ', 'ﺪ', 'ﺩ', 'ﺪ',false,false ],
	'ْ':[  'ْ', 'ﹾ', 'ﹾ', 'ﹾ', 'ﹿ',false,true ],
	'ت':[  'ت', 'ﺕ', 'ﺖ', 'ﺗ', 'ﺘ',true,false ],
	'ث':[  'ث', 'ﺙ', 'ﺚ', 'ﺛ', 'ﺜ',true,false ],
	'ج':[  'ج', 'ﺝ', 'ﺞ', 'ﺟ', 'ﺠ',true,false ],
	'ٍ':[  'ٍ', 'ﹴ', 'ﹴ', 'ﹴ', 'ﹴ',false,true ],
	'ط':[  'ط', 'ﻁ', 'ﻂ', 'ﻃ', 'ﻄ',true,false ],
	'ض':[  'ض', 'ﺽ', 'ﺾ', 'ﺿ', 'ﻀ',true,false ],
	'ص':[  'ص', 'ﺹ', 'ﺺ', 'ﺻ', 'ﺼ',true,false ],
	'ش':[  'ش', 'ﺵ', 'ﺶ', 'ﺷ', 'ﺸ',true,false ],
	'س':[  'س', 'ﺱ', 'ﺲ', 'ﺳ', 'ﺴ',true,false ],
	'ز':[  'ز', 'ﺯ', 'ﺰ', 'ﺯ', 'ﺰ',false,false ],
	'ر':[  'ر', 'ﺭ', 'ﺮ', 'ﺭ', 'ﺮ',false,false ],
	'ذ':[  'ذ', 'ﺫ', 'ﺬ', 'ﺫ', 'ﺬ',false,false ],
	'َ':[  'َ', 'ﹶ', 'ﹶ', 'ﹶ', 'ﹷ',false,true ],
	'ع':[  'ع', 'ﻉ', 'ﻊ', 'ﻋ', 'ﻌ',true,false ],
	'ظ':[  'ظ', 'ﻅ', 'ﻆ', 'ﻇ', 'ﻈ',true,false ],
	'ّ':[  'ّ', 'ﹼ', 'ﹼ', 'ﹼ', 'ﹽ',false,true ],
	'ِ':[  'ِ', 'ﹺ', 'ﹺ', 'ﹺ', 'ﹻ',false,true ],
	'ي':[  'ي', 'ﻱ', 'ﻲ', 'ﻳ', 'ﻴ',true,false ],
	'ٓ':[  'ٓ', 'ٓ', 'ٓ', 'ٓ', 'ٓ',false,true ],
	'ٌ':[  'ٌ', 'ﹲ', 'ﹲ', 'ﹲ', 'ﹲ',false,true ],
	'ً':[  'ً', 'ﹹ', 'ﹰ', 'ﹰ', 'ﹱ',false,true ],
	'ُ':[  'ُ', 'ﹸ', 'ﹸ', 'ﹸ', 'ﹹ',false,true ],
	'ن':[  'ن', 'ﻥ', 'ﻦ', 'ﻧ', 'ﻨ',true,false ],
	'ه':[  'ه', 'ﻩ', 'ﻪ', 'ﻫ', 'ﻬ',true,false ],
	'ل':[  'ل', 'ﻝ', 'ﻞ', 'ﻟ', 'ﻠ',true,false ],
	'م':[  'م', 'ﻡ', 'ﻢ', 'ﻣ', 'ﻤ',true,false ],
	'ق':[  'ق', 'ﻕ', 'ﻖ', 'ﻗ', 'ﻘ',true,false ],
	'ك':[  'ك', 'ﻙ', 'ﻚ', 'ﻛ', 'ﻜ',true,false ],
	'غ':[  'غ', 'ﻍ', 'ﻎ', 'ﻏ', 'ﻐ',true,false ],
	'ف':[  'ف', 'ﻑ', 'ﻒ', 'ﻓ', 'ﻔ',true,false ],
	'و':[  'و', 'ﻭ', 'ﻮ', 'ﻭ', 'ﻮ',false,false ],
	'ى':[  'ى', 'ﻯ', 'ﻰ', 'ﻯ', 'ﻰ',false,false ],
	'ؤ':[  'ؤ', 'ﺅ', 'ﺆ', 'ﺅ', 'ﺆ',false,false ],
	'إ':[  'إ', 'ﺇ', 'ﺈ', 'ﺇ', 'ﺈ',false,false ],
	'ئ':[  'ئ', 'ﺉ', 'ﺊ', 'ﺋ', 'ﺌ',true,false ],
	'ا':[  'ا', 'ﺍ', 'ﺎ', 'ﺍ', 'ﺎ',false,false ],
	'ء':[  'ء', 'ﺀ', 'ﺀ', 'ﺀ', 'ﺀ',false,false ],
	'آ':[  'آ', 'ﺁ', 'ﺂ', 'ﺁ', 'ﺂ',false,false ],
	'أ':[  'أ', 'ﺃ', 'ﺄ', 'ﺃ', 'ﺄ',false,false ],
	'ب':[  'ب', 'ﺏ', 'ﺐ', 'ﺑ', 'ﺒ',true,false ],
	'ة':[  'ة', 'ﺓ', 'ﺔ', 'ﺓ', 'ﺔ',false,false ]
	}
# this is straight from godot 3.1 sources. When in multi-godot environment,
# this list has to be greatest common between them.

const valid_locales = [
	"aa", #  Afar
	"aa_DJ", #  Afar (Djibouti)
	"aa_ER", #  Afar (Eritrea)
	"aa_ET", #  Afar (Ethiopia)
	"af", #  Afrikaans
	"af_ZA", #  Afrikaans (South Africa)
	"agr_PE", #  Aguaruna (Peru)
	"ak_GH", #  Akan (Ghana)
	"am_ET", #  Amharic (Ethiopia)
	"an_ES", #  Aragonese (Spain)
	"anp_IN", #  Angika (India)
	"ar", #  Arabic
	"ar_AE", #  Arabic (United Arab Emirates)
	"ar_BH", #  Arabic (Bahrain)
	"ar_DZ", #  Arabic (Algeria)
	"ar_EG", #  Arabic (Egypt)
	"ar_IN", #  Arabic (India)
	"ar_IQ", #  Arabic (Iraq)
	"ar_JO", #  Arabic (Jordan)
	"ar_KW", #  Arabic (Kuwait)
	"ar_LB", #  Arabic (Lebanon)
	"ar_LY", #  Arabic (Libya)
	"ar_MA", #  Arabic (Morocco)
	"ar_OM", #  Arabic (Oman)
	"ar_QA", #  Arabic (Qatar)
	"ar_SA", #  Arabic (Saudi Arabia)
	"ar_SD", #  Arabic (Sudan)
	"ar_SS", #  Arabic (South Soudan)
	"ar_SY", #  Arabic (Syria)
	"ar_TN", #  Arabic (Tunisia)
	"ar_YE", #  Arabic (Yemen)
	"as_IN", #  Assamese (India)
	"ast_ES", #  Asturian (Spain)
	"ayc_PE", #  Southern Aymara (Peru)
	"ay_PE", #  Aymara (Peru)
	"az_AZ", #  Azerbaijani (Azerbaijan)
	"be", #  Belarusian
	"be_BY", #  Belarusian (Belarus)
	"bem_ZM", #  Bemba (Zambia)
	"ber_DZ", #  Berber languages (Algeria)
	"ber_MA", #  Berber languages (Morocco)
	"bg", #  Bulgarian
	"bg_BG", #  Bulgarian (Bulgaria)
	"bhb_IN", #  Bhili (India)
	"bho_IN", #  Bhojpuri (India)
	"bi_TV", #  Bislama (Tuvalu)
	"bn", #  Bengali
	"bn_BD", #  Bengali (Bangladesh)
	"bn_IN", #  Bengali (India)
	"bo", #  Tibetan
	"bo_CN", #  Tibetan (China)
	"bo_IN", #  Tibetan (India)
	"br_FR", #  Breton (France)
	"brx_IN", #  Bodo (India)
	"bs_BA", #  Bosnian (Bosnia and Herzegovina)
	"byn_ER", #  Bilin (Eritrea)
	"ca", #  Catalan
	"ca_AD", #  Catalan (Andorra)
	"ca_ES", #  Catalan (Spain)
	"ca_FR", #  Catalan (France)
	"ca_IT", #  Catalan (Italy)
	"ce_RU", #  Chechen (Russia)
	"chr_US", #  Cherokee (United States)
	"cmn_TW", #  Mandarin Chinese (Taiwan)
	"crh_UA", #  Crimean Tatar (Ukraine)
	"csb_PL", #  Kashubian (Poland)
	"cs", #  Czech
	"cs_CZ", #  Czech (Czech Republic)
	"cv_RU", #  Chuvash (Russia)
	"cy_GB", #  Welsh (United Kingdom)
	"da", #  Danish
	"da_DK", #  Danish (Denmark)
	"de", #  German
	"de_AT", #  German (Austria)
	"de_BE", #  German (Belgium)
	"de_CH", #  German (Switzerland)
	"de_DE", #  German (Germany)
	"de_IT", #  German (Italy)
	"de_LU", #  German (Luxembourg)
	"doi_IN", #  Dogri (India)
	"dv_MV", #  Dhivehi (Maldives)
	"dz_BT", #  Dzongkha (Bhutan)
	"el", #  Greek
	"el_CY", #  Greek (Cyprus)
	"el_GR", #  Greek (Greece)
	"en", #  English
	"en_AG", #  English (Antigua and Barbuda)
	"en_AU", #  English (Australia)
	"en_BW", #  English (Botswana)
	"en_CA", #  English (Canada)
	"en_DK", #  English (Denmark)
	"en_GB", #  English (United Kingdom)
	"en_HK", #  English (Hong Kong)
	"en_IE", #  English (Ireland)
	"en_IL", #  English (Israel)
	"en_IN", #  English (India)
	"en_NG", #  English (Nigeria)
	"en_NZ", #  English (New Zealand)
	"en_PH", #  English (Philippines)
	"en_SG", #  English (Singapore)
	"en_US", #  English (United States)
	"en_ZA", #  English (South Africa)
	"en_ZM", #  English (Zambia)
	"en_ZW", #  English (Zimbabwe)
	"eo", #  Esperanto
	"es", #  Spanish
	"es_AR", #  Spanish (Argentina)
	"es_BO", #  Spanish (Bolivia)
	"es_CL", #  Spanish (Chile)
	"es_CO", #  Spanish (Colombia)
	"es_CR", #  Spanish (Costa Rica)
	"es_CU", #  Spanish (Cuba)
	"es_DO", #  Spanish (Dominican Republic)
	"es_EC", #  Spanish (Ecuador)
	"es_ES", #  Spanish (Spain)
	"es_GT", #  Spanish (Guatemala)
	"es_HN", #  Spanish (Honduras)
	"es_MX", #  Spanish (Mexico)
	"es_NI", #  Spanish (Nicaragua)
	"es_PA", #  Spanish (Panama)
	"es_PE", #  Spanish (Peru)
	"es_PR", #  Spanish (Puerto Rico)
	"es_PY", #  Spanish (Paraguay)
	"es_SV", #  Spanish (El Salvador)
	"es_US", #  Spanish (United States)
	"es_UY", #  Spanish (Uruguay)
	"es_VE", #  Spanish (Venezuela)
	"et", #  Estonian
	"et_EE", #  Estonian (Estonia)
	"eu", #  Basque
	"eu_ES", #  Basque (Spain)
	"fa", #  Persian
	"fa_IR", #  Persian (Iran)
	"ff_SN", #  Fulah (Senegal)
	"fi", #  Finnish
	"fi_FI", #  Finnish (Finland)
	"fil", #  Filipino
	"fil_PH", #  Filipino (Philippines)
	"fo_FO", #  Faroese (Faroe Islands)
	"fr", #  French
	"fr_BE", #  French (Belgium)
	"fr_CA", #  French (Canada)
	"fr_CH", #  French (Switzerland)
	"fr_FR", #  French (France)
	"fr_LU", #  French (Luxembourg)
	"fur_IT", #  Friulian (Italy)
	"fy_DE", #  Western Frisian (Germany)
	"fy_NL", #  Western Frisian (Netherlands)
	"ga", #  Irish
	"ga_IE", #  Irish (Ireland)
	"gd_GB", #  Scottish Gaelic (United Kingdom)
	"gez_ER", #  Geez (Eritrea)
	"gez_ET", #  Geez (Ethiopia)
	"gl_ES", #  Galician (Spain)
	"gu_IN", #  Gujarati (India)
	"gv_GB", #  Manx (United Kingdom)
	"hak_TW", #  Hakka Chinese (Taiwan)
	"ha_NG", #  Hausa (Nigeria)
	"he", #  Hebrew
	"he_IL", #  Hebrew (Israel)
	"hi", #  Hindi
	"hi_IN", #  Hindi (India)
	"hne_IN", #  Chhattisgarhi (India)
	"hr", #  Croatian
	"hr_HR", #  Croatian (Croatia)
	"hsb_DE", #  Upper Sorbian (Germany)
	"ht_HT", #  Haitian (Haiti)
	"hu", #  Hungarian
	"hu_HU", #  Hungarian (Hungary)
	"hus_MX", #  Huastec (Mexico)
	"hy_AM", #  Armenian (Armenia)
	"ia_FR", #  Interlingua (France)
	"id", #  Indonesian
	"id_ID", #  Indonesian (Indonesia)
	"ig_NG", #  Igbo (Nigeria)
	"ik_CA", #  Inupiaq (Canada)
	"is", #  Icelandic
	"is_IS", #  Icelandic (Iceland)
	"it", #  Italian
	"it_CH", #  Italian (Switzerland)
	"it_IT", #  Italian (Italy)
	"iu_CA", #  Inuktitut (Canada)
	"ja", #  Japanese
	"ja_JP", #  Japanese (Japan)
	"kab_DZ", #  Kabyle (Algeria)
	"ka", #  Georgian
	"ka_GE", #  Georgian (Georgia)
	"kk_KZ", #  Kazakh (Kazakhstan)
	"kl_GL", #  Kalaallisut (Greenland)
	"km_KH", #  Central Khmer (Cambodia)
	"kn_IN", #  Kannada (India)
	"kok_IN", #  Konkani (India)
	"ko", #  Korean
	"ko_KR", #  Korean (South Korea)
	"ks_IN", #  Kashmiri (India)
	"ku", #  Kurdish
	"ku_TR", #  Kurdish (Turkey)
	"kw_GB", #  Cornish (United Kingdom)
	"ky_KG", #  Kirghiz (Kyrgyzstan)
	"lb_LU", #  Luxembourgish (Luxembourg)
	"lg_UG", #  Ganda (Uganda)
	"li_BE", #  Limburgan (Belgium)
	"li_NL", #  Limburgan (Netherlands)
	"lij_IT", #  Ligurian (Italy)
	"ln_CD", #  Lingala (Congo)
	"lo_LA", #  Lao (Laos)
	"lt", #  Lithuanian
	"lt_LT", #  Lithuanian (Lithuania)
	"lv", #  Latvian
	"lv_LV", #  Latvian (Latvia)
	"lzh_TW", #  Literary Chinese (Taiwan)
	"mag_IN", #  Magahi (India)
	"mai_IN", #  Maithili (India)
	"mg_MG", #  Malagasy (Madagascar)
	"mh_MH", #  Marshallese (Marshall Islands)
	"mhr_RU", #  Eastern Mari (Russia)
	"mi", #  Māori
	"mi_NZ", #  Māori (New Zealand)
	"miq_NI", #  Mískito (Nicaragua)
	"mk", #  Macedonian
	"mk_MK", #  Macedonian (Macedonia)
	"ml", #  Malayalam
	"ml_IN", #  Malayalam (India)
	"mni_IN", #  Manipuri (India)
	"mn_MN", #  Mongolian (Mongolia)
	"mr_IN", #  Marathi (India)
	"ms", #  Malay
	"ms_MY", #  Malay (Malaysia)
	"mt", #  Maltese
	"mt_MT", #  Maltese (Malta)
	"my_MM", #  Burmese (Myanmar)
	"myv_RU", #  Erzya (Russia)
	"nah_MX", #  Nahuatl languages (Mexico)
	"nan_TW", #  Min Nan Chinese (Taiwan)
	"nb", #  Norwegian Bokmål
	"nb_NO", #  Norwegian Bokmål (Norway)
	"nds_DE", #  Low German (Germany)
	"nds_NL", #  Low German (Netherlands)
	"ne_NP", #  Nepali (Nepal)
	"nhn_MX", #  Central Nahuatl (Mexico)
	"niu_NU", #  Niuean (Niue)
	"niu_NZ", #  Niuean (New Zealand)
	"nl", #  Dutch
	"nl_AW", #  Dutch (Aruba)
	"nl_BE", #  Dutch (Belgium)
	"nl_NL", #  Dutch (Netherlands)
	"nn", #  Norwegian Nynorsk
	"nn_NO", #  Norwegian Nynorsk (Norway)
	"nr_ZA", #  South Ndebele (South Africa)
	"nso_ZA", #  Pedi (South Africa)
	"oc_FR", #  Occitan (France)
	"om", #  Oromo
	"om_ET", #  Oromo (Ethiopia)
	"om_KE", #  Oromo (Kenya)
	"or_IN", #  Oriya (India)
	"os_RU", #  Ossetian (Russia)
	"pa_IN", #  Panjabi (India)
	"pap", #  Papiamento
	"pap_AN", #  Papiamento (Netherlands Antilles)
	"pap_AW", #  Papiamento (Aruba)
	"pap_CW", #  Papiamento (Curaçao)
	"pa_PK", #  Panjabi (Pakistan)
	"pl", #  Polish
	"pl_PL", #  Polish (Poland)
	"pr", #  Pirate
	"ps_AF", #  Pushto (Afghanistan)
	"pt", #  Portuguese
	"pt_BR", #  Portuguese (Brazil)
	"pt_PT", #  Portuguese (Portugal)
	"quy_PE", #  Ayacucho Quechua (Peru)
	"quz_PE", #  Cusco Quechua (Peru)
	"raj_IN", #  Rajasthani (India)
	"ro", #  Romanian
	"ro_RO", #  Romanian (Romania)
	"ru", #  Russian
	"ru_RU", #  Russian (Russia)
	"ru_UA", #  Russian (Ukraine)
	"rw_RW", #  Kinyarwanda (Rwanda)
	"sa_IN", #  Sanskrit (India)
	"sat_IN", #  Santali (India)
	"sc_IT", #  Sardinian (Italy)
	"sco", #  Scots
	"sd_IN", #  Sindhi (India)
	"se_NO", #  Northern Sami (Norway)
	"sgs_LT", #  Samogitian (Lithuania)
	"shs_CA", #  Shuswap (Canada)
	"sid_ET", #  Sidamo (Ethiopia)
	"si", #  Sinhala
	"si_LK", #  Sinhala (Sri Lanka)
	"sk", #  Slovak
	"sk_SK", #  Slovak (Slovakia)
	"sl", #  Slovenian
	"sl_SI", #  Slovenian (Slovenia)
	"so", #  Somali
	"so_DJ", #  Somali (Djibouti)
	"so_ET", #  Somali (Ethiopia)
	"so_KE", #  Somali (Kenya)
	"so_SO", #  Somali (Somalia)
	"son_ML", #  Songhai languages (Mali)
	"sq", #  Albanian
	"sq_AL", #  Albanian (Albania)
	"sq_KV", #  Albanian (Kosovo)
	"sq_MK", #  Albanian (Macedonia)
	"sr", #  Serbian
	"sr_Cyrl", #  Serbian (Cyrillic)
	"sr_Latn", #  Serbian (Latin)
	"sr_ME", #  Serbian (Montenegro)
	"sr_RS", #  Serbian (Serbia)
	"ss_ZA", #  Swati (South Africa)
	"st_ZA", #  Southern Sotho (South Africa)
	"sv", #  Swedish
	"sv_FI", #  Swedish (Finland)
	"sv_SE", #  Swedish (Sweden)
	"sw_KE", #  Swahili (Kenya)
	"sw_TZ", #  Swahili (Tanzania)
	"szl_PL", #  Silesian (Poland)
	"ta", #  Tamil
	"ta_IN", #  Tamil (India)
	"ta_LK", #  Tamil (Sri Lanka)
	"tcy_IN", #  Tulu (India)
	"te", #  Telugu
	"te_IN", #  Telugu (India)
	"tg_TJ", #  Tajik (Tajikistan)
	"the_NP", #  Chitwania Tharu (Nepal)
	"th", #  Thai
	"th_TH", #  Thai (Thailand)
	"ti", #  Tigrinya
	"ti_ER", #  Tigrinya (Eritrea)
	"ti_ET", #  Tigrinya (Ethiopia)
	"tig_ER", #  Tigre (Eritrea)
	"tk_TM", #  Turkmen (Turkmenistan)
	"tl_PH", #  Tagalog (Philippines)
	"tn_ZA", #  Tswana (South Africa)
	"tr", #  Turkish
	"tr_CY", #  Turkish (Cyprus)
	"tr_TR", #  Turkish (Turkey)
	"ts_ZA", #  Tsonga (South Africa)
	"tt_RU", #  Tatar (Russia)
	"ug_CN", #  Uighur (China)
	"uk", #  Ukrainian
	"uk_UA", #  Ukrainian (Ukraine)
	"unm_US", #  Unami (United States)
	"ur", #  Urdu
	"ur_IN", #  Urdu (India)
	"ur_PK", #  Urdu (Pakistan)
	"uz", #  Uzbek
	"uz_UZ", #  Uzbek (Uzbekistan)
	"ve_ZA", #  Venda (South Africa)
	"vi", #  Vietnamese
	"vi_VN", #  Vietnamese (Vietnam)
	"wa_BE", #  Walloon (Belgium)
	"wae_CH", #  Walser (Switzerland)
	"wal_ET", #  Wolaytta (Ethiopia)
	"wo_SN", #  Wolof (Senegal)
	"xh_ZA", #  Xhosa (South Africa)
	"yi_US", #  Yiddish (United States)
	"yo_NG", #  Yoruba (Nigeria)
	"yue_HK", #  Yue Chinese (Hong Kong)
	"zh", #  Chinese
	"zh_CN", #  Chinese (China)
	"zh_HK", #  Chinese (Hong Kong)
	"zh_SG", #  Chinese (Singapore)
	"zh_TW", #  Chinese (Taiwan)
	"zu_ZA", #  Zulu (South Africa)
]

const locale_fix_map = {
	"bs": "bs_BA" # for some reason, in 3.1 Godot doesn’t recognize bs as valid locale, have to go with bs_BA
}

var rtl_content=false

	# default options keys and values
### | Opcja | Opis | Oczekiwany rodzaj wartości | Domyślna wartość |
### | :--: | :--: | :--: | :--: |

var	config_dict={
		"Game":{
###	|`language`|string|bierze udział w konkursie na język|`""`|	
		"language":"",#TranslationServer.get_locale(),
###	|`baselanguage`|string|bierze udział w konkursie na język|`""`|	
		"baselanguage":"",
###	|`sensitivity_diff`|int|odchyłka od systemowego ustawienia czułości|`0`|	
		"sensitivity_diff":0,
###	|`sensitivity`|int|nadpisanie systemowego ustawienia czułości|`-1`|	
		"sensitivity":-1,
###	|`autoplay`|int|jeśli różne od zera - wyłącza ekran "start"|`0`|	
		"autoplay":0,
###	|`lockscreen`|int|po pewnym czasie nieaktywności gra się kończy z zaznaczeniem tego faktu w systemie, co powoduje właczenie ekranu przyciągania uwagi; 4.0 chyba nieużywane ???|`0`|	
		"lockscreen":0,
###	|`remote_only`|boolean|ekran "start" i "new_game" obsługiwane wyłącznie pilotem|`false`|
		"remote_only":false,
###	|`translation_file`|string|stary nieużywany sposób dodawania tłumaczeń|`"locale.txt"`|
		"translation_file":"locale.txt",
###	|`translation_directory`|string|aktualny sposób określania miejsca tłumaczeń|`"po/"`|
		"translation_directory":"po/",
###	|`external_font_path`|string|aktualny sposób określania miejsca fontów do podmiany|`""`|
		"external_font_path":"",
###	|`bg_color`|string|tło ekranu "start" (nieużywane)|`""`|
		"bg_color":"1c2158",
###	|`bg_particles`|string|cząsteczki nieużywanego ekranu "start" - błędny typ, powinien być boolean|`""`|
		"bg_particles":"",
###	|`game_title`|string|menu przekazuje nazwę gry, dotyczy nieużywanego ekranu "start"|`""`|
		"game_title":"",
###	|`bundle_label`|string|menu przekazuje etykietę gry, dotyczy nieużywanego ekranu "start"|`""`|
		"bundle_label":"",
###	|`game_category_icon`|string|wczytuje i ustawia ikonę, dotyczy nieużywanego ekranu "start"|`""`|
		"game_category_icon":"", #
###	|`funtronic_logo_hidden`|boolean|???|`false`|	
		"funtronic_logo_hidden":false,
###	|`tutorial`|string|zarzucone, nieużywane wraz z ekranem "start"|`"res://tutorial.ogv"`|
		"tutorial":"res://tutorial.ogv", 
###	|`newgame`|int|jeśli newgame_enabled==true, po tym czasie (jeśli nie 0) następuje zamoistne zakończenie gry, w celu uruchomienia nowej ???|`0`|
		"newgame":0,
###	|`newgame_enabled`|boolean|jeśli false, po zakończeniu gry na screenie "new_game" będzie obecny wyłącznie przycisk "powtórz", w p. p. "powtórz" i "zakończ" |`false`|	
		"newgame_enabled":false,
###	|`newgame_exit_delay`|int|jeśli >=0, powoduje opoźnienie po pojawieniu się ekranu "new_game", po którym gra się kończy|`-1`|
		"newgame_exit_delay":-1,
###	|`no_startscreen`|boolean|nie pokazuje ekranu "start", do tego stopnia, że ekran "start" nie jest dobrze przetestowany i pewnie nie wszystko działa|`true`|	
		"no_startscreen":true,
###	|`upside_down`|boolean|nic nie robi, może być obsłużone indywidualnie|`false`|
		"upside_down":false,
###	|`show_game_version`|boolean|pokazuje wersję gry w lewym górnym rogu; używa pliku \_version.tscn|`false`|
		"show_game_version":false,
###	|`startscreen_delay`|int|sprowadza opóźnienie pokazania sie napisu START; dotyczy nieużywanego ekranu "start"|`0`|
		"startscreen_delay":"0",
###	|`startscreen_audio`|string|słowna instrukcja użytkowania, dotyczy nieużywanego ekranu "start"|`"rules.ogg"`|
		"startscreen_audio":"rules.ogg",
###	|`rtl_languages`|string|lista języków right to left oddzielona przecinkami; nietestowane na 4.0|`"ar"`|
		"rtl_languages":"ar",
###	|`zoom_on_aspect_key`|boolean|pozwala zmieniać zoom w grze, **tylko w celach testowych**|`false`|
		"zoom_on_aspect_key":false,
###	|`custom_aspect_key`|boolean|pozwala obsługiwać aspect_key w grach, wyłącza jego domyślne działanie|`false`|
		"custom_aspect_key":false,
###	|`teachers_screen_on_aspect_key`|boolean|pozwala uruchomić ekran nauczyciela w grze|`true`|
		"teachers_screen_on_aspect_key":true,
###	|`is_screensaver`|boolean|zmienia tryb działania gry na typ screensaver|`false`|
		"is_screensaver":false,
###	|`network_client_active`|boolean|???|`true`|
		"network_client_active":true,
###	|`setzoom`|float|pozwala ustawić zoom na stałe. **Tylko do celów testowych.**|`true`|
		"setzoom":1.0,
###	|`game_parameters`|string|stary sposób ustawiania specyficznych dla gry parametrów - nie używać. Nowy to `GameParameters.tscn`|`""`|	
		"game_parameters":"",
###	|`label`|string|menu przekazuje nazwę gry zakodowaną w Base64, automatycznie rozkodowaną|`""`|
		"label":"",
###	|`description`|string|menu przekazuje opis gry zakodowany w Base64, automatycznie rozkodowany|`""`|
		"description":"",
###	|`rw_config_filename`|string|**UNIKALNA (dba o to programista)** nazwa pliku, w którym gra zapisuje swoje dane|`""`|
		"rw_config_filename":"",
###	|`menu_home`|string|???|`""`|
		"menu_home":"",
###	|`games_home`|string|???|`""`|
		"games_home":"",
###	|`diagnose_map_interval`|string|co ile zapisywać log diagnostyki (w celach badań statystycznych)|`"0"`|
		"diagnose_map_interval":"0",
###	|`do_diagnose_log`|boolean|zapisywać, czy nie zapisywać log diagnostyki (w celach badań statystycznych)|`false`|
		"do_diagnose_log":false,
###	|`diagnose_log_filename`|string|nazwa pliku do zapisu, z parametrem %s jako numerem|`"/dev/shm/diagnose_%s.log"`|
		"diagnose_log_filename":"/dev/shm/diagnose_%s.log",
###	|`testmode`|boolean|włącza tryb testowy dla niektórych gier (głównie quizów)|`false`|
		"testmode":false,
###	|`no_randomize`|boolean|nie wykonuje "randomize()" podczas inicjacji; pozwala testować randomowe gry w nierandomowy sposób|`false`|
		"no_randomize":false,
###	|`bg_image`|string|nazwa pliku tła; domyślna wartość - znacznik pliku|`"__FILE__"`|
		"bg_image":"__FILE__", #file
###	|`bundle_logo`|string|nazwa pliku logo; domyślna wartość - znacznik pliku|`"__FILE__"`|
		"bundle_logo":"__FILE__", #file
###	|`partner_logo`|string|nazwa pliku partner_logo; domyślna wartość - znacznik pliku|`"__FILE__"`|
		"partner_logo":"__FILE__", #file
###	|`funtronic_logo`|string|nazwa pliku funtronic_logo; domyślna wartość - znacznik pliku|`"__FILE__"`|
		"funtronic_logo":"__FILE__", #file
		},
		"Game_Local":{
		}}
# those are not hadled by game, but by menu
###	| `main_pack` | Steruje formatem kontenera, do którego eksportowana jest gra. `zip` zapewnia lepszą kompresję, ale generowało problemy (problem aktualnie usunięty). `pck` jest bezproblemowy. | `"zip"` lub `"pck"` | `"zip"` |
###	| `godot_version` | Wersja Godota używana przez grę. | `"3.1.1"`, `"3.2.3"` | `"3.1.1"` |

func _ready():
	print("COMMON init START")
	print(game_version())
	true_base_viewport_size=get_viewport_rect().size
	base_viewport_size=Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))#get_viewport_rect().size
	window_size=OS.get_window_size()
	aspect_ratio=window_size.x/window_size.y
	print("OS Locale: "+OS.get_locale())
	print("AppWindowSize:    "+str(window_size))
	print("TrueViewPortSize: "+str(true_base_viewport_size))
	print("DeclViewPortSize: "+str(base_viewport_size))
	print("AspectRatio: "+str(aspect_ratio))

	# this is needed for event mapping inside guts of godot.
	ProjectSettings.set_setting("display/window/size/test_width",window_size.x)
	ProjectSettings.set_setting("display/window/size/test_height",window_size.y)

	# SETTING DEFAULTS	
	for s in ["Game","Game_Local"]:
		for d in config_dict[s]:
			if str(config_dict[s][d])=="__FILE__":
				options[d]="" # it is file, so we have to check the existence
			else: # simple value
				options[d] = config_dict[s][d]



	# KEY IS PARAM PASSED, VALUE IS AN "OPTIONS" KEY
	var translate_param_dict={
		"-baselanguage":"baselanguage",
		"-nostartscreen":"no_startscreen",
		"-upsidedown":"upside_down",
		"-showgameversion":"show_game_version",
		"-remoteonly":"remote_only", 
		"-newgame_exit_delay":"newgame_exit_delay",
		"-funtroniclogohidden":"funtronic_logo_hidden",
		"-lockscreen":"lockscreen",
		"-newgame":"newgame",
		"-partnerlogo":"partner_logo",
		"-bundlelogo":"bundle_logo",
		"-bundlelabel":"bundle_label",
		"-bgimage":"bg_image",
		"-bgcolor":"bg_color",
		"-funtroniclogo":"funtronic_logo",
		"-autoplay":"autoplay",
		"-setzoom":"setzoom",
		"-is_screensaver":"is_screensaver",
		"-zoom_on_aspect_key":"zoom_on_aspect_key",
		"-testmode":"testmode",
		"-no_randomize":"no_randomize",
		"-label":"label",
		"-description":"description",
		"-teachers_screen_on_aspect_key":"teachers_screen_on_aspect_key",
		"-external_font_path":"external_font_path",
		}
	var args = OS.get_cmdline_args()

	for arg in args:
		if arg in ["-nostartscreen","-remoteonly","-funtroniclogohidden","-showgameversion","-upsidedown","-testmode","-no_randomize"]:
			options[translate_param_dict[arg]]=true
			print("SET: "+translate_param_dict[arg]+"="+str(options[translate_param_dict[arg]]))

	for t in translate_param_dict:

		# Boolean values handling
		if t in ["-nostartscreen","-remoteonly","-funtroniclogohidden","-showgameversion","-upsidedown","-testmode","-zoom_on_aspect_key","-is_screensaver","-teachers_screen_on_aspect_key","-no_randomize"]:
			for arg in args:
				if(arg.find(t) > -1):
					if arg.right(str(t).length()) == "true":
						options[translate_param_dict[t]] = true
					elif arg.right(str(t).length()) == "false":
						options[translate_param_dict[t]] = false
					elif arg == t:
						options[translate_param_dict[t]] = true
					elif arg.right(str(t).length()) != "":
						print("BAD VALUE "+arg+" : "+arg.right(str(t).length()))
					
		# raw id_string handling
		# special handling due to substring
		elif t=="-funtroniclogo":
			for arg in args:
				if(arg.find(t) > -1 and arg != "-funtroniclogohidden"):
					options[translate_param_dict[t]] = arg.right(str(t).length())
		
		# Base64 values handling
		elif t in ["-label","-description"]:
			for arg in args:
				if arg.find(t) > -1:
					print("TITLE: "+Marshalls.base64_to_utf8(arg.right(str(t).length())))
					options[translate_param_dict[t]] = Marshalls.base64_to_utf8(arg.right(str(t).length()))
		# Float values handling
		elif t=="-setzoom": # special handling due to substring
			for arg in args:
				if arg.find(t) > -1:
					options[translate_param_dict[t]] = float(arg.right(str(t).length()))
		# Integer values handling + logic
		elif t=="-autoplay":  # special handling due to logic
			for arg in args:
				if(arg.find(t) > -1):
					options["no_startscreen"] = true
					options[translate_param_dict[t]] = int(arg.right(str(t).length()))

		# rest of Integer values handling
		elif t in ["-lockscreen","-newgame","-newgame_exit_delay"]:
			for arg in args:
				if(arg.find(t) > -1):
					options[translate_param_dict[t]] = int(arg.right(str(t).length()))

		# rest - string values handling
		else:
			for arg in args:
				if(arg.find(t) > -1):
					options[translate_param_dict[t]] = arg.right(str(t).length())
		print(translate_param_dict[t]+"="+str(options[translate_param_dict[t]]))
			
	LoadMainGameConfig("Game")

	for n in ["menu_home","games_home"]:
		if(OS.get_environment(n) != ""):
			options[n] = OS.get_environment(n)
			if options[n].length()>0:
				if options[n].right(options[n].length()-1)!="/":
					options[n]+="/"
		# will be local if no
		options[n]+="rw_game_settings"
		options[n]+="/"+options["rw_config_filename"]
		print("LOCAL RW OPTIONS FILE: "+options[n])

	
	if(options["no_randomize"] == false): randomize()

	if(options["external_font_path"] != ""):
		get_tree().connect("node_added", self, "font_replace_on_tree_node_added")
	
	call_deferred("init_sensitivity")
	
	call_deferred("set_window_size",options["setzoom"])

	if(common.options["autoplay"] > 0):
		call_deferred("set_global_autoplay", true)
	
	if(common.options["autoplay"] > 0 or common.options["lockscreen"] > 0 or common.options["newgame"] > 0):
		set_physics_process(true)

	#for o in options:
	#	print("CONFIG: "+o+"="+str(options[o]))
	
	init_translation()
	print("COMMON init END")

func get_aspect_ratio():
	return aspect_ratio

func LoadMainGameConfig(section):
	var config_file = ConfigFile.new() 
	var s=section
	var err = config_file.load(alt_file_to_load)
	if err != OK:
		err = config_file.load(file_to_load)
	if err == OK:
		for d in config_file.get_section_keys(s):
			if config_dict[s].has(d):
				if s=="Game": # only in this section keys can be anything
					if str(config_dict[s][d])=="__FILE__": # it is file, so we have to check the existence
						if(File.new().file_exists(config_file.get_value(s, d))): 
							options[d] = config_file.get_value(s, d)
							print("CONFIG_GAME: "+d+"="+str(options[d]))
					else: # simple value
						options[d] = config_file.get_value(s, d)
						print("CONFIG_GAME: "+d+"="+str(options[d]))
			else:
				if s=="Game_Local": # only in this section keys can be anything
					if options.has(d): # overwrite default values
						options[d] = config_file.get_value(s, d)
						print("CONFIG_GAME_LOCAL: "+d+"="+str(options[d]))
					else:
						print("MAINTAIN> TRY TO HANDLE nonexistent parameter "+str(d))
						print("MAINTAIN> Add it to ./local/game_parameters/GameParameters.tscn")

func impulse():
	newgame_timer = 0.0
	lockscreen_timer = 0.0
	lockscreen_increment_timer = 0.0
	if(type_exists("VFFileOps")):
		if fileops!=null:
			fileops.setNotUsed()
	if(get_tree().root.has_node("/root/NetworkClient")):
		get_tree().root.get_node("NetworkClient").SendImpulse()

func _physics_process(delta):
	if(autoplay_running):
		if(common.options["autoplay"] == 0):
			call_deferred("set_global_autoplay", false)
		else:
			common.timer += delta
			if(common.timer > common.options["autoplay"]):
				get_tree().quit()

	if(options["lockscreen"] > 0):
		lockscreen_timer += delta
		lockscreen_increment_timer += delta
		if(lockscreen_increment_timer > 1.0):
			lockscreen_increment_timer -= 1.0
			if(type_exists("VFFileOps")):
				fileops.incNotUsed()
		if(lockscreen_timer > options["lockscreen"]):
			if(type_exists("VFFileOps")):
				fileops.setLock(1)
			get_tree().quit()
	
	if(options["newgame"] > 0 and options["newgame_enabled"] and current_scene == GAMESCREEN):
		newgame_timer += delta
		if(newgame_timer > options["newgame"]):
			get_tree().get_current_scene().show_new_game()
		if options["newgame_exit_delay"]>=0:
			if(newgame_timer > options["newgame"]+ options["newgame_exit_delay"]):
				get_tree().quit()

func set_global_autoplay(value):
	autoplay_running = value
	if(type_exists("VFFileOps")):
		fileops.setAutoplay(value)

func aspect():
	var aspect=options["setzoom"]
	if curr_aspect==0:
		curr_aspect=aspect
		
	if typeof(aspect) == TYPE_REAL:
		if aspect>=0.5 and aspect <=1.0:
			curr_aspect=aspect
			aspect-=0.1
	else:
		aspect=1.0
		curr_aspect=aspect

	if aspect<0.599:
		aspect=1.0
	options["setzoom"]=aspect

	if (curr_aspect<aspect) :
		while (curr_aspect<aspect-0.06) :
			curr_aspect+=0.04
			set_window_size(curr_aspect)
			
			yield(get_tree(), "idle_frame")
		curr_aspect=aspect
		set_window_size(curr_aspect)
		yield(get_tree(), "idle_frame")
		
	if (curr_aspect>aspect) :
		while (curr_aspect>aspect+0.01) :
			curr_aspect-=0.01
			set_window_size(curr_aspect)
			yield(get_tree(), "idle_frame")
		curr_aspect=aspect
		set_window_size(curr_aspect)
		yield(get_tree(), "idle_frame")

func set_window_size(size):
	if not has_node("/root/Main"): return
	var m=get_node("/root/Main")
	m.camera.zoom = Vector2(1.0/size, 1.0/size)

	if m.border != null:
		print(m.border.material.get_shader_param("zoom"))
		m.border.material.set_shader_param("zoom", size)
		print(m.border.material.get_shader_param("zoom"))

	if(type_exists("VFFileOps")):
		yield(get_tree(), "idle_frame")
		if fileops.has_method("notifyZoom"):
			fileops.notifyZoom(size);

func get_window_size():
	return window_size

func init_sensitivity():
	return
	if(type_exists("VFFileOps")):
		if(common.options["sensitivity"] == -1):
			common.options["sensitivity"] = fileops.getSensitivity() + common.options["sensitivity_diff"]
		else:
			common.options["sensitivity"] += common.options["sensitivity_diff"]
		common.options["sensitivity"] = int(min(max(common.options["sensitivity"], 10), 30))
		fileops.setSensitivity(common.options["sensitivity"])

func set_sensitivity(sen):
	return
	common.options["sensitivity"] = sen
	common.options["sensitivity"] = int(min(max(common.options["sensitivity"], 10), 30))
	if(type_exists("VFFileOps")):
		fileops.setSensitivity(common.options["sensitivity"])


# logic in finding languages:
# 0. if --language set (game.cfg or cmdline) - if translation available, set it, else:
# 1. check system langauage; if translation available, set it, else:
# 2. check english as default; if translation available, set it, else:
# 3. get the main.po linked language; if translation available, set it, else:
# 4. set the first available translation, else:
# 5. do not set translation at all

# returns (and sets global) priority search list of languages set here and here.
# list is compatible with godot internal locale names.

var langcandidates=[]

var langsavailable=[]

func getSystemLocaleGodotCompatibleArray():
	return langcandidates+langsavailable

func getStrictSystemLocaleGodotCompatibleArray():
	
	if langcandidates.size()>0:
		return langcandidates

	var syslocale=OS.get_locale()
	for l in valid_locales:
		if syslocale.left(l.length())==l:
			# prepend,
			# because for example en_IE has to be before en
			langcandidates.insert(0,l)

	if options["language"]!="":
		langcandidates.insert(0,options["language"]) # prepend
		
	langcandidates.append("en")
	if options["baselanguage"]!="":
		langcandidates.append(options["baselanguage"])
	
	print("Obtained languages (first most important): "+str(langcandidates))
	return langcandidates
	
# New locale system based on gettext
# Loads all .po files from translation_directory
# Workflow goes like this:
# - create .pot file for the project at your own discretion: manual or with babel
# - create .po files from the .pot file for all desired languages
# - put desired .po files in the specified translation_directory directory
# - launch godot with --language loc option, for instance
#     godot --main-pack data.zip --language pl
#
# For the translation to take effect:
# - use Label.text in the scene to set the translation key, it translates automatically
# - in script use tr(traslation key), setting properties in script does not translate automatically

func init_translation():
	
	langcandidates=getStrictSystemLocaleGodotCompatibleArray()
	langsavailable=[]
	# fallback if none oflangcandidates work, we have to search for main.po link
	# and add it to langcandidates later

	var translations_added=[]
	if options["translation_directory"]!="":
		var dir = Directory.new()
		var err = dir.open(options["translation_directory"])
		if err == OK:
			dir.list_dir_begin(true)
			var file_path = dir.get_next()
			while file_path != "":
				if !dir.current_is_dir():
					var file_path_long = options["translation_directory"] + "/" + file_path
					var file = load(file_path_long)
					
					if file is Translation and file_path!="main.po":
						if file.locale in valid_locales:
							langsavailable.append(file.locale)
						#print("Loaded translation "+file.locale+" from file: "+file_path)
						var filename_locale = file_path.trim_suffix(".po")
						if !(filename_locale in valid_locales):
							if filename_locale in locale_fix_map.keys():
								filename_locale = locale_fix_map[filename_locale]
								
						if (filename_locale in valid_locales):
							file.locale = filename_locale
							
						TranslationServer.add_translation(file)
						translations_added.append(file)

				file_path = dir.get_next()
			#print("Loaded translations. actual: "+str(actlang)+" fallback: "+str(fallback))
			var lset=false
			for l in langcandidates:
				for ta in translations_added:
					if ta.locale==l:
						TranslationServer.set_locale(l)
						lset=true
						break
				if lset:
					break
					
			if !lset:
				if translations_added.size()>0:
					TranslationServer.set_locale(translations_added[0].locale)
					lset=true
			if lset:
				print("Chosen Language from "+str(langcandidates)+": "+TranslationServer.get_locale())
			else:
				printerr("ERROR setting language from "+str(langcandidates)+", dir: %s: %d" % [options["translation_directory"], err])
			return
			
		else:
			printerr("ERROR accessing translation directory %s: %d" % [options["translation_directory"], err])

	# this is old code for locale.txt, does not take langcandidates into consideration
	var file = File.new()
	if(file.file_exists(options["translation_file"])):
		if file.open(options["translation_file"], file.READ) != OK:  return

		var translations
		var translation = Translation.new()
		var locale_index = -1
		var default_locale_index = -1
		while(!file.eof_reached()):
			translations = file.get_csv_line(",")
			if(translations.size() > 1):
				if(translations[0] == "id"):
					for i in range(translations.size()):
						if(translations[i] == options["language"]):
							locale_index = i
						elif(translations[i] == "en"):
							default_locale_index = i
					if(locale_index == -1 and default_locale_index > 0):
						locale_index = default_locale_index
					elif(locale_index == -1 and default_locale_index == -1):
						locale_index = 1
				else:
					if(translations[locale_index].length() > 0):
						translation.add_message(translations[0], translations[locale_index].c_unescape())
					else:
						translation.add_message(translations[0], translations[default_locale_index].c_unescape())
		file.close()
		TranslationServer.add_translation(translation)

func load_translated_keys_from_file(translation_file, keys):
	var locale = TranslationServer.get_locale()
	var file = File.new()
	if(file.file_exists(translation_file)):
		file.open(translation_file, file.READ)
		var translations
		var translation = Translation.new()
		var locale_index = -1
		var default_locale_index = -1
		var translated_keys = 0
		while(!file.eof_reached()):
			translations = file.get_csv_line(",")
			if(translations.size() > 1):
				if(translations[0] == "id"):
					for i in range(translations.size()):
						if(translations[i] == locale):
							locale_index = i
						elif(translations[i] == "en"):
							default_locale_index = i
					if(locale_index == -1 and default_locale_index > 0):
						locale_index = default_locale_index
					elif(locale_index == -1 and default_locale_index == -1):
						locale_index = 1
				else:
					for k in keys:
						if(translations[0] == k):
							if(translations[locale_index].length() > 0):
								translation.add_message(translations[0], translations[locale_index].c_unescape())
							else:
								translation.add_message(translations[0], translations[default_locale_index].c_unescape())
							translated_keys += 1
					if(translated_keys == keys.size()):
						break
		file.close()
		TranslationServer.add_translation(translation)

func translate_event(event):
	if event is InputEventScreenTouch:
		return [event.position , event.index]
	return [event.position , 25]
	

func font_replace_on_tree_node_added(node):
	if node.filename != "":
		var scene = load(node.filename)
		for variant in scene._bundled["variants"]:
			if variant is DynamicFont:
				var font : DynamicFont = variant
				var curr_font_name = get_filename_from_path(font.font_data.font_path)
				var font_dir = get_dir_name_from_path(common.options["external_font_path"])
				if(File.new().file_exists(font_dir+curr_font_name)):
					font.font_data = load(font_dir+curr_font_name)
				elif(File.new().file_exists(common.options["external_font_path"])):
					font.font_data = load(common.options["external_font_path"])
				
func get_filename_from_path(p):
	var arr = p.split("/")
	return arr[arr.size()-1]

func get_dir_name_from_path(p):
	return p.substr(0,p.find_last("/"))

func get_game_parameter(param, default="0"):
	print("OBSOLETE get_game_parameter")
	print("PLEASE use GetGameParameter with the same arguments instead")
	print("You will be guided how to use them")
	get_tree().quit()

# Functions for r-t-l arabic texts; exact copy of menu functions in common/common.gd

func is_rtl():
	if not get_parent():
		return false
	if not common.options["language"] in common.options["rtl_languages"].split(","):
		return false
	return true


func rtl_str(st):
	if not is_rtl():
		return st
	st=arabic_transform(st)
	# if former did not encounter arabic letters...
	if not rtl_content:
		return st.strip_edges()
	var cout=""
	var rtlacc=""
	var ltracc=""
	var latinacc=""
	var last=""
	var rtl=true
	var space=" "
	#print("START:")

	for c in st:
		#print("CHAR: "+c+" RTL: "+str(rtl))
		if c!=" ":
			var c2=c
			if c2=="(":
				c2=")"
			elif c2==")":
				c2="("
			rtlacc = c2 + rtlacc
			ltracc = ltracc + c
			var cord=c.ord_at(0)
			if (cord <=127) and (not c in [ ">", "<", "(" , ")" , "." , "," , "?" , "!", ":"]):
				rtl=false
		if c==" " or c=="":
			if (rtl):
				cout = space + rtlacc + space + latinacc + cout
				latinacc=""
			else:
				if latinacc=="":
					latinacc = ltracc
				else:
					latinacc = latinacc + ltracc + space
			rtlacc=""
			ltracc=""
			rtl=true
		#print("CHAR: "+c+" RTL: "+str(rtl))
	if (rtl):
		cout = rtlacc + space + latinacc + cout
		latinacc=""
	else:
		latinacc = latinacc + ltracc 
		cout = latinacc +" "+ cout


	return cout.strip_edges()


  # Determine the form of the current character (:isolated, :initial, :medial,
  # or :final), given the previous character and the next one. In Arabic, all
  # characters can connect with a previous character, but not all letters can
  # connect with the next character (this is determined by
  # CharacterInfo#connects?).

func determine_form(previous_previous_char, previous_char, next_char, next_next_char):

	if charinfos.has(next_char) and charinfos[next_char][diacritic]==true:
		next_char = next_next_char 

	if charinfos.has(previous_char):
		if charinfos[previous_char][diacritic]==true:
			previous_char = previous_previous_char

	if charinfos.has(previous_char) and charinfos.has(next_char):
		if charinfos[previous_char][connects]==true:
			return medial
		else:
			return initial # If the current character does not connect, 
					# its medial form will map to its final form,
					# and its initial form will map to its isolated form.

	elif charinfos.has(previous_char): # The next character is not an arabic character.
		if charinfos[previous_char][connects]==true:
			return final
		else:
			return isolated 

	elif charinfos.has(next_char): # The previous character is not an arabic character.
		return initial # If the current character does not connect, its initial form will map to its isolated form.

	else: # Neither of the surrounding characters are arabic characters.
		return isolated

func arabic_transform(stri):

	var res = ""
	var previous_previous_char
	var previous_char
	var current_char
	var next_char
	var next_next_char

	rtl_content=false
	for chr in stri+"  ": # two more loops after string end.
		previous_previous_char = previous_char
		previous_char = current_char
		current_char = next_char
		next_char = next_next_char
		next_next_char = chr
		if not current_char: continue # skip initial empty values

		if charinfos.has(current_char):
			var form = determine_form(previous_previous_char, previous_char, next_char, next_next_char)
			res += charinfos[current_char][form]
			rtl_content=true
		else:
			res += current_char

	#res.gsub!(/\d+/) {|m| m.reverse}
	if rtl_content:
		return res
	else:
		return stri

func writeFile(fname,fcontent):
	var file=File.new()
	file.open(fname+".tmp",file.WRITE)
	if file.get_error()==0:
		file.store_string(fcontent)
		file.close()
		return Directory.new().rename(fname+".tmp",fname)
	# something wrong
	return 1

func game_version():
	if File.new().file_exists("res://_version.tscn"):
		var n=load("res://_version.tscn").instance()
		return "GAME VERSION: "+n.get_name()
	else:
		return "GAME VERSION: 0 (unset)"

func getLocalizedCsvLanguage():
	return loaded_csv_language
#
# in source catalog fnamepath, should be hierarchy of languages
# and data.dat inside those catalogs
# besides of hierarchy, there should be default data.dat in most common langage
# ex english, polish or latin
#
func loadLocalizedCsvIntoArray(fnamepath, fname, delim, fieldsnum):
	loaded_csv_language=""
	for l in getStrictSystemLocaleGodotCompatibleArray()+[""]:
		var array=loadCsvIntoArray(fnamepath+"/"+l+"/"+fname,delim,fieldsnum)
		if typeof(array)==TYPE_ARRAY:
			loaded_csv_language=l
			return array
	return null
#
# fieldsnum > 0 -> expect exactly fieldsnum fields
# fieldsnum < 0 -> expect fieldsnum or more fields
# fieldsnum == 0 -> expect any number of fields but not 0
#
func loadCsvIntoArray(fname,delim,fieldsnum):
	var file = File.new()
	var outarr=[]
	var ln=0
	print("Trying to load csv from "+fname)
	if(file.file_exists(fname)):
		if file.open(fname, file.READ) != OK:  return
		while(!file.eof_reached()):
			ln+=1
			var line = file.get_csv_line(delim)
			var good=false
			
			if fieldsnum>0:
				if(line.size() ==fieldsnum):
					outarr.append(line)
					good=true
			elif fieldsnum<0:
				if(line.size() >=-fieldsnum):
					outarr.append(line)
					good=true
			else:
				if(line.size() != 0):
					outarr.append(line)
					good=true
				
			if not good:
				if !file.eof_reached():
					print("ERROR: Incorrect number of fields in file "+fname+":"+str(ln)+" (should be "+str(fieldsnum)+")")
		file.close()
		print("Read "+str(outarr.size())+" lines from file "+fname)
		return outarr
	else:
		print("file does not exist ("+fname+")")
	return null

func LoadTexture(imgname):
	var tex
	if(imgname.find("res://") == -1):
		print("Loading image "+imgname)
		var im = Image.new()
		im.load(imgname)
		tex = ImageTexture.new()
		tex.create_from_image(im)
	else:
		tex = ResourceLoader.load(imgname)
	return tex

func LoadOggStream(oggname, looping=false):
	var ogg
	if(oggname.find("res://") == -1):
		print("Loading ogg stream "+oggname)
		var file = File.new()
		var err = file.open(oggname, File.READ)
		if err != OK:
			print("Error opening file %s: %d" % [oggname, err])
			return null
		var bytes = file.get_buffer(file.get_len())
		file.close()
		var aud = AudioStreamOGGVorbis.new()
		aud.loop=false
		aud.data=bytes
		if looping:
			aud.loop = true
		return aud
	else:
		return load(oggname)

func LoadWavStream(wavname, looping=false):
	var wav
	if(wavname.find("res://") == -1):
		print("Loading wav stream "+wavname)
		var file := File.new()
		var err = file.open(wavname, File.READ)
		if err != OK:
			print("Error opening file %s: %d" % [wavname, err])
			return null
		var bytes := file.get_buffer(file.get_len())
		file.close()
		
		var format_begin = 16
		
		var format_length = bytes[format_begin] + (bytes[format_begin + 1] << 8) + (bytes[format_begin + 2] << 16) + (bytes[format_begin + 3] << 24)
		var format = bytes[format_begin + 4] + (bytes[format_begin + 5] << 8)
		var channel_num = bytes[format_begin + 6] + (bytes[format_begin + 7] << 8)
		var sample_rate = bytes[format_begin + 8] + (bytes[format_begin + 9] << 8) + (bytes[format_begin + 10] << 16) + (bytes[format_begin + 11] << 24)
		var data_rate = bytes[format_begin + 12] + (bytes[format_begin + 13] << 8) + (bytes[format_begin + 14] << 16) + (bytes[format_begin + 15] << 24)
		var bits_per_ample_all_channels = bytes[format_begin + 16] + (bytes[format_begin + 17] << 8)
		var bit_depth = bytes[format_begin + 18] + (bytes[format_begin + 19] << 8)
		
		var aud := AudioStreamSample.new()
		
		aud.mix_rate = sample_rate
		if bit_depth == 8:
			aud.format = AudioStreamSample.FORMAT_8_BITS
		elif bit_depth == 16:
			aud.format = AudioStreamSample.FORMAT_16_BITS
		aud.stereo = channel_num == 2
		aud.loop_mode = AudioStreamSample.LOOP_DISABLED
		
		var chunk_begin = format_begin + 4 + format_length
		while chunk_begin < bytes.size():
			var chunk_length = bytes[chunk_begin + 4] + (bytes[chunk_begin + 5] << 8) + (bytes[chunk_begin + 6] << 16) + (bytes[chunk_begin + 7] << 24)
			var chunk_name = char(bytes[chunk_begin]) + char(bytes[chunk_begin + 1]) + char(bytes[chunk_begin + 2]) + char(bytes[chunk_begin + 3])
			printt(chunk_begin, chunk_name, chunk_length)
			if chunk_name == "data":
				var data_begin = chunk_begin + 8
				aud.data=bytes.subarray(data_begin, data_begin + chunk_length - 1)
			chunk_begin += 8 + chunk_length
		
		if looping:
			aud.loop_mode = AudioStreamSample.LOOP_FORWARD
			aud.loop_begin = 0
			aud.loop_end = aud.data.size() / (2 if aud.stereo else 1) / (1 if aud.format == AudioStreamSample.FORMAT_8_BITS else 2)
		return aud
	else:
		return load(wavname)


# first use this to set local name
func SetLocalSettingsFile(path):
	file_to_load_local_config=path

func MakeLocalSettingsFileDir(filepath):
	var path=filepath
	if not Directory.new().dir_exists(filepath.get_base_dir()):
		if Directory.new().make_dir_recursive(filepath.get_base_dir())!=OK:
			print("CANNOT mkdir "+filepath.get_base_dir())
			get_tree().quit()

#then loads game settings cached
func LoadLocalGameSettings():
	for o in options:
		print("CONFIG: "+o+"="+str(options[o]))
	SetLocalSettingsFile(options["menu_home"])
	var ls=loadLocalSettingsCached(file_to_load_local_config,true)
	if ls!=null:
		for key2 in ls.get_section_keys("Game_Local"):
			options[key2]=ls.get_value("Game_Local",key2,null)
			print("CONFIGLOCAL: "+key2+"="+str(options[key2]))

# returns null when some error or no key present
# always cached
func GetGameParameter(param,default):
	if options.has(param):
		return options[param]
	else:
		print("No key "+str(param)+" in options; getting default value: "+str(default))
		return default
# updates game calibration from file path with dict values
# self-operating function, single call needed
# always cached and reloads cache
# self-operating function, single call needed (not neede file opening or closing)
# change of Global Settings is forbidden
func UpdateLocalGameSettings(dict, cached=false):
	print("UPDATE SETTINGS")
	var cf=null
	if file_to_load_local_config=="":
		print("Local config file name not set! Please use SetLocalSettingsFile(path)")
		return
		
	print("Saving local settings to: "+file_to_load_local_config)
	print("Settings: "+str(dict))
	loadLocalSettingsCached(file_to_load_local_config)
	
	if local_config_file != null:
		for entr in dict:
			local_config_file.set_value("Game_Local", entr, dict[entr])
		MakeLocalSettingsFileDir(file_to_load_local_config)
		local_config_file.save(file_to_load_local_config)
		print("saved")
		#force reloading
		loadLocalSettingsCached(file_to_load_local_config,true)
		return true
	print("failed")
		
	return false


#loads game settings
# private
func loadLocalSettingsCached(var path, var reload=false):
	if not reload and local_config_file!= null:
		return local_config_file
	if str(path)=="": return null

	local_config_file = ConfigFile.new() 
	print("Opening file: "+path)
	

	var err = local_config_file.load(path)
	print("ERR = "+str(err))
	if err==OK:
		return local_config_file
	return null

func npos(v):
	return v*base_viewport_size

func getZoom():
	return options["setzoom"]

func translate_event_position(position):
	var vps = base_viewport_size
	var zoom
	if has_node("/root/Main"):
		zoom = get_node("/root/Main").camera.zoom
	else:
		zoom = Vector2(1,1)

	position *= zoom
	position -= true_base_viewport_size * (zoom - Vector2(1,1)) / 2.0 + (true_base_viewport_size-base_viewport_size)/2
	if position.x>=0 and position.x<vps.x and position.y>=0 and position.y<vps.y:
		return position
	return Vector2()

func set_game_orientation(dir):
	get_node("/root/Main").set_game_orientation(dir)

func set_pause_version(num):
	get_node("/root/Main").set_pause_version(num)

func enablePauseProcessing(b=true):
	get_node("/root/Main").enablePauseProcessing(b)

func get_game_rotation():
	return get_node("/root/Main").get_game_rotation()

func get_display_scale():
	return get_node("/root/Main").get_display_scale()

func get_fixed_scale():
	return get_node("/root/Main").get_fixed_scale()
