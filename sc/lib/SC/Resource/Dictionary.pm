package SC::Resource::Dictionary;

our $VERSION = '3.0';

use strict;
use warnings;

sub get_keywords {
    return (
        FACILITY_TYPE		=> 'Type',
        FACILITY_ID			=> 'ID',
        FACILITY_NAME		=> 'Name',
        DIST				=> 'Ep. Distance (km)',
        LATITUDE			=> 'Latitude',
        LONGITUDE			=> 'Longitude',
        PGA					=> 'PGA (%g)',
        PGV					=> 'PGV (cm/s)',
        PSA03				=> 'PSA .3s (%g)',
        PSA10				=> 'PSA 1s (%g)',
        PSA30				=> 'PSA 3s (%g)',
        STDPGA				=> 'STDV PGA ln(%g)',
        SVEL				=> 'Vs30 (m/s)',
        MMI					=> 'MMI',
        DAMAGE_LEVEL					=> 'Inspection Priority',
        RED					=> 'High',
        ORANGE					=> 'Moderate High',
        YELLOW					=> 'Moderate',
        GREEN					=> 'Low',
        GREY					=> 'Below Threshold',
        'SL1_OBE'			=> 'SL1/OBE (PGA)',
        'SL2_SSE'			=> 'SL2/SSE (PGA)',
	   'ATTR_SL2_SSE'		=> 'Design Value',
        'RG1166'			=> 'RG 1.166 App. A',
        aliceblue            => '#EFF7FF',
        antiquewhite         => '#F9EAD7',
        antiquewhite1        => '#FFEEDB',
        antiquewhite2        => '#EDDFCC',
        antiquewhite3        => '#CDBFB0',
        antiquewhite4        => '#8A8278',
        aqua                 => '#00FFFF',
        aquamarine           => '#7FFFD4',
        aquamarine1          => '#7FFFD4',
        aquamarine2          => '#76EDC5',
        aquamarine3          => '#66CDAA',
        aquamarine4          => '#458A74',
        azure                => '#EFFFFF',
        azure1               => '#EFFFFF',
        azure2               => '#E0EDED',
        azure3               => '#C0CDCD',
        azure4               => '#828A8A',
        beige                => '#F4F4DC',
        bisque               => '#FFE4C3',
        bisque1              => '#FFE4C3',
        bisque2              => '#EDD5B6',
        bisque3              => '#CDB69E',
        bisque4              => '#8A7D6B',
        black                => '#000000',
        blanchedalmond       => '#FFEACD',
        blue                 => '#0000FF',
        blue1                => '#0000FF',
        blue2                => '#0000ED',
        blue3                => '#0000CD',
        blue4                => '#00008A',
        blueviolet           => '#9F5E9F',
        brass                => '#B4A642',
        brightgold           => '#D9D918',
        bronze               => '#8B7852',
        bronzeii             => '#A67D3D',
        brown                => '#A52929',
        brown1               => '#FF4040',
        brown2               => '#ED3B3B',
        brown3               => '#CD3333',
        brown4               => '#8A2222',
        burlywood            => '#DEB786',
        burlywood1           => '#FFD39B',
        burlywood2           => '#EDC490',
        burlywood3           => '#CDAA7D',
        burlywood4           => '#8A7354',
        cadetblue            => '#5E9EA0',
        cadetblue1           => '#98F4FF',
        cadetblue2           => '#8DE5ED',
        cadetblue3           => '#7AC4CD',
        cadetblue4           => '#52858A',
        chartreuse           => '#7FFF00',
        chartreuse1          => '#7FFF00',
        chartreuse2          => '#76ED00',
        chartreuse3          => '#66CD00',
        chartreuse4          => '#458A00',
        chocolate            => '#D2691D',
        chocolate1           => '#FF7F23',
        chocolate2           => '#ED7620',
        chocolate3           => '#CD661C',
        chocolate4           => '#8A4512',
        coolcopper           => '#D98618',
        coral                => '#FF7F4F',
        coral1               => '#FF7255',
        coral2               => '#ED6A4F',
        coral3               => '#CD5A45',
        coral4               => '#8A3E2E',
        cornflowerblue       => '#6394EC',
        cornsilk             => '#FFF7DC',
        cornsilk1            => '#FFF7DC',
        cornsilk2            => '#EDE7CD',
        cornsilk3            => '#CDC7B1',
        cornsilk4            => '#8A8778',
        crimson              => '#DC143C',
        cyan                 => '#00FFFF',
        cyan1                => '#00FFFF',
        cyan2                => '#00EDED',
        cyan3                => '#00CDCD',
        cyan4                => '#008A8A',
        darkblue             => '#00008A',
        darkcyan             => '#008A8A',
        darkgoldenrod        => '#B7850B',
        darkgoldenrod1       => '#FFB80E',
        darkgoldenrod2       => '#EDAD0D',
        darkgoldenrod3       => '#CD940C',
        darkgoldenrod4       => '#8A6507',
        darkgray             => '#A9A9A9',
        darkgreen            => '#006300',
        darkgrey             => '#A9A9A9',
        darkkhaki            => '#BCB66B',
        darkmagenta          => '#8A008A',
        darkolivegreen       => '#546B2E',
        darkolivegreen1      => '#CAFF70',
        darkolivegreen2      => '#BBED68',
        darkolivegreen3      => '#A2CD59',
        darkolivegreen4      => '#6E8A3D',
        darkorange           => '#FF8B00',
        darkorange1          => '#FF7F00',
        darkorange2          => '#ED7600',
        darkorange3          => '#CD6600',
        darkorange4          => '#8A4500',
        darkorchid           => '#9931CC',
        darkorchid1          => '#BE3EFF',
        darkorchid2          => '#B13AED',
        darkorchid3          => '#9A31CD',
        darkorchid4          => '#68218A',
        darkred              => '#8A0000',
        darksalmon           => '#E8957A',
        darkseagreen         => '#8EBB8E',
        darkseagreen1        => '#C0FFC0',
        darkseagreen2        => '#B4EDB4',
        darkseagreen3        => '#9BCD9B',
        darkseagreen4        => '#698A69',
        darkslateblue        => '#483D8A',
        darkslategray        => '#2E4E4E',
        darkslategray1       => '#97FFFF',
        darkslategray2       => '#8CEDED',
        darkslategray3       => '#79CDCD',
        darkslategray4       => '#518A8A',
        darkslategrey        => '#2E4E4E',
        darkturquoise        => '#00CED1',
        darkviolet           => '#9300D3',
        darkwood             => '#845D42',
        deeppink             => '#FF1492',
        deeppink1            => '#FF1492',
        deeppink2            => '#ED1188',
        deeppink3            => '#CD1076',
        deeppink4            => '#8A0A4F',
        deepskyblue          => '#00BEFF',
        deepskyblue1         => '#00BEFF',
        deepskyblue2         => '#00B1ED',
        deepskyblue3         => '#009ACD',
        deepskyblue4         => '#00688A',
        dimgray              => '#696969',
        dimgrey              => '#696969',
        dodgerblue           => '#1D8FFF',
        dodgerblue1          => '#1D8FFF',
        dodgerblue2          => '#1B85ED',
        dodgerblue3          => '#1774CD',
        dodgerblue4          => '#104D8A',
        dustyrose            => '#846262',
        feldspar             => '#D19175',
        firebrick            => '#B12121',
        firebrick1           => '#FF2F2F',
        firebrick2           => '#ED2B2B',
        firebrick3           => '#CD2525',
        firebrick4           => '#8A1919',
        flesh                => '#F4CCB0',
        floralwhite          => '#FFF9EF',
        forestgreen          => '#218A21',
        fuchsia              => '#FF00FF',
        gainsboro            => '#DCDCDC',
        ghostwhite           => '#F7F7FF',
        gold                 => '#FFD700',
        gold1                => '#FFD700',
        gold2                => '#EDC900',
        gold3                => '#CDAD00',
        gold4                => '#8A7500',
        goldenrod            => '#DAA51F',
        goldenrod1           => '#FFC024',
        goldenrod2           => '#EDB421',
        goldenrod3           => '#CD9B1C',
        goldenrod4           => '#8A6914',
        gray                 => '#7F7F7F',
        gray0                => '#000000',
        gray1                => '#020202',
        gray10               => '#191919',
        gray100              => '#FFFFFF',
        gray11               => '#1B1B1B',
        gray12               => '#1E1E1E',
        gray13               => '#202020',
        gray14               => '#232323',
        gray15               => '#252525',
        gray16               => '#282828',
        gray17               => '#2A2A2A',
        gray18               => '#2D2D2D',
        gray19               => '#2F2F2F',
        gray2                => '#050505',
        gray20               => '#333333',
        gray21               => '#363636',
        gray22               => '#383838',
        gray23               => '#3B3B3B',
        gray24               => '#3D3D3D',
        gray25               => '#404040',
        gray26               => '#424242',
        gray27               => '#454545',
        gray28               => '#474747',
        gray29               => '#4A4A4A',
        gray3                => '#070707',
        gray30               => '#4C4C4C',
        gray31               => '#4E4E4E',
        gray32               => '#515151',
        gray33               => '#535353',
        gray34               => '#565656',
        gray35               => '#585858',
        gray36               => '#5B5B5B',
        gray37               => '#5D5D5D',
        gray38               => '#606060',
        gray39               => '#626262',
        gray4                => '#0A0A0A',
        gray40               => '#666666',
        gray41               => '#696969',
        gray42               => '#6B6B6B',
        gray43               => '#6E6E6E',
        gray44               => '#707070',
        gray45               => '#737373',
        gray46               => '#757575',
        gray47               => '#787878',
        gray48               => '#7A7A7A',
        gray49               => '#7D7D7D',
        gray5                => '#0C0C0C',
        gray50               => '#7F7F7F',
        gray51               => '#818181',
        gray52               => '#848484',
        gray53               => '#868686',
        gray54               => '#898989',
        gray55               => '#8B8B8B',
        gray56               => '#8E8E8E',
        gray57               => '#909090',
        gray58               => '#939393',
        gray59               => '#959595',
        gray6                => '#0E0E0E',
        gray60               => '#999999',
        gray61               => '#9C9C9C',
        gray62               => '#9E9E9E',
        gray63               => '#A1A1A1',
        gray64               => '#A3A3A3',
        gray65               => '#A6A6A6',
        gray66               => '#A8A8A8',
        gray67               => '#ABABAB',
        gray68               => '#ADADAD',
        gray69               => '#B0B0B0',
        gray7                => '#111111',
        gray70               => '#B2B2B2',
        gray71               => '#B4B4B4',
        gray72               => '#B7B7B7',
        gray73               => '#B9B9B9',
        gray74               => '#BCBCBC',
        gray75               => '#BEBEBE',
        gray76               => '#C1C1C1',
        gray77               => '#C3C3C3',
        gray78               => '#C6C6C6',
        gray79               => '#C9C9C9',
        gray8                => '#141414',
        gray80               => '#CCCCCC',
        gray81               => '#CFCFCF',
        gray82               => '#D1D1D1',
        gray83               => '#D4D4D4',
        gray84               => '#D6D6D6',
        gray85               => '#D9D9D9',
        gray86               => '#DBDBDB',
        gray87               => '#DEDEDE',
        gray88               => '#E0E0E0',
        gray89               => '#E2E2E2',
        gray9                => '#161616',
        gray90               => '#E5E5E5',
        gray91               => '#E7E7E7',
        gray92               => '#EAEAEA',
        gray93               => '#ECECEC',
        gray94               => '#EFEFEF',
        gray95               => '#F1F1F1',
        gray96               => '#F4F4F4',
        gray97               => '#F6F6F6',
        gray98               => '#F9F9F9',
        gray99               => '#FBFBFB',
        green                => '#007F00',
        green1               => '#00FF00',
        green2               => '#00ED00',
        green3               => '#00CD00',
        green4               => '#008A00',
        greencopper          => '#846262',
        greenyellow          => '#D19175',
        grey                 => '#BDBDBD',
        grey0                => '#000000',
        grey1                => '#020202',
        grey10               => '#191919',
        grey100              => '#FFFFFF',
        grey11               => '#1B1B1B',
        grey12               => '#1E1E1E',
        grey13               => '#202020',
        grey14               => '#232323',
        grey15               => '#252525',
        grey16               => '#282828',
        grey17               => '#2A2A2A',
        grey18               => '#2D2D2D',
        grey19               => '#2F2F2F',
        grey2                => '#050505',
        grey20               => '#333333',
        grey21               => '#363636',
        grey22               => '#383838',
        grey23               => '#3B3B3B',
        grey24               => '#3D3D3D',
        grey25               => '#404040',
        grey26               => '#424242',
        grey27               => '#454545',
        grey28               => '#474747',
        grey29               => '#4A4A4A',
        grey3                => '#070707',
        grey30               => '#4C4C4C',
        grey31               => '#4E4E4E',
        grey32               => '#515151',
        grey33               => '#535353',
        grey34               => '#565656',
        grey35               => '#585858',
        grey36               => '#5B5B5B',
        grey37               => '#5D5D5D',
        grey38               => '#606060',
        grey39               => '#626262',
        grey4                => '#0A0A0A',
        grey40               => '#666666',
        grey41               => '#696969',
        grey42               => '#6B6B6B',
        grey43               => '#6E6E6E',
        grey44               => '#707070',
        grey45               => '#737373',
        grey46               => '#757575',
        grey47               => '#787878',
        grey48               => '#7A7A7A',
        grey49               => '#7D7D7D',
        grey5                => '#0C0C0C',
        grey50               => '#7F7F7F',
        grey51               => '#818181',
        grey52               => '#848484',
        grey53               => '#868686',
        grey54               => '#898989',
        grey55               => '#8B8B8B',
        grey56               => '#8E8E8E',
        grey57               => '#909090',
        grey58               => '#939393',
        grey59               => '#959595',
        grey6                => '#0E0E0E',
        grey60               => '#999999',
        grey61               => '#9C9C9C',
        grey62               => '#9E9E9E',
        grey63               => '#A1A1A1',
        grey64               => '#A3A3A3',
        grey65               => '#A6A6A6',
        grey66               => '#A8A8A8',
        grey67               => '#ABABAB',
        grey68               => '#ADADAD',
        grey69               => '#B0B0B0',
        grey7                => '#111111',
        grey70               => '#B2B2B2',
        grey71               => '#B4B4B4',
        grey72               => '#B7B7B7',
        grey73               => '#B9B9B9',
        grey74               => '#BCBCBC',
        grey75               => '#BEBEBE',
        grey76               => '#C1C1C1',
        grey77               => '#C3C3C3',
        grey78               => '#C6C6C6',
        grey79               => '#C9C9C9',
        grey8                => '#141414',
        grey80               => '#CCCCCC',
        grey81               => '#CFCFCF',
        grey82               => '#D1D1D1',
        grey83               => '#D4D4D4',
        grey84               => '#D6D6D6',
        grey85               => '#D9D9D9',
        grey86               => '#DBDBDB',
        grey87               => '#DEDEDE',
        grey88               => '#E0E0E0',
        grey89               => '#E2E2E2',
        grey9                => '#161616',
        grey90               => '#E5E5E5',
        grey91               => '#E7E7E7',
        grey92               => '#EAEAEA',
        grey93               => '#ECECEC',
        grey94               => '#EFEFEF',
        grey95               => '#F1F1F1',
        grey96               => '#F4F4F4',
        grey97               => '#F6F6F6',
        grey98               => '#F9F9F9',
        grey99               => '#FBFBFB',
        honeydew             => '#EFFFEF',
        honeydew1            => '#EFFFEF',
        honeydew2            => '#E0EDE0',
        honeydew3            => '#C0CDC0',
        honeydew4            => '#828A82',
        hotpink              => '#FF69B4',
        hotpink1             => '#FF6EB4',
        hotpink2             => '#ED6AA7',
        hotpink3             => '#CD5F8F',
        hotpink4             => '#8A3A61',
        indianred            => '#F4CCB0',
        indianred1           => '#FF6A6A',
        indianred2           => '#ED6262',
        indianred3           => '#CD5454',
        indianred4           => '#8A3A3A',
        indigo               => '#4B0081',
        ivory                => '#FFFFEF',
        ivory1               => '#FFFFEF',
        ivory2               => '#EDEDE0',
        ivory3               => '#CDCDC0',
        ivory4               => '#8A8A82',
        khaki                => '#EFE68B',
        khaki1               => '#FFF58E',
        khaki2               => '#EDE684',
        khaki3               => '#CDC573',
        khaki4               => '#8A854D',
        lavender             => '#E6E6F9',
        lavenderblush        => '#FFEFF4',
        lavenderblush1       => '#FFEFF4',
        lavenderblush2       => '#EDE0E5',
        lavenderblush3       => '#CDC0C4',
        lavenderblush4       => '#8A8285',
        lawngreen            => '#7CFB00',
        lemonchiffon         => '#FFF9CD',
        lemonchiffon1        => '#FFF9CD',
        lemonchiffon2        => '#EDE8BE',
        lemonchiffon3        => '#CDC9A5',
        lemonchiffon4        => '#8A8870',
        lightblue            => '#ADD8E6',
        lightblue1           => '#BEEEFF',
        lightblue2           => '#B1DFED',
        lightblue3           => '#9ABFCD',
        lightblue4           => '#68828A',
        lightcoral           => '#EF7F7F',
        lightcyan            => '#E0FFFF',
        lightcyan1           => '#E0FFFF',
        lightcyan2           => '#D1EDED',
        lightcyan3           => '#B4CDCD',
        lightcyan4           => '#7A8A8A',
        lightgoldenrod       => '#EDDD81',
        lightgoldenrod1      => '#FFEB8A',
        lightgoldenrod2      => '#EDDC81',
        lightgoldenrod3      => '#CDBD70',
        lightgoldenrod4      => '#8A804C',
        lightgoldenrodyellow => '#F9F9D2',
        lightgray            => '#D3D3D3',
        lightgreen           => '#8FED8F',
        lightgrey            => '#D3D3D3',
        lightpink            => '#FFB5C0',
        lightpink1           => '#FFAEB8',
        lightpink2           => '#EDA2AD',
        lightpink3           => '#CD8B94',
        lightpink4           => '#8A5E65',
        lightsalmon          => '#FFA07A',
        lightsalmon1         => '#FFA07A',
        lightsalmon2         => '#ED9472',
        lightsalmon3         => '#CD8061',
        lightsalmon4         => '#8A5642',
        lightseagreen        => '#1FB1AA',
        lightskyblue         => '#86CEF9',
        lightskyblue1        => '#B0E2FF',
        lightskyblue2        => '#A4D3ED',
        lightskyblue3        => '#8CB5CD',
        lightskyblue4        => '#5F7B8A',
        lightslateblue       => '#8370FF',
        lightslategray       => '#778799',
        lightslategrey       => '#778799',
        lightsteelblue       => '#B0C3DE',
        lightsteelblue1      => '#CAE1FF',
        lightsteelblue2      => '#BBD2ED',
        lightsteelblue3      => '#A2B4CD',
        lightsteelblue4      => '#6E7B8A',
        lightyellow          => '#FFFFE0',
        lightyellow1         => '#FFFFE0',
        lightyellow2         => '#EDEDD1',
        lightyellow3         => '#CDCDB4',
        lightyellow4         => '#8A8A7A',
        lime                 => '#00FF00',
        limegreen            => '#31CD31',
        linen                => '#F9EFE6',
        magenta              => '#FF00FF',
        magenta1             => '#FF00FF',
        magenta2             => '#ED00ED',
        magenta3             => '#CD00CD',
        magenta4             => '#8A008A',
        mandarianorange      => '#8D2222',
        maroon               => '#7F0000',
        maroon1              => '#FF34B2',
        maroon2              => '#ED2FA7',
        maroon3              => '#CD288F',
        maroon4              => '#8A1B61',
        mediumaquamarine     => '#66CDAA',
        mediumblue           => '#0000CD',
        mediumorchid         => '#B954D3',
        mediumorchid1        => '#E066FF',
        mediumorchid2        => '#D15EED',
        mediumorchid3        => '#B451CD',
        mediumorchid4        => '#7A378A',
        mediumpurple         => '#9270DB',
        mediumpurple1        => '#AB81FF',
        mediumpurple2        => '#9F79ED',
        mediumpurple3        => '#8868CD',
        mediumpurple4        => '#5C478A',
        mediumseagreen       => '#3CB271',
        mediumslateblue      => '#7B68ED',
        mediumspringgreen    => '#00F99A',
        mediumturquoise      => '#48D1CC',
        mediumvioletred      => '#C61584',
        midnightblue         => '#2E2E4E',
        mintcream            => '#F4FFF9',
        mistyrose            => '#FFE4E1',
        mistyrose1           => '#FFE4E1',
        mistyrose2           => '#EDD5D2',
        mistyrose3           => '#CDB6B4',
        mistyrose4           => '#8A7D7B',
        moccasin             => '#FFE4B4',
        navajowhite          => '#FFDEAD',
        navajowhite1         => '#FFDEAD',
        navajowhite2         => '#EDCFA1',
        navajowhite3         => '#CDB28A',
        navajowhite4         => '#8A795D',
        navy                 => '#00007F',
        navyblue             => '#00007F',
        neonblue             => '#4C4CFF',
        neonpink             => '#FF6EC6',
        none                 => '#000000',
        oldlace              => '#FCF4E6',
        olive                => '#7F7F00',
        olivedrab            => '#6B8D22',
        olivedrab1           => '#BFFF3E',
        olivedrab2           => '#B2ED3A',
        olivedrab3           => '#9ACD31',
        olivedrab4           => '#698A21',
        orange               => '#FFA500',
        orange1              => '#FFA500',
        orange2              => '#ED9A00',
        orange3              => '#CD8400',
        orange4              => '#8A5900',
        orangered            => '#FF4500',
        orangered1           => '#FF4500',
        orangered2           => '#ED4000',
        orangered3           => '#CD3700',
        orangered4           => '#8A2400',
        orchid               => '#DA70D6',
        orchid1              => '#FF82F9',
        orchid2              => '#ED7AE8',
        orchid3              => '#CD69C9',
        orchid4              => '#8A4788',
        palegoldenrod        => '#EDE7AA',
        palegreen            => '#98FB98',
        palegreen1           => '#9AFF9A',
        palegreen2           => '#8FED8F',
        palegreen3           => '#7CCD7C',
        palegreen4           => '#538A53',
        paleturquoise        => '#AFEDED',
        paleturquoise1       => '#BAFFFF',
        paleturquoise2       => '#AEEDED',
        paleturquoise3       => '#95CDCD',
        paleturquoise4       => '#668A8A',
        palevioletred        => '#DB7092',
        palevioletred1       => '#FF81AB',
        palevioletred2       => '#ED799F',
        palevioletred3       => '#CD6888',
        palevioletred4       => '#8A475C',
        papayawhip           => '#FFEED5',
        peachpuff            => '#FFDAB8',
        peachpuff1           => '#FFDAB8',
        peachpuff2           => '#EDCBAD',
        peachpuff3           => '#CDAF94',
        peachpuff4           => '#8A7765',
        peru                 => '#CD843F',
        pink                 => '#FFBFCB',
        pink1                => '#FFB4C4',
        pink2                => '#EDA9B7',
        pink3                => '#CD909E',
        pink4                => '#8A626C',
        plum                 => '#DDA0DD',
        plum1                => '#FFBAFF',
        plum2                => '#EDAEED',
        plum3                => '#CD95CD',
        plum4                => '#8A668A',
        powderblue           => '#B0E0E6',
        purple               => '#7F007F',
        purple1              => '#9B2FFF',
        purple2              => '#902BED',
        purple3              => '#7D25CD',
        purple4              => '#54198A',
        quartz               => '#D9D9F2',
        red                  => '#FF0000',
        red1                 => '#FF0000',
        red2                 => '#ED0000',
        red3                 => '#CD0000',
        red4                 => '#8A0000',
        richblue             => '#5858AB',
        rosybrown            => '#BB8E8E',
        rosybrown1           => '#FFC0C0',
        rosybrown2           => '#EDB4B4',
        rosybrown3           => '#CD9B9B',
        rosybrown4           => '#8A6969',
        royalblue            => '#4169E1',
        royalblue1           => '#4876FF',
        royalblue2           => '#436EED',
        royalblue3           => '#3A5ECD',
        royalblue4           => '#26408A',
        saddlebrown          => '#8A4512',
        salmon               => '#F97F72',
        salmon1              => '#FF8B69',
        salmon2              => '#ED8161',
        salmon3              => '#CD7053',
        salmon4              => '#8A4C39',
        sandybrown           => '#F3A45F',
        seagreen             => '#2D8A56',
        seagreen1            => '#53FF9F',
        seagreen2            => '#4DED93',
        seagreen3            => '#43CD7F',
        seagreen4            => '#2D8A56',
        seashell             => '#FFF4ED',
        seashell1            => '#FFF4ED',
        seashell2            => '#EDE5DE',
        seashell3            => '#CDC4BE',
        seashell4            => '#8A8581',
        sienna               => '#A0512C',
        sienna1              => '#FF8147',
        sienna2              => '#ED7942',
        sienna3              => '#CD6839',
        sienna4              => '#8A4725',
        silver               => '#BFBFBF',
        skyblue              => '#86CEEA',
        skyblue1             => '#86CEFF',
        skyblue2             => '#7EBFED',
        skyblue3             => '#6CA6CD',
        skyblue4             => '#4A708A',
        slateblue            => '#6A59CD',
        slateblue1           => '#826FFF',
        slateblue2           => '#7A67ED',
        slateblue3           => '#6958CD',
        slateblue4           => '#473C8A',
        slategray            => '#707F8F',
        slategray1           => '#C5E2FF',
        slategray2           => '#B8D3ED',
        slategray3           => '#9FB5CD',
        slategray4           => '#6C7B8A',
        slategrey            => '#707F8F',
        snow                 => '#FFF9F9',
        snow1                => '#FFF9F9',
        snow2                => '#EDE8E8',
        snow3                => '#CDC9C9',
        snow4                => '#8A8888',
        springgreen          => '#00FF7F',
        springgreen1         => '#00FF7F',
        springgreen2         => '#00ED76',
        springgreen3         => '#00CD66',
        springgreen4         => '#008A45',
        steelblue            => '#4681B4',
        steelblue1           => '#62B7FF',
        steelblue2           => '#5BACED',
        steelblue3           => '#4E93CD',
        steelblue4           => '#36638A',
        summersky            => '#38B0DE',
        tan                  => '#D2B48B',
        tan1                 => '#FFA54E',
        tan2                 => '#ED9A49',
        tan3                 => '#CD843F',
        tan4                 => '#8A592A',
        teal                 => '#007F7F',
        thistle              => '#D8BED8',
        thistle1             => '#FFE1FF',
        thistle2             => '#EDD2ED',
        thistle3             => '#CDB4CD',
        thistle4             => '#8A7B8A',
        tomato               => '#FF6247',
        tomato1              => '#FF6247',
        tomato2              => '#ED5B42',
        tomato3              => '#CD4E39',
        tomato4              => '#8A3625',
        turquoise            => '#40E0D0',
        turquoise1           => '#00F4FF',
        turquoise2           => '#00E5ED',
        turquoise3           => '#00C4CD',
        turquoise4           => '#00858A',
        violet               => '#ED81ED',
        violetred            => '#D01F8F',
        violetred1           => '#FF3E95',
        violetred2           => '#ED3A8B',
        violetred3           => '#CD3178',
        violetred4           => '#8A2151',
        wheat                => '#F4DEB2',
        wheat1               => '#FFE6B9',
        wheat2               => '#EDD8AE',
        wheat3               => '#CDB995',
        wheat4               => '#8A7E66',
        white                => '#FFFFFF',
        whitesmoke           => '#F4F4F4',
        yellow               => '#FFFF00',
        yellow1              => '#FFFF00',
        yellow2              => '#EDED00',
        yellow3              => '#CDCD00',
        yellow4              => '#8A8A00',
        yellowgreen          => '#99CC31',
    );
}

1;
