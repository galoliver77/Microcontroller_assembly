# RV32I 32 bites előjeles osztás assemblyben

Ez a projekt egy 32 bites előjeles osztást megvalósító assembly szubrutin RISC-V RV32I utasításkészletre.  
A megoldás nem használ hardveres osztóutasításokat, az osztás teljes egészében szoftverből történik, nem visszaállításos (non-restoring) algoritmussal.

A projekt fő célja az volt, hogy jobban megértsem:

- az alacsony szintű algoritmusimplementációt
- az előjeles számkezelést assemblyben
- a bitműveletek és shiftelések gyakorlati használatát
- egy iteratív aritmetikai algoritmus működését regiszterszinten

A kód kezeli:

- pozitív és negatív operandusokat
- maradékszámítást
- 0-val való osztást

A részletes működésről és az algoritmus lépéseiről a mellékelt dokumentáció tartalmaz leírást.
