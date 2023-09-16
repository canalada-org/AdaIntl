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


package D_Idiomas is

   type T_Language is 
         (Aa,  -- Afar
          Ab,  -- Abkhazian
          Ae,  -- Avestan
          Af,  -- Afrikaans
          Ak,  -- Akan
          Am,  -- Amharic
          Ar,  -- Arabic
          As,  -- Assamese
          Av,  -- Avaric
          Ay,  -- Aymara
          Az,  -- Azerbaijani
          Ba,  -- Bashkir
          Bm,  -- Bambara
          Be,  -- Belarusian
          Bg,  -- Bulgarian
          Bh,  -- Bihari
          Bi,  -- Bislama
          Bn,  -- Bengali
          Bo,  -- Tibetan
          Br,  -- Breton
          Bs,  -- Bosnian
          Ca,  -- Catalan
          Ce,  -- Chechen 
          Ch,  -- Chamorro
          Co,  -- Corsican
          Cr,  -- Cree
          Cs,  -- Czech 
          Cv,  -- Chuvash
          Cy,  -- Welsh
          Da,  -- Danish
          De,  -- German
          Dv,  -- Divehi / Maldivian
          Dz,  -- Dzongkha
          Ee,  -- Ewe
          El,  -- Greek
          En,  -- English
          Eo,  -- Esperanto
          Es,  -- Spanish
          Et,  -- Estonian
          Eu,  -- Basque
          Fa,  -- Persian
          Fi,  -- Finnish
          Ff,  -- Fulah
          Fj,  -- Fijian
          Fo,  -- Faroese
          Fr,  -- French
          Ga,  -- Irish
          Gd,  -- Scottish Gaelic
          Gl,  -- Galician
          Gn,  -- Guarani
          Gu,  -- Gujarati
          Gv,  -- Manx
          Ha,  -- Hausa
          He,  -- Hebre
          Hi,  -- Hindi
          Ho,  -- Hiri Motu
          Hr,  -- Croatian
          Ht,  -- Haitian 
          Hu,  -- Hungarian
          Hy,  -- Armenian
          Hz,  -- Herero
          Id,  -- Indonesian
          Ie,  -- Interlingue
          Ig,  -- Igbo
          Ik,  -- Inupiaq
          Ii,  -- Sichuan Yi
          Isl, -- Icelandic (cannot use Is, Ada reserved word)
          Io,  -- Ido
          It,  -- Italian
          Iu,  -- Inuktitut
          Ja,  -- Japanese
          Jv,  -- Javanese
          Ka,  -- Georgian
          Kg,  -- Kongo
          Ki,  -- Gikuyu
          Kj,  -- Kwanyama
          Kk,  -- Kazakh
          Kl,  -- Greenlandic
          Km,  -- Khmer
          Kn,  -- Kannada
          Ko,  -- Korean
          Kr,  -- Kanuri
          Ks,  -- Kashmiri
          Ku,  -- Kurdish
          Kv,  -- Komi
          Kw,  -- Cornish
          Ky,  -- Kirghiz
          La,  -- Latin
          Lb,  -- Letzerburgesch
          Lg,  -- Ganda
          Li,  -- Limburgish
          Ln,  -- Lingala
          Lo,  -- Lao
          Lt,  -- Lithuanian
          Lu,  -- Luba-Katanga
          Lv,  -- Latvian
          Mg,  -- Malagasy
          Mh,  -- Marshallese
          Mi,  -- Maori
          Mk,  -- Macedonian
          Ml,  -- Malayalm
          Mn,  -- Mongolian
          Mo,  -- Moldavian
          Mr,  -- Marathi
          Ms,  -- Malay
          Mt,  -- Maltese
          My,  -- Burmese
          Na,  -- Nauru
          Nd,  -- Ndebele
          Ne,  -- Nepali
          Ng,  -- Ndonga
          Nl,  -- Dutch
          No,  -- Norwegian 
          Nv,  -- Navaho
          Ny,  -- Chichewa / Chewa
          Oc,  -- Occitan
          Oj,  -- Ojibwa
          Om,  -- Oromo
          Ori, -- Oriya (cannot use Or, Ada reserved word)
          Os,  -- Ossetic
          Pa,  -- Panjabi
          Pi,  -- Pali
          Pl,  -- Polish
          Ps,  -- Pushto
          Pt,  -- Portuguese
          Qu,  -- Quechua
          Rn,  -- Rundi
          Ro,  -- Romanian
          Ru,  -- Russian
          Sa,  -- Sanskrit
          Sc,  -- Sardinian
          Sd,  -- Sindhi
          Se,  -- Northern Sami
          Sg,  -- Sango
          Si,  -- Sinhala
          Sk,  -- Slovak
          Sl,  -- Slovenian
          Sm,  -- Samoan
          Sn,  -- Shona
          So,  -- Somali
          Sq,  -- Albanian
          Sr,  -- Serbian
          Ss,  -- Swati, 
          St,  -- Southern Sotho
          Su,  -- Sundanese
          Sv,  -- Swedih
          Sw,  -- Swahili
          Ta,  -- Tamil
          Te,  -- Telugu
          Tg,  -- Tajik
          Th,  -- Thai
          Ti,  -- Tigrinya
          Tk,  -- Turkmen
          Tl,  -- Tagalog
          To,  -- Tonga
          Tr,  -- Turkish
          Ts,  -- Tsonga
          Tt,  -- Tatar
          Tw,  -- Twi
          Ty,  -- Tahitian
          Ug,  -- Uyghur
          Uk,  -- Ukrainian
          Ur,  -- Urdu
          Uz,  -- Uzbek
          Ve,  -- Venda
          Vi,  -- Vietnamese
          Vo,  -- Volapuk
          Wa,  -- Walloon
          Wo,  -- Wolof
          Xh,  -- Shosa
          Yi,  -- Yiddish
          Yo,  -- Yoruba
          Za,  -- Zhuang
          Zh,  -- Chinese
          Zu,  -- Zulu
          Nul  -- Null <- It MUST be the last one
); 

   function Language_Name (
         L : T_Language ) 
     return String; 

end D_Idiomas;
