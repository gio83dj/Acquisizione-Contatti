GOSUB INPUT_RANGE_SCHEDE

while quantitaSchede>=0
    {
	GOSUB ATTIVA_GESAT
	; Invia il numero di scheda al Gesat
	Send, %schedaIniziale%{ENTER}
	Sleep, 250
	; Due volte Invio per le chede con note o spedite
	Send, {ENTER}
	Sleep, 250
	Send, {ENTER}
	;GOSUB COPIA_N_SCHEDA
	;numScheda = %Clipboard%
	;Sleep, 250
	GOSUB COPIA_N_TEL
	numTel = %Clipboard%
	Sleep, 250
	GOSUB COPIA_NOME
	nome = %Clipboard%
	; Va a scrivere il vile vcf
	GOSUB CREA_VCARD
	; Aggiorna i contatori
	schedaIniziale := schedaIniziale + 1
	quantitaSchede := schedaFinale - schedaIniziale
	Send, {Esc}
	}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ATTIVA_GESAT:
	#WinActivateForce
	WinActivate, server2015 - Connessione Desktop remoto ahk_class TscShellContainerClass ahk_exe mstsc.exe
	RETURN

;Crea file di testo con il numero di scheda nome e numero separati da punto e virgola
AGGIUNGI_LISTA:
	FileAppend, %numScheda%;%nome%;%numTel%;; , C:\Users\Giorgio\Desktop\clienti.txt
	SoundBeep, 987, 500
	return

;Crea file VCARD con i contatti selezionati
CREA_VCARD:
	FileAppend, BEGIN:VCARD`n`VERSION:2.1`n`N:%nome%`n`FN:%nome%`n`TEL;CELL;PREF:%numTel%`n`END:VCARD`n, C:\Users\Giorgio\Desktop\VCARD_%schedeFatte%.vcf
	SoundBeep, 987, 500
	return

COPIA_N_TEL:
	;GOSUB ATTIVA_GESAT
	Click, 668, 148 Left, Down
	Sleep, 100
	Click, 758, 148 Left, Up
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



;;;;;;;;;;;;;; Giorgio Leggio ;;;;;;;;;;;;;;;;;;;;;;;;;;;