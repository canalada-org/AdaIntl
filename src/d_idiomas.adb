--------------------------------------------------------------------------------------
-- AdaIntl: Internationalization library for Ada95 made in Ada95
-- Copyright (C) 2006  Andres_age
--
-- AdaIntl is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
-- or look here: http://www.gnu.org/licenses/lgpl.html
--
-- You can contact the author at this e-mail: andres.age*AT*gmail*DOT*com
--------------------------------------------------------------------------------------


package body D_Idiomas is


   function Language_Name (
         L : T_Language ) 
     return String is 
   begin

      case L is
         when Aa=>
            return  "Afar";
         when Ab=>
            return  "Abkhazian";
         when Ae=>
            return "Avestan";
         when Af=>
            return "Afrikaans";
         when Ak=>
            return "Akan";
         when Am=>
            return "Amharic";
         when Ar=>
            return "Arabic";
         when As=>
            return "Assamese";
         when Av=>
            return "Avaric";
         when Ay=>
            return "Aymara";
         when Az=>
            return "Azerbaijani";
         when Ba=>
            return "Bashkir";
         when Bm=>
            return "Bambara";
         when Be=>
            return "Belarusian";
         when Bg=>
            return "Bulgarian";
         when Bh=>
            return "Bihari";
         when Bi=>
            return "Bislama";
         when Bn=>
            return "Bengali";
         when Bo=>
            return "Tibetan";
         when Br=>
            return "Breton";
         when Bs=>
            return "Bosnian";
         when Ca=>
            return "Catalan";
         when Ce=>
            return "Chechen";
         when Ch=>
            return "Chamorro";
         when Co=>
            return "Corsican";
         when Cr=>
            return "Cree";
         when Cs=>
            return "Czech";
         when Cv=>
            return "Chuvash";
         when Cy=>
            return "Welsh";
         when Da=>
            return "Danish";
         when De=>
            return "German";
         when Dv=>
            return "Divehi";
         when Dz=>
            return "Dzongkha";
         when Ee=>
            return "Ewe";
         when El=>
            return "Greek";
         when En=>
            return "English";
         when Eo=>
            return "Esperanto";
         when Es=>
            return "Spanish";
         when Et=>
            return "Estonian";
         when Eu=>
            return "Basque";
         when Fa=>
            return "Persian";
         when Fi=>
            return "Finnish";
         when Ff=>
            return "Fulah";
         when Fj=>
            return "Fijian";
         when Fo=>
            return "Faroese";
         when Fr=>
            return "French";
         when Ga=>
            return "Irish";
         when Gd=>
            return "Scottish Gaelic";
         when Gl=>
            return "Galician";
         when Gn=>
            return "Guarani";
         when Gu=>
            return "Gujarati";
         when Gv=>
            return "Manx";
         when Ha=>
            return "Hausa";
         when He=>
            return "Hebre";
         when Hi=>
            return "Hindi";
         when Ho=>
            return "Hiri Motu";
         when Hr=>
            return "Croatian";
         when Ht=>
            return "Haitian";
         when Hu=>
            return "Hungarian";
         when Hy=>
            return "Armenian";
         when Hz=>
            return "Herero";
         when Id=>
            return "Indonesian";
         when Ie=>
            return "Interlingue";
         when Ig=>
            return "Igbo";
         when Ik=>
            return "Inupiaq";
         when Ii=>
            return "Sichuan Yi";
         when Isl=>
            return "Icelandic";
         when Io=>
            return "Ido";
         when It=>
            return "Italian";
         when Iu=>
            return "Inuktitut";
         when Ja=>
            return "Japanese";
         when Jv=>
            return "Javanese";
         when Ka=>
            return "Georgian";
         when Kg=>
            return "Kongo";
         when Ki=>
            return "Gikuyu";
         when Kj=>
            return "Kwanyama";
         when Kk=>
            return "Kazakh";
         when Kl=>
            return "Greenlandic";
         when Km=>
            return "Khmer";
         when Kn=>
            return "Kannada";
         when Ko=>
            return "Korean";
         when Kr=>
            return "Kanuri";
         when Ks=>
            return "Kashmiri";
         when Ku=>
            return "Kurdish";
         when Kv=>
            return "Komi";
         when Kw=>
            return "Cornish";
         when Ky=>
            return "Kirghiz";
         when La=>
            return "Latin";
         when Lb=>
            return "Letzerburgesch";
         when Lg=>
            return "Ganda";
         when Li=>
            return "Limburgish";
         when Ln=>
            return "Lingala";
         when Lo=>
            return "Lao";
         when Lt=>
            return "Lithuanian";
         when Lu=>
            return "Luba-Katanga";
         when Lv=>
            return "Latvian";
         when Mg=>
            return "Malagasy";
         when Mh=>
            return "Marshallese";
         when Mi=>
            return "Maori";
         when Mk=>
            return "Macedonian";
         when Ml=>
            return "Malayalm";
         when Mn=>
            return "Mongolian";
         when Mo=>
            return "Moldavian";
         when Mr=>
            return "Marathi";
         when Ms=>
            return "Malay";
         when Mt=>
            return "Maltese";
         when My=>
            return "Burmese";
         when Na=>
            return "Nauru";
         when Nd=>
            return "Ndebele";
         when Ne=>
            return "Nepali";
         when Ng=>
            return "Ndonga";
         when Nl=>
            return "Dutch";
         when No=>
            return "Norwegian";
         when Nv=>
            return "Navaho";
         when Ny=>
            return "Chichewa";
         when Oc=>
            return "Occitan";
         when Oj=>
            return "Ojibwa";
         when Om=>
            return "Oromo";
         when Ori=>
            return "Oriya";
         when Os=>
            return "Ossetic";
         when Pa=>
            return "Panjabi";
         when Pi=>
            return "Pali";
         when Pl=>
            return "Polish";
         when Ps=>
            return "Pushto";
         when Pt=>
            return "Portuguese";
         when Qu=>
            return "Quechua";
         when Rn=>
            return "Rundi";
         when Ro=>
            return "Romanian";
         when Ru=>
            return "Russian";
         when Sa=>
            return "Sanskrit";
         when Sc=>
            return "Sardinian";
         when Sd=>
            return "Sindhi";
         when Se=>
            return "Northern Sami";
         when Sg=>
            return "Sango";
         when Si=>
            return "Sinhala";
         when Sk=>
            return "Slovak";
         when Sl=>
            return "Slovenian";
         when Sm=>
            return "Samoan";
         when Sn=>
            return "Shona";
         when So=>
            return "Somali";
         when Sq=>
            return "Albanian";
         when Sr=>
            return "Serbian";
         when Ss=>
            return "Swati";
         when St=>
            return "Southern Sotho";
         when Su=>
            return "Sundanese";
         when Sv=>
            return "Swedih";
         when Sw=>
            return "Swahili";
         when Ta=>
            return "Tamil";
         when Te=>
            return "Telugu";
         when Tg=>
            return "Tajik";
         when Th=>
            return "Thai";
         when Ti=>
            return "Tigrinya";
         when Tk=>
            return "Turkmen";
         when Tl=>
            return "Tagalog";
         when To=>
            return "Tonga";
         when Tr=>
            return "Turkish";
         when Ts=>
            return "Tsonga";
         when Tt=>
            return "Tatar";
         when Tw=>
            return "Twi";
         when Ty=>
            return "Tahitian";
         when Ug=>
            return "Uyghur";
         when Uk=>
            return "Ukrainian";
         when Ur=>
            return "Urdu";
         when Uz=>
            return "Uzbek";
         when Ve=>
            return "Venda";
         when Vi=>
            return "Vietnamese";
         when Vo=>
            return "Volapuk";
         when Wa=>
            return "Walloon";
         when Wo=>
            return "Wolof";
         when Xh=>
            return "Shosa";
         when Yi=>
            return "Yiddish";
         when Yo=>
            return "Yoruba";
         when Za=>
            return "Zhuang";
         when Zh=>
            return "Chinese";
         when Zu=>
            return "Zulu";
         when Nul =>
            return "Null";
      end case;
   end Language_Name;

end D_Idiomas;
