
#-----------------------------------------------------------------------------------------------------------------------
# Modul Auftragsrückmeldung
#-----------------------------------------------------------------------------------------------------------------------
#
# Beschreibung:
# -------------
#
# Dieses Modul führt die Auftragsrückmeldung durch.
#
#
# Funktionen:
# -----------
#
# rt030_first_entry  Laden des LDB und Initialisierung
# rt030_entry
# rt030_exit
# rt030_last_exit    Abschließen und entfernen des LDB
#
# rt030_rueckmeldung Steuerfunktion der Auftragsrückmeldung
# rt030_daten_neu    Veränderte Daten an aufrufendes Programm senden
# rt030_protokoll    Direktaufruf der Protokollierung
#
#
# benutzte Variablen aus "appl.ldb"
# ----------------------------------
#
#
# Parameter:
# ----------
#
# handle      LDB-Handle zur Speicherung im rufenden Modul/Programm/Maske
#
# Bundles:
# --------
#
# rt030       Übergabe der Daten an die Funktionen
#
#
# LDB:
# ----
#
# rt030.ldb   enthält Daten für das gesamte Modul
#
#
# Aufgerufene Module:
# -------------------
#
# lm100        Buchungsmodul
# it000        Instandhaltungsmodul
# vt110r       Setzen Freigabestatus in Kundenauftragsposition
#
#-----------------------------------------------------------------------------------------------------------------------

include rt030i1.bsl

#-----------------------------------------------------------------------------------------------------------------------
# rt030_first_entry
#
# - Laden und aktivieren des LDB
# - Funktion "first_entry" der Module aufrufen
# - Deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_first_entry()
{
    vars handleL
    vars cdtTermGlobalL


    handleL = sm_ldb_load("rt030.ldb")
    if (handleL < OK) {
        return FAILURE
    }
    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, TRUE)

    name_cdtTermGlobal_rt030 = "cdtTermGlobalRt030_" ## handleL

    // Kontext Terminierungsmodul einmalig erzeugen
    public cdtTermGlobal.bsl
    cdtTermGlobalL = cdtTermGlobal_new(FALSE)
    unload cdtTermGlobal.bsl
    call boa_cdt_put(cdtTermGlobalL, name_cdtTermGlobal_rt030)


    rt030_lo_freig      = FALSE
    rt030_lo_freig_vers = FALSE

    // eigenes Handle sichern
    rt030_rt030_handle = handleL

    rt030_lt110_handle = NULL
    public lt110:(EXT)
    rt030_lt110_handle = lt110_first_entry("rt030_proto")
    if (rt030_lt110_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public it000:(EXT)
    rt030_it000_handle = it000_first_entry("rt030_proto")
    if (rt030_it000_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public vt110r:(EXT)
    rt030_vt110r_handle = vt110r_first_entry("2", "rt030_proto")
    if (rt030_vt110r_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    rt030_R_MATPR         = bu_getenv("R_MATPR")
    rt030_R_MATBUCH_START = bu_getenv("R_MATBUCH_START")

    rt030_R_BUSVA_ZUG_W = bu_getenv("R_BUSVA_ZUG_W")
    if (rt030_R_BUSVA_ZUG_W == NULL) {
        rt030_R_BUSVA_ZUG_W = R_BUSZUG_G
    }

    rt030_R_BUSVA_ZUG_F = bu_getenv("R_BUSVA_ZUG_F")
    if (rt030_R_BUSVA_ZUG_F == NULL) {
        rt030_R_BUSVA_ZUG_F = R_BUSZUG_G
    }

    g_chk_ts = bu_getenv("G_CHK_TS")

    rt030_R_REF_BUCHUNG = bu_getenv("R_REF_BUCHUNG")
    if (L_BEWERTUNG > "0") {
        rt030_R_REF_BUCHUNG = 1
    }

    R_DR_VERSRt030          = bu_getenv("R_DR_VERS")
    R_CHK_RUECKMELDEN_rt030 = bu_getenv("R_CHK_RUECKMELDEN")

    call bu_split(R_BUSVA_EIN_W, "stringtab", ";")
    busEinlagZiellagWRt030 = stringtab[1]
    busAuslagTPlagWRt030   = stringtab[2]

    call bu_split(R_BUSVA_EIN_F, "stringtab", ";")
    busEinlagZiellagFRt030 = stringtab[1]
    busAuslagTPlagFRt030   = stringtab[2]

    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)

    return handleL
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_entry
#
# - Funktion "entry" der Module aufrufen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_entry(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    public lt110:(EXT)
    call lt110_entry(rt030_lt110_handle)

    public it000:(EXT)
    call it000_entry(rt030_it000_handle)

    public vt110r:(EXT)
    call vt110r_entry(rt030_vt110r_handle)

    if (rt030_dt810_handle != NULL) {
        public dt810:(EXT)
        call dt810_entry(rt030_dt810_handle)
    }
    if (rt030_dt800_handle != NULL) {
        public dt800:(EXT)
        call dt800_entry(rt030_dt800_handle)
    }

    if (rt030_rt822_handle > 0) {
        public rt822:(EXT)
        call rt822_exit(rt030_rt822_handle)
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_exit
#
# - Funktion "exit" der Module aufrufen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_exit(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    public lt110:(EXT)
    call lt110_exit(rt030_lt110_handle)

    public it000:(EXT)
    call it000_exit(rt030_it000_handle)

    public vt110r:(EXT)
    call vt110r_exit(rt030_vt110r_handle)

    if (rt030_dt810_handle != NULL) {
        public dt810:(EXT)
        call dt810_exit(rt030_dt810_handle)
    }
    if (rt030_dt800_handle != NULL) {
        public dt800:(EXT)
        call dt800_exit(rt030_dt800_handle)
    }

    if (rt030_rt822_handle > 0) {
        public rt822:(EXT)
        call rt822_entry(rt030_rt822_handle)
    }

    // Start Auftragsfreigabe
    if (rt030_lo_freig == TRUE) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        call rt030_start_freigabe()
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
        rt030_lo_freig = FALSE
    }

    // Start Auftragsfreigabe Versorgung
    if (rt030_lo_freig_vers == TRUE) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        call rt030_start_freigabe_vers()
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
        rt030_lo_freig_vers = FALSE
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_last_exit(handleP)
#
# - Funktion "last_exit" der Module aufrufen
# - deaktivieren und entladen des LDB
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_last_exit(handleP)
{
    int i1L
    string kontext_cacheL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    unload ri070.bsl
    unload ri000.bsl

    call bu_unload_tmodul("rt822", rt030_rt822_handle)
    rt030_rt822_handle = NULL

    public lt110:(EXT)
    call lt110_last_exit(rt030_lt110_handle)
    unload lt110:(EXT)
    rt030_lt110_handle = NULL

    public it000:(EXT)
    call it000_last_exit(rt030_it000_handle)
    unload it000:(EXT)
    rt030_it000_handle = NULL

    public vt110r:(EXT)
    call vt110r_last_exit(rt030_vt110r_handle)
#   unload vt110r:(EXT)
    rt030_vt110r_handle = NULL

    if (rt030_dt810_handle != NULL) {
        public dt810:(EXT)
        call dt810_last_exit(rt030_dt810_handle)
        unload dt810:(EXT)
        rt030_dt810_handle = NULL
    }

    if (rt030_dt800_handle != NULL) {
        public dt800:(EXT)
        call dt800_last_exit(rt030_dt800_handle)
        unload dt800:(EXT)
        rt030_dt800_handle = NULL
    }

    if (rt030_handle_lm100 > 0) {
        public lm100.bsl
        call   lm100_unload(rt030_handle_lm100)
        unload lm100.bsl
        rt030_handle_lm100 = NULL
    }

    if (rm121_handleRt030 > 0) {
        public rm121.bsl
        call rm121_unload(rm121_handleRt030)
        unload rm121.bsl
        rm121_handleRt030 = NULL
    }

    // Autom. Start Nettobedarfsrechnung, wenn R_START_NETTOBEDARF = "1"
    call fertig_start_rh1004()

    // Kalendermodul entladen
    call bu_unload_modul("gm300", rt030_handle_gm300)
    rt030_handle_gm300 = NULL

    call fertig_unload_modul("rm131", rm131_handleRt030)
    rm131_handleRt030 = NULL

    for i1L = 1 while (i1L <= cursorRt030->num_occurrences) step 1 {
        if (dm_is_cursor(cursorRt030[i1L]) == TRUE) {
            dbms close cursor :(cursorRt030[i1L])
        }
    }

    public rq1004.bsl
    call verknuepfungRq1004Unload()
    unload rq1004.bsl

    kontext_cacheL = name_cdtTermGlobal_rt030
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    // q-Module der Terminierung entladen
    call fertig_unload_terminierungsmodule($NULL, kontext_cacheL)

    call sm_ldb_h_unload(handleP)
    return OK
}

/**
 * Prüfungen zur Auftragsrückmeldung
 *
 * Wenn bei oder nach dem Buchen ein Fehler auftritt, werden bereits durchgeführte Buchungen manuell zurückgefahren
 *
 * @param handleP               Eigenes Handle
 * @return OK
 * @return WARNING              Logicher Fehler
 *                              Fehlermeldung steht in "msg_text"
 * @return FAILURE              Fehler (mit Rollback)
 *                              Fehlermeldung steht in "msg_text"
 **/
int proc rt030_fa_pruefen(handleP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // Initialisieren der Daten
    call rt030_init()

    // Übergabedaten empfangen
    call rt030_bundle()

    // Status-LineMeldung ausgeben
    call rt030_meldung_ag_rueckm_durchfuehren()

    // Fertigungsauftrag lesen
    rcL = rt030_lesen_r000()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Kalendermodul aktivieren
    if (rt030_load_gm300(fi_nr, rt030_werk_r000) != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return FAILURE
    }

    // Teilestamm lesen
    rcL = rt030_lesen_g000()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Versorgungsstruktur lesen
    if (cod_aart_versorg(rt030_aart) == TRUE) {
        rcL = rt030_lesen_d700()
        if (rcL != OK) {
            dbms close cursor lock_r000_rt030C
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }

        // Prüfen/Lesen Komm-Listen-Daten
        call rt030_lesen_l820()
    }
    else {
        rt030_kn_tplager = "0"
    }

    // Prüfungen durchführen
    rcL = rt030_pruefen()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    dbms close cursor lock_r000_rt030C
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    msg d_msg ""

    return OK
}

/**
 * Steuerung der Auftragsrückmeldung
 *
 * Wenn bei oder nach dem Buchen ein Fehler auftritt, werden bereits durchgeführte Buchungen manuell zurückgefahren
 *
 * @param handleP                   Eigenes Handle
 * @param pruefen_anlegen_seriennrP Übergebene Seriennummern prüfen und anlegen, wenn nicht vorhanden?
 * @return OK
 * @return WARNING                  Logicher Fehler
 *                                  Fehlermeldung steht in "msg_text"
 * @return FAILURE                  Fehler (mit Rollback)
 *                                  Fehlermeldung steht in "msg_text"
 **/
int proc rt030_rueckmeldung(handleP, boolean pruefen_anlegen_seriennrP)
{
    int  rcL
    vars cdtLq040L

    log LOG_DEBUG, LOGFILE, "Seriennummern prüfen und anlegen >" ## pruefen_anlegen_seriennrP ## "<"

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // Initialisieren der Daten
    call rt030_init()

    // Übergabedaten empfangen
    call rt030_bundle()

    // Status-LineMeldung ausgeben
    call rt030_meldung_ag_rueckm_durchfuehren()

    // Fertigungsauftrag lesen
    rcL = rt030_lesen_r000()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Kalendermodul aktivieren
    if (rt030_load_gm300(fi_nr, rt030_werk_r000) != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return FAILURE
    }

    // Teilestamm lesen
    rcL = rt030_lesen_g000()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Versorgungsstruktur lesen
    if (cod_aart_versorg(rt030_aart) == TRUE) {
        rcL = rt030_lesen_d700()
        if (rcL != OK) {
            dbms close cursor lock_r000_rt030C
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }

        // Prüfen/Lesen Komm-Listen-Daten
        call rt030_lesen_l820()
    }
    else {
        rt030_kn_tplager = "0"
    }

    // Prüfungen durchführen
    rcL = rt030_pruefen()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    if (pruefen_anlegen_seriennrP) {
        if (rt030i1_pruefen_anlegen_seriennr() != OK) {
            dbms close cursor lock_r000_rt030C
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return FAILURE
        }
    }

    // Wurde keine gueltige Charge (Charge = NULL) im Bundle uebergeben, wird dafür ein neuer Chargenstamm angelegt und
    // die Charge wird nicht aus r000 gelesen. Dies darf aber nur bei chargenpflichtigen Teilen geschehen (nicht bei
    // Chargensplit). Und auch nur dann, wenn die gemeldete Menge > 0 ist. Ausgenommen bei Versorgungsvorschlägen.
    // Da darf keine neue Chargennummer generiert werden.
    if ( \
        rt030_charge == NULL && \
        cod_chargen_pflicht(rt030_chargen_pflicht) == TRUE && \
        rt030_menge_meld > 0 && \
        !cod_aart_versorg(rt030_aart) \
    ) {
        cdtLq040L = lq040_new()
        call rt030_send_lq040(cdtLq040L)
        if (cdtLq040L=>charge != "") {
            if (lq040_chargenstamm_anlegen(cdtLq040L) != OK) {
                // Chargenstammes wurde nicht angelegt
                call on_error(FAILURE, "l0400024", "", "rt030_proto_kb")
                dbms close cursor lock_r000_rt030C
                call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
                msg d_msg ""
                return FAILURE
            }
        }
        else {
            if (lq040_chargengenerierung(cdtLq040L, TRUE)!= OK) {   // include lq040 ist im lager.bsl
                // Beim automatischen Generieren des Chargenstammes trat ein Fehler auf!
                call on_error(FAILURE, "l0400137", "", "rt030_proto_kb")
                dbms close cursor lock_r000_rt030C
                call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
                msg d_msg ""
                return FAILURE
            }
        }
        call rt030_receive_lq040(cdtLq040L)

        // Chargenstamm automatisch generiert - Chargen-Nr: %s
        call on_error(INFO, "l0400138", rt030_charge, "rt030_proto")
    }

    // Berechnung der geplanten und der ungeplanten Menge
    rcL = rt030_mengen_ermittlung()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Storno Entnahmebuchung über rm131, muss vor dem Storno der Zugangsbuchung erfolgen
    if ( \
        rt030_fu_farm == "1" || \
        rt030_fu_farm == "2" || \
        rt030_fu_farm == "9" \
    ) {
        rcL = rt030_call_rm131("1")
        if (rcL != OK) {
            dbms close cursor lock_r000_rt030C
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }
    }

    // Lagerbuchung durchführen
    rcL = rt030_st_buchen()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Instandhaltungsdaten aktualisieren bei Instandhaltungsaufträgen
    rcL = rt030_instandhaltung()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Update auf Fertigungsauftrag durchführen
    rcL = rt030_update_r000()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Bestellbestand aktualisieren
    rcL = rt030_update_g020()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Neue Freigabeabhandlung - "3" - automatische Freigabe über die übergeordnete Auftragsstruktur
    if ( \
        rt030_freigabe == "3" && \
        rt030_fkfs     == FSTATUS_FERTIG && \
        ( \
            rt030_aart == "0" || \
            rt030_aart == "9" \
        ) \
    ) {
        rcL = rt030_uebg_freigeben()
        if (rcL != OK) {
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }
    }

    // Satz in die Aktionstabelle r035 (Sammelrückmeldung) abstellen
    rcL = rt030_insert_r035()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Satz in die Aktionstabelle r045 (Auftragsabrechnung) abstellen
    rcL = rt030_auftragsabrechnung()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Kanbanauftragsdaten aktualisieren
    rcL = rt030_set_kanban()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Freigabestatus in Kundenauftragsposition aktualisieren
    rcL = rt030_uebg()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Fortschreiben Kostenträgerstatus bei Fertigmeldung oder Storno Fertigmeldung
    if ( \
        rt030_fu_farm == "7" || \
        rt030_fu_farm == "8" || \
        rt030_fu_farm == "1" || \
        rt030_fu_farm == "2" \
    ) {
        rcL = rt030_set_ktr_status()
        if (rcL != OK) {
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }
    }

    rcL = rt030_reservierung_bedarf()
    if (rcL < OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        msg d_msg ""
        return rcL
    }

    // Durchführung Entnahmebuchung über rm131, nach Zugangsbuchung
    if ( \
        rt030_fu_farm  >= "6" && \
        rt030_fu_farm  <= "8" \
    ) {
        rcL = rt030_call_rm131("0")
        if (rcL != OK) {
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }
    }

    // Satz in die Protokolltabelle r036 abstellen
    if (prt_ok == TRUE) {
        // Initialisierung der globalen Message-Felder für die OK-Meldung
        call fertig_fehler_init_globale_felder(TRUE)

        rcL = rt030_proto(OK, PRT_CTRL_OK, $NULL, $NULL)
        if (rcL != OK) {
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            msg d_msg ""
            return rcL
        }
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    msg d_msg NULL

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_daten_neu
#
# Veränderte Daten an re030 senden
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_daten_neu(handleP)
{
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    send bundle "b_rt030_s" data \
        rt030_fkfs, \
        rt030_menge_gef, \
        rt030_menge_offen, \
        rt030_charge

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_protokoll(handleP)
#
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_protokoll(handleP, prt_ctrlP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    // Übergabedaten empfangen
    call rt030_bundle()

    // Fertigungsauftrag lesen
    rcL = rt030_protokoll_lesen_r000()
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    if (rt030_proto($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_init
#
# - Initialisieren der Daten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_init()
{
    rt030_komm_nr         = NULL
    rt030_bearb           = NULL

    rt030_menge_geplant   = 0
    rt030_menge_ungeplant = 0

    rt030_kn_tplager      = "0"
    rt030_werk_tp         = 0
    rt030_lgnr_tp         = 0

    rt030_bunr_gepl       = NULL

    rt030_vv_nr           = NULL

    call fertig_fehler_init_globale_felder(FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_bundle
#
# - Übergabedaten empfangen und in LDB laden
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_bundle()
{
    vars bu_datL


    receive bundle "b_rt030" data \
        rt030_fu_farm, \
        rt030_art_farm, \
        rt030_nr, \
        rt030_fklz, \
        rt030_menge_meld, \
        rt030_matoffen, \
        rt030_agoffen, \
        rt030_nboffen, \
        rt030_bu_monat, \
        bu_datL, \
        rt030_kostst, \
        rt030_kosttraeger, \
        rt030_lgnr, \
        rt030_lgber, \
        rt030_lgfach, \
        rt030_charge, \
        rt030_lg_dat, \
        rt030_reservnr, \
        rt030_fu_matrm, \
        rt030_fu_agrm, \
        rt030_schad_code_meld, \
        rt030_ausfzeit, \
        rt030_meih_zt, \
        rt030_seriennr, \
        rt030_vv_nr, \
        rt030_bunr_meld, \
        etikettRt030

    // Empfangenen String in formatierte LDB-Variable umladen
    rt030_bu_dat = bu_datL

    call sm_n_1clear_array("rt030_seriennr_buch")
    call sm_n_1clear_array("rt030_seriennr_gebucht")

    // Empfangen R_MATBUCH_DIALOG an rt030, wird nur von re030 gesendet!
    if (sm_is_bundle("b_rt030_matb_dir") == TRUE) {
        receive bundle "b_rt030_matb_dir" data rt030_R_MATBUCH_DIALOG
    }
    else {
        rt030_R_MATBUCH_DIALOG = "2"
    }

    call sm_n_clear_array("rt030_charge_uml")
    call sm_n_1clear_array("rt030_menge_uml")
    call sm_n_1clear_array("rt030_wert_uml")

    if (sm_is_bundle("b_rt030_umlagerung") == TRUE) {
        receive bundle "b_rt030_umlagerung" data \
            rt030_charge_uml, \
            rt030_menge_uml
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_lesen_r000
#
# - Fertigungsauftrag lesen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_lesen_r000()
{
    string in_nopseudoL


    // Alle Auftragsarten, ausgenommen Pseudoaufträge
    in_nopseudoL = cod_aart_in("nopseudo")

    dbms declare lock_r000_rt030C cursor for \
        select \
            r000.fkfs, \
            r000.menge, \
            r000.menge_gef, \
            r000.menge_offen, \
            r000.matbuch, \
            r000.disstufe, \
            r000.aart, \
            r000.fsterm_uhr, \
            r000.seterm_uhr, \
            r000.fortsetz_uhr, \
            r000.seterm, \
            r000.dlzeit, \
            r000.vzag, \
            r000.freigabe, \
            r000.identnr, \
            r000.var, \
            r000.aufnr, \
            r000.aufpos, \
            r000.servicenr, \
            r000.schad_code, \
            r000.bs, \
            r000.da, \
            r000.ch, \
            r000.chargen_pflicht,\
            r000.lgnr, \
            r000.werk, \
            r000.kanbannr, \
            r000.kanbananfnr, \
            r000.aendind, \
            r000.kdidentnr, \
            r000.kn_tplager \
        from \
            r000 :MSSQL_FOR_UPDATE \
        where \
            r000.fi_nr = :+FI_NR1      and \
            r000.fklz  = :+rt030_fklz  and \
            r000.aart    :in_nopseudoL \
        :FOR_UPDATE
    dbms with cursor lock_r000_rt030C alias \
        rt030_fkfs, \
        rt030_menge, \
        rt030_menge_gef, \
        rt030_menge_offen, \
        rt030_matbuch, \
        rt030_disstufe, \
        rt030_aart, \
        rt030_fsterm_uhr, \
        rt030_seterm_uhr, \
        rt030_fortsetz_uhr, \
        rt030_seterm, \
        rt030_dlzeit, \
        rt030_vzag, \
        rt030_freigabe, \
        rt030_identnr, \
        rt030_var, \
        rt030_aufnr, \
        rt030_aufpos, \
        rt030_servicenr, \
        rt030_schad_code, \
        rt030_bs, \
        rt030_da, \
        rt030_ch, \
        rt030_chargen_pflicht, \
        rt030_lgnr_r000, \
        rt030_werk_r000, \
        rt030_kanbannr, \
        rt030_kanbananfnr, \
        rt030_aendind, \
        rt030_kdidentnr, \
        rt030_kn_tplager
    dbms with cursor lock_r000_rt030C execute
    dbms with cursor lock_r000_rt030C alias

    if (SQL_CODE == SQLNOTFOUND) {
        dbms close cursor lock_r000_rt030C
        // Fertigungsauftrag %s nicht vorhanden
        return on_error(FAILURE, "r0000000", rt030_fklz, "rt030_proto")
    }

    if (SQL_CODE == SQLE_ROWLOCKED) {
        dbms close cursor lock_r000_rt030C
        // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
        return on_error(WARNING, "r0000002", rt030_fklz, "rt030_proto")
    }

    if (SQL_CODE != SQL_OK) {
        dbms close cursor lock_r000_rt030C
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "r000", "rt030_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_lesen_d700
#
# - Versorgungsstruktur lesen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_lesen_d700()
{
    vars dummyL


    if (dm_is_cursor("sel_r100_4_rt030C") != TRUE) {
        dbms declare sel_r100_4_rt030C cursor for \
            select \
                r100.werk, \
                r100.lgnr \
            from \
                r100 \
            where \
                r100.fi_nr = ::_1 and \
                r100.fklz  = ::_2

        cursorRt030[++] = "sel_r100_4_rt030C"
    }
    dbms with cursor sel_r100_4_rt030C alias \
        rt030_werk_r100, \
        rt030_lgnr_r100
    dbms with cursor sel_r100_4_rt030C execute using \
        FI_NR1, \
        rt030_fklz
    dbms with cursor sel_r100_4_rt030C alias

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "r100", "rt030_proto")
    }

    // Parameter R_VM_INTRANS_W/F übersteuern rt030_kn_tplager
    if ( \
        ( \
            R_VM_INTRANS_W  != "1"             && \
            rt030_werk_r100 == rt030_werk_r000 \
        ) || \
        ( \
            R_VM_INTRANS_F  != "1"             && \
            rt030_werk_r100 != rt030_werk_r000 \
        ) \
    ) {
        rt030_kn_tplager = "0"
        return OK
    }

    if (rt030_werk_r100 == rt030_werk_r000) {
        rt030_bus_tpein = busEinlagZiellagWRt030
        rt030_bus_tpaus = busAuslagTPlagWRt030
    }
    else {
        rt030_bus_tpein = busEinlagZiellagFRt030
        rt030_bus_tpaus = busAuslagTPlagFRt030
    }

    if (rt030_kn_tplager <= "0") {
        rt030_kn_tplager = "0"
        return OK
    }

    if (dm_is_cursor("sel_b120_rt030C") != TRUE) {
        dbms declare sel_b120_rt030C cursor for \
            select \
                1, \
                b120.lgnr, \
                b120.lgber, \
                b120.lgfach \
            from \
                b120, \
                l900 \
            where \
                b120.fi_nr        = ::_1       and \
                b120.fi_nr_q      = b120.fi_nr and \
                b120.werk_q       = ::_2       and \
                b120.werk         = ::_3       and \
                b120.lgnr_q       = ::_4       and \
                l900.fi_nr        = b120.fi_nr and \
                l900.lgnr         = b120.lgnr  and \
                l900.kn_lgnurvers = '1' \
            union all \
            select \
                2, \
                b120.lgnr, \
                b120.lgber, \
                b120.lgfach \
            from \
                b120, \
                l900 \
            where \
                b120.fi_nr        = ::_5       and \
                b120.fi_nr_q      = b120.fi_nr and \
                b120.werk_q       = ::_6       and \
                b120.werk         = ::_7       and \
                b120.lgnr_q       = -1         and \
                l900.fi_nr        = b120.fi_nr and \
                l900.lgnr         = b120.lgnr  and \
                l900.kn_lgnurvers = '1' \
            order by \
                1

        cursorRt030[++] = "sel_b120_rt030C"
    }

    dbms with cursor sel_b120_rt030C alias \
        dummyL, \
        rt030_lgnr_tp, \
        rt030_lgber_tp, \
        rt030_lgfach_tp
    dbms with cursor sel_b120_rt030C execute using \
        FI_NR1, \
        rt030_werk_r100, \
        rt030_werk_r000, \
        rt030_lgnr_r100, \
        FI_NR1, \
        rt030_werk_r100, \
        rt030_werk_r000
    dbms with cursor sel_b120_rt030C alias

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLNOTFOUND:
            rt030_kn_tplager = "0"
            break
        else:
            // Fehler beim Lesen in Tabelle %s
            return on_error(FAILURE, "APPL0006", "b120", "rt030_proto")
    }

    switch (rt030_kn_tplager) {
        case "0":
            break
        case "1":
            rt030_werk_tp = rt030_werk_r100
            break
        case "2":
            rt030_werk_tp = rt030_werk_r000
            break
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_lesen_l820
#
# - Lesen Daten zur Kommissionier-Liste
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_lesen_l820()
{
    if (dm_is_cursor("sel_l82010_rt030C") != TRUE) {
        dbms declare sel_l82010_rt030C cursor for \
            select \
                l82010.komm_nr, \
                l82010.sb_schl \
            from \
                r100, \
                l82010 \
            where \
                r100.fklz     = ::_1 and \
                r100.fi_nr    = ::_2 and \
                r100.pos_herk = :+cPOSHERK_VERSORG and \
                l82010.fmlz   = r100.fmlz and \
                l82010.fi_nr  = r100.fi_nr

        cursorRt030[++] = "sel_l82010_rt030C"
    }

    dbms with cursor sel_l82010_rt030C alias \
        rt030_komm_nr, \
        rt030_bearb
    dbms with cursor sel_l82010_rt030C execute using \
        rt030_fklz, \
        FI_NR1
    dbms with cursor sel_l82010_rt030C alias

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_lesen_g000
#
# - Bestandsmaßeinheit lesen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_lesen_g000()
{
    if (dm_is_cursor("sel_g030_rt030C") != TRUE) {
        dbms declare sel_g030_rt030C cursor for \
            select \
                g000.me, \
                g000.kn_variant, \
                g030.pe, \
                g030.prodgr, \
                g030.wgr, \
                g000.serien_pflicht \
            from \
                g000, \
                g030, \
                g023 \
            where \
                g000.fi_nr    = ::_1         and \
                g000.identnr  = ::_2         and \
                g030.fi_nr    = ::_3         and \
                g030.identnr  = g000.identnr and \
                g023.fi_nr    = g030.fi_nr   and \
                g023.werk     = ::_4         and \
                g023.identnr  = g030.identnr and \
                g023.var      = ::_5

        cursorRt030[++] = "sel_g030_rt030C"
    }
    dbms with cursor sel_g030_rt030C alias \
        rt030_me, \
        rt030_kn_variant, \
        rt030_pe, \
        rt030_prodgr, \
        rt030_wgr, \
        rt030_serien_pflicht
    dbms with cursor sel_g030_rt030C execute using \
        FI_G000, \
        rt030_identnr, \
        FI_NR1, \
        rt030_werk_r000, \
        rt030_var
    dbms with cursor sel_g030_rt030C alias

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLNOTFOUND:
            // Passende Meldung generieren
            call Cidentnr_varPi(rt030_identnr, rt030_var, NULL, rt030_werk_r000, TRUE)
            return on_error(FAILURE, NULL, NULL, "rt030_proto")
        else:
            // Fehler beim Lesen in Tabelle %s
            return on_error(FAILURE, "APPL0006", "g000", "rt030_proto")
    }

    if (dm_is_cursor("sel_g020_rt030C") != TRUE) {
        dbms declare sel_g020_rt030C cursor for \
            select \
                g043.agr, \
                g020.konto, \
                g020.abc, \
                g020.kn_lagereinheit, \
                g020.kn_lgdisp \
            from \
                g020, \
                g043 \
            where \
                g020.fi_nr   = ::_1         and \
                g020.werk    = ::_2         and \
                g020.lgnr    = ::_3         and \
                g020.identnr = ::_4         and \
                g020.var     = ::_5         and \
                g043.fi_nr   = g020.fi_nr   and \
                g043.identnr = g020.identnr and \
                g043.var     = g020.var

        cursorRt030[++] = "sel_g020_rt030C"
    }
    dbms with cursor sel_g020_rt030C alias \
        rt030_agr, \
        rt030_konto, \
        rt030_abc, \
        rt030_kn_lagereinheit, \
        kn_lgdispRt030
    dbms with cursor sel_g020_rt030C execute using \
        FI_NR1, \
        rt030_werk_r000, \
        rt030_lgnr_r000, \
        rt030_identnr, \
        rt030_var
    dbms with cursor sel_g020_rt030C alias

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLNOTFOUND:
            // Teile-/Variantenstamm >%1< für Lager >%2< des Standortes >%3< in Firma >%4< nicht vorhanden
            return on_error( \
                FAILURE, \
                "g0200000", \
                rt030_identnr ## " " ## rt030_var ## "^" ## rt030_lgnr_r000 ## "^" ## rt030_werk_r000 ## "^" ## FI_NR1,\
                "rt030_proto" \
            )
        else:
            // Fehler beim Lesen in Tabelle %s
            return on_error(FAILURE, "APPL0006", "g020", "rt030_proto")
    }

    // Bei Kanban prüfen, ob das Etikett ermittelt werden muss
    if ( \
        rt030_kanbannr                                                 != NULL && \
        etikettRt030                                                   == NULL && \
        lager_mll_behaelter(rt030_identnr, rt030_var, rt030_lgnr_r000) == TRUE \
    ) {
        if (dm_is_cursor("sel_d800_1_rt030C") != TRUE) {
            dbms declare sel_d800_1_rt030C cursor for \
                select \
                    d800.etikett_layout \
                from \
                    d800 \
                where \
                    d800.fi_nr    = ::_1 and \
                    d800.kanbannr = ::_2

            cursorRt030[++] = "sel_d800_1_rt030C"
        }
        dbms with cursor sel_d800_1_rt030C alias etikett_layoutRt030
        dbms with cursor sel_d800_1_rt030C execute using \
            FI_NR1, \
            rt030_kanbannr
        dbms with cursor sel_d800_1_rt030C alias

        if (etikett_layoutRt030 != NULL) {
            etikettRt030 = rt030_kanbannr ## rt030_kanbananfnr
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_protokoll_lesen_r000
#
# - Fertigungsauftrag lesen für reine Protokollierung
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_protokoll_lesen_r000()
{
    vars in_nopseudoL


    // Alle Auftragsarten, ausgenommen Pseudoaufträge
    in_nopseudoL = cod_aart_in("nopseudo")

    if (dm_is_cursor("sel_r000_1_rt030C") != TRUE) {
        dbms declare sel_r000_1_rt030C cursor for \
            select \
                r000.fkfs, \
                r000.menge, \
                r000.menge_gef, \
                r000.menge_offen, \
                r000.matbuch, \
                r000.disstufe, \
                r000.aart, \
                r000.fsterm_uhr, \
                r000.seterm_uhr, \
                r000.fortsetz_uhr, \
                r000.seterm, \
                r000.dlzeit, \
                r000.vzag, \
                r000.freigabe, \
                r000.identnr, \
                r000.var, \
                r000.aufnr, \
                r000.aufpos \
            from \
                r000 \
            where \
                r000.fi_nr = ::_1 and \
                r000.fklz  = ::_2 and \
                r000.aart    :in_nopseudoL

        cursorRt030[++] = "sel_r000_1_rt030C"
    }
    dbms with cursor sel_r000_1_rt030C alias \
        rt030_fkfs, \
        rt030_menge, \
        rt030_menge_gef, \
        rt030_menge_offen, \
        rt030_matbuch, \
        rt030_disstufe, \
        rt030_aart, \
        rt030_fsterm_uhr, \
        rt030_seterm_uhr, \
        rt030_fortsetz_uhr, \
        rt030_seterm, \
        rt030_dlzeit, \
        rt030_vzag, \
        rt030_freigabe, \
        rt030_identnr, \
        rt030_var, \
        rt030_aufnr, \
        rt030_aufpos
    dbms with cursor sel_r000_1_rt030C execute using \
        FI_NR1, \
        rt030_fklz
    dbms with cursor sel_r000_1_rt030C alias

    if ( \
        SQL_CODE != SQL_OK      && \
        SQL_CODE != SQLNOTFOUND \
    ) {
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "r000", "rt030_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_pruefen
#
# - Durchführung der Prüfungen für die Auftragsrückmeldungen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_pruefen()
{
    int rcL

    log LOG_DEBUG, LOGFILE, ""

    if (rt030_pruefe_ts() != OK) {
        return FAILURE
    }

    // Prüfen "fu_farm"
    if ( \
        rt030_fu_farm != "1" && \
        rt030_fu_farm != "2" && \
        rt030_fu_farm != "5" && \
        rt030_fu_farm != "6" && \
        rt030_fu_farm != "7" && \
        rt030_fu_farm != "8" && \
        rt030_fu_farm != "9" \
    ) {
        // Falscher Funktionscode bei Aufruf Modul %s
        return on_error(FAILURE, "ral00901", "rt030", "rt030_proto_kb")
    }

    rt030_menge_meld = chk_ganzzahlig(rt030_me, rt030_menge_meld)

    if (rt030_fkfs == FSTATUS_SIM) {
        // Der Status des Fertigungsauftrags darf nicht 0 sein!
        return on_error(FAILURE, "r0000233", "", "rt030_proto_kb")
    }

    if (rt030_fkfs == FSTATUS_AUSGESETZT) {
        // Der Status des Fertigungsauftrags darf nicht 2 sein!
        return on_error(FAILURE, "r0000234", "", "rt030_proto_kb")
    }

    if (rt030_fkfs < FSTATUS_FREIGEGEBEN || rt030_fkfs > FSTATUS_FERTIG) {
        // Der Status des Fertigungsauftrags muss zwischen 4 und 7 sein!
        return on_error(FAILURE, "r0000203", "", "rt030_proto_kb")
    }

    // Wenn der FA gelöscht werden soll, wird die Menge = 0 gesetzt und für die Bedarfsrechnung ein Aktionssatz zum
    // Stornieren/Löschen abgestellt. Dann darf auch ein Rückmelden nicht mehr erfolgen!
    if (rt030_menge == 0) {
        // Fertigungsauftrag bereits storniert --> Bedarfsrechnung starten
        return on_error(FAILURE, "r0000125", "", "rt030_proto_kb")
    }

    switch (rt030_fu_farm) {
        case "1":
        case "9":
            if (rt030_fkfs < FSTATUS_ANGEARBEITET || rt030_fkfs > FSTATUS_FERTIG) {
                // Der Status des Fertigungsauftrags muss zwischen 6 und 7 sein!
                return on_error(WARNING, "r0000204", "", "rt030_proto_kb")
            }
            if (rt030_menge_meld > rt030_menge_gef) {
                // Es kann max. die gefertigte Menge %s storniert werden!
                return on_error(WARNING, "r0000206", rt030_menge_gef, "rt030_proto_kb")
            }
            break
        case "2":
            if (rt030_fkfs < FSTATUS_BEGONNEN|| rt030_fkfs > FSTATUS_FERTIG) {
                // Todo JK: Meldung passt nicht zur Prüfung!
                // Der Status des Fertigungsauftrags muss zwischen 6 und 7 sein!
                return on_error(WARNING, "r0000204", "", "rt030_proto_kb")
            }
            // Die zu stornierende Menge wird mit der bisher zurückgemeldeten Menge gefüllt
            rt030_menge_meld = rt030_menge_gef
            break
        case "7":
            if (rt030_fkfs < FSTATUS_FREIGEGEBEN || rt030_fkfs > FSTATUS_ANGEARBEITET) {
                // Der Status des Fertigungsauftrags muss zwischen 4 und 6 sein!
                return on_error(WARNING, "r0000205", "", "rt030_proto_kb")
            }
            break
        case "8":
            if (rt030_fkfs < FSTATUS_FREIGEGEBEN || rt030_fkfs > FSTATUS_ANGEARBEITET) {
                // Der Status des Fertigungsauftrags muss zwischen 4 und 6 sein!
                return on_error(WARNING, "r0000205", "", "rt030_proto_kb")
            }
            // Die freizugebende Menge wird mit der offenen Menge gefüllt
            rt030_menge_meld = rt030_menge_offen
            break
    }

    if (fertig_fa_bedarfsrechnung_notwendig(rt030_fklz, R_CHK_RUECKMELDEN_rt030) == TRUE) {
        // Eine Rückmeldung zum Fertigungsauftrag <%1> ist aktuell nicht möglich,
        // da für diesen noch ein Aktionssatz zur Bedarfsrechnung anliegt.
        return on_error(WARNING, "r0000255", rt030_fklz, "rt030_proto_kb")
    }
    if (fertig_fa_freigabe_in_stornierung(rt030_fklz) == TRUE) {
        // Eine Rückmeldung zum Fertigungsauftrag <%1> ist aktuell nicht möglich,
        // da für diesen noch ein Aktionssatz zur Stornierung der Fertigungsfreigabe anliegt.
        return on_error(WARNING, "r0000256", rt030_fklz, "rt030_proto_kb")
    }
    if (fertig_fa_papiere_im_druck(rt030_fklz, R_CHK_RUECKMELDEN_rt030) == TRUE) {
        // Eine Rückmeldung zum Fertigungsauftrag <%1> ist aktuell nicht möglich,
        // da noch ein Druck der Fertigungspapiere anliegt.
        return on_error(WARNING, "r0000254", rt030_fklz, "rt030_proto_kb")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_mengen_ermittlung
#
# - Ermittlung der geplanten und der ungeplanten Menge
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_mengen_ermittlung()
{
    switch (rt030_fu_farm) {
        case "6":
        case "7":
        case "8":
            // Kein Storno
            if (rt030_menge_gef >= rt030_menge) {
                rt030_menge_ungeplant = rt030_menge_meld
            }
            else if (rt030_menge_gef + rt030_menge_meld > rt030_menge) {
                rt030_menge_ungeplant = rt030_menge_gef + rt030_menge_meld - rt030_menge
            }
            else {
                rt030_menge_ungeplant = 0
            }
            rt030_menge_geplant = rt030_menge_meld - rt030_menge_ungeplant
            break
        case "1":
        case "2":
        case "9":
            // Storno
            if (rt030_menge_gef - rt030_menge_meld >= rt030_menge) {
                rt030_menge_ungeplant = rt030_menge_meld
            }
            else if (rt030_menge_gef <= rt030_menge) {
                rt030_menge_ungeplant = 0
            }
            else {
                // 300149352
                if (rt030_bunr_meld <= 0) {
                    rt030_menge_ungeplant = rt030_menge_gef - rt030_menge
                }
                else {
                    rt030_menge_ungeplant = 0
                }
            }
            rt030_menge_geplant = rt030_menge_meld - rt030_menge_ungeplant
            break
        case "5":
            // Beginnmeldung
            rt030_menge_meld = 0
            break
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_st_buchen
#
# Steuerung der Durchführung der Lagerbuchung :
# - Für die Durchführung einer geplanten bzw. ungeplanten Lagerbuchung muss die geplante bzw. die ungeplante Menge
#   größer als Null sein.
# - Für einen evtl. notwendig werdenden manuellen Rollback werden die entprechenden Flags gesetzt.
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_st_buchen()
{
    int rcL


    // Ohne eine Eingabemenge werden keine Lagerbuchungen ausgelöst.
    if (rt030_menge_meld == 0.0) {
        return OK
    }

    // Dito bei Instandhaltungsaufträgen.
    if (rt030_aart == "8") {
        return OK
    }

    call sm_n_clear_array("bunr_resRt030")

    // Flags initialisieren
    rt030_lo_buch_g  = FALSE
    rt030_lo_buch_ug = FALSE

    if ( \
        rt030_fu_farm == "1" || \
        rt030_fu_farm == "2" || \
        rt030_fu_farm == "9" \
    ) {
        rt030_storno = "1"

        // Durchführung der ungeplanten Buchung
        if (rt030_menge_ungeplant > 0) {
            if (rt030_kn_tplager != "1") {
                if (cod_aart_versorg(rt030_aart) == TRUE) {
                    if (rt030_werk_r100 == rt030_werk_r000) {
                        rt030_bus = rt030_R_BUSVA_ZUG_W
                    }
                    else {
                        rt030_bus = rt030_R_BUSVA_ZUG_F
                    }
                }
                else {
                    if (cod_aart_reparatur(rt030_aart) == TRUE) {
                        rt030_bus = R_BUSZUG_UG_MAN
                    }
                    else {
                        rt030_bus = R_BUSZUG_UG
                    }
                }
            }
            else {
                rt030_bus = rt030_bus_tpein
            }

            rt030_menge_l100 = rt030_menge_ungeplant
            rcL = rt030_buchen()
            if (rcL != OK) {
                // Fehler bei der ungeplanten Lagerbewegung mit der Buchungsnummer %s
                call on_error(OK, "lal00124", rt030_bunr, "rt030_proto")
                if (prt == TRUE) {
                    call rt030_proto_buchen()
                }
                return rcL
            }

            // ungeplante Buchung durchgeführt
            rt030_lo_buch_ug = TRUE
        }

        // Durchführung der geplanten Buchung
        if (rt030_menge_geplant > 0) {
            if (rt030_menge_ungeplant > 0) {
                warn_2_failRt030 = warn_2_fail
                warn_2_fail = TRUE
            }

            if (rt030_kn_tplager <= "0") {
                if (cod_aart_reparatur(rt030_aart) == TRUE) {
                    rt030_bus = R_BUSZUG_G_MAN
                }
                else {
                    // Separate Buchungsschlüssel für Versorgung
                    if (rt030_aart == "9") {
                        if (rt030_werk_r100 == rt030_werk_r000) {
                            rt030_bus = rt030_R_BUSVA_ZUG_W
                        }
                        else {
                            rt030_bus = rt030_R_BUSVA_ZUG_F
                        }
                    }
                    else {
                        rt030_bus = R_BUSZUG_G
                    }
                }
            }
            else {
                rt030_bus = rt030_bus_tpein
            }

            rt030_menge_l100 = rt030_menge_geplant
            rcL = rt030_buchen()
            if (rcL != OK) {
                // Fehler bei der geplanten Lagerbewegung mit der Buchungsnummer %s
                call on_error(OK, "lal00123", rt030_bunr, "rt030_proto")
                if (prt == TRUE) {
                    call rt030_proto_buchen()
                }
                if (rt030_menge_ungeplant > 0) {
                    warn_2_fail = warn_2_failRt030
                }
                return rcL
            }

            if (rt030_menge_ungeplant > 0) {
                warn_2_fail = warn_2_failRt030
            }

            // geplante Buchung durchgeführt
            rt030_lo_buch_g = TRUE

            // Buchungsnummer sichern
            rt030_bunr_gepl = rt030_bunr
        }
    }
    else {
        rt030_storno = "0"

        // Durchführung der geplanten Buchung
        if (rt030_menge_geplant > 0) {
            if (rt030_kn_tplager <= "0") {
                if (cod_aart_reparatur(rt030_aart) == TRUE) {
                    rt030_bus = R_BUSZUG_G_MAN
                }
                else {
                    // Separate Buchungsschlüssel für Versorgung
                    if (rt030_aart == "9") {
                        if (rt030_werk_r100 == rt030_werk_r000) {
                            rt030_bus = rt030_R_BUSVA_ZUG_W
                        }
                        else {
                            rt030_bus = rt030_R_BUSVA_ZUG_F
                        }
                    }
                    else {
                        rt030_bus = R_BUSZUG_G
                    }
                }
            }
            else {
                rt030_bus = rt030_bus_tpein
            }

            rt030_menge_l100 = rt030_menge_geplant
            rcL = rt030_buchen()
            if (rcL != OK) {
                // Fehler bei der geplanten Lagerbewegung mit der Buchungsnummer %s
                call on_error(OK, "lal00123", rt030_bunr, "rt030_proto")
                if (prt == TRUE) {
                    call rt030_proto_buchen()
                }
                return rcL
            }

            // geplante Buchung durchgeführt
            rt030_lo_buch_g = TRUE

            // Buchungsnummer sichern
            rt030_bunr_gepl = rt030_bunr
        }

        // Durchführung der ungeplanten Buchung
        if (rt030_menge_ungeplant > 0) {
            if (rt030_menge_geplant > 0) {
                warn_2_failRt030 = warn_2_fail
                warn_2_fail = TRUE
            }

            if (rt030_kn_tplager != "1") {
                if (cod_aart_versorg(rt030_aart) == TRUE) {
                    if (rt030_werk_r100 == rt030_werk_r000) {
                        rt030_bus = rt030_R_BUSVA_ZUG_W
                    }
                    else {
                        rt030_bus = rt030_R_BUSVA_ZUG_F
                    }
                }
                else {
                    if (cod_aart_reparatur(rt030_aart) == TRUE) {
                        rt030_bus = R_BUSZUG_UG_MAN
                    }
                    else {
                        rt030_bus = R_BUSZUG_UG
                    }
                }
            }
            else {
                rt030_bus = rt030_bus_tpein
            }

            rt030_menge_l100 = rt030_menge_ungeplant
            rcL = rt030_buchen()
            if (rcL != OK) {
                // Fehler bei der ungeplanten Lagerbewegung mit der Buchungsnummer %s
                call on_error(OK, "lal00124", rt030_bunr, "rt030_proto")
                if (prt == TRUE) {
                    call rt030_proto_buchen()
                }
                if (rt030_menge_geplant > 0) {
                    warn_2_fail = warn_2_failRt030
                }
                return rcL
            }

            if (rt030_menge_geplant > 0) {
                warn_2_fail = warn_2_failRt030
            }

            // ungeplante Buchung durchgeführt
            rt030_lo_buch_ug = TRUE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_buchen_lm100
#
# Buchen über Modul lm100
# - flagGetSnrP <leer> Ermitteln über rt030_seriennr
# -             "1"    Ermitteln direkt über rt030_seriennr_gebucht
# -             "2"    Ermitteln direkt über rt030_seriennr_buch
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_buchen_lm100(LGNR, STORNO, BUS, LGBER, LGFACH, RESERVNR, WERK, flagUmlagP, BUNR_REF, flagGetSnrP)
{
    int  rcL
    vars statusL
    vars iL


    log LOG_DEBUG, LOGFILE, "(:LGNR, :STORNO, :BUS, :LGBER, :LGFACH, :RESERVNR, :WERK, :BUNR_REF)"

    public lm100.bsl

    if (rt030_handle_lm100 == NULL) {
        rt030_handle_lm100 = lm100_load()
        if (rt030_handle_lm100 < OK) {
            // Fehler beim Laden des Moduls %s!
            call bu_msg("APPL0520", "lm100")
            return FAILURE
        }
    }

    call lm100_activate(rt030_handle_lm100)
    call lm100_init()

    aufnrLm100EA = rt030_aufnr
    aufposLm100EA = rt030_aufpos
    bu_datLm100EA = rt030_bu_dat
    bu_herkLm100EA = BU_2

    if (rt030_bu_monat == NULL) {
        call rt030_get_bu_monat(WERK, LGNR)
    }

    bu_monatLm100EA = rt030_bu_monat
    bu_termLm100EA = rt030_bu_dat
    busLm100EA = BUS
    chargeLm100EA = rt030_charge
    chargen_pflichtLm100EA = rt030_chargen_pflicht
    servicenrLm100EA = rt030_servicenr
    chargen_splittLm100EA = BU_0
    fklzLm100EA = rt030_fklz
    identnrLm100EA = rt030_identnr
    koststLm100EA = rt030_kostst
    kosttraegerLm100EA = rt030_kosttraeger
    lg_datLm100EA = rt030_lg_dat
    lg_refLm100EA = rt030_fklz
    lgberLm100EA = LGBER
    lgfachLm100EA = LGFACH
    lgnrLm100EA = LGNR
    mengeLm100EA = rt030_menge_l100
    reservnrLm100EA = RESERVNR
    stornoLm100EA = STORNO
    varLm100EA = rt030_var
    werkLm100EA = WERK
    wertLm100EA = rt030_wert_l100

    bearbLm100EA = rt030_bearb
    komm_nrLm100EA = rt030_komm_nr

    // Daten Chargenpflicht für Modul lm100 laden
    if (cod_chargen_pflicht(rt030_chargen_pflicht) == TRUE) {
        chvb_presentLm100EA = TRUE
        ch_fklzLm100EA      = rt030_fklz
    }
    else {
        chvb_presentLm100EA = FALSE
    }

    // Referenzfeld bei Versorgungsauftrag für Modul lm100 laden
    if (cod_aart_versorg(rt030_aart) == TRUE) {
        lg_ref_clLm100EA =  rt030_fklz
    }
    else {
        lg_ref_clLm100EA = screen_name
    }

    // Referenzbuchungsnummer für Modul lm100 laden
    if ( \
        rt030_kn_tplager >  "0" && \
        flagUmlagP       == "S" \
    ) {
        bunr_refLm100EA = rt030_bunr_ref
    }
    else if (BUNR_REF != NULL) {
        bunr_refLm100EA = BUNR_REF
    }

    vv_nrLm100EA = rt030_vv_nr
    aendindLm100EA = rt030_aendind
    kdidentnrLm100EA = rt030_kdidentnr

    // Seriennummernabhandlung
    if (flagGetSnrP == "1") {
        call sm_n_copyarray("seriennrLm100EA", "rt030_seriennr_gebucht")
    }
    else if (flagGetSnrP == "2") {
        call sm_n_copyarray("seriennrLm100EA", "rt030_seriennr_buch")
    }
    else {
        if ( \
            ( \
                STORNO              == 0   || \
                rt030_fu_farm       == "2" || \
                rt030_bunr_meld     >  0   || \
                rt030_R_REF_BUCHUNG <= "0" \
            ) && \
            ( \
                rt030_kn_tplager <= "0" || \
                flagUmlagP       != "S" \
            ) \
        ) {
            if (rt030_menge_l100 < rt030_seriennr->num_occurrences) {
                call sm_n_1clear_array("rt030_seriennr_buch")
                for iL = 1 while iL <= rt030_menge_l100 step 1 {
                    rt030_seriennr_buch[iL] = rt030_seriennr[1]
                    call sm_i_doccur("rt030_seriennr", 1, 1)
                }
            }
            else {
                call sm_n_copyarray("rt030_seriennr_buch", "rt030_seriennr")
                call sm_n_1clear_array("rt030_seriennr")
            }
            call sm_n_copyarray("seriennrLm100EA", "rt030_seriennr_buch")
        }
    }

    etikettLm100E = etikettRt030

    vars eigenes_handleL = rt030_rt030_handle
    call sm_ldb_h_state_set(rt030_rt030_handle, LDB_ACTIVE, FALSE)

    rcL = lm100_buchen()

    call sm_ldb_h_state_set(eigenes_handleL, LDB_ACTIVE, TRUE)

    // Buchungsnummer aus Modul lm100 umladen
    rt030_bunr = bunrLm100A

    // Abhandlung rcL = FAILURE
    if (rcL != OK) {
        if (SQL_IN_TRANS == TRUE) {
            call bu_rollback()
        }
        call bu_msg_errmsg("lm100")
        call lm100_deactivate(rt030_handle_lm100)
        return FAILURE
    }

    // Fehlermeldung aus Modul lm100
    call bu_msg_errmsg("lm100")

    // Referenzbuchungsnummer aus Modul lm100 umladen
    if ( \
        rt030_kn_tplager >  "0" && \
        flagUmlagP       == "G" \
    ) {
        rt030_bunr_ref = bunrLm100A
    }

    if ( \
        rt030_R_REF_BUCHUNG == "1" && \
        !STORNO && \
        ( \
            rt030_fu_farm == "6" || \
            rt030_fu_farm == "7" || \
            rt030_fu_farm == "8" || \
            ( \
                rt030_fu_farm == "1" && \
                ( \
                    flagUmlagP       == NULL || \
                    rt030_kn_tplager >  "0" \
                ) \
            ) \
        ) \
    ) {
        if ( \
            rt030_kn_tplager >  "0" && \
            flagUmlagP       == "S" \
        ) {
            statusL = "1"
        }
        else {
            statusL = "0"
        }

        dbms sql \
            insert into \
                r039 \
            ( \
                r039.fi_nr, \
                r039.werk, \
                r039.lgnr, \
                r039.identnr, \
                r039.var, \
                r039.bunr, \
                r039.fklz, \
                r039.fmlz, \
                r039.datuhr, \
                r039.status, \
                r039.logname, \
                r039.maske, \
                r039.menge_bearb \
            ) \
            values ( \
                :+FI_NR1, \
                :+WERK, \
                :+LGNR, \
                :+rt030_identnr, \
                :+rt030_var, \
                :+rt030_bunr, \
                :+rt030_fklz, \
                :+NULL, \
                :CURRENT, \
                :+statusL, \
                :+LOGNAME, \
                :+screen_name, \
                :+rt030_menge_l100 \
            )

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Einfügen in Tabelle %s
            return on_error(FAILURE, "APPL0003", "r039", "rt030_proto")
        }
    }

    call lm100_deactivate(rt030_handle_lm100)

    call rt030_set_reservierung_bedarf(LGNR, STORNO, BUS, RESERVNR, WERK)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_instandhaltung
#
# Aktualisierung der Instandhaltungsdaten
# - nur bei Instandhaltungsaufträgen
# - Schadenscode aus Bundle, wenn übergeben
# - Summe Instandhaltungszeiten ( = Summe verbrauchte Zeit aller AG)
# - Aufruf Modul "it000"
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_instandhaltung()
{
    int rcL


    if (rt030_aart != "8") {
        return OK
    }

    // Schadenscode aus Bundle übernehmen
    if (rt030_schad_code_meld != NULL) {
        rt030_schad_code = rt030_schad_code_meld
    }

    // Summe der Instandhaltungszeiten ermitteln
    if (dm_is_cursor("sel_r200_2_rt030C") != TRUE) {
        dbms declare sel_r200_2_rt030C cursor for \
            select \
                sum(r200.verbrzt_sek) \
            from \
                r200 \
            where \
                r200.fi_nr = ::_1 and \
                r200.fklz  = ::_2

       cursorRt030[++] = "sel_r200_2_rt030C"
    }
    dbms with cursor sel_r200_2_rt030C alias rt030_ih_zeit
    dbms with cursor sel_r200_2_rt030C execute using \
        FI_NR1, \
        fklz
    dbms with cursor sel_r200_2_rt030C alias

    if ( \
        SQL_CODE != SQL_OK && \
        SQL_CODE != SQLNOTFOUND \
    ) {
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "r200", "rt030_proto")
    }

    send bundle "b_it000_rueckmeld" data \
        rt030_aufnr, \
        rt030_aufpos, \
        rt030_fklz, \
        rt030_schad_code, \
        @format_date(rt030_bu_dat, DATEFORMAT0), \
        @format_date(rt030_bu_dat, DATEFORMAT0), \
        fertig_umrechnenZeit(rt030_ih_zeit, "SEC", ZMA, NULL, NULL, $NULL), \
        rt030_ausfzeit, \
        rt030_meih_zt, \
        rt030_bs

    warn_2_failRt030 = warn_2_fail
    warn_2_fail      = FALSE
    rcL              = it000_rueckmelden(rt030_it000_handle)
    warn_2_fail      = warn_2_failRt030

    if (rcL < OK) {
        return FAILURE
    }


    // Status-LineMeldung ausgeben
    call rt030_meldung_ag_rueckm_durchfuehren()

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_update_r000
#
# - Update auf Fertigungsauftrag durchführen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_update_r000()
{
    int                    rcL
    int                    angearbeitetL
    int                    angearbeitet_altL
    date                   fortsetz_datL
    date                   vzdatumL
    string                 chargeL
    boolean                r000_geaendertL = FALSE
    cdt                    datumL
    verknuepfungFklzRq1004 verknuepfungL
    R000CDBI               r000L
    cdtRq000               cdtRq000L


    switch (rt030_fu_farm) {
        case "6":
        case "7":
        case "8":
            rt030_menge_gef += rt030_menge_meld
            break
        case "1":
        case "2":
        case "9":
            rt030_menge_gef -= rt030_menge_meld
            break
    }

    rt030_fkfs_alt = rt030_fkfs
    rcL = rt030_ermittlung_fkfs()
    if (rcL != OK) {
        dbms close cursor lock_r000_rt030C
        return rcL
    }


    rt030_menge_offen_alt = rt030_menge_offen
    rt030_menge_offen     = rt030_menge - rt030_menge_gef
    if ( \
        rt030_fkfs == FSTATUS_FERTIG || \
        rt030_menge_offen < 0 \
    ) {
        rt030_menge_offen = 0
    }

    datumL = fertig_getDatum(rt030_handle_gm300, "get;prev;first", $NULL, @date(rt030_seterm))
    if (md_isnull(datumL) == TRUE) {
        dbms close cursor lock_r000_rt030C
        return on_error(FAILURE, NULL, NULL, "rt030_proto")
    }

    rt030_sefkt = datumL=>fkt

    call gm300_activate(rt030_handle_gm300)

    public ri070.bsl
    rt030_vzzeit = ri070_vzzeit_fa(rt030_fklz, rt030_fkfs, rt030_sefkt, rt030_dlzeit, rt030_vzag)
    call gm300_deactivate(rt030_handle_gm300)


    // 300196003: Wenn der Status eines FA von 5 oder 6 auf <= 4 gesetzt wird, muss der Fortsetztermin gelöscht werden
    // 300366217: Es müssen immer beide Felder des Fortsetztermins berücksichtigt werden
    angearbeitetL     = fertig_check_fkfs_angearbeitet(rt030_fkfs, "", rt030_fklz)
    angearbeitet_altL = fertig_check_fkfs_angearbeitet(rt030_fkfs_alt, "", rt030_fklz)
    if (angearbeitet_altL != FALSE \
    &&  angearbeitetL     == FALSE) {
        rt030_fortsetz_uhr  = ""
    }

    if (rt030_fortsetz_uhr != "") {
        fortsetz_datL = rt030_fortsetz_uhr
        fortsetz_datL = bu_date_set_time(fortsetz_datL, $NULL)   // ab R2023.01
    }
    else {
        fortsetz_datL = $NULL
    }


    // rq000-Instanz inkl. Lesen der r000 erzeugen
    public rq000.bsl
    cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt030), FI_NR1, rt030_fklz, $NULL)
    if (defined(cdtRq000L) != TRUE) {
        return FAILURE
    }

    if (rq000_get_fkfs(cdtRq000L) != rt030_fkfs) {
        call rq000_set_fkfs(cdtRq000L, rt030_fkfs)
        r000_geaendertL = TRUE
    }

    if (rq000_get_menge_gef(cdtRq000L) != rt030_menge_gef) {
        call rq000_set_menge_gef(cdtRq000L, rt030_menge_gef)
        r000_geaendertL = TRUE
    }

    if (rq000_get_menge_offen(cdtRq000L) != rt030_menge_offen) {
        call rq000_set_menge_offen(cdtRq000L, rt030_menge_offen)
        r000_geaendertL = TRUE
    }

    if (rq000_get_vzzeit(cdtRq000L) != rt030_vzzeit) {
        call rq000_set_vzzeit(cdtRq000L, rt030_vzzeit)
        r000_geaendertL = TRUE
    }

    if (rq000_get_rueck_dat(cdtRq000L) != rt030_bu_dat) {
        call rq000_set_rueck_dat(cdtRq000L, rt030_bu_dat)
        r000_geaendertL = TRUE
    }

    if (rq000_get_schad_code(cdtRq000L) != rt030_schad_code) {
        call rq000_set_schad_code(cdtRq000L, rt030_schad_code)
        r000_geaendertL = TRUE
    }

    vzdatumL = bu_get_datetime()
    if (rq000_get_vzdatum_date(cdtRq000L) != vzdatumL) {
        call rq000_set_vzdatum_date(cdtRq000L, vzdatumL)
        r000_geaendertL = TRUE
    }

    if (rq000_get_fortsetz_uhr(cdtRq000L) != rt030_fortsetz_uhr) {
        call rq000_set_fortsetz_uhr(cdtRq000L, rt030_fortsetz_uhr)
        r000_geaendertL = TRUE
    }

    if (rq000_get_fortsetz_dat_date(cdtRq000L) != fortsetz_datL) {
        call rq000_set_fortsetz_dat_date(cdtRq000L, fortsetz_datL)
        r000_geaendertL = TRUE
    }

    if ( \
        ( \
            rt030_storno    == "1" && \
            rt030_menge_gef <= 0   && \
            cod_chargen_rein(rt030_chargen_pflicht) \
        ) || \
        cod_aart_versorg(rt030_aart) \
    ) {
        chargeL = ""
    }
    else {
        chargeL = rt030_charge
    }

    if (rq000_get_charge(cdtRq000L) != chargeL) {
        call rq000_set_charge(cdtRq000L, chargeL)
        r000_geaendertL = TRUE
    }


    // Speichern der r000 nur, wenn mindestens ein Feld geändert wurde
    if (r000_geaendertL == TRUE) {
        rcL = rq000_update_cdbi(cdtRq000L, r000L)
        dbms close cursor lock_r000_rt030C
        if (rcL != OK) {
            call rq000_speichern_protokoll(cdtRq000L, BU_0, FALSE)
            // Fehler beim Ändern in Tabelle %s
            return on_error(FAILURE, "APPL0004", "r000", "rt030_proto")
        }
    }
    else {
        dbms close cursor lock_r000_rt030C
    }

    // Aktionssatz/-sätze schreiben
    if (dispo_aktion_d205(FI_NR1, rt030_werk_r000, rt030_identnr, rt030_var, rt030_lgnr_r000, "R") != OK) {
        return FAILURE
    }

    // Falls sich das Ist-Zugangslager vom Soll-Zugangslager unterscheidet
    if (rt030_lgnr != rt030_lgnr_r000) {
        if (dispo_aktion_d205(FI_NR1, rt030_werk_r000, rt030_identnr, rt030_var, rt030_lgnr, "R") != OK) {
            return FAILURE
        }
    }

    if ( \
        rt030_fu_farm >= "6" && \
        rt030_fu_farm <= "8" \
    ) {
        public rq1004.bsl
        verknuepfungL        = new verknuepfungFklzRq1004()
        verknuepfungL=>fi_nr = FI_NR1
        verknuepfungL=>fklz  = rt030_fklz
        if (rt030_fu_farm == "6") {
            verknuepfungL=>menge_diff = rt030_menge_meld
        }
        else {
            verknuepfungL=>menge_diff = rt030_menge_offen_alt
        }

        if (verknuepfungFklzRq1004Aufheben(verknuepfungL) < OK) {
            // Fehler beim Einfügen in Tabelle %s
            return on_error(FAILURE, "APPL0003", "r1004", "rt030_proto")
        }
    }

    // Werkstattsteuerung tisoware bedienen
    if (bu_getenv("RH822_PROFIL") == "tisoware_r822") {
        rcL = rt030_werkstattsteuerung()
        if (rcL != OK) {
            return rcL
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_update_g020
#
# - Bestellbestand aktualisieren
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_update_g020()
{
    if ( \
        kn_lgdispRt030 == "0" || \
        rt030_da       == "0" \
    ) {
        return OK
    }

    rt030_diffmenge = rt030_menge_offen_alt - rt030_menge_offen

    call rt030_bundle_lt110()
    public lt110:(EXT)

    if (lt110_rvb_fortschreiben(rt030_lt110_handle) != OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_ermittlung_fkfs
#
# - Ermittlung der Status des Fertigungsauftrages
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_ermittlung_fkfs()
{
    public ri000.bsl

    switch (rt030_fu_farm) {
        case "1":
            if (rt030_menge_gef > 0) {
                rt030_fkfs = FSTATUS_ANGEARBEITET
            }
            else if ( \
                ri000_anz_mat("beg",  rt030_fklz) > 0 || \
                ri000_anz_ag ("beg",  rt030_fklz) > 0 || \
                ri000_anz_zum("alle", rt030_fklz) > 0 \
            ) {
                rt030_fkfs = FSTATUS_BEGONNEN
            }
            else {
                rt030_fkfs = FSTATUS_FREIGEGEBEN
            }
            break
        case "2":
            if ( \
                ri000_anz_mat("beg",  rt030_fklz) > 0 || \
                ri000_anz_ag ("beg",  rt030_fklz) > 0 || \
                ri000_anz_zum("alle", rt030_fklz) > 0 \
            ) {
                rt030_fkfs = FSTATUS_BEGONNEN
            }
            else {
                rt030_fkfs = FSTATUS_FREIGEGEBEN
            }
            break
        case "5":
            if (rt030_fkfs == FSTATUS_FREIGEGEBEN) {
                rt030_fkfs = FSTATUS_BEGONNEN
            }
            break
        case "6":
            if (rt030_fkfs != FSTATUS_FERTIG) {
                rt030_fkfs = FSTATUS_ANGEARBEITET
            }
            break
        case "7":
        case "8":
            rt030_fkfs = FSTATUS_FERTIG
            break
        case "9":
            if (rt030_menge_gef == 0) {
                if ( \
                    ri000_anz_mat("beg",  rt030_fklz) > 0 || \
                    ri000_anz_ag ("beg",  rt030_fklz) > 0 || \
                    ri000_anz_zum("alle", rt030_fklz) > 0 \
                ) {
                    rt030_fkfs = FSTATUS_BEGONNEN
                }
                else {
                    rt030_fkfs = FSTATUS_FREIGEGEBEN
                }
            }
            break
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_insert_r035
#
# - Satz in die Aktionstabelle r035 für Materialbereitstellung abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_insert_r035()
{
    boolean dupkeyL = TRUE


    // Keine Materialentnahmesätze in r035, wenn
    // - matbuch != "4" (Nur bei "4" darf sie im Hintergrund erfolgen)
    // - keine Versorgungsaufträge betroffen sind
    // - die Materialentnahme in re030 über re135 erfolgt, d.h. bei R_MATBUCH_DIALOG="1" autom. in re030 aufgerufen wird
    if ( \
        rt030_matbuch != "4"          || \
        cod_aart_versorg(rt030_aart)  || \
        rt030_R_MATBUCH_DIALOG == "1" \
    ) {
        return OK
    }

    // keine Rückmeldung des Materials bei Menge 0 und FuAgrm "1" oder "6"
    if ( \
        rt030_menge_meld == 0 && \
        ( \
            (rt030_fu_farm == "1" && rt030_fkfs_alt < "7") || \
            rt030_fu_farm == "6" \
        ) \
    ) {
        return OK
    }

    // "Beginnmeldung" macht bei Material keinen Sinn
    if (rt030_fu_farm == "5") {
        return OK
    }

    // Nächste "nr" vergeben
    if (dm_is_cursor("sel_r035_rt030C") != TRUE) {
        dbms declare sel_r035_rt030C cursor for \
            select \
                max(r035.nr) \
            from \
                r035 \
            where \
                r035.fi_nr = ::_1

        cursorRt030[++] = "sel_r035_rt030C"
    }
    dbms with cursor sel_r035_rt030C alias rt030_nr_r035
    dbms with cursor sel_r035_rt030C execute using FI_NR1
    dbms with cursor sel_r035_rt030C alias

    if (rt030_nr_r035 == NULL) {
        rt030_nr_r035 = 0
    }

    while (dupkeyL == TRUE) {
        rt030_nr_r035++

        call bu_noerr()

        dbms sql \
            insert into \
                r035 \
            ( \
                datuhr, \
                fi_nr, \
                werk, \
                logname, \
                tty, \
                maske, \
                nr, \
                fklz, \
                aufnr, \
                aufpos, \
                disstufe, \
                fu_matrm, \
                fu_agrm, \
                fu_farm, \
                menge, \
                rueck_dat, \
                jobid, \
                art_matrm, \
                vv_nr \
            ) values ( \
                :CURRENT, \
                :+FI_NR1, \
                :+rt030_werk_r000, \
                :+LOGNAME, \
                :+TTY, \
                :+screen_name, \
                :+rt030_nr_r035, \
                :+rt030_fklz, \
                :+rt030_aufnr, \
                :+rt030_aufpos, \
                :+rt030_disstufe, \
                :+rt030_fu_farm, \
                :+NULL, \
                :+NULL, \
                :+rt030_menge_meld, \
                :+rt030_bu_dat, \
                0, \
                'R', \
                :+rt030_vv_nr \
            )

        switch (SQL_CODE) {
            case SQL_OK:
                dupkeyL = FALSE
                break
            case SQLE_DUPKEY:
                break
            else:
                // Fehler beim Einfügen in Tabelle %s
                return on_error(FAILURE, "APPL0003", "r035", "rt030_proto")
        }
    }

    if (rt030_R_MATBUCH_START == "1") {
        call sm_n_1clear_array("partab")
        partab[1] = LOGNAME
        partab[7] = rt030_fklz
        call bu_job("rh035", NULL, NULL)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_auftragsabrechnung
#
# - Satz in die Aktionstabelle r045 für die Auftragsabrechnung abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_auftragsabrechnung()
{
    int rcL


    if (rt030_fkfs == FSTATUS_FERTIG) {
        rcL = rt030_insert_r045()
    }
    else {
        rcL = rt030_delete_r045()
    }

    return rcL
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_insert_r045
#
# - Satz in die Aktionstabelle r045 für die Auftragsabrechnung
#   abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_insert_r045()
{
    vars lockedL


    call bu_noerr()

    dbms sql \
        insert into \
            r045 \
        ( \
            r045.fi_nr, \
            r045.werk, \
            r045.fklz, \
            r045.aufnr, \
            r045.aufpos, \
            r045.fu_abrch, \
            r045.matoffen, \
            r045.agoffen, \
            r045.nboffen, \
            r045.abr_owb, \
            r045.disstufe, \
            r045.logname, \
            r045.jobid \
        ) values ( \
            :+FI_NR1, \
            :+rt030_werk_r000, \
            :+rt030_fklz, \
            :+rt030_aufnr, \
            :+rt030_aufpos, \
            '8', \
            :+rt030_matoffen, \
            :+rt030_agoffen, \
            :+rt030_nboffen, \
            0, \
            :+rt030_disstufe, \
            :+LOGNAME, \
            0 \
        )

    if ( \
        SQL_CODE != SQL_OK      && \
        SQL_CODE != SQLE_DUPKEY \
    ) {
        // Fehler beim Einfügen in Tabelle %s
        return on_error(FAILURE, "APPL0003", "r045", "rt030_proto")
    }

    if (SQL_CODE == SQLE_DUPKEY) {
        lockedL = TRUE
        while (lockedL == TRUE) {
            dbms sql \
                update \
                    r045 \
                set \
                    fu_abrch = '8', \
                    matoffen = :+rt030_matoffen, \
                    agoffen  = :+rt030_agoffen, \
                    nboffen  = :+rt030_nboffen, \
                    disstufe = :+rt030_disstufe, \
                    logname  = :+LOGNAME \
                where \
                    fi_nr =  :+FI_NR1     and \
                    fklz  =  :+rt030_fklz and \
                    jobid <= 0

            switch (SQL_CODE) {
                case SQL_OK:
                    lockedL = FALSE
                    break
                case SQLE_ROWLOCKED:
                    // Aktion Auftragsabrechnung %s von einem anderen Benutzer gesperrt
                    call bu_msg("r0450002", rt030_fklz)
                    break
                else:
                    // Fehler beim Ändern in Tabelle %s
                    return on_error(FAILURE, "APPL0004", "r045", "rt030_proto")
            }
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_delete_r045
#
# - Satz aus der Aktionstabelle r045 für die Auftragsabrechnung löschen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_delete_r045()
{
    vars lockedL


    lockedL = TRUE
    while (lockedL == TRUE) {
        dbms sql \
            delete from \
                r045 \
            where \
                r045.fi_nr =  :+FI_NR1     and \
                r045.fklz  =  :+rt030_fklz and \
                r045.jobid <= 0

        switch (SQL_CODE) {
            case SQL_OK:
                lockedL = FALSE
                break
            case SQLE_ROWLOCKED:
                // Aktion Auftragsabrechnung %s von einem anderen Benutzer gesperrt
                call bu_msg("r0450002", rt030_fklz)
                break
            else:
                // Fehler beim Löschen in Tabelle %s
                return on_error(FAILURE, "APPL0005", "r045", "rt030_proto")
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_uebg
#
# Aktualisieren des Freigabekennzeichens in den Kundenauftragspositionen
# zu den übergeordneten Bedarfen
# - nur bei Auftragsart "K" (Kundenaufträge)
# - nur, wenn Fertigungsstatus sich geändert hat
# - lesen aller übergeordneten Materialien zum Fertigungsauftrag
# - Aktualisieren des Freigabekennzeichens in der Kundenauftragsposition
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_uebg()
{
    // nur bei Auftragsart "1" (Kundenauftrag) und "9" (Versorgung)
    if ( \
        !( \
            cod_aart_vertriebsfa(rt030_aart) || \
            cod_aart_versorg(rt030_aart) \
        ) \
    ) {
        return OK
    }

    // nur, wenn Fertigungsstatus sich geändert hat
    if (rt030_fkfs == rt030_fkfs_alt) {
        return OK
    }

    // Cursor über alle übergeordneten Primärbedarfe zum Fertigungsauftrag
    dbms declare sel_r100_1_rt030C cursor for \
        select :OPT_HINT_RULE \
            r100.fmlz \
        from \
            r100 \
        where \
            r100.fi_nr    = :+FI_NR1        and \
            r100.ufklz    = :+rt030_fklz    and \
            r100.identnr  = :+rt030_identnr and \
            r100.var      = :+rt030_var     and \
            r100.pos_herk = :+cPOSHERK_VERTRIEB \
        union \
        select :OPT_HINT_RULE \
            r100.fmlz \
        from \
            r100 \
        where \
            r100.fi_nr    = :+FI_NR1        and \
            r100.ufklz    = :+rt030_fklz    and \
            r100.identnr  = :+rt030_identnr and \
            r100.var      = :+rt030_var     and \
            r100.pos_herk = :+cPOSHERK_ABRUF
    dbms with cursor sel_r100_1_rt030C alias rt030_fmlz_uebg
    dbms with cursor sel_r100_1_rt030C execute

    while (SQL_CODE == SQL_OK) {
        // Aktualisierung des Freigabestatus in der Kundenauftragsposition
        if (rt030_status_uebg() < OK) {
            dbms close cursor sel_r100_1_rt030C
            return FAILURE
        }
        dbms with cursor sel_r100_1_rt030C continue
    }

    if (SQL_CODE != SQLNOTFOUND) {
        dbms close cursor sel_r100_1_rt030C
        // Fehlermeldung nur bei Kundenaufträgen, nicht bei Versorgungsaufträgen
        if (cod_aart_vertriebsfa(rt030_aart) == TRUE) {
            // Fehler beim Lesen in Tabelle %s
            return on_error(FAILURE, "APPL0006", "r100", "rt030_proto")
        }
    }

    dbms close cursor sel_r100_1_rt030C

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_status_uebg
#
# Freigabestatus in Kundenauftragsposition setzen
# - bei Status "4"  --> "5", immer mit storno
# - bei Status "5"  --> "6", storno je nach fkfs_alt
# - bei Status "6"  --> "7", storno je nach fkfs_alt
# - bei Status "7"  --> "8", immer ohne storno
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_status_uebg()
{
    vars kn_freigabeL
    vars stornoL


    // Je nach Fertigungsstatus und Fertigungsstatus alt
    switch (rt030_fkfs) {
        case FSTATUS_FREIGEGEBEN:
            kn_freigabeL = "5"
            stornoL      = "1"
            break
        case FSTATUS_BEGONNEN:
            kn_freigabeL = "6"
            if (rt030_fkfs_alt == FSTATUS_FREIGEGEBEN) {
                stornoL = "0"
            }
            else {
                stornoL = "1"
            }
            break
        case FSTATUS_ANGEARBEITET:
            kn_freigabeL = "7"
            if (rt030_fkfs_alt == FSTATUS_FERTIG) {
                stornoL = "1"
            }
            else {
                stornoL = "0"
            }
            break
        case FSTATUS_FERTIG:
            kn_freigabeL = "8"
            stornoL      = "0"
            break
        else:
            // Todo JK
            break
    }

    send bundle "b_vt110r_status" data \
        NULL, \
        NULL, \
        NULL, \
        rt030_fmlz_uebg, \
        kn_freigabeL, \
        stornoL, \
        rt030_fklz, \
        rt030_bunr_gepl

    // 2003-09-24 BEB: Meiko-OP h87
    // Vor dem Aufruf von vt110r_status() darf das rt030.ldb nicht deaktiviert werden, da die Felder in der
    // Protokollierung von vt110r-Fehlern verwendet werden (siehe vt110r_first_entry() oben)!
    if (vt110r_status(rt030_vt110r_handle) < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_proto_buchen
#
# - Buchungsfehler in Protokolltabelle r036 abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_proto_buchen()
{
    if (bu_begin() != OK) {
        return FAILURE
    }

    // Meldungsdaten lesen über Buchungsnummer
    dbms declare sel_l106_rt030C cursor for \
        select \
            l106.msg_nr, \
            l106.msg_typ, \
            l106.msg_text \
        from \
            l106 \
        where \
            l106.fi_nr = :+FI_NR1 and \
            l106.bunr  = :+rt030_bunr
    dbms with cursor sel_l106_rt030C alias \
        msg_nr, \
        msg_typ, \
        msg_text
    dbms with cursor sel_l106_rt030C execute

    while (SQL_CODE == SQL_OK) {
        call rt030_proto_kb(WARNING, PRT_CTRL_FEHLER, $NULL, $NULL)
        dbms with cursor sel_l106_rt030C continue
    }

    if (SQL_CODE != SQLNOTFOUND) {
        dbms close cursor sel_l106_rt030C
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "l106")
    }

    dbms close cursor sel_l106_rt030C

    call bu_commit()

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_proto
#
# - Satz in die Protokolltabelle r036 abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_proto(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    vars werkL


    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r036")

    werkL = rt030_werk_r000
    if (werkL == NULL) {
        werkL = werk
    }

    dbms sql \
        insert into \
            r036 \
        ( \
            datuhr, \
            fi_nr, \
            werk, \
            logname, \
            tty, \
            maske, \
            msg_nr, \
            msg_typ, \
            msg_text, \
            prt_ctrl, \
            jobid, \
            nr, \
            fklz, \
            aufnr, \
            aufpos, \
            identnr, \
            var, \
            aart, \
            fkfs, \
            fsterm_uhr, \
            seterm_uhr, \
            fortsetz_uhr, \
            seterm, \
            art_farm, \
            fu_farm, \
            menge, \
            bunr, \
            lgnr, \
            bu_monat, \
            bu_dat, \
            kostst, \
            kosttraeger, \
            charge, \
            reservnr, \
            lg_dat, \
            lgber, \
            lgfach, \
            fu_matrm, \
            fu_agrm \
        ) values ( \
            :CURRENT, \
            :+FI_NR1, \
            :+werkL, \
            :+LOGNAME, \
            :+TTY, \
            :+screen_name, \
            :+msg_nr, \
            :+msg_typ, \
            :+msg_text, \
            :+prt_ctrl, \
            :+JOBID, \
            :+rt030_nr, \
            :+rt030_fklz, \
            :+rt030_aufnr, \
            :+rt030_aufpos, \
            :+rt030_identnr, \
            :+rt030_var, \
            :+rt030_aart, \
            :+rt030_fkfs, \
            :+rt030_fsterm_uhr, \
            :+rt030_seterm_uhr, \
            :+rt030_fortsetz_uhr, \
            :+rt030_seterm, \
            :+rt030_art_farm, \
            :+rt030_fu_farm, \
            :+rt030_menge_meld, \
            :+rt030_bunr, \
            :+rt030_lgnr, \
            :+rt030_bu_monat, \
            :+rt030_bu_dat, \
            :+rt030_kostst, \
            :+rt030_kosttraeger, \
            :+rt030_charge, \
            :+rt030_reservnr, \
            :+rt030_lg_dat, \
            :+rt030_lgber, \
            :+rt030_lgfach, \
            :+rt030_fu_matrm, \
            :+rt030_fu_agrm \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle %s
        return on_error(FAILURE, "APPL0003", "r036")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# An dieser Stelle wird die aktualisierte Chargennummer empfangen,
# welche im lq040 im neuen Chargenstamm angelegt wurde
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_receive_lq040(cdtLq040P)
{
    rt030_charge = cdtLq040P=>charge

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# An dieser Stelle werden die Daten fuer die Generierung der Chargennummer gesendet
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_send_lq040(cdtLq040P)
{
    string chargeL

    if (bu_getenv("L_CHARGE_GENERIERT") == "3") {
        chargeL = rt030_fklz
    }
    else {
        chargeL = ""
    }

    cdtLq040P=>identnr      = rt030_identnr
    cdtLq040P=>var          = rt030_var
    cdtLq040P=>charge       = chargeL

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_bundle_lt110()
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_bundle_lt110()
{
    rt030_diffmenge = -rt030_diffmenge

    send bundle "b_lt110" data \
        rt030_identnr, \
        rt030_var, \
        FALSE, \
        rt030_werk_r000, \
        rt030_lgnr_r000, \
        rt030_diffmenge, \
        NULL

    rt030_diffmenge = -rt030_diffmenge

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
#  rt030_WERT2EINLAGERUNG
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_wert2einlagerung()
{
    vars wertL  = DoubleBU_new()
    vars mengeL = DoubleBU_new()


    if (dm_is_cursor("sel_l100_rt030C") != TRUE) {
        dbms declare sel_l100_rt030C cursor for \
            select \
                l100.wert, \
                l100.menge \
            from \
                l100 \
            where \
                l100.fi_nr = ::_1 and \
                l100.bunr  = ::_2

        cursorRt030[++] = "sel_l100_rt030C"
    }
    dbms with cursor sel_l100_rt030C alias \
        wertL=>value, \
        mengeL=>value
    dbms with cursor sel_l100_rt030C execute using \
        FI_NR1, \
        rt030_bunr
    dbms with cursor sel_l100_rt030C alias

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLNOTFOUND:
            return WARNING
        else:
            // Fehler beim Lesen in Tabelle %s
            return on_error(FAILURE, "APPL0006", "l100", "rt030_proto")
    }

    rt030_wert_l100  = wertL=>value
    rt030_menge_l100 = mengeL=>value

    if (rt030_menge_l100 > 0.0) {
        rt030_wert_l100 = rt030_wert_l100 * (10 ^ (rt030_pe - 1)) / rt030_menge_l100
    }
    else {
        rt030_wert_l100 = 0.0
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_SET_KANBAN
#
# - Daten Kanbanauftrag setzen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_set_kanban()
{
    int  rcL
    vars dummyL


    if (rt030_kanbannr == NULL) {
        return OK
    }

    if (dm_is_cursor("sel_d800_2_rt030C") != TRUE) {
        dbms declare sel_d800_2_rt030C cursor for \
            select \
                d800.kn_kbeinmal, \
                d800.kn_kbdruck, \
                d800.kn_kbtyp \
            from \
                d800 \
            where \
                d800.fi_nr    = ::_1 and \
                d800.kanbannr = ::_2

        cursorRt030[++] = "sel_d800_2_rt030C"
    }
    dbms with cursor sel_d800_2_rt030C alias \
        rt030_kn_kbeinmal, \
        rt030_kn_kbdruck, \
        rt030_kn_kbtyp
    dbms with cursor sel_d800_2_rt030C execute using \
        FI_NR1, \
        rt030_kanbannr
    dbms with cursor sel_d800_2_rt030C alias

    rt030_rueck_dat = @date(BU_DATE0)

    // Freigabe
    if (rt030_fkfs == FSTATUS_FERTIG) {
        if (rt030_kn_kbeinmal == "1") {
            rt030_st_kanbannr = "9"
        }
        else {
            rt030_st_kanbannr = "7"
        }
        rt030_status = "7"

        // Datum ermitteln
        call gm300_activate(rt030_handle_gm300)
        call gm300_init()
        opcodeGm300E = "today"
        if (gm300_datum() != OK) {
            call bu_msg_errmsg("Gm300", NULL)
            call gm300_deactivate(rt030_handle_gm300)
            return on_error(FAILURE, "", "", "rt030_proto")
        }
        rt030_fertig_dat = datumGm300A

        // Rückmeldung ohne vorherige Beginnmeldung
        if (rt030_fkfs_alt == FSTATUS_FREIGEGEBEN) {
            rt030_rueck_dat = datumGm300A
        }
        call gm300_deactivate(rt030_handle_gm300)
    }
    else {
        rt030_st_kanbannr = "5"

        // Teilrückmeldung
        if (rt030_fkfs == FSTATUS_ANGEARBEITET) {
            rt030_status = "6"

            // Teil-Rückmeldung ohne Beginnmeldung
            if (rt030_fkfs_alt == FSTATUS_FREIGEGEBEN) {
                // Datum ermitteln
                call gm300_activate(rt030_handle_gm300)
                call gm300_init()
                opcodeGm300E = "today"
                if (gm300_datum() != OK) {
                    call bu_msg_errmsg("Gm300", NULL)
                    call gm300_deactivate(rt030_handle_gm300)
                    return on_error(FAILURE, "", "", "rt030_proto")
                }
                rt030_rueck_dat = datumGm300A
                call gm300_deactivate(rt030_handle_gm300)
            }
        }
        else if (rt030_fkfs == FSTATUS_BEGONNEN) {
            // Beginmeldung
            rt030_status = "5"

            // Datum ermitteln
            call gm300_activate(rt030_handle_gm300)
            call gm300_init()
            opcodeGm300E = "today"
            if (gm300_datum() != OK) {
                // Datum nicht im Fabrikkalender!
                call bu_msg_errmsg("Gm300", NULL)
                call gm300_deactivate(rt030_handle_gm300)
                return on_error(FAILURE, "", "", "rt030_proto")
            }
            rt030_rueck_dat = datumGm300A
            call gm300_deactivate(rt030_handle_gm300)
        }
        else {
            // Komplettstorno
            rt030_st_kanbannr = "4"
            rt030_status      = "4"
            rt030_rueck_dat   = @date(BU_DATE0)
        }
        rt030_fertig_dat = @date(BU_DATE0)
    }

    rcL = rt030_update_d800()
    if (rcL != OK) {
        return rcL
    }

    rcL = rt030_update_d810()
    if (rcL != OK) {
        return rcL
    }

    if ( \
        rt030_kn_kbdruck == "4" && \
        rt030_kn_kbtyp   >  "0" \
    ) {
        if (cod_aart_versorg(rt030_aart) != TRUE) {
            if (dm_is_cursor("sel_r200_1_rt030C") != TRUE) {
                dbms declare sel_r200_1_rt030C cursor for \
                    select \
                        r200.kostst, \
                        r200.agpos \
                    from \
                        r200 \
                    where \
                        r200.fi_nr = ::_1 and \
                        r200.fklz  = ::_2 \
                    order by \
                        r200.agpos

                cursorRt030[++] = "sel_r200_1_rt030C"
            }
            dbms with cursor sel_r200_1_rt030C alias \
                rt030_kostst_kb, \
                dummyL
            dbms with cursor sel_r200_1_rt030C execute using \
                FI_NR1, \
                rt030_fklz
            dbms with cursor sel_r200_1_rt030C alias

            if (dm_is_cursor("sel_f330_rt030C") != TRUE) {
                dbms declare sel_f330_rt030C cursor for \
                    select \
                        f330.auspraeg \
                    from \
                        f330 \
                    where \
                        f330.fi_nr  = ::_1 and \
                        f330.kostst = ::_2 and \
                        f330.werk   = ::_3

                cursorRt030[++] = "sel_f330_rt030C"
            }
            dbms with cursor sel_f330_rt030C alias rt030_auspraeg
            dbms with cursor sel_f330_rt030C execute using \
                FI_NR1, \
                rt030_kostst_kb, \
                rt030_werk_r000
            dbms with cursor sel_f330_rt030C alias
        }
        else {
            rt030_auspraeg = NULL
        }

        rcL = rt030_kb_drucken()
        if (rcL != OK) {
            return rcL
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_UPDATE_D800
#
# - Kanbankarte (d800) aktualisieren
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_update_d800()
{
    if (rt030_dt800_handle == NULL) {
        public dt800:(EXT)
        rt030_dt800_handle = dt800_first_entry()
        if (rt030_dt800_handle < OK) {
            return on_error(FAILURE)
        }
        call dt800_entry(rt030_dt800_handle)
    }

    call sm_n_1clear_array("stringtab")
    call sm_n_1clear_array("stringtab2")

    stringtab[++] = "st_kanbannr"
    stringtab[++] = "datletzt"

    stringtab2[++] = rt030_st_kanbannr

    // Datum ermitteln
    call gm300_activate(rt030_handle_gm300)
    call gm300_init()
    opcodeGm300E = "today"
    if (gm300_datum() != OK) {
        call bu_msg_errmsg("Gm300", NULL)
        call gm300_deactivate(rt030_handle_gm300)
        return on_error(FAILURE, "", "", "rt030_proto")
    }
    stringtab2[++] = datumGm300A
    call gm300_deactivate(rt030_handle_gm300)

    send bundle "b_dt800_dyn_data" data \
        rt030_kanbannr, \
        stringtab, \
        stringtab2

    if (dt800_dyn_update(rt030_dt800_handle) != OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_UPDATE_D810
#
# - Kanbankarte (d810) aktualisieren
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_update_d810()
{
    vars kn_verfuegL
    vars versorg_fmlzL


    if (rt030_dt810_handle == NULL) {
        public dt810:(EXT)
        rt030_dt810_handle = dt810_first_entry()
        if (rt030_dt810_handle < OK) {
            return on_error(FAILURE)
        }
        call dt810_entry(rt030_dt810_handle)
    }

    call sm_n_1clear_array("stringtab")
    call sm_n_1clear_array("stringtab2")

    stringtab[++] = "fertig_dat"
    stringtab[++] = "ktag_fertig"
    stringtab[++] = "atag_fertig"
    stringtab[++] = "ktag_versorg"
    stringtab[++] = "atag_versorg"
    stringtab[++] = "ktag_eigen"
    stringtab[++] = "atag_eigen"
    stringtab[++] = "ktag_fremd"
    stringtab[++] = "atag_fremd"

    stringtab2[++] = rt030_fertig_dat
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0
    stringtab2[++] = 0

    stringtab[++]  = "status"
    stringtab2[++] = rt030_status
    stringtab[++]  = "st_kanbannr"
    stringtab2[++] = rt030_st_kanbannr

    if (rt030_fkfs == FSTATUS_FERTIG) {
        stringtab[++]  = "ist_menge"
        stringtab2[++] = rt030_menge_gef
    }
    else {
        stringtab[++]  = "ist_menge"
        stringtab2[++] = 0
    }

    if (rt030_fkfs_alt < FSTATUS_BEGONNEN) {
        stringtab[++] = "rueck_dat"
        stringtab[++] = "ktag_rueck"
        stringtab[++] = "atag_rueck"

        stringtab2[++] = rt030_rueck_dat
        stringtab2[++] = 0
        stringtab2[++] = 0
    }

    if (cod_aart_versorg(rt030_aart) == TRUE) {
        dbms alias versorg_fmlzL
        dbms sql \
            select \
                r100.fmlz \
            from \
                r100 \
            where \
                r100.fi_nr = :+FI_NR1     and \
                r100.fklz  = :+rt030_fklz
        dbms alias

        kn_verfuegL    = "11"
        stringtab[++]  = "fmlz"
        stringtab2[++] = versorg_fmlzL
    }
    else {
        versorg_fmlzL = NULL
        kn_verfuegL   = "1"
    }

    stringtab[++]  = "fklz"
    stringtab2[++] = rt030_fklz
    stringtab[++]  = "aufnr"
    stringtab2[++] = rt030_aufnr
    stringtab[++]  = "aufpos"
    stringtab2[++] = rt030_aufpos
    stringtab[++]  = "kn_verfueg"
    stringtab2[++] = kn_verfuegL

    send bundle "b_dt810_dyn_key" data \
        rt030_kanbannr, \
        rt030_kanbananfnr
    send bundle "b_dt810_zusatz" data \
        kn_verfuegL, \
        "0", \
        "1", \
        rt030_fklz, \
        versorg_fmlzL, \
        NULL, \
        0, \
        rt030_aufnr, \
        rt030_aufpos, \
        0
    send bundle "b_dt810_dyn_data" data \
        stringtab, \
        stringtab2

    if (dt810_dyn_update(rt030_dt810_handle) != OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
#  rt030_kb_drucken
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_kb_drucken()
{
    vars jobidL


    jobidL = JOBID
    if (jobidL <= 0) {
        jobidL = bu_getnr("JOBID")
    }

    call bu_noerr()

    dbms sql \
        insert into \
            d815 \
        ( \
            fi_nr, \
            kanbannr, \
            kanbananfnr, \
            jobid, \
            logname, \
            kn_kbtyp, \
            auspraeg, \
            identnr, \
            var, \
            kostst, \
            werk, \
            lgnr, \
            lgber, \
            lgfach \
        ) values ( \
            :+FI_NR1, \
            :+rt030_kanbannr, \
            :+rt030_kanbananfnr, \
            :+jobidL, \
            :+LOGNAME, \
            :+rt030_kn_kbtyp, \
            :+rt030_auspraeg, \
            :+rt030_identnr, \
            :+rt030_var, \
            :+rt030_kostst, \
            :+rt030_werk_r000, \
            :+rt030_lgnr, \
            :+rt030_lgber, \
            :+rt030_lgfach \
        )

    if ( \
        SQL_CODE != SQL_OK      && \
        SQL_CODE != SQLE_DUPKEY \
    ) {
        // Fehler beim Einfügen in Tabelle %s
        return on_error(FAILURE, "APPL0003", "d815", "rt030_proto")
    }

    // Parameter der Vorlaufmaske übergeben
    call sm_n_1clear_array("partab")
    partab[1] = jobidL
    partab[2] = rt030_auspraeg

    call bu_job("dr810", NULL, NULL, rt030_auspraeg)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_UEBG_FREIGEBEN
#
# - bei r000.freigabe = "3" erfolgt nach Fertigmeldung des FA die Freigabeprüfung für übergeordnete FA, d.h. wurden
#   alle FA zu einem übergeordneten FA fertiggemeldet, wird dieser autom. freigegeben.
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_uebg_freigeben()
{
    int  rcL
    vars anzahlL


    // Lesen übergeordnete Fertigungsaufträge
    if (dm_is_cursor("sel_r000_2_rt030C") != TRUE) {
        dbms declare sel_r000_2_rt030C cursor for \
            select \
                r000.fklz, \
                r000.fkfs, \
                r000.werk, \
                r000.aufnr, \
                r000.aufpos, \
                r000.freigabe, \
                r000.aart \
            from \
                r000, \
                r100 \
            where \
                r100.fi_nr = ::_1       and \
                r100.ufklz = ::_2       and \
                r000.fi_nr = r100.fi_nr and \
                r000.fklz  = r100.fklz \
            order by \
                r000.fklz
        dbms with cursor sel_r000_2_rt030C alias \
            rt030_fklz_uebg, \
            rt030_fkfs_uebg, \
            rt030_werk_uebg, \
            rt030_aufnr_uebg, \
            rt030_aufpos_uebg, \
            rt030_freigabe_uebg, \
            rt030_aart_uebg

        cursorRt030[++] = "sel_r000_2_rt030C"
    }
    dbms with cursor sel_r000_2_rt030C execute using \
        FI_NR1, \
        rt030_fklz

    while (@dmrowcount > 0) {
        if (rt030_fkfs_uebg < FSTATUS_FREIGEGEBEN) {
            if (dm_is_cursor("sel_r100_2_rt030C") != TRUE) {
                dbms declare sel_r100_2_rt030C cursor for \
                    select \
                        count(*) \
                    from \
                        r100, \
                        r000 \
                    where \
                        r100.fi_nr   =  ::_1             and \
                        r100.fklz    =  ::_2             and \
                        r000.fi_nr   =  r100.fi_nr       and \
                        r000.fklz    =  r100.ufklz       and \
                        r000.fklz    <> ::_3             and \
                        r000.fkfs    <  :+FSTATUS_FERTIG and \
                        r000.identnr =  r100.identnr     and \
                        r000.var     =  r100.var

                cursorRt030[++] = "sel_r100_2_rt030C"
            }
            dbms with cursor sel_r100_2_rt030C alias anzahlL
            dbms with cursor sel_r100_2_rt030C execute using \
                FI_NR1, \
                rt030_fklz_uebg, \
                rt030_fklz
            dbms with cursor sel_r100_2_rt030C alias

            // Sind alle untergeordneten FA zum übergeordneten FA fertiggemeldet?
            if (anzahlL == 0) {
                // Freigabe normaler Fertigungsauftrag oder Versorgungsauftrag?
                if (cod_aart_versorg(rt030_aart_uebg) == TRUE) {
                    if (dm_is_cursor("sel_r100_3_rt030C") != TRUE) {
                        dbms declare sel_r100_3_rt030C cursor for \
                            select \
                                r100.werk, \
                                r100.lgnr, \
                                r100.fmlz \
                            from \
                                r100 \
                            where \
                                r100.fi_nr = ::_1 and \
                                r100.fklz  = ::_2

                        cursorRt030[++] = "sel_r100_3_rt030C"
                    }
                    dbms with cursor sel_r100_3_rt030C alias \
                        rt030_werk_vers, \
                        rt030_lgnr_vers, \
                        rt030_fmlz_vers
                    dbms with cursor sel_r100_3_rt030C execute using \
                        FI_NR1, \
                        rt030_fklz_uebg
                    dbms with cursor sel_r100_3_rt030C alias

                    // Abstellen eines Satzes in r725
                    rcL = rt030_insert_r725()
                    if (rcL == WARNING) {
                        rcL = rt030_update_r725()
                    }
                    if (rcL < OK) {
                        return FAILURE
                    }

                    rt030_lo_freig_vers = TRUE
                }
                else {
                    // Abstellen eines Satzes in r025
                    rcL = rt030_insert_r025()
                    if (rcL == WARNING) {
                        rcL = rt030_update_r025()
                    }
                    if (rcL < OK) {
                        return FAILURE
                    }
                    rt030_lo_freig = TRUE
                }
            }
        }
        dbms with cursor sel_r000_2_rt030C continue
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_insert_r025
#
# Satz für Fertigungsauftrag in die Aktionstabelle r025 abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_insert_r025()
{
    call bu_noerr()

    dbms sql \
        insert into \
            r025 \
        ( \
            fi_nr, \
            werk, \
            fklz, \
            freigabe, \
            aufnr, \
            aufpos, \
            fu_freig, \
            fu_matpr, \
            logname, \
            kz_matpr, \
            jobid, \
            vstat, \
            kz_fhl \
        ) values ( \
            :+FI_NR1, \
            :+rt030_werk_uebg, \
            :+rt030_fklz_uebg, \
            :+rt030_freigabe_uebg, \
            :+rt030_aufnr_uebg, \
            :+rt030_aufpos_uebg, \
            '4', \
            :+rt030_R_MATPR, \
            :+LOGNAME, \
            0, \
            0, \
            :+NULL, \
            :+NULL \
        )

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLE_DUPKEY:
            return WARNING
        else:
            // Fehler beim Einfügen in Tabelle %s
            return on_error(FAILURE, "APPL0003", "r025", "rt030_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_update_r025
#
# Satz in Tabelle r025 updaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_update_r025()
{
    vars lockedL


    lockedL = TRUE
    while (lockedL == TRUE) {
        dbms sql \
            update \
                r025 \
            set \
                fu_freig = '4', \
                fu_matpr = :+rt030_R_MATPR, \
                logname  = :+LOGNAME, \
                kz_matpr = '0' \
            where \
                r025.fi_nr =  :+FI_NR1     and \
                r025.fklz  =  :+rt030_fklz and \
                r025.jobid <= 0

        switch (SQL_CODE) {
            case SQL_OK:
                lockedL = FALSE
                break
            case SQLE_ROWLOCKED:
                // Aktion Auftragsfreigabe %s von einem anderen Benutzer gesperrt
                call bu_msg("r0250002", rt030_fklz)
                break
            else:
                // Fehler beim Ändern in Tabelle %s
                return on_error(FAILURE, "APPL0004", "r025", "rt030_proto")
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_insert_r725
#
# - Erstellung Aktionssatz Versorgung
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_insert_r725()
{
    vars kzdruckL


    if (R_DR_VERSRt030 == NULL) {
        kzdruckL = "1"
    }
    else {
        kzdruckL = R_DR_VERSRt030
    }

    call bu_noerr()

    dbms sql \
        insert into \
            r725 \
        ( \
            fi_nr, \
            werk, \
            lgnr, \
            jobid, \
            logname, \
            datuhr, \
            fmlz, \
            fklz, \
            kn_freigabe, \
            kzdruck, \
            aufnr, \
            aufpos, \
            kn_dr_kom, \
            kn_dr_ls \
        ) values ( \
            :+FI_NR1, \
            :+rt030_werk_vers, \
            :+rt030_lgnr_vers, \
            0, \
            :+LOGNAME, \
            :CURRENT, \
            :+rt030_fmlz_vers, \
            :+rt030_fklz_uebg, \
            '4', \
            :+kzdruckL, \
            :+rt030_aufnr_uebg, \
            :+rt030_aufpos_uebg, \
            '0', \
            '0' \
        )

    switch (SQL_CODE) {
        case SQL_OK:
            break
        case SQLE_DUPKEY:
            return WARNING
        else:
            // Fehler beim Einfügen in Tabelle %s
            return on_error(FAILURE, "APPL0003", "r725", "rt030_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_update_r725
#
# Satz in Tabelle r725 updaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt030_update_r725()
{
    vars lockedL


    lockedL = TRUE
    while (lockedL == TRUE) {
        dbms sql \
            update \
                r725 \
            set \
                fu_freig = '4', \
                logname  = :+LOGNAME \
            where \
                r725.fi_nr =  :+FI_NR1     and \
                r725.fklz  =  :+rt030_fklz and \
                r725.jobid <= 0

        switch (SQL_CODE) {
            case SQL_OK:
                lockedL = FALSE
                break
            case SQLE_ROWLOCKED:
                // Aktion Auftragsfreigabe %s von einem anderen Benutzer gesperrt
                call bu_msg("r0250002", rt030_fklz)
                break
            else:
                // Fehler beim Ändern in Tabelle %s
                return on_error(FAILURE, "APPL0004", "r725", "rt030_proto")
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rr030_start_freigabe
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_start_freigabe()
{
    vars own_transL


    call sm_n_1clear_array("partab")
    partab[1] = LOGNAME
    partab[6] = "3"
    partab[8] = LANG_EXT

    own_transL = !SQL_IN_TRANS
    if (own_transL == TRUE) {
        if (bu_begin() != OK) {
            return FAILURE
        }
    }

    call bu_job("rh020", NULL, NULL, NULL, NULL, NULL, "!l")

    if (own_transL == TRUE) {
        call bu_commit()
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_start_freigabe_vers
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_start_freigabe_vers()
{
    vars own_transL


    call sm_n_1clear_array("partab")
    partab[1] = LOGNAME
    partab[3] = 0       // jobid

    own_transL = !SQL_IN_TRANS
    if (own_transL == TRUE) {
        if (bu_begin() != OK) {
            return FAILURE
        }
    }

    call bu_job("rh720", NULL, NULL)

    if (own_transL == TRUE) {
        call bu_commit()
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_proto_kb(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    if (rt030_proto(rcP, prt_ctrlP, msg_nrP, msg_zusatzP) != OK) {
        return FAILURE
    }

    if (rt030_kanbannr != NULL) {
        if (rt030_proto_d816(rcP) != OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_proto_d816(rcP)
{
    vars fmlzL
    vars dispnL
    vars einkaeuferL
    vars koststL


    if (cod_aart_versorg(rt030_aart) == TRUE) {
        dbms alias fmlzL
        dbms sql \
            select \
                r100.fmlz \
            from \
                r100 \
            where \
                r100.fi_nr = :+FI_NR1 and \
                r100.fklz  = :+rt030_fklz
        dbms alias
    }
    else {
        fmlzL = NULL
    }

    dbms alias \
        dispnL, \
        einkaeuferL
    dbms sql \
        select \
            g020.dispn, \
            g043.einkaeufer \
        from \
            g020, \
            g043 \
        where \
            g020.fi_nr   = :+FI_NR1 and \
            g020.werk    = :+rt030_werk_r000 and \
            g020.lgnr    = :+rt030_lgnr_r000 and \
            g020.identnr = :+rt030_identnr and \
            g020.var     = :+rt030_var and \
            g043.fi_nr   = g020.fi_nr and \
            g043.identnr = g020.identnr and \
            g043.var     = g020.var
    dbms alias

    dbms alias koststL
    dbms sql \
        select \
            d800.kostst \
        from \
            d800 \
        where \
            d800.fi_nr    = :+FI_NR1 and \
            d800.kanbannr = :+rt030_kanbannr
    dbms alias

    rt030_kanbananfnr += 0
    rt030_aufpos      += 0

    call bu_noerr()

    dbms sql \
        insert into \
            d816 \
        ( \
            fi_nr, \
            datuhr, \
            werk, \
            jobid, \
            logname, \
            kanbananfnr, \
            kanbannr, \
            kostst, \
            identnr, \
            var, \
            lgnr, \
            lgber, \
            lgfach, \
            fertig_dat, \
            freig_dat, \
            rueck_dat, \
            bvor_art, \
            soll_menge, \
            ist_menge, \
            status, \
            kostst_akt, \
            lfdnr_etik, \
            kostst_q, \
            lgnr_q, \
            lgber_q, \
            lgfach_q, \
            msg_text, \
            msg_typ, \
            kz_verarb, \
            kommentar, \
            dataen, \
            kbfehlerart, \
            einkaeufer, \
            dispn, \
            fklz, \
            fmlz, \
            bestnr, \
            bestpos, \
            aufnr, \
            aufpos, \
            vorschlnr \
        ) values ( \
            :+FI_NR1, \
            :CURRENT, \
            :+rt030_werk_r000, \
            0, \
            :+LOGNAME, \
            :+rt030_kanbananfnr, \
            :+rt030_kanbannr, \
            :+koststL, \
            :+rt030_identnr, \
            :+rt030_var, \
            :+rt030_lgnr_r000, \
            :+NULL, \
            :+NULL, \
            :+BU_DATE0, \
            :+BU_DATE0, \
            :+BU_DATE0, \
            :+NULL, \
            0, \
            0, \
            0, \
            0, \
            0, \
            0, \
            0, \
            :+NULL, \
            :+NULL, \
            :+msg_text, \
            :+msg_typ, \
            '0', \
            :+NULL, \
            :CURRENT, \
            '0', \
            :+einkaeuferL, \
            :+dispnL, \
            :+rt030_fklz, \
            :+fmlzL, \
            :+NULL, \
            0, \
            :+rt030_aufnr, \
            :+rt030_aufpos, \
            0 \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle %s
        return on_error(FAILURE, "APPL0003", "d816")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# proc rt030_call_rm131()
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_call_rm131(stornoP)
{
    int rcL


    // keine Verarbeitung erforderlich
    if ( \
        ( \
            rt030_aart != "0" && \
            rt030_aart != "6" \
        ) || \
        rt030_menge_meld == 0 \
    ) {
        return OK
    }

    rm131_handleRt030 = fertig_load_modul("rm131", rm131_handleRt030)
    if (rm131_handleRt030 < OK) {
        return FAILURE
    }

    call rm131_activate(rm131_handleRt030)
    call rm131_init()
    FI_NR1Rm131E       = FI_NR1
    fklzRm131EA        = rt030_fklz
    stornoRm131E       = stornoP
    mengeZugangRm131EA = rt030_menge_meld
    lgnrRm131E         = rt030_lgnr_r000
    lgberRm131E        = rt030_lgber
    lgfachRm131E       = rt030_lgfach
    etikettRm131EA     = etikettRt030

    rcL = rm131_verarbeiten()
    if (rcL < OK) {
        call bu_msg_errmsg("rm131")
        call rm131_deactivate(rm131_handleRt030)
        return fertig_fehler_proto(rcL, "rt030_proto", NULL)
    }
    if (rcL > OK) {
        call bu_msg_errmsg("rm131")
        call fertig_fehler_proto(rcL, "rt030_proto", PRT_CTRL_FEHLER)
    }

    call rm131_deactivate(rm131_handleRt030)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_SET_KTR_STATUS
#
# - Fortschreiben des Kostenträgerstatus
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_set_ktr_status()
{
    int  rcL
    vars anzahlL
    vars statusL


    if ( \
        C_KTR_AKTIV       != "1"  || \
        ktr_handle_cm100  == NULL || \
        rt030_kosttraeger == NULL \
    ) {
        return OK
    }

    switch (rt030_fu_farm) {
        case "7":
        case "8":
            // Prüfen, ob alle Aufträge auf Status "7"
            dbms alias anzahlL
            dbms sql \
                select \
                    count(*) \
                from \
                    r000 \
                where \
                    r000.fi_nr       =  :+FI_NR1 and \
                    r000.kosttraeger =  :+rt030_kosttraeger and \
                    r000.fkfs        <  :+FSTATUS_FERTIG    and \
                    r000.fklz        <> :+rt030_fklz
            dbms alias

            // Es gibt noch "nicht-fertiggemeldete" Aufträge zu diesem Kostenträger,
            // Kostenträgerstatus kann nicht auf "gefertigt" gesetzt werden.
            if (anzahlL > 0) {
                return OK
            }

            statusL = "2"
            break
        case "1":
        case "2":
            statusL = "1"
            break
        else:
            call bu_assert(FALSE)
            break
    }

    call cm100_activate(ktr_handle_cm100)
    call cm100_init()
    kosttraegerCm100 = rt030_kosttraeger
    rcL = cm100_ktr_status(statusL)
    call bu_msg_errmsg("cm100")
    call cm100_deactivate(ktr_handle_cm100)

    if (rcL < OK) {
        return on_error(FAILURE)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
#  rt030_pruefe_ts
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_pruefe_ts()
{
    int  rcL
    vars warn_2_failL


    if (dm_is_cursor("sel_g040_rt030C") != TRUE) {
        dbms declare sel_g040_rt030C cursor for \
            select \
                g040.ts \
            from \
                g040 \
            where \
                g040.fi_nr   = ::_1 and \
                g040.identnr = ::_2 and \
                g040.var     = ::_3

        cursorRt030[++] = "sel_g040_rt030C"
    }
    dbms with cursor sel_g040_rt030C alias rt030_ts
    dbms with cursor sel_g040_rt030C execute using \
        FI_NR1, \
        rt030_identnr, \
        rt030_var
    dbms with cursor sel_g040_rt030C alias

    warn_2_failL = warn_2_fail
    warn_2_fail = FALSE
    rcL = g_check_ts_all(g_chk_ts(1, 1), rt030_identnr, rt030_var, rt030_ts, "rt030_proto")
    warn_2_fail = warn_2_failL

    return rcL
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_set_reservierung_bedarf(lgnrP, stornoP, busP, reservnrP, werkP)
{
    vars naechsterL


    if (stornoP == 1) {
        return OK
    }

    if ( \
        reservnrP != "*"  && \
        reservnrP != NULL \
    ) {
        return OK
    }

    // Bei Bedarfen zu Lagereinheiten darf die Reservierung nicht ausgeführt werden.
    if (rt030_kn_lagereinheit == "1") {
        return OK
    }

    if (cod_aart_reparatur(rt030_aart) == TRUE) {
        return OK
    }

    // Automatische Reservierung aktiv?
    switch (bu_getenv("RT121_AKTIV")) {
        case "1":
        case "2":
            break
        else:
            return OK
    }

    // Buchungsschlüssel in der Liste für physische Reservierung?
    if (bu_strstr(bu_getenv("L_BUS_RESERVE"), "+" ## busP ## "+" ) == 0) {
        return OK
    }

    // Daten für spätere Reservierung in Array abstellen
    naechsterL                  = bunr_resRt030->num_occurrences + 1
    bunr_resRt030[naechsterL]   = rt030_bunr
    bus_resRt030[naechsterL]    = busP
    werk_resRt030[naechsterL]   = werkP
    lgnr_resRt030[naechsterL]   = lgnrP
    charge_resRt030[naechsterL] = rt030_charge
    menge_resRt030[naechsterL]  = rt030_menge_l100

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Reservierungen in einer separaten Transaktion (am Ende der Verarbeitung) durchführen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_reservierung_bedarf()
{
    int rcL
    int iL
    int jL


    if (bunr_resRt030->num_occurrences <= 0) {
        return OK
    }

    public rm121.bsl
    if (rm121_handleRt030 == NULL) {
        rm121_handleRt030 = rm121_load()
        if (rm121_handleRt030 < OK) {
            // Fehler beim Laden des Moduls %s!
            call bu_msg("APPL0520", "rm121")
            return FAILURE
        }
    }

    call rm121_activate(rm121_handleRt030)

    for iL = 1 while (iL <= bunr_resRt030->num_occurrences) step 1 {
        call rm121_init()
        werkRm121E      = werk_resRt030[iL]
        lgnrRm121E      = lgnr_resRt030[iL]
        identnrRm121E   = rt030_identnr
        varRm121E       = rt030_var
        chargeRm121E    = charge_resRt030[iL]
        menge_gelRm121E = menge_resRt030[iL]
        kn_sobeRm121E   = "0"
        bunrRm121E      = bunr_resRt030[iL]
        aufnrRm121E     = rt030_aufnr
        aufposRm121E    = rt030_aufpos
        fklz_uebgRm121E = rt030_fklz

        // 300270538
        // Bei der geplanten Buchung (erste Buchung) muss der Auftragsbezug bei Primär- und Sekundäraufträgen
        // berücksichtigt werden.
        if ( \
            bus_resRt030[iL] == R_BUSZUG_G && \
            ( \
                cod_aart_vertriebsfa(rt030_aart) == TRUE || \
                cod_aart_sek(rt030_aart)         == TRUE \
            ) \
        ) {
            flagLagerstammRm121E = "2"
        }

        rcL = rm121_reservieren(rm121_handleRt030)
        if (rcL != OK) {
            // Meldungen aus Array holen und in Protokollierungstabelle speichern
            for jL = 1 while (jL <= errmsgRm121->num_occurrences) step 1 {
                call bu_split(errmsgRm121[jL], "stringtab", ESCFLG)
                call bu_get_msg(stringtab[1], stringtab[2], stringtab[3])
                call rt030_proto(rcL, $NULL, $NULL, $NULL)
            }
        }
        call bu_msg_errmsg("rm121")
    }

    call rm121_deactivate(rm121_handleRt030)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt030_get_bu_monat
# Buchungsmonat raussuchen:
# wenn Parameter l_lager_bumonat = 0  dann aus g990
# wenn Parameter l_lager_bumonat aus Tagesdatum
# wenn g020.abmonat, abjahr > d.h. Monatsabschluss für das Teil bereits
#                             gelaufen, dann das vorgeben
#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_get_bu_monat(werkP, lgnrP)
{
    vars abmonatL
    vars abjahrL
    vars monatL
    vars jahrL


    if (bu_getenv("L_BUMONAT") == "0") {
        dbms alias rt030_bu_monat
        dbms sql \
            select \
                g990.inhalt \
            from \
                g990 \
            where \
                g990.fi_nr = :+FI_NR1 and \
                g990.feld  = 'bu_monat'
        dbms alias

        dbms alias \
            abmonatL, \
            abjahrL
        dbms sql \
            select \
                g020.abmonat, \
                g020.abjahr \
            from \
                g020 \
            where \
                g020.fi_nr   = :+FI_NR1 and \
                g020.werk    = :+werkP and \
                g020.lgnr    = :+lgnrP and \
                g020.identnr = :+rt030_identnr and \
                g020.var     = :+rt030_var
        dbms alias

        // Monatsabschluss läuft gerade und ist für dieses Teil bereits fertig
        monatL = rt030_bu_monat(5, 2)
        jahrL  = rt030_bu_monat(1, 4)
        if ( \
            monatL == abmonatL && \
            jahrL  == abjahrL \
        ) {
            if (++monatL > 12) {
                monatL = 1
                jahrL++
            }

            if (@length(monatL) == 1) {
                monatL = "0" ## monatL
            }

            rt030_bu_monat = jahrL ## monatL
        }
    }
    else {
        jamdatuhr      = bu_get_datetime()
        rt030_bu_monat = @date(jamdatuhr)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_load_gm300(fi_nrP, werkP)
{
    rt030_handle_gm300 = bu_load_modul("gm300", rt030_handle_gm300)
    if (rt030_handle_gm300 < 0) {
        return FAILURE
    }

    // einmalig den zu verwendenden Kalender ermitteln
    call gm300_activate(rt030_handle_gm300)
    call gm300_init()
    fi_nrGm300E = fi_nrP
    werkGm300E  = werkP
    if (gm300_kalender_ermitteln() != OK) {
        call bu_msg_errmsg("Gm300", NULL)
        call gm300_deactivate(rt030_handle_gm300)
        return on_error(FAILURE, "", "", "rt030_proto")
    }
    call gm300_deactivate(rt030_handle_gm300)

    return OK
}

/**
 * Schnittstelle Werkstattsteuerung bedienen
 *
 * - den ersten Arbeitsgang lesen => min(r200.agpos)
 * - wenn Übergabe erforderlich, Aufruf "rt822"
 *
 * @return      OK
 * @return      FAILURE
 **/
int proc rt030_werkstattsteuerung()
{
    int     rcL
    int     aes_rt822   // Änderungsschlüssel für WS
    string  falzL
    string  fklzL
    int     agposL
    int     splitnrL
    string  fafsL

    dbms alias falzL     \
             , agposL    \
             , fklzL     \
             , splitnrL  \
             , fafsL

    dbms sql select r200.falz                            \
                  , r200.agpos                           \
                  , r200.fklz                            \
                  , r200.splitnr                         \
                  , r200.fafs                            \
               from r200                                 \
              where r200.fi_nr = :+FI_NR1              \
                and r200.fklz  = :+rt030_fklz          \
                and r200.agpos = (select min(r200.agpos)       \
                                    from r200                  \
                                   where r200.fi_nr = :+FI_NR1 \
                                     and r200.fklz  = :+rt030_fklz)

    dbms alias

    if (SQL_CODE != SQL_OK && SQL_CODE != SQLNOTFOUND) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r200", "rt030_proto")
    }

    if (fafsL < FSTATUS_FREIGEGEBEN || fafsL == FSTATUS_STORNIERT) {
        return OK
    }

    if (fklzL != NULL) {
        aes_rt822 = cAES_UPDATE

        if (rt030_load_rt822() != OK) {
            return FAILURE
        }

        send bundle "b_rt822" data \
            falzL, \
            fklzL, \
            agposL, \
            splitnrL, \
            aes_rt822, \
            werk

        rcL = rt822_uebergabe(rt030_rt822_handle)
        if (rcL < OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt030_load_rt822()
{
    public rt822:(EXT)
    if (rt030_rt822_handle <= 0) {
        rt030_rt822_handle = rt822_first_entry("rt030_proto")
        if (rt030_rt822_handle < OK) {
            unload rt822:(EXT)
            // Fehler beim Laden des Moduls %s!
            return on_error(FAILURE , "APPL0520" , "rt822", "rt030_proto")
        }
        call rt822_entry(rt030_rt822_handle)
    }

    return OK
}

/**
 * Ausgabe der Meldung "Auftragsrückmeldung wird durchgeführt" (ral00100)
 *
 * @return OK
 * @see         rt230_meldung_ag_rueckm_durchfuehren
 **/
int proc rt030_meldung_ag_rueckm_durchfuehren()
{
    string msg_nrL   = msg_nr
    string msg_textL = msg_text
    string msg_typL  = msg_typ

    if (BATCH == TRUE) {
        return OK
    }


    //TODO OB: Muss diese Meldung hier im Modul eigentlich ausgegeben werden?
    //         Im rufenden Dialogprogramm wäre das m.E. sinnvoller.

    // Auftragsrückmeldung wird durchgeführt
    call bu_msg("ral00100")


    // Die globalen MSG-Felder initialisieren und ggf wieder rücksichern, wenn vorher eine (Fehler-)Meldung drin
    // gestanden ist. Es soll niemals die Meldung "ral00112" an den Aufrufer übergeben werden!
    call fertig_fehler_init_globale_felder(FALSE)
    if ((defined(msg_nrL)   == TRUE && msg_nrL   != "") \
    ||  (defined(msg_textL) == TRUE && msg_textL != "")) {
        msg_nr   = msg_nrL
        msg_text = msg_textL
        msg_typ  = msg_typL
    }

    return OK
}
