5 s=54272:x=8
10 forl=stos+24:pokel,0:next
20 pokes+5,9:pokes+6,155
30 pokes+24,15
40 readhf,lf,dr
50 ifhf<0thenend
60 pokes+1,hf+x:pokes,lf
70 pokes+4,17
80 fort=1todr-30:next
90 pokes+4,16:fort=1to50:next
100 goto40
110 data25,175,400,35,214,75
120 data45,214,75,55,177,75
130 data77,177,125,-1,-1,-1