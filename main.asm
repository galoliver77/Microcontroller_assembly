// -----------------------------------------------------------
// Mikrokontroller alapú rendszerek házi feladat
// Készítette: Gál Olivér
// Neptun kód: P5DKSP
// Feladat leírása:
//	Tegyük fel, hogy olyan mikrokontrollere van, amelyik csak az RV32I utasításkészlettel rendelkezik,
//  tehát a szorzó-osztó utasításokat nem ismeri.
//  Készítse el a paraméterként kapott  két darab 32 bites előjeles szám nem visszaállításos osztását elvégző szubrutint,
//  az eredmény 32 bites hányados és 32 bites maradék.
//  Bemenet: osztandó, osztó (értékek regiszterekben). Kimenet: eredmény, maradék (értékek regiszterekben),
//  és egy harmadik regiszter jelezze, ha az osztó 0 volt (=0/1).
// -----------------------------------------------------------

.global main 		// main címke exportálása (globálissá tétele)


.text
// ------------------------------------------------------------
// Főprogram
// ------------------------------------------------------------
main:
	li 		a0, 10	  		// Példa osztandó
	li 		a1, 0			// Példa osztó
	call	Division_32 	// Osztó szunrutin hívás

	j	 	0 				// végtelen ciklusban várunk

// -----------------------------------------------------------
// Division szubrutin
// -----------------------------------------------------------
// Funkció: 		2 db 32 bites előjeles szám osztása
// Bementek:		a0 - Osztandó
//					a1 - Osztó

// Kimenetek:		a0 - Hányados
// Változik:		a1 - Maradék
//					a2 - Esetleges 0-val való osztást jelző flag
// -----------------------------------------------------------

Division_32:

Zero_test:
    beq a1, x0, div_zero //0-val való osztás flagje

    // Előjelek elmentése (0/1 formában)
    xor  t0, a0, a1
    srli t0, t0, 31          // t0 = 1 ha a hányados negatív
    srli t1, a0, 31          // t1 = 1 ha a maradék negatív (osztandó előjele)

    // Abszolútértékre hozás
    bge  a0, x0, abs_divisor
    sub  a0, x0, a0 //Ha negatív, 0-ból való kivonással pozitív lesz

abs_divisor:
    bge  a1, x0, setup
    sub  a1, x0, a1

// -----------------------------------------------------------
// NON-RESTORING osztás (32 iteráció)
// -----------------------------------------------------------
setup:
    li   t2, 0               // Hányados
    li   t3, 0               // Maradék
    li   t4, 32              // 32 bit

div_loop:

    slli t3, t3, 1 			//Maradék shiftelése, ,,helyet" csinálunk az osztandó MSB-jének
    srli t5, a0, 31 		//Osztandó MSB-je
    or   t3, t3, t5 		//Osztandó MSB beírása Maradék LSB-be


    slli a0, a0, 1 //A következő ciklusban már a következő ,,új" MSB-t vesszük az osztandóból

//A shiftelt maradék előjelét vizsgáljuk, ez alapján döntünk plus / minus műveletről

    slt  a2, t3, x0          // a2 = 1 ha Maradék < 0
    bne  a2, x0, plus      	 // ha Maradék <0 -> plus

minus:
    sub  t3, t3, a1          // Maradék = Maradék - Osztó
     j    set_quotient

plus:
    add  t3, t3, a1          // Maradék = Maradék + Osztó

set_quotient:
    slli t2, t2, 1			 // Hányados eltolása, ,,helyet" csinálunk az új LSB-nek
    slt  a2, t3, x0          // a2 = 1 ha Maradék < 0
    bne  a2, x0, cycle_test   // ha Maradék  <0 -> Hányados LSB = 0
    addi t2, t2, 1           // ha Maradék >=0 -> Hányados LSB = 1

cycle_test:
    addi t4, t4, -1  		//Iteráló csökkentés
    bne  t4, x0, div_loop	//Ha még nem 0, ciklus elejére ugrás

// 5) Maradék korrekció: ha R < 0 -> R = R + D
last_step:
    slt  a2, t3, x0
    beq  a2, x0, sign_fix
    add  t3, t3, a1

// 6) Előjel visszaállítás
sign_fix:
    beq  t0, x0, rem_sign
    sub  t2, x0, t2          // hányados negálása

rem_sign:
    beq  t1, x0, done
    sub  t3, x0, t3          // maradék negálása

done:
    mv   a0, t2
    mv   a1, t3
    li   a2, 0
    ret

div_zero:
    li a0, 0
    li a1, 0
    li a2, 1
    ret

