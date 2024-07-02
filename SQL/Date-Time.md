DATE ONLY FORMATS
Format #	Query	Format	Sample
1	select convert(varchar, getdate(), 1)	mm/dd/yy	12/30/22
2	select convert(varchar, getdate(), 2)	yy.mm.dd	22.12.30
3	select convert(varchar, getdate(), 3)	dd/mm/yy	30/12/22
4	select convert(varchar, getdate(), 4)	dd.mm.yy	30.12.22
5	select convert(varchar, getdate(), 5)	dd-mm-yy	30-12-22
6	select convert(varchar, getdate(), 6)	dd-Mon-yy	30 Dec 22
7	select convert(varchar, getdate(), 7)	Mon dd, yy	Dec 30, 22
10	select convert(varchar, getdate(), 10)	mm-dd-yy	12-30-22
11	select convert(varchar, getdate(), 11)	yy/mm/dd	22/12/30
12	select convert(varchar, getdate(), 12)	yymmdd	221230
23	select convert(varchar, getdate(), 23)	yyyy-mm-dd	2022-12-30
31	select convert(varchar, getdate(), 31)	yyyy-dd-mm	2022-30-12
32	select convert(varchar, getdate(), 32)	mm-dd-yyyy	12-30-2022
33	select convert(varchar, getdate(), 33)	mm-yyyy-dd	12-2022-30
34	select convert(varchar, getdate(), 34)	dd-mm-yyyy	30-12-2022
35	select convert(varchar, getdate(), 35)	dd-yyyy-mm	30-2022-12
101	select convert(varchar, getdate(), 101)	mm/dd/yyyy	12/30/2022
102	select convert(varchar, getdate(), 102)	yyyy.mm.dd	2022.12.30
103	select convert(varchar, getdate(), 103)	dd/mm/yyyy	30/12/2022
104	select convert(varchar, getdate(), 104)	dd.mm.yyyy	30.12.2022
105	select convert(varchar, getdate(), 105)	dd-mm-yyyy	30-12-2022
106	select convert(varchar, getdate(), 106)	dd Mon yyyy	30 Dec 2022
107	select convert(varchar, getdate(), 107)	Mon dd, yyyy	Dec 30, 2022
110	select convert(varchar, getdate(), 110)	mm-dd-yyyy	12-30-2022
111	select convert(varchar, getdate(), 111)	yyyy/mm/dd	2022/12/30
112	select convert(varchar, getdate(), 112)	yyyymmdd	20221230
 	
TIME ONLY FORMATS
8	select convert(varchar, getdate(), 8)	hh:mm:ss	00:38:54
14	select convert(varchar, getdate(), 14)	hh:mm:ss:nnn	00:38:54:840
24	select convert(varchar, getdate(), 24)	hh:mm:ss	00:38:54
108	select convert(varchar, getdate(), 108)	hh:mm:ss	00:38:54
114	select convert(varchar, getdate(), 114)	hh:mm:ss:nnn	00:38:54:840
 	
DATE & TIME FORMATS
0	select convert(varchar, getdate(), 0)	Mon dd yyyy hh:mm AM/PM	Dec 30 2022 12:38AM
9	select convert(varchar, getdate(), 9)	Mon dd yyyy hh:mm:ss:nnn AM/PM	Dec 30 2022 12:38:54:840AM
13	select convert(varchar, getdate(), 13)	dd Mon yyyy hh:mm:ss:nnn AM/PM	30 Dec 2022 00:38:54:840AM
20	select convert(varchar, getdate(), 20)	yyyy-mm-dd hh:mm:ss	2022-12-30 00:38:54
21	select convert(varchar, getdate(), 21)	yyyy-mm-dd hh:mm:ss:nnn	2022-12-30 00:38:54.840
22	select convert(varchar, getdate(), 22)	mm/dd/yy hh:mm:ss AM/PM	12/30/22 12:38:54 AM
25	select convert(varchar, getdate(), 25)	yyyy-mm-dd hh:mm:ss:nnn	2022-12-30 00:38:54.840
26	select convert(varchar, getdate(), 26)	yyyy-dd-mm hh:mm:ss:nnn	2022-30-12 00:38:54.840
27	select convert(varchar, getdate(), 27)	mm-dd-yyyy hh:mm:ss:nnn	12-30-2022 00:38:54.840
28	select convert(varchar, getdate(), 28)	mm-yyyy-dd hh:mm:ss:nnn	12-2022-30 00:38:54.840
29	select convert(varchar, getdate(), 29)	dd-mm-yyyy hh:mm:ss:nnn	30-12-2022 00:38:54.840
30	select convert(varchar, getdate(), 30)	dd-yyyy-mm hh:mm:ss:nnn	30-2022-12 00:38:54.840
100	select convert(varchar, getdate(), 100)	Mon dd yyyy hh:mm AM/PM	Dec 30 2022 12:38AM
109	select convert(varchar, getdate(), 109)	Mon dd yyyy hh:mm:ss:nnn AM/PM	Dec 30 2022 12:38:54:840AM
113	select convert(varchar, getdate(), 113)	dd Mon yyyy hh:mm:ss:nnn	30 Dec 2022 00:38:54:840
120	select convert(varchar, getdate(), 120)	yyyy-mm-dd hh:mm:ss	2022-12-30 00:38:54
121	select convert(varchar, getdate(), 121)	yyyy-mm-dd hh:mm:ss:nnn	2022-12-30 00:38:54.840
126	select convert(varchar, getdate(), 126)	yyyy-mm-dd T hh:mm:ss:nnn	2022-12-30T00:38:54.840
127	select convert(varchar, getdate(), 127)	yyyy-mm-dd T hh:mm:ss:nnn	2022-12-30T00:38:54.840