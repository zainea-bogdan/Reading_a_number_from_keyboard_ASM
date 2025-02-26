model small
.stack 200h

.data
   intreg dw 0 
   semn db 00h
   numero dd 0
   expo db 127
   temp dw 0
.code

    main:
        mov ax, @data
        mov ds, ax
        
        mov cx, 10
        xor bx, bx

        citireintreg:
            ;invoc citirea unui caracter de la tastatura
            mov ah, 01h
            int 21h
            ;compar tasta introdusa cu enter si dupa cu caracterul "-"
            cmp al,13
                je citirefractie
            cmp al, 45
                je negativ
            ;transformare din ascii in cod efectiv
            sub al, 48
            mov bl, al
            mov ax, intreg
            mul cx
            add ax, bx
            mov intreg, ax
            jmp citireintreg
        ;schimba bitul de semn daca este cazul din 0 in 1
        negativ:    
            mov semn,1
            jmp citireintreg

        citirefractie:
            ; ne asiguram ca registri sunt 0 
            xor dx,dx
            xor cx,cx 
            xor bx,bx

            mov dx,intreg
            
            ;aici gen am calculat de cate ori va fi mutata virgula in intreg 
            ;rezultatul e stocat in cx= contorul de biti
            comparare:
                ; am comparat daca dx este egal cu 1;
                cmp dx,1
                    je exponent_calcul
                ; daca nu este egal cu unu, at shiftez la dreapta dx cu 1 si maresc cu 1 contorul cx = care reprezinta numarul de biti care trebuie mutati si care de asemenea reprezinta si exponentul real
                shr dx,1
                inc cx
                jmp comparare

            ;aici adauga la 127 val expo real
            exponent_calcul:
                mov bl, expo
                add bl,cl
                mov expo, bl
                jmp mutare_in_fractie
            ; aici gen am transformat numarul intreg in biti care trebuie mutati in mantisa: adica basically am rotit biti de trebuiau transferati in fata si ultimul bit care e 100% un 1, este shiftat afara si apoi shiftam inapoi astfel incat primi biti sa fie biti trasnferati in mantisa in urma procesorului de normalizare
            mutare_in_fractie:
                mov dx,intreg 
                mutare_biti:
                    ror dx,1
                loop mutare_biti
                shr dx,1
                shl dx,1
                mov intreg, dx
                jmp finalizare
        
        
        finalizare:
         					; tin minte semnul
            xor ax,ax
            mov al, semn

						; daca nu e 0 am semn, baga un bit de 1
						cmp al, 0
						je skipSemn
						; adauga un 1
						add cx, 1
						skipSemn:
						; da-l la stanga, treci la urm bit
						shl cx, 1

						; plasez exponent
						; tin minte numarul in bx, ca in loop am nevoie de cx
						mov bx, cx
						mov cx, 8
						; folosesc temporat ax, ca sa fac comparari pe biti
						xor ax, ax
                        mov dl, expo 

						plaseazaExp:
							; copiaza exponentul
							mov al, dl
							; obtine doar ultimul bit
							and al, 1
							; adauga-l la rezulat
							add bl, al
							; taie un bit(trece la urmatorul)
							shr dl, 1
							; daca sunt la ultimul bit nu mai fac loc de alti biti
							cmp cx, 1
							je skipPlasareExp
							; fa loc in rezultat pentru urmatorul bit
							shl bl, 1
						loop plaseazaExp
						skipPlasareExp:

						; plasez primii 7 biti din mantisa
						; tin minte numarul in bx, ca in loop am nevoie de cx
						mov cx, 7
						; folosesc temporat ax, ca sa fac comparari pe biti
						xor ax, ax
                        mov dx, intreg 

						plaseazaMantisa1:
							; copiaza exponentul
							mov al, dl
							; obtine doar ultimul bit
							and al, 1
							; adauga-l la rezulat
							add bl, al
							; taie un bit(trece la urmatorul)
							shr dl, 1
							; daca sunt la ultimul bit nu mai fac loc de alti biti
							cmp cx, 1
							je skipMantisa1
							; fa loc in rezultat pentru urmatorul bit
							shl bl, 1
						loop plaseazaMantisa1
						skipMantisa1:
						mov si, offset numero
						mov [si], bx

						mov bx, 0
						; plasez primii 7 biti din mantisa
						; tin minte numarul in bx, ca in loop am nevoie de cx
						mov cx, 7
						; folosesc temporat ax, ca sa fac comparari pe biti
						xor ax, ax

						plaseazaMantisa2:
							; copiaza exponentul
							mov al, dl
							; obtine doar ultimul bit
							and al, 1
							; adauga-l la rezulat
							add bl, al
							; taie un bit(trece la urmatorul)
							shr dl, 1
							; daca sunt la ultimul bit nu mai fac loc de alti biti
							cmp cx, 1
							je skipMantisa2
							; fa loc in rezultat pentru urmatorul bit
							shl bl, 1
						loop plaseazaMantisa2
						skipMantisa2:
						mov si, offset numero + 2
						mov [si], bx


            ;de mai devreme am bl facut ca expo 
            ;de mai devreme am dx facut ca intreg

        ;incheiere program
        mov ah, 4ch
        int 21h
	end main
