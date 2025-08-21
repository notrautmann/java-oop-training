/***
 * Fertigungsauftrag verwalten
 *
 * @group rt000
 * @group_parent fertig_module
 ***/

#-------------------------------------------------------------------------
# Patches im Stack-Verfahren
#-------------------------------------------------------------------------
# b 2
# R 5.1
# 2008-08-14  Ronge, Raymund
#             - Trace-Protokollierungen zur Nachverfolgung der Kostenträgerabhandlung
#               eingestreut
# R 4.3
# 2003-05-26  Ingo Pfeiffer
#             - Bei der Übernahme von Bestellvorschlägen in die Fertigung wird
#               der Kostenträger ermittelt.
#               Vorgang 20040402
# 2004-05-24  Bernd Eberling
#             - Laufzeitoptimierung bei Selektion auf r100 über r100.ufklz
#               und zusätzlich r100.identnr, var
#               Vorgang 20041238
# 2004-05-05  Bernd Eberling
#             - Bei Lagernummernwechsel wurde der Bestellbestand nicht aktualisiert
#               Vorgang 20041097
# 2004-04-21  Albicker, Martin
#             - Sofern in der r115 für einen Auftrag noch ein Führungssatz vorhanden war
#               (z.B. APL konnte nicht aufgelöst werden), konnte über die FA-Verwaltung
#               keine Änderung an diesem Auftrag vorgenommen werden.
#               In der Prüfung auf einen vorhandenen Führungssatz (proc rt000_sel_r115)
#               erfolgte folgende Änderung:
#               Statt ... and r115.vstat >= '0'
#               Jetzt ... and r115.vstat >= '2'
#             Vorgang: 20040973
# 2003-11-11  H. Laxander
#             - Bei Änderung "stlidentnr", "altern" etc. wurde "stlnr"/ "aplnr" nicht gelöscht.
# 2003-10-08  Bernd Eberling
#             - Bei Änderung wurde auch für den VA ein r115-Satz angelegt
#               Vorgang 20031478
#-------------------------------------------------------------------------
# R4.2 Patch
# 2002-08-5   A. Lakasz
#             - Bei der Abfrage der Meldung r0000603, bei != MSG_YES wird
#             return WARNING statt OK gemacht
# R4.1 Patch
# 2002-08-27  Tobias Selb
#             Laufzeitoptimierung: zuerst Zugriff mit get_fkt/get_datum mit "get"
#             -> Zugriff über Index
# 2002-04-22  Gunter Mann
#             - Cursor korrigiert (::fi_nr)
#-------------------------------------------------------------------------
#
# Releasefortschreibung im Stack-Verfahren
#
#-------------------------------------------------------------------------
# R6.2
#
# 2009-01-14  V. Gärtner
#             - Umstellung auf Richtext:
#               -> Löschen von Texten auf "bu_text_loeschen" geändert.
#-------------------------------------------------------------------------
# R6.1
# 2008-05-21  Valentin Gärtner
#              - Meldung r0000109 auf r0000260 umgestellt.
# 2007-10-01  Bernd Eberling
#             - Dokumentation Lagerbuchungen für Storno und Versorgung
#               . Beim Löschen von r000/r100-Sätzen werden die entsprechenden
#                 r039-Sätze mitgelöscht
# 2007-08-29  Vadim Maier
#             - Konvertierung kn_lgres
#               es gibt nur noch die Ausprägungen 0 und 1
#               0 = nicht reservieren, 1 = reservieren
#              -    Parameter L_LGRES hat nun zwei stellen. wenn die zweite stelle nicht
#                gefüllt ist wird die erste benutzt
#-------------------------------------------------------------------------
# b2
# R5.2
# 2006-11-09  Bernd Eberling
#             - Änderungsindex
#               . r000.aendind auch änderbar bei update
# 2006-07-28  Bernd Eberling
#             - Änderungsindex
#               . Abhandlung r000.aendind
# 2006-07-03  Bernd Eberling
#             - Abrufbestellung
#               . Abhandlung r000.kneintl
#-------------------------------------------------------------------------
# b2
# R5.1
# 2005-09-06  Bernd Eberling
#             - Abhandlung Übergabe FA-Struktur Kostenrechnung
#             - Ermittlung Kostenträger über cm100, wenn C_KTR_AKTIV
#               gesetzt und kein VA aus der integrierten Versorgung
#             - Abhandlung der Funktion rt000_kosttraeger_ermitteln (durch Patch
#               nachträglich hinzugekommen) entfernt (ct100)
#-------------------------------------------------------------------------
# b2
# R 5.0
# 2005-08-31  H. Laxander
#             - Abhandlung Leitzahl Primärauftrag (fklz_prim, fklz_var)
# 2005-06-28  H. Laxander
#             - "fklz_prim" im bundle "b_rt000" war nicht erforderlich
# 2005-01-20  Albicker, Martin
#             - Durch die Zusammenlegung von Primärauftragsverwaltung und FA-Verwaltung
#               sind die bisherigen Verwaltungsarten (rt000_verw_art) "NULL" und "1"
#               zusammengefaßt zur "NULL". Die bisherige Verwaltungsart "2" (aus rt010d)
#               wird zur neuen Verwaltungsart "1". Die Verwaltungsart "9"
#               (aus Versorgungsauftrag) bleibt.
#-------------------------------------------------------------------------
# R4.4
# 2004-06-22  Mayer, Marc-Andre
#             - Performancesteigerung bei selects auf r100 bzw. r000
# 2004-05-03  O. Obergfell
#             - Aktualisierung Modul-StyleGuide für gm7*.-Module:
#               -> Umbenennen Eingabe- und Ausgabeparameter (*E, *A, *EA)
# 2004-03-05  O. Obergfell
#             - Modul gt711 durch gm711 ersetzt.
#-------------------------------------------------------------------------
# b2
# R4.3
# 2003-07-08  H. Laxander
#             - Rekonfiguration für auftragsbez. Stammdaten
# 2003-04-02  Bernd Eberling
#             - Abhandlung d810.st_kanbannr
# 2003-03-25  Bernd Eberling
#             - Fehler bei Aufruf dyn_update_dt810 behoben
# 2002-10-01  Sonja Trotter
#             - Erweiterung um projekt_id (aus fp_ps8_anb)
# 2003-02-25  O. Obergfell
#             - Einfügen von FA-Kriterien (kritart 009) über gt711.
#             - Löschen von FA-Kriterien (kritart 009) über gt711.
# 2003-02-20  Bernd Eberling
#             - Abhandlung D_KB_STORNO
# 2003-02-18  Bernd Eberling
#             - Fehler bei Abhandlung Verwaltungsart "2" und Abstellen
#               r115-Satz behoben
# 2003-02-06  Bernd Eberling
#             - Erweiterung Datenübergabe an dt810
# 2003-01-29  Bernd Eberling
#             - Verwaltungsart "2" für rt010d eingeführt (Abhandlung für
#               Versorgungsaufträge steuern)
# 2002-10-24  Bernd Eberling
#             - Verwaltung Feld r000.milest_verf
# 2002-06-10  Bernd Eberling
#             - Zugriffe erfolgen mit "rt000_werk" statt LDB-Feld "werk"
# 2002-05-24  Tobias Selb
#             - Feldlängenbegrenzung für LDB Handles < 20 entfernt
#-------------------------------------------------------------------------
# bäurer 2
# R4.2
# 2002-03-19  Gunter Mann
#             - select auf declare cursor umgestellt
# 2002-03-01  Alina Lakasz
#             Aufruf der Funktion bu_dyn_fct beim insert in r000
# 2002-02-20  Tanja Metz
#             - Bundle b_rt000 erweitert kosttraeger wird mit NULL
#               weitergegeben
# 2002-02-19  Alina Lakasz
#             - Abhandlung fu_bedr == "4" zugefuegt
# 2002-02-11  Gunter Mann
#             - neues r000-Feld "servicenr" bei Bundle b_rt000
# 2002-01-22  Bernd Eberling
#             - Kanbanabhandlung: Löschen eines Kanban-Fertigungsauftrags
# 2002-01-15  Bernd Eberling
#             - Neue r000-Felder bei Insert - kanbannr, kanbananfnr
# 2001-11-07  ALL
#             - Funktion rt000_pruefen: falls ein Satz in r115 vorhanden ist
#             und der fkfs > 3 und es gibt keine Materialien oder Ag zu
#             dem Auftrag wird die Funktion mit WARNING beendet. Das wird
#             in rv000 und rv010 benutzt denn wenn die Funktion WARNING
#             zurückgibt kann der Auftrag nur gelöscht oder eingeplannt
#             werden.
# 2001-09-03  ALL
#             - Bundle b_rt115 um das Feld rkz erweitert
# 2001-08-16  Bernd Eberling
#             - Für Versorgungsaufträge erfolgt kein Anstoß der Bedarfsrechnung
#               über rt115, bei der Neuanlage wird fkfs gleich auf "3" gesetzt
# 2001-08-09  Bernd Eberling
#             - Anpassungen für kn_lgres
#-------------------------------------------------------------------------
# bäurer 2
# R4.1
# 2001-05-15  Lisa Indlekofer
#             - Standart-Meldungen mit Platzhalter
# 2001-04-07  Ashish Doodhwala (India)
#             - Added kkomm_nr field
#             - kkomm_nr screen feild length is set to 30
# 2001-03-26  ALL
#             - Zeile g020.lgnr = 0 in g020.lgnr = rt000_lgnr geändert (Abhandlung
#               g020-g023-lgnr = 0); g023.bestell.. mit aktualisiert
# 2001-03-12  Albicker, Martin
#             - Löschkennzeichen bei Neuanlage max. "2"
# 2001-02-28  H. Ashtiani
#             - Feldererweiterung
#------------------------------------------------------------
# b2
# R4.0  Patch
# 2000-12-05  Albicker, Martin
#             - Prüfung von "Kennzeichen Kalkulation" und "Kennzeichen
#               Löschen Auftrag" in proc rt000_pruefen_verw aufgenommen.
#-------------------------------------------------------------------------
# R4.0
# 2000-10-06 Alexander Korner
#            - Erweiterung des Moduls um charge und chargen_pflicht
# 2000-10-05 Alexander Korner
#              Anbindung der Feinplanung
#-------------------------------------------------------------------------
# B2
# R3.0
# 2000-03-20  Albicker, Martin
#             - Änderung Alphanumerischer Codes
#-------------------------------------------------------------------------
# R2.0
# 08.10.1999  Siegfried Wagenseil
#             - Abhandlung neue Felder für TISOWARE
# 08.09.1999  Siegfried Wagenseil
#             - Umstellung fkt -> datum
# 25.08.1999  Martin Albicker
#             - Werksabhandlung Phase 1
#-------------------------------------------------------------------------
# b2
# 30.06.1999  Siegfried Wagenseil
#             - Neuerstellung
#-------------------------------------------------------------------------
#
# Beschreibung:
# -------------
#
# Dieses Modul enthält die Funktionen zum eigentlichen Einfügen, Ändern
# Löschen eines Fertigungsauftrags und außerdem alle daran geknüpften
# Abhandlungen. Dies sind im Wesentlichen:
#
#   - Ermitteln bzw. Berechnen der Terminierungsart, der Mengen und
#     Termine bei Mengen-/ Terminänderung
#   - Anstoß Bedarfsrechnung (Modul rt115)
#   - Update Bestellbestand
#   - Prüfungen, insbesondere beim Löschen
#
#
# Funktionen:
# -----------
#
# rt000_first_entry Laden des LDB und Initialisierung
# rt000_entry       Aktivieren des LDB
# rt000_exit        Deaktivieren des LDB
# rt000_last_exit   Abschließen und entfernen des LDB
#
# rt000_pruefen     Pruefen, ob der Fertigungsauftrag verwaltet werden kann
#
# rt000_verwalten   Anlegen/ Ändern/ Löschen Fertigungsauftrag
#
# rt000_daten_neu   Geänderte Daten an rufendes Programm senden
#
# rt000_protokoll   Protokollsatz schreiben für Fertigungsauftrag
#
#
# benutzte Variablen aus "appl.ldb"
# ----------------------------------
#
# - / -
#
#
# Parameter:
# ----------
#
# handle      LDB-Handle zur Speicherung im rufenden Modul/ Programm/ Maske
#
# prot        Name der anzusteuernden Protokollfunktion im übergeordneten
#             Programm, (wenn nicht übergeben, eigene Protokollierung)
#
# verw_art    Verwaltungsart
#
#                 NULL  = Aufruf aus Primärauftragsverwaltung
#                         bzw. Aufruf aus Übernahme IH-Vorschläge als IH-Aufträge
#                 1     = Aufruf aus rt010d
#                 2     = Aufruf aus dh204 - Sim. Produktionsplan
#                 3     = Aufruf aus rm1004i1
#                 4     = Aufruf aus rh080 (Simulation)
#                 5     = Aufruf aus rv0000
#                 6     = Aufruf aus dv250
#
#
# Bundles:    b_rt000     Enthält Daten des Fertigungsauftrags
# --------    b_rt000_s   Enthält geänderte Daten des Fertigungsauftrags
#
#
# LDB:
# ----
#
# rt000.ldb   Enthält alle modulrelevanten Daten
#
#
# Aufgerufene Module:
# -------------------
#
# rt115       Anstoß Bedarfsrechnung
# it010       Instandhaltung
#
# ri000       Ermittlung Zähler
# ri070       Ermittlung Verzug
#
#--------------------------------------------------------------------

include rt000.cdt
include rt000_priv.bsl

call rt000_define_cdts()

#--------------------------------------------------------------------
# rt000_first_entry
#
# - Laden und aktivieren des LDB
# - Funktion "first_entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#--------------------------------------------------------------------
int proc rt000_first_entry(verw_art, prot)
{
    vars          handleL
    cdtTermGlobal cdtTermGlobalL

    handleL = sm_ldb_load("rt000.ldb")
    if (handleL < OK) {
        return FAILURE
    }
    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, TRUE)

    name_cdtTermGlobal_rt000 = "cdtTermGlobalRt000_" ## handleL

    // Kontext Terminierungsmodul einmalig erzeugen
    public cdtTermGlobal.bsl
    cdtTermGlobalL = cdtTermGlobal_new(FALSE)
    unload cdtTermGlobal.bsl
    call boa_cdt_put(cdtTermGlobalL, name_cdtTermGlobal_rt000)


    // Protokollierungsfunktion setzen in LDB (Default = intern)
    rt000_prot = prot
    if (rt000_prot == NULL) {
        rt000_prot = "rt000_proto"
    }

    rt000_werk = werk

    // Parameter in LDB umladen
    rt000_verw_art = verw_art

    L_LGRESRt000            = bu_getenv("L_LGRES")
    rt000_R_VERSCHIEB       = bu_getenv("R_VERSCHIEB")
    rt000_R_FS_TAUSCH       = bu_getenv("R_FS_TAUSCH")
    rt000_D_KB_STORNO       = bu_getenv("D_KB_STORNO")
    rt000_R_START           = bu_getenv("R_START")
    rt000_R_SERIE_STORNO    = bu_getenv("R_SERIE_STORNO")
    R_NETTOBEDARFRt000      = bu_getenv("R_NETTOBEDARF")
    R_KZ_DISPORt000         = bu_getenv("R_KZ_DISPO")
    R_KZ_DISPO_FBRt000      = bu_getenv("R_KZ_DISPO_FB")

    // 300397191:
    rt000_R_FA_STORNO = bu_getenv("R_FA_STORNO")
    if (rt000_R_FA_STORNO != "1") {
        rt000_R_FA_STORNO = "0"
    }

    // Tagesdatum lesen
    if (rt000_load_gm300(fi_nr, rt000_werk) != OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    rt000_cm130 = -1

    antwort_r0000131 = FALSE
    antwort_r0000166 = FALSE
    antwort_r0000603 = FALSE
    antwort_r0000172 = FALSE
    antwort_r0000173 = FALSE

    // MCS Einstellungen Firmennummern
    bFirmenkopplungRt000 = cod_vereinfachte_firmenkopplung(fi_nr, FALSE)

    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
    return handleL
}

#--------------------------------------------------------------------
# rt000_entry
#
# - aktivieren des LDB
# - Funktion "entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#--------------------------------------------------------------------
int proc rt000_entry(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // Module laden
    if (rt000_lt110_handle > 0) {
        public lt110:(EXT)
        call lt110_entry(rt000_lt110_handle)
    }

    if (rt000_it000_handle > 0) {
        public it000:(EXT)
        call it000_entry(rt000_it000_handle)
    }

    if (rt000_dt800_handle > 0) {
        public dt800:(EXT)
        call dt800_entry(rt000_dt800_handle)
    }

    if (rt000_dt810_handle > 0) {
        public dt810:(EXT)
        call dt810_entry(rt000_dt810_handle)
    }

    if (handleRt090Rt000 > 0) {
        public rt090:(EXT)
        call rt090_entry(handleRt090Rt000)
    }

    public ri000:(EXT)
    public ri070:(EXT)

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#--------------------------------------------------------------------
# rt000_exit
#
# - aktivieren des LDB
# - Funktion "exit" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#--------------------------------------------------------------------
int proc rt000_exit(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    if (rt000_lt110_handle > 0) {
        public lt110:(EXT)
        call lt110_exit(rt000_lt110_handle)
    }

    if (rt000_it000_handle > 0) {
        public it000:(EXT)
        call it000_exit(rt000_it000_handle)
    }

    if (rt000_dt800_handle != NULL) {
        public dt800:(EXT)
        call dt800_exit(rt000_dt800_handle)
    }

    if (rt000_dt810_handle > 0) {
        public dt810:(EXT)
        call dt810_exit(rt000_dt810_handle)
    }

    if (handleRt090Rt000 > 0) {
        public rt090:(EXT)
        call rt090_exit(handleRt090Rt000)
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#--------------------------------------------------------------------
# rt000_last_exit
#
# - aktivieren des LDB
# - Funktion "last_exit" der untergeordneten Module aufrufen
# - deaktivieren und entladen des LDB
#--------------------------------------------------------------------

int proc rt000_last_exit(handleP)
{
    cdtTermGlobal kontextL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    if (dm_is_cursor("rt000_read_r000") == TRUE) {
        dbms close cursor rt000_read_r000
    }
    if (dm_is_cursor("rt000_read_r100") == TRUE) {
        dbms close cursor rt000_read_r100
    }
    if (dm_is_cursor("sel_r115_rt000C") == TRUE) {
        dbms close cursor sel_r115_rt000C
    }
    if (dm_is_cursor("rt000_read_f100") == TRUE) {
        dbms close cursor rt000_read_f100
    }
    if (dm_is_cursor("rt000_read_f200") == TRUE) {
        dbms close cursor rt000_read_f200
    }
    if (dm_is_cursor("rt000_read_d800") == TRUE) {
        dbms close cursor rt000_read_d800
    }
    if (dm_is_cursor("rt000_read_d810") == TRUE) {
        dbms close cursor rt000_read_d810
    }
    if (dm_is_cursor("selObjektidRt000") == TRUE) {
        dbms close cursor selObjektidRt000
    }
    if (dm_is_cursor("rt000_zuordnung") == TRUE) {
        dbms close cursor rt000_zuordnung
    }
    if (dm_is_cursor("rt000_get_aenddr") == TRUE) {
        dbms close cursor rt000_get_aenddr
    }
    if (dm_is_cursor("rt000_upd_r100") == TRUE) {
        dbms close cursor rt000_upd_r100
    }
    if (dm_is_cursor("rt000_del_r039") == TRUE) {
        dbms close cursor rt000_del_r039
    }
    if (dm_is_cursor("rt000_get_zustext") == TRUE) {
        dbms close cursor rt000_get_zustext
    }
    if (dm_is_cursor("rt000CurLgDisp") == TRUE) {
        dbms close cursor rt000CurLgDisp
    }
    if (dm_is_cursor("rt000CurSbterm") == TRUE) {
        dbms close cursor rt000CurSbterm
    }
    if (dm_is_cursor("rt000GetKomm") == TRUE) {
        dbms close cursor rt000GetKomm
    }
    if (dm_is_cursor("sel_e110_rt000C") == TRUE) {
        dbms close cursor sel_e110_rt000C
    }
    if (dm_is_cursor("curTSTRt000") == TRUE) {
        dbms close cursor curTSTRt000
    }
    if (dm_is_cursor("sel_b110_kalid_rt000C") == TRUE) {
        dbms close cursor sel_b110_kalid_rt000C
    }

    // Module entladen
    call bu_unload_tmodul("lt110", rt000_lt110_handle)
    rt000_lt110_handle = NULL
    call bu_unload_tmodul("it000", rt000_it000_handle)
    rt000_it000_handle = NULL
    call bu_unload_tmodul("dt800", rt000_dt800_handle)
    rt000_dt800_handle = NULL
    call bu_unload_tmodul("dt810", rt000_dt810_handle)
    rt000_dt810_handle = NULL
    call bu_unload_tmodul("rt090", handleRt090Rt000)
    handleRt090Rt000 = NULL

    call bu_unload_modul("gm790", rt000_gm790_handle)
    rt000_gm790_handle = NULL
    call bu_unload_modul("gm300", rt000_handle_gm300)
    rt000_handle_gm300 = NULL
    call bu_unload_modul("cm130", rt000_cm130)
    rt000_cm130 = -1

    unload ri000:(EXT)
    unload ri070:(EXT)

    public rq1004.bsl
    call verknuepfungRq1004Unload()

    kontextL = boa_cdt_get(name_cdtTermGlobal_rt000)
    if (md_typeof(boa_cdt_get(name_cdtTermGlobal_rt000)) == "cdtTermGlobal") {
        call boa_cdt_remove(name_cdtTermGlobal_rt000)
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    // ggf. Entladen gq300, rq115, rq000
    call fertig_unload_terminierungsmodule(kontextL, $NULL)

    call sm_ldb_h_unload(handleP)
    return OK
}

#--------------------------------------------------------------------
# rt000_pruefen
#
# Prüfen, ob Fertigungsauftrag verwaltet werden kann
# - Prüfung auf Fertigungstatus
# - Prüfung auf Auftragsart
#--------------------------------------------------------------------

int proc rt000_pruefen(handleP)
{
    int rcL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // empfangen der alten Werte
    rt000_alt_neu = "alt"
    call rt000_receive_rt000()
    rt000_da_alt = rt000_da

    rcL = rt000_pruefen_verarb()

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    return rcL
}

#--------------------------------------------------------------------
int proc rt000_pruefen_verarb(pAufst)
{
    int     rcL
    boolean aus_re000L

    public rq000.bsl
    aus_re000L = cdtTermGlobal_is_sammelaenderung_fa($NULL) // 300354288


    // Pseudoauftrag ??
    if (cod_aart_pseudo(rt000_aart) == TRUE) {
        // Pseudo-Auftrag mit aart = NULL kann nicht verwaltet werden
        return on_error(FAILURE, "r0000110", "", rt000_prot)
    }

    // simulativer Auftrag nur im Simulationsmodus
    if (rt000_fkfs == FSTATUS_SIM && SIM != TRUE) {
        // Simulativer Auftrag, Verwaltung nur im Simulationsmodus möglich
        return on_error(FAILURE, "r0000165", "", rt000_prot)
    }

    // Auftrag ausgesetzt
    if (rt000_fkfs == FSTATUS_AUSGESETZT || rt000_fkfs_a == FSTATUS_AUSGESETZT) {
        // Auftrag ausgesetzt, keine Verwaltung möglich
        return on_error(FAILURE, "r0000164", "", rt000_prot)
    }

    // Auftrag bereits storniert, Änderungsdruck steht noch aus
    if (rt000_fkfs == FSTATUS_STORNIERT || rt000_fkfs_a == FSTATUS_STORNIERT) {
        // 300168767
        // Fertigungsauftrag ><%1 bereits storniert, Druck FA-Papiere starten.
        return on_error(FAILURE, "r0000139", rt000_fklz, rt000_prot)
    }

    // Auftrag bereits storniert ??
    if (rt000_menge_alt == 0) {
        // 300314029:
        // Im re000 darf man bei Fertigungsaufträgen mit Menge 0.0 immer ein Storno-Aktionssatz
        // abstellen (falls dieser aus irgend welchen Gründen fehlt).

        // Fertigungsauftrag bereits storniert --> Bedarfsrechnung starten
        if (rt000_aes   == cAES_DELETE \
        &&  screen_name == "re000") {
            // Fertigungsauftrag bereits storniert --> Bedarfsrechnung starten
            call on_error(INFO, "r0000125", "", rt000_prot)
        }
        else {
            // Fertigungsauftrag bereits storniert --> Bedarfsrechnung starten
            return on_error(FAILURE, "r0000125", "", rt000_prot)
        }
    }

    // Auftrag fertiggemeldet ??
    if (rt000_fkfs > FSTATUS_ANGEARBEITET || rt000_fkfs_a > FSTATUS_ANGEARBEITET) {
        // Fertigungsauftrag bereits fertig gemeldet, kein Verwalten möglich.
        // Wollen Sie den Fertigungsauftrag kopieren?
        if (bu_msg("r0000260") != MSG_YES) {
            return on_error(FAILURE)
        }
        else {
            return INFO
        }
    }

    // bei Primärauftragsverwaltung zusätzliche Prüfungen
    if (rt000_verw_art == "1") {
        // keine Sekundäraufträge
        if (rt000_aart == "0") {
            // Auftrag mit aart = "0" kann nicht verwaltet werden
            return on_error(FAILURE, "r0000127", "", rt000_prot)
        }
    }

    // prüfen, ob ein teilweise verarbeiteter Aktionssatz
    // für Bedarfsrechnung vorhanden ist
    // 300354288:
    // Im re000 darf keine Prüfung auf vorhandenen r115-Satz kommen, da dies dort separat gemacht wird
    // (vgl. "re000_verarbeiten" bzw. "rq115_check_aenderung_fu_bedr").
    if (pAufst     != TRUE \
    &&  aus_re000L != TRUE) {
        rcL = rt000_sel_r115()
        if (rcL < OK) {
            return FAILURE
        }
        else if (rcL == OK) {
            if ( \
                rt000_fkfs >= FSTATUS_TERMINIERT && \
                ri000_anz_mat("alle", rt000_fklz) == 0 && \
                ri000_anz_ag("alle", rt000_fklz) == 0 \
            ) {
                // die Verwaltung kann doch durchgeführt werden,
                // der Auftrag kann gelöscht werden
                if (rt000_verw_art != "3") {
                    return on_error(FAILURE, "", "", rt000_prot)
                }
                else {
                    return on_error(WARNING, "", "", rt000_prot)
                }
            }
            else {
                // Der Satz in r115 ist OK
                if (rt000_verw_art != "3") {
                    // Fertigungsauftrag >%1< kann nicht verwaltet werden, da noch eine Bedarfsrechnung anliegt.%%NBitte zuerst Bedarfsrechnung starten!
                    return on_error(FAILURE, "r0000135", rt000_fklz, rt000_prot)
                }
                else {
                    // Fertigungsauftrag >%1< kann nicht verwaltet werden, da noch eine Bedarfsrechnung anliegt.%%NBitte zuerst Bedarfsrechnung starten!
                    return on_error(WARNING, "r0000135", rt000_fklz, rt000_prot)
                }
            }
        }
    }

    // Fertigungsauftrag ist bereits angearbeitet
    if (rt000_fkfs > FSTATUS_FREIGEGEBEN || rt000_fkfs_a > FSTATUS_FREIGEGEBEN) {
        // Fertigungauftrag >%1< ist bereits angearbeitet!
        call on_error(INFO, "r0000138", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_INFO)

        // Das Modul rm1004 muss neben der Meldung aber auch mitbekommen, dass die Prüfung auf ein Problem gestoßen ist!
        if (rt000_verw_art == "3") {
            return INFO
        }
    }

    return OK
}

/**
 * Verwaltungsfunktionen Fertigungsauftrag
 *
 * - berechnen Termine, Terminierungsart etc.
 *- Fertigungsauftrag anlegen/ ändern/ löschen
 *   . wenn Status > 1 und löschen
 *     --> prüfen, ob Fertigungsauftrag storniert werden kann
 *         berechnen Termine und Terminierungsart
 *         fkfs = 9 setzen
 *         ändern Fertigungsauftrag
 * - Bedarfsrechnung anstoßen
 * - Bestellbestand korrigieren
 *
 * Bundle "b_rt000" wird empfangen
 * Bundle "b_rt000_s" wird gesendet (optional)
 *
 * @param handle                    Handle des Moduls
 * @param [tkzP]                    Von extern übergebenes TKZ
 * @param [kn_term_verschobP]       Von extern übergebenes Kennzeichen verschoben
 * @param [fu_bedr_extP]            Von extern übergebener FU_BEDR
 * @param [standortkalenderP]       Standortkalender als Instanz von {@code cdtGq300}
 * @param [kn_aend_faP]             Von extern übergebenes KN_AEND_FA
 * @return OK
 * @return FAILURE                  Fehler
 * @see
 * @example
 **/
int proc rt000_verwalten(handle, string tkzP, string kn_term_verschobP, string fu_bedr_extP, cdtGq300 standortkalenderP, string kn_aend_faP)
{
    int rcL

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    // empfangen der neuen Werte
    rt000_alt_neu = "neu"
    rcL = rt000_receive_rt000()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }


    rt000_fu_bedr = fu_bedr_extP        // für die Protokollierung den übergebenen Funktionscode merken


    // Gm300 neu laden, da sich das Werk geändert haben könnte
    if (rt000_load_gm300(fi_nr, rt000_werk) != OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // 300364183
    // ggf. den Standortkalender einmalig lesen, wenn nicht übergeben
    standortkalenderP = rt000_ermitteln_standortkalender(standortkalenderP)

    rcL = rt000_verwalten_verarb(FALSE, tkzP, kn_term_verschobP, fu_bedr_extP, standortkalenderP, kn_aend_faP, $NULL)
    if (rcL != OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return rcL
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
    return OK
}

/**
 * Interne Methode zum Speichern/Anlegen/Löschen eines Fertigungsauftrages
 *
 * @param aufstP                Aufruf aus "rt000_aendern" (TRUE) odfer nicht (FALSE)
 * @param [tkzP]                Termin-Änderungs-Kennzeichen
 * @param [kn_term_verschobP]   Kennzeichen FA verschoben
 * @param [fu_bedr_extP]        Funktionscode Bedarfsrechnung
 * @param [standortkalenderP]   Standortkalender
 * @param [kn_aend_faP]         Kennzeichen Ändeurng Projekt-ID
 * @param [ergebnisP]           CDT, in welches (bei Erfolg) Ergebnisdaten geschrieben werden
 * @return OK
 * @return WARNING              logischer Fehler
 * @return FAILURE              Fehler (immer mit Rollback)
 * @see  {@code cdtTermGlobal_ermittlen_welche_meldung_PRT_OK}
 * @example
 **/
int proc rt000_verwalten_verarb( \
    boolean aufstP, \
    string tkzP, \
    string kn_term_verschobP, \
    string fu_bedr_extP, \
    cdtGq300 standortkalenderP, \
    string kn_aend_faP, \
    ErgebnisRt000 ergebnisP \
) {
    int      rcL
    string   mkzL                 = MKZ_UNDEFINIERT     // 300354288
    boolean  termine_beibehaltenL = FALSE               // 300354288
    boolean  bedarfsrechnungL     = FALSE
    cdtRq000 cdtRq000L


    // 300354288 und 300366769
    // Todo: Das Kennzeichen "mkz" sollte besser analog dem "tkz" per Parameter von außen übergeben werden!
    if (sm_is_bundle("b_termine_beibehalten_rt000") == TRUE) {
        receive bundle "b_termine_beibehalten_rt000" data \
            termine_beibehaltenL, \
            mkzL
    }

    // Prüfen "aes"
    if ( \
        rt000_aes != cAES_DELETE   && \
        rt000_aes != cAES_INSERT   && \
        rt000_aes != cAES_UPDATE   && \
        rt000_aes != cAES_REKONFIG && \
        rt000_aes != "9" \
    ) {
        // Falscher Funktionscode bei Aufruf Modul %s
        return on_error(FAILURE, "ral00901", "rt000", rt000_prot)
    }


    if (rt000_aes == cAES_INSERT) {
        rt000_identnr_alt = rt000_identnr_neu
        rt000_var_alt     = rt000_var_neu
        rt000_lgnr_alt    = rt000_lgnr_neu
        rt000_da_alt      = rt000_da
    }

    // Prüfungen durchführen
    if (rt000_pruefen_verw() != OK) {
        return FAILURE
    }

    // bestimmte Felder müssen berechnet bzw. gesetzt werden
    if (rt000_felder_fa(tkzP, fu_bedr_extP, mkzL, termine_beibehaltenL, standortkalenderP, kn_aend_faP) != OK) {
        return FAILURE
    }

    // Merkmale löschen
    if (rt000_merkmale_delete() < OK) {
        return on_error(FAILURE)
    }

    if (rt000_serienverwaltung() < OK) {
        return on_error(FAILURE)
    }


    // 300349432: Instanz des rq000 einmalig erzeugen (beim Update mit einmaligem Lesen r000)
    public rq000.bsl
    switch (rt000_aes) {
         case cAES_INSERT:
            cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, "", standortkalenderP)
            call rq000_set_fklz(cdtRq000L, rt000_fklz)
            call rq000_set_aes(cdtRq000L, rt000_aes)
            break
         else:
            cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)
            break
    }

    bedarfsrechnungL = cdtTermGlobal_is_bedarfsrechnung(cdtRq000L, "")

    // Fertigungsauftrag anlegen / ändern/ löschen
    rcL = rt000_fa(aufstP, kn_term_verschobP, standortkalenderP, cdtRq000L)
    switch (rcL) {
        case OK:
            // Merkmale Einfügen
            if (rt000_merkmale_insert() < OK) {
                return on_error(FAILURE)
            }

            // Aktionssatz/-sätze in r115 abstellen.
            if (rt000_aktionssatz(cdtRq000L, fu_bedr_extP, termine_beibehaltenL, ergebnisP) != OK) {
                return FAILURE
            }
            break
        case INFO:      // FA wurde gelöscht
            // 300392101: Bei gelöschten FA keinen Aktionssatz abstellen und keine Merkmale einfügen
            break
        case FAILURE:
        else:
            return FAILURE
    }


    // Bestellbestand korrigieren
    if (rt000_bestellbestand() != OK) {
        return FAILURE
    }

    // Instandhaltungsdaten korrigieren
    if (rt000_instandhaltung() != OK) {
        return FAILURE
    }

    // Kanbanaufträge verarbeiten
    if (rt000_set_kanban() != OK) {
        return FAILURE
    }

    // Protokollierung, wenn per Parameter gewünscht
    // (vgl. "cdtTermGlobal_ermittlen_welche_meldung_PRT_OK")
    // Meldung wird auch über "cdtTermGlobal_ermittlen_welche_meldung_PRT_OK" erzeugt.
    if (prt_ok           == TRUE \
    &&  bedarfsrechnungL != TRUE) {
        switch (rt000_aes) {
            case cAES_INSERT:
                if (cod_aart_versorg(rt000_aart) == TRUE) {
                    // Versorgungsauftrag %s wurde angelegt
                    call bu_get_msg("r7200023", rt000_fklz)
                }
                else {
                    // Fertigungsauftrag %s wurde angelegt
                    call bu_get_msg("r0000023", rt000_fklz)
                }
                break
            case cAES_UPDATE:
            case cAES_REKONFIG:
            case "9":
                if (cod_aart_versorg(rt000_aart) == TRUE) {
                    // Versorgungsauftrag %s wurde geändert
                    call bu_get_msg("r7200025", rt000_fklz)
                }
                else {
                    // Fertigungsauftrag %s wurde geändert
                    call bu_get_msg("r0000025", rt000_fklz)
                }
                break

            case cAES_DELETE:
                if (cod_aart_versorg(rt000_aart) == TRUE) {
                    // Versorgungsauftrag %s wurde gelöscht
                    call bu_get_msg("r7200027", rt000_fklz)
                }
                else {
                    // Fertigungsauftrag %s wurde gelöscht
                    call bu_get_msg("r0000027", rt000_fklz)
                }
                break
            else:
                // Initialisierung der globalen Message-Felder für die OK-Meldung
                call fertig_fehler_init_globale_felder(TRUE)
                break
        }


        if (rt000_proto(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
            return FAILURE
        }
    }

    return OK
}


#--------------------------------------------------------------------
# rt000_daten_neu
#
# Geänderte Daten an rufendes Programm senden
#--------------------------------------------------------------------

int proc rt000_daten_neu(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    call rt000_send_rt000()

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#--------------------------------------------------------------------
# rt000_protokoll
#
# Ansteuerung Protokollierung Fertigungsauftrag vom rufenden
# Programm aus
#
# Returns: FAILURE, OK
#--------------------------------------------------------------------

int proc rt000_protokoll(handleP, string prt_ctrlP, string fu_bedr_extP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // Daten empfangen
    rt000_alt_neu = "neu"
    call rt000_receive_rt000()

    rt000_fu_bedr = fu_bedr_extP        // für die Protokollierung den übergebenen Funktionscode merken

    if (rt000_proto($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#--------------------------------------------------------------------
# rt000_pruefen_verw
#
# Prüfungen nach Aufruf "verwalten"
# - Bei Stornierung
#   . wenn fkfs > "4" oder begonnene Materialien, begonnene Arbeitsgänge
#     oder Zusatzmeldungen, ist keine Stornierung mehr möglich
#   . wenn fkfs = "1" und Auftragsart "K" oder "V" ist keine Stornierung
#     möglich
# - Prüfung, ob STL-APL-Tausch anliegt
#   . nicht bei Neuanlage
#   . hat sich ein relevantes Feld geändert, wenn ja
#     --> wenn Status keinen Tausch mehr zulässt --> Fehler
#     --> ansonsten Tausch anstossen, wenn bereits eingeplant (aes = 4)
# - Prüfung stlnr/ aplnr
#   . nicht bei Löschen
#   . wenn > 0, und Neuanlage oder geändert
#     --> lesen Stücklisten- bzw. Arbeitsplankopfdaten
#--------------------------------------------------------------------

int proc rt000_pruefen_verw()
{
    int    rcL
    string fkfsL
    int    anzahlL
    string dyn_whereL
    string dyn_usingL = "FI_NR1, rt000_fklz"
    int    vorhandenL


    // bei simulativem Auftrag ist Status alt für Tausch maßgebend
    fkfsL = fertig_get_fkfs(rt000_fkfs, rt000_fkfs_a)

    // 300145076
    // Sind Fremdarbeitsgänge mit (offenen) Bestellpositionen vorhanden?
    // Dann darf ein Löschen ebenfalls nicht mehr erfolgen!
    if ( \
        ( \
            rt000_aes == cAES_DELETE \
        ) || ( \
            rt000_aes       == cAES_UPDATE && \
            rt000_menge_neu == 0.0 \
        ) \
    ) {
        if (rt000_fkfs > FSTATUS_ERFASST) {
            if (bFirmenkopplungRt000 == "0") {
                dyn_whereL   = " and e110.fi_nr = ::fi_nr "
                dyn_usingL ##= ", fi_nr"
            }
            else {
                dyn_whereL   = " and e110.fi_nr > 0 "
            }
            if (dm_is_cursor("sel_e110_rt000C") != TRUE) {
                // 300323747: Angleich Selekt an den aus rt010
                dbms declare sel_e110_rt000C cursor for \
                    select \
                        count(*) \
                    from \
                        r200, \
                        e110 \
                    where \
                        r200.fi_nr   = ::FI_NR1            and \
                        r200.fklz    = ::fklz              and \
                        r200.falz    = e110.falz \
                        :dyn_whereL

                dbms with cursor sel_e110_rt000C alias \
                    vorhandenL
            }

            dbms with cursor sel_e110_rt000C execute using :dyn_usingL
            if (vorhandenL > 0) {
                // Es existieren noch offene Fremdarbeitsgang-Bestellpositionen.
                // Ein Löschen des Fertigungsauftrags ist daher nicht möglich!
                return on_error(FAILURE, "r0000263", "", rt000_prot)
            }
        }
    }

    // Bei Stornierung
    if (rt000_aes == cAES_DELETE) {
        if fkfsL > FSTATUS_FREIGEGEBEN
            // Fertigungsauftrag angearbeitet, keine Stornierung mehr möglich!
            return on_error(WARNING, "r0000132", "", rt000_prot)

        if (fkfsL > FSTATUS_ERFASST) {
            if ri000_anz_mat("beg", rt000_fklz) > 0 || \
               ri000_anz_ag ("beg", rt000_fklz) > 0 || \
               ri000_anz_zum("alle", rt000_fklz) > 0
            // Fertigungsauftrag angearbeitet, keine Stornierung mehr möglich!
            return on_error(WARNING, "r0000132", "", rt000_prot)
        }

        if (fkfsL == FSTATUS_ERFASST) {
            // Für Versorgungsaufträge ist diese Prüfung irrelevant, da ein Löschen
            // der Bedarfe über rt100 direkt nach dem Löschen per rt000 zu erfolgen hat
            // (-> Steuerung über rt010d)
            if (cod_aart_versorg(rt000_aart) == FALSE) {
                anzahlL = ri000_anz_mat("alle", rt000_fklz)
                if (anzahlL > 0) {
                    // Der Fertigungsauftrag kann nicht gelöscht werden.
                    // Es sind noch >%1< Materialien vorhanden!
                    return on_error(WARNING, "r0000199", anzahlL, rt000_prot)
                }
                anzahlL = ri000_anz_ag("alle", rt000_fklz)
                if (anzahlL > 0) {
                    // Der Fertigungsauftrag kann nicht gelöscht werden.
                    // Es sind noch >%1< Arbeitsgänge vorhanden!
                    return on_error(WARNING, "r0000299", anzahlL, rt000_prot)
                }
            }

            // bei Primäraufträgen mit überg. Bedarf Sicherheitsabfrage
            if ((cod_aart_vertriebsfa(rt000_aart) == TRUE || cod_aart_vdispo(rt000_aart) == TRUE) && antwort_r0000166 == FALSE) {
                // Beim Löschen von Primäraufträgen mit übergeordnetem Bedarf geht die Verknüpfung zu diesem verloren.
                // Wollen Sie dies zulassen ?
                rcL = bu_msg("r0000166")
                log LOG_DEBUG, LOGFILE, "Meldung r0000166 rc >:rcL< "
                if (rcL == MSG_NO) {
                    return WARNING
                }
                else if (rcL == MSG_ABORT || rcL == MSG_CANCEL) {
                    return on_error(FAILURE)
                }
                else if (rcL == MSG_YESTOALL) {
                    antwort_r0000166 = TRUE
                }
            }
        }

        if (rt000_fkfs == FSTATUS_FREIGEGEBEN) {
            if (dm_is_cursor("rt000GetKomm") != TRUE) {
                dbms declare rt000GetKomm cursor for \
                     select count(*) \
                       from l82010, r100 \
                      where r100.fi_nr   = ::FI_NR1 \
                        and r100.fklz    = ::rt000_fklz \
                        and l82010.fi_nr = r100.fi_nr \
                        and l82010.fmlz  = r100.fmlz \
                    union all \
                     select count(*) \
                       from l82030, r100 \
                      where r100.fi_nr   = ::FI_NR1 \
                        and r100.fklz    = ::rt000_fklz \
                        and l82030.fi_nr = r100.fi_nr \
                        and l82030.fmlz  = r100.fmlz \
                      order by 1 desc

                dbms with cursor rt000GetKomm alias jamint
            }

            dbms with cursor rt000GetKomm execute using FI_NR1, rt000_fklz, \
                                                        FI_NR1, rt000_fklz

            if (jamint > 0) {
                if (cod_aart_versorg(rt000_aart) == TRUE) {
                    // Der freigegebene Versorgungsauftrag kann nicht storniert werden, da er einem
                    // Kommissioniervorgang zugeordnet ist
                    return on_error(FAILURE, "r0000251", rt000_fklz, rt000_prot)
                }
                else {
                    // Der freigegebene Fertigungsauftrag kann nicht storniert werden, da er einem
                    // Kommissioniervorgang zugeordnet ist
                    return on_error(FAILURE, "r0000252", rt000_fklz, rt000_prot)
                }
            }
        }
    }

    // Prüfen von Kalkulations- und Löschkennzeichen,
    // jedoch nur bei Neuanlage oder im Status "1" (Felder sind noch offen)
    if (rt000_aes == cAES_INSERT || fkfsL == FSTATUS_ERFASST) {
        rcL = rt000_pruefen_kennzeichen_loeschen()
        if (rcL != OK) {
            return rcL
        }
    }

    // restliche Prüfungen nur, wenn nicht Löschen
    if (rt000_aes == cAES_DELETE) {
        return OK
    }


    // 300267546: AENDDR muss immer vorhanden sein, damit beim CDBI-Update keine "0" daraus gemacht wird
    if (rt000_aenddr == NULL) {
        rcL = rt000_sel_aenddr()
        if (rcL != OK) {
            return rcL
        }
    }

    // Prüfen stlnr, wenn > 0 und Neuanlage, oder geändert
    if (rt000_stlnr_neu > 0) {
        rcL = rt000_sel_f100()
        if (rcL != OK) {
            return rcL
        }

        if (rt000_stlnr_neu == rt000_stlnr_alt) {
            if (rt000_stlidentnr_neu        != NULL \
            && (rt000_stlidentnr_neu ## " " != rt000_stlidentnr_alt ## " " \
            ||  rt000_stlvar_neu ## " "     != rt000_stlvar_alt ## " ")) \
            ||  rt000_altern_neu ## " "     != rt000_altern_alt ## " "
                rt000_stlnr_neu      = NULL
            else {
                rt000_stlidentnr_neu = rt000_stlidentnr_alt
                rt000_stlvar_neu     = rt000_stlvar_alt
            }
        }
        else {
            if (rt000_aes != cAES_INSERT) {
                rt000_stlidentnr_neu = rt000_stlidentnr_f100
                rt000_stlvar_neu     = rt000_stlvar_f100
                rt000_datvon_stl     = rt000_datvon_stl_f100
                rt000_stlidentnr_alt = rt000_stlidentnr_neu
                rt000_stlvar_alt     = rt000_stlvar_neu
            }
        }
    }

    // Prüfen aplnr, wenn > 0 und Neuanlage oder geändert
    if (rt000_aplnr_neu > 0) {
        rcL = rt000_sel_f200()
        if (rcL != OK) {
            return rcL
        }

        if (rt000_aplnr_neu == rt000_aplnr_alt) {
            if (rt000_aplidentnr_neu        != NULL \
            && (rt000_aplidentnr_neu ## " " != rt000_aplidentnr_alt ## " " \
            ||  rt000_aplvar_neu ## " "     != rt000_aplvar_alt ## " ")) \
            ||  rt000_altern_neu ## " "     != rt000_altern_alt ## " "
                rt000_aplnr_neu      = NULL
            else {
                rt000_aplidentnr_neu = rt000_aplidentnr_alt
                rt000_aplvar_neu     = rt000_aplvar_alt
            }
        }
        else {
            if (rt000_aes != cAES_INSERT) {
                rt000_aplidentnr_neu = rt000_aplidentnr_f200
                rt000_aplvar_neu     = rt000_aplvar_f200
                rt000_datvon_apl     = rt000_datvon_apl_f200
                rt000_aplidentnr_alt = rt000_aplidentnr_neu
                rt000_aplvar_alt     = rt000_aplvar_neu
            }
        }
    }

    // Prüfung, ob Stücklisten/ Arbeitsplantausch vorliegt, wenn Änderung
    if rt000_aes != cAES_UPDATE && rt000_aes != cAES_REKONFIG
        return OK

    if rt000_stlidentnr_neu == rt000_stlidentnr_alt \
    && rt000_stlvar_neu     == rt000_stlvar_alt \
    && rt000_stlnr_neu      == rt000_stlnr_alt \
    && rt000_staltern_neu   == rt000_staltern_alt \
    && rt000_aplidentnr_neu == rt000_aplidentnr_alt \
    && rt000_aplvar_neu     == rt000_aplvar_alt \
    && rt000_aplnr_neu      == rt000_aplnr_alt \
    && rt000_agaltern_neu   == rt000_agaltern_alt \
    && rt000_altern_neu     == rt000_altern_alt {
       if (rt000_aes == cAES_UPDATE) {
           return  OK
       }

       if (antwort_r0000603 == FALSE) {
            // Stückliste/Arbeitsplan gleich. Weiter?
            rcL = bu_msg("r0000603")
            log LOG_DEBUG, LOGFILE, "Meldung r0000603 rc=" ## rcL
            if (rcL == MSG_NO) {
                call bu_rollback()
                return WARNING
            }
            else if (rcL == MSG_ABORT || rcL == MSG_CANCEL) {
                return on_error(FAILURE)
            }
            else if (rcL == MSG_YESTOALL) {
                antwort_r0000603 = TRUE
            }
        }
    }

    rt000_aes = cAES_UPDATE

    // wenn Status keinen Tausch mehr zuläßt (Parameter)
    if (fkfsL > rt000_R_FS_TAUSCH(1, 1)) {
        // kein Stücklisten-/ Arbeitsplantausch im untergeordneten Fertigungsauftrag da Status bereits >%s<
        return on_error(WARNING, "r0000244", fkfsL, rt000_prot)
    }
    else if (fkfsL           == rt000_R_FS_TAUSCH(1, 1) \
         &&  rt000_R_FS_TAUSCH == "41" \
         &&  rt000_aenddr      >  "0") {
        // Fertigungsauftrag hat Status %s, kein STL-APL-Tausch möglich
        return on_error(WARNING, "r0000244", fkfsL, rt000_prot)
    }


    // wenn bereits eingeplant, Tausch anstoßen
    if (fkfsL > FSTATUS_ERFASST) {
        rt000_aes = cAES_REKONFIG
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_felder_fa
#
# Bestimmte Felder müssen berechnet bzw. gesetzt werden
# - Leitzahl vergeben bei Neuanlage
# - Mengen
#   . Sollmenge aufrunden bei bestimmten Maßeinheiten (lt. Parameter
#     ME_GANZ)
#   . Menge und Ausschußmenge auf 0 setzen bei Löschen
#   . offene Menge entsprechend Menge neu setzen
# - Fertigungsstatus setzen bei Neuanlage abhängig vom Simulationsmodus
# - Termine
#   bei Primärauftragsverwaltung werden die FA-Termine = den neuen
#   Wunschterminen gesetzt. Ansonsten werden bei Neuanlage die
#   Wunschtermine = den neuen Auftragsterminen gesetzt
# - Durchlaufzeit = 0
# - Terminierungsart = 0 (rückwärts)
# - Verzug berechnen
# - Setzen Stücklistendaten
# - Setzen Arbeitsplandaten
# - rt000_austragen_ressourcenkonflikte wird ermittelt
#--------------------------------------------------------------------

int proc rt000_felder_fa(string tkzP, string fu_bedr_extP, string mkzP, boolean termine_beibehaltenP, cdtGq300 standortkalenderP, string kn_aend_faP)
{
    int     rcL
    cdt     datumL
    string  fkfsL
    boolean kostentraegerL  = FALSE
    boolean menge_austragenL = FALSE


    rt000_austragen_ressourcenkonflikte = FALSE


    // 300186024: Matbuch wird "nicht-reproduziebar" manchmal auf "" gesetzt. Deshalb hier eine Sicherheitsprüfung
    if (rt000_matbuch == NULL) {
//        log LOG_DEBUG, LOGFILE, "rt000_matbuch is empty! \n " ## md_get_stacktrace(0)
        rt000_matbuch = bu_getenv("R_MATBUCH")
    }

    if (rt000_fklz_uebg == NULL) {
        rt000_fklz_prim = NULL
        rt000_fklz_var  = NULL
    }

    // Leitzahlvergabe bei Neuanlage
    if (rt000_aes == cAES_INSERT) {
        if (rt000_fklz == NULL) {
            rt000_fklz = bu_getnr("N")
            if (rt000_fklz == "ERROR" || rt000_fklz == FAILURE) {
                // Fehler bei Vergabe der Auftragskopfleitzahl
                return on_error(FAILURE, "r0000126", NULL, rt000_prot)
            }
        }

        if (cod_aart_primaer(rt000_aart) == TRUE && rt000_fklz_uebg == NULL) {
            rt000_fklz_prim = rt000_fklz
        }

    }

    if (rt000_aes != cAES_DELETE && rt000_var_neu != NULL) {
        if (cod_aart_primaer(rt000_aart) == TRUE) {
            rt000_fklz_var = rt000_fklz
        }
    }

    // Reparaturauftrag?
    if (cod_aart_reparatur(rt000_aart) == TRUE) {
        // Hat keine Stammdaten, es erfolgt auch keine Bedarfsrechnung
        rt000_stlidentnr_neu = ""
        rt000_stlvar_neu = ""
        rt000_aplidentnr_neu = ""
        rt000_aplvar_neu = ""
        // Soll gemäß Parametereinstellung nicht dispositiv betrachtet werden
        if (R_AART7_DISP == "0") {
            rt000_da = DA_NICHT
        }
    }

    // kn_lgres setzten
    // 2.Stelle aus Parameter nehmen und prüfen ob sie gefüllt ist
    // wenn 2. Stelle nicht gesetzt dann wird erste Stelle genommen
    if (rt000_kn_lgres_neu == NULL) {
        rt000_kn_lgres_neu = L_LGRESRt000(2, 1)
        if (rt000_kn_lgres_neu == NULL) {
            rt000_kn_lgres_neu = L_LGRESRt000(1, 1)
        }
    }

    rt000_rkz = RKZ_UNDEFINIERT
    if (rt000_aes != cAES_INSERT) {
        if (rt000_kn_lgres_alt != rt000_kn_lgres_neu || \
            rt000_vv_nr_alt    != rt000_vv_nr_neu    || \
            rt000_kneintl_alt  != rt000_kneintl_neu) {
            rt000_rkz = RKZ_JA
        }
    }

    if (rt000_kn_unterbr_neu == NULL) {
        rt000_kn_unterbr_neu = 0
    }

    // 300160475
    // 300166130: Ausgabe der Meldung (4. Parameter)
    rt000_kn_kapaz_neu = fertig_pruefe_kn_kapaz(rt000_termstr_neu, \
                                                rt000_kn_kapaz_neu, \
                                                TRUE, \
                                                rt000_fklz, \
                                                boa_cdt_get(name_cdtTermGlobal_rt000), \
                                                standortkalenderP)
    switch (rt000_kn_kapaz_neu)  {
        case cKNKAPAZ_KEINE:
        case cKNKAPAZ_MAT:
        case cKNKAPAZ_APZ:
        case cKNKAPAZ_BEIDES:
            break
        else:
            rt000_kn_kapaz_neu = cKNKAPAZ_KEINE
            break
    }

    if (rt000_kn_prodplan == NULL) {
        rt000_kn_prodplan = 0
    }

    if (rt000_aes != cAES_DELETE) {
        // Sollmenge aufrunden, wenn Maßeinheit so definiert
        rt000_menge_rund = chk_ganzzahlig(rt000_me, rt000_menge_neu)

        if (rt000_menge_rund != rt000_menge_neu) {
            // Auflagemenge %s %s wurde aufgerundet
            call on_error(INFO, "r0000108", rt000_menge_neu ## "^" ## rt000_me, rt000_prot)
            rt000_menge_neu = rt000_menge_rund
        }

        // Ausschußmenge aufrunden, wenn Maßeinheit so definiert
        rt000_menge_rund = chk_ganzzahlig(rt000_me, rt000_menge_aus_neu)
        if (rt000_menge_rund != rt000_menge_aus_neu) {
            // Ausschußmenge %s %s wurde aufgerundet
            call on_error(INFO, "r0000152", rt000_menge_aus_neu ## "^" ## rt000_me, rt000_prot)
            rt000_menge_aus_neu = rt000_menge_rund
        }
    }


    // offene Menge
    if (rt000_aes == cAES_INSERT) {
        rt000_menge_offen_neu = rt000_menge_neu
        rt000_menge_offen_alt = 0.0
    }
    else if (rt000_aes == cAES_DELETE) {
        // abhängig von Status und Auftragsart
        // Beim Löschen muss zwischen dem Löschen über die Nettobedarfsrechnung ("3")
        // und sonstigen Programmen unterschieden werden
        menge_austragenL = FALSE
        if (rt000_fkfs > FSTATUS_ERFASST) {
            // Normale FA im Status > 1 (erfasst):
            if ( \
                (cod_aart_vertriebsfa(rt000_aart) != TRUE || rt000_verw_art == "3") && \
                 cod_aart_vdispo(rt000_aart)      != TRUE && \
                 cod_aart_planauftrag(rt000_aart) != TRUE \
            ) {
                menge_austragenL                    = TRUE
                rt000_austragen_ressourcenkonflikte = TRUE
            }
            else if (cod_aart_vertriebsfa(rt000_aart) == TRUE \
                 &&  rt000_R_FA_STORNO                 == "1") {
                // 300397191:
                // Wenn der Parameter gesetzt ist, soll auch bei Primäraufträgen aus dem Vertriebsvorgang die Menge(n)
                // ausgetragen werden,
                menge_austragenL                    = TRUE
                rt000_austragen_ressourcenkonflikte = TRUE
            }
        }
        else if (rt000_fkfs_a > FSTATUS_ERFASST) {
            // Simulative FA im Status > 1 (erfasst):
            if (rt000_verw_art                    == "5" \
            &&  cod_aart_lagerauftrag(rt000_aart) == TRUE ) {
                // 300424085:
                // Simulative Lageraufträge sollen über rv0000 gelöscht werden können. Es muss die Menge auf 0 gesetzt
                // werden, damit diese dann im rh110 korrekt gelöscht werden
                menge_austragenL                    = TRUE
                rt000_austragen_ressourcenkonflikte = TRUE
            }
            else {
                // Diese Abhandlung kam vermutlich über Ticket 300070773 rein (es ist unklar wieso genau)
                if ( \
                    ( \
                        cod_aart_primaer(rt000_aart)     == FALSE || \
                        cod_aart_planauftrag(rt000_aart) == TRUE \
                    ) \
                ) {
                    menge_austragenL                    = TRUE
                    rt000_austragen_ressourcenkonflikte = TRUE
                }
            }
        }
        else if (rt000_fkfs == FSTATUS_ERFASST || rt000_fkfs_a == FSTATUS_ERFASST) {
            // Alle FA im Status "erfasst"
            menge_austragenL = TRUE
        }

        log LOG_DEBUG, LOGFILE, "aart >" ## rt000_aart ## "< / " \
                             ## "verw_art >" ## rt000_verw_art ## "< / " \
                             ## "rt000_fkfs >" ## rt000_fkfs ## "< / " \
                             ## "rt000_fkfs_a >" ## rt000_fkfs_a ## "< / " \
                             ## "rt000_R_FA_STORNO >" ## rt000_R_FA_STORNO ## "< / " \
                             ## "menge_austragen " ## menge_austragenL ## "< / " \
                             ## "ressoucenkonflikt_austragen >" ## rt000_austragen_ressourcenkonflikte ## "<"

        // Austragen der Mengen beim Löschen/Stornieren FA
        if (menge_austragenL == TRUE) {
            rt000_menge_neu       = 0.0
            rt000_menge_offen_neu = 0.0
        }

        // 300397191 - Ressouercenkonflikte aufheben Teil 1:
        // Löschen des Ressoucenkonfliktes in Tabelle r070 und r0701. Der Update auf r000 erfolgt zusammen mit den
        // restlichen r000-Feldern, damit hier nicht unnötigerweise eine "leerer" Update gemacht wird.
        // Hier haben ist die r000 noch nicht gelesen, um sie mit dem neuen Wert zu vergleichen!
        if (rt000_loeschen_resourcenkonflikte() != OK) {
            return FAILURE
        }
    }
    else {
        rt000_menge_offen_neu = rt000_menge_neu - rt000_menge_gef
        if (rt000_menge_offen_neu < 0.0) {
            rt000_menge_offen_neu = 0.0
        }
    }

    // Fertigungsstatus setzen bei Neuanlage
    // Beim Aufruf über rm1004i1 wird fkfs/fkfs_a voreingestellt
    // 300258082 - Bei Aufruf aus der BVOR-Übernahme (verw_art = 1") werden die Stati schon von
    //             rt010d gesetzt und müssen nicht mehr übersteuert werden
    if ( \
        rt000_aes      == cAES_INSERT && \
        rt000_verw_art != "3"         && \
        rt000_verw_art != "1" \
    ) {
        // im Simulationsmodus mit Status = 0 anlegen, Status alt analog Status
        if (SIM == TRUE) {
            rt000_fkfs   = FSTATUS_SIM
            rt000_fkfs_a = FSTATUS_ERFASST
        }
        else {
            if (cod_aart_versorg(rt000_aart) == TRUE) {
                rt000_fkfs   = FSTATUS_TERMINIERT
                rt000_fkfs_a = NULL
            }
            else {
                rt000_fkfs   = FSTATUS_ERFASST
                rt000_fkfs_a = NULL
            }
        }
    }

    // umladen der Wunschtermine bzw. der Auftragstermine
    if (rt000_verw_art == "1") {
        if (rt000_aes == cAES_INSERT   || rt000_aes == cAES_UPDATE || \
            rt000_aes == cAES_REKONFIG || rt000_aes == "9") {
            rt000_fsterm_uhr_neu    = rt000_fsterm_w_uhr_neu
            rt000_fortsetz_uhr_neu  = NULL
            rt000_seterm_uhr_neu    = rt000_seterm_w_uhr_neu
        }
    }
    else if (rt000_verw_art == "5") && ((cod_aart_primaer(rt000_aart) == TRUE) && (rt000_fkfs > FSTATUS_ERFASST || rt000_fkfs_a > FSTATUS_ERFASST)) {
        // Bei Primäraufträgen muss fsterm = fsterm_w und seterm = seterm_w sein, da die Terminierung im rh110 nie von den Wunschtermin-Feldern
        // ausgeht; Und dass beim Einfügen bzw. Kopieren eines FA und bei der Strukturterminierung sollen gleich wie die Neueinplanung
        // abgehandelt werden.
        if (rt000_aes == cAES_INSERT) {
            rt000_fsterm_uhr_neu    = rt000_fsterm_w_uhr_neu
            rt000_fortsetz_uhr_neu  = NULL
            rt000_seterm_uhr_neu    = rt000_seterm_w_uhr_neu
        }
    }


    // Mengen/ Terminänderung
    rcL = rt000_mengen_termine_fa(tkzP, fu_bedr_extP, mkzP, termine_beibehaltenP, standortkalenderP)
    if (rcL != OK) {
        return rcL
    }

    // Änderung Projekt-ID
    rcL = rt000_ermitteln_aenderung_projekt_id(fu_bedr_extP, kn_aend_faP)
    if (rcL != OK) {
        return rcL
    }

    // Reihenfolgeprüfung
    rcL = rt000_pruefen_kn_reihenfolge(standortkalenderP)
    if (rcL != OK) {
        return rcL
    }


    // Verzug berechnen (wenn Status = 0, ist Status alt maßgebend)
    // 300333295: Beim Löschen der r000 muss der Verzug nicht neu berechnet werden
    if (rt000_aes != cAES_DELETE) {
        datumL = fertig_getDatum(rt000_handle_gm300, "get;prev;first", $NULL, @date(rt000_seterm_uhr_neu))
        if (md_isnull(datumL) == TRUE) {
            return on_error(FAILURE, NULL, NULL, rt000_prot)
        }

        rt000_sefkt = datumL=>fkt

        call gm300_activate(rt000_handle_gm300)
        public ri070:(EXT)
        fkfsL = fertig_get_fkfs(rt000_fkfs, rt000_fkfs_a)
        rt000_vzzeit = ri070_vzzeit_fa(rt000_fklz, fkfsL, rt000_sefkt, rt000_dlzeit, rt000_vzag)
        call gm300_deactivate(rt000_handle_gm300)
    }


    // 300401388: FA-Verschoben setzen
    rcL = rt000_pruefen_fa_verschoben(standortkalenderP)
    if (rcL != OK) {
        return rcL
    }


    // setzen Stücklistendaten
    rcL = rt000_stl_fa()
    if (rcL != OK) {
        return OK
    }

    // setzen Arbeitsplandaten
    rcL = rt000_apl_fa()
    if (rcL != OK) {
        return OK
    }

    // Kostenträgerermittlung bei Neuanlage
    // Ist rt000_fklz_uebg != NULL, wird der Kostenträger aus der
    // integrierten Versorgung übernommen, der Versorgungsauftrag wird
    // wie ein Sekundärauftrag abgehandelt
    kostentraegerL = FALSE
    if (C_KTR_AKTIV == TRUE \
    &&  rt000_aes   == cAES_INSERT) {
        if (rt000_fklz_uebg == "") {
            kostentraegerL = TRUE
        }
        else if (rt000_aart == "3") {
            // Analog rt100_untg
            kostentraegerL = TRUE
        }
    }

    if (kostentraegerL == TRUE)   {
        // Modul zum Schreiben des Kostenträgerstamms wird zentral geladen
        call cm100_activate(ktr_handle_cm100)
        call cm100_init()

        aufnrCm100       = rt000_aufnr
        aufposCm100      = rt000_aufpos
        auf_artCm100     = NULL
        kosttraegerCm100 = rt000_kosttraeger
        identnrCm100     = rt000_identnr_neu
        varCm100         = rt000_var_neu
        kontoCm100       = NULL
        satzartCm100     = NULL
        fklzCm100        = rt000_fklz
        projekt_idCm100  = rt000_projekt_id_neu
        woherCm100       = "2" // Fertigung
        zustandCm100     = 2   // Insert

        if (cm100_verwalten(ktr_handle_cm100) < OK) {
            // Fehler bei der Verarbeitung des Kostenträgerstammsatzes!
            call bu_msg("c1000133")
            call cm100_deactivate(ktr_handle_cm100)
            return on_error(FAILURE)
        }

        // Ermittelten Kostenträger umladen
        rt000_kosttraeger = kosttraeger_neuCm100
        call cm100_deactivate(ktr_handle_cm100)
    }

    if (dm_is_cursor("curTSTRt000") != TRUE) {
        dbms declare curTSTRt000 cursor for \
            select \
                g020.kn_nettobedarf, \
                g020.bm, \
                g020.kn_kanban, \
                g020.kn_lgdisp \
            from \
                g020 \
            where \
                g020.fi_nr   = ::_1 and \
                g020.identnr = ::_2 and \
                g020.var     = ::_3 and \
                g020.werk    = ::_4 and \
                g020.lgnr    = ::_5
        dbms with cursor curTSTRt000 alias \
            kn_nettobedarfRt000, \
            bmRt000, \
            kn_kanbanRt000, \
            kn_lgdisp_neuRt000
    }

    dbms with cursor curTSTRt000 execute using \
        FI_NR1, \
        rt000_identnr_neu, \
        rt000_var_neu, \
        rt000_werk, \
        rt000_lgnr_neu, \
        FI_G000

    if (kn_nettobedarfRt000 == NULL) {
        if (rt000_da == DA_AUFTRAG) {
            kn_nettobedarfRt000 = R_NETTOBEDARFRt000(1, 1)
        }
        else if (rt000_da == DA_BEDARF) {
            kn_nettobedarfRt000 = R_NETTOBEDARFRt000(2, 1)
        }
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_mengen_termine_fa
#
# Prüfen und setzen Felder bei Mengen-/ Terminänderung
# - Prüfung auf Mengenunterdeckung übergeordnete Bedarfe bei Mengenänderung
#   oder Stornierung
#   diese liegt vor, wenn Menge - abgesetzte Menge - Summe überg. Bedarf
#   ohne abgesetzte und abgeglichene Menge < 0
# - Prüfen, ob Mengen- und/oder Terminänderung
#   bei Neuanlage und Löschen liegt immer eine Mengen- UND Termin-
#   änderung vor
# - Setzen Terminierungsart und Änderungskennzeichen für r115
#   allerdings nur, wenn Auftrag bereits eingeplant
#   bei Primärauftragsverwaltung wird immer eine Strukturterminierung
#   ansonsten eine Baukastenterminierung angestoßen
# - Bei Baukastenterminierung und Terminänderung prüfen, ob
#   Verschiebung der überg. Struktur durchgeführt werden soll
#--------------------------------------------------------------------

int proc rt000_mengen_termine_fa(string tkzP, string fu_bedr_extP, string mkzP, boolean termine_beibehaltenP, cdtGq300 standortkalenderP)
{
    int      rcL
    string   tkzL
    cdtRq000 cdtRq000L
    R000CDBI r000L
    R000CDBI r000_altL
    boolean  strukturL
    boolean  baukastenL
    boolean  mengenaenderungL


    // 1) Prüfung Mengenunterdeckung bei Änderung oder Stornierung
    if ( \
        ( \
            rt000_aes == cAES_UPDATE   || \
            rt000_aes == cAES_DELETE   || \
            rt000_aes == cAES_REKONFIG || \
            rt000_aes == "9" \
        ) && \
        ( \
            rt000_menge_neu != rt000_menge_alt \
        ) \
    )  {
        // Lesen Summe übergeordnete Bedarfe
        if (rt000_sel_sum_bed() < OK) {
            return FAILURE
        }

        // Liegt Mengenunterdeckung vor ?
        if (rt000_menge_neu - rt000_menge_abg - rt000_sum_bed_uebg < 0) {
            if (rt000_menge_alt > rt000_menge_neu) {
                if (antwort_r0000172 == FALSE \
                &&  BATCH            != TRUE) {
                    // Mengenänderung führt zu einer Unterdeckung der zugeordneten Bedarfe.
                    // Wollen Sie dies zulassen?
                    switch (bu_msg("r0000172")) {
                        case MSG_YES:
                            break
                        case MSG_NO:
                            call bu_rollback()
                            return WARNING
                        case MSG_YESTOALL:
                            antwort_r0000172 = TRUE
                            break
                        else:
                            return on_error(FAILURE)
                    }
                }
            }
            else {
                if (antwort_r0000173 == FALSE \
                &&  BATCH            != TRUE) {
                    jamnum = (-1) * (rt000_menge_neu - rt000_menge_abg - rt000_sum_bed_uebg)

                    // Trotz der Mengenerhöhung ist der zugeordnete Bedarf um %1 %2 unterdeckt.
                    // Wollen Sie dies zulassen? == %1 = unterdeckte Menge, %2 = Maßeinheit
                    switch (bu_msg("r0000173", jamnum ## "^" ## rt000_me)) {
                        case MSG_YES:
                            break
                        case MSG_NO:
                            call bu_rollback()
                            return WARNING
                        case MSG_YESTOALL:
                            antwort_r0000173 = TRUE
                        else:
                            return on_error(FAILURE)
                    }
                }
            }
        }
    }


    // 300317547:
    // Prüfen, ob Kalender ausreicht
    rcL = rt000_check_standortkalender(standortkalenderP)
    if (rcL != OK) {
        return rcL
    }


    public rq000.bsl
    cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)
    r000L     = rq000_get_r000(cdtRq000L)
    r000_altL = rq000_get_r000_alt(cdtRq000L)


    // 2) Prüfungen angearbeiteter FA
    if (rt000_aes != cAES_DELETE) {
        // 300185637: Prüfen fsterm angearbeiteter FA
        rcL = rt000_pruefen_fsterm_status6(standortkalenderP, cdtRq000L)
        if (rcL != OK) {
            return rcL
        }

        // 300185637: Prüfen fsterm_w angearbeiteter FA
        rcL = rt000_pruefen_fsterm_w_status6()
        if (rcL != OK) {
            return rcL
        }
    }


    // 3) Kennzeichen Mengen-/ Terminänderung initialisieren
    rt000_mkz        = MKZ_UNDEFINIERT
    rt000_tkz        = cTKZ_KEINE
    rt000_kn_aend_fa = KN_AEND_FA_KEINE     // Setzen auf "0" für Protokollierung in r016, da hier niemals ein FU_BEDR=0 erzeugt wird


    // 4) bei Neuanlage, Tausch und Löschen liegt immer eine Mengenänderung vor und die
    // Terminierung ist undefiniert (dlzeit)
    // Das gleiche gilt, wenn Auftrag noch nicht eingeplant
    if ( \
        rt000_aes == cAES_INSERT   || \     // Neuanlage
        rt000_aes == cAES_REKONFIG || \     // Tausch
        rt000_aes == "9"           || \     // Storno?
        ( \
            rt000_aes == cAES_UPDATE && \
            ( \
                rt000_fkfs   == FSTATUS_ERFASST || \
                rt000_fkfs_a == FSTATUS_ERFASST \
            ) \
        ) \
    ) {
        // Prüfung Endtermin < Starttermin
        if ( \
            rt000_aes != "9" && \
            @time(rt000_seterm_uhr_neu) < @time(rt000_fsterm_uhr_neu) \
        ) {
            // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
            return on_error(WARNING, "r0000129", rt000_seterm_uhr_neu ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
        }

        if (cod_aart_versorg(rt000_aart) != TRUE) {
            rt000_dlzeit  = 0
        }


        // 300354288:
        // Übergebenes MKZ übernehmen
        if (rt000_aes            == cAES_REKONFIG \
        &&  termine_beibehaltenP == TRUE) {
            rt000_mkz = mkzP
            log LOG_DEBUG, LOGFILE, "mkz >" ## rt000_mkz ## "< von extern übernommen / fklz >" ## rt000_fklz ## "<"
        }
        else {
            rt000_mkz = MKZ_JA
            log LOG_DEBUG, LOGFILE, "mkz >" ## rt000_mkz ## "< auf >1< gesetzt / fklz >" ## rt000_fklz ## "<"
        }


        if (rt000_aes == "9") {
            rt000_tkz = cTKZ_BAUKASTEN_MIT_VERSCHIEB

            // 300247960;
            // Beim Kritischen Pfad darf keine TERMART = 1 eingestellt sein.
            if (rt000_termstr_neu == cTERMSTR_KRITISCH) {
                rt000_termart_neu = cTERMART_KRITISCH
            }
            else if (rt000_termart_alt == cTERMART_RUECKW) {
                rt000_termart_neu = cTERMART_VORW
            }
            else {
                rt000_termart_neu = rt000_termart_alt
            }

            if (rt000_termart_neu == NULL) {
                rt000_termart_neu = rt000_termstr_neu
            }
        }
        else if (rt000_aes == cAES_REKONFIG) {
            // Das Setzen der Strukturterminierung darf nicht bei Sekundäraufträgen passieren,
            // wenn ein Tausch angestossen wird. Sonst werden beim Tausch am Ende diese Funktion die Termine
            // auf die Wunsch-Termine gesetzt

            // 300354288:
            // Im Spezialfall "Wandle fu_bedr=2 nach 4" im re000 dürfen die Termine (etc.) nicht verändert werden
            if (termine_beibehaltenP == TRUE \
            &&  tkzP                 != cTKZ_KEINE) {
                rt000_tkz = tkzP
            }
            else {
                if (cod_aart_nosek(rt000_aart) == TRUE) {
                    rt000_tkz = cTKZ_STRUKTUR
                }
                else {
                    rt000_tkz = cTKZ_BAUKASTEN_OHNE_VERSCHIEB
                }

                rt000_termart_neu = rt000_termstr_neu
            }
        }
        else {
            if (tkzP != cTKZ_KEINE) {
                rt000_tkz = tkzP
            }
            else {
                rt000_tkz = cTKZ_STRUKTUR
            }

            rt000_termart_neu = rt000_termstr_neu
        }
        log LOG_DEBUG, LOGFILE, "rt000_tkz >" ## rt000_tkz ## "< bei Neuanlage/Kopiern/Rekonfiguration..."
    }
    else if (rt000_aes == cAES_DELETE) {    // Löschen FA
        rt000_dlzeit  = 0
        rt000_tkz     = cTKZ_STRUKTUR
        rt000_mkz     = MKZ_JA
        log LOG_DEBUG, LOGFILE, "mkz >" ## rt000_mkz ## "< auf >1< gesetzt / fklz >" ## rt000_fklz ## "< (aes = DELETE)"
    }
    else {      // Ändern FA
        if (rt000_termart_neu == NULL) {
            rt000_termart_neu = rt000_termstr_neu
        }

        // 5) liegt eine Terminänderung vor?

        // 5a) Strukturänderung?
        call rq000_set_fklz(cdtRq000L, rt000_fklz)
        call rq000_set_fkfs(cdtRq000L, rt000_fkfs)
        call rq000_set_fkfs_a(cdtRq000L, rt000_fkfs_a)
        call rq000_set_aart(cdtRq000L, rt000_aart)
        call rq000_set_fsterm_w_uhr(cdtRq000L, rt000_fsterm_w_uhr_neu)
        call rq000_set_seterm_w_uhr(cdtRq000L, rt000_seterm_w_uhr_neu)
        call rq000_set_seterm_w(cdtRq000L, rt000_seterm_w_neu)
        call rq000_set_termstr(cdtRq000L, rt000_termstr_neu)
        call rq000_set_kn_kapaz(cdtRq000L, rt000_kn_kapaz_neu)
        call rq000_set_kn_unterbr(cdtRq000L, rt000_kn_unterbr_neu)
        call rq000_set_clear_message(cdtRq000L, TRUE)

        strukturL = rq000_is_strukturterminierung(cdtRq000L, $NULL)
        call rt000_protokoll_aus_rq000(cdtRq000L, OK)

        // 5b) Baukastenänderung/-verschiebung?
        cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, "", standortkalenderP)
        call rq000_set_r000(cdtRq000L, r000L, FALSE)
        call rq000_set_r000_alt(cdtRq000L, r000_altL)

        call rq000_set_fklz(cdtRq000L, rt000_fklz)
        call rq000_set_fkfs(cdtRq000L, rt000_fkfs)
        call rq000_set_fkfs_a(cdtRq000L, rt000_fkfs_a)
        call rq000_set_menge(cdtRq000L, rt000_menge_neu)
        call rq000_set_menge_aus(cdtRq000L, rt000_menge_aus_neu)
        call rq000_set_fsterm_uhr(cdtRq000L, rt000_fsterm_uhr_neu)
        call rq000_set_fsterm(cdtRq000L, @format_date(rt000_fsterm_uhr_neu, DATEFORMAT0))
        call rq000_set_fortsetz_uhr(cdtRq000L, rt000_fortsetz_uhr_neu)
        if (rt000_fortsetz_uhr_neu != NULL) {
            call rq000_set_fortsetz_dat(cdtRq000L, @format_date(rt000_fortsetz_uhr_neu, DATEFORMAT0))
        }
        else {
            call rq000_set_fortsetz_dat(cdtRq000L, $NULL)
        }
        call rq000_set_seterm_uhr(cdtRq000L, rt000_seterm_uhr_neu)
        call rq000_set_seterm(cdtRq000L, rt000_seterm_neu)
        call rq000_set_termart(cdtRq000L, rt000_termart_neu)
        call rq000_set_red_faktor(cdtRq000L, rt000_red_faktor_neu)
        call rq000_set_clear_message(cdtRq000L, TRUE)

        baukastenL = rq000_is_baukastenterminierung(cdtRq000L)
        call rt000_protokoll_aus_rq000(cdtRq000L, OK)

        // 5c) bei Änderung Wunschtermin oder Termart-Struktur wird immer eine Strukturterminierung
        // angestoßen, sonst eine Baukastenterminierung
        if (tkzP != cTKZ_KEINE) {
            rt000_tkz = tkzP
        }
        else {
            cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)

            call rq000_set_aart(cdtRq000L, rt000_aart)
            call rq000_set_kz_fix(cdtRq000L, rt000_kz_fix_neu)
            call rq000_set_kz_fix_alt(cdtRq000L, rt000_kz_fix_alt)
            rt000_tkz = rq000_tkz_ermitteln(cdtRq000L, strukturL, baukastenL)
        }


        // 6) liegt eine Mengenänderung vor?
        cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, "", standortkalenderP)
        call rq000_set_r000(cdtRq000L, r000L, FALSE)
        call rq000_set_r000_alt(cdtRq000L, r000_altL)

        call rq000_set_fklz(cdtRq000L, rt000_fklz)
        call rq000_set_fkfs(cdtRq000L, rt000_fkfs)
        call rq000_set_fkfs(cdtRq000L, rt000_fkfs_a)
        call rq000_set_menge(cdtRq000L, rt000_menge_neu)
        call rq000_set_menge_aus(cdtRq000L, rt000_menge_aus_neu)
        call rq000_set_clear_message(cdtRq000L, TRUE)

        mengenaenderungL = rq000_is_mengenaenderung(cdtRq000L)
        call rt000_protokoll_aus_rq000(cdtRq000L, OK)
        if (mengenaenderungL == TRUE) {
            rt000_mkz = MKZ_JA
            log LOG_DEBUG, LOGFILE, "mkz >" ## rt000_mkz ## "< auf >1< gesetzt / fklz >" ## rt000_fklz ## "< (mengenaenderungL = TRUE)"
        }


        // 7) Setzen Terminierungsart und DLZ
        if (rt000_tkz != cTKZ_KEINE \
        ||  rt000_mkz == MKZ_JA) {
            rt000_dlzeit = 0

            if (rt000_tkz == cTKZ_STRUKTUR) {
                // 300168307 (Fehler 1)
                // Die termart darf hier nicht grundsätzich auf "Rückwärts" geändert werden, da
                // sonst immer eine Rückwärtsterminierung beginnt: Im rt210_param_1 die Termart von r000 auf r200
                // durchgereicht wurde und auch gleich eingelastet wird.
                // Wenn z.B, nur die Menge geändert wurde darf nicht bei termstr=1 eine Rückwärtsverschiebung ausgelöst werden.
                // Es soll bei tkz = 0 immer termart = termstr sein. Einzige Ausnahme: termart wurde manuell geändert!
                if (rt000_termart_neu == rt000_termart_alt) {
                    rt000_termart_neu = rt000_termstr_neu
                }
            }
        }


        // Wenn tkz auf einem ungültigen Wert steht, dann keine Terminänderung
        switch (rt000_tkz) {
            case cTKZ_STRUKTUR:
            case cTKZ_BAUKASTEN_MIT_VERSCHIEB:
            case cTKZ_BAUKASTEN_OHNE_VERSCHIEB:
                break
            else:
                rt000_tkz = cTKZ_KEINE
                break
        }


        // Bei Terminänderung ggf. fragen, ob Verschiebung überg. Struktur verschoben werden soll oder nicht.
        // 300173107:
        // Die Abhandlung mit R_VERSCHIEB und der Frage soll nur bei Sekundäraufträgen und nicht bei
        // Verriebsaufträgen (aart=1) und Vorausdispo-Aufträgen (aart=6) kommen.
        // 300225013:
        // Auch bei 2 (nicht nur 1) muss der R_VERSCHIEB abgehandelt werden. Nur wenn schon feststeht, dass
        // es eine Strukturterminieurng ist, muss er nicht abgehandelt werden.
        // 300346623:
        // Wenn tkz nicht gefüllt, dann sollte auch bei einem Sek-FA kein Aktionssatz abgestellt werden.
        if (cod_aart_sek(rt000_aart) == TRUE \
        &&  (rt000_tkz == cTKZ_BAUKASTEN_MIT_VERSCHIEB || rt000_tkz == cTKZ_BAUKASTEN_OHNE_VERSCHIEB  )) {
            if (rt000_R_VERSCHIEB == "1") {
                rt000_tkz = cTKZ_BAUKASTEN_MIT_VERSCHIEB
            }
            else if (rt000_R_VERSCHIEB == "2") {
                if (antwort_r0000131 == FALSE) {
                    // Mengen-/ Terminänderung !!
                    // Soll die übergeordnete Auftragsstruktur
                    // verschoben werden?
                    if (BATCH != TRUE) {
                        // Mengen-/ Terminänderung !!
                        // Soll die übergeordnete Auftragsstruktur verschoben werden?
                        rcL = bu_msg("r0000131")
                    }
                    else {
                        rcL = MSG_YESTOALL
                    }

                    log LOG_DEBUG, LOGFILE, "Meldung r0000131 rcL >:rcL< "
                    switch (rcL) {
                        case MSG_YES:
                            rt000_tkz = cTKZ_BAUKASTEN_MIT_VERSCHIEB
                            break
                        case MSG_YESTOALL:
                            rt000_tkz = cTKZ_BAUKASTEN_MIT_VERSCHIEB
                            antwort_r0000131 = TRUE
                            break
                        case MSG_NO:
                            rt000_tkz = cTKZ_BAUKASTEN_OHNE_VERSCHIEB
                            break
                        case MSG_NOTOALL:  // 300225013
                            rt000_tkz = cTKZ_BAUKASTEN_OHNE_VERSCHIEB
                            antwort_r0000131 = TRUE
                            break
                        else:
                            return on_error(FAILURE)
                    }
                }
                else {
                    rt000_tkz = cTKZ_BAUKASTEN_OHNE_VERSCHIEB   // 300225013
                }
            }
        }
    }


    // 300254582:
    // 8) Prüfen Struktur-Termine auf gültige Uhrzeit und gefüllt
    rcL = rt000_pruefen_termine_struktur_gegen_arbeitszeit(standortkalenderP)
    if (rcL != OK) {
        return FAILURE
    }


    // 300254582:
    // 9) Prüfen/Setzen termstr und termart:
    // - Muss nach Prüfung Strukturtermine kommen da diese verwendet werden
    // - Muss vor Prüfung Baukastentermine kommen, da die Termart dort benötigt wird
    rcL = rt000_pruefen_terminierungsart()
    if (rcL != OK) {
        return FAILURE
    }


    // 300254582:
    // 10) Prüfen Baukasten-Termine auf gültige Uhrzeit und gefüllt
    rcL = rt000_pruefen_termine_bauk_gegen_arbeitszeit(fu_bedr_extP, standortkalenderP)
    if (rcL != OK) {
        return FAILURE
    }


    // 300185637:
    // 11) Fortsetztermin im FA
    rcL = rt000_pruefen_fortsetz_dat_status6()
    if (rcL != OK) {
        return rcL
    }


    // 300272770
    // 12) Bei einer Strukturterminierung (egal wie sie ausgelöst wurde), muss die User-Fixierung aufgehoben werden.
    if (cod_kz_fix_user(rt000_kz_fix_neu) == TRUE) {
        if (rt000_tkz == cTKZ_STRUKTUR) {
            tkzL = cTKZ_STRUKTUR
        }
        else {
            dbms alias tkzL
            dbms sql select r115.tkz \
                     from r115 \
                     where r115.fi_nr = :+FI_NR1 \
                     and   r115.werk  = :+werk \
                     and   r115.fklz  = :+rt000_fklz
            dbms alias
        }

        // 300276094:
        // Bei einer Mengenänderung darf das Fixierungskennzeichen nicht zurück gesetzt werden.
        // Da eine Mengenänderung laut Ticket kein TKZ=0 mehr auslösen kann, passt das hier so.
        if (tkzL == cTKZ_STRUKTUR) {
            // Beim Fertigungsauftrag >%1< ist die Terminfixierung gesetzt und es wird eine Strukturterminierung angestossen. Die Benutzer-Fixierung wird aufgehoben.
            call on_error(INFO, "r0000630", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_HINWEIS)

            if (rt000_kz_fix_neu == cKZ_FIX_BEIDES) {
                rt000_kz_fix_neu = cKZ_FIX_SYSTEM
            }
            else {
                rt000_kz_fix_neu = cKZ_FIX_NEIN
            }
        }
    }


    // 300276094:
    // 13) Meldung, wenn Mengenänderung und User-Fixierung
    if (rt000_mkz                         == MKZ_JA \               // Mengenänderung
    &&  cod_kz_fix_user(rt000_kz_fix_neu) == TRUE \                 // User-Fixierung gesetzt
    &&  screen_name                       == "rv0000" \             // Nur in rv0000
    &&  rt000_aes                         == cAES_UPDATE) {         // Nur bei Änderung FA
        // Meldung abhängig von der neuen TERMART:
        switch (rt000_termart_neu) {
            case cTERMART_VORW:
                // Bitte beachten: Durch die Mengenänderung mit Terminfixierung wird nur der Starttermin des Fertigungsauftrags >%1< fixiert und der Endtermin aufgrund der geänderten Auflagemenge neu ermittelt. Aufgrund der geänderten Bedarfsmengen können sich für Sekundäraufträge abhängig von der Terminierungsart Struktur Terminkonflikte ergeben.
                call on_error(INFO, "r0000633", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_INFO)
                break
            case cTERMART_RUECKW:
            case cTERMART_MITTEL:
                // Bitte beachten: Durch die Mengenänderung mit Terminfixierung wird nur der Endtermin des Fertigungsauftrags >%1< fixiert und der Starttermin aufgrund der geänderten Auflagemenge neu ermittelt. Aufgrund der geänderten Bedarfsmengen können sich für Sekundäraufträge abhängig von der Terminierungsart Struktur Terminkonflikte ergeben.
                call on_error(INFO, "r0000634", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_INFO)
                break
            case cTERMART_KRITISCH:
            else:
                // Keine Meldung
                break
        }
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_stl_fa
#
# Setzen Stücklistendaten
# - nicht bei Löschen
# - wenn STL-Teilenummer geändert, stlnr = NULL setzen
#   --> Kopfauswahl über angegebene STL-Teilenummer
# - wenn Neuanlage oder stlnr geändert
#   . wenn stlnr > 0, übernehmen Daten aus Stücklistenkopf
#     --> dieser Stücklistenkopf wird direkt eingeplant
#   . wenn stlnr = 0, löschen STL-Teilenummer
#     --> Einplanung ohne Stückliste
#   . wenn stlnr = NULL
#     --> Kopfauswahl über angegebene STL-Teilenummer
#--------------------------------------------------------------------
int proc rt000_stl_fa()
{
    vars stlnr_neuL
    vars stlnr_altL

    // nicht bei Löschen
    if (rt000_aes == cAES_DELETE) {
        return OK
    }

    // wenn nicht Neuanlage und Teilenummer geändert, Stücklistennummer entfernen
    if rt000_aes != cAES_INSERT && \
      (rt000_stlidentnr_neu != rt000_stlidentnr_alt || \
       rt000_stlvar_neu     != rt000_stlvar_alt) {
        rt000_stlnr_neu  = NULL
        rt000_datvon_stl = NULL

        rt000_dataen_stl = NULL
        rt000_aendnr_stl = NULL
    }

    // umladen in vars-Felder
    stlnr_altL = rt000_stlnr_alt
    stlnr_neuL = rt000_stlnr_neu

    if (rt000_aes == cAES_INSERT || stlnr_neuL != stlnr_altL) {
        if (stlnr_neuL > 0) {
            rt000_stlidentnr_neu = rt000_stlidentnr_f100
            rt000_stlvar_neu     = rt000_stlvar_f100
            rt000_datvon_stl     = rt000_datvon_stl_f100

            rt000_txt_stl        = rt000_txt_f100
        }
        else {
            if (stlnr_neuL != NULL) {
                rt000_stlidentnr_neu = NULL
                rt000_stlvar_neu     = NULL
            }

            rt000_datvon_stl     = NULL
        }

        rt000_dataen_stl = NULL
        rt000_aendnr_stl = NULL
    }

    return OK
}


#--------------------------------------------------------------------
# rt000_apl_fa
#
# Setzen Arbeitsplandaten
# - nicht bei Löschen
# - wenn APL-Teilenummer geändert, aplnr = NULL setzen
#   --> Kopfauswahl über angegebene APL-Teilenummer
# - wenn Neuanlage oder aplnr geändert
#   . wenn aplnr > 0, übernehmen Daten aus Arbeitsplankopf
#     --> dieser Arbeitsplankopf wird direkt eingeplant
#   . wenn aplnr = 0, löschen APL-Teilenummer
#     --> Einplanung ohne Stückliste
#   . wenn aplnr = NULL
#     --> Kopfauswahl über angegebene STL-Teilenummer
#--------------------------------------------------------------------

int proc rt000_apl_fa()
{
    vars aplnr_neuL
    vars aplnr_altL

    // nicht bei Löschen
    if (rt000_aes == cAES_DELETE) {
        return OK
    }

    // wenn nicht Neuanlage und Teilenummer geändert, Arbeitsplannummer entfernen
    if rt000_aes != cAES_INSERT \
    && (rt000_aplidentnr_neu != rt000_aplidentnr_alt \
    ||  rt000_aplvar_neu     != rt000_aplvar_alt) {
        rt000_aplnr_neu  = NULL
        rt000_datvon_apl = NULL
        rt000_dataen_apl = NULL
        rt000_aendnr_apl = NULL
    }

    aplnr_altL = rt000_aplnr_alt
    aplnr_neuL = rt000_aplnr_neu

    if (rt000_aes == cAES_INSERT || rt000_aes == cAES_REKONFIG || aplnr_neuL != aplnr_altL) {
        if (aplnr_neuL > 0) {
            rt000_aplidentnr_neu = rt000_aplidentnr_f200
            rt000_aplvar_neu     = rt000_aplvar_f200
            rt000_datvon_apl     = rt000_datvon_apl_f200
            rt000_txt_apl        = rt000_txt_f200

            if (rt000_kostst_f200 >  0 \
            ||  rt000_kostst      <= 0 \
            ||  aplnr_neuL        != aplnr_altL) {
                rt000_kostst         = rt000_kostst_f200
                rt000_arbplatz       = rt000_arbplatz_f200
            }

            rt000_ncprognr       = rt000_ncprognr_f200
            rt000_fam            = rt000_fam_f200
            rt000_kn_reihenfolge = rt000_kn_reihenfolge_f200
            rt000_milest_verf    = rt000_milest_verf_f200
        }
        else {
            if (aplnr_neuL != NULL) {
                rt000_aplidentnr_neu = NULL
                rt000_aplvar_neu     = NULL
            }

            rt000_datvon_apl = NULL
        }

        rt000_dataen_apl = NULL
        rt000_aendnr_apl = NULL
    }

    return OK
}

/**
 * Diese Methode legt eine Fertigngsauftrag an, löscht oder ändert diesen
 *
 * @param aufstP                Auftragsbezogene Stammdaten (TRUE) oder nicht (FALSE) -> für Meldungsausgabe am Ende
 * @param [kn_term_verschobP]   Optional übergebenes Kennzeichen KN_TERM_VERSCHOB
 * @param [standortkalenderP]   Übergebener Standortkalender
 * @param [cdtRq000P]           Q-Modul-Instanz des Fertigungsauftrages
 * @return OK                   Fertigungsauftrag wurde angelegt oder geändert
 * @return INFO                 Fertigungsauftrag wurde gelöscht
 * @return FAILURE              Fehler
 **/
int proc rt000_fa(boolean aufstP, string kn_term_verschobP, cdtGq300 standortkalenderP, cdtRq000 cdtRq000P)
{
    boolean                loeschenL        = FALSE
    string                 fkfsL            = fertig_get_fkfs(rt000_fkfs, rt000_fkfs_a)
    verknuepfungFklzRq1004 verknuepfungL


    // Vorausdispositionen (Pseudo und aufpos > 0) müssen ebenfalls gelöscht werden
    // siehe "re000_verarbeiten"
    if (rt000_aes == cAES_DELETE \
    &&  (    fkfsL                       == FSTATUS_ERFASST \
         || (cod_aart_pseudo(rt000_aart) == TRUE && rt000_aufpos > 0)) \
        ) {
        handleRt090Rt000 = bu_load_tmodul("rt090", handleRt090Rt000)
        if (handleRt090Rt000 < OK) {
            return on_error(FAILURE)
        }

        call rt090_entry(handleRt090Rt000)
        send bundle "b_rt090" data \
            rt000_fklz, \
            FU_LOE_FA_LOESCHEN, \
            rt000_werk

        if (rt090_loeschen(handleRt090Rt000) != OK) {
            call rt090_exit(handleRt090Rt000)
            return on_error(FAILURE)
        }
        call rt090_exit(handleRt090Rt000)

        call rt000_set_cm130(cAES_DELETE)

        loeschenL = TRUE
    }
    else if (rt000_aes == cAES_INSERT) {
        if (rt000_insert_r000(kn_term_verschobP, standortkalenderP, cdtRq000P) < OK) {
            return FAILURE
        }

        call rt000_set_cm130(cAES_INSERT)
    }
    else {  // bei aes = 3 und aes = 1 mit fafs > 1
        if (rt000_update_r000(kn_term_verschobP, standortkalenderP, cdtRq000P) < OK) {
            return FAILURE
        }

        // 300238287: Auch beim "Stornieren" mit Menge = 0 müssen Verknüpfungen aufgelöst werden
        if ( \
            rt000_aes       == cAES_DELETE && \
            rt000_menge_neu == 0.0 \
        ) {
            public rq1004.bsl
            verknuepfungL             = new verknuepfungFklzRq1004()
            verknuepfungL=>fi_nr      = FI_NR1
            verknuepfungL=>fklz       = rt000_fklz
            verknuepfungL=>menge_diff = rt000_menge_alt
            if (verknuepfungFklzRq1004Aufheben(verknuepfungL) < OK) {
                // Fehler beim Ändern in Tabelle %s
                return on_error(FAILURE, "APPL0004", "r1004", rt000_prot)
            }
        }
    }


    // Ggf. nur noch eine Meldungen ausgeben
    call rt000_fa_meldung_ende(aufstP, loeschenL, standortkalenderP, cdtRq000P)


    // FA wurde gelöscht
    if (loeschenL == TRUE) {
        return INFO
    }

    return OK
}

/**
 * Ausgabe einer Meldung nach dem Speichern der r000
 *
 * Verwendete rt000-FeldeR:
 * - rt000_aes
 * - rt000_aart
 * - rt000_fklz
 * - rt000_fkfs
 * - rt000_fkfs_a
 * - rt000_tkz
 * - rt000_mkz
 * - rt000_rkz
 *
 * @param aufstP                Kennzeichen auftragsbezogenen Stammdaten (TRUE) oder nicht (FALSE)
 * @param loeschenP             Löschung über rt090 (TRUE) oder nicht (FALSE)
 * @param [standortkalenderP]   Standortkalender
 * @param cdtRq000P             Instanz des Moduls rq000
 * @return OK
 * @see                         rt000_protokoll_aus_rq000
 **/
int proc rt000_fa_meldung_ende(boolean aufstP, boolean loeschenP, cdtGq300 standortkalenderP, cdtRq000 cdtRq000P)
{
    int      rcL
    R000CDBI r000_vorherL


    if (aufstP == TRUE) {
        return OK
    }

    // rq000 nur aufrufen, wenn auch wegen dem AES eine Meldung ausgegeben werden soll (z.B. nicht bei der Neuanlage).
    switch (rt000_aes) {
        case cAES_UPDATE:
        case cAES_DELETE:
        case cAES_REKONFIG:
            public rq000.bsl

            // 300351541:
            // Beim Löschen FA ist u.U. jetzt der r000-Satz schon gelöscht. Darum müssen alle benötigten Daten an die
            // Methode übergeben werden.
            if (loeschenP == TRUE) {
                r000_vorherL = rq000_get_r000(cdtRq000P)

                call rq000_set_fklz(cdtRq000P, rt000_fklz)
                call rq000_set_aart(cdtRq000P, rt000_aart)
                call rq000_set_fkfs(cdtRq000P, rt000_fkfs)
                call rq000_set_fkfs_a(cdtRq000P, rt000_fkfs_a)
            }

            call rq000_set_tkz_uebergeben(cdtRq000P, rt000_tkz)
            call rq000_set_mkz_uebergeben(cdtRq000P, rt000_mkz)
            call rq000_set_rkz_uebergeben(cdtRq000P, rt000_rkz)
            call rq000_set_kn_aend_fa_uebergeben(cdtRq000P, rt000_kn_aend_fa)
            call rq000_set_clear_message(cdtRq000P, TRUE)

            rcL = rq000_erzeugen_meldungen_nach_verwaltung_fa(cdtRq000P, rt000_aes)

            if (loeschenP == TRUE) {
                call rq000_set_r000(cdtRq000P, r000_vorherL, FALSE)
            }

            call rt000_protokoll_aus_rq000(cdtRq000P, rcL)
            if (rcL != OK) {
                return FAILURE
            }
            break
        else:
            break
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_bestellbestand
#
# Korrigieren Bestellbestand
# - bestimmen, um wieviel sich der Bestellbestand ändert
# - update Lagerstamm (g020), wenn Bestellbestand sich ändert
# - abhängig vom Fertigungsstatus wird der simulative oder echte
#   Bestellbestand verändert
#--------------------------------------------------------------------

int proc rt000_bestellbestand()
{
    vars simL
    vars kn_lgdispAltRt000L="1"
    vars kn_lgdispNeuRt000L="1"

    // muß Update überhaupt durchgeführt werden
    if (rt000_identnr_neu ## " " == rt000_identnr_alt ## " " \
     && rt000_var_neu ## " "     == rt000_var_alt ## " " \
     && rt000_menge_offen_neu    == rt000_menge_offen_alt \
     && (rt000_aes               != cAES_DELETE \
     ||  (rt000_aes              == cAES_DELETE \
       && rt000_menge_offen_neu  == 0)) \
     && rt000_lgnr_neu           == rt000_lgnr_alt \
     && rt000_da                 == rt000_da_alt) {
        return OK
    }

    // Da die folgende Prüfung zum Löschen des FAs in der Funktion rt000_fa() führt,
    // darf der Bestellbestand hier noch nicht korrigiert werden!
    if (rt000_aes == cAES_DELETE \
    && ((rt000_fkfs == FSTATUS_ERFASST || rt000_fkfs_a == FSTATUS_ERFASST) \
    || (cod_aart_pseudo(rt000_aart) == TRUE && rt000_aufpos > 0))) {
        return OK
    }

    // Bei AART = "7" kann das LgNrAlt/Neu nicht dispositiv sein, d.h. der
    // Bestellbestand des nicht disp. Lagers muss dann nicht aktualisiert
    // werden
    if (cod_aart_reparatur(rt000_aart) == TRUE) {
        if (dm_is_cursor("rt000CurLgDisp") != TRUE) {
            dbms declare rt000CurLgDisp cursor for \
                  select g020.kn_lgdisp \
                    from g020 \
                   where g020.fi_nr   = ::FI_NR1 \
                     and g020.werk    = ::werk \
                     and g020.identnr = ::identnr \
                     and g020.var     = ::var \
                     and g020.lgnr    = ::lgnr
        }
        dbms with cursor rt000CurLgDisp alias kn_lgdispAltRt000L

        dbms with cursor rt000CurLgDisp execute using FI_NR1, \
                                                      rt000_werk, \
                                                      rt000_identnr_alt, \
                                                      rt000_var_alt, \
                                                      rt000_lgnr_alt

        if (kn_lgdisp_neuRt000 == "0" && \
            kn_lgdispAltRt000L  == "0" && \
            rt000_da_alt        == rt000_da) {
            // Keine Änderung des Bestellbestands erforderlich, da
            // LagerAlt und LagerNeu nicht dispositiv
            return OK
        }
    }

    if (rt000_load_lt110() != OK) {
        return FAILURE
    }

    // bei simulativem Auftrag simulativen Bestellbestand verändern
    if (rt000_fkfs == FSTATUS_SIM) {
        simL = TRUE
    }
    else {
        simL = FALSE
    }

    // Update:
    // nur wenn sich die Teilenummer ändert (Teiletausch oder Änderung
    // identnr), muß folgende Funktion folgende Abhandlung durchgeführt
    // werden
    // - zur Korrektur des Bestellbestandes der alten Teilenummer
    // - für die neue Teilenummer werden die Felder menge_offen_alt/neu
    //   wie bei der Neuanlage gesetzt

    if ((rt000_aes == cAES_UPDATE || rt000_aes == cAES_REKONFIG|| rt000_aes == "9") && \
        (rt000_identnr_neu ## " " != rt000_identnr_alt ## " " || \
         rt000_var_neu     ## " " != rt000_var_alt ## " "     || \
         rt000_lgnr_neu           != rt000_lgnr_alt)) {
        if (kn_lgdispAltRt000L != "0" \
        &&  rt000_da_alt       != DA_NICHT \
        &&  rt000_identnr_alt  != "") { // 300354288
            rt000_bestell_diff = - rt000_menge_offen_alt

            rt000_alt_neu = "alt"

            call rt000_bundle_lt110()
            if (lt110_rvb_fortschreiben(rt000_lt110_handle, simL) < OK) {
                return FAILURE
            }
        }

        rt000_menge_offen_neu = rt000_menge_neu
        rt000_menge_offen_alt = 0
    }

    // um wieviel ändert sich der Bestellbestand
    if (kn_lgdispNeuRt000L != "0" \
    &&  rt000_da           != DA_NICHT \
    &&  rt000_identnr_neu  != "") { // 300354288
        rt000_bestell_diff = rt000_menge_offen_neu - rt000_menge_offen_alt

        rt000_alt_neu = "neu"

        call rt000_bundle_lt110()
        if (lt110_rvb_fortschreiben(rt000_lt110_handle, simL) < OK) {
            return FAILURE
        }
    }
    return OK
}


#--------------------------------------------------------------------
# rt000_instandhaltung
#
# Instandhaltungsdaten korrigieren, wenn Auftrag storniert wird
#--------------------------------------------------------------------

int proc rt000_instandhaltung()
{
    int rcL

    // nur, wenn Instandhaltungsauftrag storniert wird
    if (rt000_aart != "8" || rt000_aes != cAES_DELETE) {
        return OK
    }

    // Aufruf Modul "it000" Funktion "storno"
    if (rt000_load_it000() != OK) {
        return FAILURE
    }

    send bundle "b_it000_storno" data rt000_aufnr, rt000_aufpos, rt000_fklz

    warn_2_failRt000 = warn_2_fail
    warn_2_fail = FALSE

    rcL = it000_storno(rt000_it000_handle)
    if (rcL < OK) {
        warn_2_fail = warn_2_failRt000
        return FAILURE
    }

    warn_2_fail = warn_2_failRt000

    return OK
}

#--------------------------------------------------------------------
# rt000_insert_r000
#
# Satz in Tabelle "r000" einfügen
#--------------------------------------------------------------------

int proc rt000_insert_r000(string kn_term_verschobP, cdtGq300 standortkalenderP, cdtRq000 cdtRq000P)
{
    int      rcL
    R000CDBI r000L
    string   msg_nrL
    string   msg_zusatzL

    call bu_dyn_fct("insert_r000", "START")

    if (rt000_kanbananfnr == NULL) {
        rt000_kanbananfnr = 0
    }

    if (rt000_lfzeit == NULL) {
        rt000_lfzeit = 0
    }

    if (rt000_kz_ueb == NULL \
    ||  R_KZ_BELAST  == 0) {
        rt000_kz_ueb = "0"
    }

    // Initialisierung der Felder für die uhrzeitengenaue Terminierung mit sinnvollen Werten
    rcL = rt000_init_terminierung_uhrzeitengenau(cAES_INSERT, standortkalenderP, cdtRq000P)
    if (rcL != OK) {
        return rcL
    }

    r000L = rq000_get_r000(cdtRq000P)
    call md_clear_modified(r000L)

    // 300349432: Aus Laufzeitgründen keine Setter hier verwenden
    r000L=>fi_nr            = FI_NR1
    r000L=>werk             = rt000_werk
    r000L=>fklz             = rt000_fklz
    r000L=>fklz_prim        = rt000_fklz_prim
    r000L=>fklz_var         = rt000_fklz_var
    r000L=>aufnr            = rt000_aufnr
    r000L=>aufpos           = rt000_aufpos
    r000L=>identnr          = rt000_identnr_neu
    r000L=>var              = rt000_var_neu
    r000L=>aart             = rt000_aart
    r000L=>fkfs             = rt000_fkfs
    r000L=>fkfs_a           = rt000_fkfs_a
    r000L=>menge            = rt000_menge_neu
    r000L=>menge_abg        = 0
    r000L=>menge_aus        = rt000_menge_aus_neu
    r000L=>menge_gef        = 0
    r000L=>menge_offen      = rt000_menge_offen_neu
    r000L=>fsterm           = rt000_fsterm_neu
    r000L=>fortsetz_dat     = rt000_fortsetz_dat_neu
    r000L=>seterm           = rt000_seterm_neu
    r000L=>kz_fix           = rt000_kz_fix_neu
    r000L=>fsterm_w         = rt000_fsterm_w_neu
    r000L=>seterm_w         = rt000_seterm_w_neu
    r000L=>dlzeit           = rt000_dlzeit
    r000L=>red_faktor       = rt000_red_faktor_neu
    r000L=>vzag             = 0
    r000L=>vzzeit           = rt000_vzzeit
    r000L=>kalk             = rt000_kalk
    r000L=>loesch           = rt000_loesch
    r000L=>zusammen         = rt000_zusammen
    r000L=>freigabe         = rt000_freigabe
    r000L=>kz_spl           = rt000_kz_spl
    r000L=>kz_ueb           = rt000_kz_ueb
    r000L=>matbuch          = rt000_matbuch
    r000L=>termstr          = rt000_termstr_neu
    r000L=>termart          = rt000_termart_neu
    r000L=>aenddr           = rt000_aenddr
    r000L=>drucknr          = 0
    r000L=>disstufe         = rt000_disstufe
    r000L=>da               = rt000_da
    r000L=>ch               = rt000_ch
    r000L=>bs               = rt000_bs
    r000L=>altern           = rt000_altern_neu
    r000L=>kostst           = rt000_kostst
    r000L=>arbplatz         = rt000_arbplatz
    r000L=>ncprognr         = rt000_ncprognr
    r000L=>fam              = rt000_fam
    r000L=>kn_reihenfolge   = rt000_kn_reihenfolge
    r000L=>lgnr             = rt000_lgnr_neu
    r000L=>lgber            = rt000_lgber
    r000L=>lgfach           = rt000_lgfach
    r000L=>schad_code       = rt000_schad_code
    r000L=>charge           = rt000_charge
    r000L=>chargen_pflicht  = rt000_chargen_pflicht
    r000L=>stlidentnr       = rt000_stlidentnr_neu
    r000L=>stlvar           = rt000_stlvar_neu
    r000L=>stlnr            = rt000_stlnr_neu
    r000L=>staltern         = rt000_staltern_neu
    r000L=>datvon_stl       = rt000_datvon_stl
    r000L=>dataen_stl       = rt000_dataen_stl
    r000L=>aendnr_stl       = rt000_aendnr_stl
    r000L=>txt_stl          = rt000_txt_stl
    r000L=>aplidentnr       = rt000_aplidentnr_neu
    r000L=>aplvar           = rt000_aplvar_neu
    r000L=>aplnr            = rt000_aplnr_neu
    r000L=>agaltern         = rt000_agaltern_neu
    r000L=>datvon_apl       = rt000_datvon_apl
    r000L=>dataen_apl       = rt000_dataen_apl
    r000L=>aendnr_apl       = rt000_aendnr_apl
    r000L=>txt_apl          = rt000_txt_apl
    r000L=>aendnr           = 0
    r000L=>kkomm_nr         = rt000_kkomm_nr
    r000L=>kn_lgres         = rt000_kn_lgres_neu
    r000L=>kanbannr         = rt000_kanbannr
    r000L=>kanbananfnr      = rt000_kanbananfnr
    r000L=>servicenr        = rt000_servicenr
    r000L=>kosttraeger      = rt000_kosttraeger
    r000L=>projekt_id       = rt000_projekt_id_neu
    r000L=>milest_verf      = rt000_milest_verf
    r000L=>vv_nr            = rt000_vv_nr_neu
    r000L=>kneintl          = rt000_kneintl_neu
    r000L=>aendind          = rt000_aendind
    r000L=>kdidentnr        = rt000_kdidentnr
    r000L=>kn_kapaz         = rt000_kn_kapaz_neu
    r000L=>kn_unterbr       = rt000_kn_unterbr_neu
    r000L=>kn_prodplan      = rt000_kn_prodplan
    r000L=>kn_kritisch      = 0
    r000L=>uebzeit          = 0
    r000L=>objektid         = NULL
    r000L=>kn_tplager       = rt000_kn_tplager
    r000L=>lfzeit           = rt000_lfzeit
    r000L=>fa_verschoben    = "0"
    r000L=>bestnr           = NULL
    r000L=>bestpos          = 0
    r000L=>uebzt_sek        = rt000_uebzt_sek_neu
    r000L=>fortsetz_uhr     = rt000_fortsetz_uhr_neu
    r000L=>fsterm_uhr       = rt000_fsterm_uhr_neu
    r000L=>seterm_uhr       = rt000_seterm_uhr_neu
    r000L=>fsterm_w_uhr     = rt000_fsterm_w_uhr_neu
    r000L=>seterm_w_uhr     = rt000_seterm_w_uhr_neu
    r000L=>kn_terminiert    = rt000_kn_terminiert_neu
    r000L=>vzdatum          = bu_get_datetime()

    // Abholen der Instanz der Globalen Daten


    // Das Kennzeichen kn_term_verschob bei Terminverschiebung korrekt setzen
    call rq000_set_kn_term_verschob_fa(cdtRq000P, INFO)
    call rq000_set_kn_term_verschob(cdtRq000P, KN_TERM_VERSCHOB_NEIN)

    call rq000_set_logging(cdtRq000P, $NULL)
    call rq000_set_aes(cdtRq000P, cAES_INSERT)  // 300349432: Damit der aes nicht im Modul erneut per SQL ermittelt werden muss

    rcL = rq000_insert_cdbi(cdtRq000P, r000L)
    if (rcL != OK) {
        msg_nrL     = "APPL0003"    // Fehler beim Einfügen in Tabelle %s.
        msg_zusatzL = "r000"
    }
    if (rt000_verw_art == "5") {
        // Bei Aufruf aus rv0000 Meldungen aus rq000 auf dem Bildschirm ausgeben, andernfalls ins Protokoll schreiben
        call rq000_ausgeben_meldungen(cdtRq000P, BU_0, TRUE)
    }
    else {
        // Fehler beim Einfügen in Tabelle >%s<.
        call rq000_set_clear_message(cdtRq000P, TRUE)
        call rq000_speichern_protokoll_funktion(cdtRq000P, rt000_prot, msg_nrL, msg_zusatzL, "")
    }
    if (rcL != OK) {
        return on_error(FAILURE)
    }

    // Die neue fklz muss aus rq000 abgeholt werden.
    if (rt000_fklz == NULL) {
        rt000_fklz = rq000_get_fklz(cdtRq000P)
    }

    return OK
}

# Satz in Tabelle "r000" ändern
#--------------------------------------------------------------------
int proc rt000_update_r000(string kn_term_verschobP, cdtGq300 standortkalenderP, cdtRq000 cdtRq000P)
{
    int      rcL
    int      kn_term_verschob_faL = FALSE
    R000CDBI r000L
    R000CDBI r000_altL
    string   msg_nrL
    string   msg_zusatzL


    if (rt000_lfzeit == "") {
        rt000_lfzeit = 0
    }

    if (rt000_kz_ueb == "" \
    ||  R_KZ_BELAST  == 0) {
        rt000_kz_ueb = "0"
    }

    // Initialisierung der Felder für die uhrzeitengenaue Terminierung mit sinnvollen Werten
    rcL = rt000_init_terminierung_uhrzeitengenau(cAES_UPDATE, standortkalenderP, cdtRq000P)
    if (rcL != OK) {
        return rcL
    }

    r000L = rq000_get_r000(cdtRq000P)
    call md_clear_modified(r000L)


    // 300386224:
    // Die alten Daten der r000 wurden vorher beim "rq000_new" gelesen und noch nicht verändert. Darum können sie hier
    // (vor dem Setzen der geänderten Daten) 1:1 in die alt-Daten übernommen werden.
    r000_altL = bu_cdbi_new("r000")
    if (bu_cdt_clone(r000L, r000_altL, TRUE, FALSE, "") == OK) {
        call md_clear_modified(r000_altL)
        call rq000_set_r000_alt(cdtRq000P, r000_altL)
    }


    // 300349432: Aus Laufzeitgründen keine Setter hier verwenden
    r000L=>fi_nr            = FI_NR1
    r000L=>fklz             = rt000_fklz
    r000L=>identnr          = rt000_identnr_neu
    r000L=>var              = rt000_var_neu
    r000L=>fklz_var         = rt000_fklz_var
    r000L=>menge            = rt000_menge_neu
    r000L=>menge_aus        = rt000_menge_aus_neu
    r000L=>menge_offen      = rt000_menge_offen_neu
    r000L=>fsterm           = rt000_fsterm_neu
    r000L=>fortsetz_dat     = rt000_fortsetz_dat_neu
    r000L=>seterm           = rt000_seterm_neu
    r000L=>kz_fix           = rt000_kz_fix_neu
    r000L=>fsterm_w         = rt000_fsterm_w_neu
    r000L=>seterm_w         = rt000_seterm_w_neu
    r000L=>dlzeit           = rt000_dlzeit
    r000L=>red_faktor       = rt000_red_faktor_neu
    r000L=>vzzeit           = rt000_vzzeit
    r000L=>kalk             = rt000_kalk
    r000L=>loesch           = rt000_loesch
    r000L=>zusammen         = rt000_zusammen
    r000L=>freigabe         = rt000_freigabe
    r000L=>kz_spl           = rt000_kz_spl
    r000L=>kz_ueb           = rt000_kz_ueb
    r000L=>matbuch          = rt000_matbuch
    r000L=>termstr          = rt000_termstr_neu
    r000L=>termart          = rt000_termart_neu
    r000L=>altern           = rt000_altern_neu
    r000L=>kostst           = rt000_kostst
    r000L=>arbplatz         = rt000_arbplatz
    r000L=>ncprognr         = rt000_ncprognr
    r000L=>fam              = rt000_fam
    r000L=>kn_reihenfolge   = rt000_kn_reihenfolge
    r000L=>milest_verf      = rt000_milest_verf
    r000L=>lgnr             = rt000_lgnr_neu
    r000L=>lgber            = rt000_lgber
    r000L=>lgfach           = rt000_lgfach
    r000L=>schad_code       = rt000_schad_code
    r000L=>charge           = rt000_charge
    r000L=>chargen_pflicht  = rt000_chargen_pflicht
    r000L=>stlidentnr       = rt000_stlidentnr_neu
    r000L=>stlvar           = rt000_stlvar_neu
    r000L=>stlnr            = rt000_stlnr_neu
    r000L=>staltern         = rt000_staltern_neu
    r000L=>datvon_stl       = rt000_datvon_stl
    r000L=>dataen_stl       = rt000_dataen_stl
    r000L=>aendnr_stl       = rt000_aendnr_stl
    r000L=>txt_stl          = rt000_txt_stl
    r000L=>aplidentnr       = rt000_aplidentnr_neu
    r000L=>aplvar           = rt000_aplvar_neu
    r000L=>aplnr            = rt000_aplnr_neu
    r000L=>agaltern         = rt000_agaltern_neu
    r000L=>datvon_apl       = rt000_datvon_apl
    r000L=>dataen_apl       = rt000_dataen_apl
    r000L=>aendnr_apl       = rt000_aendnr_apl
    r000L=>txt_apl          = rt000_txt_apl
    r000L=>kn_lgres         = rt000_kn_lgres_neu
    r000L=>aendind          = rt000_aendind
    r000L=>kkomm_nr         = rt000_kkomm_nr
    r000L=>servicenr        = rt000_servicenr
    r000L=>vv_nr            = rt000_vv_nr_neu
    r000L=>kneintl          = rt000_kneintl_neu
    r000L=>kn_kapaz         = rt000_kn_kapaz_neu
    r000L=>kn_unterbr       = rt000_kn_unterbr_neu
    r000L=>kn_tplager       = rt000_kn_tplager
    r000L=>lfzeit           = rt000_lfzeit
    r000L=>fa_verschoben    = rt000_fa_verschoben
    r000L=>kdidentnr        = rt000_kdidentnr
    r000L=>uebzt_sek        = rt000_uebzt_sek_neu
    r000L=>fortsetz_uhr     = rt000_fortsetz_uhr_neu
    r000L=>fsterm_uhr       = rt000_fsterm_uhr_neu
    r000L=>seterm_uhr       = rt000_seterm_uhr_neu
    r000L=>fsterm_w_uhr     = rt000_fsterm_w_uhr_neu
    r000L=>seterm_w_uhr     = rt000_seterm_w_uhr_neu
    r000L=>vzdatum          = bu_get_datetime()
    r000L=>aenddr           = rt000_aenddr
    r000L=>da               = rt000_da


    // 300386224:
    // Nur bei Änderung der Projek-ID auch diese übergeben
    if (rt000_kn_aend_fa == KN_AEND_FA_PROJEKTID) {
        r000L=>projekt_id = rt000_projekt_id_neu
    }
    else {
        r000L=>projekt_id = rt000_projekt_id_alt
        call md_clear_modified(r000L, "projekt_id")
    }


    // Das Kennzeichen kn_term_verschob bei Terminverschiebung korrekt setzen
    if (rt000_tkz == cTKZ_STRUKTUR) {
        // Bei einer Strukturterminierung wird das Kennzeichen Verschoben immer
        // auf "nicht verschoben" gesetzt
        kn_term_verschob_faL    = INFO
        r000L=>kn_term_verschob = KN_TERM_VERSCHOB_NEIN
    }
    else {
        // Bei einer Baukastenterminierung wird das Kennzeichen Verschoben entweder übergeben oder
        // abhängig von der Termart gesetzt.
        // Wenn nicht explizit übergeben, wird versucht, den geänderten Termin zu ermitteln oder ob keine Terminänderung
        // vorliegt

        if (kn_term_verschobP == NULL) {
            if (rt000_fsterm_uhr_neu != rt000_fsterm_uhr_alt \
            &&  rt000_seterm_uhr_neu == rt000_seterm_uhr_alt \
            &&  rt000_seterm_neu     == rt000_seterm_alt) {
                // nur Starttermin hat sich geändert
                kn_term_verschobP = KN_TERM_VERSCHOB_START
            }
            else if (rt000_fsterm_uhr_neu  == rt000_fsterm_uhr_alt \
                 &&  (rt000_seterm_uhr_neu != rt000_seterm_uhr_alt || rt000_seterm_neu != rt000_seterm_alt)) {
                // nur Endtermin hat sich geändert
                kn_term_verschobP = KN_TERM_VERSCHOB_ENDE
            }
            else if (rt000_fsterm_uhr_neu == rt000_fsterm_uhr_alt \
                 &&  rt000_seterm_uhr_neu == rt000_seterm_uhr_alt \
                 &&  rt000_seterm_neu     == rt000_seterm_alt) {
                    // kein Termin hat sich geändert
                    kn_term_verschobP = KN_TERM_VERSCHOB_NEIN
            }
            else {
                // beides geändert
            }
        }

        switch (kn_term_verschobP) {
            case KN_TERM_VERSCHOB_START:
            case KN_TERM_VERSCHOB_ENDE:
                // Wenn vom rufenden Programm explizit eine Verschiebung übergeben wurde (z.B. aus dem rv0000 oder re000),
                // wird diese 1:1 in der r000 gespeichert.
                kn_term_verschob_faL    = INFO
                r000L=>kn_term_verschob = kn_term_verschobP
                break
            case KN_TERM_VERSCHOB_NEIN:
                kn_term_verschob_faL    = INFO
                r000L=>kn_term_verschob = KN_TERM_VERSCHOB_NEIN
                break
            else:       // z.B. NULL (wenn beide Termine geänedert wurden)
                kn_term_verschob_faL    = TRUE
                break
        }
    }
    call rq000_set_kn_term_verschob_fa(cdtRq000P, kn_term_verschob_faL)


    if (cod_aart_versorg(rt000_aart) == TRUE \
    ||  rt000_aes                    == cAES_DELETE) {
        // Bei Versorgungsaufträgen muss das Kennzeichen immer gesetzt werden (auf "1" -> vgl. rt000_init_terminierung_uhrzeitengenau)
        // Beim Stornieren eines FA sollte das Kennzeichen terminiert zurück gesetzt werden
         r000L=>kn_terminiert = rt000_kn_terminiert_neu
    }
    else if (cod_kn_term_verschob_nein(r000L=>kn_term_verschob) == TRUE) {
        // Wenn keine tatsächliche Termin-Verschiebung vorliegt, soll das kn_terminiert nicht geändert werden
        call md_clear_modified(r000L, "kn_terminiert")
    }
    else {
         r000L=>kn_terminiert = rt000_kn_terminiert_neu
    }


    // 300397191 - Ressouercenkonflikte aufheben Teil 2:
    // Setzen des kn_kritisch in r000 hier, wenn es sich geändert hat. So werden unnötige Updagtes inkl. Protokolierung
    // in r0006 unterbunden.
    if (rt000_auftrag_zuruecksetzen_kn_kritisch(r000L, r000_altL) != OK) {
        return FAILURE
    }


    r000L=>aart     = rt000_aart
    r000L=>kn_kapaz = rt000_kn_kapaz_neu
    r000L=>fkfs     = rt000_fkfs
    r000L=>fkfs_a   = rt000_fkfs_a

    call rq000_set_logging(cdtRq000P, $NULL)
    call rq000_set_aes(cdtRq000P, cAES_UPDATE)  // 300349432: Damit der aes nicht im Modul erneut per SQL ermittelt werden muss

    rcL = rq000_update_cdbi(cdtRq000P, r000L)
    if (rcL != OK) {
        msg_nrL     = "APPL0004"    // Fehler beim Ändern in Tabelle %s.
        msg_zusatzL = "r000"
    }
    if (rt000_verw_art == "5") {
        // Bei Aufruf aus rv0000 Meldungen aus rq000 auf dem Bildschirm ausgeben, andernfalls ins Protokoll schreiben
        call rq000_ausgeben_meldungen(cdtRq000P, BU_0, TRUE)
    }
    else {
        // Fehler beim Einfügen in Tabelle >%s<.
        call rq000_set_clear_message(cdtRq000P, TRUE)
        call rq000_speichern_protokoll_funktion(cdtRq000P, rt000_prot, msg_nrL, msg_zusatzL, "")
    }
    if (rcL != OK) {
        return on_error(FAILURE)
    }


    if (rt000_menge_alt      >  rt000_menge_neu && \
        (rt000_verw_art      != "3" || \
         rt000_fa_verschoben == "1") ) {

        public rq1004.bsl

        vars verknuepfungL = new verknuepfungFklzRq1004()

        verknuepfungL=>fi_nr        = FI_NR1
        verknuepfungL=>fklz         = rt000_fklz
        verknuepfungL=>menge_diff   = rt000_menge_alt - rt000_menge_neu

        if (verknuepfungFklzRq1004Aufheben(verknuepfungL) < OK) {
            // Fehler beim Einfügen in Tabelle >%s<.
            return on_error(FAILURE, "APPL0003", "r1004", rt000_prot)
        }
    }

    if ( \
        rt000_menge_offen_neu == 0.0   && \
        cod_aart_planauftrag(rt000_aart) == TRUE \
    ) {
        dbms sql \
            update \
                d020 \
            set \
                d020.fklz  = :+NULL \
            where \
                d020.fi_nr = :+FI_NR1     and \
                d020.fklz  = :+rt000_fklz

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "d020", rt000_prot)
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Prüfen, ob ein Aktionssatz für Bedarfsrechnung vorhanden ist und nur teilweise verarbeitet wurde
#-----------------------------------------------------------------------------------------------------------------------
int proc rt000_sel_r115()
{
    string dummyL


    if (!dm_is_cursor("sel_r115_rt000C")) {
        dbms declare sel_r115_rt000C cursor for \
            select \
                r115.uuid \
            from \
                r115 \
            where \
                r115.fklz    =  ::_1 and \
                r115.fi_nr   =  ::_2 and \
                r115.werk    =  ::_3 and \
                r115.lgnr    =  0 and \
                r115.identnr =  :+NULL and \
                r115.var     =  :+NULL and \
                r115.vstat   >= '1' and \
                not ( \
                    ( \
                        r115.logname = :+LOGNAME or \
                        r115.logname like ::_4 \
                    ) and \
                    ( \
                        r115.jobid = 0 or \
                        r115.jobid = ::_5 \
                    ) \
                )
        dbms with cursor sel_r115_rt000C alias dummyL
    }
    dbms with cursor sel_r115_rt000C execute using \
        rt000_fklz, \
        FI_NR1, \
        werk, \
        rt000_filter_logname, \
        JOBID

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLNOTFOUND:
            return WARNING
        else:
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r115", rt000_prot)
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_sel_sum_uebg
#
# Summen der übergeordneten Bedarfssätze zu einem FA ermitteln.
#--------------------------------------------------------------------

int proc rt000_sel_sum_bed()
{
    if !(dm_is_cursor("rt000_read_r100")) {
        dbms declare rt000_read_r100 cursor for \
             select sum(r100.menge - r100.menge_abg - r100.menge_agl) \
           from r100 \
              where r100.fi_nr       = ::FI_NR1 \
                and r100.ufklz       = ::rt000_fklz \
                and r100.identnr     = ::rt000_identnr \
                and r100.var         = ::rt000_var

        dbms with cursor rt000_read_r100 alias rt000_sum_bed_uebg
    }

    dbms with cursor rt000_read_r100 execute using FI_NR1, \
                                                   rt000_fklz, \
                                                   rt000_identnr_neu, \
                                                   rt000_var_neu

    if (SQL_CODE != SQL_OK) {
         // Fehler beim Lesen in Tabelle %s.
         return on_error(FAILURE, "APPL0006", "r100", rt000_prot)
    }

    if (rt000_sum_bed_uebg == NULL) {
        rt000_sum_bed_uebg = 0.0
    }

    return OK
}


#--------------------------------------------------------------------
# rt000_sel_f100
#
# Lesen Stücklistenkopfdaten
#--------------------------------------------------------------------

int proc rt000_sel_f100()
{
    // Stücklistengültigkeit wurde bereits über das rv000 geprüft

    if !(dm_is_cursor("rt000_read_f100")) {
        dbms declare rt000_read_f100 cursor for \
             select  f100.stlidentnr, \
                     f100.stlvar, \
                     f100.datvon, \
                     f100.txt \
               from  f100 \
              where  f100.fi_nr      = ::FI_F100 \
                and  f100.stlnr      = ::stlnr

        dbms with cursor rt000_read_f100 alias \
                     rt000_stlidentnr_f100, \
                     rt000_stlvar_f100, \
                     rt000_datvon_stl_f100, \
                     rt000_txt_f100
    }

    dbms with cursor rt000_read_f100 execute using FI_F100, rt000_stlnr_neu

    if (SQL_CODE == SQLNOTFOUND) {
        // Stücklistenkopf >%1< nicht vorhanden.
        return on_error(WARNING, "f1000000", rt000_stlnr_neu, rt000_prot)
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "f100", rt000_prot)
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_sel_f200
#
# Lesen Arbeitsplankopfdaten
#--------------------------------------------------------------------
int proc rt000_sel_f200()
{
    if !(dm_is_cursor("rt000_read_f200")) {
        dbms declare rt000_read_f200 cursor for \
             select  f200.aplidentnr, \
                     f200.aplvar, \
                     f200.datvon, \
                     f200.kostst, \
                     f200.arbplatz, \
                     f200.ncprognr, \
                     f200.fam, \
                     f200.kn_reihenfolge, \
                     f200.milest_verf, \
                     f200.txt \
               from  f200 \
              where  f200.fi_nr  = ::FI_F200 \
                and  f200.aplnr  = ::aplnr

        dbms with cursor rt000_read_f200 alias \
                     rt000_aplidentnr_f200, \
                     rt000_aplvar_f200, \
                     rt000_datvon_apl_f200, \
                     rt000_kostst_f200, \
                     rt000_arbplatz_f200, \
                     rt000_ncprognr_f200, \
                     rt000_fam_f200, \
                     rt000_kn_reihenfolge_f200, \
                     rt000_milest_verf_f200, \
                     rt000_txt_f200
    }
    dbms with cursor rt000_read_f200 execute using FI_F200, rt000_aplnr_neu

    if (SQL_CODE == SQLNOTFOUND) {
         // Arbeitsplankopf >%1< nicht vorhanden.
         return on_error(WARNING, "f2000000", rt000_aplnr_neu, rt000_prot)
    }

    if (SQL_CODE != SQL_OK) {
         // Fehler beim Lesen in Tabelle %s.
         return on_error(FAILURE, "APPL0006", "f200", rt000_prot)
    }

    return OK
}


#--------------------------------------------------------------------
# rt000_proto
#
# Satz für Fertigungsauftrag in die Protokolltabelle r016 abstellen
# - abhängig von "rt000_alt_neu" werden die alten oder die neuen
#   Daten protokolliert
#--------------------------------------------------------------------
int proc rt000_proto(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    int    jobidL
    string fu_bedrL
    string kn_aend_faL


    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r016")


    if (rt000_werk <= 0) {
        rt000_werk = werk
    }


    // 300170171: keine null in der jobid
    jobidL = JOBID + 0


    // Sicherstellen, dass Einträge aus der Nettobedarfsrechnung entsprechend markiert sind
    if (rt000_verw_art == "3") {
        fu_bedrL = cFUBEDR_NETTO
    }
    else if (rt000_fu_bedr != "") {
        fu_bedrL = rt000_fu_bedr
    }
    else {
        dbms alias fu_bedrL
        dbms sql select r115.fu_bedr \
                 from r115 \
                 where r115.fi_nr   = :+FI_NR1 \
                 and   r115.werk    = :+rt000_werk \
                 and   r115.fklz    = :+rt000_fklz \
                 and   r115.identnr = :+NULL \
                 and   r115.var     = :+NULL \
                 and   r115.lgnr    = 0
        dbms alias
    }


    // Kennzeichen im Protokoll-Satz mit sinnvollem Wert füllen, wenn noch nicht gefüllt
    switch (fu_bedrL) {
        case cFUBEDR_NETTO:
            kn_aend_faL = KN_AEND_FA_OHNE
            break
        case cFUBEDR_MTAEND:
            if (rt000_kn_aend_fa != KN_AEND_FA_OHNE) {
                kn_aend_faL = rt000_kn_aend_fa
            }
            else {
                kn_aend_faL = KN_AEND_FA_KEINE
            }
            break
        else:
            kn_aend_faL = KN_AEND_FA_KEINE
            break
    }


    dbms sql insert into r016 ( \
             datuhr, \
             fi_nr, \
             werk, \
             lgnr, \
             logname, \
             tty, \
             maske, \
             msg_nr, \
             msg_typ, \
             msg_text, \
             prt_ctrl, \
             jobid, \
             fu_bedr, \
             fklz, \
             aufnr, \
             aufpos, \
             identnr, \
             var, \
             aart, \
             fkfs, \
             fsterm, \
             fsterm_uhr, \
             fortsetz_dat, \        // 300185637
             fortsetz_uhr, \
             seterm, \
             seterm_uhr, \
             fsterm_w, \
             fsterm_w_uhr, \
             seterm_w, \
             seterm_w_uhr, \
             menge, \
             termstr, \
             termart, \
             aes, \
             tkz, \
             mkz, \
             kn_aend_fa \
          ) values ( \
             :CURRENT, \
             :+FI_NR1, \
             :+rt000_werk, \
             :+rt000_lgnr_:(rt000_alt_neu), \
             :+LOGNAME, \
             :+TTY, \
             :+screen_name, \
             :+msg_nr, \
             :+msg_typ, \
             :+msg_text, \
             :+prt_ctrl, \
             :+jobidL, \        // 300170171
             :+fu_bedrL, \
             :+rt000_fklz, \
             :+rt000_aufnr, \
             :+rt000_aufpos, \
             :+rt000_identnr_:(rt000_alt_neu), \
             :+rt000_var_:(rt000_alt_neu), \
             :+rt000_aart, \
             :+rt000_fkfs, \
             :+rt000_fsterm_:(rt000_alt_neu), \
             :+rt000_fsterm_uhr_:(rt000_alt_neu), \
             :+rt000_fortsetz_dat_:(rt000_alt_neu), \        // 300185637
             :+rt000_fortsetz_uhr_:(rt000_alt_neu), \        // 300185637
             :+rt000_seterm_:(rt000_alt_neu), \
             :+rt000_seterm_uhr_:(rt000_alt_neu), \
             :+rt000_fsterm_w_:(rt000_alt_neu), \
             :+rt000_fsterm_w_uhr_:(rt000_alt_neu), \
             :+rt000_seterm_w_:(rt000_alt_neu), \
             :+rt000_seterm_w_uhr_:(rt000_alt_neu), \
             :+rt000_menge_:(rt000_alt_neu), \
             :+rt000_termstr_:(rt000_alt_neu), \
             :+rt000_termart_:(rt000_alt_neu), \
             :+rt000_aes, \
             :+rt000_tkz, \
             :+rt000_mkz, \
             :+kn_aend_faL \
          )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r016")
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_receive_rt000
#
# Bundle für "rt000" empfangen
# - abhängig von "rt000_alt_neu" werden die Werte-neu oder die Werte-alt
#   geladen
#--------------------------------------------------------------------

int proc rt000_receive_rt000()
{
    receive bundle "b_rt000" data \
        rt000_fklz, \
        rt000_aes, \
        rt000_aufnr, \
        rt000_aufpos, \
        rt000_identnr_:(rt000_alt_neu), \
        rt000_var_:(rt000_alt_neu), \
        rt000_werk, \
        rt000_aart, \
        rt000_fkfs, \
        rt000_fkfs_a, \
        rt000_menge_:(rt000_alt_neu), \
        rt000_menge_abg, \
        rt000_menge_aus_:(rt000_alt_neu), \
        rt000_menge_gef, \
        rt000_menge_offen_:(rt000_alt_neu), \
        rt000_me, \
        rt000_fsterm_:(rt000_alt_neu), \
        rt000_seterm_:(rt000_alt_neu), \
        rt000_kz_fix_:(rt000_alt_neu), \
        rt000_fsterm_w_:(rt000_alt_neu), \
        rt000_seterm_w_:(rt000_alt_neu), \
        rt000_dlzeit, \
        rt000_red_faktor_:(rt000_alt_neu), \
        rt000_vzag, \
        rt000_kalk, \
        rt000_loesch, \
        rt000_zusammen, \
        rt000_freigabe, \
        rt000_kz_spl, \
        rt000_kz_ueb, \
        rt000_matbuch, \
        rt000_termstr_:(rt000_alt_neu), \
        rt000_termart_:(rt000_alt_neu), \
        rt000_disstufe, \
        rt000_da, \
        rt000_ch, \
        rt000_bs, \
        rt000_altern_:(rt000_alt_neu), \
        rt000_kostst, \
        rt000_arbplatz, \
        rt000_ncprognr, \
        rt000_fam, \
        rt000_kn_reihenfolge, \
        rt000_lgnr_:(rt000_alt_neu), \
        rt000_lgber, \
        rt000_lgfach, \
        rt000_schad_code, \
        rt000_charge, \
        rt000_chargen_pflicht, \
        rt000_stlidentnr_:(rt000_alt_neu), \
        rt000_stlvar_:(rt000_alt_neu), \
        rt000_stlnr_:(rt000_alt_neu), \
        rt000_staltern_:(rt000_alt_neu), \
        rt000_txt_stl, \
        rt000_aplidentnr_:(rt000_alt_neu), \
        rt000_aplvar_:(rt000_alt_neu), \
        rt000_aplnr_:(rt000_alt_neu), \
        rt000_agaltern_:(rt000_alt_neu), \
        rt000_txt_apl, \
        rt000_kkomm_nr, \
        rt000_kn_lgres_:(rt000_alt_neu), \
        rt000_kanbannr, \
        rt000_kanbananfnr, \
        rt000_servicenr, \
        rt000_kosttraeger, \
        rt000_projekt_id_:(rt000_alt_neu), \
        rt000_milest_verf, \
        rt000_vv_nr_:(rt000_alt_neu), \
        rt000_kneintl_:(rt000_alt_neu), \
        rt000_aendind, \
        rt000_kdidentnr, \
        rt000_kn_kapaz_:(rt000_alt_neu), \
        rt000_kn_unterbr_:(rt000_alt_neu), \
        rt000_kn_prodplan, \
        rt000_kn_tplager, \
        rt000_lfzeit, \
        rt000_fa_verschoben, \
        rt000_fortsetz_dat_:(rt000_alt_neu), \
        rt000_fortsetz_uhr_:(rt000_alt_neu), \
        rt000_fsterm_uhr_:(rt000_alt_neu), \
        rt000_seterm_uhr_:(rt000_alt_neu), \
        rt000_fsterm_w_uhr_:(rt000_alt_neu), \
        rt000_seterm_w_uhr_:(rt000_alt_neu), \
        rt000_kn_terminiert_:(rt000_alt_neu)


    // Weitere (r000-)Felder empfangen
    rt000_aenddr = NULL
    if (sm_is_bundle("b_rt000_2") == TRUE) {
        receive bundle "b_rt000_2" data \
            rt000_aenddr
    }


    // Wenn chargen_pflicht durch das Bundle nicht richtig empfangen wurde wird chargen_pflicht auf 0 gesetzt
    if (rt000_chargen_pflicht == NULL) {
        rt000_chargen_pflicht = "0"
    }
    if (rt000_lfzeit == NULL) {
        rt000_lfzeit = 0
    }

    if (sm_is_bundle("b_rt000_ktr") == TRUE) {
        receive bundle "b_rt000_ktr" data \
            rt000_fklz_uebg, \
            rt000_fmlz_uebg, \
            rt000_menge_uebg, \
            rt000_menge_agl_uebg, \
            rt000_menge_abg_uebg, \
            rt000_fklz_prim, \
            rt000_fklz_var
    }
    else {
        rt000_fklz_uebg      = NULL
        rt000_fmlz_uebg      = NULL
        rt000_menge_uebg     = 0
        rt000_menge_agl_uebg = 0
        rt000_menge_abg_uebg = 0
    }

    rt000_fklz_q  = NULL
    rt000_fi_nr_q = NULL
    if (sm_is_bundle("bRt000CopyMM") == TRUE) {
        // Bundle zum kopieren von Merkmalen
        receive bundle "bRt000CopyMM" data \
            rt000_fklz_q, \
            rt000_fi_nr_q
    }

    // Über dieses Bundle kann gesteuert werden, ob ein zur aktuellen FKLZ gegebenfalls existierender Aktionssatz (r115)
    // als "zur aktuellen Verarbeitung gehörig" angesehen werden darf oder nicht.
    if (sm_is_bundle("b_rt000_filter")) {
        receive bundle "b_rt000_filter" data rt000_filter_logname
        // Keine Einschränkung in den Vorlaufmasken angegeben?
        if (rt000_filter_logname == "") {
            // Dann alle Benutzernamen als zugehörig betrachten
            rt000_filter_logname = "%"
        }
    }
    else {
        // Wenn es keinen Filter gibt, dann nur LOGNAME als zugehörig betrachten
        rt000_filter_logname = LOGNAME
    }


    // Initialisierungen:
    rt000_fu_bedr = ""
    rt000_austragen_ressourcenkonflikte = FALSE

    return OK
}

#--------------------------------------------------------------------
# rt000_send_rt000
#
# Bundle von "rt000" senden
# - gesendet werden alle Felder, die in "rt000" verändert werden
#   können
#--------------------------------------------------------------------
int proc rt000_send_rt000()
{
    send bundle "b_rt000_s" data \
        rt000_fklz, \
        rt000_fkfs, \
        rt000_fkfs_a, \
        rt000_menge_neu, \
        rt000_menge_aus_neu, \
        rt000_menge_offen_neu, \
        rt000_fsterm_neu, \
        rt000_seterm_neu, \
        rt000_fsterm_w_neu, \
        rt000_seterm_w_neu, \
        rt000_termart_neu, \
        rt000_altern_neu, \
        rt000_kostst, \
        rt000_arbplatz, \
        rt000_ncprognr, \
        rt000_fam, \
        rt000_kn_reihenfolge, \
        rt000_stlidentnr_neu, \
        rt000_stlvar_neu, \
        rt000_stlnr_neu, \
        rt000_staltern_neu, \
        rt000_datvon_stl, \
        rt000_txt_stl, \
        rt000_dataen_stl, \
        rt000_aendnr_stl, \
        rt000_aplidentnr_neu, \
        rt000_aplvar_neu, \
        rt000_aplnr_neu, \
        rt000_agaltern_neu, \
        rt000_datvon_apl, \
        rt000_txt_apl, \
        rt000_dataen_apl, \
        rt000_aendnr_apl,\
        rt000_kkomm_nr,\
        rt000_kn_lgres_neu,\
        rt000_projekt_id_neu, \
        rt000_kosttraeger, \
        rt000_kn_kapaz_neu, \
        rt000_fortsetz_dat_neu, \
        rt000_fortsetz_uhr_neu, \
        rt000_fsterm_uhr_neu, \
        rt000_seterm_uhr_neu, \
        rt000_fsterm_w_uhr_neu, \
        rt000_seterm_w_uhr_neu, \
        rt000_kn_terminiert_neu

    return OK
}

#--------------------------------------------------------------------
# proc rt000_bundle_lt110()
#--------------------------------------------------------------------
int proc rt000_bundle_lt110()
{
    send bundle "b_lt110" data \
        rt000_identnr_:(rt000_alt_neu), \
        rt000_var_:(rt000_alt_neu), \
        FALSE, \
        rt000_werk, \
        rt000_lgnr_:(rt000_alt_neu), \
        rt000_bestell_diff, \
        NULL

    return OK
}

#--------------------------------------------------------------------
# rt000_SET_KANBAN
#
# - Daten Kanbanauftrag setzen
#--------------------------------------------------------------------

int proc rt000_set_kanban()
{
    int rcL

    if (rt000_kanbannr == NULL || (rt000_aes != cAES_DELETE && rt000_aes != cAES_INSERT)) {
        return OK
    }

    // Löschen / Stornieren eines Kanban-Fertigungsauftrags
    if (rt000_aes == cAES_DELETE) {
        if !(dm_is_cursor("rt000_read_d800")) {
            dbms declare rt000_read_d800 cursor for \
                 select d800.st_kanbannr \
                   from d800 \
                  where d800.fi_nr    = ::FI_NR1 \
                    and d800.kanbannr = ::kanbannr

            dbms with cursor rt000_read_d800 alias rt000_st_kanbannr
        }
        dbms with cursor rt000_read_d800 execute using FI_NR1, rt000_kanbannr

        // Setzen Behälterstatus auf "0", wenn kein Auslaufkanban, sonst
        // soll der Status auf "Auslaufkanbna = 9" stehen bleiben
        if (rt000_st_kanbannr != "9") {
            rt000_st_kanbannr = "0"
        }

        // Setzen Daten Kanbanauftrag (KB-Auftr.Status...)

        rt000_status     = "9"
        rt000_freig_dat  = @date(BU_DATE0)
        rt000_rueck_dat  = @date(BU_DATE0)
        rt000_fertig_dat = @date(BU_DATE0)
    }

    // Übernahme eines Kanban-BVOR als Kanban-FA
    if (rt000_aes == cAES_INSERT) {
        rt000_st_kanbannr = "4"

        call gm300_activate(rt000_handle_gm300)        // 300170598
        call gm300_init()
        opcodeGm300E = "today"

        // Datum ermitteln
        if (gm300_datum() != OK) {
            // Datum nicht im Fabrikkalender!
            call bu_msg_errmsg("Gm300", NULL)
            call gm300_deactivate(rt000_handle_gm300)        // 300170598
            return on_error(FAILURE, "", "", rt000_prot)    // 300170598
        }

        rt000_freig_dat = datumGm300A
        call gm300_deactivate(rt000_handle_gm300)        // 300170598
    }

    rcL = rt000_update_d800()
    if (rcL != OK) {
        return rcL
    }

    rcL = rt000_update_d810()
    if (rcL != OK) {
        return rcL
    }

    // Wenn keine Auslauf-Kanbankarte, erfolgt nach dem
    // Löschen des Kanban-FA und Stornieren des Kanbanauftrags
    // die Neuanlage eines neuen Kanbanauftrags, allerdings
    // nur incl. BVOR!
    if (rt000_aes == cAES_DELETE && rt000_st_kanbannr != "9" && rt000_D_KB_STORNO == "1") {
        if !(dm_is_cursor("rt000_read_d810")) {
           dbms declare rt000_read_d810 cursor for \
                 select max(d810.kanbananfnr) \
                   from d810 \
                  where d810.fi_nr = ::FI_NR1 \
                    and d810.kanbannr = ::kanbannr

           dbms with cursor rt000_read_d810 alias rt000_kanbananfnr
        }
        dbms with cursor rt000_read_d810 execute using FI_NR1, rt000_kanbannr

        rt000_kanbananfnr = rt000_kanbananfnr + 1

        call rt000_send_dt810()

        rcL = dt810_neuanlage(rt000_dt810_handle, TRUE)
        if (rcL != OK) {
            return rcL
        }
    }

    return OK
}

#-------------------------------------------------------------------------
# rt000_send_dt810
#-------------------------------------------------------------------------
int proc rt000_send_dt810()
{
    vars lo_kn_verfueg
    vars lo_versorg_fmlz

    if (rt000_aufpos == NULL) {
        rt000_aufpos = 0
    }

    send bundle "b_dt810" data \
        rt000_werk, \
        rt000_kanbannr, \
        rt000_kanbananfnr, \
        rt000_kostst, \
        rt000_identnr_neu, \
        rt000_var_neu, \
        rt000_lgnr_neu, \
        rt000_lgber, \
        rt000_lgfach, \
        0, \
        NULL, \
        NULL, \
        BU_DATE0, \
        BU_DATE0, \
        BU_DATE0, \
        "1", \
        0, \
        rt000_menge_alt, \
        0, \
        0, \
        "0", \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        0, \
        "0"

    if (cod_aart_versorg(rt000_aart) == TRUE) {
        lo_kn_verfueg = "1"

        dbms alias lo_versorg_fmlz
        dbms sql select r100.fmlz \
                   from r100 \
                  where r100.fi_nr = :+FI_NR1 \
                    and r100.fklz  = :+rt000_fklz
        dbms alias
    }
    else {
        lo_kn_verfueg = "11"
    }

    send bundle "b_dt810_zusatz" data \
        lo_kn_verfueg, \
        "1", \
        "0", \
        rt000_fklz, \
        lo_versorg_fmlz, \
        NULL, \
        0, \
        rt000_aufnr, \
        rt000_aufpos, \
        0
}

#--------------------------------------------------------------------
# rt000_UPDATE_D800
#
# - Kanbankarte (d800) aktualisieren
#--------------------------------------------------------------------

int proc rt000_update_d800()
{
    int rcL

    if (rt000_load_dt800() != OK) {
        return FAILURE
    }

    call sm_n_1clear_array("stringtab")
    call sm_n_1clear_array("stringtab2")

    stringtab[++]  = "st_kanbannr"
    stringtab2[++] = rt000_st_kanbannr

    send bundle "b_dt800_dyn_data" data rt000_kanbannr, stringtab, stringtab2

    rcL = dt800_dyn_update(rt000_dt800_handle)
    if (rcL != OK) {
        return FAILURE
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_UPDATE_D810
#
# - Kanbankarte (d810) aktualisieren
#--------------------------------------------------------------------

int proc rt000_update_d810()
{
    int rcL
    vars lo_kn_verfueg
    vars lo_versorg_fmlz

    if (rt000_load_dt810() != OK) {
        return FAILURE
    }

    call sm_n_1clear_array("stringtab")
    call sm_n_1clear_array("stringtab2")

    stringtab[++]  = "st_kanbannr"
    stringtab2[++] = rt000_st_kanbannr

    if (rt000_aes == cAES_DELETE || rt000_aes == cAES_INSERT) {
        stringtab[++]   = "freig_dat"
        stringtab[++]   = "atag_frei"
        stringtab[++]   = "ktag_frei"

        stringtab2[++] = rt000_freig_dat
        stringtab2[++] = 0
        stringtab2[++] = 0
    }

    if (rt000_aes == cAES_DELETE) {
        stringtab[++]   = "rueck_dat"
        stringtab[++]   = "atag_rueck"
        stringtab[++]   = "ktag_rueck"
        stringtab[++]   = "ist_menge"
        stringtab[++]   = "fertig_dat"
        stringtab[++]   = "ktag_fertig"
        stringtab[++]   = "atag_fertig"
        stringtab[++]   = "ktag_versorg"
        stringtab[++]   = "atag_versorg"
        stringtab[++]   = "ktag_eigen"
        stringtab[++]   = "atag_eigen"
        stringtab[++]   = "ktag_fremd"
        stringtab[++]   = "atag_fremd"
        stringtab[++]   = "status"

        stringtab2[++] = rt000_rueck_dat
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = rt000_fertig_dat
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = 0
        stringtab2[++] = rt000_status
    }


    if (stringtab->num_occurrences > 0) {
        send bundle "b_dt810_dyn_key" data rt000_kanbannr, rt000_kanbananfnr

        if (cod_aart_versorg(rt000_aart) == TRUE) {
            dbms alias lo_versorg_fmlz
            dbms sql select r100.fmlz \
                       from r100 \
                      where r100.fi_nr = :+FI_NR1 \
                        and r100.fklz  = :+rt000_fklz
            dbms alias

            lo_kn_verfueg = "11"
            if (lo_versorg_fmlz != NULL) {
                stringtab[++]   = "fmlz"
                stringtab2[++] = lo_versorg_fmlz
            }
        }
        else {
            lo_versorg_fmlz = NULL
            lo_kn_verfueg = "1"
        }

        if (rt000_fklz != NULL) {
            stringtab[++]   = "fklz"
            stringtab2[++] = rt000_fklz
        }

        if (rt000_aufnr != NULL) {
            stringtab[++]   = "aufnr"
            stringtab2[++] = rt000_aufnr
        }

        stringtab[++] = "aufpos"

        if (rt000_aufpos != NULL && rt000_aufpos > 0) {
            stringtab2[++] = rt000_aufpos
        }
        else {
            stringtab2[++] = "0"
        }

        stringtab[++]   = "kn_verfueg"
        stringtab2[++] = lo_kn_verfueg

        send bundle "b_dt810_zusatz" data \
            lo_kn_verfueg, \
            "0", \
            "1", \
            rt000_fklz, \
            lo_versorg_fmlz, \
            NULL, \
            0, \
            rt000_aufnr, \
            rt000_aufpos, \
            0

        send bundle "b_dt810_dyn_data" data stringtab, stringtab2

        rcL = dt810_dyn_update(rt000_dt810_handle)
        if (rcL != OK) {
            return FAILURE
        }
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_aendern
#--------------------------------------------------------------------
int proc rt000_aendern(handle)
{
    int rcL

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    receive bundle "b_rt000_aend" data \
        rt000_aes, \
        rt000_fklz, \
        rt000_identnr_neu, \
        rt000_var_neu, \
        rt000_altern_neu

    rcL = rt000_aendern_verarb()

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return rcL
}

#--------------------------------------------------------------------
int proc rt000_aendern_verarb()
{
    int rcL


    if (rt000_aes != cAES_DELETE && rt000_aes != cAES_UPDATE && rt000_aes != "9") {
        return OK
    }

    if (rt000_fklz == NULL) {
        return OK
    }

    rt000_alt_neu = "alt"
    rcL = rt000_sel_r000()
    if (rcL != OK) {
        return rcL
    }

    // Gm300 neu laden, da sich das Werk geändert haben könnte
    if (rt000_load_gm300(fi_nr, rt000_werk) != OK) {
        return FAILURE
    }

    rcL = rt000_pruefen_verarb(TRUE)
    if (rcL != OK) {
        return rcL
    }

    // Alt-Felder nach Neu übernehmen (siehe auch Funktion rt000_priv_uebernehmen_alt_in_neu!)
    rt000_menge_neu        = rt000_menge_alt
    rt000_menge_aus_neu    = rt000_menge_aus_alt
    rt000_menge_offen_neu  = rt000_menge_offen_alt
    rt000_fsterm_neu       = rt000_fsterm_alt
    rt000_fortsetz_dat_neu = rt000_fortsetz_dat_alt
    rt000_seterm_neu       = rt000_seterm_alt
    rt000_fsterm_w_neu     = rt000_fsterm_w_alt
    rt000_seterm_w_neu     = rt000_seterm_w_alt
    rt000_fsterm_uhr_neu   = rt000_fsterm_uhr_alt
    rt000_fortsetz_uhr_neu = rt000_fortsetz_uhr_alt
    rt000_seterm_uhr_neu   = rt000_seterm_uhr_alt
    rt000_fsterm_w_uhr_neu = rt000_fsterm_w_uhr_alt
    rt000_seterm_w_uhr_neu = rt000_seterm_w_uhr_alt
    rt000_red_faktor_neu   = rt000_red_faktor_alt
    rt000_termstr_neu      = rt000_termstr_alt
    rt000_termart_neu      = rt000_termart_alt
    rt000_staltern_neu     = rt000_staltern_alt
    rt000_agaltern_neu     = rt000_agaltern_alt
    rt000_kn_lgres_neu     = rt000_kn_lgres_alt
    rt000_lgnr_neu         = rt000_lgnr_alt
    rt000_kn_kapaz_neu     = rt000_kn_kapaz_alt
    rt000_kn_unterbr_neu   = rt000_kn_unterbr_alt

    if (rt000_aes == cAES_UPDATE || rt000_aes == "9") {
        rt000_stlidentnr_neu  = rt000_identnr_neu
        rt000_stlvar_neu      = rt000_var_neu
        rt000_stlnr_neu       = NULL
        rt000_aplidentnr_neu  = rt000_identnr_neu
        rt000_aplvar_neu      = rt000_var_neu
        rt000_aplnr_neu       = NULL
    }
    else {
        rt000_stlidentnr_neu  = rt000_stlidentnr_alt
        rt000_stlvar_neu      = rt000_stlvar_alt
        rt000_stlnr_neu       = rt000_stlnr_alt
        rt000_aplidentnr_neu  = rt000_aplidentnr_alt
        rt000_aplvar_neu      = rt000_aplvar_alt
        rt000_aplnr_neu       = rt000_aplnr_alt
        rt000_altern_neu      = rt000_altern_alt
    }

    return rt000_verwalten_verarb(TRUE, cTKZ_KEINE, "", "", $NULL, KN_AEND_FA_OHNE, $NULL)
}

#--------------------------------------------------------------------
int proc rt000_sel_r000()
{
    if !(dm_is_cursor("rt000_read_r000")) {
        dbms declare rt000_read_r000 cursor for \
            select \
                r000.aufnr, \
                r000.aufpos, \
                r000.identnr, \
                r000.var, \
                r000.aart, \
                r000.werk, \
                r000.fkfs, \
                r000.fkfs_a, \
                r000.menge, \
                r000.menge_abg, \
                r000.menge_aus, \
                r000.menge_gef, \
                r000.menge_offen, \
                r000.fsterm, \
                r000.seterm, \
                r000.kz_fix, \
                r000.fsterm_w, \
                r000.seterm_w, \
                r000.dlzeit, \
                r000.red_faktor, \
                r000.vzag, \
                r000.vzzeit, \
                r000.kalk, \
                r000.loesch, \
                r000.zusammen, \
                r000.freigabe, \
                r000.kz_spl, \
                r000.kz_ueb, \
                r000.matbuch, \
                r000.termstr, \
                r000.termart, \
                r000.aenddr, \
                r000.drucknr, \
                r000.disstufe, \
                r000.da, \
                r000.ch, \
                r000.bs, \
                r000.altern, \
                r000.kostst, \
                r000.arbplatz, \
                r000.ncprognr, \
                r000.fam, \
                r000.kn_reihenfolge, \
                r000.lgnr, \
                r000.lgber, \
                r000.lgfach, \
                r000.schad_code, \
                r000.kn_ws, \
                r000.charge, \
                r000.chargen_pflicht, \
                r000.stlidentnr, \
                r000.stlvar, \
                r000.stlnr, \
                r000.staltern, \
                r000.datvon_stl, \
                r000.dataen_stl, \
                r000.aendnr_stl, \
                r000.txt_stl, \
                r000.aplidentnr, \
                r000.aplvar, \
                r000.aplnr, \
                r000.agaltern, \
                r000.datvon_apl, \
                r000.dataen_apl, \
                r000.aendnr_apl, \
                r000.txt_apl, \
                r000.kkomm_nr, \
                r000.kn_lgres, \
                r000.kanbannr, \
                r000.kanbananfnr, \
                r000.servicenr, \
                r000.kosttraeger, \
                r000.milest_verf, \
                r000.vv_nr, \
                r000.aendind, \
                r000.kn_kapaz, \
                r000.kn_unterbr, \
                r000.kn_prodplan, \
                r000.fortsetz_dat, \
                r000.fortsetz_uhr, \
                r000.fsterm_uhr, \
                r000.seterm_uhr, \
                r000.fsterm_w_uhr, \
                r000.seterm_w_uhr, \
                r000.kn_terminiert \
               from  r000 \
              where  r000.fi_nr  = ::FI_NR1 \
                and  r000.fklz   = ::fklz
    }

    dbms with cursor rt000_read_r000 alias \
        rt000_aufnr, \
        rt000_aufpos, \
        rt000_identnr_:(rt000_alt_neu), \
        rt000_var_:(rt000_alt_neu), \
        rt000_aart, \
        rt000_werk, \
        rt000_fkfs, \
        rt000_fkfs_a, \
        rt000_menge_:(rt000_alt_neu), \
        rt000_menge_abg, \
        rt000_menge_aus_:(rt000_alt_neu), \
        rt000_menge_gef, \
        rt000_menge_offen_:(rt000_alt_neu), \
        rt000_fsterm_:(rt000_alt_neu), \
        rt000_seterm_:(rt000_alt_neu), \
        rt000_kz_fix_:(rt000_alt_neu), \
        rt000_fsterm_w_:(rt000_alt_neu), \
        rt000_seterm_w_:(rt000_alt_neu), \
        rt000_dlzeit, \
        rt000_red_faktor_:(rt000_alt_neu), \
        rt000_vzag, \
        rt000_vzzeit, \
        rt000_kalk, \
        rt000_loesch, \
        rt000_zusammen, \
        rt000_freigabe, \
        rt000_kz_spl, \
        rt000_kz_ueb, \
        rt000_matbuch, \
        rt000_termstr_:(rt000_alt_neu), \
        rt000_termart_:(rt000_alt_neu), \
        rt000_aenddr, \
        rt000_drucknr, \
        rt000_disstufe, \
        rt000_da, \
        rt000_ch, \
        rt000_bs, \
        rt000_altern_:(rt000_alt_neu), \
        rt000_kostst, \
        rt000_arbplatz, \
        rt000_ncprognr, \
        rt000_fam, \
        rt000_kn_reihenfolge, \
        rt000_lgnr_:(rt000_alt_neu), \
        rt000_lgber, \
        rt000_lgfach, \
        rt000_schad_code, \
        rt000_kn_ws, \
        rt000_charge, \
        rt000_chargen_pflicht, \
        rt000_stlidentnr_:(rt000_alt_neu), \
        rt000_stlvar_:(rt000_alt_neu), \
        rt000_stlnr_:(rt000_alt_neu), \
        rt000_staltern_:(rt000_alt_neu), \
        rt000_datvon_stl, \
        rt000_dataen_stl, \
        rt000_aendnr_stl, \
        rt000_txt_stl, \
        rt000_aplidentnr_:(rt000_alt_neu), \
        rt000_aplvar_:(rt000_alt_neu), \
        rt000_aplnr_:(rt000_alt_neu), \
        rt000_agaltern_:(rt000_alt_neu), \
        rt000_datvon_apl, \
        rt000_dataen_apl, \
        rt000_aendnr_apl, \
        rt000_txt_apl, \
        rt000_kkomm_nr, \
        rt000_kn_lgres_:(rt000_alt_neu), \
        rt000_kanbannr, \
        rt000_kanbananfnr, \
        rt000_servicenr, \
        rt000_kosttraeger, \
        rt000_milest_verf, \
        rt000_vv_nr_:(rt000_alt_neu), \
        rt000_aendind, \
        rt000_kn_kapaz_:(rt000_alt_neu), \
        rt000_kn_unterbr_:(rt000_alt_neu), \
        rt000_kn_prodplan, \
        rt000_fortsetz_dat_:(rt000_alt_neu), \
        rt000_fortsetz_uhr_:(rt000_alt_neu), \
        rt000_fsterm_uhr_:(rt000_alt_neu), \
        rt000_seterm_uhr_:(rt000_alt_neu), \
        rt000_fsterm_w_uhr_:(rt000_alt_neu), \
        rt000_seterm_w_uhr_:(rt000_alt_neu), \
        rt000_kn_terminiert_:(rt000_alt_neu)

    dbms with cursor rt000_read_r000 execute using FI_NR1, rt000_fklz

    if (SQL_CODE == SQLNOTFOUND) {
        return WARNING
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r000", rt000_prot)
    }

    return OK
}

/**
 * Diese Methode ermittelt das Kennzeichen "aenddr" eines Fertigungsauftrages
 *
 * @prc                 rt000_sel_aenddr
 * @param rt000_aes
 * @param rt000_aenddr
 * @return OK
 * @return OK
 * @error FAILURE       Fehler
 * @see
 * @example
**/
int proc rt000_sel_aenddr()
{
    log LOG_DEBUG, LOGFILE, "rt000_aes >" ## rt000_aes ## "<"
    switch (rt000_aes) {
        case cAES_UPDATE:       // Mengen-/Terminänderung
        case cAES_REKONFIG:     // Tausch anstossen (z.B. im re000)
            break
        case cAES_INSERT:       // Neuanlage / Erste Einlanung anstossen
            rt000_aenddr = "0"
            return OK
        case cAES_DELETE:
        else:
            return OK
    }

    log LOG_DEBUG, LOGFILE, "rt000_fklz >" ## rt000_fklz ## "<"
    if (rt000_fklz == NULL) {
        rt000_aenddr = "0"
        return OK
    }


    if (dm_is_cursor("rt000_get_aenddr") != TRUE) {
        dbms declare rt000_get_aenddr cursor for \
             select  r000.aenddr \
               from  r000 \
              where  r000.fi_nr = ::FI_NR1 \
                and  r000.fklz  = ::fklz
    }

    dbms with cursor rt000_get_aenddr alias rt000_aenddr
    dbms with cursor rt000_get_aenddr execute using FI_NR1, rt000_fklz

    switch (SQL_CODE) {
        case SQL_OK:
            if (rt000_aenddr == NULL) {
                rt000_aenddr = "0"
            }
            break
        case SQLNOTFOUND:
            rt000_aenddr = "0"
            break
        else:
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r000", rt000_prot)
    }

    log LOG_DEBUG, LOGFILE, "rt000_aenddr >" ## rt000_aenddr ## "<"
    return OK
}

#--------------------------------------------------------------------
int proc rt000_decl_objektid()
{
    if (dm_is_cursor("selObjektidRt000") != TRUE) {
        dbms declare selObjektidRt000 cursor for \
             select r000.objektid \
             from r000 \
             where r000.fi_nr   = ::fi_nr \
             and   r000.fklz    = ::fklz

        dbms with cursor selObjektidRt000 alias rt000_objektid
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_merkmale_delete
#--------------------------------------------------------------------
int proc rt000_merkmale_delete()
{
    int rcL

    if (G_MERKMAL == "0") {
        return OK
    }

    if (rt000_aes == cAES_DELETE || (rt000_aes == cAES_UPDATE && rt000_identnr_alt != rt000_identnr_neu)) {
        // Löschen Merkmale bei aes=1 oder bei aes=3, wenn sich die identnr geändert hat.

        call rt000_decl_objektid()
        dbms with cursor selObjektidRt000 execute using FI_NR1, rt000_fklz
        if (rt000_objektid == NULL) {
            return OK
        }

        rt000_gm790_handle = bu_load_modul("gm790", rt000_gm790_handle, NULL)
        if (rt000_gm790_handle <= 0) {
            return on_error(FAILURE)
        }

        call gm790_activate(rt000_gm790_handle)
        call gm790_init()
        fklzGm790EA     = rt000_fklz    // @bsldoc.ignore
        fi_nrGm790EA    = FI_NR1        // @bsldoc.ignore

        rcL = gm790_loeschen_fklz()
        if (rcL < OK) {
            call bu_msg_errmsg("Gm790", NULL)
            call gm790_deactivate(rt000_gm790_handle)
            return on_error(FAILURE)
        }
        else if (rcL > OK) {
            call bu_msg_errmsg("Gm790", NULL)
            call rt000_proto(rcL, PRT_CTRL_HINWEIS, $NULL, $NULL)
        }
        rt000_objektid = NULL
        call gm790_deactivate(rt000_gm790_handle)
    }

    return OK
}

#--------------------------------------------------------------------
# rt000_merkmale_insert
#--------------------------------------------------------------------
int proc rt000_merkmale_insert()
{
    int rcL

    if (G_MERKMAL == "0") {
        return OK
    }

    if (rt000_fklz == NULL) {
        return OK
    }

    if (rt000_aes == cAES_INSERT || (rt000_aes == cAES_UPDATE && rt000_identnr_alt != rt000_identnr_neu)) {
        /* Einfügen Merkmale bei aes=2 oder bei aes=3, wenn sich die identnr geändert hat */

        if (rt000_aes == cAES_INSERT) {
            rt000_objektid = NULL
        }

        /* Sind überhaupt FA-Kriterien erfaßt worden? */
        if (dm_is_cursor("rt000_zuordnung") != TRUE) {
            dbms declare rt000_zuordnung cursor for \
                 select distinct g710.objektid \
                 from  g000, g710, g730 \
                 where g000.fi_nr    = ::fi_nr \
                 and   g000.identnr  = ::identnr \
                 and   g710.objektid = g000.objektid \
                 and   g710.kritnr   > 0 \
                 and   g710.kritgrp  = 0 \
                 and   g730.kritnr   = g710.kritnr \
                 and   g730.kritart  = '009' \
                 union \
                 select g710.objektid \
                 from  g000, g710, g760 \
                 where g000.fi_nr    = ::fi_nr \
                 and   g000.identnr  = ::identnr \
                 and   g710.objektid = g000.objektid \
                 and   g710.kritnr   = 0 \
                 and   g710.kritgrp  > 0 \
                 and   g760.kritgrp  = g710.kritgrp \
                 and   g760.kritart  = '009'
            dbms with cursor rt000_zuordnung alias stringtab
        }

        call sm_n_1clear_array("stringtab")
        dbms with cursor rt000_zuordnung execute using FI_G000, rt000_identnr_neu, FI_G000, rt000_identnr_neu

        if (stringtab->num_occurrences == 0) {
            return OK
        }

        rt000_gm790_handle = bu_load_modul("gm790", rt000_gm790_handle, NULL)
        if (rt000_gm790_handle <= 0) {
            return on_error(FAILURE)
        }

        call gm790_activate(rt000_gm790_handle)
        call gm790_init()
        if (rt000_fklz_q  != NULL \
        &&  rt000_fi_nr_q >  0) {
            fklzGm790EA        = rt000_fklz_q   // @bsldoc.ignore
            fi_nrGm790EA       = rt000_fi_nr_q  // @bsldoc.ignore
            fklz_1Gm790EA      = rt000_fklz     // @bsldoc.ignore
            fi_nr_1Gm790EA     = FI_NR1         // @bsldoc.ignore

            rcL = gm790_kopieren_fklz()
        }
        else {
            fklzGm790EA        = rt000_fklz     // @bsldoc.ignore
            fi_nrGm790EA       = FI_NR1         // @bsldoc.ignore

            rcL = gm790_einfuegen_fklz()
        }

        if (rcL != OK) {
            call bu_msg_errmsg("Gm790", NULL)
            call gm790_deactivate(rt000_gm790_handle)
            return on_error(FAILURE)
        }
        rt000_objektid = objektidGm790EA
        call gm790_deactivate(rt000_gm790_handle)
    }

    return OK
}

#--------------------------------------------------------------------
int proc rt000_load_lt110()
{
    public lt110:(EXT)
    if (rt000_lt110_handle <= 0) {
        rt000_lt110_handle = lt110_first_entry(rt000_prot)
        if (rt000_lt110_handle < OK) {
            unload lt110:(EXT)
            // Fehler beim Laden des Moduls %s!
            return on_error(FAILURE, "APPL0520", "lt110")
        }
        call lt110_entry(rt000_lt110_handle)
    }
    return OK
}

#--------------------------------------------------------------------
int proc rt000_load_it000()
{
    rt000_it000_handle = bu_load_tmodul("it000", rt000_it000_handle)
    if (rt000_it000_handle < 0) {
        return on_error(FAILURE)
    }

    call it000_entry(rt000_it000_handle)

    return OK
}

#--------------------------------------------------------------------
int proc rt000_load_dt800()
{
    rt000_dt800_handle = bu_load_tmodul("dt800", rt000_dt800_handle)
    if (rt000_dt800_handle < 0) {
        return on_error(FAILURE)
    }

    call dt800_entry(rt000_dt800_handle)

    return OK
}

#--------------------------------------------------------------------
int proc rt000_load_dt810()
{
    rt000_dt810_handle = bu_load_tmodul("dt810", rt000_dt810_handle)
    if (rt000_dt810_handle < 0) {
        return on_error(FAILURE)
    }

    call dt810_entry(rt000_dt810_handle)

    return OK
}

#--------------------------------------------------------------------
int proc rt000_set_cm130(aesStrukturP)
{
    int rcL

    log LOG_DEBUG, LOGFILE,"aesStrukturP >" ## aesStrukturP ## "< C_KTR_AKTIV >" ## C_KTR_AKTIV ## "<"

    if (C_KTR_AKTIV != "1") {
        return OK
    }

    rt000_cm130 = bu_load_modul("cm130", rt000_cm130)
    call bu_assert(rt000_cm130 >= 0)
    call cm130_activate(rt000_cm130)
    call cm130_init()

    kosttraegerCm130 = rt000_kosttraeger
    identnrCm130     = rt000_identnr_neu
    varCm130         = rt000_var_neu
    disstufeCm130    = rt000_disstufe

    aesCm130         = aesStrukturP

    if (rt000_verw_art != "2") {
        ufklzCm130      = rt000_fklz
        menge_entCm130  = 0
        mengeCm130      = 0
        menge_aglCm130  = 0
        menge_abgCm130  = 0
    }
    else {
        fmlzCm130      = rt000_fmlz_uebg
        fklzCm130      = rt000_fklz_uebg
        ufklzCm130     = rt000_fklz
        menge_entCm130 = 0
        mengeCm130     = rt000_menge_uebg
        menge_aglCm130 = rt000_menge_agl_uebg
        menge_abgCm130 = rt000_menge_abg_uebg
    }

    log LOG_DEBUG, LOGFILE,"3 * fklzCm130 >:fklzCm130< * ufklzCm130 >:ufklzCm130< * fmlzCm130 >:fmlzCm130<"
    log LOG_DEBUG, LOGFILE,"4 * kosttraegerCm130 >:kosttraegerCm130< * identnrCm130 >:identnrCm130< * varCm130 >:varCm130<"
    log LOG_DEBUG, LOGFILE,"5 * disstufeCm130 >:disstufeCm130< * mengeCm130 >:mengeCm130< * aesCm130 >:aesCm130<"
    log LOG_DEBUG, LOGFILE,"6 * menge_aglCm130 >:menge_aglCm130< * menge_abgCm130 >:menge_abgCm130< * rt000_verw_art >:rt000_verw_art<"

    rcL = cm130_struktur()
    call bu_msg_errmsg("cm130")
    call cm130_deactivate(rt000_cm130)
    if (rcL < OK) {
        return on_error(FAILURE)
    }

    return OK
}

#--------------------------------------------------------------------
int proc rt000_load_gm300(fi_nrP, werkP)
{
    rt000_handle_gm300 = bu_load_modul("gm300", rt000_handle_gm300)
    if (rt000_handle_gm300 < 0) {
        return FAILURE
    }

    // der Kalender wurde schon gelesen und muss nicht ein 2. Mal gelesen werden
    // => Laufzeit!

    call gm300_activate(rt000_handle_gm300)        // 300170598

    if (fi_nrKalenderRt000 != NULL && \
        werkKalenderRt000  != NULL && \
        fi_nrKalenderRt000 == fi_nrP && \
        werkKalenderRt000  == werkP  && \
        kalidGm300EA        == kalidKalenderRt000) {
        call gm300_deactivate(rt000_handle_gm300)        // 300170598
        return OK
    }

    call gm300_init()

    fi_nrGm300E = fi_nrP
    werkGm300E = werkP

    // einmalig den zu verwendenden Kalender ermitteln
    if (gm300_kalender_ermitteln() != OK) {
        call bu_msg_errmsg("Gm300", NULL)  // 300170598
        call gm300_deactivate(rt000_handle_gm300)        // 300170598
        return on_error(FAILURE, "", "", rt000_prot)    // 300170598
    }

    fi_nrKalenderRt000 = fi_nrP
    werkKalenderRt000  = werkP
    kalidKalenderRt000 = kalidGm300EA

    call gm300_deactivate(rt000_handle_gm300)        // 300170598

    return OK
}

/**
 * Rücksetzen von kn_kritisch im FA (r000)
 *
 * "rt000_austragen_ressourcenkonflikte" muss auf TRUE gesetzt sein
 *
 * Alter Name: rt000_auftrag_n_kritisch
 *
 * @param r000P         CDBI der r000 mit neuen FA-Daten
 * @param [r000_altP]   CDBI der r000 mit alten FA-Daten
 * @return OK
 * @return FAILURE      Fehler
 * @see                 rt000_loeschen_resourcenkonflikte
 **/
int proc rt000_auftrag_zuruecksetzen_kn_kritisch(R000CDBI r000P, R000CDBI r000_altP)
{
    if (rt000_austragen_ressourcenkonflikte != TRUE \
    ||  defined(r000P)                      != TRUE) {
        return OK
    }


    // Rücksetzen KN_KRITISCH
    if (defined(r000_altP) == TRUE) {
        if (r000_altP=>kn_kritisch != 0) {
            r000P=>kn_kritisch = 0
        }
    }
    else {
        r000P=>kn_kritisch = 0
    }

    return OK
}

/**
 * Löschen der Ressourcenprüfungs-Tabellen r070/r0701 und Setzen kn_kritisch in FA
 *
 * Alter Name: rt000_auftrag_n_kritisch
 *
 * @param r000P         CDBI der r000 mit neuen FA-Daten (nur bei r000P = $NULL)
 * @param r000_altP     CDBI der r000 mit alten FA-Daten (nur bei r000P = $NULL)
 * @return OK
 * @return FAILURE      Fehler
 * @see                 rt000_auftrag_zuruecksetzen_kn_kritisch
 **/
int proc rt000_loeschen_resourcenkonflikte(R000CDBI r000P, R000CDBI r000_altP)
{
    boolean eigene_transaktionL = (SQL_IN_TRANS != TRUE)


    if (rt000_austragen_ressourcenkonflikte != TRUE) {
        return OK
    }


    // Löschen r070 und r0701
    if (eigene_transaktionL == TRUE) {
        if (bu_begin() != OK) {
            return FAILURE
        }
    }


    // 1) Ressourcenkonflikte Fertigungsauftrag löschen
    dbms sql \
        delete from \
            r070 \
        where \
            r070.fklz  = :+rt000_fklz and \
            r070.fi_nr = :+FI_NR1

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Löschen in Tabelle %s.
        return on_error(FAILURE, "APPL0005", "r070", rt000_prot)
    }


    // 2) Meldungen Ressourcenkonflikte Fertigungsauftrag löschen
    dbms sql \
        delete from \
            r0701 \
        where \
            r0701.fklz  = :+rt000_fklz and \
            r0701.fi_nr = :+FI_NR1

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Löschen in Tabelle %s.
        return on_error(FAILURE, "APPL0005", "r0701", rt000_prot)
    }


    if (eigene_transaktionL == TRUE) {
        call bu_commit()
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt000_serienverwaltung()
{
    double benoetigtL
    boolean n_benoetigte_loeschenL


    // Bei Neuanlage müssen weder Seriennummern generiert, noch welche wieder freigegeben werden.
    if (rt000_aes == cAES_INSERT) {
        return OK
    }

    // Bei Änderungen an Teilenummer/Variante oder der Lagernummer sind noch Vorarbeiten nötig.
    if ( \
        rt000_identnr_alt != rt000_identnr_neu || \
        rt000_var_alt     != rt000_var_neu \
    ) {
        // Todo JK@BEB: Gegebenenfalls bereits vorhandene Seriennummern für die alte Teilenummer freigeben?
    }
    else if (rt000_lgnr_alt != rt000_lgnr_neu) {
        // Die Lagernummer in den bestehenden Seriennummmern anpassen, sodass diese weiterverwendet werden können.
        if ( \
            rt000_update_seriennummern( \
                rt000_identnr_alt, \
                rt000_var_alt, \
                rt000_lgnr_alt, \
                rt000_fklz, \
                rt000_lgnr_neu \
            ) != OK \
        ) {
            return FAILURE
        }
    }

    // Keine Mengenänderung?
    if (rt000_menge_offen_alt == rt000_menge_offen_neu) {
        return OK
    }

    // Bei Verminderung der Menge kann die Seriennummern, die nicht mehr benötigt sind, gelöscht werden.
    if (rt000_menge_offen_neu < rt000_menge_offen_alt) {
        n_benoetigte_loeschenL = rt000_R_SERIE_STORNO == "0"
    }

    if (rt000_fkfs < FSTATUS_FREIGEGEBEN) {
        // Ohne Freigabe kann die Zuordnung zu ggfs. bereits generierten Seriennummern aufgehoben werden.
        benoetigtL = 0.0
    }
    else {
        // Ansonsten muss die benötigte Menge berücksichtigt werden.
        benoetigtL = rt000_menge_offen_neu
    }

    // Abgleich durchführen
    if ( \
        fertig_abgleich_seriennummern( \
            rt000_identnr_neu, \
            rt000_var_neu, \
            rt000_lgnr_neu, \
            rt000_aufnr, \
            rt000_aufpos, \
            rt000_fklz, \
            @to_int(benoetigtL), \
            n_benoetigte_loeschenL \
        ) != OK \
    ) {
        return FAILURE
    }

    return OK
}

/**
 * Ändert die Lagernummer in den durch die ersten vier Parameter adressierten Seriennummern.
 *
 * @param identnrP      Teilenummer
 * @param varP          Variante
 * @param lgnrP         Lagernummer
 * @param fklzP         FKLZ
 * @param lgnr_neuP     Neue Lagernummer
 * @return OK           Aktualisierung erfolgreich durchgeführt
 * @return FAILURE      Aktualisierung abgebrochen
 **/
int proc rt000_update_seriennummern(string identnrP, string varP, int lgnrP, string fklzP, int lgnr_neuP)
{
    modulLq080 lq080_rL
    modulLq080 lq080_wL


    call bu_assert(identnrP != "")
    call bu_assert(fklzP != "")

    public lq080.bsl
    lq080_rL                        = lq080_new(1)
    lq080_rL=>daten[1]=>identnr     = identnrP
    lq080_rL=>daten[1]=>var         = varP
    lq080_rL=>daten[1]=>lgnr        = lgnrP
    lq080_rL=>daten[1]=>ufklz       = fklzP
    lq080_rL=>daten[1]=>serien_stat = cSERIE_ERFASST
    call lq080_get_seriennr(lq080_rL, FALSE)
    if (md_get_arraysize(lq080_rL, "seriennr") > 0) {
        lq080_wL                    = lq080_new(1)
        lq080_wL=>daten[1]=>identnr = identnrP
        lq080_wL=>daten[1]=>var     = varP
        lq080_wL=>daten[1]=>lgnr    = lgnr_neuP
        call bu_cdt_copyarray(lq080_rL, "seriennr", lq080_wL=>daten[1], "seriennr")
        if (lq080_update(lq080_wL) != OK) {
            return FAILURE
        }
    }
    unload lq080.bsl

    return OK
}

/**
 * Prüfung des Fortsetztermins abhängig vom FA-Status
 *
 * ...wenn er geändert wurde auf eien anderen Zeitstempel
 *
 * - Bei Löschung FA wird nicht geprüft.
 * - Beim Einfügen oder wenn der FA-Status < 6, wird der Fortsetzttermin ausgetragen.
 * - Bei FA-Status > 6 kann der Fortsetzttermin nicht geändert werden.
 *
 * Benötigte Felder:
 * - rt000_aes
 * - rt000_fkfs
 * - rt000_fkfs_a
 * - rt000_fortsetz_uhr_neu
 * - rt000_fortsetz_uhr_alt
 *
 * @return OK
 *                      rt000_fortsetz_uhr_neu
 * @return WARNING      Endtermin liegt vor dem Fortsetztermin
 * @return FAILURE      Fortsetzungstermin liegt vor dem Starttermin
 * @see                 {@code rq000_val_fortsetz_uhr_pruefungen_gegen_fsterm_uhr}
 * @see                 {@code rq200i_korrektur_fa_termine_ag_verschoben_und_nicht_am_dl}
 **/
// 300185637
int proc rt000_pruefen_fortsetz_dat_status6()
{
    string fkfsL = fertig_get_fkfs(rt000_fkfs, rt000_fkfs_a)


    if (rt000_aes == cAES_DELETE) {
        return OK
    }

    if (rt000_aes == cAES_INSERT \
    ||  fkfsL     <  FSTATUS_BEGONNEN) {
        rt000_fortsetz_uhr_neu = ""
        return OK
    }

    if (fkfsL > FSTATUS_ANGEARBEITET) {
        rt000_fortsetz_uhr_neu = rt000_fortsetz_uhr_alt
        return OK
    }

    if (rt000_tkz == cTKZ_STRUKTUR) {
        rt000_fortsetz_uhr_neu = ""
        return OK
    }

    // Fortsetzungsttermin wurde auf einen anderen Termin geändert (d.h. nicht ausgetragen).
    // Dann prüfen, ob der Endtermin vor dem Fortsetztermin liegt.
    if (rt000_fortsetz_uhr_neu        != "" \
    &&  @time(rt000_fortsetz_uhr_neu) != @time(rt000_fortsetz_uhr_alt)) {
        if (@time(rt000_seterm_uhr_neu) < @time(rt000_fortsetz_uhr_neu)) {
            // bei Termart = 2 und 3 Fehler, sonst korrigieren
            if (rt000_termart_neu == cTERMART_RUECKW) {
                rt000_fortsetz_uhr_neu = rt000_seterm_uhr_neu
            }
            else if (rt000_termart_neu == cTERMART_VORW) {
                rt000_seterm_uhr_neu = rt000_fortsetz_uhr_neu
            }
            else {
                // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
                return on_error(WARNING, "r0000129", rt000_seterm_uhr_neu ## "^" ## rt000_fortsetz_uhr_neu, rt000_prot)
            }
        }

        if (rt000_fortsetz_uhr_neu != NULL && @time(rt000_fortsetz_uhr_neu) < @time(rt000_fsterm_uhr_neu)) {
            // Der Fortsetzstermin >%1< darf nicht vor den ursprünglichen Starttermin >%2< fallen.
            return on_error(FAILURE, "r0000317", rt000_fortsetz_uhr_neu ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
        }
    }

    return OK
}

/**
 * Prüfung des Starttermins des FA bei angearbeiteten FA
 *
 * @param [standortkalenderP]   Standortkalender als Instanz von {@code cdtGq300}
 * @param [rq000P]              Fertigungsauftrag als Instanz von {@code cdtRq000}
 * @return OK
 * @return FAILURE              Fehler
 * @see                         {@code rq000_sind_istbelastungen_zum_fa_vorhanden}
 * @see                         {@code rq000i0_berechnen_daten_verschieben_angearbeiteter_fa_rueckwaerts}
 * @example
 **/
// 300185637 + 300353375
int proc rt000_pruefen_fsterm_status6(cdtGq300 standortkalenderP, cdtRq000 rq000P)
{
    int      angearbeitetL
    boolean  istbelastungen_vorhandenL


    angearbeitetL = fertig_check_fkfs_angearbeitet(rt000_fkfs, rt000_fkfs_a, rt000_fklz)
    if (rt000_aes                   != cAES_UPDATE \
    ||  angearbeitetL               != TRUE \
    ||  @time(rt000_fsterm_uhr_neu) == @time(rt000_fsterm_uhr_alt)) {
        return OK
    }


    // 300353375:
    // Bei einem angearbeiteten FA darf i.d.R. der Starttermin nicht mehr manuell geändert werden.
    // Ausnahme ist, wenn der FA keine Ist-Belastungen besitzt. Dann darf auch bei angearbeiteten FA der Starttermin
    // u.U. nochmal geändert werden (siehe auch "rq000i0_berechnen_daten_verschieben_angearbeiteter_fa_rueckwaerts").
    public rq000.bsl
    call rq000_set_fklz(rq000P, rt000_fklz)
    call rq000_set_fi_nr(rq000P, FI_NR1)
    call rq000_set_fkfs(rq000P, rt000_fkfs)
    call rq000_set_fkfs_a(rq000P, rt000_fkfs_a)
    call rq000_set_angearbeitet(rq000P, angearbeitetL)
    call rq000_set_clear_message(rq000P, TRUE)

    istbelastungen_vorhandenL = rq000_sind_istbelastungen_zum_fa_vorhanden(rq000P, BU_0)
    call rt000_protokoll_aus_rq000(rq000P, OK)


    if (istbelastungen_vorhandenL == TRUE) {
        log LOG_DEBUG, LOGFILE, "Bei FA im Status 5 und 6 darf sich der fsterm_uhr nicht mehr ändern: " \
                             ## "alt >" ## rt000_fsterm_alt ## "< / " \
                             ## "neu >" ## rt000_fsterm_neu ## "<"

        // Aus FA-Verwaltung wird immer abgebrochen
        if (rt000_verw_art == "5") {
            if (screen_name == "rv0000") {
                // Den Starttermin immer und ohne Meldung zurück setzen im rv0000, wenn Ist-Belastungen
                // vorhanden sind. Das Starttermin-Feld ist in der Maske in diesem Fall immer gesperrt.
                rt000_fsterm_uhr_neu = rt000_fsterm_uhr_alt
            }
            else {
                // Bei einem angearbeiteten Fertigungsauftrag >%1< darf der Starttermin >%2< nicht mehr auf >%3< geändert werden!
                return on_error(FAILURE, "r0000622", rt000_fklz ## "^" ## rt000_fsterm_uhr_alt ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
            }
        }
        else {
            // Bei einem angearbeiteten Fertigungsauftrag >%1< darf der Starttermin >%2< nicht mehr auf >%3< geändert werden. Der Starttermin wird auf den ursprünglichen Termin zurückgesetzt.
            call on_error(INFO, "r0000621", rt000_fklz ## "^" ## rt000_fsterm_uhr_alt ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
            rt000_fsterm_uhr_neu = rt000_fsterm_uhr_alt
        }
    }

    return OK
}

// 300185637
#--------------------------------------------------------------------
int proc rt000_pruefen_fsterm_w_status6()
{
    int angearbeitetL

    if (rt000_aes != cAES_UPDATE) {
        return OK
    }

    angearbeitetL = fertig_check_fkfs_angearbeitet(rt000_fkfs, rt000_fkfs_a, rt000_fklz)
    log LOG_DEBUG, LOGFILE, "rt000_fklz >" ## rt000_fklz ## "< / fkfs >" ## rt000_fkfs ## "< / fkfs_a >" ##rt000_fkfs_a ## "< / angearbeitet >" ## angearbeitetL ## "<"
    if (angearbeitetL != TRUE) {
        return OK
    }

    if (@time(rt000_fsterm_w_uhr_neu) != @time(rt000_fsterm_w_uhr_alt)) {
        log LOG_DEBUG, LOGFILE, "Bei FA im Status 5 und 6 darf sich der fsterm nicht mehr ändern: alt >:rt000_fsterm_alt< / neu >:rt000_fsterm_neu<"

        // Aus rv000 wird immer abgebrochen
        if (rt000_verw_art == "5") {
            // Bei einem angearbeiteten Fertigungsauftrag >%1< darf der Wunsch-Starttermin >%2< nicht mehr auf >%3< geändert werden!
            return on_error(FAILURE, "r0000624", rt000_fklz ## "^" ## rt000_fsterm_w_uhr_alt ## "^" ## rt000_fsterm_w_uhr_neu, rt000_prot)
        }
        else {
            // Bei einem angearbeiteten Fertigungsauftrag >%1< darf der Wunsch-Starttermin >%2< nicht mehr auf >%3< geändert werden. Der Wunsch-Starttermin wird auf den ursprünglichen Termin zurückgesetzt.
            call on_error(INFO, "r0000623", rt000_fklz ## "^" ## rt000_fsterm_w_uhr_alt ## "^" ## rt000_fsterm_w_uhr_neu, rt000_prot)
            rt000_fsterm_w_uhr_neu = rt000_fsterm_w_uhr_alt
        }
    }

    return OK
}

#--------------------------------------------------------------------
int proc rt000_init_terminierung_uhrzeitengenau(int aesP, cdtGq300 standortkalenderP, cdtRq000 cdtRq000P)
{
    int rcL


    // 1) kn_terminiert
    if (cod_aart_versorg(rt000_aart) == TRUE) {
        rt000_kn_terminiert_neu = KN_TERMINIERT_JA
    }
    else {
        rt000_kn_terminiert_neu = KN_TERMINIERT_NEIN
    }


    // 2) UEBZT_SEK
    rt000_uebzt_sek_neu = 0


    public rq000.bsl

    // 3) seterm in Abhängigkeit vom seterm_uhr setzen
    if (rt000_seterm_uhr_neu != NULL) {
        call rq000_set_seterm_uhr(cdtRq000P, rt000_seterm_uhr_neu)
        call rq000_set_aart(cdtRq000P, rt000_aart)
        call rq000_set_clear_message(cdtRq000P, TRUE)
        rcL = rq000_berechnen_seterm_aus_seterm_uhr(cdtRq000P)
        call rt000_protokoll_aus_rq000(cdtRq000P, rcL)
        if (rcL != OK) {
            return on_error(FAILURE)
        }
        rt000_seterm_neu = rq000_get_seterm(cdtRq000P)
    }
    else {
        rt000_seterm_neu = NULL
    }


    // 4) seterm_w in Abhängigkeit vom seterm_w_uhr setzen
    if (rt000_seterm_w_uhr_neu == NULL)  {
        rt000_seterm_w_uhr_neu = rt000_seterm_neu
        if (rt000_seterm_w_uhr_neu == NULL) {
            // Pflichtfeld >%s< nicht gefüllt!
            return on_error(FAILURE, "APPL0290", "seterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
        }
    }

    call rq000_set_seterm_w_uhr(cdtRq000P, rt000_seterm_w_uhr_neu)
    call rq000_set_aart(cdtRq000P, rt000_aart)
    call rq000_set_clear_message(cdtRq000P, TRUE)
    rcL = rq000_berechnen_seterm_w_aus_seterm_w_uhr(cdtRq000P)
    call rt000_protokoll_aus_rq000(cdtRq000P, rcL)
    if (rcL != OK) {
        return on_error(FAILURE)
    }
    rt000_seterm_w_neu = rq000_get_seterm_w(cdtRq000P)


    // 5) fsterm_w in Abhängigkeit vom fsterm_w_uhr setzen
    rt000_fsterm_neu = rt000_fsterm_uhr_neu
    if (rt000_fsterm_w_uhr_neu == NULL)  {
        rt000_fsterm_w_uhr_neu = rt000_fsterm_uhr_neu
        if (rt000_fsterm_w_uhr_neu == NULL)  {
            // Pflichtfeld >%s< nicht gefüllt!
            return on_error(FAILURE, "APPL0290", "fsterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
        }
    }
    rt000_fsterm_w_neu = rt000_fsterm_w_uhr_neu


    // 6) Fortsetztermin setzen
    rt000_fortsetz_dat_neu = rt000_fortsetz_uhr_neu

    return OK
}

/**
 * Diese Methode prüft alle Struktur-Termine auf eine gültige Arbeitszeit laut Standort-Kalender und ob sie gefüllt sind.
 *
 * Beim Starttermin wird der nächste gültige Zeitstempel "vorwärts" (in Richtung Zukunft) gesucht.
 * Beim Endtermin wird der nächste gültige Zeitstempel "rückwärts" (in Richtung Vergangenheit) gesucht.
 *
 * Ist der Starttermin aufgrund dieser Regel größer als der Endtermin,
 * so wird der Starttermin = Datum des Endtermins + Tagesstart gesetzt.
 *
 * @param [standortkalenderP]   Standortkalender als Instanz von {@code cdtGq300}
 * @return OK
 * @return WARNING              logischer Fehler
 * @return FAILURE              Fehler
 **/
//300254582 (Problem 1)
int proc rt000_pruefen_termine_struktur_gegen_arbeitszeit(cdtGq300 standortkalenderP)
{
    int  rcL
    cdt  cdtRq000L
    int  angearbeitetL          = fertig_check_fkfs_angearbeitet(rt000_fkfs, rt000_fkfs_a, rt000_fklz)
    int  terminierungsrelevantL = TRUE


    if (rt000_aes     == cAES_DELETE \
    ||  angearbeitetL == INFO) {
        return OK
    }

    // Prüfen auf "gefüllt":
    if (rt000_fsterm_w_uhr_neu == "") {
        // Pflichtfeld >%s< nicht gefüllt!
        return on_error(FAILURE, "APPL0290", "fsterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }

    if (rt000_seterm_w_uhr_neu == "") {
        // Pflichtfeld >%s< nicht gefüllt!
        return on_error(FAILURE, "APPL0290", "seterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }


    // 300290459:
    // Wenn keine terminierungsrelevante Änderung am FA, dann keine Prüfung der Strukturtermine.
    // Bei Neuanlage immer prüfen.
    if (rt000_aes == cAES_UPDATE) {
        terminierungsrelevantL = rt000_is_terminierungsrelevant(standortkalenderP)
    }
    switch (terminierungsrelevantL) {
        case TRUE:
        case FALSE:
            break
        case FAILURE:
        else:
            return FAILURE
    }

    if (terminierungsrelevantL == TRUE) {
        public rq000.bsl
        if (rt000_aes == cAES_INSERT) {
            cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, "", standortkalenderP)
        }
        else {
            cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)
        }

        call rq000_set_fklz(cdtRq000L, rt000_fklz)
        call rq000_set_fi_nr(cdtRq000L, FI_NR1)
        call rq000_set_fsterm_w_uhr(cdtRq000L, rt000_fsterm_w_uhr_neu)
        call rq000_set_seterm_w_uhr(cdtRq000L, rt000_seterm_w_uhr_neu)
        call rq000_set_fsterm_w(cdtRq000L, rt000_fsterm_w_neu)
        call rq000_set_seterm_w(cdtRq000L, rt000_seterm_w_neu)
        call rq000_set_termstr(cdtRq000L, rt000_termstr_neu)
        call rq000_set_termart(cdtRq000L, rt000_termart_neu)

        // Beim Insert müssen alle zu prüfenden übergeben werden da sie nicht im rq000_new gelesen werden konnten
        // (auch wenn sie nicht geändert wurden).
        if (rt000_aes == cAES_INSERT) {
            call rq000_set_fkfs(cdtRq000L, rt000_fkfs)
            call rq000_set_fkfs_a(cdtRq000L, rt000_fkfs_a)
            call rq000_set_aart(cdtRq000L, rt000_aart)
        }

        call rq000_set_richtung(cdtRq000L, NULL)
        call rq000_set_clear_message(cdtRq000L, TRUE)

        // 300345019
        switch (rt000_verw_art) {
            case "1":                   // Aufruf aus rt010d (Versorgung)
                call rq000_set_aufrufer(cdtRq000L, "rt010d")
                break
            case "3":                   // Aufruf aus Nettobedarfsrechnung
                // Im rq000 kann bei Aufruf über rh110/rv110 nicht unterschieden werden, ob die Herkunft
                // die Nettobedarfsrechnung (rm1004) ist oder die Bedarfsrechnung ist. Das geht nur hier
                // über die Varwaltungsart.
                call rq000_set_aufrufer(cdtRq000L, "rm1004")
                break
            case "5":                   // Aufruf aus rv0000
                call rq000_set_aufrufer(cdtRq000L, "rv0000")
                break
            case "6":                   // Aufruf aus dv250
                call rq000_set_aufrufer(cdtRq000L, "dv250")
                break
            else:
                break
        }

        call rq000_set_aes(cdtRq000L, rt000_aes)

        rcL = rq000_pruefen_strukturtermine_mit_uhrzeit(cdtRq000L)
        call rt000_protokoll_aus_rq000(cdtRq000L, rcL)
        if (rcL != OK) {
            return FAILURE
        }

        rt000_fsterm_w_uhr_neu = rq000_get_fsterm_w_uhr(cdtRq000L)
        rt000_fsterm_w_neu     = rq000_get_fsterm_w(cdtRq000L)
        rt000_seterm_w_uhr_neu = rq000_get_seterm_w_uhr(cdtRq000L)
        rt000_seterm_w_neu     = rq000_get_seterm_w(cdtRq000L)
    }

    return OK
}

/**
 * Diese Methode korrigiert den FSTERM_W_UHR auf den nächsten gültigen Termin in Richtung Zukunft.
 *
 * Geändert wird der Struktur-Starttermin, wenn er zuvor ungültig war (siehe {@code rt000_pruefen_termine_struktur_gegen_arbeitszeit}).
 *
 * @param arbeitstagP                   Ist FSTERM_UHR_W ein Arbeitstag (TRUE) oder nicht (FALSE oder INFO)
 * @param [standortkalenderP]           Standortkalender als Instanz von {@code cdtGq300}
 * @return OK
 *                                      [rt000_fsterm_w_uhr_neu]
 * @return WARNING                      Keine Korrektur des Termins erlaubt
 * @return FAILURE                      Fehler
 * @see                                 {@code rt000_korrektur_seterm_w_uhr}
 * @see                                 {@code gq300_ermitteln_naechsten_termin_vorwaerts}
 * @example                             {@code rt000_pruefen_termine_struktur_gegen_arbeitszeit}
 **/
int proc rt000_korrektur_fsterm_w_uhr(int arbeitstagP, cdtGq300 standortkalenderP)
{
    int       rcL
    date     datuhr_neuL
    cdtGq300 cdtGq300L


    // Laut Ticket 300277023 nur in re000 korrigieren der Termine erlaubt
    if (screen_name != "re000") {
        return WARNING
    }

    if (rt000_fsterm_w_uhr_neu == NULL) {
        return FAILURE
    }
    log LOG_DEBUG, LOGFILE, "rt000_fsterm_w_uhr_neu vorher >" ## rt000_fsterm_w_uhr_neu ## "<"

    cdtGq300L = rt000_ermitteln_standortkalender(standortkalenderP)

    public gq300.bsl
    call gq300_set_datuhr(cdtGq300L, rt000_fsterm_w_uhr_neu)
    call gq300_set_zeitspanne(cdtGq300L, 0)
    call gq300_set_zeitraum_merken(cdtGq300L, FALSE)
    call gq300_set_methode(cdtGq300L, BU_0)
    call gq300_set_kapaz_faktor(cdtGq300L, 1.0)
    call gq300_set_fldname(cdtGq300L, "fsterm_w_uhr")
    call gq300_set_clear_message(cdtGq300L, TRUE)
    if (arbeitstagP == TRUE) {
        call gq300_set_wieviel_tage(cdtGq300L, BU_0)
    }
    else {
        call gq300_set_wieviel_tage(cdtGq300L, BU_1)
    }

    // Es darf nicht "gq300_ermitteln_arbeitsbeginn_next" verwendet werden, da diese Methode immer auf den Vortag
    // wechselt und es darf auch nicht immer der Arbeitsbeginn des Tages sein!
    // Der errechnete Zeitstempel daf nur an einem anderen AT liegen, wenn er vor dem Arbeitsbeginn des aktuellen
    // Tages liegt.

    rcL = gq300_ermitteln_naechsten_termin_vorwaerts(cdtGq300L)
    call rt000_protokoll_aus_gq300(cdtGq300L, rcL)
    if (rcL != OK) {
        return on_error(FAILURE)
    }

    datuhr_neuL = gq300_get_datuhr_neu_date(cdtGq300L)
    if (defined(datuhr_neuL) != TRUE) {
        // Pflichtfeld >%s< nicht gefüllt!
        return on_error(FAILURE, "APPL0290", "fsterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }
    rt000_fsterm_w_uhr_neu = datuhr_neuL

    log LOG_DEBUG, LOGFILE, "rt000_fsterm_w_uhr_neu nachher >" ## rt000_fsterm_w_uhr_neu ## "<"
    return OK
}

/**
 * Diese Methode korrigiert den SETERM_W_UHR auf den nächsten gültigen Termin in Richtung Vergangenheit.
 *
 * Geändert wird der Struktur-Endtermin, wenn er zuvor ungültig war (siehe {@code rt000_pruefen_termine_struktur_gegen_arbeitszeit}).
 *
 * @param arbeitstagP                   Ist SETERM_UHR_W ein Arbeitstag (TRUE) oder nicht (FALSE oder INFO)
 * @param [standortkalenderP]           Standortkalender als Instanz von {@code cdtGq300}
 * @return OK
 *                                      [rt000_seterm_w_uhr_neu]
 * @return WARNING                      Keine Korrektur des Termins erlaubt
 * @return FAILURE                      Fehler
 * @see                                 {@code rt000_korrektur_fsterm_w_uhr}
 * @see                                 {@code gq300_ermitteln_naechsten_termin_rueckwaerts}
 * @example                             {@code rt000_pruefen_termine_struktur_gegen_arbeitszeit}
 **/
int proc rt000_korrektur_seterm_w_uhr(int arbeitstagP, cdtGq300 standortkalenderP)
{
    int      rcL
    date     datuhr_neuL
    cdtGq300 cdtGq300L


    // Laut Ticket 300277023 nur in re000 korrigieren der Termine erlaubt
    if (screen_name != "re000") {
        return WARNING
    }

    if (rt000_seterm_w_uhr_neu == NULL) {
        return FAILURE
    }
    log LOG_DEBUG, LOGFILE, "rt000_seterm_w_uhr_neu vorher >" ## rt000_seterm_w_uhr_neu ## "<"

    cdtGq300L = rt000_ermitteln_standortkalender(standortkalenderP)

    public gq300.bsl
    call gq300_set_datuhr(cdtGq300L, rt000_seterm_w_uhr_neu)
    call gq300_set_zeitspanne(cdtGq300L, 0)
    call gq300_set_zeitraum_merken(cdtGq300L, FALSE)
    call gq300_set_methode(cdtGq300L, BU_0)
    call gq300_set_kapaz_faktor(cdtGq300L, 1.0)
    call gq300_set_fldname(cdtGq300L, "seterm_w_uhr")
    call gq300_set_clear_message(cdtGq300L, TRUE)
    if (arbeitstagP == TRUE) {
        call gq300_set_wieviel_tage(cdtGq300L, BU_0)
    }
    else {
        call gq300_set_wieviel_tage(cdtGq300L, BU_1)
    }

    // Es darf nicht "gq300_ermitteln_arbeitsende_prev" verwendet werden, da diese Methode immer auf den Vortag
    // wechselt und es darf auch nicht immer das Arbeitsende des Tages sein!
    // Der errechnete Zeitstempel daf nur an einem anderen AT liegen, wenn er hinter dem Arbeitsende des aktuellen
    // Tages liegt.

    rcL = gq300_ermitteln_naechsten_termin_rueckwaerts(cdtGq300L)
    call rt000_protokoll_aus_gq300(cdtGq300L, rcL)
    if (rcL != OK) {
        return on_error(FAILURE)
    }

    datuhr_neuL = gq300_get_datuhr_neu_date(cdtGq300L)
    if (defined(datuhr_neuL) != TRUE) {
        // Pflichtfeld >%s< nicht gefüllt!
        return on_error(FAILURE, "APPL0290", "seterm_w_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }

    rt000_seterm_w_uhr_neu = datuhr_neuL

    log LOG_DEBUG, LOGFILE, "rt000_seterm_w_uhr_neu nachher >" ## rt000_seterm_w_uhr_neu ## "<"
    return OK
}

/**
 * Diese Methode prüft alle Baukasten-Termine auf eine gültige Arbeitszeit laut Standort-Kalender
 *
 * Es wird auch geprüft, ob sie überhaupt gefüllt sind.
 * Im re000 werden keine Baukastentermine geprüft, da dort keine Uhrzeiten erfasst werden können.
 *
 * Folgende Felder werden benötigt:
 * - rt000_fsterm_uhr_neu
 * - rt000_fsterm_uhr_alt
 * - rt000_seterm_uhr_neu
 * - rt000_seterm_uhr_alt
 * - rt000_fortsetz_uhr_neu
 * - rt000_fortsetz_uhr_alt
 * - rt000_termart_neu
 * - rt000_aes
 * - rt000_aart
 * - rt000_verw_art
 * - rt000_tkz
 * - rt000_mkz
 * - rt000_fklz
 * - rt000_fkfs
 * - rt000_fkfs_a
 * - rt000_fsterm_w_uhr_neu
 * - rt000_seterm_w_uhr_neu
 *
 * @param [fu_bedr_extP]            Funktionscode der Bedarfsrechnung, der von extern übergeben wurde
 * @param [standortkalenderP]       Standortkalender
 * @return OK
 *                                  rt000_fsterm_uhr_neu
 *                                  rt000_seterm_uhr_neu
 * @return WARNING                  logischer Fehler
 * @return FAILURE                  Fehler
 * @see                             {@code rt010_pruefen_starttemin_gegen_endtermin}
 * @example
 **/
//300254582 (Problem 1)
int proc rt000_pruefen_termine_bauk_gegen_arbeitszeit(string fu_bedr_extP, cdtGq300 standortkalenderP)
{
    int      rcL
    cdtGq300 gq300L
    cdtRq000 rq000L
    string   einl_richtungL
    int      arbeitsbeginnL
    int      arbeitsendeL
    int      angearbeitetL
    int      uhrzeit_pruefenL       = $NULL
    int      terminierungsrelevantL = TRUE
    date     fortsetzterminL
    boolean  pruefen_arbeitsbeginn_endeL
    boolean  pruefung_durchfuehrenL
    boolean  pruefen_kalenderendeL
    boolean  kalendergrenze_erreichtL       // @bsldoc.ignore


    log LOG_DEBUG, LOGFILE, "rt000_fsterm_uhr_neu >" ## rt000_fsterm_uhr_neu ## "< / " \
                         ## "rt000_fsterm_uhr_alt >" ## rt000_fsterm_uhr_alt ## "< / " \
                         ## "rt000_fortsetz_uhr_neu >" ## rt000_fortsetz_uhr_neu ## "< / " \
                         ## "rt000_fortsetz_uhr_alt >" ## rt000_fortsetz_uhr_alt ## "< / " \
                         ## "rt000_seterm_uhr_neu >" ## rt000_seterm_uhr_neu ## "< / " \
                         ## "rt000_seterm_uhr_alt >" ## rt000_seterm_uhr_alt ## "< / " \
                         ## "rt000_aes >" ## rt000_aes ## "<"


    // Bei zu löschenden werden die Termine nicht mehr geprüft oder geändert.
    if (rt000_aes == cAES_DELETE) {
        return OK
    }


    // FA-Status ermitteln
    fortsetzterminL = $NULL
    angearbeitetL   = fertig_check_fkfs_angearbeitet(rt000_fkfs, rt000_fkfs_a, rt000_fklz)
    switch (angearbeitetL) {
        case FALSE:
            break
        case TRUE:
            // Bei angearbeiteten FA wird der Fortsetztermin nur geprüft, wenn der gefüllt ist
            if (rt000_fortsetz_uhr_neu != "") {
                fortsetzterminL = rt000_fortsetz_uhr_neu
            }
            break
        case INFO:
            // Bei fertigen FA werden die Termine nicht mehr geprüft oder geändert.
            return OK
        else:
            log LOG_DEBUG, LOGFILE, "Fehler fertig_check_fkfs_angearbeitet rc=" ## angearbeitetL
            return on_error(FAILURE)
    }


    // 1) Prüfen auf "gefüllt" von Start- und Endtermin:
    if (rt000_fsterm_uhr_neu == "") {
        // Pflichtfeld >%s< nicht gefüllt
        return on_error(FAILURE, "APPL0290", "fsterm_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }
    if (rt000_seterm_uhr_neu == "") {
        // Pflichtfeld >%s< nicht gefüllt
        return on_error(FAILURE, "APPL0290", "seterm_uhr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }


    // 2) Beim Auslösen einer Strukturterminierung (tkz = 0) müssen die Termine immer auf die Wunschtermine gesetzt werden.
    // Beim Aufruf aus Nettobedarfsrechnung darf das nicht gemacht werden.
    // Das Ändern der Termine darf bei Sekundäraufträgen nicht passieren (z.B. beim Tausch).
    if (rt000_tkz                  == cTKZ_STRUKTUR \
    &&  rt000_verw_art             != "3" \
    &&  rt000_verw_art             != "6" \
    &&  angearbeitetL              == FALSE \
    &&  cod_aart_nosek(rt000_aart) == TRUE \
    &&  (rt000_aes                 == cAES_INSERT || rt000_aes == cAES_UPDATE || rt000_aes == cAES_REKONFIG)) {
        if (rt000_fsterm_w_uhr_neu != "") {
            log LOG_DEBUG, LOGFILE, "Bei Strukturterminierung wird fsterm_uhr = fsterm_w_uhr gesetzt."
            rt000_fsterm_uhr_neu = rt000_fsterm_w_uhr_neu
        }

        if (rt000_seterm_w_uhr_neu != "") {
            log LOG_DEBUG, LOGFILE, "Bei Strukturterminierung wird seterm_uhr = seterm_w_uhr gesetzt."
            rt000_seterm_uhr_neu = rt000_seterm_w_uhr_neu
        }
    }

    gq300L = rt000_ermitteln_standortkalender(standortkalenderP)

    // Laden Module
    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)

    public gq300.bsl


    // 3) Definition der Terminierungsrichtung anhand der Terminierungsart
    einl_richtungL = ""
    if (rt000_tkz != cTKZ_KEINE) {
        // Ermitteln der Richtung anhand der Termart und fu_bedr
        call rq000_set_termart(rq000L, rt000_termart_neu)
        einl_richtungL = rq000_richtung_aus_termart(rq000L, fu_bedr_extP)
        switch (einl_richtungL) {
            case EINL_RICHTUNG_RUECKW:
            case EINL_RICHTUNG_VORW:
            case cTERMART_KRITISCH:
            case "":
                break
            else:
                log LOG_DEBUG, LOGFILE, "Fehler rq000_richtung_aus_termart rc=" ## einl_richtungL
                return on_error(FAILURE)
        }
    }
    log LOG_DEBUG, LOGFILE, "einl_richtung >" ## einl_richtungL ## "< / rt000_tkz >" ## rt000_tkz ## "<"


    // 4) Prüfung Endtermin < Starttermin
    if (rt000_tkz != cTKZ_KEINE) {
        // Ein Termin hat sich geändert:

        // Bei TERMART 2 und 3 ist das ein Fehler;
        // Bei TERMART 1 und 0 wird der jeweilige Termin korrigiert.

        // Ist neuer Endtermin jetzt vor Starttermin bzw. umgekehrt?
        if (angearbeitetL == TRUE) {
            // Bei angearbeitetem FA mit Fortsetztermin, der vor hinter dem Endtermin liegt:
            if (defined(fortsetzterminL)    == TRUE \
            &&  @time(rt000_seterm_uhr_neu) <  @time(fortsetzterminL)) {
                if (rt000_termart_neu == cTERMART_RUECKW) {
                    rt000_fortsetz_uhr_neu = rt000_seterm_uhr_neu
                }
                else if (rt000_termart_neu == cTERMART_VORW) {
                    rt000_seterm_uhr_neu = fortsetzterminL
                }
                else {  // Kritischer Pfad, Mittelpunkt oder nichts (NULL)
                    // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
                    return on_error(WARNING, "r0000129", rt000_seterm_uhr_neu ## "^" ## @format_date(fortsetzterminL, DATEFORMAT1), rt000_prot)
                }

                // 300276038:
                // Prüfen/Setzen der korrekten Uhrzeit im oben geänderten Feld
                uhrzeit_pruefenL = BU_2
            }
        }
        else {
            // bei offenen FA, wenn Starttermin hinter Endtermin liegt:
            if (@time(rt000_seterm_uhr_neu) < @time(rt000_fsterm_uhr_neu)) {
                if (rt000_termart_neu == cTERMART_RUECKW) {
                    if (@date(rt000_seterm_neu) < @date(rt000_fsterm_neu)) {
                        rt000_fsterm_neu = rt000_seterm_neu

                        call gq300_set_datum(gq300L, rt000_fsterm_neu)
                        call gq300_set_clear_message(gq300L, TRUE)
                        rcL = gq300_ermitteln_arbeitsbeginn(gq300L, TRUE)
                        call rt000_protokoll_aus_gq300(gq300L, rcL)
                        if (rcL != OK) {
                            return on_error(FAILURE)
                        }
                        rt000_fsterm_uhr_neu = gq300_get_datuhr_neu(gq300L)
                    }
                    else {
                        rt000_fsterm_uhr_neu = rt000_seterm_uhr_neu
                    }
                }
                else if (rt000_termart_neu == cTERMART_VORW) {
                    if (@date(rt000_seterm_neu) < @date(rt000_fsterm_neu)) {
                        rt000_seterm_neu = rt000_fsterm_neu

                        call gq300_set_datum(gq300L, rt000_seterm_neu)
                        call gq300_set_clear_message(gq300L, TRUE)
                        rcL = gq300_ermitteln_arbeitsende(gq300L, TRUE)
                        call rt000_protokoll_aus_gq300(gq300L, rcL)
                        if (rcL != OK) {
                            return on_error(FAILURE)
                        }
                        rt000_seterm_uhr_neu = gq300_get_datuhr_neu(gq300L)
                    }
                    else {
                        rt000_seterm_uhr_neu = rt000_fsterm_uhr_neu
                    }
                }
                else {  // Kritischer Pfad, Mittelpunkt oder nichts (NULL)
                    // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
                    return on_error(WARNING, "r0000129", rt000_seterm_uhr_neu ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
                }

                // 300276038:
                // Prüfen/Setzen der korrekten Uhrzeit im oben geänderten Feld
                uhrzeit_pruefenL = BU_2
            }
        }
    }


    // 5) Wenn der Starttermin ein Arbeitsende (Rückwärtsterminierung) oder der Endtermin ein Starttermin
    //    (Vorwärtsterminierung) ist, muss geprüft werden:
    //    Rückwärtsterminierung und Starttermin = Arbeitsende
    //    bzw.
    //    Vorwärtsterminierung und Endtermin = Arbeitsbeginn
    //    Fall 1 (300276269):
    //    Bei einer Mengenänderung im rv0000
    //    Fall 2 (300359866):
    //    Bei Aufruf aus fv010, wenn die DLZ = 0 bzw. Starttermin = Endtermin
    //    300353375:
    //    Bei angearbeitete FA wird bei Änderung Endtermin (d.h. Rückwärtsterminierung) der Fortsetztermin immer
    //    platt gemacht. In diesem Fall darf auch keine Prüfung gemacht werden.
    pruefen_arbeitsbeginn_endeL = FALSE
    switch (screen_name) {
        case "rv0000":  // 300276269
            if (einl_richtungL == EINL_RICHTUNG_VORW) {
                if (rt000_mkz == MKZ_JA) {
                    log LOG_DEBUG, LOGFILE, "Aufruf aus rv0000 mit Richtung >vorwärts< und Mengenänderung<"
                    pruefen_arbeitsbeginn_endeL = TRUE
                }
            }
            else if (einl_richtungL == EINL_RICHTUNG_RUECKW) {
                if (angearbeitetL == TRUE) {
                    if (rt000_mkz                == MKZ_JA \
                    &&  defined(fortsetzterminL) == TRUE) {
                    log LOG_DEBUG, LOGFILE, "Aufruf aus rv0000 mit Richtung >rückwärts< und Mengenänderung und Fortsetztermin<"
                        pruefen_arbeitsbeginn_endeL = TRUE
                    }
                }
                else {
                    if (rt000_mkz == MKZ_JA) {
                    log LOG_DEBUG, LOGFILE, "Aufruf aus rv0000 mit Richtung >rückwärts< und Mengenänderung<"
                        pruefen_arbeitsbeginn_endeL = TRUE
                    }
                }
            }
            break
        case "fv010":   // 300359866
            if (angearbeitetL == TRUE) {
                if (defined(fortsetzterminL) == TRUE \
                &&  @time(fortsetzterminL)   == @time(rt000_seterm_uhr_neu)) {
                    log LOG_DEBUG, LOGFILE, "Aufruf aus fv010 mit Richtung >" ## einl_richtungL ## "< und Fortsetztermin = Endtermin"
                    pruefen_arbeitsbeginn_endeL = TRUE
                }
            }
            else {
                if (@time(rt000_fsterm_uhr_neu) == @time(rt000_seterm_uhr_neu)) {
                    log LOG_DEBUG, LOGFILE, "Aufruf aus fv010 mit Richtung >" ## einl_richtungL ## "< und Startttermin = Endtermin"
                    pruefen_arbeitsbeginn_endeL = TRUE
                }
            }
            break
        else:
            break
    }

    log LOG_DEBUG, LOGFILE, "pruefen_arbeitsbeginn_ende >" ## pruefen_arbeitsbeginn_endeL ## "<"
    if (pruefen_arbeitsbeginn_endeL == TRUE) {
        switch (einl_richtungL) {
            case EINL_RICHTUNG_RUECKW:
                if (defined(fortsetzterminL) == TRUE) {
                    call gq300_set_datuhr_date(gq300L, fortsetzterminL)
                }
                else {
                    call gq300_set_datuhr(gq300L, rt000_fsterm_uhr_neu)
                }
                call gq300_set_clear_message(gq300L, TRUE)
                call gq300_set_ohne_vortag(gq300L, TRUE)

                arbeitsendeL = gq300_is_arbeitsende(gq300L, FALSE)
                switch (arbeitsendeL) {
                    case TRUE:
                        log LOG_DEBUG, LOGFILE, "Rückwärtsterminierung und Starttermin ist Arbeitsende"
                        uhrzeit_pruefenL = BU_3
                        call rt000_protokoll_aus_gq300(gq300L, OK)
                        break
                    case FALSE:
                    case INFO:
                        call rt000_protokoll_aus_gq300(gq300L, OK)
                        break
                    else:
                        call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                        return FAILURE
                }
                break
            case EINL_RICHTUNG_VORW:
                call gq300_set_datuhr(gq300L, rt000_seterm_uhr_neu)
                call gq300_set_clear_message(gq300L, TRUE)

                arbeitsbeginnL = gq300_is_arbeitsbeginn(gq300L, FALSE)
                switch (arbeitsbeginnL) {
                    case TRUE:
                        log LOG_DEBUG, LOGFILE, "Vorwärtsterminierung und Endtermin ist Arbeitsbeginn"
                        uhrzeit_pruefenL = BU_3
                        call rt000_protokoll_aus_gq300(gq300L, OK)
                        break
                    case FALSE:
                    case INFO:
                        call rt000_protokoll_aus_gq300(gq300L, OK)
                        break
                    else:
                        call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                        return FAILURE
                }
                break
            case cTERMART_KRITISCH: // Kritischer Pfad
            case NULL:              // nichts tun / kein tkz
                break
            else:
                return FAILURE
        }
    }


    // 6) Prüfen auf Arbeitszeit oder Setzen der Arbeitszeit abhängig von der Terminierungsrichtung
    pruefen_kalenderendeL = FALSE
    if ( \
        rt000_fu_bedr == cFUBEDR_TAUSCH || \
        cdtTermGlobal_is_sammelaenderung_fa($NULL) == TRUE \
    ) {
        // 300270631 + 300406497: Bei übergebenem fu_bedr = 4 (Tausch) keine Prüfung auf Uhrzeit
        // 300277023: Im re000 generell keine Prüfung auf Uhrzeiten, da sie dort nicht vom Anwender
        //            geändert werden können (sie wird dort immer automatisch gesetzt).
        //            Die Baukastentermine müssen dort korrekt übergeben werden (besonders wenn tkz != 0)!
        //            Bei 5. werden bei Strukturterminierung die Baukastentermine an die Strukturtermine angeglichen.
        log LOG_DEBUG, LOGFILE, "Im re000 werden keine Uhrzeiten verwaltete -> keine Uhrzeiten prüfen"
        uhrzeit_pruefenL      = BU_0
        pruefen_kalenderendeL = TRUE
    }
    else if (uhrzeit_pruefenL == BU_2) {
        log LOG_DEBUG, LOGFILE, "Start- und Endtermin waren identisch"
    }
    else if (uhrzeit_pruefenL == BU_3) {
        log LOG_DEBUG, LOGFILE, "Setzen korrespondierendes Terminfeld aus Richtung >" ## einl_richtungL ## "<"
    }
    else if (cod_aart_versorg(rt000_aart) == TRUE) {
        log LOG_DEBUG, LOGFILE, "Versorgungsauftrag -> keine Uhrzeiten prüfen"
        uhrzeit_pruefenL = BU_0
    }
    else {
        switch (rt000_verw_art) {
            case "1":   // Aufruf aus rt010d
            case "2":   // Aufruf aus dh204
            case "6":   // Aufruf aus dv250
                log LOG_DEBUG, LOGFILE, "Versorgungsauftrag/Dispo -> keine Uhrzeiten prüfen"
                uhrzeit_pruefenL = BU_0
                break
            else:       // z.B. Aufruf aus rv0000
                log LOG_DEBUG, LOGFILE, "Sonstiger FA -> Uhrzeiten prüfen"

                //300290459:
                // Prüfen, ob eine Terminierungsrelevante Änderung vorliegt.
                // Wenn nein, dann keine Prüfung der Termine.
                terminierungsrelevantL = TRUE
                if (rt000_aes == cAES_UPDATE) {
                    terminierungsrelevantL = rt000_is_terminierungsrelevant(standortkalenderP)
                }
                switch (terminierungsrelevantL) {
                    case TRUE:
                        // 300308531:
                        // Beim Anstoss einer Strukturterminierung eines angearbeiteten FA mit Fortsetztermin
                        // kann der Starttermin und Fortsetztermin nicht mehr geändert werden (z.B. im rv0000).
                        // Dann muss der Fortsetztermin nicht geprüft werden. Er wird hier später platt gemacht
                        // und in der Terminierung neu berechnet.
                        // 300317194:
                        // Bei einem nicht vorhanden Fortsetztermin darf auch der Starttermin des angearbeiteten FA
                        // bei einer Strukturterminierung nicht validiert werden. Er kann ebenfalls nicht mehr
                        // geändert werden.
                        if (rt000_tkz     == cTKZ_STRUKTUR \
                        &&  angearbeitetL == TRUE) {
                            uhrzeit_pruefenL = BU_0
                        }
                        else {
                            uhrzeit_pruefenL = BU_1
                        }
                        break
                    case FALSE:
                        uhrzeit_pruefenL = BU_0
                        break
                    case FAILURE:
                    else:
                        return FAILURE
                }

                pruefen_kalenderendeL = TRUE
                break
        }
    }


    // 300364183:
    // Der Start- oder Endtermintermin darf jeweils nicht auf dem letzten Kalendertag liegen, da sonst der SETERM
    // nicht berechnet werden kann.
    if (pruefen_kalenderendeL == TRUE) {
        rcL = rt000_pruefen_starttermin_auf_kalenderende(standortkalenderP)
        if (rcL != OK) {
            return FAILURE
        }
        rcL = rt000_pruefen_endtermin_auf_kalenderende(standortkalenderP)
        if (rcL != OK) {
            return FAILURE
        }
    }


    // 7) Prüfung oder Setzen
    log LOG_DEBUG, LOGFILE, "uhrzeit_pruefen >" ## uhrzeit_pruefenL ## "<"
    switch (uhrzeit_pruefenL) {
        case BU_1:      // Nur prüfen der Termine
            // 7a) Prüfen, ob Starttermin ein Arbeitstag im Standortkalender ist
            //     300353375:
            //     Bei angearbeiteten FA keine Prüfung auf Startttermin, wenn kein Fortsetztermin vorhanden.
            pruefung_durchfuehrenL = FALSE
            if (angearbeitetL == TRUE) {
                if (defined(fortsetzterminL) == TRUE) {
                    call gq300_set_datuhr_date(gq300L, fortsetzterminL)
                    pruefung_durchfuehrenL = TRUE
                }
            }
            else {
                call gq300_set_datuhr(gq300L, rt000_fsterm_uhr_neu)
                pruefung_durchfuehrenL = TRUE
            }

            if (pruefung_durchfuehrenL == TRUE) {
                call gq300_set_clear_message(gq300L, TRUE)
                rcL = gq300_is_arbeitszeit(gq300L, FALSE, BU_1)
                kalendergrenze_erreichtL = gq300_get_kalendergrenze_erreicht(gq300L)
                switch (rcL) {
                    case TRUE:
                        call rt000_protokoll_aus_gq300(gq300L, OK)
                        break
                    case FALSE:
                    case INFO:
                        call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                        return on_error(FAILURE)
                    else:
                        call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                        // Fehlerhafter Aufruf der Funktion  %s !
                        return on_error(FAILURE, "APPL0586", "gq300_is_arbeitszeit", rt000_prot)
                }
            }


            // 7b) Prüfen, ob Endtermin ein Arbeitstag im Standortkalender ist
            call gq300_set_datuhr(gq300L, rt000_seterm_uhr_neu)
            call gq300_set_clear_message(gq300L, TRUE)
            rcL = gq300_is_arbeitszeit(gq300L, TRUE, BU_1)
            kalendergrenze_erreichtL = gq300_get_kalendergrenze_erreicht(gq300L)
            switch (rcL) {
                case TRUE:
                    call rt000_protokoll_aus_gq300(gq300L, OK)
                    break
                case FALSE:
                case INFO:
                    call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                    return on_error(FAILURE)
                else:
                    call rt000_protokoll_aus_gq300(gq300L, FAILURE)
                    // Fehlerhafter Aufruf der Funktion %s !
                    return on_error(FAILURE, "APPL0586", "gq300_is_arbeitszeit", rt000_prot)
            }
            break
        case BU_2:      // Start- und Endtermin waren identisch
            call rq000_set_fklz(rq000L, rt000_fklz)
            call rq000_set_fsterm_uhr(rq000L, rt000_fsterm_uhr_neu)
            call rq000_set_fortsetz_uhr_date(rq000L, fortsetzterminL)
            call rq000_set_seterm_uhr(rq000L, rt000_seterm_uhr_neu)
            call rq000_set_fsterm(rq000L, rt000_fsterm_neu)
            call rq000_set_fortsetz_dat(rq000L, rt000_fortsetz_dat_neu)
            call rq000_set_seterm(rq000L, rt000_seterm_neu)
            call rq000_set_clear_message(rq000L, TRUE)
            call rq000_set_richtung(rq000L, einl_richtungL)
            //TODO: rt000_aes übergeben?

            rcL = rq000_pruefen_starttermin_gegen_endtermin(rq000L, FALSE)
            call rt000_protokoll_aus_rq000(rq000L, rcL)
            switch (rcL) {
                case OK:        // Änderung Start- oder Endtermin notwendig
                    if (einl_richtungL == EINL_RICHTUNG_RUECKW) {
                        if (angearbeitetL == TRUE) {
                            rt000_fortsetz_uhr_neu = rq000_get_fortsetz_uhr(rq000L)
                        }
                        else {
                            rt000_fsterm_uhr_neu = rq000_get_fsterm_uhr(rq000L)
                        }
                    }
                    else if (einl_richtungL == EINL_RICHTUNG_VORW) {
                        rt000_seterm_uhr_neu = rq000_get_seterm_uhr(rq000L)
                    }
                    else {
                        return FAILURE
                    }
                    break
                case INFO:      // Keine Änderung notwendig
                    break
                else:
                    return on_error(FAILURE)
            }
            break
        case BU_3:      // Setzen der anderen Uhrzeit abhängig von der Terminierungsrichtung
            call rq000_set_fklz(rq000L, rt000_fklz)
            call rq000_set_fsterm_uhr(rq000L, rt000_fsterm_uhr_neu)
            call rq000_set_fortsetz_uhr_date(rq000L, fortsetzterminL)
            call rq000_set_seterm_uhr(rq000L, rt000_seterm_uhr_neu)
            call rq000_set_fsterm(rq000L, rt000_fsterm_neu)
            call rq000_set_fortsetz_dat(rq000L, rt000_fortsetz_dat_neu)
            call rq000_set_seterm(rq000L, rt000_seterm_neu)
            call rq000_set_clear_message(rq000L, TRUE)
            //TODO: rt000_aes übergeben?

            switch (einl_richtungL) {
                case EINL_RICHTUNG_RUECKW:
                    rcL = rq000_pruefen_starttermin_gegen_arbeitsende(rq000L)
                    break
                case EINL_RICHTUNG_VORW:
                    rcL = rq000_pruefen_endtermin_gegen_arbeitsbeginn(rq000L)
                    break
                case cTERMART_KRITISCH: // Kritischer Pfad
                case NULL:              // nichts tun / kein tkz
                    rcL = INFO
                    break
                else:
                    return FAILURE
            }
            call rt000_protokoll_aus_rq000(rq000L, rcL)
            switch (rcL) {
                case OK:        // Änderung Start- oder Endtermin notwendig
                    if (einl_richtungL == EINL_RICHTUNG_RUECKW) {
                        if (angearbeitetL == TRUE) {
                            rt000_fortsetz_uhr_neu = rq000_get_fortsetz_uhr(rq000L)
                        }
                        else {
                            rt000_fsterm_uhr_neu = rq000_get_fsterm_uhr(rq000L)
                        }
                    }
                    else if (einl_richtungL == EINL_RICHTUNG_VORW) {
                        rt000_seterm_uhr_neu = rq000_get_seterm_uhr(rq000L)
                    }
                    else {
                        return FAILURE
                    }
                    break
                case INFO:      // Keine Änderung notwendig
                    break
                else:
                    return on_error(FAILURE)
            }
            break
        case BU_0:     // weder Prüfen noch Setzen der Uhrzeit
        case $NULL:
        else:
            break
    }


    // 8) Erneute Prüfung auf Start- gegen Endtermin
    if (angearbeitetL == TRUE) {
        if (rt000_fortsetz_uhr_neu      != "" \
        &&  @time(rt000_seterm_uhr_neu) <  @time(rt000_fortsetz_uhr_neu)) {
            // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
            return on_error(FAILURE, "r0000129", rt000_seterm_uhr_neu ## "^" ## rt000_fortsetz_uhr_neu, rt000_prot)
        }
    }
    else {
        if (@time(rt000_seterm_uhr_neu) < @time(rt000_fsterm_uhr_neu)) {
            // Endtermin >%1< darf nicht vor Starttermin >%2< liegen!
            return on_error(FAILURE, "r0000129", rt000_seterm_uhr_neu ## "^" ## rt000_fsterm_uhr_neu, rt000_prot)
        }
    }

    log LOG_DEBUG, LOGFILE, "fsterm_uhr_neu >" ## rt000_fsterm_uhr_neu ## "< / " \
                         ## "fortsetz_uhr_neu >" ## rt000_fortsetz_uhr_neu ## "< / " \
                         ## "seterm_uhr_neu >" ## rt000_seterm_uhr_neu ## "<"
    return OK
}

/**
 * Diese Methode prüft alle Baukasten-Termine auf eine gültige Arbeitszeit laut Standort-Kalender und
 * ob sie überhaupt gefüllt sind
 *
 * @param rt000_termart_neu
 * @param rt000_termstr_neu
 * @param rt000_aes
 * @param rt000_aart
 * @param rt000_tkz
 * @param rt000_mkz
 * @param rt000_fsterm_w_uhr_neu
 * @param rt000_seterm_w_uhr_neu
 * @param rt000_fsterm_w_uhr_alt
 * @param rt000_seterm_w_uhr_alt
 * @param rt000_kz_fix_neu
 * @param R_KZ_TERM
 * @return rt000_termart_neu
 * @return OK
 * @return FAILURE              Fehler
 * @see                         {@code rv0000_fsterm_w_uhr_fv}
 * @see                         {@code rv0000_seterm_w_uhr_fv}
 * @see                         {@code rv0000_seterm_w_fv}
 * @see                         {@code rv0000_seterm_fv}
 * @example
 **/
//300254582
int proc rt000_pruefen_terminierungsart()
{
    boolean setzen_termartL

    if (rt000_aes == cAES_DELETE) {
        return OK
    }

    // 1) Prüfen termstr:

    if (rt000_termstr_neu == NULL) {
        // Pflichtfeld >%s< nicht gefüllt!
        return on_error(FAILURE, "APPL0290", "termstr", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
    }

    if (R_KZ_TERM         == "S" \
    &&  rt000_termstr_neu != cTERMSTR_RUECKW) {
        // Bei Terminierung über die Vorlaufzeit der Stückliste (R_KZ_TERM = S) darf die Terminierungsart der Struktur >%1< für Fertigungsauftrag >%2< nur "rückwärts" sein!
        return on_error(FAILURE, "TERM0030", rt000_termstr_neu ## "^" ## rt000_fklz, rt000_prot)
    }
    log LOG_DEBUG, LOGFILE, "termstr >" ## rt000_termstr_neu ## "<"


    // 2) Prüfen termart:

    // 300221806: Bei Neuanlage eines Primärauftrages aus Vertrieb muss immer eine Rückwärtsterminierung
    // abgestellt werden.
    if ((rt000_aes  == cAES_INSERT || rt000_aes == cAES_REKONFIG) \
    &&   rt000_aart == "1" \
    &&   rt000_tkz  == cTKZ_STRUKTUR) {
        // 300247960;
        // Beim Kritischen Pfad darf keine TERMART = 0 eingestellt sein.
        if (rt000_termstr_neu == cTERMSTR_KRITISCH) {
            rt000_termart_neu = cTERMART_KRITISCH
        }
        else {
            rt000_termart_neu = cTERMART_RUECKW
        }
        log LOG_DEBUG, LOGFILE, "termart >" ## rt000_termart_neu ## "< ( mit aart = 1)"
    }
    else {
        if (rt000_termart_neu == NULL) {
            // Pflichtfeld >%s< nicht gefüllt!
            return on_error(FAILURE, "APPL0290", "termart", rt000_prot, $NULL, $NULL, PRT_CTRL_FEHLER)
        }

        // vgl. rq000i_pruefen_R_KZ_TERM
        if (R_KZ_TERM         == "S" \
        &&  rt000_termart_neu != cTERMART_RUECKW) {
            // Bei Terminierung über die Vorlaufzeit der Stückliste (R_KZ_TERM = S) darf ein Fertigungsauftrag >%1< nur rückwärts terminiert werden!
            return on_error(FAILURE, "TERM0029", rt000_fklz, rt000_prot)
        }

        // 3) Prüfung auf geänderte Strukturtermine und setzen der termart
        // 300254582 (Problem 2)
        if (cod_aart_versorg(rt000_aart) == TRUE) {
            setzen_termartL = FALSE
        }
        else if (cod_aart_primaer(rt000_aart) == TRUE) {
            setzen_termartL = TRUE
        }
        else {
            setzen_termartL = FALSE
        }
        log LOG_DEBUG, LOGFILE, "setzen_termart >" ## setzen_termartL ## "<"

        if (setzen_termartL == TRUE \
        &&  rt000_aes       == cAES_UPDATE \
        &&  rt000_tkz       == cTKZ_STRUKTUR) {
            // Bei einer Strukturterminierung, d.h. wenn sich einer der Struktur-Termine geändert hat, muss ggf. die
            // Terminierungsart gesetzt werden
            if (@time(rt000_fsterm_w_uhr_neu) != @time(rt000_fsterm_w_uhr_alt) \
            &&  @time(rt000_seterm_w_uhr_neu) == @time(rt000_seterm_w_uhr_alt)) {
                // Fall 1: nur der Struktur-Starttermin hat sich geändert
                // 300247960;
                // Beim Kritischen Pfad darf keine TERMART = 0 eingestellt sein.
                if (rt000_termstr_neu == cTERMSTR_KRITISCH) {
                    log LOG_DEBUG, LOGFILE, "Struktur-Endtermin wurde geändert -> Kritischer Pfad"
                    rt000_termart_neu = cTERMART_KRITISCH
                }
                else {
                    log LOG_DEBUG, LOGFILE, "Struktur-Starttermin wurde geändert -> Vorwärtsterminierung"
                    rt000_termart_neu = cTERMART_VORW
                }
            }
            else if (@time(rt000_fsterm_w_uhr_neu) == @time(rt000_fsterm_w_uhr_alt) \
            &&       @time(rt000_seterm_w_uhr_neu) != @time(rt000_seterm_w_uhr_alt)) {
                // Fall 2: nur der Struktur-Endtermin hat sich geändert
                // 300247960;
                // Beim Kritischen Pfad darf keine TERMART = 1 eingestellt sein.
                if (rt000_termstr_neu == cTERMSTR_KRITISCH) {
                    log LOG_DEBUG, LOGFILE, "Struktur-Endtermin wurde geändert -> Kritischer Pfad"
                    rt000_termart_neu = cTERMART_KRITISCH
                }
                else {
                    log LOG_DEBUG, LOGFILE, "Struktur-Endtermin wurde geändert -> Rückwärtsterminierung"
                    rt000_termart_neu = cTERMART_RUECKW
                }
            }
            else if (@time(rt000_fsterm_w_uhr_neu) != @time(rt000_fsterm_w_uhr_alt) \
            &&       @time(rt000_seterm_w_uhr_neu) != @time(rt000_seterm_w_uhr_alt)) {
                // Fall 3: beide Strukturtermine haben sich geändert -> termart beibehalten
                log LOG_DEBUG, LOGFILE, "Beide Strukturtermine wurden geändert -> Termart auf Termstr setzen"
                rt000_termart_neu = rt000_termstr_neu
            }
            else {
                // Fall 4: kein der Strukturtermin hat sich geändert -> termart beibehalten
                log LOG_DEBUG, LOGFILE, "Kein Strukturtermin wurde geändert -> Übergebene Termart beibehalten"
            }
        }
        else {      // Baukastenterminierung oder Neuanlage oder Löschung
            // Hinweis: Die Baukastentermine wurden schon in Funktion "rt000_pruefen_termine_bauk_gegen_arbeitszeit" mit
            //          den Strukturterminen abgeglichen!
        }
    }


    // 300276094:
    // 4) Meldung, wenn Mengenänderung und User-Fixierung
    if (rt000_mkz                         == MKZ_JA \               // Mengenänderung
    &&  cod_kz_fix_user(rt000_kz_fix_neu) == TRUE \                 // User-Fixierung gesetzt
    &&  screen_name                       == "rv0000" \             // Nur in rv0000
    &&  rt000_aes                         == cAES_UPDATE) {         // Nur bei Änderung FA
        // Meldung abhängig von der neuen TERMART:
        switch (rt000_termart_neu) {
            case cTERMART_VORW:
                // Bitte beachten: Durch die Mengenänderung mit Terminfixierung wird nur der Starttermin des Fertigungsauftrags >%1< fixiert und der Endtermin aufgrund der geänderten Auflagemenge neu ermittelt. Aufgrund der geänderten Bedarfsmengen können sich für Sekundäraufträge abhängig von der Terminierungsart Struktur Terminkonflikte ergeben.
                call on_error(INFO, "r0000633", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_INFO)
                break
            case cTERMART_RUECKW:
            case cTERMART_MITTEL:
                // Bitte beachten: Durch die Mengenänderung mit Terminfixierung wird nur der Endtermin des Fertigungsauftrags >%1< fixiert und der Starttermin aufgrund der geänderten Auflagemenge neu ermittelt. Aufgrund der geänderten Bedarfsmengen können sich für Sekundäraufträge abhängig von der Terminierungsart Struktur Terminkonflikte ergeben.
                call on_error(INFO, "r0000634", rt000_fklz, rt000_prot, NULL, NULL, PRT_CTRL_INFO)
                break
            case cTERMART_KRITISCH:
            else:
                // Keine Meldung
                break
        }
    }

    log LOG_DEBUG, LOGFILE, "termart >" ## rt000_termart_neu ## "<"
    return OK
}

/**
 * Diese Methode bestimmt, ob eine terminierungsrelevante Änderung gemacht wurde oder nicht
 *
 * @param  standortkalenderP    Standortkalender
 * @return TRUE                 Es wurde eine terminierungsrelevante Änderung gemacht
 * @return FALSE                Es wurde keine terminierungsrelevante Änderung gemacht
 * @return FAILURE              Fehler
 * @see                         {@code rq000_is_terminierungsrelevant}
 * @example
 * {@code rt000_pruefen_termine_bauk_gegen_arbeitszeit}
 **/
int proc rt000_is_terminierungsrelevant(cdtGq300 standortkalenderP)
{
    cdt rq000L
    int terminierungsrelevantL
    int angearbeitetL           = fertig_check_fkfs_angearbeitet(rt000_fkfs, rt000_fkfs_a, rt000_fklz)

    switch (angearbeitetL) {
        case INFO:
            return FALSE
         case TRUE:
            if (rt000_fortsetz_dat_neu == NULL) {
                rt000_fortsetz_dat_neu = rt000_fortsetz_uhr_neu
            }
            break
         case FALSE:
            break
         else:
            return FAILURE
    }

    if (rt000_fsterm_neu == NULL) {
        rt000_fsterm_neu = rt000_fsterm_uhr_neu
    }


    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)

    // Änderbare und terminierungsrelevante Felder aus rt000 an rq000 übergeben
    call rq000_set_fkfs(rq000L, rt000_fkfs)
    call rq000_set_fkfs_a(rq000L, rt000_fkfs_a)

    call rq000_set_menge(rq000L, rt000_menge_neu)
    call rq000_set_menge_aus(rq000L, rt000_menge_aus_neu)
    call rq000_set_fsterm_uhr(rq000L, rt000_fsterm_uhr_neu)
    call rq000_set_fsterm(rq000L, rt000_fsterm_neu)
    if (angearbeitetL == TRUE) {
        call rq000_set_fortsetz_dat(rq000L, rt000_fortsetz_dat_neu)
        call rq000_set_fortsetz_uhr(rq000L, rt000_fortsetz_uhr_neu)
    }
    call rq000_set_seterm_uhr(rq000L, rt000_seterm_uhr_neu)
    call rq000_set_seterm(rq000L, rt000_seterm_neu)
    call rq000_set_fsterm_w_uhr(rq000L, rt000_fsterm_w_uhr_neu)
    call rq000_set_fsterm_w(rq000L, rt000_fsterm_w_neu)
    call rq000_set_seterm_w_uhr(rq000L, rt000_seterm_w_uhr_neu)
    call rq000_set_seterm_w(rq000L, rt000_seterm_w_neu)
    call rq000_set_termart(rq000L, rt000_termart_neu)
    call rq000_set_kn_kapaz(rq000L, rt000_kn_kapaz_neu)
    call rq000_set_kn_unterbr(rq000L, rt000_kn_unterbr_neu)
    call rq000_set_stlidentnr(rq000L, rt000_stlidentnr_neu)
    call rq000_set_stlvar(rq000L, rt000_stlvar_neu)
    call rq000_set_stlnr(rq000L, rt000_stlnr_neu)
    call rq000_set_staltern(rq000L, rt000_staltern_neu)
    call rq000_set_datvon_stl(rq000L, rt000_datvon_stl)
    call rq000_set_aplidentnr(rq000L, rt000_aplidentnr_neu)
    call rq000_set_aplvar(rq000L, rt000_aplvar_neu)
    call rq000_set_aplnr(rq000L, rt000_aplnr_neu)
    call rq000_set_agaltern(rq000L, rt000_agaltern_neu)
    call rq000_set_datvon_apl(rq000L, rt000_datvon_apl)
    call rq000_set_vv_nr(rq000L, rt000_vv_nr_neu)
    call rq000_set_altern(rq000L, rt000_altern_neu)

    terminierungsrelevantL = rq000_is_terminierungsrelevant(rq000L)
    call rt000_protokoll_aus_rq000(rq000L, OK)
    return terminierungsrelevantL
}

/**
 * Diese Methode prüft das Feld KN_REIHENFOLGE
 *
 * @param [standortkalenderP]   Standortkalender
 * @return OK
 * @return FAILURE              Fehler
 * @see                         {@code rq000_val_pruefen_kn_reihenfolge}
 * @see                         {@code rt010_pruefen_verarb}
**/
int proc rt000_pruefen_kn_reihenfolge(cdtGq300 standortkalenderP)
{
    int rcL
    cdt rq000L

    // 300320262
    // Bei Aufruf aus Nettobedarfsrechnung (rm1004) nicht prüfen, da Versorgungsaufträge immer eine "0"
    // bekommen (vgl. "rq000_val_pruefen_kn_reihenfolge").
    // 300320262
    // und nur bei Versorgung übersteuern!
    if ( \
        rt000_verw_art == "3" && \
        cod_aart_versorg(rt000_aart) == TRUE \
    ) {
        rt000_kn_reihenfolge = "0"
        return OK
    }

    // 300324281:
    // Beim Löschen/Stornieren eines FA muss nicht geprüft werden.
    if (rt000_aes == cAES_DELETE) {
        return OK
    }

    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)

    call rq000_set_kn_reihenfolge(rq000L, rt000_kn_reihenfolge)
    call rq000_set_aplnr(rq000L, rt000_aplnr_neu)
    call rq000_set_aart(rq000L, rt000_aart)
    call rq000_set_clear_message(rq000L, TRUE)

    rcL = rq000_val_kn_reihenfolge_fv(rq000L, rt000_aes)
    call rt000_protokoll_aus_rq000(rq000L, rcL)
    if (rcL != OK) {
        return on_error(FAILURE)
    }

    rt000_kn_reihenfolge = rq000_get_kn_reihenfolge(rq000L)

    return OK
}

/**
 * Diese Methode, ob der Standort-Kalender ausreicht
 **/
int proc rt000_check_standortkalender(cdtGq300 standortkalenderP)
{
    int     iL
    int     anzahlL = 0
    date    datumL
    string  datum_str_arrayL[100]
    string  fldname_arrayL[100]


    // Alle zu prüfenden FA-Termine im Array merken
    if (rt000_fsterm_uhr_neu != NULL) {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fsterm_uhr_neu
        fldname_arrayL[anzahlL] = "fsterm_uhr"
    }
    if (rt000_fsterm_w_uhr_neu != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fsterm_w_uhr_neu
        fldname_arrayL[anzahlL] = "fsterm_uhr_w"
    }
    if (rt000_seterm_uhr_neu != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_seterm_uhr_neu
        fldname_arrayL[anzahlL] = "seterm_uhr"
    }
    if (rt000_seterm_w_uhr_neu != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_seterm_w_uhr_neu
        fldname_arrayL[anzahlL] = "seterm_uhr_w"
    }
    if (rt000_fortsetz_uhr_neu != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fortsetz_uhr_neu
        fldname_arrayL[anzahlL] = "fortsetz_uhr"
    }

    if (rt000_fsterm_uhr_alt != NULL) {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fsterm_uhr_alt
        fldname_arrayL[anzahlL] = "fsterm_uhr"
    }
    if (rt000_fsterm_w_uhr_alt != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fsterm_w_uhr_alt
        fldname_arrayL[anzahlL] = "fsterm_uhr_w"
    }
    if (rt000_seterm_uhr_alt != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_seterm_uhr_alt
        fldname_arrayL[anzahlL] = "seterm_uhr"
    }
    if (rt000_seterm_w_uhr_alt != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_seterm_w_uhr_alt
        fldname_arrayL[anzahlL] = "seterm_uhr_w"
    }
    if (rt000_fortsetz_uhr_alt != NULL)  {
        anzahlL++
        datum_str_arrayL[anzahlL]   = rt000_fortsetz_uhr_alt
        fldname_arrayL[anzahlL] = "fortsetz_uhr"
    }


    if (kalidKalenderRt000 <= 0) {
        dbms alias kalidKalenderRt000
        dbms sql select b110.kalid \
                 from b110 \
                 where b110.fi_nr = :+fi_nrKalenderRt000 \
                 and   b110.werk =  :+werkKalenderRt000
        dbms alias
    }


    public gq300.bsl
    for iL = 1 while (iL <= anzahlL) step 1 {
        datumL = @to_date(":datum_str_arrayL[iL]", DATEFORMAT1)
        if (defined(datumL) != TRUE) {
            next
        }

        if (gq300_pruefen_tag_im_kalender(kalidKalenderRt000, datumL) != TRUE) {
            // Kalendertag %s zu Kalender %s nicht vorhanden!
            return on_error(FAILURE, "g3000000", @format_date(datumL, DATEFORMAT0) ## " (" ## fldname_arrayL[iL] ## ")" ## "^" ## kalidKalenderRt000)
        }
    }

    return OK
}

/**
 * Prüft das "Kennzeichen Löschen Auftrag" auf Gültigkeit
 *
 * @return OK
 * @return WARNING/FAILURE Logischer Fehler, abhängig von warn2fail
 **/
int proc rt000_pruefen_kennzeichen_loeschen()
{
    string labelL

    switch (rt000_loesch) {
        case "1":
            if (rt000_kalk > "1") {
                // Wenn Kennzeichen Kalkulation > "1", dann muss auch Kennzeichen Löschen > "1" sein
                return on_error(WARNING, "r0000184", "", rt000_prot)
            }
            break
        case "2":
            break
        case "3":
            if ( \
                rt000_aart != AART_PRIMAER_KUNDE && \
                rt000_aart != AART_SEKUNDAER \
            ) {
                // Kennzeichen Löschen >3< ist nur für Primär- und Sekundäraufträge zu Kundenaufträgen gültig
                return on_error(WARNING, "r0000280", "", rt000_prot)
            }
            break
        else:
            labelL = bu_get_property_value("loesch", PR_STATUS_LINE_TEXT)
            // Ungültiger Wert (%s) im Feld <%s>!
            return on_error(WARNING, "APPl0497", rt000_loesch ## "^" ## labelL, rt000_prot)
    }

    return OK
}

/**
 * Diese Methode prüft den Starttermin (Datum), ob er auf dem Kalenderende des Standortkalenders liegt
 *
 * Wenn ja, dann ist er ungültig, weil sonst der SETERM nicht berechnet werden kann. Dieser ist immer mindestens ein
 * Tag dannach, welcher nicht mehr im Kalender liegt.
 *
 * Benötigte Felder aus rt000:
 * rt000_fsterm_uhr_neu
 * rt000_fklz
 *
 * @param [standortkalenderP]   Standortkalender als Instanz von {@code cdtGq300}
 * @return OK                   Starttermin liegt nicht auf dem Kalenderende
 * @return WARNING              Starttermin liegt auf dem Kalenderende
 * @return FAILURE              Fehler
 * @see                         {@code rq000_val_pruefen_starttermin_auf_kalenderende}
 * @see                         {@code rt000_pruefen_endtermin_auf_kalenderende}
 * @example
 **/
int proc rt000_pruefen_starttermin_auf_kalenderende(cdtGq300 standortkalenderP)
{
    int  kalidL
    date kalenderendeL
    cdt  datumL = DateBU_new()


    // Standort-Kalender übernehmen oder neu ermitteln
    standortkalenderP = rt000_ermitteln_standortkalender(standortkalenderP)


    // Kalenderende ermitteln
    public gq300.bsl
    kalenderendeL = gq300_get_datum_last_date(standortkalenderP, TRUE)
    if (defined(kalenderendeL) != TRUE) {
        kalidL = gq300_get_kalid(standortkalenderP)
        log LOG_DEBUG, LOGFILE, "Es konnte kein Kalenderende zum Standortkalender >" ## kalidL ## "< ermittelt werden -> return OK"
        return OK
    }


    // Datum ohne Uhrzeit ermitteln
    datumL=>value = rt000_fsterm_uhr_neu
    call bu_cdt_ersetzen_uhrzeit(datumL, "value", defaultUhrzeit0C)
    log LOG_DEBUG, LOGFILE, "Datum Starttermin >" ## @format_date(datumL=>value, DATEFORMAT0) ## "< / " \
                         ## "Kalenderende >" ## @format_date(kalenderendeL, DATEFORMAT0) ## "<"


    // 300364183:
    // Liegt der Starttermin auf dem Kalenderende (des Standortkalenders) j/n?
    if (@date(datumL=>value) == @date(kalenderendeL)) {
        kalidL = gq300_get_kalid(standortkalenderP)
        // Der Starttermin >%1< des Fertigungsauftrages >%2< ist ungültig, da er auf dem Kalenderende des Kalenders >%3< liegt!
        return on_error(WARNING, "r0000281", \
                        @format_date(datumL=>value, DATEFORMAT0) ## "^" ## rt000_fklz ## "^" ## kalidL, \
                        rt000_prot)
    }

    return OK
}

/**
 * Diese Methode prüft den Endtermin (mit Uhrzeit), ob er auf dem Kalenderende des Standortkalenders liegt
 *
 * Wenn ja, dann ist er ungültig, weil sonst der SETERM nicht berechnet werden kann. Dieser ist immer mindestens ein
 * Tag dannach, welcher nicht mehr im Kalender liegt.
 *
 * Benötigte Felder aus rt000:
 * rt000_seterm_uhr_neu
 * rt000_fklz
 *
 * @param [standortkalenderP]   Standortkalender als Instanz von {@code cdtGq300}
 * @return OK                   Endtermin liegt nicht auf dem Kalenderende
 * @return WARNING              Endtermin liegt auf dem Kalenderende
 * @return FAILURE              Fehler
 * @see                         {@code rq000_val_pruefen_starttermin_auf_kalenderende}
 * @see                         {@code rt000_pruefen_starttermin_auf_kalenderende}
 * @example
 **/
int proc rt000_pruefen_endtermin_auf_kalenderende(cdtGq300 standortkalenderP)
{
    int  kalidL
    date kalenderendeL
    cdt  datumL = DateBU_new()


    // Standort-Kalender übernehmen oder neu ermitteln
    standortkalenderP = rt000_ermitteln_standortkalender(standortkalenderP)

    // Kalenderende ermitteln
    public gq300.bsl
    kalenderendeL = gq300_get_datum_last_date(standortkalenderP, TRUE)
    if (defined(kalenderendeL) != TRUE) {
        kalidL = gq300_get_kalid(standortkalenderP)
        log LOG_DEBUG, LOGFILE, "Es konnte kein Kalenderende zum Standortkalender >" ## kalidL ## "< ermittelt werden -> return OK"
        return OK
    }


    // Datum ohne Uhrzeit ermitteln
    datumL=>value = rt000_seterm_uhr_neu
    call bu_cdt_ersetzen_uhrzeit(datumL, "value", defaultUhrzeit0C)
    log LOG_DEBUG, LOGFILE, "Datum Endtermin >" ## @format_date(datumL=>value, DATEFORMAT0) ## "< / " \
                         ## "Kalenderende >" ## @format_date(kalenderendeL, DATEFORMAT0) ## "<"


    // 300364183:
    // Liegt der Starttermin auf dem Kalenderende (des Standortkalenders) j/n?
    if (@date(datumL=>value) == @date(kalenderendeL)) {
        kalidL = gq300_get_kalid(standortkalenderP)
        // Der Endtermin >%1< des Fertigungsauftrages >%2< ist ungültig, da er auf dem Kalenderende des Kalenders >%3< liegt!
        return on_error(WARNING, "r0000282", \
                        @format_date(datumL=>value, DATEFORMAT0) ## "^" ## rt000_fklz ## "^" ## kalidL, \
                        rt000_prot)
    }

    return OK
}

/**
 * Prüfung und ggf. neue Ermittlung des Standortkalenders
 *
 * @param [standortkalenderP]   übergebener Standortkalender
 * @return !=$NULL              Ermittelter Standortkalender
 * @return $NULL                Fehler
 * @see                         {@code rt100_ermitteln_standortkalender}
 * @see                         {@code rt110_ermitteln_standortkalender}
 * @see                         {@code rt210_ermitteln_standortkalender}
 * @see                         {@code re000_ermitteln_standortkalender}
 * @see                         {@code rt110v_ermitteln_standortkalender}
 **/
cdtGq300 proc rt000_ermitteln_standortkalender(cdtGq300 standortkalenderP)
{
    int      kalid_standortL
    cdtGq300 gq300L


    // 300348492: ggf. übergebenen Standortkalender direkt nehmen, wenn übergeben
    if (defined(standortkalenderP) == TRUE) {
        return standortkalenderP
    }


    // Selektion KALID des Standortkalenders
    if (dm_is_cursor("sel_b110_kalid_rt000C") != TRUE) {
        dbms declare sel_b110_kalid_rt000C cursor for \
             select b110.kalid \
             from b110 \
             where b110.fi_nr = ::_1 \
             and   b110.werk  = ::_2

        dbms with cursor sel_b110_kalid_rt000C alias \
            kalid_standortL
    }

    dbms with cursor sel_b110_kalid_rt000C execute using \
        FI_NR1, \
        rt000_werk
    switch (SQL_CODE) {
        case SQL_OK:
        case SQLNOTFOUND:
            if (defined(kalid_standortL) != TRUE \
            ||  kalid_standortL          <= 0) {
                return $NULL
            }
            break
        else:
            return $NULL
    }

    // Standortkalender über Kalender-Cache ermitteln
    gq300L = fertig_lesen_kalender(boa_cdt_get(name_cdtTermGlobal_rt000), \
                                    kalid_standortL, \
                                    $NULL, \        // datum_vonP
                                    $NULL, \        // datum_bisP
                                    FALSE, \        // terminierungP
                                    FI_NR1, \
                                    rt000_werk, \
                                    $NULL, \        // kostst
                                    $NULL,          // arbplatzP
                                    TRUE,           // clear_messageP
                                    F_ART_PROTOKOLL_FA)           // art_protokoll


    return gq300L
}

/**
 * Diese Methode macht die Meldungs-Abhandlung für das Modul gq300
 *
 * d.h. im BATCH werden die Meldungen gespeichert und im Dialog auf dem Bildschrim ausgegeben
 *
 * Bei Returncode != OK und INFO wird ggf. ein Rollback gemacht.
 *
 * @param gq300P    Modul-Instanz von gq300
 * @param rcP       Return-Code der gq300-Methode
 * @return OK
 * @see             {@code rt100_protokoll_aus_gq300}
 * @see             {@code rt100_protokoll_aus_rq000}
 * @see             {@code rt100_protokoll_aus_rq100}
 **/
int proc rt000_protokoll_aus_gq300(cdtGq300 gq300P, int rcP)
{
    if (BATCH == TRUE) {
        if ((SQL_IN_TRANS == TRUE || warn_2_fail == TRUE) \
        &&   rcP != OK \
        &&   rcP != INFO) {
            call bu_rollback()
        }

        call gq300_speichern_protokoll_funktion(gq300P, rt000_prot, $NULL, $NULL)
    }
    else {
        call gq300_ausgeben_meldungen(gq300P, BU_0, (rcP != OK && rcP != INFO), FALSE)
    }

    return OK
}

/**
 * Diese Methode macht die Meldungs-Abhandlung für das Modul rq000P
 *
 * d.h. im BATCH werden die Meldungen gespeichert und im Dialog auf dem Bildschrim ausgegeben
 *
 * Bei Returncode != OK und INFO wird ggf. ein Rollback gemacht.
 *
 * @param rq000P    Modul-Instanz von rq000
 * @param rcP       Return-Code der rq000-Methode
 * @return OK
 * @see             {@code rt000_protokoll_aus_gq300}
 * @see             {@code rt100_protokoll_aus_rq000}
 * @see             {@code rt000_fa_meldung_ende}
 **/
int proc rt000_protokoll_aus_rq000(cdtRq000 rq000P, int rcP)
{
    if (BATCH == TRUE) {
        if ((SQL_IN_TRANS == TRUE || warn_2_fail == TRUE) \
        &&   rcP != OK \
        &&   rcP != INFO) {
            call bu_rollback()
        }

        call rq000_set_clear_message(rq000P, TRUE)
        call rq000_speichern_protokoll_funktion(rq000P, rt000_prot, $NULL, $NULL, "")
    }
    else {
        call rq000_ausgeben_meldungen(rq000P, BU_0, (rcP != OK && rcP != INFO), FALSE)
    }

    return OK
}

/**
 * Ermitteln, ob die PROJEKT_ID im FA geändert wurde oder nicht
 *
 * @ldb_in rt000_aes
 * @ldb_in rt000_projekt_id_neu
 * @ldb_in rt000_projekt_id_alt
 * @ldb_out rt000_kn_aend_fa
 * @ldb_out rt000_verw_art
 *
 * @param [fu_bedr_extP]        Funktionscode aus r115
 * @param [kn_aend_fa_extP]     Von außen übergebenes Kennzeichen
 * @return OK
 *                              rt000_kn_aend_fa
 * @return FAILURE              Fehler
 * @see
 **/
int proc rt000_ermitteln_aenderung_projekt_id(string fu_bedr_extP, string kn_aend_fa_extP)
{
    string fu_bedrL


    // Wenn von exterm das Kennzeichen vorgegeben wurde, wird dieses generell genommen,
    // egal ob die Projekt-ID geändert wird oder nicht.
    if (defined(kn_aend_fa_extP) == TRUE \
    &&  kn_aend_fa_extP          != "") {
        rt000_kn_aend_fa = kn_aend_fa_extP
        log LOG_DEBUG, LOGFILE, "kn_aend_fa extern >" ## rt000_kn_aend_fa ## "< / " \
                             ## "projekt_id_neu >" ## rt000_projekt_id_neu ## "< / " \
                             ## "projekt_id_alt >" ## rt000_projekt_id_alt ## "< / " \
                             ## "aes >" ## rt000_aes ## "< / " \
                             ## "verw_art >" ## rt000_verw_art ## "<"
        return OK
    }


    // Funktionscode ermitteln
    if (defined(fu_bedr_extP) == TRUE \
    &&  fu_bedr_extP          != "") {
        fu_bedrL = fu_bedr_extP
    }
    else if (rt000_fu_bedr != "") {
        fu_bedrL = rt000_fu_bedr
    }
    else {
        switch (rt000_verw_art) {
            case "3":   // Aufruf aus rm1004 (Nettobedarfsrechnung)
                fu_bedrL = cFUBEDR_NETTO
                break
            case "1":   // Versorgung (rt010d)
            case "5":   // bei Aufruf aus rv0000 immer abhängig vom AES
                fu_bedrL = cFUBEDR_MTAEND
                break
            case "2":   // Sim. Produktionsplan (dh204)
            case "4":   // Simulation (rh080)
            case "6":   // Verfürgbarkeit (dv250)
            case "":    // Primärauftragsverwaltung bzw. Aufruf aus Übernahme IH-Vorschläge als IH-Aufträge
            else:
                break
        }
    }


    // Kennzeichen setzen (nur bei FU_BEDR=2)
    if (fu_bedrL == cFUBEDR_NETTO) {
        rt000_kn_aend_fa = KN_AEND_FA_OHNE
    }
    else if (fu_bedrL != cFUBEDR_MTAEND) {
        rt000_kn_aend_fa = KN_AEND_FA_KEINE
    }
    else {      // fu_bedr = 2 bzw. Änderung FA
        // Prüfung, ob sich die Projekt-ID geändert hat
        switch (rt000_aes) {
            case cAES_UPDATE:
                if (rt000_projekt_id_neu != rt000_projekt_id_alt) {
                    rt000_kn_aend_fa = KN_AEND_FA_PROJEKTID
                }
                else {
                    rt000_kn_aend_fa = KN_AEND_FA_KEINE
                }
                break
            case cAES_INSERT:
            case cAES_REKONFIG:
            case cAES_DELETE:
            case 9:
            else:
                if (cod_kn_aend_fa_keine(rt000_kn_aend_fa) != TRUE) {
                    rt000_kn_aend_fa = KN_AEND_FA_KEINE
                }
                break
        }
    }

    log LOG_DEBUG, LOGFILE, "kn_aend_fa >" ## rt000_kn_aend_fa ## "< / " \
                         ## "projekt_id_neu >" ## rt000_projekt_id_neu ## "< / " \
                         ## "projekt_id_alt >" ## rt000_projekt_id_alt ## "< / " \
                         ## "aes >" ## rt000_aes ## "< / " \
                         ## "fu_bedr >" ## fu_bedrL ## "< / " \
                         ## "verw_art >" ## rt000_verw_art ## "<"
    return OK
}

/**
 * Abstellen eines Aktionssatzes in r115 für Bedarfsrechnung und/oder Nettobedarfsrechnung
 *
 * @ldb_in rt000_aes
 * @ldb_in rt000_tkz
 * @ldb_in rt000_mkz
 * @ldb_in rt000_rkz
 * @ldb_in rt000_kn_aend_fa
 * @ldb_in rt000_werk
 * @ldb_in rt000_fklz
 * @ldb_in rt000_aufnr
 * @ldb_in rt000_aufpos
 * @ldb_in rt000_fkfs
 * @ldb_in rt000_fkfs_a
 * @ldb_in rt000_freigabe
 * @ldb_in rt000_da
 * @ldb_in rt000_kn_prodplan
 * @ldb_in rt000_verw_art
 * @ldb_in rt000_identnr_neu
 * @ldb_in rt000_var_neu
 * @ldb_in rt000_lgnr_neu
 * @ldb_in rt000_identnr_alt
 * @ldb_in rt000_var_alt
 * @ldb_in rt000_lgnr_alt
 * @ldb_in bmRt000
 * @ldb_in kn_kanbanRt000
 * @ldb_in kn_lgdisp_neuRt000
 * @ldb_in kn_nettobedarfRt000
 * @ldb_in R_KZ_DISPORt000
 * @ldb_in name_cdtTermGlobal_rt000
 * @ldb_in rt000_prot
 *
 * @param rq000P                Modul-Instanz des betroffenen Fertigungsauftrages
 *                              rq000P=>r000
 * @param [fu_bedr_extP]        Von extern übergebener Funktionscode
 * @param termine_beibehaltenP  Von extern übergebenes Kennzeichen für Termine beibehalten (TRUE) oder nicht (FALSE)
 *                              (siehe Bundle "b_termine_beibehalten_rt000")
 * @param [ergebnisP]           CDT, in welches (bei Erfolg) Ergebnisdaten geschrieben werden
 * @return OK
 *                              rt000_kn_aend_fa
 *                              rt000_fu_bedr
 * @return FAILURE              Fehler
 * @see                         rq115i_check_abstellen_netto
 **/
int proc rt000_aktionssatz(cdtRq000 rq000P, string fu_bedr_extP, boolean termine_beibehaltenP, ErgebnisRt000 ergebnisP)
{
    int              rcL
    int              aes_rq115L
    string           flagKZ_DISPOL
    boolean          aktionssatzL
    boolean          aktionssatz_nettoL
    aktionssatzRq115 rq115L


    // 1) Aktionssatz für die Bedarfsrechnung abstellen
    aktionssatzL = TRUE
    if (rt000_aes != cAES_DELETE) {
        if (cod_aart_versorg(rt000_aart) == TRUE) {
            // Für Versorgungsaufträge darf die Bedarfsrechnung nicht gestartet werden
            aktionssatzL = FALSE
        }
        else if (cod_aart_reparatur(rt000_aart) == TRUE) {
            // 300249176: Bei Reparaturaufträgen soll auch ein fu_bedr=2 abgestellt werden (keiner bei fu_bedr=3 oder 4).
            aktionssatzL = (rt000_aes == cAES_UPDATE)
        }


        // 300346623
        // Wenn keine terminierungsrelevanten Änderung gemacht wurde, wird kein Aktionssatz abgestellt.
        log LOG_DEBUG, LOGFILE, "rt000_tkz >" ## rt000_tkz ## "< / " \
                             ## "rt000_mkz >" ## rt000_mkz ## "< / " \
                             ## "rt000_rkz >" ## rt000_rkz ## "< / " \
                             ## "rt000_kn_aend_fa >" ## rt000_kn_aend_fa ## "< / " \
                             ## "aktionssatz >" ## aktionssatzL ## "< / " \
                             ## "termine_beibehalten >" ## termine_beibehaltenP ## "<"  // 300354288
        if (rt000_tkz                             == cTKZ_KEINE \
        &&  rt000_mkz                             == MKZ_UNDEFINIERT \
        &&  rt000_rkz                             == RKZ_UNDEFINIERT \
        &&  cod_kn_aend_fa_nein(rt000_kn_aend_fa) == TRUE \               // 300386224
        &&  termine_beibehaltenP                  == FALSE \
        &&  aktionssatzL                          == TRUE) {
            log LOG_DEBUG, LOGFILE, "Keine Änderung -> Kein Aktionssatz"
            aktionssatzL = FALSE
        }
    }


    if (aktionssatzL == TRUE) {
        if (screen_name  == "re000" \
        &&  fu_bedr_extP == cFUBEDR_EINPLAN) {
            if (rt000_aes == cAES_DELETE) {
                // 300392376:
                // Beim Stornieren den in rt090 gelöschen r115-Satz nicht wieder anlegen!
                aes_rq115L = cAES_DELETE
            }
            else {
                // 300331307:
                // Der korrekte Funktionscode wird im re000 bei vorhandenem Aktionssatz mit fu_bedr=3 ermittelt und als
                // echter Funktionscode übergeben Das rq115 braucht aber (leider) einen AES.
                aes_rq115L = cAES_INSERT
            }
        }
        else {
            switch (rt000_aes) {
                case cAES_DELETE:
                case cAES_INSERT:
                case cAES_UPDATE:
                case cAES_REKONFIG:
                case 9:
                    aes_rq115L = rt000_aes
                    break
                case $NULL:
                case cAES_NONE:
                    aes_rq115L = cAES_UPDATE
                    break
                else:
                    log LOG_DEBUG, LOGFILE, "Fehler: Ungültiger aes >" ## rt000_aes ## "<"
                    return FAILURE
            }
        }

        public rq115.bsl
        rq115L = rq115_new(boa_cdt_get(name_cdtTermGlobal_rt000), rt000_prot)
        call rq115_set_fi_nr(rq115L, FI_NR1)
        call rq115_set_werk(rq115L, rt000_werk)
        call rq115_set_fklz(rq115L, rt000_fklz)
        call rq115_set_aes(rq115L, aes_rq115L)
        call rq115_set_mkz(rq115L, rt000_mkz)
        call rq115_set_tkz(rq115L, rt000_tkz)
        call rq115_set_rkz(rq115L, rt000_rkz)
        call rq115_set_kn_aend_fa(rq115L, rt000_kn_aend_fa)
        call rq115_set_aufnr(rq115L, rt000_aufnr)
        call rq115_set_aufpos(rq115L, rt000_aufpos)
        call rq115_set_aart(rq115L, rt000_aart)
        call rq115_set_fkfs(rq115L, rt000_fkfs)
        call rq115_set_fkfs_a(rq115L, rt000_fkfs_a)
        call rq115_set_freigabe(rq115L, rt000_freigabe)

        // Die Abhandlung des Aktionssatzes "Bedarfsrechnung" im re000 direkt gemacht
        if (screen_name == "re000") {
            call rq115_set_reset_kn_terminiert(rq115L, FALSE)
            call rq115_set_nur_aktionssatz(rq115L, TRUE)
            if (sm_prop_id("logname") > 0) {
                call rq115_set_logname(rq115L, logname) // @bsldoc.ignore
            }
        }
        else {
            call rq115_set_reset_kn_terminiert(rq115L, TRUE)
            call rq115_set_nur_aktionssatz(rq115L, FALSE)
        }

        // 300349432/300354288
        call rq115_set_r000(rq115L, rq000_get_r000(rq000P))

        // 300337541:
        // Aus Nettobedarfsrechnung und rh110/rv110/rh1004 heraus muss die aktuelle Jobid übergeben werden, damit die
        // u.U. angelegten r115-Sätze auch im gleichen Lauf abgearbietet werden und nicht stehen bleiben.
        // 300370156:
        // Damit in der Bedarfsrechnung/Nettobedarfsrechnung immer die aktuelle JOBID im rq115 gesetzt wird reicht
        // die Übergabe von $NULL.
        call rq115_set_jobid(rq115L, $NULL)
        call rq115_set_clear_message(rq115L, TRUE)
        call rq115_set_feinplanung(rq115L, FALSE)
        call rq115_set_art_protokoll(rq115L, F_ART_PROTOKOLL_FA)

        rcL = rq115_terminierung(rq115L, FALSE)
        switch (rcL) {
            case OK:
            case BU_3:
            case BU_4:
                log LOG_DEBUG, LOGFILE, "Es wurde ein Aktionssatz in r115 zu fklz >" ## rt000_fklz ## "< abgestellt"
                rt000_fu_bedr    = rq115_get_fu_bedr_r115(rq115L)
                rt000_kn_aend_fa = rq115_get_kn_aend_fa_r115(rq115L)
                if (defined(ergebnisP)) {
                    // Daten zum möglicherweise abgestellten Aktionsssatz abholen
                    ergebnisP=>r115 = bu_cdbi_new("r115")
                    call bu_cdt_copyfields(rq115L, ergebnisP=>r115, TRUE, TRUE)
                }
                break
            case INFO:          // r000 nicht vorhanden
                // 300392101: Beim löschen eines fa über rt090 ist er natürlich nicht mehr vorhanden und es muss/darf
                // keine Aktionssatz abgestellt werden -> Darum kein Fehler
                if (rt000_aes == cAES_DELETE) {
                    return OK
                }

                // Hier ein "fallthrough", da Fehler
            case FAILURE:
            else:
                log LOG_DEBUG, LOGFILE, "Fehler rq115_terminierung rc=" ## rcL
                return FAILURE
        }
    }
    else {
        aktionssatz_nettoL = FALSE
    }


    // 2) Zusätzlich Aktionssatz für die Nettobedarfsrechnung abstellen
    //    Bitte auch "rq115i_check_abstellen_netto" beachten!
    if (aktionssatzL == TRUE) {
        // Zusätzlich Abstellen Aktionssatz Nettobedarfsrechnung "0"
        if ( \
            rt000_verw_art != "3" && \
            ( \
                rt000_identnr_neu != NULL  || \
                rt000_identnr_alt != NULL \
            ) && \
            cod_aart_pseudo(rt000_aart)      != TRUE && \
            bmRt000                          != "0"  && \
            kn_kanbanRt000                   != "1"  && \
            kn_lgdisp_neuRt000               == "1"  && \
            cod_aart_planauftrag(rt000_aart) != TRUE \
        ) {
            aktionssatz_nettoL = FALSE
            flagKZ_DISPOL      = 0

            if (R_VKN == "1") {
                // 300176911 - nur Bedarfsdecker mit Dispoart > "0"
                if ( \
                    rt000_da == DA_BEDARF || \
                    ( \
                        rt000_da            == DA_AUFTRAG && \
                        kn_nettobedarfRt000 != "1" && \
                        kn_nettobedarfRt000 != "2" \
                    ) \
                ) {
                    aktionssatz_nettoL = TRUE
                }
            }
            else {
                if (cod_bs_eigen(rt000_bs) == TRUE) {
                    if ( \
                        rt000_fkfs        == FSTATUS_SIM && \
                        rt000_kn_prodplan == "1" \
                    ) {
                        flagKZ_DISPOL = R_KZ_DISPORt000(2, 1)
                    }
                    else {
                        flagKZ_DISPOL = R_KZ_DISPORt000(1, 1)
                    }
                }
                else {
                    flagKZ_DISPOL = R_KZ_DISPO_FBRt000(1, 1)

                    // Flag auf "2" setzen, damit es bei Versorgung-B-Teil analog zu
                    // EF abgehandelt werden kann
                    if (flagKZ_DISPOL == "1") {
                        flagKZ_DISPOL = "2"
                    }
                }
                if ( \
                    ( \
                        rt000_da == DA_BEDARF && \
                        ( \
                            flagKZ_DISPOL  == "2" || \
                            ( \
                                flagKZ_DISPOL == "3"         && \
                                rt000_fkfs    == FSTATUS_SIM \
                            ) \
                        ) \
                    ) || \
                    ( \
                        rt000_da            == DA_AUFTRAG && \
                        flagKZ_DISPOL       >  "0" && \
                        kn_nettobedarfRt000 == "3" \
                    ) \
                ) {
                    aktionssatz_nettoL = TRUE
                }
            }
        }
    }

    if (aktionssatz_nettoL == TRUE) {
        if (rt000_identnr_neu != "") {
            public rq115.bsl
            rq115L = rq115_new(boa_cdt_get(name_cdtTermGlobal_rt000), rt000_prot)
            call rq115_set_fi_nr(rq115L, FI_NR1)
            call rq115_set_werk(rq115L, werk)
            call rq115_set_identnr(rq115L, rt000_identnr_neu)
            call rq115_set_var(rq115L, rt000_var_neu)
            call rq115_set_lgnr(rq115L, rt000_lgnr_neu)
            call rq115_set_werk(rq115L, rt000_werk)
            call rq115_set_nur_vkn(rq115L, FALSE)
            call rq115_set_feinplanung(rq115L, FALSE)
            call rq115_set_art_protokoll(rq115L, F_ART_PROTOKOLL_FA)
            call rq115_set_clear_message(rq115L, TRUE)

            rcL = rq115_nettobedarfsrechnung(rq115L)
            switch (rcL) {
                case OK:
                case INFO:
                case BU_3:
                case BU_4:
                    break
                case FAILURE:
                else:
                    log LOG_DEBUG, LOGFILE, "Fehler rq115_nettobedarfsrechnung (neu) rc=" ## rcL
                    return FAILURE
            }
        }

        if ( \
            ( \
                rt000_identnr_alt != rt000_identnr_neu || \
                rt000_var_alt     != rt000_var_neu     || \
                rt000_lgnr_alt    != rt000_lgnr_neu \
            ) && \
            rt000_identnr_alt  != "" \
        ) {
            public rq115.bsl
            rq115L = rq115_new(boa_cdt_get(name_cdtTermGlobal_rt000), rt000_prot)
            call rq115_set_fi_nr(rq115L, FI_NR1)
            call rq115_set_werk(rq115L, werk)
            call rq115_set_identnr(rq115L, rt000_identnr_alt)
            call rq115_set_var(rq115L, rt000_var_alt)
            call rq115_set_lgnr(rq115L, rt000_lgnr_alt)
            call rq115_set_werk(rq115L, rt000_werk)
            call rq115_set_nur_vkn(rq115L, FALSE)
            call rq115_set_feinplanung(rq115L, FALSE)
            call rq115_set_art_protokoll(rq115L, F_ART_PROTOKOLL_FA)
            call rq115_set_clear_message(rq115L, TRUE)

            rcL = rq115_nettobedarfsrechnung(rq115L)
            switch (rcL) {
                case OK:
                case INFO:
                case BU_3:
                case BU_4:
                    break
                case FAILURE:
                else:
                    log LOG_DEBUG, LOGFILE, "Fehler rq115_nettobedarfsrechnung (alt) rc=" ## rcL
                    return FAILURE
            }
        }
    }

    log LOG_DEBUG, LOGFILE, "aktionssatz >" ## aktionssatzL ## "< / " \
                         ## "aktionssatz_netto >" ## aktionssatz_nettoL ## "< / " \
                         ## "fu_bedr_ext >" ## fu_bedr_extP ## "< / " \
                         ## "termine_beibehalten >" ## termine_beibehaltenP ## "<"
    return OK
}

/**
 * Setzen und Abhandlung des Kennzeichens "fa_verschoben"
 *
 * @param [standortkalenderP]   Standortkalender als Instanz von "cdtGq300"
 * @return OK
 * @return FAILURE              Fehler
 * @see                         rq000_val_pruefen_fa_verschoben
 * @see                         rt100_pruefen_fa_verschoben_untg
 **/
int proc rt000_pruefen_fa_verschoben(cdtGq300 standortkalenderP)
{
    int      pezeitL
    date     seterm_uhr_altL
    string   dummyL
    boolean  setzen_fa_verschobenL    = FALSE
    boolean  fa_verschoben_geaendertL = FALSE
    cdt      datumL
    cdtRq000 rq000L


    // 300191700 (Fehler 2):
    // Wenn der neue Start-/Endtermin hinter dem jeweils alten Termin liegt, muss bei gesetztem R_VKN und
    // R_PRUEF_VERSCHOBEN und aes 3/4 das FA_VERSCHOBEN gesetzt werden (passiert z.B. wenn bei Mittelpunkterminierung
    // ein Primär-FA aus Vertriebsauftrag in die Vergangenheit fallen würde).
    // Keine besondere Abhandlung von angearbeiteten FA, wenn der Fortsetztermin geändert wurde
    // (und lt. PO keine Prüfung auf fsterm).
    // 300401388 - Erweiterung der Parameter-Prüfung:
    // Ermittlung an Hand von mehreren Parametern (siehe "rq000_pruefen_setzen_fa_verschoben"), ob das
    // FA_VERSCHOBEN gesetzt werden darf oder nicht.

    // Aus Laufzeitgründen immer zuerst den geänderten Termin und den AES prüfen. Denn ohne diese Änderung wird das
    // Kennzeichen niemals auf "1" gesetzt (unabhängig von den Parametern). Die Parametereinstellungen sind dann
    // irrelevant und müssen nicht ermittelt werden.
    if (@time(rt000_seterm_uhr_neu) > @time(rt000_seterm_uhr_alt) \
    &&  (rt000_aes == cAES_REKONFIG || rt000_aes == cAES_UPDATE)) {
        public rq000.bsl
        rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt000), FI_NR1, rt000_fklz, standortkalenderP)
        if (defined(rq000L) != TRUE) {
            return FAILURE
        }

        call rq000_set_da(rq000L, rt000_da)
        call rq000_set_fkfs(rq000L, rt000_fkfs)
        call rq000_set_aart(rq000L, rt000_aart)
        call rq000_set_identnr(rq000L, rt000_identnr_neu)
        call rq000_set_var(rq000L, rt000_var_neu)
        call rq000_set_lgnr(rq000L, rt000_lgnr_neu)
        call rq000_set_sim(rq000L, (SIM == TRUE))
        call rq000_set_clear_message(rq000L, TRUE)

        setzen_fa_verschobenL = rq000_pruefen_setzen_fa_verschoben(rq000L)
        call rq000_ausgeben_meldungen(rq000L, BU_0, FALSE, FALSE)

        if (setzen_fa_verschobenL == TRUE) {
            rt000_fa_verschoben      = "1"
            fa_verschoben_geaendertL = TRUE
        }
    }


    // Geänderten Spätesten Endtermin mit frühestem übergeordneten Bedarf vergleichen, um ggf. KnFaVerschoben aufzuheben
    if (rt000_fa_verschoben         == "1"    \
    &&  @time(rt000_seterm_uhr_alt) != @time(rt000_seterm_uhr_neu) \
    &&  rt000_aes                   != cAES_DELETE \
    &&  rt000_aes                   != cAES_INSERT) {
        if (dm_is_cursor("rt000CurSbterm") != TRUE) {
            dbms declare rt000CurSbterm cursor for \
                select \
                    '1', \
                    r100.sbterm \
                from \
                    r100 \
                where \
                    r100.fi_nr = ::_1     and \
                    r100.ufklz = ::_2 \
                union \
                select \
                    '2', \
                    r100.sbterm \
                from \
                    r100 \
                    join r1004 on ( \
                        r1004.fi_nr = r100.fi_nr and \
                        r1004.fmlz  = r100.fmlz \
                    ) \
                where \
                    r1004.fi_nr = ::_3     and \
                    r1004.fklz  = ::_4 and \
                    r1004.menge > 0 \
                order by \
                    2

            dbms with cursor rt000CurSbterm alias \
                dummyL, \
                rt000_sbterm_uebg
        }

        dbms with cursor rt000CurSbterm execute using \
            FI_NR1,  \
            rt000_fklz,  \
            FI_NR1, \
            rt000_fklz

        // Berücksichtigung der pezeit bei da = 2: seterm + pezeit bzw. (sbterm - pezeit) über den FKT
        seterm_uhr_altL = rt000_seterm_uhr_neu
        pezeitL         = 0
        if (rt000_da          == DA_BEDARF \
        &&  rt000_sbterm_uebg != "") {
            dbms alias pezeitL
            dbms sql \
                select \
                    g020.pezeit \
                from \
                    g020 \
                where \
                    g020.fi_nr   = :+FI_NR1            and \
                    g020.werk    = :+rt000_werk        and \
                    g020.identnr = :+rt000_identnr_neu and \
                    g020.var     = :+rt000_var_neu     and \
                    g020.lgnr    = :+rt000_lgnr_neu
            dbms alias

            if (pezeitL <= 0) {
                pezeitL = bu_getenv("D_PEZEIT") + 0
            }

            if (pezeitL > 0) {
                datumL = fertig_getDatum(rt000_handle_gm300, "get", rt000_sefkt + pezeitL, $NULL)
                if (defined(datumL) == TRUE) {
                    seterm_uhr_altL = datumL=>datum
                }
            }
        }

        log LOG_DEBUG, LOGFILE, "fa_verschoben: seterm >" ## rt000_seterm_uhr_neu ## "< seterm mit pezeit >" \
                             ## bu_date_to_string(seterm_uhr_altL, TRUE) ## "< sbterm >" ## rt000_sbterm_uebg \
                             ## "< pezeit >" ## pezeitL ## "< da >" ## rt000_da ## "<"

        if (rt000_sbterm_uebg      == "" \
        ||  @date(seterm_uhr_altL) <= @date(rt000_sbterm_uebg)) {
            rt000_fa_verschoben      = "0"
            fa_verschoben_geaendertL = TRUE
        }
    }
    else if (rt000_aes == cAES_DELETE \
         ||  rt000_menge_neu == 0.0) {
        rt000_fa_verschoben      = "0"
        fa_verschoben_geaendertL = TRUE
    }

    log LOG_DEBUG, LOGFILE, "rt000_fa_verschoben >" ## rt000_fa_verschoben ## "< / " \
                         ## "fa_verschoben_geaendert >" ## fa_verschoben_geaendertL ## "< / " \
                         ## "setzen_fa_verschoben >" ## setzen_fa_verschobenL ## "<"
    return OK
}

/**
 * Stößt einen Austausch zum Fertigungsauftrag an
 *
 * @param handleP           Modul-Handle
 * @param fklzP             Fertigungsauftragsleitzahl
 * @param [transaktionP]    Transaktionsnummer des anzulegenden Aktionssatzes für die Bedarfsrechnung
 * @param [starten_bedrP]   Bedarfsrechnung direkt starten?
 * @param [ergebnisP]       CDT, in welches (bei Erfolg) Ergebnisdaten geschrieben werden
 * @return OK
 * @return FAILURE
 **/
int proc rt000_austauschen( \
    int handleP, \
    string fklzP, \
    string transaktionP, \
    boolean starten_bedrP, \
    ErgebnisRt000 ergebnisP \
) {
    int rcL
    boolean eigene_transL

    if (!defined(handleP)) {
        // Das Feld %s wurde nicht gesetzt (Methode %s, bsl-File %s)!
        call bu_msg("OBJ00100", "handleP^" ## md_session_get_property("PROC_NAME") ## "^rt000")
        return FAILURE
    }
    if (!defined(fklzP)) {
        // Das Feld %s wurde nicht gesetzt (Methode %s, bsl-File %s)!
        call bu_msg("OBJ00100", "fklzP^" ## md_session_get_property("PROC_NAME") ## "^rt000")
        return FAILURE
    }

    eigene_transL = !SQL_IN_TRANS
    if (eigene_transL) {
        if (bu_begin() != OK) {
            call bu_assert(FALSE)
        }
    }
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
    rcL = rt000_priv_austauschen(fklzP, transaktionP, starten_bedrP, ergebnisP)
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    if (eigene_transL) {
        if (rcL == OK) {
            call bu_commit()
        }
        else {
            call bu_rollback()
        }
    }
    if (rcL != OK) {
        return FAILURE
    }

    return OK
}
