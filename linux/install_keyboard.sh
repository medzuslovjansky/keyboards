#!/bin/bash
echo "|..... 0%| Upgrading the evdev.lst file"
sed -ie "/^! layout/a\  isv             Interslavic" /usr/share/X11/xkb/rules/evdev.lst
sed -ie "/^! variant/a\  cyrillic        isv: Interslavic (Cyrillic)" /usr/share/X11/xkb/rules/evdev.lst
sed -ie "/^! variant/a\  latin           isv: Interslavic (Latin)" /usr/share/X11/xkb/rules/evdev.lst

echo "|#.... 20%| Upgrading the evdev.xml file"
cat >> /usr/share/X11/xkb/rules/evdev.xml << EOL
    <layout>
      <configItem>
        <name>isv</name>
        <!-- Keyboard indicator for Interslavic layouts -->
        <shortDescription>isv</shortDescription>
        <description>Interslavic</description>
        <languageList>
          <iso639Id>art</iso639Id>
        </languageList>
      </configItem>
      <variantList>
        <variant>
          <configItem>
            <name>latin</name>
            <description>Interslavic (Latin)</description>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <name>cyrillic</name>
            <description>Interslavic (Cyrillic)</description>
          </configItem>
        </variant>
      </variantList>
    </layout>
EOL

echo "|###.. 60%| Writing the file of symbols"
tail -n +44 "$0" > /usr/share/X11/xkb/symbols/isv
chown root:root /usr/share/X11/xkb/symbols/isv
chmod 0644 /usr/share/X11/xkb/symbols/isv

echo "|##### 100%| Done! Reboot your computer."
exit 0
#####
// Keyboard layouts for Interslavic Language.

default partial alphanumeric_keys
xkb_symbols "latin" {

    name[Group1]= "Interslavic (Latin)";

    key <TLDE> { [ U0060, U007e, U00fc, U00dc ] }; // ` ~ ü Ü
    key <AE01> { [ U0031, U0021, U00b9, U00f7 ] }; // 1 ! ¹ ÷
    key <AE02> { [ U0032, U0040, U00b2, U00bd ] }; // 2 @ ² ½
    key <AE03> { [ U0033, U0023, U00b3, U2153 ] }; // 3 # ³ ⅓
    key <AE04> { [ U0034, U0024, U2074, U00bc ] }; // 4 $ ⁴ ¼
    key <AE05> { [ U0035, U0025, U2030, Ufb01 ] }; // 5 % ‰ ﬁ
    key <AE06> { [ U0036, U005e, U00b6, U02c6 ] }; // 6 ^ ¶ ˆ
    key <AE07> { [ U0037, U0026, U2191, U00bf ] }; // 7 & ↑ ¿
    key <AE08> { [ U0038, U002a, U2193, U2022 ] }; // 8 * ↓ •
    key <AE09> { [ U0039, U0028, U2190, U2248 ] }; // 9 ( ← ≈
    key <AE10> { [ U002d, U005f, U2014, U2013 ] }; // - _ — –
    key <AE12> { [ U003d, U002b, U2260, U00b1 ] }; // = + ≠ ±

    key <AD01> { [ U0071, U0051, U015b, U015a ] }; // q Q ś Ś
    key <AD02> { [ U0077, U0057, U0119, U0118 ] }; // w W ę Ę
    key <AD03> { [ U0065, U0045, U011b, U011a ] }; // e E ě Ě
    key <AD04> { [ U0072, U0052, U0155, U0154 ] }; // r R ŕ Ŕ
    key <AD05> { [ U0074, U0054, U0165, U0164 ] }; // t T ť Ť
    key <AD06> { [ U0079, U0059, U00f9, U00d9 ] }; // y Y ù Ù
    key <AD07> { [ U0075, U0055, U0173, U0172 ] }; // u U ų Ų
    key <AD08> { [ U0069, U0049, U0105, U0104 ] }; // i I ą Ą
    key <AD09> { [ U006f, U004f, U022f, U022e ] }; // o O ȯ Ȯ
    key <AD10> { [ U0070, U0050, U00f2, U00d2 ] }; // p P ò Ò
    key <AD11> { [ U005b, U007b, U0117, U0116 ] }; // [ { ė Ė
    key <AD12> { [ U005d, U007d, U0159, U0158 ] }; // ] } ř Ř
    key <BKSL> { [ U005c, U007c, U1e59, U1e58 ] }; // \ | ṙ Ṙ
    key <AC01> { [ U0061, U0041, U00e5, U00c5 ] }; // a A å Å
    key <AC02> { [ U0073, U0053, U0161, U0160 ] }; // s S š Š
    key <AC03> { [ U0064, U0044, U010f, U010e ] }; // d D ď Ď
    key <AC04> { [ U0066, U0046, U0111, U0110 ] }; // f F đ Đ
    key <AC05> { [ U0067, U0047, U011f, U011e ] }; // g G ğ Ğ
    key <AC06> { [ U0068, U0048, U1e25, U1e24 ] }; // h H ḥ Ḥ
    key <AC07> { [ U006a, U004a, U016f, U016e ] }; // j J ů Ů
    key <AC08> { [ U006b, U004b, U0142, U0141 ] }; // k K ł Ł
    key <AC09> { [ U006c, U004c, U013a, U0139 ] }; // l L ĺ Ĺ
    key <AC10> { [ U003b, U003a, U013e, U013d ] }; // ; : ľ Ľ
    key <AC11> { [ U0027, U0022, U0103, U0102 ] }; // ' " ă Ă

    key <AB01> { [ U007a, U005a, U017e, U017d ] }; // z Z ž Ž
    key <AB02> { [ U0078, U0058, U017a, U0179 ] }; // x X ź Ź
    key <AB03> { [ U0063, U0043, U010d, U010c ] }; // c C č Č
    key <AB04> { [ U0076, U0056, U0107, U0106 ] }; // v V ć Ć
    key <AB05> { [ U0062, U0042, U0148, U0147 ] }; // b B ň Ň
    key <AB06> { [ U006e, U004e, U0144, U0143 ] }; // n N ń Ń
    key <AB07> { [ U006d, U004d, U017c, U017b ] }; // m M ż Ż
    key <AB08> { [ U002c, U003c, U0140, U013f ] }; // , < ŀ Ŀ
    key <AB09> { [ U002e, U003e, U00e8, U00c8 ] }; // . > è È
    key <AB10> { [ U002f, U003f, U0131 ] }; // / ? ı

    key <LSGT> { [ U002f, U007c ] }; // / |

    include "level3(ralt_switch)"
};

partial alphanumeric_keys
xkb_symbols "cyrillic" {

    name[Group1]= "Interslavic (Cyrillic)";

    key <TLDE> { [ U0060, U007e, U2019, U2248 ] }; // ` ~ ’ ≈
    key <AE01> { [ U0031, U0021, U00b9, U00f7 ] }; // 1 ! ¹ ÷
    key <AE02> { [ U0032, U0022, U00b2, U00bd ] }; // 2 " ² ½
    key <AE03> { [ U0033, U2116, U00b3, U2153 ] }; // 3 № ³ ⅓
    key <AE04> { [ U0034, U003b, U2074, U00bc ] }; // 4 ; ⁴ ¼
    key <AE05> { [ U0035, U0025, U2030, Ufb01 ] }; // 5 % ‰ ﬁ
    key <AE06> { [ U0036, U003a, U00b6, U02c6 ] }; // 6 : ¶ ˆ
    key <AE07> { [ U0037, U003f, U2191, U00bf ] }; // 7 ? ↑ ¿
    key <AE08> { [ U0038, U002a, U2193, U2022 ] }; // 8 * ↓ •
    key <AE09> { [ U0039, U0028, U2190, U2248 ] }; // 9 ( ← ≈
    key <AE10> { [ U002d, U005f, U2014, U2013 ] }; // - _ — –
    key <AE12> { [ U003d, U002b, U2260, U00b1 ] }; // = + ≠ ±

    key <AD01> { [ U0439, U0419, U0458, U0408 ] }; // й Й ј Ј
    key <AD02> { [ U0446, U0426, U03b1, U0391 ] }; // ц Ц α Α
    key <AD03> { [ U0443, U0423, U046b, U046a ] }; // у У ѫ Ѫ
    key <AD04> { [ U043a, U041a, U045c, U040c ] }; // к К ќ Ќ
    key <AD05> { [ U0435, U0415, U0463, U0462 ] }; // е Е ѣ Ѣ
    key <AD06> { [ U043d, U041d, U045a, U040a ] }; // н Н њ Њ
    key <AD07> { [ U0433, U0413, U0491, U0490 ] }; // г Г ґ Ґ
    key <AD08> { [ U0448, U0428, U0453, U0403 ] }; // ш Ш ѓ Ѓ
    key <AD09> { [ U0449, U0429, U03b3, U0393 ] }; // щ Щ γ Γ
    key <AD10> { [ U0437, U0417, U0455, U0405 ] }; // з З ѕ Ѕ
    key <AD11> { [ U0445, U0425, U00d7, U2022 ] }; // х Х × •
    key <AD12> { [ U044a, U042a, U0457, U0407 ] }; // ъ Ъ ї Ї
    key <BKSL> { [ U005c, U007c ] }; // \ |

    key <AC01> { [ U0444, U0424, U0473, U0472 ] }; // ф Ф ѳ Ѳ
    key <AC02> { [ U044b, U042b, U0456, U0406 ] }; // ы Ы і І
    key <AC03> { [ U0432, U0412, U045e, U040e ] }; // в В ў Ў
    key <AC04> { [ U0430, U0410, U0467, U0466 ] }; // а А ѧ Ѧ
    key <AC05> { [ U043f, U041f, U04d1, U04d0 ] }; // п П ӑ Ӑ
    key <AC06> { [ U0440, U0420, U0461, U0460 ] }; // р Р ѡ Ѡ
    key <AC07> { [ U043e, U041e, U0451, U0401 ] }; // о О ё Ё
    key <AC08> { [ U043b, U041b, U0459, U0409 ] }; // л Л љ Љ
    key <AC09> { [ U0434, U0414, U0452, U0402 ] }; // д Д ђ Ђ
    key <AC10> { [ U0436, U0416, U045b, U040b ] }; // ж Ж ћ Ћ
    key <AC11> { [ U044d, U042d, U0454, U0404 ] }; // э Э є Є

    key <AB01> { [ U044f, U042f, U0469, U0468 ] }; // я Я ѩ Ѩ
    key <AB02> { [ U0447, U0427, U045f, U040f ] }; // ч Ч џ Џ
    key <AB03> { [ U0441, U0421, U03c3, U03a3 ] }; // с С σ Σ
    key <AB04> { [ U043c, U041c, U03bc, U039c ] }; // м М μ Μ
    key <AB05> { [ U0438, U0418, U045d, U040d ] }; // и И ѝ Ѝ
    key <AB06> { [ U0442, U0422, U03c4, U03a4 ] }; // т Т τ Τ
    key <AB07> { [ U044c, U042c, U0475, U0474 ] }; // ь Ь ѵ Ѵ
    key <AB08> { [ U0431, U0411, U03b2, U0392 ] }; // б Б β Β
    key <AB09> { [ U044e, U042e, U046d, U046c ] }; // ю Ю ѭ Ѭ
    key <AB10> { [ U002e, U002c, U2026, U003f ] }; // . , … ?

    key <LSGT> { [ U002f, U007c ] };

    include "level3(ralt_switch)"
};
