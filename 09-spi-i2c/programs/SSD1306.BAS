5 REM Communicate via I2C with an SSD1306 OLED display
10 BA=&H40:REM SPI/I2C card base address
11 IA=&H3C:REM SSD1306 OLED I2C address
12 CR=BA+2:DR=BA+3:CM=&H80:DM=&H40
13 OUT CR,0
15 :
20 GOSUB 1100:REM initialize OLED
30 GOSUB 1300:REM clear screem
40 GOSUB 1900:REM read font data
50 S$="HELLO WORLD!":C=0:R=0:GOSUB 1500
90 END
999 :
1000 REM --- send command in D
1010 OUT DR,2:OUT CR,IA OR 128:OUT DR,CM:OUT DR,D
1015 IF INP(CR) AND 128 THEN 1015
1017 IF INP(CR)<>0 THEN PRINT "WRITE ERROR:";INP(CR):END
1020 IF INP(CR) AND 128 THEN 1020
1030 IF INP(CR)<>0 THEN PRINT "WRITE CMD ERROR:";D;INP(CR):END
1040 RETURN
1099 :
1100 REM --- send init sequence
1105 PRINT "initializing display..."
1110 READ D:IF D>=0 THEN GOSUB 1000:GOTO 1110
1120 RETURN
1130 DATA &HAE,&HA8,&H1F,&HD3,&H00,&H20,&H00,&HB0,&H00,&H10
1140 DATA &H40,&H81,&HCF,&HA1,&HC8,&HA6,&HD5,&H80,&HD9,&HF1
1150 DATA &HDA,&H02,&HDB,&H30,&H2E,&H8D,&H14,&HAF,-1
1199 :
1200 REM --- send "clip area" command (C, R, W, H)
1210 OUT DR,5:OUT CR,IA OR 128
1220 OUT DR,CM:OUT DR,&H21:OUT DR,0:OUT DR,C:OUT DR,C+W-1
1230 IF INP(CR) AND 128 THEN 1230
1240 IF INP(CR)<>0 THEN PRINT "CLIPC CMD ERROR:";INP(CR):END
1250 OUT DR,5:OUT CR,IA OR 128
1260 OUT DR,CM:OUT DR,&H22:OUT DR,0:OUT DR,R:OUT DR,R+H-1
1270 IF INP(CR) AND 128 THEN 1270
1280 IF INP(CR)<>0 THEN PRINT "CLIPR CMD ERROR:";INP(CR):END
1290 RETURN
1299 :
1300 REM --- clear screen
1305 PRINT "clearing screen..."
1310 R=0:C=0:W=128:H=4:GOSUB 1200
1320 FOR I=1 TO 17
1330 OUT DR,32:OUT CR,IA OR 128:OUT DR,DM
1340 FOR J=1 TO 31:OUT DR,0:NEXT J
1350 IF INP(CR) AND 128 THEN 1350
1360 IF INP(CR)<>0 THEN PRINT "CLR ERROR:";INP(CR):END
1370 NEXT I
1380 RETURN
1390 :
1400 REM --- print character c at position r, c
1405 IF CH<32 OR CH>95 THEN RETURN
1407 CH=CH-32
1410 C=C*6:W=6:H=1:GOSUB 1200
1420 OUT DR,7:OUT CR,IA OR 128:OUT DR,DM
1450 FOR I=0 TO 4:OUT DR,FT(CH,I):NEXT I
1460 OUT DR,0
1470 IF INP(CR) AND 128 THEN 1470
1480 IF INP(CR)<>0 THEN PRINT "PRINT ERROR:";INP(CR):END
1490 RETURN
1499 :
1500 REM --- print string s at position r,c
1505 CC=C
1510 FOR J=1 TO LEN(S$)
1520 C=CC:CH=ASC(MID$(S$,J,1)):GOSUB 1400
1525 CC=CC+1
1530 NEXT J
1540 RETURN
1599 :
1900 REM --- read font data
1905 PRINT "reading font data..."
1910 DIM FT(94,5)
1920 FOR I=0 TO 63:FOR J=0 TO 4:READ FT(I,J):NEXT J,I
1930 RETURN
1999 :
2000 REM --- 5x7 font data (ASCII 32-126) ---
2005 DATA 0,0,0,0,0
2010 DATA 0,0,95,0,0,0,7,0,7,0,20,127,20,127,20
2020 DATA 36,42,127,42,18,35,19,8,100,98,54,73,86,32,80
2030 DATA 0,8,7,3,0,0,28,34,65,0,0,65,34,28,0
2040 DATA 42,28,127,28,42,8,8,62,8,8,0,128,112,48,0
2050 DATA 8,8,8,8,8,0,0,96,96,0,32,16,8,4,2
2060 DATA 62,81,73,69,62,0,66,127,64,0,114,73,73,73,70
2070 DATA 33,65,73,77,51,24,20,18,127,16,39,69,69,69,57
2080 DATA 60,74,73,73,49,65,33,17,9,7,54,73,73,73,54
2090 DATA 70,73,73,41,30,0,0,20,0,0,0,64,52,0,0
2100 DATA 0,8,20,34,65,20,20,20,20,20,0,65,34,20,8
2110 DATA 2,1,89,9,6,62,65,93,89,78,124,18,17,18,124
2120 DATA 127,73,73,73,54,62,65,65,65,34,127,65,65,65,62
2130 DATA 127,73,73,73,65,127,9,9,9,1,62,65,65,81,115
2140 DATA 127,8,8,8,127,0,65,127,65,0,32,64,65,63,1
2150 DATA 127,8,20,34,65,127,64,64,64,64,127,2,28,2,127
2160 DATA 127,4,8,16,127,62,65,65,65,62,127,9,9,9,6
2170 DATA 62,65,81,33,94,127,9,25,41,70,38,73,73,73,50
2180 DATA 3,1,127,1,3,63,64,64,64,63,31,32,64,32,31
2190 DATA 63,64,56,64,63,99,20,8,20,99,3,4,120,4,3
2200 DATA 97,89,73,77,67,0,127,65,65,65,2,4,8,16,32
2210 DATA 0,65,65,65,127,4,2,1,2,4,64,64,64,64,64
2220 DATA 0,3,7,8,0,32,84,84,120,64,127,40,68,68,56
2230 DATA 56,68,68,68,40,56,68,68,40,127,56,84,84,84,24
2240 DATA 0,8,126,9,2,24,164,164,156,120,127,8,4,4,120
2250 DATA 0,68,125,64,0,32,64,64,61,0,127,16,40,68,0
2260 DATA 0,65,127,64,0,124,4,120,4,120,124,8,4,4,120
2270 DATA 56,68,68,68,56,252,24,36,36,24,24,36,36,24,252
2280 DATA 124,8,4,4,8,72,84,84,84,36,4,4,63,68,36
2290 DATA 60,64,64,32,124,28,32,64,32,28,60,64,48,64,60
2300 DATA 68,40,16,40,68,76,144,144,144,124,68,100,84,76,68
2310 DATA 0,8,54,65,0,0,0,119,0,0,0,65,54,8,0
2320 DATA 2,1,2,4,2
