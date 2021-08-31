L0010:       equ  0010h
L0018:       equ  0018h
L001C:       equ  001Ch
L0038:       equ  0038h
L00AD:       equ  00ADh
L00AE:       equ  00AEh
L00E6:       equ  00E6h
L014A:       equ  014Ah
L0295:       equ  0295h
L056B:       equ  056Bh
L0A37:       equ  0A37h
L0A3E:       equ  0A3Eh
L0A84:       equ  0A84h
L0A8B:       equ  0A8Bh
L0B3F:       equ  0B3Fh
L0B4E:       equ  0B4Eh
L0BE2:       equ  0BE2h
L0D62:       equ  0D62h
L10C2:       equ  10C2h
L10CB:       equ  10CBh
L24F2:       equ  24F2h
L2C24:       equ  2C24h
L4055:       equ  4055h
L4134:       equ  4134h
L42B2:       equ  42B2h
L4514:       equ  4514h
L4769:       equ  4769h
L4AFF:       equ  4AFFh
L636E:       equ  636Eh
L63C9:       equ  63C9h
L6C1C:       equ  6C1Ch
L6D48:       equ  6D48h
L7304:       equ  7304h
L8024:       equ  8024h
L82B3:       equ  82B3h
L82C2:       equ  82C2h
L82D1:       equ  82D1h
L86E1:       equ  86E1h
LA4FE:       equ  A4FEh
LDB3D:       equ  DB3Dh
LDBD2:       equ  DBD2h
LF3F8:       equ  F3F8h
LF3FA:       equ  F3FAh
LF661:       equ  F661h
LF672:       equ  F672h
LF674:       equ  F674h
LF678:       equ  F678h
LF69B:       equ  F69Bh
LF6A7:       equ  F6A7h
LF6AA:       equ  F6AAh
LF6AF:       equ  F6AFh
LF6B1:       equ  F6B1h
LF6B5:       equ  F6B5h
LF6B9:       equ  F6B9h
LF6BB:       equ  F6BBh
LF6C0:       equ  F6C0h
LF6C2:       equ  F6C2h
LF6C4:       equ  F6C4h
LF6C6:       equ  F6C6h
LF860:       equ  F860h
LF862:       equ  F862h
LF87C:       equ  F87Ch
LFBCD:       equ  FBCDh
LFC48:       equ  FC48h
LFC4A:       equ  FC4Ah
LFCAA:       equ  FCAAh
LFDC2:       equ  FDC2h
LFED0:       equ  FED0h
LFED5:       equ  FED5h
LFEDA:       equ  FEDAh
LFF11:       equ  FF11h


             org 092Dh


092D L092D:
092D CD 3E 0A     CALL L0A3E  
0930 3A DD F3     LD   A,(LF3DD) 
0933 3D           DEC  A      
0934 32 61 F6     LD   (LF661),A 
0937 F1           POP  AF     


0938 L0938:
0938 C1           POP  BC     
0939 D1           POP  DE     
093A E1           POP  HL     
093B C9           RET         


093C CD           defb CDh    
093D FA           defb FAh    
093E 08           defb 08h    
093F D0           defb D0h    
0940 4F           defb 4Fh    
0941 20           defb 20h    
0942 0D           defb 0Dh    
0943 21           defb 21h    
0944 A7           defb A7h    
0945 FC           defb FCh    
0946 7E           defb 7Eh    
0947 A7           defb A7h    
0948 C2           defb C2h    
0949 EC           defb ECh    
094A 09           defb 09h    
094B 79           defb 79h    
094C FE           defb FEh    
094D 20           defb 20h    
094E 38           defb 38h    
094F 21           defb 21h    
0950 2A           defb 2Ah    
0951 DC           defb DCh    
0952 F3           defb F3h    
0953 FE           defb FEh    
0954 7F           defb 7Fh    
0955 CA           defb CAh    
0956 FA           defb FAh    
0957 0A           defb 0Ah    
0958 CD           defb CDh    
0959 8D           defb 8Dh    
095A 0B           defb 0Bh    
095B CD           defb CDh    
095C A1           defb A1h    
095D 0A           defb 0Ah    
095E C0           defb C0h    
095F AF           defb AFh    
0960 CD           defb CDh    
0961 DB           defb DBh    
0962 0B           defb 0Bh    
0963 26           defb 26h    
0964 01           defb 01h    


0965 L0965:
0965 CD BE 0A     CALL L0ABE  
0968 C0           RET  NZ     
0969 CD C6 0A     CALL L0AC6  
096C 2E 01        LD   L,01h  
096E C3 E5 0A     JP   L0AE5  


0971 21           defb 21h    
0972 8A           defb 8Ah    
0973 09           defb 09h    
0974 0E           defb 0Eh    
0975 0C           defb 0Ch    


0976 L0976:
0976 23           INC  HL     
0977 23           INC  HL     
0978 A7           AND  A      
0979 0D           DEC  C      
097A F8           RET  M      
097B BE           CP   (HL)   
097C 23           INC  HL     
097D 20 F7        JR   NZ,L0976 
097F 4E           LD   C,(HL) 
0980 23           INC  HL     
0981 46           LD   B,(HL) 
0982 2A DC F3     LD   HL,(LF3DC) 
0985 CD 8A 09     CALL L098A  
0988 AF           XOR  A      
0989 C9           RET         


098A L098A:
098A C5           PUSH BC     
098B C9           RET         


098C 07           defb 07h    
098D 13           defb 13h    
098E 11           defb 11h    
098F 08           defb 08h    
0990 A9           defb A9h    
0991 0A           defb 0Ah    
0992 09           defb 09h    
0993 CE           defb CEh    
0994 0A           defb 0Ah    
0995 0A           defb 0Ah    
0996 65           defb 65h    
0997 09           defb 09h    
0998 0B           defb 0Bh    
0999 DC           defb DCh    
099A 0A           defb 0Ah    
099B 0C           defb 0Ch    
099C CE           defb CEh    
099D 07           defb 07h    
099E 0D           defb 0Dh    
099F DE           defb DEh    
09A0 0A           defb 0Ah    
09A1 1B           defb 1Bh    
09A2 E6           defb E6h    
09A3 09           defb 09h    
09A4 1C           defb 1Ch    
09A5 B8           defb B8h    
09A6 0A           defb 0Ah    
09A7 1D           defb 1Dh    
09A8 A9           defb A9h    
09A9 0A           defb 0Ah    
09AA 1E           defb 1Eh    
09AB B4           defb B4h    
09AC 0A           defb 0Ah    
09AD 1F           defb 1Fh    
09AE BE           defb BEh    
09AF 0A           defb 0Ah    
09B0 6A           defb 6Ah    
09B1 CE           defb CEh    
09B2 07           defb 07h    
09B3 45           defb 45h    
09B4 CE           defb CEh    
09B5 07           defb 07h    
09B6 4B           defb 4Bh    
09B7 05           defb 05h    
09B8 0B           defb 0Bh    
09B9 4A           defb 4Ah    
09BA 19           defb 19h    
09BB 0B           defb 0Bh    
09BC 6C           defb 6Ch    
09BD 03           defb 03h    
09BE 0B           defb 0Bh    
09BF 4C           defb 4Ch    
09C0 EE           defb EEh    
09C1 0A           defb 0Ah    
09C2 4D           defb 4Dh    
09C3 E2           defb E2h    
09C4 0A           defb 0Ah    
09C5 59           defb 59h    
09C6 E3           defb E3h    
09C7 09           defb 09h    
09C8 41           defb 41h    
09C9 B4           defb B4h    
09CA 0A           defb 0Ah    
09CB 42           defb 42h    
09CC BE           defb BEh    
09CD 0A           defb 0Ah    
09CE 43           defb 43h    
09CF A1           defb A1h    
09D0 0A           defb 0Ah    
09D1 44           defb 44h    
09D2 B2           defb B2h    
09D3 0A           defb 0Ah    
09D4 48           defb 48h    
09D5 DC           defb DCh    
09D6 0A           defb 0Ah    
09D7 78           defb 78h    
09D8 DD           defb DDh    
09D9 09           defb 09h    
09DA 79           defb 79h    
09DB E0           defb E0h    
09DC 09           defb 09h    
09DD 3E           defb 3Eh    
09DE 01           defb 01h    
09DF 01           defb 01h    
09E0 3E           defb 3Eh    
09E1 02           defb 02h    
09E2 01           defb 01h    
09E3 3E           defb 3Eh    
09E4 04           defb 04h    
09E5 01           defb 01h    
09E6 3E           defb 3Eh    
09E7 FF           defb FFh    
09E8 32           defb 32h    


             org 0ABEh


0ABE L0ABE:
0ABE CD E2 0B     CALL L0BE2  
0AC1 BD           CP   L      
0AC2 C8           RET  Z      
0AC3 38 05        JR   C,L0ACA 
0AC5 2C           INC  L      


0AC6 L0AC6:
0AC6 22 DC F3     LD   (LF3DC),HL 
0AC9 C9           RET         


0ACA L0ACA:
0ACA 2D           DEC  L      
0ACB AF           XOR  A      
0ACC 18 F8        JR   L0AC6  


0ACE 3E           defb 3Eh    
0ACF 20           defb 20h    
0AD0 CD           defb CDh    
0AD1 3C           defb 3Ch    
0AD2 09           defb 09h    
0AD3 3A           defb 3Ah    
0AD4 DD           defb DDh    
0AD5 F3           defb F3h    
0AD6 3D           defb 3Dh    
0AD7 E6           defb E6h    
0AD8 07           defb 07h    
0AD9 20           defb 20h    
0ADA F3           defb F3h    
0ADB C9           defb C9h    
0ADC 2E           defb 2Eh    
0ADD 01           defb 01h    
0ADE 26           defb 26h    
0ADF 01           defb 01h    
0AE0 18           defb 18h    
0AE1 E4           defb E4h    
0AE2 CD           defb CDh    
0AE3 DE           defb DEh    
0AE4 0A           defb 0Ah    


0AE5 L0AE5:
0AE5 DD E5        PUSH IX     
0AE7 DD 21 21 01  LD   IX,0121h 
0AEB C3 95 02     JP   L0295  


0AEE CD           defb CDh    
0AEF DE           defb DEh    
0AF0 0A           defb 0Ah    
0AF1 DD           defb DDh    
0AF2 E5           defb E5h    
0AF3 DD           defb DDh    
0AF4 21           defb 21h    
0AF5 25           defb 25h    
0AF6 01           defb 01h    
0AF7 C3           defb C3h    
0AF8 95           defb 95h    
0AF9 02           defb 02h    
0AFA CD           defb CDh    
0AFB A9           defb A9h    
0AFC 0A           defb 0Ah    
0AFD C8           defb C8h    
0AFE 0E           defb 0Eh    
0AFF 20           defb 20h    
0B00 C3           defb C3h    
0B01 8D           defb 8Dh    
0B02 0B           defb 0Bh    
0B03 26           defb 26h    
0B04 01           defb 01h    
0B05 CD           defb CDh    
0B06 D9           defb D9h    
0B07 0B           defb 0Bh    
0B08 E5           defb E5h    
0B09 CD           defb CDh    
0B0A F1           defb F1h    
0B0B 07           defb 07h    
0B0C E1           defb E1h    
0B0D 3E           defb 3Eh    
0B0E 20           defb 20h    
0B0F D3           defb D3h    
0B10 98           defb 98h    
0B11 24           defb 24h    
0B12 3A           defb 3Ah    
0B13 B0           defb B0h    
0B14 F3           defb F3h    
0B15 BC           defb BCh    
0B16 30           defb 30h    
0B17 F5           defb F5h    
0B18 C9           defb C9h    
0B19 E5           defb E5h    
0B1A CD           defb CDh    
0B1B 05           defb 05h    
0B1C 0B           defb 0Bh    
0B1D E1           defb E1h    
0B1E CD           defb CDh    
0B1F E2           defb E2h    
0B20 0B           defb 0Bh    
0B21 BD           defb BDh    


             org 0D65h


0D65 L0D65:
0D65 3A F8 F3     LD   A,(LF3F8) 
0D68 95           SUB  L      
0D69 C9           RET         


0D6A L0D6A:
0D6A FB           EI          
0D6B E5           PUSH HL     
0D6C D5           PUSH DE     
0D6D C5           PUSH BC     
0D6E CD 4E 0B     CALL L0B4E  
0D71 30 0F        JR   NC,L0D82 
0D73 3A CD FB     LD   A,(LFBCD) 
0D76 21 EB FB     LD   HL,FBEBh 
0D79 AE           XOR  (HL)   
0D7A 21 DE F3     LD   HL,F3DEh 
0D7D A6           AND  (HL)   
0D7E 0F           RRCA        
0D7F DC 3F 0B     CALL C,L0B3F 
0D82 L0D82:
0D82 CD 62 0D     CALL L0D62  
0D85 C1           POP  BC     
0D86 D1           POP  DE     
0D87 E1           POP  HL     
0D88 C9           RET         


0D89 E5           defb E5h    
0D8A D5           defb D5h    
0D8B C5           defb C5h    
0D8C F5           defb F5h    
0D8D 3E           defb 3Eh    
0D8E 0B           defb 0Bh    
0D8F 90           defb 90h    
0D90 87           defb 87h    
0D91 87           defb 87h    
0D92 87           defb 87h    
0D93 4F           defb 4Fh    
0D94 06           defb 06h    
0D95 08           defb 08h    
0D96 F1           defb F1h    
0D97 1F           defb 1Fh    
0D98 C5           defb C5h    
0D99 F5           defb F5h    
0D9A DC           defb DCh    
0D9B 21           defb 21h    
0D9C 10           defb 10h    
0D9D F1           defb F1h    
0D9E C1           defb C1h    
0D9F 0C           defb 0Ch    
0DA0 10           defb 10h    
0DA1 F5           defb F5h    
0DA2 C3           defb C3h    
0DA3 38           defb 38h    
0DA4 09           defb 09h    
0DA5 30           defb 30h    
0DA6 31           defb 31h    
0DA7 32           defb 32h    
0DA8 33           defb 33h    
0DA9 34           defb 34h    
0DAA 35           defb 35h    
0DAB 36           defb 36h    
0DAC 37           defb 37h    
0DAD 38           defb 38h    
0DAE 39           defb 39h    
0DAF 2D           defb 2Dh    
0DB0 3D           defb 3Dh    
0DB1 5C           defb 5Ch    
0DB2 5B           defb 5Bh    
0DB3 5D           defb 5Dh    
0DB4 3B           defb 3Bh    
0DB5 27           defb 27h    
0DB6 60           defb 60h    
0DB7 2C           defb 2Ch    
0DB8 2E           defb 2Eh    
0DB9 2F           defb 2Fh    
0DBA FF           defb FFh    
0DBB 61           defb 61h    
0DBC 62           defb 62h    
0DBD 63           defb 63h    
0DBE 64           defb 64h    
0DBF 65           defb 65h    
0DC0 66           defb 66h    
0DC1 67           defb 67h    
0DC2 68           defb 68h    
0DC3 69           defb 69h    
0DC4 6A           defb 6Ah    
0DC5 6B           defb 6Bh    
0DC6 6C           defb 6Ch    
0DC7 6D           defb 6Dh    
0DC8 6E           defb 6Eh    
0DC9 6F           defb 6Fh    
0DCA 70           defb 70h    
0DCB 71           defb 71h    
0DCC 72           defb 72h    
0DCD 73           defb 73h    
0DCE 74           defb 74h    
0DCF 75           defb 75h    
0DD0 76           defb 76h    
0DD1 77           defb 77h    
0DD2 78           defb 78h    
0DD3 79           defb 79h    
0DD4 7A           defb 7Ah    
0DD5 29           defb 29h    
0DD6 21           defb 21h    
0DD7 40           defb 40h    
0DD8 23           defb 23h    
0DD9 24           defb 24h    
0DDA 25           defb 25h    
0DDB 5E           defb 5Eh    
0DDC 26           defb 26h    
0DDD 2A           defb 2Ah    
0DDE 28           defb 28h    
0DDF 5F           defb 5Fh    
0DE0 2B           defb 2Bh    
0DE1 7C           defb 7Ch    
0DE2 7B           defb 7Bh    
0DE3 7D           defb 7Dh    
0DE4 3A           defb 3Ah    
0DE5 22           defb 22h    


             org 10CEh


10CE L10CE:
10CE CD C2 FD     CALL LFDC2  
10D1 CD 6A 0D     CALL L0D6A  
10D4 20 0B        JR   NZ,L10E1 
10D6 CD 37 0A     CALL L0A37  
10D9 L10D9:
10D9 CD 6A 0D     CALL L0D6A  
10DC 28 FB        JR   Z,L10D9 
10DE CD 84 0A     CALL L0A84  
10E1 L10E1:
10E1 21 9B FC     LD   HL,FC9Bh 
10E4 7E           LD   A,(HL) 
10E5 FE 04        CP   04h    
10E7 20 02        JR   NZ,L10EB 
10E9 36 00        LD   (HL),00h 
10EB L10EB:
10EB 2A FA F3     LD   HL,(LF3FA) 
10EE 4E           LD   C,(HL) 
10EF CD C2 10     CALL L10C2  
10F2 22 FA F3     LD   (LF3FA),HL 
10F5 79           LD   A,C    
10F6 C3 38 09     JP   L0938  


10F9 E5           defb E5h    
10FA 21           defb 21h    
10FB 00           defb 00h    
10FC 00           defb 00h    
10FD CD           defb CDh    
10FE F0           defb F0h    
10FF 04           defb 04h    
1100 E1           defb E1h    
1101 C9           defb C9h    
1102 F3           defb F3h    
1103 D3           defb D3h    
1104 A0           defb A0h    
1105 F5           defb F5h    
1106 7B           defb 7Bh    
1107 FB           defb FBh    
1108 D3           defb D3h    
1109 A1           defb A1h    
110A F1           defb F1h    
110B C9           defb C9h    
110C 3E           defb 3Eh    
110D 0E           defb 0Eh    
110E D3           defb D3h    
110F A0           defb A0h    
1110 DB           defb DBh    
1111 A2           defb A2h    
1112 C9           defb C9h    
1113 DD           defb DDh    
1114 E5           defb E5h    
1115 DD           defb DDh    
1116 21           defb 21h    
1117 7D           defb 7Dh    
1118 01           defb 01h    
1119 C3           defb C3h    
111A 95           defb 95h    
111B 02           defb 02h    
111C F5           defb F5h    
111D 3E           defb 3Eh    
111E 0F           defb 0Fh    
111F D3           defb D3h    
1120 A0           defb A0h    
1121 DB           defb DBh    
1122 A2           defb A2h    
1123 E6           defb E6h    
1124 7F           defb 7Fh    
1125 47           defb 47h    
1126 F1           defb F1h    
1127 B7           defb B7h    
1128 3E           defb 3Eh    
1129 80           defb 80h    
112A 28           defb 28h    
112B 01           defb 01h    
112C AF           defb AFh    
112D B0           defb B0h    
112E D3           defb D3h    
112F A1           defb A1h    
1130 C9           defb C9h    
1131 47           defb 47h    
1132 CD           defb CDh    
1133 0A           defb 0Ah    
1134 0C           defb 0Ch    
1135 2B           defb 2Bh    
1136 56           defb 56h    
1137 2B           defb 2Bh    
1138 5E           defb 5Eh    
1139 1B           defb 1Bh    
113A 73           defb 73h    
113B 23           defb 23h    
113C 72           defb 72h    


             org 23E7h


23E7 L23E7:
23E7 CD CB 10     CALL L10CB  


23EA L23EA:
23EA 21 37 24     LD   HL,2437h 
23ED 0E 0B        LD   C,0Bh  
23EF CD 76 09     CALL L0976  
23F2 F5           PUSH AF     
23F3 C4 FF 23     CALL NZ,L23FF 
23F6 F1           POP  AF     
23F7 30 EE        JR   NC,L23E7 
23F9 21 5D F5     LD   HL,F55Dh 
23FC C8           RET  Z      
23FD 3F           CCF         
23FE C9           RET         


23FF L23FF:
23FF F5           PUSH AF     
2400 FE 09        CP   09h    
2402 20 0F        JR   NZ,L2413 
2404 F1           POP  AF     
2405 L2405:
2405 3E 20        LD   A,20h  
2407 CD FF 23     CALL L23FF  
240A 3A DD F3     LD   A,(LF3DD) 
240D 3D           DEC  A      
240E E6 07        AND  07h    
2410 20 F3        JR   NZ,L2405 
2412 C9           RET         
2413 L2413:
2413 F1           POP  AF     
2414 21 A8 FC     LD   HL,FCA8h 
2417 FE 01        CP   01h    
2419 28 0B        JR   Z,L2426 
241B FE 20        CP   20h    
241D 38 09        JR   C,L2428 
241F F5           PUSH AF     
2420 7E           LD   A,(HL) 
2421 A7           AND  A      
2422 C4 F2 24     CALL NZ,L24F2 
2425 F1           POP  AF     
2426 L2426:
2426 DF           RST  18h    
2427 C9           RET         
2428 L2428:
2428 36 00        LD   (HL),00h 
242A DF           RST  18h    
242B 3E 3E        LD   A,3Eh  
242D AF           XOR  A      
242E F5           PUSH AF     
242F CD 8B 0A     CALL L0A8B  
2432 F1           POP  AF     
2433 32 AA FC     LD   (LFCAA),A 
2436 C3 3E 0A     JP   L0A3E  


2439 08           defb 08h    
243A 61           defb 61h    
243B 25           defb 25h    
243C 12           defb 12h    
243D E5           defb E5h    
243E 24           defb 24h    
243F 1B           defb 1Bh    
2440 FE           defb FEh    
2441 23           defb 23h    
2442 02           defb 02h    
2443 0E           defb 0Eh    
2444 26           defb 26h    
2445 06           defb 06h    
2446 F8           defb F8h    
2447 25           defb 25h    
2448 0E           defb 0Eh    
2449 D7           defb D7h    
244A 25           defb 25h    


             org 4164h


4164 L4164:
4164 CD AE 00     CALL L00AE  
4167 30 0A        JR   NC,L4173 
4169 AF           XOR  A      
416A 32 AA F6     LD   (LF6AA),A 
416D C3 34 41     JP   L4134  


4170 CD           defb CDh    
4171 74           defb 74h    
4172 73           defb 73h    


4173 L4173:
4173 D7           RST  10h    
4174 3C           INC  A      
4175 3D           DEC  A      
4176 28 BC        JR   Z,L4134 
4178 F5           PUSH AF     
4179 CD 69 47     CALL L4769  
417C 30 06        JR   NC,L4184 
417E CD 4A 01     CALL L014A  
4181 CA 55 40     JP   Z,L4055 
4184 L4184:
4184 CD 14 45     CALL L4514  
4187 3A AA F6     LD   A,(LF6AA) 
418A B7           OR   A      
418B 28 08        JR   Z,L4195 
418D FE 2A        CP   2Ah    
418F 20 04        JR   NZ,L4195 
4191 BE           CP   (HL)   
4192 20 01        JR   NZ,L4195 
4194 23           INC  HL     
4195 L4195:
4195 7A           LD   A,D    
4196 B3           OR   E      
4197 28 06        JR   Z,L419F 
4199 7E           LD   A,(HL) 
419A FE 20        CP   20h    
419C 20 01        JR   NZ,L419F 
419E 23           INC  HL     
419F L419F:
419F D5           PUSH DE     
41A0 CD B2 42     CALL L42B2  
41A3 D1           POP  DE     
41A4 F1           POP  AF     
41A5 22 AF F6     LD   (LF6AF),HL 
41A8 CD 11 FF     CALL LFF11  
41AB 38 07        JR   C,L41B4 
41AD AF           XOR  A      
41AE 32 AA F6     LD   (LF6AA),A 
41B1 C3 48 6D     JP   L6D48  
41B4 L41B4:
41B4 D5           PUSH DE     
41B5 C5           PUSH BC     
41B6 D7           RST  10h    
41B7 B7           OR   A      
41B8 F5           PUSH AF     
41B9 3A AA F6     LD   A,(LF6AA) 
41BC A7           AND  A      
41BD 28 03        JR   Z,L41C2 
41BF F1           POP  AF     
41C0 37           SCF         
41C1 F5           PUSH AF     
41C2 L41C2:
41C2 ED 53 B5 F6  LD   (LF6B5),DE 
41C6 2A AD 00     LD   HL,(L00AD) 


             org 62A1h


62A1 L62A1:
62A1 CD D0 FE     CALL LFED0  
62A4 22 A7 F6     LD   (LF6A7),HL 
62A7 CD 6E 63     CALL L636E  
62AA 06 1A        LD   B,1Ah  
62AC 21 CA F6     LD   HL,F6CAh 
62AF CD D5 FE     CALL LFED5  
62B2 L62B2:
62B2 36 08        LD   (HL),08h 
62B4 23           INC  HL     
62B5 10 FB        DJNZ L62B2  
62B7 CD 24 2C     CALL L2C24  
62BA AF           XOR  A      
62BB 32 BB F6     LD   (LF6BB),A 
62BE 6F           LD   L,A    
62BF 67           LD   H,A    
62C0 22 B9 F6     LD   (LF6B9),HL 
62C3 22 C0 F6     LD   (LF6C0),HL 
62C6 2A 72 F6     LD   HL,(LF672) 
62C9 22 9B F6     LD   (LF69B),HL 
62CC CD C9 63     CALL L63C9  
62CF 2A C2 F6     LD   HL,(LF6C2) 
62D2 22 C4 F6     LD   (LF6C4),HL 
62D5 22 C6 F6     LD   (LF6C6),HL 
62D8 CD 1C 6C     CALL L6C1C  
62DB 3A 7C F8     LD   A,(LF87C) 
62DE E6 01        AND  01h    
62E0 20 03        JR   NZ,L62E5 
62E2 32 7C F8     LD   (LF87C),A 
62E5 L62E5:
62E5 C1           POP  BC     
62E6 2A 74 F6     LD   HL,(LF674) 
62E9 2B           DEC  HL     
62EA 2B           DEC  HL     
62EB 22 B1 F6     LD   (LF6B1),HL 
62EE 23           INC  HL     
62EF 23           INC  HL     
62F0 CD DA FE     CALL LFEDA  
62F3 F9           LD   SP,HL  
62F4 21 7A F6     LD   HL,F67Ah 
62F7 22 78 F6     LD   (LF678),HL 
62FA CD 04 73     CALL L7304  
62FD CD FF 4A     CALL L4AFF  
6300 AF           XOR  A      
6301 67           LD   H,A    
6302 6F           LD   L,A    
6303 22 E6 00     LD   (L00E6),HL 


             org 8032h


8032 L8032:
8032 CD 1C 00     CALL L001C  
8035 DD E1        POP  IX     
8037 E1           POP  HL     
8038 23           INC  HL     
8039 18 E9        JR   L8024  


803B C9           defb C9h    
803C 00           defb 00h    
803D 46           defb 46h    
803E 69           defb 69h    
803F 6C           defb 6Ch    
8040 65           defb 65h    
8041 20           defb 20h    
8042 4E           defb 4Eh    
8043 4F           defb 4Fh    
8044 54           defb 54h    
8045 20           defb 20h    
8046 6C           defb 6Ch    
8047 6F           defb 6Fh    
8048 61           defb 61h    
8049 64           defb 64h    
804A 65           defb 65h    
804B 64           defb 64h    
804C 0D           defb 0Dh    
804D 0A           defb 0Ah    
804E 00           defb 00h    
804F 46           defb 46h    
8050 69           defb 69h    
8051 6C           defb 6Ch    
8052 65           defb 65h    
8053 20           defb 20h    
8054 6C           defb 6Ch    
8055 6F           defb 6Fh    
8056 61           defb 61h    
8057 64           defb 64h    
8058 65           defb 65h    
8059 64           defb 64h    
805A 0D           defb 0Dh    
805B 0A           defb 0Ah    
805C 00           defb 00h    
805D 46           defb 46h    
805E 69           defb 69h    
805F 6C           defb 6Ch    
8060 65           defb 65h    
8061 20           defb 20h    
8062 4E           defb 4Eh    
8063 4F           defb 4Fh    
8064 54           defb 54h    
8065 20           defb 20h    
8066 73           defb 73h    
8067 61           defb 61h    
8068 76           defb 76h    
8069 65           defb 65h    
806A 64           defb 64h    
806B 0D           defb 0Dh    
806C 0A           defb 0Ah    
806D 00           defb 00h    
806E 46           defb 46h    
806F 69           defb 69h    
8070 6C           defb 6Ch    
8071 65           defb 65h    
8072 20           defb 20h    
8073 73           defb 73h    
8074 61           defb 61h    
8075 76           defb 76h    
8076 65           defb 65h    
8077 64           defb 64h    
8078 0D           defb 0Dh    
8079 0A           defb 0Ah    
807A 00           defb 00h    
807B 7D           defb 7Dh    
807C D3           defb D3h    
807D 11           defb 11h    
807E C9           defb C9h    
807F 7D           defb 7Dh    
8080 D3           defb D3h    
8081 10           defb 10h    
8082 C9           defb C9h    
8083 DB           defb DBh    
8084 10           defb 10h    
8085 6F           defb 6Fh    
8086 C9           defb C9h    
8087 DB           defb DBh    
8088 11           defb 11h    
8089 6F           defb 6Fh    
808A C9           defb C9h    
808B FB           defb FBh    
808C C9           defb C9h    
808D F3           defb F3h    
808E C9           defb C9h    


808F L808F:
808F C1           POP  BC     
8090 E1           POP  HL     
8091 E5           PUSH HL     
8092 C5           PUSH BC     
8093 E5           PUSH HL     
8094 CD 1C 00     CALL L001C  


             org 82E3h


82E3 L82E3:
82E3 CD EE 82     CALL L82EE  
82E6 38 04        JR   C,L82EC 
82E8 CD C2 82     CALL L82C2  
82EB C9           RET         
82EC L82EC:
82EC F3           DI          
82ED 76           HALT        
82EE L82EE:
82EE 7D           LD   A,L    
82EF B4           OR   H      
82F0 C8           RET  Z      
82F1 EB           EX   DE,HL  
82F2 21 00 00     LD   HL,0000h 
82F5 ED 52        SBC  HL,DE  
82F7 4D           LD   C,L    
82F8 44           LD   B,H    
82F9 39           ADD  HL,SP  
82FA 3F           CCF         
82FB D8           RET  C      
82FC 7C           LD   A,H    
82FD FE C2        CP   C2h    
82FF D8           RET  C      
8300 ED 5B 48 FC  LD   DE,(LFC48) 
8304 ED 52        SBC  HL,DE  
8306 D8           RET  C      
8307 7C           LD   A,H    
8308 FE 02        CP   02h    
830A D8           RET  C      
830B C5           PUSH BC     
830C 21 00 00     LD   HL,0000h 
830F 39           ADD  HL,SP  
8310 5D           LD   E,L    
8311 54           LD   D,H    
8312 09           ADD  HL,BC  
8313 E5           PUSH HL     
8314 2A 74 F6     LD   HL,(LF674) 
8317 B7           OR   A      
8318 ED 52        SBC  HL,DE  
831A 4D           LD   C,L    
831B 44           LD   B,H    
831C 03           INC  BC     
831D E1           POP  HL     
831E F9           LD   SP,HL  
831F EB           EX   DE,HL  
8320 ED B0        LDIR        
8322 C1           POP  BC     
8323 2A 4A FC     LD   HL,(LFC4A) 
8326 09           ADD  HL,BC  
8327 22 4A FC     LD   (LFC4A),HL 
832A 11 EA FD     LD   DE,FDEAh 
832D 19           ADD  HL,DE  
832E 22 60 F8     LD   (LF860),HL 
8331 EB           EX   DE,HL  
8332 2A 72 F6     LD   HL,(LF672) 
8335 09           ADD  HL,BC  
8336 22 72 F6     LD   (LF672),HL 
8339 2A 62 F8     LD   HL,(LF862) 
833C 09           ADD  HL,BC  
833D 22 62 F8     LD   (LF862),HL 
8340 2A 74 F6     LD   HL,(LF674) 
8343 09           ADD  HL,BC  
8344 22 74 F6     LD   (LF674),HL 


             org 83A3h


83A3 L83A3:
83A3 FD 21 08 00  LD   IY,0008h 
83A7 FD 39        ADD  IY,SP  
83A9 E5           PUSH HL     
83AA C5           PUSH BC     
83AB F5           PUSH AF     
83AC CD B3 82     CALL L82B3  
83AF 01 3A 00     LD   BC,003Ah 
83B2 09           ADD  HL,BC  
83B3 FD 7E 00     LD   A,(IY+0) 
83B6 77           LD   (HL),A 
83B7 23           INC  HL     
83B8 FD 7E 01     LD   A,(IY+1) 
83BB 77           LD   (HL),A 
83BC 21 8A 83     LD   HL,838Ah 
83BF FD 75 00     LD   (IY+0),L 
83C2 FD 74 01     LD   (IY+1),H 
83C5 F1           POP  AF     
83C6 C1           POP  BC     
83C7 E1           POP  HL     
83C8 C9           RET         


83C9 E9           defb E9h    
83CA CD           defb CDh    
83CB B3           defb B3h    
83CC 82           defb 82h    
83CD EB           defb EBh    
83CE 21           defb 21h    
83CF 28           defb 28h    
83D0 00           defb 00h    
83D1 19           defb 19h    
83D2 4E           defb 4Eh    
83D3 23           defb 23h    
83D4 46           defb 46h    
83D5 2B           defb 2Bh    
83D6 79           defb 79h    
83D7 93           defb 93h    
83D8 20           defb 20h    
83D9 04           defb 04h    
83DA 78           defb 78h    
83DB 92           defb 92h    
83DC 28           defb 28h    
83DD 14           defb 14h    
83DE 79           defb 79h    
83DF 93           defb 93h    
83E0 4F           defb 4Fh    
83E1 78           defb 78h    
83E2 9A           defb 9Ah    
83E3 47           defb 47h    
83E4 E5           defb E5h    
83E5 D5           defb D5h    
83E6 C5           defb C5h    
83E7 D5           defb D5h    
83E8 CD           defb CDh    
83E9 A1           defb A1h    
83EA 8F           defb 8Fh    
83EB F1           defb F1h    
83EC F1           defb F1h    
83ED D1           defb D1h    
83EE E1           defb E1h    
83EF 73           defb 73h    
83F0 23           defb 23h    
83F1 72           defb 72h    
83F2 D5           defb D5h    
83F3 CD           defb CDh    
83F4 87           defb 87h    
83F5 80           defb 80h    
83F6 7D           defb 7Dh    
83F7 D1           defb D1h    
83F8 07           defb 07h    
83F9 38           defb 38h    
83FA 0A           defb 0Ah    
83FB D5           defb D5h    
83FC 3E           defb 3Eh    
83FD 01           defb 01h    
83FE F5           defb F5h    
83FF 33           defb 33h    
8400 CD           defb CDh    
8401 43           defb 43h    
8402 96           defb 96h    
8403 33           defb 33h    
8404 D1           defb D1h    
8405 21           defb 21h    
8406 35           defb 35h    
8407 00           defb 00h    
8408 19           defb 19h    
8409 C3           defb C3h    
840A C9           defb C9h    
840B 83           defb 83h    
840C DD           defb DDh    
840D E5           defb E5h    


             org 8758h


8758 L8758:
8758 CD E3 82     CALL L82E3  
875B CD D1 82     CALL L82D1  
875E CD E1 86     CALL L86E1  
8761 21 89 87     LD   HL,8789h 
8764 E5           PUSH HL     
8765 CD 8F 80     CALL L808F  
8768 F1           POP  AF     
8769 E1           POP  HL     
876A C9           RET         


876B 4D           defb 4Dh    
876C 53           defb 53h    
876D 58           defb 58h    
876E 55           defb 55h    
876F 53           defb 53h    
8770 42           defb 42h    
8771 20           defb 20h    
8772 54           defb 54h    
8773 65           defb 65h    
8774 72           defb 72h    
8775 6D           defb 6Dh    
8776 69           defb 69h    
8777 6E           defb 6Eh    
8778 61           defb 61h    
8779 6C           defb 6Ch    
877A 20           defb 20h    
877B 76           defb 76h    
877C 65           defb 65h    
877D 72           defb 72h    
877E 73           defb 73h    
877F 69           defb 69h    
8780 6F           defb 6Fh    
8781 6E           defb 6Eh    
8782 20           defb 20h    
8783 30           defb 30h    
8784 2E           defb 2Eh    
8785 32           defb 32h    
8786 0D           defb 0Dh    
8787 0A           defb 0Ah    
8788 00           defb 00h    
8789 2B           defb 2Bh    
878A 6E           defb 6Eh    
878B 65           defb 65h    
878C 77           defb 77h    
878D 20           defb 20h    
878E 43           defb 43h    
878F 48           defb 48h    
8790 47           defb 47h    
8791 45           defb 45h    
8792 54           defb 54h    
8793 20           defb 20h    
8794 69           defb 69h    
8795 6E           defb 6Eh    
8796 73           defb 73h    
8797 74           defb 74h    
8798 61           defb 61h    
8799 6C           defb 6Ch    
879A 6C           defb 6Ch    
879B 65           defb 65h    
879C 64           defb 64h    
879D 0D           defb 0Dh    
879E 0A           defb 0Ah    
879F 00           defb 00h    
87A0 DD           defb DDh    
87A1 E5           defb E5h    
87A2 DD           defb DDh    
87A3 21           defb 21h    
87A4 00           defb 00h    
87A5 00           defb 00h    
87A6 DD           defb DDh    
87A7 39           defb 39h    
87A8 F5           defb F5h    
87A9 F5           defb F5h    
87AA 3B           defb 3Bh    
87AB 21           defb 21h    
87AC FA           defb FAh    
87AD 87           defb 87h    
87AE E5           defb E5h    
87AF CD           defb CDh    
87B0 8F           defb 8Fh    
87B1 80           defb 80h    
87B2 21           defb 21h    
87B3 18           defb 18h    
87B4 88           defb 88h    
87B5 E3           defb E3h    
87B6 CD           defb CDh    
87B7 8F           defb 8Fh    
87B8 80           defb 80h    
87B9 21           defb 21h    
87BA 35           defb 35h    
87BB 88           defb 88h    


             org DB48h


DB48 LDB48:
DB48 FC 92 F3     CALL M,LF392 
DB4B 10 F0        DJNZ LDB3D  
DB4D C6 FD        ADD  A,FDh  
DB4F D1           POP  DE     
DB50 LDB50:
DB50 10 FF        DJNZ LDB50+1 
DB52 83           ADD  A,E    
DB53 D6 00        SUB  00h    
DB55 A8           XOR  B      
DB56 FC EA 23     CALL M,L23EA 
DB59 67           LD   H,A    
DB5A 41           LD   B,C    
DB5B 00           NOP         
DB5C 00           NOP         
DB5D 00           NOP         
DB5E 00           NOP         
DB5F 03           INC  BC     
DB60 00           NOP         
DB61 A2           AND  D      
DB62 00           NOP         
DB63 00           NOP         
DB64 40           LD   B,B    
DB65 30 6B        JR   NC,LDBD2 
DB67 32 6B 05     LD   (L056B),A 
DB6A 01 C1 0A     LD   BC,0AC1h 
DB6D 68           LD   L,B    
DB6E 09           ADD  HL,BC  
DB6F 88           ADC  A,B    
DB70 09           ADD  HL,BC  
DB71 30 09        JR   NC,LDB7C 
DB73 0C           INC  C      
DB74 0A           LD   A,(BC) 
DB75 54           LD   D,H    
DB76 6B           LD   L,E    
DB77 41           LD   B,C    
DB78 39           ADD  HL,SP  
DB79 87           ADD  A,A    
DB7A 87           ADD  A,A    
DB7B 92           SUB  D      
DB7C LDB7C:
DB7C F3           DI          
DB7D 54           LD   D,H    
DB7E D0           RET  NC     
DB7F 35           DEC  (HL)   
DB80 80           ADD  A,B    
DB81 42           LD   B,D    
DB82 87           ADD  A,A    
DB83 LDB83:
DB83 87           ADD  A,A    
DB84 87           ADD  A,A    
DB85 4B           LD   C,E    
DB86 DB C4        IN   A,(00C4h) 
DB88 FF           RST  38h    
DB89 E6 82        AND  82h    
DB8B 5B           LD   E,E    
DB8C 87           ADD  A,A    
DB8D 00           NOP         
DB8E 80           ADD  A,B    
DB8F 92           SUB  D      
DB90 F3           DI          
DB91 10 F0        DJNZ LDB83  
DB93 D4 FE A4     CALL NC,LA4FE 
DB96 62           LD   H,D    
DB97 01 46 00     LD   BC,0046h 
DB9A FF           RST  38h    
DB9B 00           NOP         
DB9C FF           RST  38h    
DB9D 00           NOP         
DB9E FF           RST  38h    
DB9F 00           NOP         
DBA0 FF           RST  38h    
DBA1 00           NOP         
DBA2 FF           RST  38h    
DBA3 00           NOP         
DBA4 FF           RST  38h    
DBA5 00           NOP         
DBA6 FF           RST  38h    
DBA7 00           NOP         
DBA8 FF           RST  38h    
DBA9 00           NOP         
DBAA FF           RST  38h    
DBAB 00           NOP         


             org F38Fh


F38F LF38F:
F38F CD 98 F3     CALL LF398  


F392 LF392:
F392 08           EX   AF,AF' 
F393 F1           POP  AF     
F394 D3 A8        OUT  (00A8h),A 
F396 08           EX   AF,AF' 
F397 C9           RET         


F398 LF398:
F398 DD E9        JP   (IX)   


F39A 5A           defb 5Ah    
F39B 47           defb 47h    
F39C 5A           defb 5Ah    
F39D 47           defb 47h    
F39E 5A           defb 5Ah    
F39F 47           defb 47h    
F3A0 5A           defb 5Ah    
F3A1 47           defb 47h    
F3A2 5A           defb 5Ah    
F3A3 47           defb 47h    
F3A4 5A           defb 5Ah    
F3A5 47           defb 47h    
F3A6 5A           defb 5Ah    
F3A7 47           defb 47h    
F3A8 5A           defb 5Ah    
F3A9 47           defb 47h    
F3AA 5A           defb 5Ah    
F3AB 47           defb 47h    
F3AC 5A           defb 5Ah    
F3AD 47           defb 47h    
F3AE 25           defb 25h    
F3AF 1D           defb 1Dh    
F3B0 25           defb 25h    
F3B1 18           defb 18h    
F3B2 0E           defb 0Eh    
F3B3 00           defb 00h    
F3B4 00           defb 00h    
F3B5 00           defb 00h    
F3B6 08           defb 08h    
F3B7 00           defb 00h    
F3B8 08           defb 08h    
F3B9 00           defb 00h    
F3BA 00           defb 00h    
F3BB 00           defb 00h    
F3BC 00           defb 00h    
F3BD 00           defb 00h    
F3BE 18           defb 18h    
F3BF 00           defb 00h    
F3C0 20           defb 20h    
F3C1 00           defb 00h    
F3C2 00           defb 00h    
F3C3 00           defb 00h    
F3C4 1B           defb 1Bh    
F3C5 00           defb 00h    
F3C6 38           defb 38h    
F3C7 00           defb 00h    
F3C8 18           defb 18h    
F3C9 00           defb 00h    
F3CA 20           defb 20h    
F3CB 00           defb 00h    
F3CC 00           defb 00h    
F3CD 00           defb 00h    
F3CE 1B           defb 1Bh    
F3CF 00           defb 00h    
F3D0 38           defb 38h    
F3D1 00           defb 00h    
F3D2 08           defb 08h    
F3D3 00           defb 00h    
F3D4 00           defb 00h    
F3D5 00           defb 00h    
F3D6 00           defb 00h    
F3D7 00           defb 00h    
F3D8 1B           defb 1Bh    
F3D9 00           defb 00h    
F3DA 38           defb 38h    
F3DB FF           defb FFh    


F3DC LF3DC:
F3DC 08           defb 08h    


F3DD LF3DD:
F3DD 08           defb 08h    
F3DE FF           defb FFh    
F3DF 00           defb 00h    
F3E0 70           defb 70h    
F3E1 00           defb 00h    
F3E2 80           defb 80h    
F3E3 01           defb 01h    
F3E4 36           defb 36h    
F3E5 07           defb 07h    
F3E6 F4           defb F4h    
F3E7 9F           defb 9Fh    
F3E8 F1           defb F1h    
F3E9 0F           defb 0Fh    
F3EA 04           defb 04h    
F3EB 04           defb 04h    
F3EC C3           defb C3h    
F3ED 00           defb 00h    
F3EE 00           defb 00h    
F3EF C3           defb C3h    
F3F0 00           defb 00h    
F3F1 00           defb 00h    
F3F2 0F           defb 0Fh    