^ESC::ExitApp
^F3::
	GOSUB AGGIUNGI_CONTATTO
	return
; PARTE IL PROGRAMMA CON CTRL+F2
^F2::

; Chiede se vogliamo usare l'automazione dal file ultima.txt o inserire manualmente range schede
MsgBox , 4, AUTOMAZIONE, VUOI USARE AUTOMAZIONE?,
IfMsgBox Yes
    GOSUB AUTOMAZIONE
else
    GOSUB INPUT_RANGE_SCHEDE

while quantitaSchede>=0
    {
		GOSUB ATTIVA_GESAT
		; Invia il numero di scheda al Gesat
		Send, %schedaIniziale%{ENTER}
		Sleep, 250
		; Due volte Invio per le schede con note o spedite
		Send, {ENTER}
		Sleep, 250
		Send, {ENTER}
		;GOSUB COPIA_N_SCHEDA
		;numScheda = %Clipboard%
		;Sleep, 250
		GOSUB COPIA_N_TEL
		numTel = %Clipboard%
		; Controlla se la scheda ha il numero di telefono o è rimasto bianco causa nota su storico
		if numTel <> 
		{
			; La scheda ha un numero di telefono, continua la registrazione del nome
			Sleep, 250
			GOSUB COPIA_NOME
			nome = %Clipboard%
			; Va a scrivere il vile vcf
			GOSUB CREA_VCARD
			SoundBeep, 1975, 300
			; Aggiorna i contatori
			schedaIniziale := schedaIniziale + 1
			quantitaSchede := schedaFinale - schedaIniziale
			Send, {Esc}
		}
		else
		{
			; La scheda non ha numero di telefono, cioè è sullo storico. Annota il numero di scheda su file
			gosub ANNOTA_STORICO
			SoundBeep, 987, 150
			; Aggiorna i contatori
			schedaIniziale := schedaIniziale + 1
			quantitaSchede := schedaFinale - schedaIniziale
			Send, {Esc}
		}
	}
	GOSUB AGGIORNA_FILE_ULTIMA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	

ATTIVA_GESAT:
	#WinActivateForce
	WinActivate, server2015 - Connessione Desktop remoto ahk_class TscShellContainerClass ahk_exe mstsc.exe
	RETURN

;Crea file di testo con il numero di scheda nome storico trovata
ANNOTA_STORICO:
	FileAppend, %schedaIniziale%`n , C:\Users\Giorgio\Desktop\VCARD\STORICO\storico.txt
	SoundBeep, 987, 150
	return

AUTOMAZIONE:
	GOSUB LEGGI_ULTIMA_FATTA
	GOSUB LEGGI_ULTIMA_DA_FARE
	RETURN
	
; Legge ultima scheda messa in VCF
LEGGI_ULTIMA_FATTA:
	FileReadLine, schedaIniziale, C:\Users\Giorgio\Desktop\VCARD\STORICO\ultima.txt, 1 
	schedaIniziale := schedaIniziale + 1
	MsgBox, , ,INIZIA DA %schedaIniziale% COMPRESO
	if ErrorLevel
        	RETURN
	;schedaIniziale = %Clipboard%
	;Filedelete, C:\Users\Giorgio\Desktop\VCARD\STORICO\ultima.txt
	;SoundBeep, 987, 150
	return

; Legge valore da gesat e lo salva come scheda da terminare
LEGGI_ULTIMA_DA_FARE:
	GOSUB COPIA_N_SCHEDA
	schedaFinale = %Clipboard%
	schedaFinale := schedaFinale - 1
	;FileAppend, %schedaFinale%`n , C:\Users\Giorgio\Desktop\VCARD\STORICO\ultima.txt
	;SoundBeep, 987, 150
	quantitaSchede := schedaFinale - schedaIniziale
	schedeFatte = %schedaIniziale%-%schedaFinale%
	MsgBox, , ,FAREMO %schedeFatte%
	return
	
AGGIORNA_FILE_ULTIMA:
	Filedelete, C:\Users\Giorgio\Desktop\VCARD\STORICO\ultima.txt
	FileAppend, %schedaFinale%`n , C:\Users\Giorgio\Desktop\VCARD\STORICO\ultima.txt
	MsgBox, , ,AGGIORNATO FILE ULTIMA
	return
	
;Crea file VCARD con i contatti selezionati
CREA_VCARD:
	FileAppend, BEGIN:VCARD`n`VERSION:2.1`n`N:%nome%`n`FN:%nome%`n`TEL;CELL;PREF:%numTel%`n`END:VCARD`n, C:\Users\Giorgio\Desktop\VCARD\%schedeFatte%.vcf
	SoundBeep, 987, 500
	return

COPIA_N_TEL:
	;GOSUB ATTIVA_GESAT
	Click, 668, 148 Left, Down
	Sleep, 100
	Click, 780, 148 Left, Up
	Sleep, 100
	Click, 765, 148 Right, Down
	Click, 765, 148 Right, Up
	Sleep, 100
	return

COPIA_NOME:
	;GOSUB ATTIVA_GESAT
	Click, 182, 148 Left, Down
	Sleep, 100
	Click, 532, 148 Left, Up
	Sleep, 100
	Click, 765, 148 Right, Down
	Click, 765, 148 Right, Up
	Sleep, 100
	return
	
INPUT_RANGE_SCHEDE:
	InputBox, schedaIniziale, SCHEDA INIZIALE, Inserisci il numero di scheda da cui iniziare (Compreso):, 320, 240
	if ErrorLevel
	{
		MsgBox, Stai uscendo dal programma.
		return
	}
	else
	{
		InputBox, schedaFinale, %schedaIniziale%, Inserisci il numero di scheda con cui terminare (Compreso):, 320, 240
		if ErrorLevel
		{
			MsgBox, Stai uscendo dal programma.
			return
		}
		else
		{
		quantitaSchede := schedaFinale - schedaIniziale
		schedeFatte = %schedaIniziale%-%schedaFinale%
		MsgBox, , ,%schedeFatte%
		}
	}
	;MsgBox, , ,%quantitaSchede%
	RETURN

COPIA_N_SCHEDA:
	GOSUB ATTIVA_GESAT
	Click, 273, 126 Left, Down
	Sleep, 100
	Click, 233, 126 Left, Up
	Sleep, 100
	Click, 765, 148 Right, Down
	Click, 765, 148 Right, Up
	Sleep, 100
	RETURN

AGGIUNGI_CONTATTO:
	SoundBeep, 1244, 300
	SoundBeep, 932, 500
	InputBox, numTel, Inserisci Numero, Inserisci il numero di cellulare del cliente, 320, 240
	InputBox, nome, Inserisci Nome, Inserisci il nome del cliente, 320, 240
	FileAppend, BEGIN:VCARD`n`VERSION:2.1`n`N:%nome%`n`FN:%nome%`n`TEL;CELL;PREF:%numTel%`n`END:VCARD`n, C:\Users\Giorgio\Desktop\VCARD\%nome%.vcf
	SoundBeep, 987, 500
	MsgBox, 4, , Altri numeri?
	IfMsgBox Yes
		GOSUB AGGIUNGI_CONTATTO
	else
		return
	return

;;;;;;;;;;;;;; Giorgio Leggio ;;;;;;;;;;;;;;;;;;;;;;;;;;;