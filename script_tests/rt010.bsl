#-----------------------------------------------------------------------------------------------------------------------
# Modul Bedarfsrechnung/ Terminierung Fertigungsauftrag
#-----------------------------------------------------------------------------------------------------------------------
#
# Beschreibung:
# -------------
#
# Dieses Modul enthält Funktionen für die Bedarfsrechnung und Terminierung
# eines Fertigungsauftrags. Dies sind im Wesentlichen:
#
#   - prüfen, ob Bedarfsrechnung durchgeführt werden darf
#   - Nettobedarfsrechnung (Absetzen des verfügbaren Bestands)
#   - Anstoß Strukturkostenverdichtung, Bestellrechnung, Druck FA-Papiere
#   - Protokollierung
#
#
# Funktionen:
# -----------
#
# rt010_pruefen       Prüfungen durchführen für Fertigungsauftrag
# rt010_nettobedarf   Nettobedarfsermittlung
# rt010_abschliessen  Abschließende Tätigkeiten ausführen
#
# rt010_daten_neu     Geänderte Daten an rufendes Programm senden
#
# rt010_protokoll     Protokollsatz schreiben für Fertigungsauftrag
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# - Laden und aktivieren des LDB
# - Funktion "first_entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_first_entry(protP)
{
    vars handleL
    vars cdtTermGlobalL

    handleL = sm_ldb_load("rt010.ldb")
    if (handleL < OK) {
        return FAILURE
    }
    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, TRUE)
    name_cdtTermGlobal_rt010 = "cdtTermGlobalRt010_" ## handleL

    // Kontext Terminierungsmodul einmalig erzeugen
    public cdtTermGlobal.bsl
    cdtTermGlobalL = cdtTermGlobal_new(FALSE)
    unload cdtTermGlobal.bsl
    call boa_cdt_put(cdtTermGlobalL, name_cdtTermGlobal_rt010)


    rt010_prot = protP
    if (rt010_prot == NULL) {
        rt010_prot = "rt010_proto_kb"
    }
    log LOG_DEBUG, LOGFILE, "rt010_prot >" ## rt010_prot ## "<"

    rt010_werk = werk

    // 300165417 (1)
    // 300164154
    R_VERSCHIEB_SYSFIXRt010     = bu_getenv("R_VERSCHIEB_SYSFIX")
    if (R_VERSCHIEB_SYSFIXRt010 != "0") {
        R_VERSCHIEB_SYSFIXRt010 = "1"
    }

    // 300166712
#   R_VERSCHIEB_AGRt010     = bu_getenv("R_VERSCHIEB_AG")
#   if R_VERSCHIEB_AGRt010 != "1"
#   {
#       R_VERSCHIEB_AGRt010 = "0"
#   }


    rt010_rt010_handle = handleL

    fm000_handle_rt010 = bu_load_modul("fm000", fm000_handle_rt010)
    if (fm000_handle_rt010 < 0) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)        // 300170598
        return FAILURE
    }

    rt010_lt110_handle = NULL
    public lt110:(EXT)
    rt010_lt110_handle = lt110_first_entry("rt010_proto")
    if (rt010_lt110_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public rt065:(EXT)
    rt010_rt065_handle = rt065_first_entry("rt010_proto")
    if (rt010_rt065_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public dt510:(EXT)
    rt010_dt510_handle = dt510_first_entry("rt010_proto")
    if (rt010_dt510_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public vt110r:(EXT)
    rt010_vt110r_handle = vt110r_first_entry("2", "rt010_proto")
    if (rt010_vt110r_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    rt010_handle_rm010v = bu_load_modul("rm010v", rt010_handle_rm010v)

    rt010_cm130 = -1

    // Parameter aus "par" lesen

    rt010_R_MATPR       = bu_getenv("R_MATPR")
    rt010_R_FS_MAEND    = bu_getenv("R_FS_MAEND")
    rt010_R_FS_TAEND    = bu_getenv("R_FS_TAEND")
    rt010_D_KZ_MINDVFG  = bu_getenv("D_KZ_MINDVFG")
    rt010_G_CHK_TS      = bu_getenv("G_CHK_TS")
    rt010_D_LAGER_BEZUG = bu_getenv("D_LAGER_BEZUG")
    rt010_R_FS_TAUSCH   = bu_getenv("R_FS_TAUSCH")
    rt010_R_VDISPO      = bu_getenv("R_VDISPO")
    R_DR_VERS_Rt010     = bu_getenv("R_DR_VERS")

    rt010_rt090_handle = bu_load_tmodul("rt090", rt010_rt090_handle)
    if (rt010_rt090_handle < OK) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // MCS Einstellungen Firmennummern
    firmenkopplungRt010 = cod_vereinfachte_firmenkopplung(fi_nr, FALSE)

    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)

    return handleL
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_entry
#
# - aktivieren des LDB
# - Funktion "entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_entry(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    if (rt010_lt110_handle > 0) {
        public lt110:(EXT)
        call lt110_entry(rt010_lt110_handle)
    }

    if (rt010_rt065_handle > 0) {
        public rt065:(EXT)
        call rt065_entry(rt010_rt065_handle)
    }

    if (rt010_vt110r_handle > 0) {
        public vt110r:(EXT)
        call vt110r_entry(rt010_vt110r_handle)
    }

    if (rt010_rt090_handle > 0) {
        public rt090:(EXT)
        call rt090_entry(rt010_rt090_handle)
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_exit
#
# - aktivieren des LDB
# - Funktion "exit" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_exit(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    if (rt010_lt110_handle > 0) {
        public lt110.bsl
        call lt110_exit(rt010_lt110_handle)
    }

    if (rt010_rt065_handle > 0) {
        public rt065.bsl
        call rt065_exit(rt010_rt065_handle)
    }

    if (rt010_dt510_handle > 0) {
        public dt510:(EXT)
        call dt510_exit(rt010_dt510_handle)
    }

    if (rt010_vt110r_handle > 0) {
        public vt110r.bsl
        call vt110r_exit(rt010_vt110r_handle)
    }

    if (rt010_rt090_handle > 0) {
        public rt090.bsl
        call rt090_exit(rt010_rt090_handle)
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_last_exit
#
# - aktivieren des LDB
# - Funktion "last_exit" der untergeordneten Module aufrufen
# - deaktivieren und entladen des LDB
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_last_exit(handleP)
{
    int i1L
    string kontext_cacheL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    if (dm_is_cursor("rt010_netto_mat") == TRUE) {
        dbms close cursor rt010_netto_mat
    }
    if (dm_is_cursor("rt010_read_r000") == TRUE) {
        dbms close cursor rt010_read_r000
    }
    if (dm_is_cursor("rt010_read_f200") == TRUE) {
        dbms close cursor rt010_read_f200
    }
    if (dm_is_cursor("rt010_chk_f200") == TRUE) {
        dbms close cursor rt010_chk_f200
    }
    if (dm_is_cursor("rt010_read_f100") == TRUE) {
        dbms close cursor rt010_read_f100
    }
    if (dm_is_cursor("rt010_chk_f100") == TRUE) {
        dbms close cursor rt010_chk_f100
    }
    if (dm_is_cursor("rt010_read_f010") == TRUE) {
        dbms close cursor rt010_read_f010
    }
    if (dm_is_cursor("rt010_read_v110") == TRUE) {
        dbms close cursor rt010_read_v110
    }
    if (dm_is_cursor("rt010_read_g000") == TRUE) {
        dbms close cursor rt010_read_g000
    }
    if (dm_is_cursor("rt010_read_uebg") == TRUE) {
        dbms close cursor rt010_read_uebg
    }
    if (dm_is_cursor("rt010_sum_uebg") == TRUE) {
        dbms close cursor rt010_sum_uebg
    }
    if (dm_is_cursor("rt010_abs_r000") == TRUE) {
        dbms close cursor rt010_abs_r000
    }
    if (dm_is_cursor("rt010_lock_r100") == TRUE) {
        dbms close cursor rt010_lock_r100
    }
    if (dm_is_cursor("rt010_objektid") == TRUE) {
        dbms close cursor rt010_objektid
    }
    if (dm_is_cursor("rt010_read_g000v") == TRUE) {
        dbms close cursor rt010_read_g000v
    }
    if (dm_is_cursor("GetVDispoRt010") == TRUE) {
        dbms close cursor GetVDispoRt010
    }
    if (dm_is_cursor("rt010CurSbterm") == TRUE) {
        dbms close cursor rt010CurSbterm
    }
    for i1L = 1 while i1L <= cursorRt010->num_occurrences step 1 {
        jamstring = cursorRt010[i1L]

        if (dm_is_cursor(jamstring) == TRUE) {
            dbms close cursor :jamstring
        }
    }
    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000pruef")
    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000abschl")


    // Module entladen
    call fertig_unload_tm_module(0, "ft010", "rt010_ft010_handle")
    call fertig_unload_tm_module(0, "lt110", "rt010_lt110_handle")
    call fertig_unload_tm_module(0, "rt065", "rt010_rt065_handle")
    call fertig_unload_tm_module(0, "dt510", "rt010_dt510_handle")
    call fertig_unload_tm_module(0, "kt410", "rt010_kt410_abg_handle")
    call fertig_unload_tm_module(0, "kt410", "rt010_kt410_handle")
    call fertig_unload_tm_module(0, "kt431", "rt010_kt431_handle")
    call fertig_unload_tm_module(0, "kt465", "rt010_kt465_handle")
    call fertig_unload_tm_module(0, "vt110r", "rt010_vt110r_handle")
    call fertig_unload_tm_module(0, "rt090", "rt010_rt090_handle")
    call fertig_unload_tm_module(1, "fm000", "fm000_handle_rt010")
    call fertig_unload_tm_module(1, "rm010v", "rt010_handle_rm010v")
    call fertig_unload_tm_module(1, "rm054", "rm054_handle_rt010")
    call fertig_unload_tm_module(1, "gm790", "rt010_gm790_handle")
    call fertig_unload_tm_module(1, "gm300", "handleGm300Rt010")
    call fertig_unload_tm_module(1, "cm130", "rt010_cm130")

    public rq1004.bsl
    call verknuepfungRq1004Unload()
    unload rq1004.bsl


    kontext_cacheL = name_cdtTermGlobal_rt010
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    // q-Module der Terminierung entladen
    call fertig_unload_terminierungsmodule($NULL, kontext_cacheL)

    call sm_ldb_h_unload(handleP)
    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_pruefen
#
# Prüfungen für Fertigungsauftrag durchführen
# - Fertigungsauftrag muß vorhanden sein
# - Fertigungsstatus prüfen
# - Teilestamm muß vorhanden sein
# - Teilestatus prüfen
# - Lesen Referenztabelle für auftragsbezogene Stammdaten, wenn
#   auftragsbezogene Stammdaten
# - Arbeitsplan-Kopfauswahl
# - Stücklisten-Kopfauswahl
#
# - Returns:   RC_PRUEFEN_BEDR_OK           0  - Bedarfsrechnung kann durchgeführt werden
#              RC_PRUEFEN_BEDR_NICHT        1  - Bedarfsrechnung kann nicht durchgeführt werden
#              RC_PRUEFEN_BEDR_ZURUECK      2  - Bedarfsrechnung muß zurückgestellt werden
#              RC_PRUEFEN_BEDR_TEILWEISE    3  - Bedarfsrechnung kann nur teilweise durchgeführt werden, Rest muß zurückgestellt werden
#              RC_PRUEFEN_BEDR_EINPL        14 - fu_bedr=2 und Auftragsbezogenen STL und keine STL bzw. APL vorhanden -> Neueinplanung (fu_bedr=3 und kz_fhl="") durchführen, mit sofortiger Verarbeitung
#              RC_PRUEFEN_BEDR_EINPL_OV     15 - fu_bedr=2 und Auftragsbezogenen STL und keine STL bzw. APL vorhanden -> Neueinplanung (fu_bedr=3 und kz_fhl="") durchführen, ohne sofortiger Verarbeitung
#              RC_PRUEFEN_BEDR_EINPL_FHL    4  - fu_bedr=2 und Auftragsbezogenen STL und keine STL bzw. APL vorhanden -> Neueinplanung (fu_bedr=3 und kz_fhl="1") durchführen
#              RC_PRUEFEN_BEDR_GELOESCHT    5  - FA geölscht (for future use)
#              RC_PRUEFEN_BEDR_NEXT         9  - Aktionssatz überlesen
#              FAILURE                      -1 - Verarbeitungsfehler
# See: rh110_done_bedr
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefen(handleP, boolean ausNeuerTerminierungP, cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int rcL
    int rcodeL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    rcL = rt010_receive_rt010($NULL)
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    rcodeL = rt010_pruefen_verarb(ausNeuerTerminierungP, standortkalenderP, r000P)
    log LOG_DEBUG, LOGFILE, "ReturnCode rt010_pruefen_verarb >" ## rcodeL ## "<"
    switch (rcodeL) {
        case RC_PRUEFEN_BEDR_OK:            // Alles OK
        case RC_PRUEFEN_BEDR_EINPL_FHL:     // Neueinplanung mit Fehler in r115
        case RC_PRUEFEN_BEDR_EINPL:         // Neueinplanung ohne Fehler in r115
        case RC_PRUEFEN_BEDR_EINPL_OV:      // Neueinplanung ohne Fehler in r115
            break
        case RC_PRUEFEN_BEDR_NICHT:         // Bedarfsrechnung kann nicht durchgeführt werden
            // Returncode 1 bedeutet doch, dass der FA nicht mehr verarbeitet werden muss und der Aktionssatz ohne weitere
            // Verarbeitung gelöscht werden kann! Unabhängig davon warum der erstellt wurde!!
            // weitere Aktionen sind nicht mehr erforderlich!
            // hier das kn_terminiert nicht auf "Fehler" setzen, sondern wieder auf "nicht terminiert" gesetzt.
            // 300325828: BU_1 kommt auch, wenn r000 nicht mehr vorhanden.
            // 300330719: Auch wenn es zu einem angearbeiteten FA einen Aktionssatz mit Storno gibt
            call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_NEIN, rcodeL, r000P)
//TODO: Erzeugen einer Meldung ins Protokoll?
            break
        case RC_PRUEFEN_BEDR_ZURUECK:       // Bedarfsrechnung muß zurückgestellt werden
        case RC_PRUEFEN_BEDR_NEXT:          // Aktionssatz überlesen
            // hier das kn_terminiert immer auf "Fehler" setzen
            call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_FEHLER, rcodeL, r000P)
            break
        case RC_PRUEFEN_BEDR_TEILWEISE:     // Bedarfsrechnung kann nur teilweise durchgeführt werden, Rest muß zurückgestellt werden
            if (R_KZ_APLSP == "1" \
            ||  R_KZ_STLSP == "1") {
                // hier das kn_terminiert immer auf "Fehler" setzen
                call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_FEHLER, rcodeL, r000P)
            }
            break
        case RC_PRUEFEN_BEDR_KEINE_AG:      // Kein APL
            if (R_KZ_APLSP == "1") {
                // hier das kn_terminiert immer auf "Fehler" setzen
                call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_FEHLER, rcodeL, r000P)
            }
            break
        case RC_PRUEFEN_BEDR_KEINE_MAT:     // keine STL
            if (R_KZ_STLSP == "1") {
                // hier das kn_terminiert immer auf "Fehler" setzen
                call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_FEHLER, rcodeL, r000P)
            }
            break
        else:                           // Fehler
            rcodeL = FAILURE
            if (SQL_IN_TRANS == TRUE) {
                call bu_rollback()
            }
            call rt010_setzen_kn_terminiert_fa(KN_TERMINIERT_FEHLER, rcodeL, r000P)
            break
    }

    // Physikalische Sperre aauf r000 aufheben
    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000pruef")

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    return rcodeL
}

#-----------------------------------------------------------------------------------------------------------------------
# Nettobedarfsrechnung durchführen
# - Fertigungsauftrag lesen
# - Teile-/ Lagerstammdaten lesen
# - bei A-Teilen und Auftragsart = "K", V", "S" (mit überg. Bedarf)
#   . verfügbare Menge absetzen
#   . abgesetzte Menge auf Fertigungsaufträge verteilen
#   . abgesetzte Menge auf überg. Bedarfssätze verteilen und korrekte
#     Auftragsnummer und -position, sowie Endtermin zuordnen
# - Ausschußmenge berechnen, wenn nicht bereits angegeben
# - bei Einplanung Fertigungstatus auf "3" setzen
# - Fertigungsauftrag updaten
# - wenn Terminbestimmung über Wiederbeschaffungszeit / Durchlaufzeit TST
#   --> Terminbestimmung aufrufen
#
# - Returns:   OK       Nettobedarfsrechnung gelaufen
#              FAILURE  Verarbeitungsfehler
#              1        Terminverschiebung muss angestoßen werden
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_nettobedarf(handleP, cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int rcL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    rcL = rt010_receive_rt010($NULL)
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    switch (rt010_fu_bedr) {
        case cFUBEDR_STORNO:
        case cFUBEDR_MTAEND:
        case cFUBEDR_EINPLAN:
        case cFUBEDR_TAUSCH:
            break
        case cFUBEDR_VORW:
        case cFUBEDR_RUECKW:
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return OK
        else:
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
    }

    // Auftragskopf lesen und sperren
    if (rt010_get_r000_netto(r000P) < OK) {
        call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Teile- und Lagerstammdaten lesen (Modul "dt510")
    public dt510:(EXT)
    call dt510_activate(rt010_dt510_handle)
    call rt010_send_dt510()
    rcL = dt510_lesen(NULL, "0") // Lesen immer mit Lagerbezug, falls nicht D_LAGER_BEZUG = "0"
    if (rcL != OK) {
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    rt010_kn_nettobedarf = dt510_kn_nettobedarf
    if (rt010_kn_nettobedarf == "") {
        rt010_kn_nettobedarf = R_NETTOBEDARF(1, 1)
    }

    // Liste der logisch gesperrten FKLZs initialisieren
    call sm_n_1clear_array("tx_fklz_grdRt010")

    // für A-Teile und entspr. Auftragsart
    if ( \
        rt010_da                    == DA_AUFTRAG && \
        cod_aart_bedarf(rt010_aart) == TRUE \
    ) {
        // absetzen verfügbare Menge
        rcL = rt010_absetzen()
        if (rcL != OK) {
            call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
            call rt010_tx_unlock_all()
            call dt510_deactivate(rt010_dt510_handle)
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return on_error(rcL)
        }

        // abgesetzte Menge auf Fertigungsaufträge verteilen
        rcL = rt010_verteilen()
        if (rcL != OK) {
            call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
            call rt010_tx_unlock_all()
            call dt510_deactivate(rt010_dt510_handle)
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return on_error(rcL)
        }

        // abgesetzte Menge auf überg. Bedarfe verteilen und evtl.
        // Auftragsnummer/ -position, sowie Endtermin zuordnen
        rcL = rt010_uebg_bedarf(standortkalenderP, r000P)
        if (rcL != OK) {
            call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
            call rt010_tx_unlock_all()
            call dt510_deactivate(rt010_dt510_handle)
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return on_error(rcL)
        }
    }

    // Ausschußmenge berechnen
    rcL = rt010_ausschuss()
    if (rcL != OK) {
        call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
        call rt010_tx_unlock_all()
        call dt510_deactivate(rt010_dt510_handle)
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return on_error(rcL)
    }

    // Bei Einplanung Status auf "3" setzen
    if (rt010_fu_bedr == cFUBEDR_EINPLAN) {
        // bei simulativem Auftrag --> Status alt
        if (rt010_fkfs == FSTATUS_SIM) {
            rt010_fkfs_a = FSTATUS_TERMINIERT
        }
        else {
            rt010_fkfs = FSTATUS_TERMINIERT
        }
    }

    // Fertigungsauftrag updaten
    if (rt010_update_r000_netto(r000P) < OK) {
        call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
        call rt010_tx_unlock_all()
        call dt510_deactivate(rt010_dt510_handle)
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return on_error(FAILURE)
    }

    // Bei Mengenänderungen Anzahl der bereits generierten Seriennummern anpassen
    if (rt010_serienverwaltung() < OK) {
        call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
        call rt010_tx_unlock_all()
        call dt510_deactivate(rt010_dt510_handle)
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return on_error(FAILURE)
    }

    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000netto")
    call rt010_tx_unlock_all()
    call dt510_deactivate(rt010_dt510_handle)
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

/**
 * Stornierung eines Fertigungsauftrages
 *
 * @param handleP                           Handle zum LDB
 * @return RC_PRUEFEN_BEDR_OK               FA wurde auf storniert gesetzt  --> In Folge ggfs. Aktionssatz löschen
 * @return RC_PRUEFEN_BEDR_TEILWEISE        @deprecated
 * @return RC_PRUEFEN_BEDR_EINPL            FA wurde auf erfasst gesetzt    --> In Folge ggfs. Neueinplanung (fu_bedr=3 und kz_fhl="") veranlassen; mit sofortiger Verarbeitung
 * @return RC_PRUEFEN_BEDR_EINPL_OV         FA wurde auf erfasst gesetzt    --> In Folge ggfs. Neueinplanung (fu_bedr=3 und kz_fhl="") veranlassen; ohne sofortiger Verarbeitung
 * @return RC_PRUEFEN_BEDR_EINPL_FHL        FA wurde auf erfasst gesetzt    --> In Folge ggfs. Neueinplanung (fu_bedr=3 und kz_fhl=1) veranlassen
 * @return RC_PRUEFEN_BEDR_GELOESCHT        FA wurde gelöscht               --> In Folge ggfs. Aktionssatz löschen
 * @return RC_PRUEFEN_BEDR_NICHT            Logischer Fehler                --> in Folge ggfs. Aktionssatz beibehalten
 * @return FAILURE                          Fehler
 * @see                                     rq0000_stornieren_baukasten
 * @see                                     rh110_done_bedr
 * @example
 * Die Funktionalität darf nur noch aus rq0000i5_aufruf_rt010 aufgerufen werden.
 * @deprecated                              Statt dessen bitte rq0000_stornieren_baukasten verwenden!
 **/
int proc rt010_storno_fa(handleP, cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int rcL
    int rcodeL

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    rcL = rt010_receive_rt010($NULL)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_receive_rt010 rc=" ## rcL
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    rt010_fu_bedr = cFUBEDR_STORNO

    rcodeL = rt010_storno_fa_verarb(standortkalenderP, r000P)
    switch (rcodeL) {
        case RC_PRUEFEN_BEDR_OK:        // FA wurde auf storniert gesetzt
        case RC_PRUEFEN_BEDR_TEILWEISE: // FA wurde auf erfasst gesetzt
        case RC_PRUEFEN_BEDR_EINPL:     // FA wurde auf erfasst gesetzt + fu_bedr=3 + kz_fhl=""; mit sofortiger Verarbeitung
        case RC_PRUEFEN_BEDR_EINPL_OV:  // FA wurde auf erfasst gesetzt + fu_bedr=3 + kz_fhl=""; ohne sofortiger Verarbeitung
        case RC_PRUEFEN_BEDR_EINPL_FHL: // FA wurde auf erfasst gesetzt + fu_bedr=3 + kz_fhl=1
        case RC_PRUEFEN_BEDR_GELOESCHT: // FA wurde gelöscht
            break
        case WARNING:
            log LOG_DEBUG, LOGFILE, "Logischer Fehler aus rt010_storno_fa_verarb"
            rcodeL = RC_PRUEFEN_BEDR_NICHT
            break
        else:
            log LOG_WARNING, LOGFILE, "Fehler aus rt010_storno_fa_verarb, Returncode >" ## rcodeL ## "< -> FAILURE"
            if (SQL_IN_TRANS == TRUE) {
                call bu_rollback()
            }
            rcodeL = FAILURE
            break
    }

    call bu_cdbi_cursor_delete("r000", "rt010_lock_r000abschl")

    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
    return rcodeL
}

# Senden der geänderten Daten an das rufende Programm
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_daten_neu(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    call rt010_send_rt010()

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_protokoll
#
# Ansteuerung Protokollierung Fertigungsauftrag vom rufenden
# Programm aus
#
# Returns: FAILURE, OK
#-----------------------------------------------------------------------------------------------------------------------
# Aufruf aus rh110
int proc rt010_protokoll(handle, string prt_ctrlP, string fu_bedrP)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    // Daten empfangen
    if (rt010_receive_rt010(fu_bedrP) != OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    if (rt010_fklz == NULL) {
        // Felder werden für Protokollierung der Nettobedarfsrechnung nicht benötigt
        rt010_aufnr        = NULL
        rt010_aufpos       = NULL
        rt010_identnr      = NULL
        rt010_var          = NULL
        rt010_aart         = NULL
        rt010_fkfs         = NULL
        rt010_menge        = NULL
        rt010_menge_abg    = NULL
        rt010_menge_aus    = NULL
        rt010_fsterm       = NULL
        rt010_fsterm_uhr   = NULL
        rt010_seterm       = NULL
        rt010_seterm_uhr   = NULL
        rt010_fsterm_w     = NULL
        rt010_fsterm_w_uhr = NULL
        rt010_seterm_w     = NULL
        rt010_seterm_w_uhr = NULL
        rt010_fortsetz_dat = NULL
        rt010_fortsetz_uhr = NULL
        rt010_termstr      = NULL
        rt010_termart      = NULL
        rt010_werk         = NULL

        receive bundle "b_rt010_proto" data \
            rt010_identnr, \
            rt010_var, \
            rt010_lgnr, \
            rt010_werk

        if (sm_is_bundle("b_rm1004_proto") == 1) {
            receive bundle "b_rm1004_proto" data \
                rt010_fklz, \
                rt010_aufnr, \
                rt010_aufpos
        }
    }
    else {
        // Fertigungsauftrag lesen für Protokollierung

        if (rt010_sel_r000() < OK) {
            call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    // Keine Protokollierung, wenn der msg_text leer ist.
    // Die "OK-Protokollierung" muss immer über prt_ok (PRT_OK) laufen.
    if (msg_text == NULL) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return OK
    }

    if (rt010_proto($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
    return OK
}

# proc Interne_Funktionen-------------------------------------------------

/**
 * Prüfen Daten eines Fertigungsauftrgaes vor der Terminierung des Baukastens
 *
 * @param [ausNeuerTerminierungP]       Aufruf aus Neuer TErminierung (TRUE) oder nicht (FALSE)
 * @param [standortkalenderP]           Standortkalender
 * @param [r000P]                       CDBI-Instanz des FA
 * @return RC_PRUEFEN_BEDR_OK           (0)
 * @return RC_PRUEFEN_BEDR_NICHT        (1)
 * @return RC_PRUEFEN_BEDR_ZURUECK      (2)
 * @return RC_PRUEFEN_BEDR_TEILWEISE    (3)
 * @return RC_PRUEFEN_BEDR_KEINE_AG     (31)
 * @return RC_PRUEFEN_BEDR_KEINE_MAT    (32)
 * @return RC_PRUEFEN_BEDR_EINPL        (14)
 * @return RC_PRUEFEN_BEDR_EINPL_OV     (15)
 * @return RC_PRUEFEN_BEDR_EINPL_FHL    (4)
 * @return RC_PRUEFEN_BEDR_NEXT         (9)
 * @return FAILURE                      Fehler
 * @see
 * @example
 **/
int proc rt010_pruefen_verarb(ausNeuerTerminierungP, cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int       rcL
    int       rcodeL      = RC_PRUEFEN_BEDR_OK
    int       rcode_aplL  = RC_PRUEFEN_BEDR_OK
    int       rcode_stlL  = RC_PRUEFEN_BEDR_OK
    string    dyn_whereL
    string    dyn_usingL  = "FI_NR1, rt010_fklz"
    string    in_fremdL = cod_agbs_in("fremd")
    int       vorhandenL
    cdtRq000  rq000L
    string    lock_keyL
    boolean   fu_bedr234_pruefenL  = FALSE
    boolean   update_r000L         = FALSE
    BooleanBU apl_daten_geaendertL = BooleanBU_new(FALSE)
    BooleanBU stl_daten_geaendertL = BooleanBU_new(FALSE)
    R000CDBI  r000_altL            = bu_cdbi_new("r000")
    R000CDBI  r000L


    // Auftragskopf r000 lesen inkl. sperren und alte Daten merken
    rcL = rt010_get_r000_pruefen(r000P, r000_altL)
    if (rcL < OK) {
        return FAILURE
    }
    else if (rcL == WARNING) {
        return RC_PRUEFEN_BEDR_NICHT
    }


    // Prüfen fu_bedr
    if rt010_fu_bedr != cFUBEDR_STORNO && rt010_fu_bedr != cFUBEDR_MTAEND && \
       rt010_fu_bedr != cFUBEDR_EINPLAN && rt010_fu_bedr != cFUBEDR_TAUSCH && \
       rt010_fu_bedr != cFUBEDR_RUECKW && rt010_fu_bedr != cFUBEDR_VORW {
        // Falscher Funktionscode Bedarfsrechnung
        call on_error(OK, "r1150100", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    // Prüfen Fertigungsstatus
    if (rt010_fkfs == FSTATUS_SIM && SIM != TRUE) {
        return RC_PRUEFEN_BEDR_NEXT
    }

    if (rt010_fkfs == FSTATUS_AUSGESETZT || rt010_fkfs_a == FSTATUS_AUSGESETZT) {
        // Fertigungsstatus darf nicht 2 sein
        call on_error(OK, "r0000234", "", rt010_prot)
        return RC_PRUEFEN_BEDR_ZURUECK
    }

    if (rt010_fu_bedr == cFUBEDR_EINPLAN && (rt010_fkfs > FSTATUS_DISPONIERT || rt010_fkfs_a > FSTATUS_DISPONIERT)) {
        // Fertigungsstatus muß kleiner als 4 sein
        call on_error(OK, "r0000213", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if (rt010_fu_bedr == cFUBEDR_MTAEND && (rt010_fkfs > FSTATUS_ANGEARBEITET || rt010_fkfs_a > FSTATUS_ANGEARBEITET)) {
        // Fertigungsstatus muß kleiner als 7 sein
        call on_error(OK, "r0000214", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if (rt010_fu_bedr == cFUBEDR_TAUSCH && (rt010_fkfs > FSTATUS_ANGEARBEITET || rt010_fkfs_a > FSTATUS_ANGEARBEITET)) {
        // Fertigungsstatus muß kleiner als 7 sein
        call on_error(OK, "r0000214", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if  rt010_fu_bedr == cFUBEDR_TAUSCH \
    && (rt010_fkfs > rt010_R_FS_TAUSCH(1, 1) || (rt010_R_FS_TAUSCH == "41" && rt010_aenddr > "0")) {
        // Fertigungsauftrag hat Status %s, kein STL-APL-Tausch möglich
        call on_error(OK, "r0000244", rt010_fkfs, rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if (rt010_fu_bedr == cFUBEDR_VORW && (rt010_fkfs > FSTATUS_ANGEARBEITET || rt010_fkfs_a > FSTATUS_ANGEARBEITET)) {
        // Fertigungsstatus muß kleiner als 7 sein
        call on_error(OK, "r0000214", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if (rt010_fu_bedr == cFUBEDR_RUECKW && (rt010_fkfs > FSTATUS_ANGEARBEITET || rt010_fkfs_a > FSTATUS_ANGEARBEITET)) {
        // Fertigungsstatus muß kleiner als 7 sein
        call on_error(OK, "r0000214", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    if (rt010_fu_bedr == cFUBEDR_STORNO && (rt010_fkfs > FSTATUS_FREIGEGEBEN || rt010_fkfs_a > FSTATUS_FREIGEGEBEN)) {
        // Fertigungsstatus muß kleiner als 5 sein
        call on_error(OK, "r0000250", "", rt010_prot)
        return RC_PRUEFEN_BEDR_NICHT
    }

    // Prüfen anhand eines logischen Locks, ob das fh010 läuft (Ticket 300339599).
    // Wenn ja, dann FA nicht verarbeiten und Aktionssatz stehen lassen.
    if (rt010_load_ft010() != OK) {
        return FAILURE
    }
    lock_keyL = ft010_get_lock_key(rt010_aufnr, rt010_aufpos, rt010_altern, cSTDART_AUFTRAG, $NULL)
    rcL = bu_testlock("f010", lock_keyL, FALSE, FI_NR1, $NULL)
    switch (rcL) {
        case OK:        // nicht gesperrt
            break
        case FAILURE:   // gesperrt
        case INFO:      // hat sich selbst gesperrt (kann eigentlich nicht sein)
            log LOG_DEBUG, LOGFILE, "fh010 läuft gerade zu fklz >" ## rt010_fklz ## "< /" \
                                 ## " aufnr >" ## rt010_aufnr ## "< /" \
                                 ## " aufpos >" ## rt010_aufpos ## "<"
            // Verarbeitung auftragsbezogene Stammdaten wurde gestartet
            call on_error(OK, "f0100107", "", rt010_prot)
            return RC_PRUEFEN_BEDR_ZURUECK
        else:           // Sonstige Fehler
            log LOG_DEBUG, LOGFILE, "Fehler bu_testlock rc=" ## rcL
            return FAILURE
    }


    if (rt010_fu_bedr == cFUBEDR_STORNO && rt010_fkfs > FSTATUS_ERFASST) {
        // Fremdarbeitsgänge mit (offenen) Bestellpositionen vorhanden?
        if (firmenkopplungRt010 == "0") {
            dyn_whereL   = " and e110.fi_nr = ::_3 "
            dyn_usingL ##= ", fi_nr"
        }
        else {
            dyn_whereL   = " and e110.fi_nr > 0 "
        }

        if (dm_is_cursor("sel_e110_rt010C") != TRUE) {
            dbms declare sel_e110_rt010C cursor for \
                select \
                    count(*) \
                from \
                    r200, \
                    e110 \
                where \
                    r200.fi_nr   = ::_1 and \
                    r200.fklz    = ::_2 and \
                    r200.agbs      :in_fremdL and \
                    e110.falz    = r200.falz and \
                    e110.identnr = r200.identnr_fremdb and \
                    e110.var     = r200.var_fremdb \
                    :dyn_whereL

            dbms with cursor sel_e110_rt010C alias \
                vorhandenL

            cursorRt010[++] = "sel_e110_rt010C"
        }

        dbms with cursor sel_e110_rt010C execute using :dyn_usingL

        if (vorhandenL > 0) {
            // Es existieren noch offen Fremdarbeitsgang-Bestellpositionen. Ein Löschen des Fertigungsauftrags ist nicht möglich!
            call on_error(OK, "r0000263", "", rt010_prot)
            return RC_PRUEFEN_BEDR_ZURUECK // 300323747: Aktionssatz muss stehen bleiben
        }
    }


    // Teilestamm lesen und prüfen. Wenn nicht vorhanden --> zurückstellen
    rcL = rt010_sel_g000()
    if (rcL < OK) {
        return FAILURE
    }
    else if (rcL == WARNING) {
        return RC_PRUEFEN_BEDR_NICHT
    }


    // Prüfungen nur bei Mengen-/Terminänderung, Einplanung, Tausch
    fu_bedr234_pruefenL = FALSE
    switch (rt010_fu_bedr) {
        case cFUBEDR_EINPLAN:
        case cFUBEDR_TAUSCH:
        case cFUBEDR_MTAEND:        // 300354288
            // Prüfungen auf Arbeitsplan und Stückliste,
            // aber nicht für Versorgungsaufträge und Primärauftrag ohne Stammdaten (ohne Zubuchung)
            if (cod_aart_versorg(rt010_aart)   != TRUE \
            &&  cod_aart_reparatur(rt010_aart) != TRUE) {
                fu_bedr234_pruefenL = TRUE
            }
            break
        else:
            break
    }

    if (fu_bedr234_pruefenL == TRUE) {
        // 1) Prüfen Teilestatus
        if (g_check_ts_mw(rt010_G_CHK_TS, rt010_identnr, rt010_var, rt010_ts_m, rt010_ts_w, rt010_ts, "fertig", rt010_prot, NULL, rt010_werk) < OK) {
            return RC_PRUEFEN_BEDR_ZURUECK
        }


        // 2) Prüfen Löschdatum
        if (rt010_datloe != NULL) {
            if @date(rt010_datloe) < @date(rt010_seterm) {
                // Löschdatum überschritten
                call on_error(INFO, "g0000203", "", rt010_prot)
            }
        }


        // 3) Lesen Kundenauftragsposition und Referenztabelle für auftragsbezogene Stammdaten
        if (F_AUFST > "1") {
            if (rt010_sel_v110() < OK) {
                return FAILURE
            }

            if (rt010_sel_f010() < OK) {
                return FAILURE
            }

            // Prüfung, ob überhaupt eingeplant werden muss
            // dies ist nicht der Fall, wenn Vertriebsfreigabe nicht erteilt
            // und sowohl für STL als auch für APL erforderlich
            if ((rt010_aart == AART_PRIMAER_KUNDE || rt010_aart == AART_PRIMAER) \
            &&   rt010_kn_freigabe_v110 == "0" \
            &&   rt010_aufst_kn_gen_stl == "1" \
            &&   rt010_aufst_kn_gen_apl == "1") {
                return RC_PRUEFEN_BEDR_NEXT
            }
        }
        else {
            rt010_aufst_stl = ""
            rt010_aufst_apl = ""
        }


        // 4) Arbeitsplan APLNR prüfen (siehe "rt210_aufloesung_verarb")
        rcL = rt010_pruefen_apl(apl_daten_geaendertL)
        switch (rcL) {
            case OK:
                // APL-Daten der r000 wurden geändert -> Update r000 anstossen
                if (apl_daten_geaendertL=>value == TRUE) {
                    update_r000L = TRUE
                }
                break
            case RC_PRUEFEN_BEDR_TEILWEISE:
                rcode_aplL    = rcL
                rt010_lo_teil = BEDR_AUFL_STATUS_KEIN_APL
                break
            case RC_PRUEFEN_BEDR_NICHT:
            case RC_PRUEFEN_BEDR_ZURUECK:
            case RC_PRUEFEN_BEDR_EINPL:
            case RC_PRUEFEN_BEDR_EINPL_OV:
            case RC_PRUEFEN_BEDR_EINPL_FHL:
                rcode_aplL = rcL
                break
            else:
                return FAILURE
        }


        // 5) Stückliste STLNR prüfen (siehe "rt110_aufloesung_verarb")
        rcL = rt010_pruefen_stl(stl_daten_geaendertL)
        switch (rcL) {
            case OK:
                // STL-Daten der r000 wurden geändert -> Update r000 anstossen
                if (stl_daten_geaendertL=>value == TRUE) {
                    update_r000L = TRUE
                }
                break
            case RC_PRUEFEN_BEDR_TEILWEISE:
                rcode_stlL    = rcL
                rt010_lo_teil = BEDR_AUFL_STATUS_KEIN_STL
                break
            case RC_PRUEFEN_BEDR_NICHT:
            case RC_PRUEFEN_BEDR_ZURUECK:
            case RC_PRUEFEN_BEDR_EINPL:
            case RC_PRUEFEN_BEDR_EINPL_OV:
            case RC_PRUEFEN_BEDR_EINPL_FHL:
                rcode_stlL = rcL
                break
            else:
                return FAILURE
        }


        // 6) Return-Code weiter prüfen
        if (rcode_aplL == RC_PRUEFEN_BEDR_ZURUECK \
        ||  rcode_stlL == RC_PRUEFEN_BEDR_ZURUECK) {
            // Stückliste oder Arbeitsplan nicht vorhanden
            return RC_PRUEFEN_BEDR_ZURUECK
        }
        if (rcode_stlL != rcode_aplL) {
            if (rcode_stlL > rcode_aplL) {
                rcodeL = RC_PRUEFEN_BEDR_KEINE_MAT // rcode_stlL
            }
            else {
                rcodeL = RC_PRUEFEN_BEDR_KEINE_AG // rcode_aplL
            }
        }
        else {
            if (rcode_stlL == RC_PRUEFEN_BEDR_OK) {
                rcodeL = rcode_stlL
            }
            else {
                rcodeL = RC_PRUEFEN_BEDR_KEINE_AG // rcode_aplL
            }
        }

        // 300354288:
        // Aktuell geänderte r000-Daten aus rt010-Feldern ins übergebene CDBI übernehmen,
        // wenn es keine Probleme mit der STL oder dem APL gab.
        if (rcode_aplL == RC_PRUEFEN_BEDR_OK \
        &&  rcode_stlL == RC_PRUEFEN_BEDR_OK) {
            switch (rt010_daten_2_r000cdbi(r000P, TRUE, FALSE)) {
                case OK:
                case INFO:
                    break
                else:
                    return FAILURE
            }
        }
    }


    // Restliche Prüfungen nur bei Einplanung, Tausch
    if (rt010_fu_bedr == cFUBEDR_EINPLAN \
    ||  rt010_fu_bedr == cFUBEDR_TAUSCH) {
        // 300322372:
        // Wenn Kennzeichen nicht gefüllt vorhanden, dann auf "0" setzen
        // 300327040:
        // Nur wenn APLNR gefüllt
        if (defined(r000P) == TRUE \
        &&  r000P=>fklz    == rt010_fklz \
        &&  r000P=>fi_nr   == FI_NR1) {
            r000L = r000P
        }
        else {
            // Auch wenn keine explizite CDBI-Instanz ans Modul übergeben wurde, kann man die in
            // "rt010_get_r000_pruefen" gelesenen Alt-Daten nehmen, damit das rq000 nicht nochmal lesen muss.
            r000L = bu_cdbi_new("r000")
            if (bu_cdt_clone(r000_altL, r000L, TRUE, TRUE, "") < OK) {
                log LOG_DEBUG, LOGFILE, "Fehler bu_cdt_clone"
                return FAILURE
            }

            // Geänderte Daten des Modul-LDBs in CDT übernehmen
            switch (rt010_daten_2_r000cdbi(r000L, TRUE, FALSE)) {
                case OK:
                case INFO:
                    break
                else:
                    return FAILURE
            }
        }


        // Prüfen Reihenfolge-Kennzeichen
        public rq000.bsl
        rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, "", standortkalenderP)
        call rq000_set_r000(rq000L, r000L, FALSE)
        call rq000_set_kn_reihenfolge(rq000L, rt010_kn_reihenfolge)
        call rq000_set_aplnr(rq000L, rt010_aplnr)
        call rq000_set_clear_message(rq000L, TRUE)

        rcL = rq000_val_kn_reihenfolge_fv(rq000L, cAES_UPDATE)
        if (rcL != OK) {
            call rq000_ausgeben_meldungen(rq000L, BU_0, TRUE)
            return FAILURE
        }

        rt010_kn_reihenfolge = rq000_get_kn_reihenfolge(rq000L)

        // Bei Änderung Übernahme Kennzeichen in übergebene CDBI-Instanz
        if (defined(r000P)        == TRUE \
        &&  r000P=>fklz           == rt010_fklz \
        &&  r000P=>fi_nr          == FI_NR1 \
        &&  r000P=>kn_reihenfolge != rt010_kn_reihenfolge) {
            r000P=>kn_reihenfolge = rt010_kn_reihenfolge
        }

        // Ggf. den Fertigungsauftrag updaten
        if (ausNeuerTerminierungP != TRUE \
        &&  rt010_kn_reihenfolge  != r000_altL=>kn_reihenfolge) {
            update_r000L = TRUE
        }
    }


    // Ggf. geänderte r000-Daten speichern
    if (update_r000L == TRUE) {
        if (rt010_update_r000_pruefen(r000P, r000_altL) < OK) {
            return FAILURE
        }
    }

    return rcodeL
}

/**
 * Interne Verarbeitung der FA-Stornierung aus Methode rt010_storno_fa
 *
 * @return RC_PRUEFEN_BEDR_OK           FA wurde auf storniert gesetzt
 * @return RC_PRUEFEN_BEDR_TEILWEISE    FA wurde auf erfasst gesetzt
 * @return RC_PRUEFEN_BEDR_EINPL        FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl="" gesetzt werden; mit sofortiger Verarbeitung
 * @return RC_PRUEFEN_BEDR_EINPL_OV     FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl="" gesetzt werden; ohne sofortiger Verarbeitung
 * @return RC_PRUEFEN_BEDR_EINPL_FHL    FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl=1 gesetzt werden
 * @return RC_PRUEFEN_BEDR_GELOESCHT    FA wurde gelöscht
 * @return WARNING                      Logischer Fehler
 * @return FAILURE                      Fehler
 **/
int proc rt010_storno_fa_verarb(cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int  rcL
    int  rcodeL

    // Prüfen fu_bedr
    if (rt010_fu_bedr != cFUBEDR_STORNO) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_fu_bedr >" ## rt010_fu_bedr ## "<"
        return FAILURE
    }

    // Auftragskopf lesen und sperren
    rcL = rt010_get_r000_abschl(r000P)
    if (rcL < OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_get_r000_abschl rc=" ## rcL
        return FAILURE
    }

    // Änderungdruck anstossen, wenn erforderlich
    rcL = rt010_aenderungsdruck()
    switch (rcL) {
        case OK:
            break
        case WARNING:
            log LOG_DEBUG, LOGFILE, "Fehler rt010_aenderungsdruck rc=" ## rcL
            return WARNING
        case FAILURE:
        else:
            log LOG_DEBUG, LOGFILE, "Fehler rt010_aenderungsdruck rc=" ## rcL
            return FAILURE
    }

    // Bestellrechnung anstossen
    rcL = rt010_bestellrechnung()
    if (rcL < OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_bestellrechnung rc=" ## rcL
        return FAILURE
    }

    // Strukturkostenverdichtung anstossen, wenn erforderlich
    rcL = rt010_verdichtung(r000P)
    if (rcL < OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_verdichtung rc=" ## rcL
        return FAILURE
    }

    // Terminbestätigung durchführen falls erforderlich
    if (rt010_termin_bestaetigen_noetig() == TRUE) {
        rcL = rt010_termin_bestaetigen(FALSE)
        if (rcL != OK) {
            log LOG_DEBUG, LOGFILE, "Fehler rt010_termin_bestaetigen rc=" ## rcL
            return FAILURE
        }
    }

    // Systemseitige Fixierungen aufheben.
    rcL = rt010_aufheben_fixierungen_system(standortkalenderP)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rt010_aufheben_fixierungen_system rc=" ## rcL
        return FAILURE
    }

    // Fertigungsauftrag selbst stornieren
    rcodeL = rt010_abschl_fa_storno(r000P)
    switch (rcodeL) {
        case RC_PRUEFEN_BEDR_OK:        // FA wurde auf storniert gesetzt
        case RC_PRUEFEN_BEDR_GELOESCHT: // FA wurde gelöscht
        case RC_PRUEFEN_BEDR_TEILWEISE: // FA wurde auf erfasst gesetzt
        case RC_PRUEFEN_BEDR_EINPL:     // FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl="" gesetzt werden; mit sofortiger Verarbeitung
        case RC_PRUEFEN_BEDR_EINPL_OV:  // FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl="" gesetzt werden; ohne sofortiger Verarbeitung
        case RC_PRUEFEN_BEDR_EINPL_FHL: // FA wurde auf erfasst gesetzt und es muss fu_bedr=3 und kz_fhl=1 gesetzt werden
            break
        else:
            log LOG_WARNING, LOGFILE, "Fehler rt010_abschl_fa_storno, rcodeL >" ## rcodeL ## "<"
            return FAILURE
    }

    log LOG_DEBUG, LOGFILE, "rcodeL >" ## rcodeL ## "<"
    return rcodeL
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_termin_bestaetigen(boolean abgesetztP)
{
    int rcL
    int iL

    if (abgesetztP != TRUE) {
        // Verwendung des letzten Sekundärauftrages lesen um an den/die Primär-
        // auftrag(e) zu kommen um diesen/diese Termin(e) zu bestätigen
        if (rt010_termstr                 == cTERMSTR_RUECKW \
         || (rt010_termstr                == cTERMSTR_MITTEL) \
         &&  cod_aart_primaer(rt010_aart) == FALSE) {

            rm054_handle_rt010 = bu_load_modul("rm054", rm054_handle_rt010)
            if (rm054_handle_rt010 < 0) {
                return FAILURE
            }

            call rm054_activate(rm054_handle_rt010)
            call rm054_init()

            fklzRm054E            = rt010_fklz
            flagSekundaerFaRm054E = FALSE

            rcL = rm054_verwendung_auftrag()
            call bu_msg_errmsg("rm054")
            if (rcL != OK) {
                call rm054_deactivate(rm054_handle_rt010)
            }
            else if (rcL == OK) {
                call rm010v_activate(rt010_handle_rm010v)

                for iL = 1 while iL <= leitzahlLstRm054->num_occurrences step 1 {
                    if (cod_aart_primaer(aartLstRm054[iL]) != TRUE) {
                        next
                    }

                    call rm010v_init()

                    fklzRm010vE          = leitzahlLstRm054[iL]
                    flagAbgesetztRm010vE = FALSE
                    aufnrRm010vEA        = aufnrLstRm054[iL] // rt010_aufnr
                    aufposRm010vEA       = aufposLstRm054[iL] // rt010_aufpos

                    log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Rueckwaerts Auftragsnummer >:(aufnrLstRm054[iL])<"
                    log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Rueckwaerts Auftragsposition >:(aufposLstRm054[iL])<"
                    log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Rueckwaerts Leitzahl >:(leitzahlLstRm054[iL])<"

//TODO: woher kommt rt010_konflikt???

                    if (rt010_konflikt == TRUE) {
                        rcL = rm010v_erstelle_todo()

                        call fertig_msg_errmsg("rm010v", NULL, "rt010_proto", rcL, NULL)

                        if (rcL != OK) {
                            call rm010v_deactivate(rt010_handle_rm010v)
                            call rm054_deactivate(rm054_handle_rt010)
                            return FAILURE
                        }
                    }
                    else {
                        rcL = rm010v_termin_bestaetigen()

                        call fertig_msg_errmsg("rm010v", NULL, "rt010_proto", rcL, NULL)

                        if (rcL != OK) {
                            call rm010v_deactivate(rt010_handle_rm010v)
                            call rm054_deactivate(rm054_handle_rt010)
                            return FAILURE
                        }
                    }
                }

                call rm010v_deactivate(rt010_handle_rm010v)
            }

            call rm054_deactivate(rm054_handle_rt010)
        }

        call rm010v_activate(rt010_handle_rm010v)
        call rm010v_init()

        fklzRm010vE          = rt010_fklz
        flagAbgesetztRm010vE = FALSE
        aufnrRm010vEA        = rt010_aufnr
        aufposRm010vEA       = rt010_aufpos

        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Nicht Rueckwaerts Auftragsnummer >:rt010_aufnr<"
        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Nicht Rueckwaerts Auftragsposition >:rt010_aufpos<"
        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Nicht Rueckwaerts Leitzahl >:rt010_fklz<"

        rcL = rm010v_termin_bestaetigen()

        call fertig_msg_errmsg("rm010v", NULL, "rt010_proto", rcL, NULL)

        if (rcL != OK) {
            call rm010v_deactivate(rt010_handle_rm010v)
            return FAILURE
        }

        call rm010v_deactivate(rt010_handle_rm010v)
    }
    else {
        call rm010v_activate(rt010_handle_rm010v)
        call rm010v_init()

        fklzRm010vE          = rt010_fklz
        flagAbgesetztRm010vE = abgesetztP
        aufnrRm010vEA        = rt010_aufnr
        aufposRm010vEA       = rt010_aufpos

        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Abgesetzt! Auftragsnummer >:rt010_aufnr<"
        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Abgesetzt! Auftragsposition >:rt010_aufpos<"
        log LOG_DEBUG, LOGFILE, "rt010_termin_bestaetigen: Abgesetzt! Leitzahl >:rt010_fklz<"

        rcL = rm010v_termin_bestaetigen()

        call fertig_msg_errmsg("rm010v", NULL, "rt010_proto", rcL, NULL)

        if (rcL != OK) {
            call rm010v_deactivate(rt010_handle_rm010v)
            return FAILURE
        }

        call rm010v_deactivate(rt010_handle_rm010v)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_pruefen_apl
#
# Prüfungen für Arbeitsplan-Auflösung
# - für die Arbeitsplannummer gilt:
#   aplnr = NULL --> noch nicht zugeordnet (undefiniert)
#   aplnr = 0    --> keine Arbeitsplanauflösung erforderlich
#   aplnr > 0    --> aufzulösende Arbeitsplannummer
# - geprüft wird das Vorhandensein eines gültigen Arbeitsplan-Kopfs
#   sowie dessen "aplstat", jedoch nur, wenn noch keine
#   "aplnr" zugeordnet wurde
# - Bestimmung, ob neutraler oder auftragsbezogener APL aufgelöst
#   werden muss.
#   Sind auftragsbezogene Arbeitspläne vorhanden, dann Zugriff mit
#   Auftragsnummer und -position abhängig davon, ob ein- oder mehrstufig,
#   ansonsten mit NULL, NULL
#   Es erfolgt eine Prüfung, ob die auftragsbezogenen Arbeitspläne bereits
#   freigegeben sind (aplstat in Tabelle "f010)
# - Wird ein gültiger Arbeitsplankopf gefunden, wird die "aplnr" und
#   weitere Arbeitsplankopfdaten in den Fertigungsauftrag übernommen
# - Ist keine Arbeitsplanauflösung erforderlich, wird die "aplnr" auf "0"
#   gesetzt
# - Für das Suchen eines passenden Arbeitsplan-Kopfs wird das Modul
#   "ft290" aufgerufen
# - Verweis-Arbeitspläne und Kopfalternativen werden immer protokolliert
#
# - Returns siehe rt010_pruefen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefen_apl(BooleanBU apl_daten_geaendertP)
{
    int     rcL
    string  verw_tsL
    string  verw_ts_wL
    string  verw_ts_mL
    boolean vorhandenL
    int     aplnr_altL
    int     aplnrL


    apl_daten_geaendertP=>value = FALSE


    // Nur, wenn noch keine Arbeitsplannummer zugeordnet.
    // Der >aplnr!=""< ist notwendig, weil BOA leider bei >aplnr==""< diesen gleich wie >aplnr==0< abhandelt
    // (und den >return OK< macht)!
    // siehe auch "rt210_aufloesung_verarb"
    if (rt010_aplnr == 0 \
    &&  rt010_aplnr != "") {
        return OK
    }


    if (rt010_aplnr > 0) {
        aplnr_altL = rt010_aplnr
        vorhandenL = rt010_check_apl()  // Prüfen, ob Arbeitsplan noch vorhanden
    }
    else {
        aplnr_altL = $NULL
        vorhandenL = FALSE
    }


    // 300354288:
    // Beim FU_BEDR=2 und einer ungültigen APLNR muss die APLNR=0 in r000 eingetragen werden.
    if (rt010_fu_bedr == cFUBEDR_MTAEND \
    &&  vorhandenL    == FALSE) {
        apl_daten_geaendertP=>value = TRUE  // immer Änderung der r000 anstossen
        call rt010_felder_ohne_apl()
        return OK
    }


    if (vorhandenL == FALSE) {
        // Muß Arbeitsplan lt. Parameter überhaupt aufgelöst werden?
        // Wenn nein, wird kein Arbeitsplankopf zugeordnet.
        if (R_KZ_APLSP  <= "0" \
        ||  rt010_kzapl == "1") {
            apl_daten_geaendertP=>value = TRUE
            call rt010_felder_ohne_apl()
            return OK
        }

        if (BATCH != TRUE) {
            // Arbeitsplan-Kopfauswahl wird durchgeführt
            call bu_msg("ral00125")
        }

        // Sind auftragsbezogene Arbeitspläne vorhanden, dann mit
        // und ansonsten ohne Auftragsnummer und -position
        rt010_aufnr_apl  = ""
        rt010_aufpos_apl = ""

        if (rt010_aufst_apl != "") {
            if (rt010_aufst_emstufig == "1") {
                // wenn mehrstufig, immer auftragsbezogen
                rt010_aufnr_apl  = rt010_aufnr
                rt010_aufpos_apl = rt010_aufpos
            }
            else {
                // wenn einstufig, nur bei oberster Baugruppe
                if rt010_identnr ## " " == rt010_aufst_identnr ## " " \
                && rt010_var     ## " " == rt010_aufst_var     ## " " {
                    rt010_aufnr_apl  = rt010_aufnr
                    rt010_aufpos_apl = rt010_aufpos
                }
            }
        }

        // Bei auftragsbezogenen Arbeitsplänen ist zunächst "aplstat" des Steuersatzes massgebend
        if (rt010_aufnr_apl != "") {
            if (rt010_aart == "1" \
            ||  rt010_aart == "2") {
                // Prüfung Freigabestatus und Kennzeichen für Generierung
                // es wird nicht eingeplant, wenn Vertriebsfreigabe nicht erteilt
                // und Einplanung nach Vertriebsfreigabe gewünscht
                if (rt010_kn_freigabe_v110 == "0" \
                &&  rt010_aufst_kn_gen_apl == "1") {
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }

                // Sind auftragsbezogene Arbeitspläne freigegeben
                if (rt010_aufst_aplstat < "8") {
                    // auftragsbezogener Arbeitsplan noch nicht freigegeben
                    call on_error(OK, "f0100213", "", rt010_prot)
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }

                // Wenn Mengen-/Terminänderung, dann muss noch Eingeplant werden
                if (rt010_fu_bedr == cFUBEDR_MTAEND) {
                    return RC_PRUEFEN_BEDR_EINPL_FHL
                }
            }

            // Es gilt immer identnr, weil Verweis-APL bereits bei Generierung (fh010) aufgelöst
            rt010_aplidentnr = rt010_identnr
            rt010_aplvar     = rt010_var

            // Auftragsbezug -> art "6"
            rt010_art = cSTDART_AUFTRAG
        }
        else {
            // Wenn keine aplidentnr geladen, gilt identnr
            if (rt010_aplidentnr == "") {
                rt010_aplidentnr = rt010_identnr
                rt010_aplvar     = rt010_var
            }

            // Kein Auftragsbezug -> art NULL
            rt010_art = cSTDART_NEUTRAL
        }

        // Arbeitsplankopf ermitteln
        call fm000_activate(fm000_handle_rt010)
        call fm000_init()
        identnrFm000E               = rt010_aplidentnr
        varFm000E                   = rt010_aplvar
        fi_nrFm000E                 = fi_nr
        werkFm000E                  = rt010_werk
        datvon_aplFm000E            = ESCFLG    // Übergabe von NULL würden alle APL selektieren, hier braucht man aber nur eine. Und zwar abhängig von F_DATVON den aktuellsten oder den von BU_DATE0.
        aufnrFm000E                 = rt010_aufnr_apl
        aufposFm000E                = rt010_aufpos_apl
        if (rt010_altern != "") {
            alternFm000E            = rt010_altern
            F_ALTERN_APLFm000E      = cALTERN_STANDARD // Übergebene Alternative selektieren
        }
        agalternFm000E              = ""
        stlapl_artFm000E            = rt010_art
        mengeFm000E                 = rt010_menge
        FlagFbFm000E                = TRUE
        FlagAplZuTeilesatzFm000E    = TRUE
        FlagKzAplErforderlichFm000E = TRUE      // 300274483

        rcL = fm000_getAplNr()
        aplnrL = aplnrFm000A
        call fm000_deactivate(fm000_handle_rt010)
        switch (rcL) {
            case OK:
                break
            case WARNING:
                if (R_KZ_APLSP == "1") {
                    call on_error(OK, "f2000201", "", rt010_prot)   // kein passender Arbeitsplankopf vorhanden
                    return RC_PRUEFEN_BEDR_ZURUECK
                }
                else if (R_KZ_APLSP == "2") {
                    apl_daten_geaendertP=>value = TRUE  // immer Änderung der r000 anstossen
                    call rt010_felder_ohne_apl()
                    call on_error(INFO, "f2000202", "", rt010_prot) // Einplanung ohne Arbeitsplan
                    return OK
                }
                else if (R_KZ_APLSP == "3") {
                    call on_error(INFO, "f2000203", "", rt010_prot) // Einplanung Arbeitsplan zurückgestell
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }
                break
            else:
            case FAILURE:
                return FAILURE
        }
        rt010_aplnr = aplnrL
    }


    if (rt010_aplnr != aplnr_altL) {
        apl_daten_geaendertP=>value = TRUE
    }


    if (rt010_aplnr <= 0) { \
        call rt010_felder_ohne_apl()
        return OK
    }
    else if (rt010_aplnr == aplnr_altL) {
        return OK
    }


    // Arbeitsplankopfdaten lesen
    //TODO: Performance: Felder aus fm000 übernehmen anstatt nochmal zu lesen?
    if (rt010_sel_f200() < OK) {
        return FAILURE
    }

    // Ist Arbeitsplan gesperrt
    if (rt010_aplstat_f200 == "3" \
    ||  rt010_aplstat_f200 == "6") {
        // Prüfungen Verweisarbeitsplan bei neutralen Arbeitsplänen
        if (rt010_aplidentnr_f200 ## " " != rt010_identnr ## " ") \
        || (rt010_aplvar_f200 ## " "     != rt010_var ## " " && rt010_aplvar_f200 != NULL) {
            // Verweisarbeitsplan gesperrt
            call on_error(OK, "f2000207", ":rt010_aplidentnr_f200^:rt010_aplvar_f200", rt010_prot)
        }
        else {
            // Arbeitsplan gesperrt
            call on_error(OK, "f2000205", "", rt010_prot)
        }
        return RC_PRUEFEN_BEDR_ZURUECK
    }

    // Protokollierung Verweisarbeitsplan
    if (rt010_aplidentnr_f200 ## " " != rt010_identnr ## " ") \
    || (rt010_aplvar_f200     ## " " != rt010_var     ## " " && rt010_aplvar_f200 != NULL) {
        // Prüfung auf Teilestatus zur Verweisstückliste
        if (dm_is_cursor("rt010_read_g000v") != TRUE) {
            dbms declare rt010_read_g000v cursor for \
                 select  g040.ts, \
                         g023.ts_w, \
                         g043.ts_m \
                   from  g040, g043, g023 \
                  where  g040.fi_nr = ::_1 and \
                     g040.identnr   = ::_2 and \
                     g040.var       = ::_3 and \
                     g043.fi_nr     = ::_4 and \
                     g043.identnr   = g040.identnr and \
                     g043.var       = g040.var and \
                     g023.fi_nr     = g043.fi_nr and \
                     g023.werk      = ::_5 and \
                     g023.identnr   = g043.identnr and \
                     g023.var       = g043.var
        }

        dbms with cursor rt010_read_g000v alias \
            verw_tsL, \
            verw_ts_wL, \
            verw_ts_mL

        dbms with cursor rt010_read_g000v execute using \
            FI_G000, \
            rt010_aplidentnr_f200, \
            rt010_aplvar_f200, \
            FI_NR1, \
            rt010_werk

        rcL = g_check_ts_mw(rt010_G_CHK_TS, rt010_aplidentnr_f200, rt010_aplvar_f200, verw_ts_mL, verw_ts_wL, verw_tsL, "fertig", rt010_prot, NULL, rt010_werk)
        if (rcL < OK) {
            // Einplanung Verweisarbeitsplan
            call on_error(INFO, "f2000206", ":rt010_aplidentnr_f200^:rt010_aplvar_f200", rt010_prot)
            return RC_PRUEFEN_BEDR_ZURUECK
        }
        else {
            // Einplanung Verweisarbeitsplan
            call on_error(INFO, "f2000206", ":rt010_aplidentnr_f200^:rt010_aplvar_f200", rt010_prot)
        }
    }

    // Protokollierung auftragsbezogener Arbeitsplan
    if (rt010_aufnr_apl != "") {
        // Einplanung auftragsbezogener Arbeitsplan
        call on_error(INFO, "f2000212", "", rt010_prot)
    }

    // Protokollierung Kopf-Alternative
    if (F_ALTERN > "0" && rt010_altern_f200 != "") {
        // Einplanung Arbeitsplan-Kopfalternative
        call on_error(INFO, "f2000208", ":rt010_altern_f200", rt010_prot)
    }

    // Protokollierung Losgröße
    if (rt010_menge_ab_f200 > 1.0) {
        // Einplanung Arbeitsplan ab Losgröße
        call on_error(INFO, "f2000209", ":rt010_menge_ab_f200", rt010_prot)
    }

    call rt010_felder_mit_apl()

    return OK
}

# Setzen Felder, wenn kein Arbeitsplan eingeplant werden soll
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_felder_ohne_apl()
{
    rt010_aplnr      = 0
    rt010_aplidentnr = ""
    rt010_aplvar     = ""
    rt010_datvon_apl = ""
    rt010_dataen_apl = ""
    rt010_aendnr_apl = ""

    return OK
}

# Setzen Felder, wenn ein Arbeitsplan eingeplant werden soll
# - Felder, die in der FA-Verwaltung verwaltbar sind, werden nur
#   geladen, wenn sie nicht bereits erfasst wurden
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_felder_mit_apl()
{
    rt010_aplidentnr     = rt010_aplidentnr_f200
    rt010_aplvar         = rt010_aplvar_f200
    rt010_datvon_apl     = rt010_datvon_f200
    rt010_dataen_apl     = rt010_dataen_f200
    rt010_aendnr_apl     = rt010_aendnr_f200

    // Priorisierung kostst/ arbplatz
    if (rt010_kostst == "" || rt010_kostst == 0) && \
       (rt010_arbplatz  == "") {
        // Ist erforderlich aufgrund eines Panther-Bug's
        // Würde das Umladen ohne vorherige Abfrage auf != NULL erfolgen, dann stünde
        // nach dem Umladen in rt010_kostst eine "0", obwohl rt010_kostst_f200 NULL ist.
        if (rt010_kostst_f200 != "") {
            rt010_kostst = rt010_kostst_f200
        }

        rt010_arbplatz  = rt010_arbplatz_f200
    }

    // Priorisierung ncprognr
    if (rt010_ncprognr == "") {
        rt010_ncprognr = rt010_ncprognr_f200
    }

    // Priorisierung fam
    if (rt010_fam == "") {
        rt010_fam = rt010_fam_f200
    }

    // Priorisierung kn_reihenfolge
    // 300327040: Wenn kein APL gefunden wurde, dann kann das Kennzeichen auch leer bleiben.
    if (rt010_kn_reihenfolge == "" \
    &&  rt010_aplnr          > 0) {
        // 300322372:
        // Wenn kein APL vorhanden, dann auf "0" setzen
        switch (rt010_kn_reihenfolge_f200) {
            case "0":
            case "1":
                rt010_kn_reihenfolge = rt010_kn_reihenfolge_f200
                break
            else:
                rt010_kn_reihenfolge = "0"
                break
        }
    }

    // Priorisierung milest_verf
    if (rt010_milest_verf == "") {
        rt010_milest_verf = rt010_milest_verf_f200
    }


    // Priorisierung txt aus APL
    switch (rt010_fu_bedr) {
        case cFUBEDR_EINPLAN:
            rt010_txt_apl = rt010_txt_f200
            break
        case cFUBEDR_TAUSCH:
            if (rt010_txt_apl == "") {
                rt010_txt_apl = rt010_txt_f200
            }
            break
        case cFUBEDR_MTAEND:
        else:
            break
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_pruefen_stl
#
# Prüfungen für Stücklisten-Auflösung
# - für die Stücklistennummer gilt:
#   stlnr = NULL --> noch nicht zugeordnet (undefiniert)
#   stlnr = 0    --> keine Stücklistenauflösung erforderlich
#   stlnr > 0    --> aufzulösende Stücklistennummer
# - geprüft wird das Vorhandensein eines gültigen Stücklisten-Kopfs
#   sowie dessen "stlstat", jedoch nur, wenn noch keine
#   "stlnr" zugeordnet wurde
# - Bestimmung, ob neutrale oder auftragsbezogene STL aufgelöst
#   werden muss.
#   Sind auftragsbezogene Stücklisten vorhanden, dann Zugriff mit
#   Auftragsnummer und -position abhängig davon, ob ein- oder mehrstufig,
#   ansonsten mit NULL, NULL
#   Es erfolgt eine Prüfung, ob die auftragsbezogenen Stücklisten bereits
#   freigegeben sind
# - Wird ein gültiger Stücklistenkopf gefunden, wird die "stlnr" und
#   weitere Stücklistenkopfdaten in den Fertigungsauftrag übernommen
# - Ist keine Stücklistenauflösung erforderlich, wird die "stlnr" auf "0"
#   gesetzt
# - Für das Suchen eines passenden Stücklisten-Kopfs wird das Modul
#   "ft190" aufgerufen
# - Verweis-Stücklisten und Kopfalternativen werden immer protokolliert
#
# - Returns siehe rt010_pruefen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefen_stl(BooleanBU stl_daten_geaendertP)
{
    int     rcL
    string  verw_tsL
    string  verw_ts_wL
    string  verw_ts_mL
    boolean vorhandenL
    int     stlnr_altL
    int     stlnrL


    stl_daten_geaendertP=>value = FALSE


    // Nur, wenn noch keine Stücklistennummer zugeordnet.
    // Der >stlnr!=""< ist notwendig, weil BOA leider bei >stlnr==""< diesen gleich wie >stlnr==0< abhandelt
    // (und den >return OK< macht)!
    // siehe auch "rt110_aufloesung_verarb"
    if (rt010_stlnr == 0 \
    &&  rt010_stlnr != "") {
        return OK
    }

    if (rt010_stlnr > 0) {
        stlnr_altL = rt010_stlnr
        vorhandenL = rt010_check_stl()  // prüfen, ob Stückliste noch vorhanden
    }
    else {
        stlnr_altL = $NULL
        vorhandenL = FALSE
    }


    // 300354288:
    // Beim FU_BEDR=2 und einer ungültigen STLNR muss die STLNR=0 in r000 eingetragen werden.
    if (rt010_fu_bedr == cFUBEDR_MTAEND \
    &&  vorhandenL    == FALSE) {
        stl_daten_geaendertP=>value = TRUE  // immer Änderung der r000 anstossen
        call rt010_felder_ohne_stl()
        return OK
    }


    if (vorhandenL == FALSE) {
        // Muß Stückliste lt. Parameter überhaupt aufgelöst werden?
        // Wenn nein, wird kein Stücklistenkopf zugeordnet
        if (R_KZ_STLSP  <= "0" \
        ||  rt010_kzstl == "1") {
            stl_daten_geaendertP=>value = TRUE
            call rt010_felder_ohne_stl()
            return OK
        }

        if (BATCH != TRUE) {
            // Stücklisten-Kopfauswahl wird durchgeführt
            call bu_msg("ral00126")
        }


        // Sind auftragsbezogene Stücklisten vorhanden, dann mit
        // und ansonsten ohne Auftragsnummer und -position
        rt010_aufnr_stl  = ""
        rt010_aufpos_stl = ""

        if (rt010_aufst_stl != "") {
            if (rt010_aufst_emstufig == "1") {
                // wenn mehrstufig, immer auftragsbezogen
                rt010_aufnr_stl  = rt010_aufnr
                rt010_aufpos_stl = rt010_aufpos
            }
            else {
                // wenn einstufig, nur bei oberster Baugruppe
                if rt010_identnr ## " " == rt010_aufst_identnr ## " " \
                && rt010_var ## " "     == rt010_aufst_var ## " " {
                    rt010_aufnr_stl  = rt010_aufnr
                    rt010_aufpos_stl = rt010_aufpos
                }
            }
        }

        // Bei auftragbezogenen Stücklisten ist zunächst "stlstat" des Steuersatzes massgebend
        if (rt010_aufnr_stl != "") {
            if (rt010_aart == "1" || rt010_aart == "2") {
                // Prüfung Freigabestatus und Kennzeichen für Generierung
                // es wird nicht eingeplant, wenn Vertriebsfreigabe nicht erteilt
                // und Einplanung nach Vertriebsfreigabe gewünscht
                if (rt010_kn_freigabe_v110 == "0" \
                &&  rt010_aufst_kn_gen_stl == "1") {
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }

                // Sind auftragsbezogene Stücklisten freigegeben
                if (rt010_aufst_stlstat < "8") {
                    if (rt010_fu_bedr != cFUBEDR_MTAEND) {
                        // auftragsbezogene Stückliste noch nicht freigegeben
                        call on_error(OK, "f0100113", "", rt010_prot)
                    }
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }

                // Wenn Mengen-/Terminänderung, dann muss noch eingeplant werden
                if (rt010_fu_bedr == cFUBEDR_MTAEND) {
                    return RC_PRUEFEN_BEDR_EINPL_FHL
                }
            }

            // Es gilt immer identnr
            rt010_stlidentnr = rt010_identnr
            rt010_stlvar     = rt010_var

            // Auftragsbezug -> art = "6"
            rt010_art = cSTDART_AUFTRAG
        }
        else {
            // Wenn keine stlidentnr geladen, gilt identnr
            if (rt010_stlidentnr == "") {
                rt010_stlidentnr = rt010_identnr
                rt010_stlvar     = rt010_var
            }

            // Kein Auftragsbezug -> art = NULL
            rt010_art = cSTDART_NEUTRAL
        }

        // Stücklistenkopf ermitteln
        call fm000_activate(fm000_handle_rt010)
        call fm000_init()
        identnrFm000E           = rt010_stlidentnr
        varFm000E               = rt010_stlvar
        fi_nrFm000E             = fi_nr
        werkFm000E              = rt010_werk
        datvon_stlFm000E        = ESCFLG    // Übergabe von NULL würden alle STL selektieren, hier braucht man aber nur eine. Und zwar abhängig von F_DATVON die aktuellste oder die von BU_DATE0.
        aufnrFm000E             = rt010_aufnr_stl
        aufposFm000E            = rt010_aufpos_stl
        if (rt010_altern != "") {
            alternFm000E        = rt010_altern
            F_ALTERN_STLFm000E  = cALTERN_STANDARD // Übergebene Alternative selektieren
        }
        stalternFm000E          = ""
        stlapl_artFm000E        = rt010_art
        FlagKzStlFm000E         = TRUE      // 300274483

        rcL = fm000_getStlNr()
        stlnrL = stlnrFm000A
        call fm000_deactivate(fm000_handle_rt010)
        switch (rcL) {
            case OK:
                break
            case WARNING:
                // siehe "rq0000i_aufbereiten_daten_terminierung"
                if (R_KZ_STLSP == "1") {
                    call on_error(OK, "f1000201", "", rt010_prot)   // kein passender Stücklistenkopf vorhanden
                    return RC_PRUEFEN_BEDR_ZURUECK
                }
                else if (R_KZ_STLSP == "2") {
                    stl_daten_geaendertP=>value = TRUE
                    call rt010_felder_ohne_stl()
                    call on_error(INFO, "f1000202", "", rt010_prot) // Einplanung ohne Stückliste
                    return OK
                }
                else if (R_KZ_STLSP == "3") {
                    call on_error(INFO, "f1000203", "", rt010_prot) // Einplanung Stückliste zurückgestellt
                    return RC_PRUEFEN_BEDR_TEILWEISE
                }
                break
            case INFO:  // Stücklistenkopf %s in aktueller Firma nicht gültig!
                // Message-Daten sind noch aus ft190 gefüllt
                call rt010_proto_kb(rcL, "", $NULL, $NULL)
                return RC_PRUEFEN_BEDR_NICHT
            else:
            case FAILURE:
                return FAILURE
        }
        rt010_stlnr = stlnrL
    }


    if (rt010_stlnr != stlnr_altL) {
        stl_daten_geaendertP=>value = TRUE
    }


    if (rt010_stlnr <= 0) { \
        call rt010_felder_ohne_stl()
        return OK
    }
    else if (rt010_stlnr == stlnr_altL) {
        return OK
    }


    // Stücklistenkopfdaten lesen
    //TODO: Performance: Felder aus fm000 übernehmen anstatt nochmal zu lesen?
    if (rt010_sel_f100() < OK) {
        return FAILURE
    }


    // Ist Stückliste gesperrt
    if (rt010_stlstat_f100 == "3" \
    ||  rt010_stlstat_f100 == "6") {
        // Prüfungen Verweisstückliste bei neutralen Stücklisten
        if (rt010_stlidentnr_f100 ## " " != rt010_identnr ## " ") \
        || (rt010_stlvar_f100 ## " "     != rt010_var ## " " && rt010_stlvar_f100 != "") {
            // Verweisstückliste gesperrt
            call on_error(OK, "f1000207", ":rt010_stlidentnr_f100^:rt010_stlvar_f100", rt010_prot)
        }
        else {
            // Stückliste gesperrt
            call on_error(OK, "f1000205", "", rt010_prot)
        }
        return RC_PRUEFEN_BEDR_ZURUECK
    }


    // Protokollierung Verweisstückliste
    if (rt010_stlidentnr_f100 ## " " != rt010_identnr ## " ") \
    || (rt010_stlvar_f100 ## " "     != rt010_var ## " " && rt010_stlvar_f100 != "") {
        // Prüfung auf Teilestatus zur Verweisstückliste
        if (dm_is_cursor("rt010_read_g000v") != TRUE) {
            dbms declare rt010_read_g000v cursor for \
                 select  g040.ts, \
                         g023.ts_w, \
                         g043.ts_m \
                   from  g040, g043, g023 \
                  where  g040.fi_nr = ::_1 and \
                     g040.identnr   = ::_2 and \
                     g040.var       = ::_3 and \
                     g043.fi_nr     = ::_4 and \
                     g043.identnr   = g040.identnr and \
                     g043.var       = g040.var and \
                     g023.fi_nr     = g043.fi_nr and \
                     g023.werk      = ::_5 and \
                     g023.identnr   = g043.identnr and \
                     g023.var       = g043.var
        }

        dbms with cursor rt010_read_g000v alias \
            verw_tsL, \
            verw_ts_wL, \
            verw_ts_mL

        dbms with cursor rt010_read_g000v execute using \
            FI_G000, \
            rt010_stlidentnr_f100, \
            rt010_stlvar_f100, \
            FI_NR1, \
            rt010_werk

        rcL = g_check_ts_mw(rt010_G_CHK_TS, rt010_stlidentnr_f100, rt010_stlvar_f100, verw_ts_mL, verw_ts_wL, verw_tsL, "fertig", rt010_prot, NULL, rt010_werk)
        if (rcL < OK) {
            // Einplanung Verweisstückliste
            call on_error(INFO, "f1000206", ":rt010_stlidentnr_f100^:rt010_stlvar_f100", rt010_prot)
            return RC_PRUEFEN_BEDR_ZURUECK
        }
        else {
            // Einplanung Verweisstückliste
            call on_error(INFO, "f1000206", ":rt010_stlidentnr_f100^:rt010_stlvar_f100", rt010_prot)
        }
    }

    // Protokollierung auftragsbezogene Stückliste
    if (rt010_aufnr_stl != "") {
        // Einplanung auftragsbezogene Stückliste
        call on_error(INFO, "f1000210", "", rt010_prot)
    }

    // Protokollierung Kopf-Alternative
    if (F_ALTERN > "0" && rt010_altern_f100 != "") {
        // Einplanung Stücklisten-Kopfalternative
        call on_error(INFO, "f1000208", ":rt010_altern_f100", rt010_prot)
    }

    call rt010_felder_mit_stl()

    return OK
}

# Setzen Felder, wenn keine Stückliste eingeplant werden soll
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_felder_ohne_stl()
{
    rt010_stlnr      = 0
    rt010_stlidentnr = ""
    rt010_stlvar     = ""
    rt010_datvon_stl = ""
    rt010_dataen_stl = ""
    rt010_aendnr_stl = ""

    return OK
}

# Setzen Felder, wenn eine Stückliste eingeplant werden soll
# - Felder, die in der FA-Verwaltung verwaltbar sind, werden nur
#   geladen, wenn sie nicht bereits erfasst wurden
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_felder_mit_stl()
{
    rt010_stlidentnr     = rt010_stlidentnr_f100
    rt010_stlvar         = rt010_stlvar_f100
    rt010_datvon_stl     = rt010_datvon_f100
    rt010_dataen_stl     = rt010_dataen_f100
    rt010_aendnr_stl     = rt010_aendnr_f100


    // Priorisierung txt aus STL
    switch (rt010_fu_bedr) {
        case cFUBEDR_EINPLAN:
            rt010_txt_stl = rt010_txt_f100
            break
        case cFUBEDR_TAUSCH:
            if (rt010_txt_stl == "") {
                rt010_txt_stl = rt010_txt_f100
            }
            break
        case cFUBEDR_MTAEND:
        else:
            break
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_absetzen
#
# Absetzen der verfügbaren Menge
# - abgesetzt wird nur, wenn Parameter > 0 und nicht bei Stornierung.
#   Außerdem nicht absetzen, wenn bm = "M" oder bei Chargen-Reinheit
# - lesen Summen der übergeordneten Bedarfe
# - Bestimmung der Überhangsmenge abhängig von rt010_kn_nettobedarf
#   . bei rt010_kn_nettobedarf = "1", disp. Lagerbestand bereinigt um Mindestbestand,
#     sowie um Summe bereits entnommene Mengen der Überg. Bedarfe und um
#     bereits gefertigte Menge. Davom werden die bereits abgesetzten, aber
#     nicht entnommenen Bedarfsmengen abgezogen.
#   . bei rt010_kn_nettobedarf = "2", Bestellüberhnag zum jew. Termin
#     bereinigt um Summe übergeordnete Bedarfe und eigenen FA
# - Bestimmung der absetzbaren Menge
#   . Maximal absetzbar ist die Summe der übergeordneten Bedarfsmengen ohne
#     die bereits früher abgesetzten, sowie der mit Vorausdispo abgeglichenen
#     Mengen
#   . diese Menge begrenzen auf verfügbare Menge
#   . die so ermittelte Menge muß anschließend auf die Bedarfssätze verteilt
#     werden. Bei Berücksichtigung Verfügbarkeit zum Termin auch auf
#     die Fertigungsaufträge.
# - Bestimmen der tatsächlich abzusetzenden Menge (menge_abgesetzt)
#   . generell darf nur maximal bis zur Auflagemenge abgesetzt werden
#   . außerdem darf die Auflagemenge nicht unter die bereits für andere
#     Bedarfe durch Absetzen reservierte Menge fallen (menge_abg).
# - Wenn nunmehr immer noch die Summe der übergeordneten Bedarfsmengen
#   abgesetzt werden kann, wird auf jeden Fall der komplette FA abgesetzt
#   und gelöscht
# - Berücksichtigung der Mindestlosgröße abhängig vom Losgrößenverfahren
#   . generell darf nur bis zur Mindestlosgröße abgesetzt werden
# - absetzen, sofern abzusetzende Menge > 0
#   . prüfen, ob der Status des FA noch eine Mengenänderung zulässt
#   . Bestellbestand um abgesetzte Menge vermindern
#   . Auflagemenge um abgesetzte Menge vermindern
#   . offene Menge neu berechnen
#   . durch das Absetzen liegt eine Mengenänderung vor (mkz = "1")
#   . wenn Menge komplett abgesetzt werden konnte, kann der Fertigungs-
#     auftrag storniert werden, dazu wird "fu_bedr" = "1" (Stornierung)
#     gesetzt.
#-----------------------------------------------------------------------------------------------------------------------
# Aufruf aus: rt010_nettobedarf
int proc rt010_absetzen()
{
    int rcL
    string  fkfsL
    boolean sim
    string  dyn_whereL
    string  dyn_usingL = "FI_NR1, rt010_fklz"
    string  in_fremdL = cod_agbs_in("fremd")
    int     vorhandenL

    // absetzbare Menge zunächst initialisieren
    rt010_menge_absetzbar  = 0

    // nur absetzen, wenn nicht Stornierung und Parameter gesetzt
    // nicht bei Losgrößenverfahren "M"
    if ((rt010_fu_bedr != cFUBEDR_EINPLAN && \
         rt010_fu_bedr != cFUBEDR_TAUSCH) || \
        rt010_kn_nettobedarf  <= "0" || \
        rt010_kn_nettobedarf  >  "2" || \
        dt510_bm              == "0" || \
        rt010_chargen_pflicht == "2") {
        return OK
    }

    // wenn g000.kn_variant == 1 und rt010_var = NULL darf nicht abgesetzt werden
    if ( \
        G_VAR == "1" && \
        rt010_kn_variant == "1" && \
        rt010_var == "" \
    ) {
        return OK
    }

    // Verfügbarkeits-/ Bestellüberhangsdaten lesen (Modul "dt510")
    if (rt010_fkfs == FSTATUS_SIM) {
        sim = TRUE
    }
    else {
        sim = FALSE
    }

    rcL = dt510_lesen_verf(NULL, sim)
    if (rcL < OK) {
        return FAILURE
    }

    // lesen Summen der übergeordneten Bedarfe
    if (rt010_sel_sum_uebg(rt010_fklz) < OK) {
        return FAILURE
    }

    // verfügbare Menge abhängig von rt010_kn_nettobedarf und Terminierungsart Struktur bestimmen
    // 300276694 - unabh. der Terminierungsart Struktur, da nicht nachvollziehbar ist, warum
    //             diese Restriktion impementiert wurde, umgekehrt nicht nachvollziebare Unterdeckungen
    //             bei R_NETTOBEDARF "2" und R_TERMSTR "1" auftreten!
    // if (rt010_kn_nettobedarf == "1" || rt010_termstr == cTERMSTR_VORW)
    if (rt010_kn_nettobedarf == "1") {

        // aktuell dispositiver Lagerbestand
        rt010_menge_ueh = dt510_dismenge - dt510_menge_abgelehnt + rt010_sum_res_uebg

        // wenn Parameter gesetzt, Lagerbestand bereinigen um Mindestbestand
        if (rt010_D_KZ_MINDVFG == "1") {
            rt010_menge_ueh = rt010_menge_ueh - dt510_minbest
        }

        // Lagerbestand bereinigen um Summe bereits entnommene Mengen der
        // überg. Bedarfe und um bereits gefertigte Menge
        rt010_menge_ueh = rt010_menge_ueh + rt010_sum_ent_uebg - rt010_menge_gef

        // berücksichtigen noch nicht entnommene, aber abgesetzte Mengen
        rt010_sum_menge = dt510_abg()

        rt010_menge_ueh = rt010_menge_ueh - rt010_sum_menge
    }
    else {

        // Überhang zum Termin bestimmen
        rt010_menge_ueh = dt510_ueh(rt010_seterm)

        // übergeordnete Bedarfe herausrechnen
        rt010_menge_ueh = rt010_menge_ueh + rt010_sum_bed_uebg - rt010_sum_ent_uebg

        // // eigenen FA herausrechnen
        // ==> dieser wird doch schon über dt510 im Überhang berücksichtigt, darf
        // aber nicht herausgerechnet werden, denn wenn er selber den Ueh verursacht,
        // wird der Ueh nicht aufgelöst!
        rt010_menge_ueh = rt010_menge_ueh - rt010_menge + rt010_menge_gef
    }

    // wenn keine Menge verfügbar, kann nicht abgesetzt werden
    if (rt010_menge_ueh <= 0) {
        return OK
    }

    // absetzbare Menge ermitteln. Dies ist die Summe der überg. Bedarfsmengen
    // ohne abgeglichene und bereits früher abgesetzte Mengen
    rt010_menge_absetzbar = rt010_sum_bed_uebg

    // auf verfügbare Menge begrenzen
    if (rt010_menge_ueh < rt010_menge_absetzbar) {
        rt010_menge_absetzbar = rt010_menge_ueh
    }

    // Bestimmung der vom Fertigungsauftrag abzusetzenden Menge
    rt010_menge_abgesetzt = rt010_menge_absetzbar

    // begrenzen auf Auflagemenge
    if (rt010_menge_abgesetzt > rt010_menge) {
        rt010_menge_abgesetzt = rt010_menge
    }

    // wenn nicht komplett abgesetzt werden kann
    if (rt010_menge_abgesetzt < rt010_sum_bed_uebg) {

        // abhängig vom Losgrößenverfahren die Mindestlosgröße ermitteln, bis zu
        // der frei abgesetzt werden kann
        rt010_mindestmenge = rt010_menge - rt010_menge_abgesetzt

        rt010_mindestmenge = dt510_mindestlos(rt010_mindestmenge)

        // Unterschreitet die Auflagemenge die Mindestmenge, darf nur bis zur
        // Mindestmenge abgesetzt werden
        if (rt010_menge - rt010_menge_abgesetzt <= rt010_mindestmenge) {
            rt010_menge_abgesetzt = rt010_menge - rt010_mindestmenge
        }
    }
    else {
        // ansonsten Fertigungsauftrag komplett absetzen
        rt010_menge_abgesetzt = rt010_menge
    }

    // nur, wenn abgesetzt werden kann
    if (rt010_menge_abgesetzt <= 0) {
        return OK
    }

    // Ist für den Auftrag noch eine Mengenänderung zugelassen
    fkfsL = fertig_get_fkfs(rt010_fkfs, rt010_fkfs_a)
    if (fkfsL  > rt010_R_FS_MAEND(1, 1)) \
    || (fkfsL == rt010_R_FS_MAEND(1, 1) && rt010_R_FS_MAEND == "41" && rt010_aenddr > "0") {
        call on_error(INFO, "r0000235", fkfsL, "rt010_proto")
        return OK
    }

    if (rt010_menge - rt010_menge_abgesetzt <= 0 && rt010_fkfs > FSTATUS_ERFASST) {
        // Fremdarbeitsgänge mit (offenen) Bestellpositionen vorhanden?
        if (firmenkopplungRt010 == "0") {
            dyn_whereL   = " and e110.fi_nr = ::_3 "
            dyn_usingL ##= ", fi_nr"
        }
        else {
            dyn_whereL   = " and e110.fi_nr > 0 "
        }

        if (dm_is_cursor("sel_e110_rt010C") != TRUE) {
            dbms declare sel_e110_rt010C cursor for \
                select \
                    count(*) \
                from \
                    r200, \
                    e110 \
                where \
                    r200.fi_nr   = ::_1 and \
                    r200.fklz    = ::_2 and \
                    r200.agbs      :in_fremdL and \
                    e110.falz    = r200.falz and \
                    e110.identnr = r200.identnr_fremdb and \
                    e110.var     = r200.var_fremdb \
                    :dyn_whereL

            dbms with cursor sel_e110_rt010C alias \
                vorhandenL

            cursorRt010[++] = "sel_e110_rt010C"
        }

        dbms with cursor sel_e110_rt010C execute using :dyn_usingL

        if (vorhandenL > 0) {
            // Es existieren noch offen Fremdarbeitsgang-Bestellpositionen. Ein Löschen des Fertigungsauftrags ist nicht möglich!
            call on_error(INFO, "r0000263", "", "rt010_proto")
            return OK
        }
    }

    // Bestellbestand um abgesetzte Menge vermindern
    if (rt010_update_g020() < OK) {
        return FAILURE
    }

    // Auflagemenge um abzusetzende Menge vermindern
    rt010_menge = rt010_menge - rt010_menge_abgesetzt

    // offene Menge neu berechnen und begrenzen
    rt010_menge_offen = rt010_menge - rt010_menge_gef
    if (rt010_menge_offen < 0) {
        rt010_menge_offen = 0
    }

    // durch das Absetzen liegt eine Mengenänderung vor
    // wenn komplett abgesetzt, außerdem Stornierung durchführen
    rt010_mkz = MKZ_JA
    log LOG_DEBUG, LOGFILE, "mkz >" ## rt010_mkz ## "< auf >1< gesetzt / fklz >" ## rt010_fklz ## "< (beim Absetzen)"

    if (rt010_menge == 0) {
        rt010_fu_bedr = cFUBEDR_STORNO
        rt010_dlzeit  = 0

        // Terminbestätigung durchführen falls erforderlich
        if (rt010_aart == "1") {
            if (rt010_termin_bestaetigen(TRUE) != OK) {
                return FAILURE
            }
        }
    }

    // Meldungen ausgeben

    if (rt010_menge == 0) {
        // Auflagemenge %1 %2 komplett abgesetzt, Fertigungsauftrag %3 storniert
        call on_error(OK, "r0000216", ":rt010_menge_abgesetzt^:dt510_me^", "rt010_proto")
    }
    else {
        // Menge %1 %2 von Fertigungsauftrag %3 abgesetzt
        call on_error(OK, "r0000217", ":rt010_menge_abgesetzt^:dt510_me^", "rt010_proto")
    }

    // Vorausdispo prüfen
    if (rt010_R_VDISPO == "1" && rt010_pruefe_vdispo() == WARNING) {
        // Vorausdisposition überprüfen!
        call on_error(OK, "r0000194", "", "rt010_proto")

        call bu_ereignis_ausloesen("VDABS")
    }

    // Abstellen Aktionssatz für Nettobedarfsrechnung
    if (rt010_insert_r115() != OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefe_vdispo()
{
//    log LOG_INFO, LOGFILE, "fklz: >" ## rt100_ufklz ## "<"
//    log LOG_INFO, LOGFILE, "STACKTRACE: \n" ## md_get_stacktrace()

    if (dm_is_cursor("GetVDispoRt010") == FALSE) {
        dbms declare GetVDispoRt010 cursor for \
            select count(*) \
              from r000 \
             where r000.aart    = :+NULL and \
               r000.aufnr   = ::aufnr and \
               (r000.aufpos = ::aufpos or \
                 r000.aufpos = 9999)

        dbms with cursor GetVDispoRt010 alias jamint
    }

    dbms with cursor GetVDispoRt010 execute using rt010_aufnr, rt010_aufpos

    if (jamint > 0) {
        return WARNING
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_verteilen
#
# Verteilen der absetzbaren Menge auf Fertigungsaufträge mit über-
# schüssigen Mengen
#NETTOBEDARF - nur, wenn absetzbare Menge vorhanden und rt010_kn_nettobedarf = "2"/"3"
# - nur, wenn absetzbare Menge vorhanden und rt010_kn_nettobedarf = "2"
# - die zu verteilende Menge ist die absetzbare Menge
#   bei Vorwärtsterminierung muß zuerst der verfügbare Lagerbestand
#   herangezogen werden
# - Bei echten Aufträgen darf nur auf echte Aufträge verteilt werden
#   sonst auch auf simulative Aufträge
# - Die Verteilung erfolgt analog der Terminierungsart Struktur
# - Cursor über alle Fertigungsaufträge zur Teilenummer bis zum Endtermin
#   ohne eigenen Fertigungsauftrag
#   . Fertigungsauftrag lesen und sperren
#   . lesen Summen der übergeordneten Bedarfssätze zu diesem Fertigungs-
#     auftrag
#   . berechnen der auf diesen Fertigungsauftrag verteilbaren Menge
#     Menge - abgesetzte Menge - Summe überg. Bedarf ohne abgesetzte und
#     abgeglichene Menge
#   . verteilbare Menge begrenzen auf zu verteilende Menge
#   . abgesetzte Menge im FA erhöhen um verteilbare Menge
#   . zu verteilende Menge vermindern um verteilbare Menge
#   . Fertigungsauftrag Updaten
#   . wenn alles verteilt, fertig
#-----------------------------------------------------------------------------------------------------------------------
# Aufruf aus: rt010_nettobedarf
int proc rt010_verteilen()
{
    string orderL
    string where_simL
    string where_lagerL

    // nur, wenn absetzbare Menge vorhanden und rt010_kn_nettobedarf = "2"
    if ( \
        rt010_menge_absetzbar == 0.0 || \
        rt010_kn_nettobedarf != "2" \
    ) {
        return OK
    }

    // zu verteilende Menge bestimmen
    rt010_menge_zuverteilen = rt010_menge_absetzbar

    // bei Vorwärtsterminierung zuerst verfügbaren Lagerbestand heranziehen
    if (rt010_termstr != cTERMSTR_RUECKW) {
        rt010_menge_zuverteilen -= dt510_lamenge
        // ist dann Verteilen überhaupt noch notwendig
        if (rt010_menge_zuverteilen <= 0.0) {
            return OK
        }
    }

    // bei echten Aufträgen nur alle echten Daten
    if (rt010_fkfs > FSTATUS_SIM) {
        where_simL = " and r000.fkfs > '" ## FSTATUS_SIM ## "' "
    }
    else {
        where_simL = ""
    }

    // Sortierung bestimmen für Select abhängig von Terminierungsart
    if (rt010_termstr == cTERMSTR_RUECKW) {
        orderL = "desc"
    }
    else {
        orderL = ""
    }

    // Bei Lagerbezug nur in aktuellem Lager verteilen, da nur für dieses abgesetzt wurde
    if (rt010_D_LAGER_BEZUG == "1") {
        where_lagerL = " and r000.lgnr = \:+rt010_lgnr "
    }
    else {
        where_lagerL = ""
    }

    // Cursor über alle Fertigungsaufträge bis zum Endtermin ohne eigenen FA
    dbms declare rt010_netto_fa cursor for \
        select \
            r000.fklz, \
            r000.seterm \
        from \
            r000 \
        where \
            r000.fi_nr   =  :+FI_NR1 and \
            r000.identnr =  :+rt010_identnr and \
            r000.var     =  :+rt010_var and \
            r000.werk    =  :+rt010_werk and \
            r000.seterm  <= :+rt010_seterm and \
            r000.fklz    <> :+rt010_fklz \
            :where_simL \
            :*where_lagerL \
        order by \
            r000.seterm :orderL
    dbms with cursor rt010_netto_fa alias \
        rt010_fklz_abs, \
        rt010_seterm_abs
    dbms with cursor rt010_netto_fa execute

    while (SQL_CODE == SQL_OK) {
        // Zuerst versuchen, den Fertigungsauftrag logisch zu sperren.
        if (rt010_tx_lock(rt010_fklz_abs) != OK) {
            dbms close cursor rt010_netto_fa
            return FAILURE
        }

        // lesen und sperren des FA
        if (rt010_get_r000_abs() < OK) {
            dbms close cursor rt010_netto_fa
            return FAILURE
        }

        // lesen Summen der übergeordneten Bedarfssätze zu diesem FA
        if (rt010_sel_sum_uebg(rt010_fklz_abs) < OK) {
            dbms close cursor rt010_netto_fa
            return FAILURE
        }

        // berechnen der auf diesen FA verteilbaren Menge
        rt010_menge_verteilbar = rt010_menge_abs - rt010_menge_abg_abs - rt010_sum_bed_uebg
        if (rt010_menge_verteilbar > rt010_menge_zuverteilen) {
            rt010_menge_verteilbar = rt010_menge_zuverteilen
        }

        // wenn etwas auf diesen FA verteilbar
        if (rt010_menge_verteilbar > 0.0) {
            // abgesetzte Menge erhöhen
            rt010_menge_abg_abs += rt010_menge_verteilbar

            // zu verteilende Menge reduzieren
            rt010_menge_zuverteilen -= rt010_menge_verteilbar

            // jetzt FA updaten
            if (rt010_update_r000_abs() < OK) {
                dbms close cursor rt010_netto_fa
                return FAILURE
            }
        }

        // Gibt es noch etwas zu verteilen?
        if (rt010_menge_zuverteilen > 0.0) {
            dbms with cursor rt010_netto_fa continue
        }
        else {
            SQL_CODE = SQLNOTFOUND
        }
    }

    if (SQL_CODE != SQLNOTFOUND) {
        dbms close cursor rt010_netto_fa
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r000", "rt010_proto")
    }

    dbms close cursor rt010_netto_fa

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Verteilen der abgesetzten Menge und zuordnen korrekte Auftrags-
# nummer/ Position und Endtermin
# - lesen aller übergeordneten Materialien zum Fertigungsauftrag
# - die zu verteilende Menge (=abgesetzte Menge) wird in terminlicher
#   Reihenfolge auf die überg. Materialien verteilt, jedoch nur bis
#   zur jew. verteilbaren Menge. Dies ist die Sollmenge abzügl. der
#   Summe aus abgeglichener Menge und bereits früher abgesetzter Menge
#   ("menge_abg_agl").
# - wenn der Fertigungsauftrag nicht bereits fixiert ist oder eine Bau-
#   kastenterminierung durchgeführt werden soll, wird der Endtermin
#   des Fertigungsauftrags auf den Bedarfstermin des ersten, nicht
#   komplett abgesetzten Materials gesetzt, sofern dieser noch eine
#   Terminänderung zuläßt. Außerdem werden die Wunschtermine und die
#   Auftragsnummer und -position aus diesem Material in den Auftragskopf
#   übernommen.
# - ist das jew. überg. Material bereits entnommen (fmfs > "4"), dann
#   muß wegen der abgesetzten Menge zuerst die alte Nachkalkulation
#   storniert und nach dem Update des überg. Materials die Nachkalkulation
#   neu durchgeführt werden.
# - bei stornierten Aufträgen (fu_bedr = "1") wird außerdem die im
#   überg. Material hinterlegte Leitzahl des aktuellen FA (ufklz) gelöscht.
#   Außerdem müssen dann alle überg. Materialien neu vorkalkuliert
#   werden und für die überg. Fertigungsaufträge die Strukturkosten-
#   verdichtung angestoßen werden.
# - setzen des Freigabekennzeichens in der Kundenauftragsposition
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_uebg_bedarf(cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int      rcL
    cdtGq300 gq300L
    int      pezeitL
    int      fktL
    date     setermL
    boolean  verteilL                 = FALSE  // "verteil" initialisieren, wird gesetzt beim ersten Bedarf, der nicht komplett abgesetzt werden konnte
    boolean  verschobenL              = FALSE
    boolean  baukastenueberlappungL   = FALSE
    boolean  is_0Uhr_vortagL          = FALSE
    boolean  terminaenderung_erlaubtL = TRUE
    boolean  ufklz_austragenL         = FALSE


    // Wenn nicht abgesetzt wurde, müssen auch keine FA-Termine an übergeordnete Materialien angepasst werden.
    if ( \
        rt010_menge_absetzbar == 0.0 || \
        rt010_menge_abgesetzt <= 0.0 \
    ) {
        return OK
    }


    // die zu verteilende Menge ist die absetzbare Menge
    rt010_menge_zuverteilen = rt010_menge_absetzbar

    // Cursor über alle übergeordneten Materialien zum Fertigungsauftrag
    if (dm_is_cursor("rt010_netto_mat") != TRUE) {
        dbms declare rt010_netto_mat cursor for \
            select \
                r100.fmlz, \
                r100.sbterm, \
                r100.fklz \
            from \
                r100 \
            where \
                r100.fi_nr   = ::_1 and \
                r100.ufklz   = ::_2 and \
                r100.identnr = ::_3 and \
                r100.var     = ::_4 \
            order by \
                r100.sbterm, \
                r100.fmlz
        dbms with cursor rt010_netto_mat alias \
            rt010_fmlz_uebg, \
            rt010_sbterm_uebg, \
            rt010_fklz_uebg
    }

    dbms with cursor rt010_netto_mat execute using \
        FI_NR1, \
        rt010_fklz, \
        rt010_identnr, \
        rt010_var

    while (SQL_CODE == SQL_OK) {
        log LOG_DEBUG, LOGFILE, "rt010_fklz >" ## rt010_fklz ## "< / " \
                             ## "rt010_identnr >" ## rt010_identnr ## "< / rt010_var >" ## rt010_var ## "<"

        // Zuerst versuchen, den übergeordneten Fertigungsauftrag logisch zu sperren.
        if (rt010_tx_lock(rt010_fklz_uebg) != OK) {
            dbms close cursor rt010_netto_mat
            return FAILURE
        }

        // lesen übergeordnetes Material
        if (rt010_get_r100_uebg() < OK) {
            return FAILURE
        }
        log LOG_DEBUG, LOGFILE, "rt010_fmlz_uebg >" ## rt010_fmlz_uebg ## "<"

        // Summe abgeglichene Menge und bereits früher abgesetzte Menge
        rt010_menge_abg_agl = rt010_menge_abg_uebg + rt010_menge_agl_uebg

        // verteilbare Menge in abgesetzter Menge des überg. Bedarfs speichern
        if (rt010_menge_zuverteilen > 0) {
            // verteilbare Menge ermitteln
            rt010_menge_verteilbar = rt010_menge_uebg - rt010_menge_abg_agl

            // begrenzen
            if (rt010_menge_zuverteilen < rt010_menge_verteilbar) {
                rt010_menge_verteilbar = rt010_menge_zuverteilen
            }

            // abgesetzte Menge erhöhen
            rt010_menge_abg_uebg += rt010_menge_verteilbar

            // Summe abgeglichene erhöhen
            rt010_menge_abg_agl += rt010_menge_verteilbar

            // zu verteilende Menge reduzieren
            rt010_menge_zuverteilen -= rt010_menge_verteilbar
        }
        log LOG_DEBUG, LOGFILE, "rt010_menge_zuverteilen >" ## rt010_menge_zuverteilen ## "< / " \
                             ## "rt010_menge_uebg >" ## rt010_menge_uebg ## "< / " \
                             ## "rt010_menge_abg_agl >" ## rt010_menge_abg_agl ## "< / " \
                             ## "verteilL >" ## verteilL ## "<"

        // beim ersten nicht komplett abgesetzten Bedarf
        if ( \
            rt010_menge_uebg >  rt010_menge_abg_agl && \
            verteilL         == FALSE \
        ) {
            // das ist der erste
            verteilL = TRUE

            // Bedarfstermin dem Fertigungsauftrag zuordnen, sofern dieser nicht fixiert ist
            if (cod_kz_fix_nein(rt010_kz_fix) == TRUE) {
                // Ist für den Auftrag noch eine Terminänderung zugelassen?
                // (300247960)
                terminaenderung_erlaubtL = rt010_terminaenderung_erlaubt_uebg(standortkalenderP, r000P)


                // Termin des Primärbedarfes berücksichtigen, wenn Änderung
                // noch erlaubt und nicht in der Rückwärtsterminierung
                if (rt010_fu_bedr            != cFUBEDR_RUECKW && \
                    terminaenderung_erlaubtL == FALSE) {
                    // Keine Terminänderung beim Absetzen von >%2<, da Status bereits >%1< (siehe auch Parameter  R_FS_TAEND).
                    call on_error(INFO, \
                                  "r0000236", fertig_get_fkfs(rt010_fkfs, rt010_fkfs_a) ## "^" ## rt010_fmlz_uebg, \
                                  rt010_prot)
                }
                else {
                    if (@date(rt010_seterm) > @date(rt010_sbterm_uebg)) {
                        verschobenL = TRUE
                    }

                    // 300241386:
                    // Hier wird die Uhrzeit des Endtermins auf das Arbeitsende gesetzt.
                    // Dies darf nur gemacht werden, wenn der Endtermin (ohne Uhrzeit) des FA ungleich des
                    // Bedarfstermins des übergeordneten Materials ist:
                    // Grund: Eine (minutengenaue) Baukastenüberlappung würde sonst nicht funktionieren!
                    // (siehe auch "rq100i5_ermitteln_termin_untg_sek_zu_material")

                    public gq300.bsl
                    if (defined(standortkalenderP) == TRUE) {
                        gq300L = standortkalenderP
                    }
                    else {
                        gq300L = gq300_new(boa_cdt_get(name_cdtTermGlobal_rt010), $NULL, $NULL, $NULL)
                    }

                    // 300356075:
                    // Arbeitsende des vorheriten Arbeitstages ermitteln, wenn keine Baukastenüberlappung und
                    // der Vortag nicht um "24 Uhr" (d.h. "0 Uhr") endet. In den genannten Ausnahmefällen beleibt der
                    // SETERM.
                    baukastenueberlappungL = rt010_is_baukastenueberlappung(gq300L, r000P)
                    is_0Uhr_vortagL        = rt010_is_0uhr_vortag(gq300L)
                    if (baukastenueberlappungL == FALSE \
                    &&  is_0Uhr_vortagL        == FALSE) {
                        // Eigentlich nur dann Termine ändern, wenn g020.bm ungleich "6", "8", "9"

                        // a) Endtermin dem Fertigungsauftrag zuordnen
                        rt010_seterm = rt010_sbterm_uebg

                        call gq300_set_datuhr(gq300L, rt010_seterm)
                        call gq300_set_clear_message(gq300L, TRUE)
                        rcL = gq300_ermitteln_arbeitsende_prev(gq300L)
                        call gq300_ausgeben_meldungen(gq300L, BU_0, (rcL != OK), TRUE)
                        if (rcL != OK) {
                            return FAILURE
                        }
                        rt010_seterm_uhr = gq300_get_datuhr_neu(gq300L)


                        // b) Strurktur-Endtermin dem Fertigungsauftrag zuordnen
                        rt010_seterm_w = rt010_seterm_w_uebg

                        call gq300_set_datuhr(gq300L, rt010_seterm_w)
                        rcL = gq300_ermitteln_arbeitsende_prev(gq300L)
                        call gq300_ausgeben_meldungen(gq300L, BU_0, (rcL != OK), TRUE)
                        if (rcL != OK) {
                            return FAILURE
                        }
                        rt010_seterm_w_uhr = gq300_get_datuhr_neu(gq300L)
                    }

                    // ebenso die Auftragsnummer/ -position ändern
                    rt010_aufnr   = rt010_aufnr_uebg
                    rt010_aufpos  = rt010_aufpos_uebg
                }
            }
        }

        // wenn das überg. Material bereits entnommen wurde, muß jetzt zuerst die Nachkalkulation storniert werden
        if ( \
            rt010_fmfs_uebg   > FSTATUS_FREIGEGEBEN || \
            rt010_fmfs_a_uebg > FSTATUS_FREIGEGEBEN \
        ) {
            if (rt010_nachkalk_uebg("1") < OK) {
                return FAILURE
            }
        }

        // Wenn Auftrag komplett abgesetzt bzw. storniert, Leitzahl löschen
        ufklz_austragenL = FALSE
        if ( \
            rt010_fu_bedr == cFUBEDR_STORNO && \
            rt010_menge   == 0.0 \
        ) {
            ufklz_austragenL = TRUE

            if ( \
                rt010_fmfs_uebg                           == 0    && \
                cod_pos_herk_auftrag(rt010_pos_herk_uebg) == TRUE \
            ) {
                rt010_fmfs_uebg = rt010_fmfs_a_uebg
                rt010_fmfs_a_uebg = NULL
            }
        }
        else if (rt010_fu_bedr    == cFUBEDR_EINPLAN \
             &&  rt010_menge_uebg == rt010_menge_abg_uebg) {
            // 300422286:
            // Auch bei der ersten Einplanung muss die ufklz ausgetragen werden, wenn die abgeglichene Menge der
            // gesamten MAT-Menge enstspricht
            ufklz_austragenL = TRUE
        }

        if (ufklz_austragenL == TRUE) {
            rt010_ufklz_uebg  = ""
        }
        log LOG_DEBUG, LOGFILE, "rt010_fmlz_uebg >" ## rt010_fmlz_uebg ## "< / " \
                             ## "rt010_fu_bedr >" ## rt010_fu_bedr ## "< / " \
                             ## "rt010_menge >" ## rt010_menge ## "< / " \
                             ## "rt010_menge_uebg >" ## rt010_menge_uebg ## "< / " \
                             ## "rt010_menge_abg_uebg >" ## rt010_menge_abg_uebg ## "< / " \
                             ## "rt010_ufklz_uebg >" ## rt010_ufklz_uebg ## "< / " \
                             ## "ufklz_austragen >" ## ufklz_austragenL ## "<"


        // jetzt überg. Material updaten
        if (rt010_update_r100_uebg() < OK) {
            return FAILURE
        }

        // Abgesetzte Menge in Kalkulation abhandeln
        if (rt010_vorkalk_uebg_abg() < OK) {
            return FAILURE
        }

        // bei Stornierung überg. Materialien neu vorkalkulieren und
        // Strukturkostenverdichtung anstoßen für überg. Fertigungsauftrag
        if (rt010_fu_bedr == cFUBEDR_STORNO) {
            // Lesen übergeordneter Fertigungsauftrag;
            // Wenn nicht (mehr) vorhanden, dann Folgefunktionen überspringen.
            rcL = rt010_sel_r000_uebg()
            if (rcL < OK) {
                return FAILURE
            }
            else if (rcL == OK) {
                rcL = rt010_vorkalk_uebg()
                if (rcL < OK) {
                    return FAILURE
                }

                rcL = rt010_verdichtung_uebg(r000P)
                if (rcL < OK) {
                    return FAILURE
                }
            }
        }

        // wenn das überg. Material bereits entnommen wurde, muß jetzt die Nachkalkulation neu durchgeführt werden.
        if ( \
            rt010_fmfs_uebg   > FSTATUS_FREIGEGEBEN || \
            rt010_fmfs_a_uebg > FSTATUS_FREIGEGEBEN \
        ) {
            if (rt010_nachkalk_uebg("0") < OK) {
                return FAILURE
            }
        }

        // Bei Kundenaufträgen Aktualisierung des Freigabestatus in der Kundenauftragsposition
        if (rt010_status_uebg() < OK) {
            return FAILURE
        }

        dbms with cursor rt010_netto_mat continue
    }

    if (SQL_CODE != SQLNOTFOUND) {
        // Fehler beim Lesen in Tabelle %s
        return on_error(FAILURE, "APPL0006", "r100", rt010_prot)
    }

    if ( \
        verschobenL         == TRUE && \
        rt010_fa_verschoben == "1" \
    ) {
        // Prüfen, ob fa_verschoben auf "0" gesetzt werden kann. Hier müssen alle übergeordneten / zugeordneten
        // Bedarfsdecker berücksichtigt werden.
        if (dm_is_cursor("rt010CurSbterm") != TRUE) {
            dbms declare rt010CurSbterm cursor for \
                select \
                    r100.sbterm \
                from \
                    r100 \
                where \
                    r100.fi_nr = ::_1 and \
                    r100.ufklz = ::_2 \
                union \
                select \
                    r100.sbterm \
                from \
                    r100 \
                join \
                    r1004 on ( \
                        r1004.fi_nr = r100.fi_nr and \
                        r1004.fmlz  = r100.fmlz \
                    ) \
                where \
                    r1004.fi_nr = ::_3 and \
                    r1004.fklz  = ::_4 \
                order by \
                    1
            dbms with cursor rt010CurSbterm alias rt010_sbterm_uebg
        }

        dbms with cursor rt010CurSbterm execute using \
            FI_NR1, \
            rt010_fklz, \
            FI_NR1, \
            rt010_fklz

        // 300218266
        setermL = rt010_seterm
        if (rt010_da == DA_BEDARF) {
            dbms alias pezeitL
            dbms sql \
                select \
                    g020.pezeit \
                from \
                    g020 \
                where \
                    g020.fi_nr   = :+FI_NR1        and \
                    g020.werk    = :+rt010_werk    and \
                    g020.identnr = :+rt010_identnr and \
                    g020.var     = :+rt010_var     and \
                    g020.lgnr    = :+rt010_lgnr
            dbms alias

            if (pezeitL <= 0) {
                pezeitL = bu_getenv("D_PEZEIT") + 0
            }
            if (pezeitL > 0) {
                call gm300_activate(handleGm300Rt010)
                call gm300_init()
                opcodeGm300E = "get"
                datumGm300E  = rt010_seterm
                if (gm300_fkt() == OK) {
                    fktL = fktGm300A + pezeitL
                    call gm300_init()
                    opcodeGm300E = "get"
                    fktGm300E    = fktL
                    if (gm300_datum() == OK) {
                        setermL = datumGm300A
                    }
                }
                call gm300_deactivate(handleGm300Rt010)
            }
        }
        if (@date(setermL) <= @date(rt010_sbterm_uebg)) {
            rt010_fa_verschoben = "0"
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_verdichtung_uebg
#
# Anstoß Strukturkostenverdichtung für überg. Fertigungsauftrag
# - Aufruf Modul "kt465"
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_verdichtung_uebg(R000CDBI r000P)
{
    int      rcL
    vars     rt010_handleL
    vars     kt465_handleL
    vars     warn_2_failL
    R000CDBI r000L = $NULL


    if (defined(r000P) == TRUE \
    &&  r000P=>fklz    == rt010_fklz_uebg \
    &&  r000P=>fi_nr   == FI_NR1) {
        r000L = r000P
    }

    rt010_kt465_handle = bu_load_tmodul("kt465", rt010_kt465_handle)
    if (rt010_kt465_handle <= 0) {
        return FAILURE
    }


    // Bundle senden
    send bundle "b_kt465" data \
        FU_VERD_VORKALK, \
        rt010_fklz_uebg, \
        rt010_aufnr_uebg, \
        rt010_aufpos_uebg

    rt010_handleL = rt010_rt010_handle
    kt465_handleL = rt010_kt465_handle
    call sm_ldb_h_state_set(rt010_handleL, LDB_ACTIVE, FALSE)
    warn_2_failL    = warn_2_fail
    warn_2_fail     = FALSE
    rcL = kt465_abstellen_aktionssatz(kt465_handleL, r000L)
    warn_2_fail = warn_2_failL
    call sm_ldb_h_state_set(rt010_handleL, LDB_ACTIVE, TRUE)

    if (rcL < OK) {
        // Fehler bei Anstoß Strukturkostenverdichtung
        call on_error(OK, "r0000502", "", rt010_prot)
        return FAILURE
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_vorkalk_uebg
#
# Vorkalkulation für übergeordnetes Material aufrufen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_vorkalk_uebg()
{
    int  rcL
    vars rt010_handle
    vars kt410_handle
    vars warn_2_failL

    rt010_kt410_handle = bu_load_tmodul("kt410", rt010_kt410_handle)
    if (rt010_kt410_handle < 0) {
        return FAILURE
    }

    send    bundle   "b_kt410_mat" data \
              rt010_fklz_uebg, \
              rt010_fmlz_uebg, \
              rt010_identnr, \
              rt010_var, \
              rt010_menge_uebg

    warn_2_failL    = warn_2_fail
    warn_2_fail     = FALSE

    rt010_handle = rt010_rt010_handle
    kt410_handle = rt010_kt410_handle

    call sm_ldb_h_state_set(rt010_handle, LDB_ACTIVE, FALSE)

    rcL = kt410_aendern_kosten_mat(kt410_handle)

    call sm_ldb_h_state_set(rt010_handle, LDB_ACTIVE, TRUE)

    if (rcL < OK) {
        // Fehler bei Vorkalkulation übergeordneter Bedarf
        call on_error(OK, "r1000503", "", rt010_prot)
        warn_2_fail = warn_2_failL
        return FAILURE
    }
    else if (rcL != OK) {
        // Hinweis(e) bei Vorkalkulation übergeordneter Bedarf
        call on_error(OK, "r1000513", "", rt010_prot)
    }

    warn_2_fail = warn_2_failL

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_nachkalk_uebg
#
# Nachkalkulation für übergeordnetes Material aufrufen
# - der Parameter Storno besagt, ob Storno oder Neukalkulation
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_nachkalk_uebg(storno)
{
    int  rcL
    vars ende
    vars rt010_handle
    vars kt431_handle
    vars warn_2_failL

    // bei bereits fertiggemeldetem Material --> Endemeldung
    if (rt010_fmfs_uebg > "6" || rt010_fmfs_a_uebg > "6") {
        ende = 1
    }
    else {
        ende = 0
    }

    rt010_kt431_handle = bu_load_tmodul("kt431", rt010_kt431_handle)
    if (rt010_kt431_handle < 0) {
        return on_error(FAILURE)
    }

    // komplette Menge stornieren bzw. neu kalkulieren
    if (storno == "1") {
        send bundle "b_kt431_mat" data "1", \
                           ende, \
                           rt010_fklz_uebg, \
                           rt010_fmlz_uebg, \
                           rt010_menge_ent_uebg, \
                           rt010_menge_ent_uebg, \
                           "0", \
                           rt010_lgnr
    }
    else {
        send bundle "b_kt431_mat" data "0", \
                           ende, \
                           rt010_fklz_uebg, \
                           rt010_fmlz_uebg, \
                           "0", \
                           rt010_menge_ent_uebg, \
                           "0", \
                           rt010_lgnr
    }

    warn_2_failL    = warn_2_fail
    warn_2_fail     = FALSE

    rt010_handle = rt010_rt010_handle
    kt431_handle = rt010_kt431_handle

    call sm_ldb_h_state_set(rt010_handle, LDB_ACTIVE, FALSE)

    rcL = kt431_nachkalk_mat(kt431_handle)

    call sm_ldb_h_state_set(rt010_handle, LDB_ACTIVE, TRUE)

    if (rcL < OK) {
        // Fehler bei Nachkalkulation überg. Bedarf
        call on_error(OK, "r1000504", "", rt010_prot)
        warn_2_fail = warn_2_failL
        return FAILURE
    }
    else if (rcL != OK) {
        // Hinweis(e) bei Nachkalkulation überg. Bedarf
        call on_error(OK, "r1000514", "", rt010_prot)
    }

    warn_2_fail = warn_2_failL

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_ausschuss
#
# Ermitteln der Ausschußmenge, sofern abgesetzt wurde oder die
# Berechnung noch nicht durchgeführt wurde, dabei bei bestimmmten
# Maßeinheiten aufrunden.
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_ausschuss()
{
    if (rt010_menge_aus       == NULL \
    ||  rt010_menge_aus       == 0.0 \
    ||  rt010_menge_absetzbar >  0.0) {
        rt010_menge_aus = rt010_menge * (dt510_aussch / 100)

        // aufrunden, wenn Maßeinheit so definiert
        rt010_menge_aus = chk_ganzzahlig(dt510_me, rt010_menge_aus)

        // wenn sich Ausschußmenge ändert, liegt eine Mengenänderung vor
        if (rt010_menge_aus > 0.0) {
            rt010_mkz = MKZ_JA
            log LOG_DEBUG, LOGFILE, "mkz >" ## rt010_mkz ## "< auf >1< gesetzt / fklz >" ## rt010_fklz ## "< (beim Ausschuss)"
            // Berücksichtigung %s %s geplanter Ausschuß
            call on_error(INFO, "r0000124", ":rt010_menge_aus^:dt510_me", rt010_prot)
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_serienverwaltung()
{
    double benoetigtL


    // Keine Mengenänderung?
    if (rt010_mkz != MKZ_JA) {
        return OK
    }

    if (rt010_fkfs < FSTATUS_FREIGEGEBEN) {
        // Bei noch nicht freigegebenen FAs kann die Zuordnung zu bereits generierten Seriennummern aufgehoben werden.
        benoetigtL = 0.0
    }
    else {
        // Ansonsten muss die noch offene Menge berücksichtigt werden.
        benoetigtL = rt010_menge_offen
    }

    // Abgleich durchführen
    if ( \
        fertig_abgleich_seriennummern( \
            rt010_identnr, \
            rt010_var, \
            rt010_lgnr, \
            rt010_aufnr, \
            rt010_aufpos, \
            rt010_fklz, \
            @to_int(benoetigtL) \
        ) != OK \
    ) {
        return FAILURE
    }

    return OK
}

/**
 * Anstoß Änderungsdruck
 *
 * - bestimmen druckrelevante Änderungsfunktion
 *   . bei Stornierung (fu_bedr = "1") --> 1 (Stornierung)
 *   . bei Mengenänderung (mkz = "1")  --> 2 (Mengenänderung)
 *   . ansonsten                       --> 4 (Terminänderung)
 *
 * @return OK
 * @return WARNING  logische Fehler (z.B. Unverarbeiteter Aktionssatz in r065 vorhanden)
 * @return FAILURE  Fehler
 **/
int proc rt010_aenderungsdruck()
{
    int rcL

    rt010_rt065_handle = bu_load_tmodul("rt065", rt010_rt065_handle, TRUE)

    // bestimmen "fu_aenddr"
    // siehe "rq000_val_pruefen_fu_aenddr"
    if (rt010_fu_bedr == cFUBEDR_STORNO) {
        rt010_fu_aenddr = "1"
    }
    else if (rt010_mkz == MKZ_JA) {
        rt010_fu_aenddr = "2"
    }
    else {
        rt010_fu_aenddr = "4"
    }

    send bundle "b_rt065" data  rt010_fklz, \
                                rt010_fu_aenddr, \
                                rt010_aenddr, \
                                rt010_aufnr, \
                                rt010_aufpos, \
                                rt010_freigabe, \
                                rt010_werk

    rcL = rt065_aenderungsdruck(rt010_rt065_handle, TRUE, FALSE, cFERTIG_AUFTRAG)
    log LOG_DEBUG, LOGFILE, "rt065_aenderungsdruck rc=" ## rcL
    switch (rcL) {
        case OK:
            break
        case WARNING:   // 300370313/300370591: Ist im konkreten Fall ein r065-Satz mit jobid > 0 vorhanden.
            return WARNING
        case FAILURE:
        else:
            return FAILURE
    }

    // Das von rt065 geänderte Kennzeichen "nachsenden" lassen, damit wir es abholen können
    call rt065_daten_neu(rt010_rt065_handle)
    if (sm_is_bundle("b_rt065_s") == TRUE) {
        receive bundle "b_rt065_s" data rt010_aenddr
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_sofortfreigabe
#
# Anstoß Auftragsfreigabe, wenn geplanter Auftrag, Sofortfreigabe
# und kein Storno und kein Versorgungsauftrag
# - schreiben Aktionssatz Freigabe in Tabelle r025
# - wenn bereits vorhanden --> updaten
# - wenn noch Auftragsfreigabe gestartet werden muß, return WARNING
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sofortfreigabe()
{
    int rcL

    // nur bei geplantem Auftrag mit Sofortfreigabe und kein Storno
    // und kein Versorgungsauftrag
    // vgl. "rq0000i5_sofortfreigabe"
    if ((rt010_fkfs    != FSTATUS_TERMINIERT && rt010_fkfs_a != FSTATUS_TERMINIERT) \
    ||  rt010_freigabe == "2" \
    ||  rt010_freigabe >  "3" \
    ||  rt010_fu_bedr  == cFUBEDR_STORNO) {
        return OK
    }

    // Darf r025/r725 überhaupt geschrieben werden?

    // Bedarfsrechnung teilweise zurückgestellt (-> "rq0000i5_sofortfreigabe")
    if (rt010_lo_teil != BEDR_AUFL_STATUS_BEIDES) {
        // Der r115-Satz wird nicht gelöscht (rt010_lo_teil != BEDR_AUFL_STATUS_BEIDES, wenn Returncode von
        // "rt010_pruefen" = RC_PRUEFEN_BEDR_TEILWEISE ist) => kein r025-Satz abstellen.

        if (rt010_fkfs > FSTATUS_SIM) {
            // Fertigungsauftrag kann nicht freigegeben werden, da noch eine Bedarfsrechnung anliegt!
            call on_error(OK, "r0000183", NULL, rt010_prot)
        }

        return OK
    }

    if (rt010_kneintl == cKNEINTL_VORSCHAU || rt010_kneintl == cKNEINTL_RESTMENGE) {
        // Solange der Fertigungsauftrag auf Vorschau (kneintl = "2") steht
        // => kein r025-Satz abstellen.

        // Fertigungsauftrag kann nicht freigegeben werden,Einteilungskennzeichen Vorschau (KnEinteilung = 2)!
        call on_error(OK, "r0000189", NULL, rt010_prot)

        return OK
    }

    if (cod_aart_versorg(rt010_aart) != TRUE) {
        // Wenn kein Versorgungsauftrag
        // Freigabesatz abstellen, wenn bereits vorhanden --> update
        rcL = rt010_insert_r025()
        if (rcL < OK) {
            return FAILURE
        }
        else if (rcL == WARNING) {
            if (rt010_update_r025() < OK) {
                return FAILURE
            }
        }
    }
    else {
        // Wenn Versorgungsauftrag
        // Freigabesatz Versorgung abstellen, wenn bereits vorhanden --> update
        rcL = rt010_insert_r725()
        if (rcL < OK) {
            return FAILURE
        }
        else if (rcL == WARNING) {
            if (rt010_update_r725() < OK) {
                return FAILURE
            }
        }
    }

    return WARNING
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_bestellrechnung
#
# Anstoß Bestellrechnung
# - nicht bei simulativem Auftrag
# - Einfügen Aktionssatz in Tabelle "d205"
# - wenn bereits vorhanden, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_bestellrechnung()
{
    string kz_herkL

    // bei simulativen Auftrag kz_herk = "S" setzten
    if (rt010_fkfs == FSTATUS_SIM) {
        kz_herkL = "S"
    }
    else {
        kz_herkL = "R"
    }

    // Aktionssatz schreiben
    if (dispo_aktion_d205(FI_NR1, rt010_werk, rt010_identnr, rt010_var, rt010_lgnr, kz_herkL) != OK) {
        return on_error(FAILURE)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_verdichtung
#
# Anstoß Strukturkostenverdichtung, wenn A-Teil/ EF und Mengen-
# änderung und nicht Stornierung und Auftragsart mit überg. Bedarf
# ("K", "V", "S")
# - Aufruf Modul "kt465"
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_verdichtung(R000CDBI r000P)
{
    int  rcL
    vars rt010_handleL
    vars kt465_handleL
    vars warn_2_failL

    // nur, wenn A-Teil/ EF und Mengenänderung und nicht Stornierung
    // und Auftragsart mit überg. Bedarf
    if !(rt010_da == DA_AUFTRAG \
    &&   cod_bs_eigen(rt010_bs) == TRUE \
    &&   rt010_mkz == MKZ_JA \
    &&   rt010_fu_bedr != cFUBEDR_STORNO \
    &&   (cod_aart_bedarf(rt010_aart) || cod_aart_versorg(rt010_aart))) {
        return OK
    }

    send bundle "b_kt465" data \
        FU_VERD_VORKALK, \
        rt010_fklz, \
        rt010_aufnr, \
        rt010_aufpos

    warn_2_failL    = warn_2_fail
    warn_2_fail     = FALSE

    rt010_kt465_handle = bu_load_tmodul("kt465", rt010_kt465_handle)
    if (rt010_kt465_handle <= 0) {
        return FAILURE
    }

    rt010_handleL = rt010_rt010_handle
    kt465_handleL = rt010_kt465_handle

    call sm_ldb_h_state_set(rt010_handleL, LDB_ACTIVE, FALSE)

    rcL = kt465_abstellen_aktionssatz(kt465_handleL, r000P)

    call sm_ldb_h_state_set(rt010_handleL, LDB_ACTIVE, TRUE)

    if (rcL < OK) {
        // Fehler bei Anstoß Strukturkostenverdichtung
        call on_error(OK, "r0000502", "", rt010_prot)
        warn_2_fail = warn_2_failL
        return FAILURE
    }
    else if (rcL != OK) {
        // Hinweis(e) bei Anstoß Strukturkostenverdichtung
        call on_error(OK, "r0000512", "", rt010_prot)
    }

    warn_2_fail = warn_2_failL

    return OK
}

/**
 * Storniert den Fertigungsauftrag selbst und stößt Folgeaktionen an
 *
 * @param   r000P                       Fertigungsauftrag-CDBI
 * @return  RC_PRUEFEN_BEDR_OK          Ein Änderungsdruck steht noch an, ein Löschen des FA ist daher (noch) nicht möglich.
 *                                      Der Fertigungsauftrag wurde deshalb auf storniert (fkfs = 9) gesetzt.
 *                                      Er kann nach dem Druck per rh090 gelöscht werden.
 * @return  RC_PRUEFEN_BEDR_TEILWEISE   Es handelt sich um einen nicht simulativen Kunden- oder Vorausdispoauftrag (Aart 1, 6)
 *                                      oder um einen simulativen Primär-FA (außer Planaufträgen).
 *                                      Dieser darf nicht im Rahmen einer Bedarfsrechnung gelöscht werden.
 *                                      Der Fertigungsauftrag wurde deshalb auf erfasst (fkfs = 1) gesetzt
 * @return  RC_PRUEFEN_BEDR_EINPL       Der Fertigungsauftrag wurde auf erfasst (fkfs = 1) gesetzt und es muss ein Aktionssatz mit FU_BEDR = 3 und KZ_FHL = "" erzeugt werden; mit sofortiger Verarbeitung
 * @return  RC_PRUEFEN_BEDR_EINPL_OV    Der Fertigungsauftrag wurde auf erfasst (fkfs = 1) gesetzt und es muss ein Aktionssatz mit FU_BEDR = 3 und KZ_FHL = "" erzeugt werden; ohne sofortiger Verarbeitung
 * @return  RC_PRUEFEN_BEDR_EINPL_FHL   Der Fertigungsauftrag wurde auf erfasst (fkfs = 1) gesetzt und es muss ein Aktionssatz mit FU_BEDR = 3 und KZ_FHL = "1" erzeugt werden
 * @return  RC_PRUEFEN_BEDR_GELOESCHT   Der Fertigungsauftrag wurde gelöscht
 * @return  FAILURE                     Fehler
 **/
int proc rt010_abschl_fa_storno(R000CDBI r000P)
{
    int     rcL
    int     rcodeL
    boolean nicht_loeschbarer_primaer_faL = FALSE
    boolean loeschen_faL                  = FALSE
    boolean loeschen_stammdatenL          = FALSE
    boolean R_FA_STORNO                   = (bu_getenv("R_FA_STORNO") == "1")


    log LOG_DEBUG, LOGFILE, "FA mit rt010_fklz >" ## rt010_fklz ## "< / " \
                         ## "rt010_aart >" ## rt010_aart ## "< / " \
                         ## "rt010_menge >" ## rt010_menge ## "< / " \
                         ## "rt010_aenddr >" ## rt010_aenddr ## "< "


    if (rt010_menge > 0.0) {
        if (rt010_fkfs == FSTATUS_SIM) {
            nicht_loeschbarer_primaer_faL = (cod_aart_primaer(rt010_aart)     == TRUE \
                                          && cod_aart_planauftrag(rt010_aart) != TRUE)
        }
        else {
            nicht_loeschbarer_primaer_faL = (cod_aart_vertriebsfa(rt010_aart) == TRUE \
                                          || cod_aart_vdispo(rt010_aart)      == TRUE)
        }
    }

    if (nicht_loeschbarer_primaer_faL == TRUE) {
        log LOG_DEBUG, LOGFILE, "FA auf erfasst setzen, da nicht löschbarer Primär-FA"
        call rt010_einstellen_daten_zum_erfasst_setzen()
        // 300418556:
        // Beim Storno und R_FA_STORNO = 0 und AART = "1" muss der Aktionssatz später auf fu_bedr=3 gesetzt werden
        // TODO: Er kommt bei R_FA_STORNO = 1 gar nicht hier hin...
        if (rt010_fu_bedr                    == cFUBEDR_STORNO \
        &&  R_FA_STORNO                      == FALSE \
        &&  cod_aart_vertriebsfa(rt010_aart) == TRUE) {
            // TODO: man könnte hier ggf. auch gleich den korrekten Update auf r115 machen und nicht den Code ans rh110
            // durchreichen...
            rcodeL = RC_PRUEFEN_BEDR_EINPL_OV
        }
        else {
            rcodeL = RC_PRUEFEN_BEDR_TEILWEISE
        }
        loeschen_faL         = FALSE
        loeschen_stammdatenL = cod_aart_vertriebsfa(rt010_aart)
    }
    else if (rt010_aenddr == "1") {
        log LOG_DEBUG, LOGFILE, "FA auf storniert setzen, da Änderungsdruck ausstehend"
        call rt010_einstellen_daten_zum_storniert_setzen()
        rcodeL               = RC_PRUEFEN_BEDR_OK
        loeschen_faL         = FALSE
        loeschen_stammdatenL = TRUE
    }
    else {
        log LOG_DEBUG, LOGFILE, "FA löschen"
        rcodeL               = RC_PRUEFEN_BEDR_GELOESCHT
        loeschen_faL         = TRUE
        loeschen_stammdatenL = TRUE
    }

    if (loeschen_faL == TRUE) {
        send bundle "b_rt090" data rt010_fklz, \
                                   FU_LOE_FA_LOESCHEN, \
                                   rt010_werk

        rcL = rt090_loeschen(rt010_rt090_handle)
        if (rcL != OK) {
            log LOG_WARNING, LOGFILE, "Fehler beim Löschen FA, rc=" ## rcL
            // Fertigungsauftrag %s wurde nicht gelöscht!
            return on_error(FAILURE, "r0000026", rt010_fklz ## " (-> rp096)", rt010_prot, FALSE, FALSE, PRT_CTRL_FEHLER)
        }

        rcL = rt010_set_cm130(cAES_DELETE)
        if (rcL != OK) {
            log LOG_WARNING, LOGFILE, "Fehler beim Löschen KTR-Daten zu FA, rc=" ## rcL
            return on_error(FAILURE)
        }
    }
    else {
        if (rt010_update_r000_abschl(rcodeL, r000P) != OK) {
            log LOG_WARNING, LOGFILE, "Fehler beim Ändern FA"
            return on_error(FAILURE)
        }
    }

    if (loeschen_stammdatenL == TRUE) {
        if (rt010_loeschen_auftragsbez_stammdaten_ohne_verwendung() != OK) {
            log LOG_WARNING, LOGFILE, "Fehler beim Löschen auftragsbez. Stammdaten"
            return on_error(FAILURE)
        }
    }

    return rcodeL
}

/**
 * Stellt im Rahmen der FA-Stornierung Daten ein für das Setzen auf Status "erfasst"
 *
 * @return OK
 **/
int proc rt010_einstellen_daten_zum_erfasst_setzen()
{
    // bei simulativem Auftrag --> Status alt setzen
    if (rt010_fkfs == FSTATUS_SIM) {
        rt010_fkfs_a = FSTATUS_ERFASST
    }
    else {
        rt010_fkfs = FSTATUS_ERFASST
    }

    rt010_kostst         = ""
    rt010_arbplatz       = ""
    rt010_ncprognr       = ""
    rt010_fam            = ""
    rt010_kn_reihenfolge = ""
    rt010_milest_verf    = ""
    rt010_stlidentnr     = ""
    rt010_stlvar         = ""
    rt010_stlnr          = ""
    rt010_staltern       = 0
    rt010_datvon_stl     = ""
    rt010_aendnr_stl     = ""
    rt010_dataen_stl     = ""
    rt010_txt_stl        = ""
    rt010_aplidentnr     = ""
    rt010_aplvar         = ""
    rt010_aplnr          = ""
    rt010_agaltern       = 0
    rt010_datvon_apl     = ""
    rt010_aendnr_apl     = ""
    rt010_dataen_apl     = ""
    rt010_txt_apl        = ""

    return OK
}

/**
 * Stellt im Rahmen der FA-Stornierung Daten ein für das Setzen auf Status "erfasst"
 *
 * @return OK
 **/
int proc rt010_einstellen_daten_zum_storniert_setzen()
{
    // bei simulativem Auftrag --> Status alt setzen
    if (rt010_fkfs == FSTATUS_SIM) {
        rt010_fkfs_a = FSTATUS_STORNIERT
    }
    else {
        rt010_fkfs = FSTATUS_STORNIERT
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_status_uebg
#
# Freigabestatus in Kundenauftragsposition setzen
# - nur bei Kundenaufträgen
# - nur bei Primärbedarfen
# - bei Einplanung  --> "4"
# - bei Stornierung --> "3"
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_status_uebg()
{
    int  rcL
    vars kn_freigabeL
    vars stornoL

    // nur bei Kundenaufträgen und Versorgungsaufträgen
    if (rt010_aart != "1" && rt010_aart != "9") {
        return OK
    }

    // nur bei Primärbedarfen aus Kundenauftragspositionen
    if (rt010_pos_herk_uebg != "4" && \
        rt010_pos_herk_uebg != "5") {
        return OK
    }

    // nur bei Einplanung oder Stornierung
    if (rt010_fu_bedr != cFUBEDR_EINPLAN \
    &&  rt010_fu_bedr != cFUBEDR_STORNO) {
        return OK
    }

    // bei Einplanung "4", bei Stornierung "3"
    if (rt010_fu_bedr == cFUBEDR_EINPLAN) {
        kn_freigabeL = "4"
        stornoL      = "0"
    }
    else {
        kn_freigabeL = "3"
        stornoL      = "1"
    }

    send bundle "b_vt110r_status" data NULL, \
                                       NULL, \
                                       NULL, \
                                       rt010_fmlz_uebg, \
                                       kn_freigabeL, \
                                       stornoL, \
                                       rt010_fklz, \
                                       NULL

    rcL = vt110r_status(rt010_vt110r_handle)
    if (rcL < OK) {
        return FAILURE
    }

    return OK
}

# Lesen und Sperren Auftragskopf für das Prüfen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_get_r000_pruefen(R000CDBI r000P, R000CDBI r000_altP)
{
    int     rcL
    boolean lockL = TRUE


    while (lockL == TRUE) {
        call md_clear_modified(r000_altP)
        r000_altP=>fi_nr = FI_NR1
        r000_altP=>fklz  = rt010_fklz

        rcL = bu_cdbi_read_cursor(r000_altP, "rt010_lock_r000pruef", TRUE, FALSE)
        switch (rcL) {
            case SQL_OK:
                // Pseudo-Köpfe dürfen nicht verarbeitet werden - Aktionssatz löschen!
                if (cod_aart_pseudo(r000_altP=>aart) == TRUE) {
                    // Fertigungsauftrag %s nicht vorhanden
                    return on_error(WARNING, "r0000000", rt010_fklz, rt010_prot)
                }
                lockL = FALSE
                break
            case SQLE_ROWLOCKED:
                // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
                call bu_msg("r0000002", rt010_fklz)
                lockL = TRUE
                break
            case SQLNOTFOUND:
                // Fertigungsauftrag %s nicht vorhanden
                return on_error(WARNING, "r0000000", rt010_fklz, rt010_prot)
            else:
                // Fehler beim Lesen in Tabelle %s.
                return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
        }
    }


    // Daten in Module-LDB übernehmen
    rt010_aufnr = r000_altP=>aufnr
    rt010_aufpos = r000_altP=>aufpos
    rt010_identnr = r000_altP=>identnr
    rt010_var = r000_altP=>var
    rt010_aart = r000_altP=>aart
    rt010_fkfs = r000_altP=>fkfs
    rt010_fkfs_a = r000_altP=>fkfs_a
    rt010_menge = r000_altP=>menge
    rt010_menge_abg = r000_altP=>menge_abg
    rt010_menge_aus = r000_altP=>menge_aus
    rt010_fsterm = r000_altP=>fsterm
    rt010_fsterm_uhr = r000_altP=>fsterm_uhr
    rt010_fortsetz_dat = r000_altP=>fortsetz_dat
    rt010_fortsetz_uhr = r000_altP=>fortsetz_uhr
    rt010_seterm = r000_altP=>seterm
    rt010_seterm_uhr = r000_altP=>seterm_uhr
    rt010_fsterm_w = r000_altP=>fsterm_w
    rt010_fsterm_w_uhr = r000_altP=>fsterm_w_uhr
    rt010_seterm_w = r000_altP=>seterm_w
    rt010_seterm_w_uhr = r000_altP=>seterm_w_uhr
    rt010_termstr = r000_altP=>termstr
    rt010_termart = r000_altP=>termart
    rt010_aenddr = r000_altP=>aenddr
    rt010_altern = r000_altP=>altern
    rt010_kostst = r000_altP=>kostst
    rt010_arbplatz = r000_altP=>arbplatz
    rt010_ncprognr = r000_altP=>ncprognr
    rt010_fam = r000_altP=>fam
    rt010_kn_reihenfolge = r000_altP=>kn_reihenfolge
    rt010_milest_verf = r000_altP=>milest_verf
    rt010_stlidentnr = r000_altP=>stlidentnr
    rt010_stlvar = r000_altP=>stlvar
    rt010_stlnr = r000_altP=>stlnr
    rt010_datvon_stl = r000_altP=>datvon_stl
    rt010_txt_stl = r000_altP=>txt_stl
    rt010_aplidentnr = r000_altP=>aplidentnr
    rt010_aplvar = r000_altP=>aplvar
    rt010_aplnr = r000_altP=>aplnr
    rt010_datvon_apl = r000_altP=>datvon_apl
    rt010_txt_apl = r000_altP=>txt_apl
    rt010_lgnr = r000_altP=>lgnr
    rt010_lgber = r000_altP=>lgber
    rt010_lgfach = r000_altP=>lgfach
    rt010_kanbannr = r000_altP=>kanbannr
    rt010_kanbananfnr = r000_altP=>kanbananfnr
    rt010_werk = r000_altP=>werk
    rt010_freigabe = r000_altP=>freigabe
    rt010_disstufe = r000_altP=>disstufe
    rt010_da = r000_altP=>da
    rt010_bs = r000_altP=>bs
    rt010_staltern = r000_altP=>staltern
    rt010_aendnr_stl = r000_altP=>aendnr_stl
    rt010_dataen_stl = r000_altP=>dataen_stl
    rt010_agaltern = r000_altP=>agaltern
    rt010_aendnr_apl = r000_altP=>aendnr_apl
    rt010_dataen_apl = r000_altP=>dataen_apl
    rt010_kneintl = r000_altP=>kneintl
    rt010_menge_offen = r000_altP=>menge_offen
    rt010_fklz_prim = r000_altP=>fklz_prim
    rt010_kn_kapaz = r000_altP=>kn_kapaz
    rt010_kz_fix = r000_altP=>kz_fix
    rt010_dlzeit = r000_altP=>dlzeit
    rt010_zusammen = r000_altP=>zusammen
    rt010_chargen_pflicht = r000_altP=>chargen_pflicht
    rt010_kosttraeger = r000_altP=>kosttraeger
    rt010_fa_verschoben = r000_altP=>fa_verschoben
    // 300358094:
    // Fehlendes r000-Feld "menge_gef" übernehmen, damit "rt010_daten_2_r000cdbi" korrekt funktioniert und nicht
    // versehentlich Werte platt macht (die menge_gef war in rt010_get_r000_netto nicht (mehr) drin).
    rt010_menge_gef = r000_altP=>menge_gef


    // 300354288:
    // Aktuell neu gelesene Daten der r000 aus rt010-Feldern ins übergebene CDBI übernehmen,
    // wenn dort die gleiche FKLZ übergeben wurde.
    switch (rt010_daten_2_r000cdbi(r000P, FALSE, TRUE)) {
        case OK:
        case INFO:
            break
        else:
            return FAILURE
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_get_r000_netto
#
# Lesen und Sperren Auftragskopf für die Nettobedarfsrechnung
#-----------------------------------------------------------------------------------------------------------------------
# siehe auch "rt010_get_r000_abschl"
int proc rt010_get_r000_netto(R000CDBI r000P)
{
    int      rcL
    boolean  lockL = TRUE
    R000CDBI r000L = bu_cdbi_new("r000")


    while (lockL == TRUE) {
        r000L=>fi_nr = FI_NR1
        r000L=>fklz  = rt010_fklz
        rcL = bu_cdbi_read_cursor(r000L, "rt010_lock_r000netto", TRUE, FALSE)
        switch (rcL) {
            case SQL_OK:
                lockL = FALSE
                break
            case SQLNOTFOUND:
                // Fertigungsauftrag %s nicht vorhanden
                return on_error(FAILURE, "r0000000", rt010_fklz, rt010_prot)
            case SQLE_ROWLOCKED:
                // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
                call bu_msg("r0000002", rt010_fklz)
                lockL = TRUE
                break
            else:
                // Fehler beim Lesen in Tabelle %s.
                return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
        }
    }

    rt010_aufnr = r000L=>aufnr
    rt010_aufpos = r000L=>aufpos
    rt010_identnr = r000L=>identnr
    rt010_var = r000L=>var
    rt010_aart = r000L=>aart
    rt010_fkfs = r000L=>fkfs
    rt010_fkfs_a = r000L=>fkfs_a
    rt010_menge = r000L=>menge
    rt010_menge_abg = r000L=>menge_abg
    rt010_menge_aus = r000L=>menge_aus
    rt010_menge_gef = r000L=>menge_gef  // 300358094: Korrektur des Tickets 300349432 (Reduktion r000-Zugriffe)
    rt010_menge_offen = r000L=>menge_offen
    rt010_fsterm = r000L=>fsterm
    rt010_fsterm_uhr = r000L=>fsterm_uhr
    rt010_fortsetz_dat = r000L=>fortsetz_dat
    rt010_fortsetz_uhr = r000L=>fortsetz_uhr
    rt010_seterm = r000L=>seterm
    rt010_seterm_uhr = r000L=>seterm_uhr
    rt010_kz_fix = r000L=>kz_fix
    rt010_fsterm_w = r000L=>fsterm_w
    rt010_fsterm_w_uhr = r000L=>fsterm_w_uhr
    rt010_seterm_w = r000L=>seterm_w
    rt010_seterm_w_uhr = r000L=>seterm_w_uhr
    rt010_dlzeit = r000L=>dlzeit
    rt010_zusammen = r000L=>zusammen
    rt010_termstr = r000L=>termstr
    rt010_termart = r000L=>termart
    rt010_da = r000L=>da
    rt010_chargen_pflicht = r000L=>chargen_pflicht
    rt010_lgnr = r000L=>lgnr
    rt010_lgber = r000L=>lgber
    rt010_lgfach = r000L=>lgfach
    rt010_werk = r000L=>werk
    rt010_kosttraeger = r000L=>kosttraeger
    rt010_fa_verschoben = r000L=>fa_verschoben
    rt010_freigabe = r000L=>freigabe
    rt010_kn_reihenfolge = r000L=>kn_reihenfolge


    // Ggf. gelesene Werte übernehmen
    if (defined(r000P) == TRUE) {
        if (bu_cdt_clone(r000L, r000P, TRUE, TRUE, "") < OK) {
            log LOG_DEBUG, LOGFILE, "Fehler bu_cdt_clone"
            return FAILURE
        }
        call md_clear_modified(r000P)
    }


    // Sicherung der gelesenen Werte, damit der spätere Update nur gemacht wird, wenn sich auch
    // tatsächlich etwas geändert hat.
    rt010_menge->memo1          = rt010_menge
    rt010_fsterm->memo1         = rt010_fsterm
    rt010_fsterm_uhr->memo1     = rt010_fsterm_uhr
    rt010_fortsetz_dat->memo1   = rt010_fortsetz_dat
    rt010_fortsetz_uhr->memo1   = rt010_fortsetz_uhr
    rt010_seterm->memo1         = rt010_seterm
    rt010_seterm_uhr->memo1     = rt010_seterm_uhr
    rt010_dlzeit->memo1         = rt010_dlzeit
    rt010_seterm_w->memo1       = rt010_seterm_w
    rt010_seterm_w_uhr->memo1   = rt010_seterm_w_uhr
    rt010_termart->memo1        = rt010_termart

    rt010_aufnr->memo1          = rt010_aufnr
    rt010_aufpos->memo1         = rt010_aufpos
    rt010_fkfs->memo1           = rt010_fkfs
    rt010_fkfs_a->memo1         = rt010_fkfs_a
    rt010_menge_abg->memo1      = rt010_menge_abg
    rt010_menge_aus->memo1      = rt010_menge_aus
    rt010_menge_offen->memo1    = rt010_menge_offen
    rt010_fa_verschoben->memo1  = rt010_fa_verschoben
    rt010_kn_reihenfolge->memo1 = rt010_kn_reihenfolge

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_get_r000_abs
#
# Lesen und Sperren Auftragskopf für Absetzen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_get_r000_abs()
{
    vars lock

    if !(dm_is_cursor("rt010_abs_r000")) {
        dbms declare rt010_abs_r000 cursor for select \
                    r000.menge, \
                    r000.menge_abg, \
                    r000.werk \
             from   r000 :MSSQL_FOR_UPDATE \
             where  r000.fi_nr  = ::FI_NR1 and \
                r000.fklz   = ::fklz \
             :FOR_UPDATE

        dbms with cursor rt010_abs_r000 alias \
                                            rt010_menge_abs, \
                                            rt010_menge_abg_abs, \
                                            rt010_werk
    }

    lock = TRUE
    while (lock == TRUE) {

        dbms with cursor rt010_abs_r000 execute using FI_NR1, rt010_fklz_abs

        if (SQL_CODE == SQLNOTFOUND) {
            // Fertigungsauftrag %s nicht vorhanden
            return on_error(FAILURE, "r0000000", rt010_fklz_abs, rt010_prot)
        }

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
            call bu_msg("r0000002", rt010_fklz_abs)
            next
        }

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
        }

        lock = FALSE
    }

    // Sicherung der gelesenen Werte, damit der spätere Update nur gemacht wird, wenn sich auch
    // tatsächlich etwas geändert hat.
    rt010_menge_abg_abs->memo1 = rt010_menge_abg_abs

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_get_r000_abschl
#
# Lesen und Sperren Auftragskopf für die Abschlußarbeiten
#-----------------------------------------------------------------------------------------------------------------------
# siehe auch "rt010_get_r000_netto"
int proc rt010_get_r000_abschl(R000CDBI r000P)
{
    int      rcL
    boolean  lockL = TRUE
    R000CDBI r000L = bu_cdbi_new("r000")


    while (lockL == TRUE) {
        r000L=>fi_nr = FI_NR1
        r000L=>fklz  = rt010_fklz
        rcL = bu_cdbi_read_cursor(r000L, "rt010_lock_r000abschl", TRUE, FALSE)
        switch (rcL) {
            case SQL_OK:
                lockL = FALSE
                break
            case SQLNOTFOUND:
                // Fertigungsauftrag %s nicht vorhanden
                return on_error(FAILURE, "r0000000", rt010_fklz, rt010_prot)
            case SQLE_ROWLOCKED:
                // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
                call bu_msg("r0000002", rt010_fklz)
                lockL = TRUE
                break
            else:
                // Fehler beim Lesen in Tabelle %s.
                return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
        }
    }

    rt010_aufnr = r000L=>aufnr
    rt010_aufpos = r000L=>aufpos
    rt010_identnr = r000L=>identnr
    rt010_var = r000L=>var
    rt010_aart = r000L=>aart
    rt010_fkfs = r000L=>fkfs
    rt010_fkfs_a = r000L=>fkfs_a
    rt010_menge = r000L=>menge
    rt010_fsterm = r000L=>fsterm
    rt010_fsterm_uhr = r000L=>fsterm_uhr
    rt010_fortsetz_dat = r000L=>fortsetz_dat
    rt010_fortsetz_uhr = r000L=>fortsetz_uhr
    rt010_seterm = r000L=>seterm
    rt010_seterm_uhr = r000L=>seterm_uhr
    rt010_fsterm_w = r000L=>fsterm_w
    rt010_fsterm_w_uhr = r000L=>fsterm_w_uhr
    rt010_seterm_w = r000L=>seterm_w
    rt010_seterm_w_uhr = r000L=>seterm_w_uhr
    rt010_freigabe = r000L=>freigabe
    rt010_termstr = r000L=>termstr
    rt010_termart = r000L=>termart
    rt010_aenddr = r000L=>aenddr
    rt010_disstufe = r000L=>disstufe
    rt010_da = r000L=>da
    rt010_bs = r000L=>bs
    rt010_kostst = r000L=>kostst
    rt010_arbplatz = r000L=>arbplatz
    rt010_ncprognr = r000L=>ncprognr
    rt010_fam = r000L=>fam
    rt010_kn_reihenfolge = r000L=>kn_reihenfolge
    rt010_milest_verf = r000L=>milest_verf
    rt010_stlidentnr = r000L=>stlidentnr
    rt010_stlvar = r000L=>stlvar
    rt010_stlnr = r000L=>stlnr
    rt010_staltern = r000L=>staltern
    rt010_datvon_stl = r000L=>datvon_stl
    rt010_aendnr_stl = r000L=>aendnr_stl
    rt010_dataen_stl = r000L=>dataen_stl
    rt010_txt_stl = r000L=>txt_stl
    rt010_aplidentnr = r000L=>aplidentnr
    rt010_aplvar = r000L=>aplvar
    rt010_aplnr = r000L=>aplnr
    rt010_agaltern = r000L=>agaltern
    rt010_datvon_apl = r000L=>datvon_apl
    rt010_aendnr_apl = r000L=>aendnr_apl
    rt010_dataen_apl = r000L=>dataen_apl
    rt010_txt_apl = r000L=>txt_apl
    rt010_lgnr = r000L=>lgnr
    rt010_lgber = r000L=>lgber
    rt010_lgfach = r000L=>lgfach
    rt010_werk = r000L=>werk
    rt010_kneintl = r000L=>kneintl
    rt010_menge_offen = r000L=>menge_offen
    rt010_fklz_prim = r000L=>fklz_prim
    rt010_kn_kapaz = r000L=>kn_kapaz

    if (defined(r000L=>kz_fix) != TRUE \
    ||  r000L=>kz_fix          == "") {
        r000L=>kz_fix = cKZ_FIX_NEIN
    }
    rt010_kz_fix = r000L=>kz_fix


    // Ggf. gelesene Werte übernehmen
    if (defined(r000P) == TRUE) {
        if (bu_cdt_clone(r000L, r000P, TRUE, TRUE, "") < OK) {
            log LOG_DEBUG, LOGFILE, "Fehler bu_cdt_clone"
            return FAILURE
        }
        call md_clear_modified(r000P)
    }

    // Sicherung der gelesenen Werte, damit der spätere Update nur gemacht wird, wenn sich auch
    // tatsächlich etwas geändert hat.
    rt010_fkfs->memo1 = rt010_fkfs
    rt010_fkfs_a->memo1 = rt010_fkfs_a
    rt010_aenddr->memo1 = rt010_aenddr
    rt010_kostst->memo1 = rt010_kostst
    rt010_arbplatz->memo1 = rt010_arbplatz
    rt010_ncprognr->memo1 = rt010_arbplatz
    rt010_fam->memo1 = rt010_fam
    rt010_kn_reihenfolge->memo1 = rt010_kn_reihenfolge
    rt010_milest_verf->memo1 = rt010_milest_verf
    rt010_stlidentnr->memo1 = rt010_stlidentnr
    rt010_stlvar->memo1 = rt010_stlvar
    rt010_stlnr->memo1 = rt010_stlnr
    rt010_staltern->memo1 = rt010_staltern
    rt010_datvon_stl->memo1 = rt010_datvon_stl
    rt010_aendnr_stl->memo1 = rt010_aendnr_stl
    rt010_dataen_stl->memo1 = rt010_dataen_stl
    rt010_txt_stl->memo1 = rt010_txt_stl
    rt010_aplidentnr->memo1 = rt010_aplidentnr
    rt010_aplvar->memo1 = rt010_aplvar
    rt010_aplnr->memo1 = rt010_aplnr
    rt010_agaltern->memo1 = rt010_agaltern
    rt010_datvon_apl->memo1 = rt010_datvon_apl
    rt010_aendnr_apl->memo1 = rt010_aendnr_apl
    rt010_dataen_apl->memo1 = rt010_dataen_apl
    rt010_txt_apl->memo1 = rt010_txt_apl

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_sel_r000
#
# Lesen Auftragskopf
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sel_r000()
{

    if !(dm_is_cursor("rt010_read_r000")) {
        dbms declare rt010_read_r000 cursor for \
             select  r000.aufnr, \
                     r000.aufpos, \
                     r000.identnr, \
                     r000.var, \
                     r000.aart, \
                     r000.fkfs, \
                     r000.menge, \
                     r000.menge_abg, \
                     r000.menge_aus, \
                     r000.fsterm, \
                     r000.fsterm_uhr, \
                     r000.seterm, \
                     r000.seterm_uhr, \
                     r000.fsterm_w, \
                     r000.fsterm_w_uhr, \
                     r000.seterm_w, \
                     r000.seterm_w_uhr, \
                     r000.termstr, \
                     r000.termart, \
                     r000.werk, \
                     r000.lgnr \
               from  r000 \
              where  r000.fi_nr  = :+FI_NR1 and \
                 r000.fklz   = ::fklz

        dbms with cursor rt010_read_r000 alias rt010_aufnr, \
                                                rt010_aufpos, \
                                               rt010_identnr, \
                                               rt010_var, \
                                               rt010_aart, \
                                               rt010_fkfs, \
                                               rt010_menge, \
                                               rt010_menge_abg, \
                                               rt010_menge_aus, \
                                               rt010_fsterm, \
                                               rt010_fsterm_uhr, \
                                               rt010_seterm, \
                                               rt010_seterm_uhr, \
                                               rt010_fsterm_w, \
                                               rt010_fsterm_w_uhr, \
                                               rt010_seterm_w, \
                                               rt010_seterm_w_uhr, \
                                               rt010_termstr, \
                                               rt010_termart,\
                                               rt010_werk, \
                                               rt010_lgnr
    }
    dbms with cursor rt010_read_r000 execute using rt010_fklz

    if (SQL_CODE == SQLNOTFOUND) {
        return WARNING
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_sel_r000_uebg
#
# Lesen übergeordneten Auftragskopf
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sel_r000_uebg()
{

    if !(dm_is_cursor("rt010_read_uebg")) {
        dbms declare rt010_read_uebg cursor for \
             select  r000.disstufe, \
                     r000.werk \
               from  r000 \
              where  r000.fi_nr  = ::FI_NR1 and \
                 r000.fklz   = ::fklz_uebg

        dbms with cursor rt010_read_uebg alias rt010_disstufe_uebg, \
                                               rt010_werk
    }
    dbms with cursor rt010_read_uebg execute using FI_NR1, rt010_fklz_uebg

    if (SQL_CODE == SQLNOTFOUND) {
        // Fertigungsauftrag %s nicht vorhanden
        return on_error(WARNING, "r0000000", rt010_fklz_uebg, rt010_prot)
    }
    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r000", rt010_prot)
    }

    return OK
}

/**
 * Satz in Tabelle "r000" ändern nach erfolgreicher Prüfung
 *
 * @param r000P         Aktuelle CDBI-Instanz der r000
 * @param r000_altP     CDBI-instanz der r000 mit den alten Daten (aus DB)
 * @return OK
 * @return FAILURE      Fehler
 * @see                 {@code rt210_update_r000}
 * @see                 {@code rt110_update_r000}
 * @example
 **/
int proc rt010_update_r000_pruefen(R000CDBI r000P, R000CDBI r000_altP)
{
    int      rcL
    boolean  aenderungL  = FALSE
    R000CDBI r000L


    // CDBI-Instanz erzeugen
    // 300349432 - Performance
    if (defined(r000P) == TRUE \
    &&  r000P=>fklz    == rt010_fklz \
    &&  r000P=>fi_nr   == FI_NR1) {
        r000L = r000P
    }
    else {
        r000L = bu_cdbi_new("r000")
        call md_clear_modified(r000L)
        r000L=>fi_nr = FI_NR1
        r000L=>fklz  = rt010_fklz
    }


    if (r000_altP=>kostst != rt010_kostst) {
        log LOG_DEBUG, LOGFILE, "kostst von >" ## r000_altP=>kostst ## "< auf >" ## rt010_kostst ## "< geändert"
        r000L=>kostst = rt010_kostst
        aenderungL    = TRUE
    }

    if (r000_altP=>arbplatz != rt010_arbplatz) {
        log LOG_DEBUG, LOGFILE, "arbplatz von >" ## r000_altP=>arbplatz ## "< auf >" ## rt010_arbplatz ## "< geändert"
        r000L=>arbplatz = rt010_arbplatz
        aenderungL      = TRUE
    }

    if (r000_altP=>ncprognr != rt010_ncprognr) {
        log LOG_DEBUG, LOGFILE, "ncprognr von >" ## r000_altP=>ncprognr ## "< auf >" ## rt010_ncprognr ## "< geändert"
        r000L=>ncprognr = rt010_ncprognr
        aenderungL      = TRUE
    }

    if (r000_altP=>fam != rt010_fam) {
        log LOG_DEBUG, LOGFILE, "fam von >" ## r000_altP=>fam ## "< auf >" ## rt010_fam ## "< geändert"
        r000L=>fam = rt010_fam
        aenderungL = TRUE
    }

    if (r000_altP=>kn_reihenfolge != rt010_kn_reihenfolge) {
        log LOG_DEBUG, LOGFILE, "kn_reihenfolge von >" ## r000_altP=>kn_reihenfolge ## "< auf >" ## rt010_kn_reihenfolge ## "< geändert"
        r000L=>kn_reihenfolge = rt010_kn_reihenfolge
        aenderungL            = TRUE
    }

    if (r000_altP=>milest_verf != rt010_milest_verf) {
        log LOG_DEBUG, LOGFILE, "milest_verf von >" ## r000_altP=>milest_verf ## "< auf >" ## rt010_milest_verf ## "< geändert"
        r000L=>milest_verf = rt010_milest_verf
        aenderungL         = TRUE
    }

    if (r000_altP=>stlidentnr != rt010_stlidentnr) {
        log LOG_DEBUG, LOGFILE, "stlidentnr von >" ## r000_altP=>stlidentnr ## "< auf >" ## rt010_stlidentnr ## "< geändert"
        r000L=>stlidentnr = rt010_stlidentnr
        aenderungL        = TRUE
    }

    if (r000_altP=>stlvar != rt010_stlvar) {
        log LOG_DEBUG, LOGFILE, "stlvar von >" ## r000_altP=>stlvar ## "< auf >" ## rt010_stlvar ## "< geändert"
        r000L=>stlvar = rt010_stlvar
        aenderungL    = TRUE
    }

    if (r000_altP=>stlnr != rt010_stlnr) {
        log LOG_DEBUG, LOGFILE, "stlnr von >" ## r000_altP=>stlnr ## "< auf >" ## rt010_stlnr ## "< geändert"
        r000L=>stlnr = rt010_stlnr
        aenderungL   = TRUE
    }

    if (@date(r000_altP=>datvon_stl) != @date(rt010_datvon_stl)) {
        log LOG_DEBUG, LOGFILE, "datvon_stl von >" ## r000_altP=>datvon_stl ## "< auf >" ## rt010_datvon_stl ## "< geändert"
        r000L=>datvon_stl = rt010_datvon_stl
        aenderungL        = TRUE
    }

    if (r000_altP=>txt_stl != rt010_txt_stl) {
        log LOG_DEBUG, LOGFILE, "txt_stl von >" ## r000_altP=>txt_stl ## "< auf >" ## rt010_txt_stl ## "< geändert"
        r000L=>txt_stl = rt010_txt_stl
        aenderungL     = TRUE
    }

    if (@date(r000_altP=>dataen_stl) != @date(rt010_dataen_stl)) {
        log LOG_DEBUG, LOGFILE, "dataen_stl von >" ## r000_altP=>dataen_stl ## "< auf >" ## rt010_dataen_stl ## "< geändert"
        r000L=>dataen_stl = rt010_dataen_stl
        aenderungL        = TRUE
    }

    if (r000_altP=>aendnr_stl != rt010_aendnr_stl) {
        log LOG_DEBUG, LOGFILE, "aendnr_stl von >" ## r000_altP=>aendnr_stl ## "< auf >" ## rt010_aendnr_stl ## "< geändert"
        r000L=>aendnr_stl = rt010_aendnr_stl
        aenderungL        = TRUE
    }

    if (r000_altP=>aplidentnr != rt010_aplidentnr) {
        log LOG_DEBUG, LOGFILE, "aplidentnr von >" ## r000_altP=>aplidentnr ## "< auf >" ## rt010_aplidentnr ## "< geändert"
        r000L=>aplidentnr = rt010_aplidentnr
        aenderungL        = TRUE
    }

    if (r000_altP=>aplvar != rt010_aplvar) {
        log LOG_DEBUG, LOGFILE, "aplvar von >" ## r000_altP=>aplvar ## "< auf >" ## rt010_aplvar ## "< geändert"
        r000L=>aplvar = rt010_aplvar
        aenderungL    = TRUE
    }

    if (r000_altP=>aplnr != rt010_aplnr) {
        log LOG_DEBUG, LOGFILE, "aplnr von >" ## r000_altP=>aplnr ## "< auf >" ## rt010_aplnr ## "< geändert"
        r000L=>aplnr = rt010_aplnr
        aenderungL   = TRUE
    }

    if (@date(r000_altP=>datvon_apl) != @date(rt010_datvon_apl)) {
        log LOG_DEBUG, LOGFILE, "datvon_apl von >" ## r000_altP=>datvon_apl ## "< auf >" ## rt010_datvon_apl ## "< geändert"
        r000L=>datvon_apl = rt010_datvon_apl
        aenderungL        = TRUE
    }

    if (r000_altP=>txt_apl != rt010_txt_apl) {
        log LOG_DEBUG, LOGFILE, "txt_apl von >" ## r000_altP=>txt_apl ## "< auf >" ## rt010_txt_apl ## "< geändert"
        r000L=>txt_apl = rt010_txt_apl
        aenderungL     = TRUE
    }

    if (@date(r000_altP=>dataen_apl) != @date(rt010_dataen_apl)) {
        log LOG_DEBUG, LOGFILE, "dataen_apl von >" ## r000_altP=>dataen_apl ## "< auf >" ## rt010_dataen_apl ## "< geändert"
        r000L=>dataen_apl = rt010_dataen_apl
        aenderungL        = TRUE
    }

    if (r000_altP=>aendnr_apl != rt010_aendnr_apl) {
        log LOG_DEBUG, LOGFILE, "aendnr_apl von >" ## r000_altP=>aendnr_apl ## "< auf >" ## rt010_aendnr_apl ## "< geändert"
        r000L=>aendnr_apl = rt010_aendnr_apl
        aenderungL        = TRUE
    }


    if (aenderungL == FALSE) {
        log LOG_DEBUG, LOGFILE, "Kein Update auf r000 für fklz >" ## rt010_fklz ## "< da kein Feld geändert wurde..."
        return OK
    }
    log LOG_DEBUG, LOGFILE, "Update auf r000 für fklz >" ## rt010_fklz ## "<..."


    // Änderungshistorie setzen
    public rq000.bsl
    rcL = cdtTermGlobal_set_historie_vor_update_cdbi(r000L, TRUE, cAES_UPDATE)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler aus cdtTermGlobal_set_historie_vor_update_cdbi rc=" ## rcL
        return on_error(FAILURE)
    }

    call md_set_modified(r000L, "fi_nr")
    call md_set_modified(r000L, "fklz")

    if (bu_cdbi_update(r000L, FALSE, TRUE, FALSE) != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r000", rt010_prot)
    }

    call md_clear_modified(r000L)

    return OK
}

/**
 * Diese Methode speichert die Änderungen am Fertigungsauftrag nach der Nettobedarfsrechnung
 *
 * Es wird ggf. eine Verschiebung des FA über den Endtermin angestossen
 * (Aber ohne Anstellen eines Aktionssatzes in r115)
 * Wenn mit Zusammenfassung gearbeitet wird kann es vorkommen, dass die Strukturtermine geändert werden.
 *
 * Folgende Felder werden in "rt010_nettobedarf" nicht verändert (darum auch kein Update darauf mehr):
 * - rt010_fsterm_w
 * - rt010_fsterm_w_uhr
 *
 * Auf folgende Felder wird ein Update gemacht, wenn sie sich jeweils geändert haben:
 * - rt010_fklz        FKLZ des zu verarbeitenden FA in der Bedarfsrechnung (rh110 / rv110)
 * - rt010_tkz         TKZ kommt aus dem "receive bundle", d.h. aus dem Aktionssatz r115 der Bedarfsrechnung
 * - [rt010_mkz]
 * - rt010_menge
 * - rt010_dlzeit
 * - rt010_seterm
 * - rt010_seterm_uhr
 * - rt010_fsterm
 * - rt010_fsterm_uhr
 * - rt010_fortsetz_dat
 * - rt010_fortsetz_uhr
 * - rt010_zusammen
 * - rt010_seterm_w
 * - rt010_seterm_w_uhr
 * - rt010_aufnr
 * - rt010_aufpos
 * - rt010_fkfs
 * - rt010_fkfs_a
 * - rt010_menge_abg
 * - rt010_menge_aus
 * - rt010_menge_offen
 * - rt010_fa_verschoben
 * - rt010_kz_fix
 * - rt010_termstr
 * - rt010_termart
 * - rt010_aart
 *
 * @param [r000P]           CDBI-Instanz der r000 zu rt010_fklz
 * @return OK
 * @return FAILURE          Fehler
 * @see                     {@code cdtTermGlobal_richtung2termart}
 * @see                     {@code cdtTermGlobal_set_historie_vor_update_cdbi}
 * @example                 rh110/rv110
 **/
int proc rt010_update_r000_netto(R000CDBI r000P)
{
    int     rcL
    boolean aenderungL                   = FALSE
    boolean terminierungsrelevantL       = FALSE
    boolean strukturterminierungL        = FALSE
    boolean mengenaenderungL             = FALSE
    boolean endtermin_geaendertL         = FALSE
    boolean strukturendtermin_geaendertL = FALSE
    boolean strukturendtermin_aenderbarL = FALSE
    string  kn_term_verschobL            = NULL
    int     angearbeitetL                = FALSE
    double  mengeL
    date    terminL
    int     dlzeitL
    double  menge_abg_uebg_altL


    // CDBI-Instanz erzeugen
    // 300349432 - Performance
    log LOG_DEBUG, LOGFILE, "rt010_fklz >" ## rt010_fklz ## "<"
    if (defined(r000P) != TRUE \
    ||  r000P=>fklz    != rt010_fklz \
    ||  r000P=>fi_nr   != FI_NR1) {
        r000P = bu_cdbi_new("r000")
        r000P=>fi_nr = FI_NR1
        r000P=>fklz  = rt010_fklz
    }
    else {
        call md_clear_modified(r000P)
    }


    // 1) Key-Felder:
    r000P=>fi_nr = FI_NR1
    r000P=>fklz  = rt010_fklz


    // 2) Änderung Menge:
    mengeL = rt010_menge->memo1 + 0
    if (mengeL != rt010_menge) {
        log LOG_DEBUG, LOGFILE, "menge von >" ## rt010_menge->memo1 ## "< auf >" ## rt010_menge ## "< geändert"
        r000P=>menge           = rt010_menge
        aenderungL             = TRUE
        terminierungsrelevantL = TRUE
        mengenaenderungL       = TRUE
    }

    mengeL = rt010_menge_abg->memo1 + 0
    if (mengeL != rt010_menge_abg) {
        log LOG_DEBUG, LOGFILE, "menge_abg von >" ## rt010_menge_abg->memo1 ## "< auf >" ## rt010_menge_abg ## "< geändert"
        r000P=>menge_abg = rt010_menge_abg
        aenderungL       = TRUE
    }

    mengeL = rt010_menge_aus->memo1 + 0
    if (mengeL != rt010_menge_aus) {
        log LOG_DEBUG, LOGFILE, "menge_aus von >" ## rt010_menge_aus->memo1 ## "< auf >" ## rt010_menge_aus ## "< geändert"
        r000P=>menge_aus = rt010_menge_aus
        aenderungL       = TRUE
    }

    mengeL = rt010_menge_offen->memo1 + 0
    if (mengeL != rt010_menge_offen) {
        log LOG_DEBUG, LOGFILE, "menge_offen von >" ## rt010_menge_offen->memo1 ## "< auf >" ## rt010_menge_offen ## "< geändert"
        r000P=>menge_offen = rt010_menge_offen
        aenderungL         = TRUE
    }


    // 2) Änderung Terminfelder:
    log LOG_DEBUG, LOGFILE, "rt010_tkz >" ## rt010_tkz ## "< (aus Bedarfsrechnung) / " \
                         ## "rt010_mkz >" ## rt010_mkz ## "< (aus rt010_absetzen/rt010_ausschuss) / " \
                         ## "rt010_kn_aend_fa >" ## rt010_kn_aend_fa ## "<"
    if (rt010_tkz == cTKZ_STRUKTUR) {
        switch (rt010_fu_bedr) {
            case cFUBEDR_MTAEND:
                // Wenn in der (bei FU_BEDR=2) schon eine Strukturterminierung von extern (z.B. im rv0000) angestossen
                // wurde, macht es keinen Sinn, die Baukastentermine zu ändern. Diese werden in der Terminierung
                // sowieso durch die Stukturtermine ersetzt
                strukturterminierungL = TRUE
                break
            case cFUBEDR_EINPLAN:
            case cFUBEDR_TAUSCH:
                // Beim Absetzen und Einplanung/Tausch müssen die Baukastentermine geändert werden
                strukturterminierungL = FALSE
                break
            else:       // Sonstige FU_BEDR -> ändern Baukastentermine
                strukturterminierungL = FALSE
                break
        }
    }
    log LOG_DEBUG, LOGFILE, "strukturterminierung >" ## strukturterminierungL ## "<"

    if (strukturterminierungL         != TRUE \
    &&  cod_kz_fix_nein(rt010_kz_fix) == TRUE) {
        if (rt010_seterm->memo1 != NULL) {
            terminL = @to_date(rt010_seterm->memo1, DATEFORMAT0)
        }
        if (@date(terminL) != @date(rt010_seterm)) {
            log LOG_DEBUG, LOGFILE, "seterm von >" ## rt010_seterm->memo1 ## "< auf >" ## rt010_seterm ## "< geändert"
            r000P=>seterm          = rt010_seterm
            aenderungL             = TRUE
            terminierungsrelevantL = TRUE
            endtermin_geaendertL   = TRUE
            kn_term_verschobL      = KN_TERM_VERSCHOB_ENDE
        }

        if (rt010_seterm_uhr->memo1 != NULL) {
            terminL = @to_date(rt010_seterm_uhr->memo1, DATEFORMAT1)
        }
        if (@time(terminL) != @time(rt010_seterm_uhr)) {
            log LOG_DEBUG, LOGFILE, "seterm_uhr von >" ## rt010_seterm_uhr->memo1 ## "< auf >" ## rt010_seterm_uhr ## "< geändert"
            r000P=>seterm_uhr      = rt010_seterm_uhr
            aenderungL             = TRUE
            terminierungsrelevantL = TRUE
            endtermin_geaendertL   = TRUE
            kn_term_verschobL      = KN_TERM_VERSCHOB_ENDE
        }
    }


    // 300299090:
    // Prüfen, ob der neue Endtermin vor dem Starttermin liegt
    if (endtermin_geaendertL == TRUE) {
        rcL = rt010_pruefen_starttermin_gegen_endtermin()
        switch (rcL) {
            case OK:    // Starttermine wurden geändert
                angearbeitetL = fertig_check_fkfs_angearbeitet(rt010_fkfs, rt010_fkfs_a, rt010_fklz)
                if (angearbeitetL == TRUE) {
                    r000P=>fortsetz_uhr = rt010_fortsetz_uhr
                    r000P=>fortsetz_dat = rt010_fortsetz_dat
                }
                else {
                    r000P=>fsterm_uhr = rt010_fsterm_uhr
                    r000P=>fsterm     = rt010_fsterm
                }
                break
            case INFO:  // Starttermine wurden nicht geändert
                break
            else:
                return FAILURE
        }
    }


    // 300261626:
    // 3) Der Update der Strukturtermine im Sekundärauftrag nur machen, wenn mit Zusammenfassung gearbeitet wird
    if (cod_aart_sek(rt010_aart) == TRUE) {
        // Bei Sekundäraufträgen wird die Zusammenfassung geprüft
        switch (rt010_zusammen) {
            case "2":
            case "3":
            case "4":
                strukturendtermin_aenderbarL = TRUE
                break
            case "1":   // ohne Zusammenfassung
            else:
                strukturendtermin_aenderbarL = FALSE
                break
        }
    }
    else if (cod_aart_vertriebsfa(rt010_aart) == TRUE) {
        // 300299090: Bei Primäraufträgen aus Vertrieb untern folgenden Bedingungen:
        //            - die Zuordnung zu einem Bedarf komplett abgesetzt wurde
        //              und
        //            - Tausch
        //              und
        //            - FA nicht fixiert
        menge_abg_uebg_altL = rt010_menge_abg_uebg->memo1 + 0
        if (rt010_menge_absetzbar         >  (rt010_menge_abg_uebg - menge_abg_uebg_altL) \
        &&  rt010_fu_bedr                 == cFUBEDR_TAUSCH \
        &&  cod_kz_fix_nein(rt010_kz_fix) == TRUE) {
            strukturendtermin_aenderbarL = TRUE
        }
        else {
            strukturendtermin_aenderbarL = FALSE
        }
    }
    else {
        // 300299090: Bei allen anderen Primäraufträgen die Strukturtermine nicht ändern
        strukturendtermin_aenderbarL = FALSE
    }
    log LOG_DEBUG, LOGFILE, "strukturendtermin_aenderbar >" ## strukturendtermin_aenderbarL ## "<"


    if (strukturendtermin_aenderbarL == TRUE) {
        if (rt010_seterm_w->memo1 != NULL) {
            terminL = @to_date(rt010_seterm_w->memo1, DATEFORMAT0)
        }
        if (@date(terminL) != @date(rt010_seterm_w)) {
            log LOG_DEBUG, LOGFILE, "seterm_w von >" ## rt010_seterm_w->memo1 ## "< auf >" ## rt010_seterm_w ## "< geändert"
            r000P=>seterm_w              = rt010_seterm_w
            aenderungL                   = TRUE
            terminierungsrelevantL       = TRUE
            strukturendtermin_geaendertL = TRUE
        }

        if (rt010_seterm_w_uhr->memo1 != NULL) {
            terminL = @to_date(rt010_seterm_w_uhr->memo1, DATEFORMAT1)
        }
        if (@time(terminL) != @time(rt010_seterm_w_uhr)) {
            log LOG_DEBUG, LOGFILE, "seterm_w_uhr von >" ## rt010_seterm_w_uhr->memo1 ## "< auf >" ## rt010_seterm_w_uhr ## "< geändert"
            r000P=>seterm_w_uhr          = rt010_seterm_w_uhr
            aenderungL                   = TRUE
            terminierungsrelevantL       = TRUE
            strukturendtermin_geaendertL = TRUE
        }
    }

    // 300299090:
    // Prüfen, ob der neue Struktur-Endtermin vor dem Struktur-Starttermin liegt
    if (strukturendtermin_geaendertL == TRUE) {
        rcL = rt010_pruefen_struktur_starttermin_gegen_endtermin()
        switch (rcL) {
            case OK:    // Struktur-Starttermine wurden geändert
                r000P=>fsterm_w_uhr = rt010_fsterm_w_uhr
                r000P=>fsterm_w     = rt010_fsterm_w
                break
            case INFO:  // Struktur-Starttermine wurden nicht geändert
                break
            else:
                return FAILURE
        }
    }


    // 4) Änderung DLZ:
    dlzeitL = rt010_dlzeit->memo1 + 0
    if (dlzeitL != rt010_dlzeit) {
        log LOG_DEBUG, LOGFILE, "dlzeit von >" ## rt010_dlzeit->memo1 ## "< auf >" ## rt010_dlzeit ## "< geändert"
        r000P=>dlzeit          = rt010_dlzeit
        aenderungL             = TRUE
        terminierungsrelevantL = TRUE
    }


    // 5) Sonstige Felder:
    if (rt010_aufnr->memo1 != rt010_aufnr) {
        log LOG_DEBUG, LOGFILE, "aufnr von >" ## rt010_aufnr->memo1 ## "< auf >" ## rt010_aufnr ## "< geändert"
        r000P=>aufnr = rt010_aufnr
        aenderungL   = TRUE
    }

    if (rt010_aufpos->memo1 != rt010_aufpos) {
        log LOG_DEBUG, LOGFILE, "aufpos von >" ## rt010_aufpos->memo1 ## "< auf >" ## rt010_aufpos ## "< geändert"
        r000P=>aufpos = rt010_aufpos
        aenderungL    = TRUE
    }

    if (rt010_fkfs->memo1 != rt010_fkfs) {
        log LOG_DEBUG, LOGFILE, "fkfs von >" ## rt010_fkfs->memo1 ## "< auf >" ## rt010_fkfs ## "< geändert"
        r000P=>fkfs = rt010_fkfs
        aenderungL  = TRUE
    }

    if (rt010_fkfs_a->memo1 != rt010_fkfs_a) {
        log LOG_DEBUG, LOGFILE, "fkfs_a von >" ## rt010_fkfs_a->memo1 ## "< auf >" ## rt010_fkfs_a ## "< geändert"
        r000P=>fkfs_a = rt010_fkfs_a
        aenderungL    = TRUE
    }

    if (rt010_fa_verschoben->memo1 != rt010_fa_verschoben) {
        log LOG_DEBUG, LOGFILE, "fa_verschoben von >" ## rt010_fa_verschoben->memo1 ## "< auf >" ## rt010_fa_verschoben ## "< geändert"
        r000P=>fa_verschoben = rt010_fa_verschoben
        aenderungL           = TRUE
    }


    // 6) Bei Änderung terminierungsrelevanter Daten das KN_TERMINIERT zurücksetzen
    if (terminierungsrelevantL == TRUE) {
        log LOG_DEBUG, LOGFILE, "Terminierungsrelevante Änderung -> Setzen kn_terminiert auf 0..."
        r000P=>kn_terminiert = KN_TERMINIERT_NEIN
        aenderungL           = TRUE
    }


    // 7a) Bei Baukastenverschiebung KN_TERM_VERSCHOB setzen
    if (kn_term_verschobL != NULL) {
        log LOG_DEBUG, LOGFILE, "Baukastenverschiebung -> Setzen KN_TERM_VERSCHOB..."
        r000P=>kn_term_verschob = kn_term_verschobL
        aenderungL              = TRUE
    }


    // 7b) Bei Baukastenverschiebung TERMART abhängig vom K_NTERM_VERSCHOB setzen
    //    (Momentan nur "rückwärts" möglich)
    if (rt010_termstr     == cTERMSTR_KRITISCH \
    &&  kn_term_verschobL != NULL) {
        // Beim kritischen Pfad (termstr = 2) bleibt die Termart i.d.R. immer 2 (vgl. cdtTermGlobal_richtung2termart)
        if (rt010_termart != cTERMART_KRITISCH) {
            log LOG_DEBUG, LOGFILE, "Baukastenverschiebung kritischer Pfad -> Setzen TERMART auf 2..."
            r000P=>termart = cTERMART_KRITISCH
            aenderungL     = TRUE
        }
    }
    else {
        // Alle anderen Terminierungsarten (termstr = 0, 1, 3):
        switch (kn_term_verschobL) {
            case KN_TERM_VERSCHOB_ENDE:
                if (rt010_termart != cTERMART_RUECKW) {
                    log LOG_DEBUG, LOGFILE, "Baukastenverschiebung rückwärts -> Setzen TERMART auf 0..."
                    r000P=>termart = cTERMART_RUECKW
                    aenderungL     = TRUE
                }
                break
            case KN_TERM_VERSCHOB_START:    // for future use
                if (rt010_termart != cTERMART_VORW) {
                    log LOG_DEBUG, LOGFILE, "Baukastenverschiebung vorwärts -> Setzen TERMART auf 1..."
                    r000P=>termart = cTERMART_VORW
                    aenderungL     = TRUE
                }
                break
            else:
                break
        }
    }


    // 8) Setzen Systemfixierung setzen, wenn noch nicht geschehen
    if (kn_term_verschobL               != NULL \
    &&  cod_kz_fix_system(rt010_kz_fix) != TRUE ) {
        switch (rt010_kz_fix) {
            case cKZ_FIX_NEIN:
            case NULL:
                log LOG_DEBUG, LOGFILE, "Baukastenverschiebung und keine Fixierung -> Sytemfixierung setzen..."
                r000P=>kz_fix = cKZ_FIX_SYSTEM
                aenderungL    = TRUE
                break
            case cKZ_FIX_USER:
                log LOG_DEBUG, LOGFILE, "Baukastenverschiebung und Userfixierung -> Sytemfixierung setzen..."
                r000P=>kz_fix = cKZ_FIX_BEIDES
                aenderungL    = TRUE
                break
            else:
                break
        }
    }


    // 9) Wenn keine Änderung an r000, dann kein Update
    if (aenderungL == FALSE) {
        log LOG_DEBUG, LOGFILE, "Kein Update auf r000 für fklz >" ## rt010_fklz ## "< da kein Feld geändert wurde..."
        return OK
    }
    log LOG_DEBUG, LOGFILE, "Update auf r000 für fklz >" ## rt010_fklz ## "<..."


    // 10) Änderungshistorie setzen (analog "cdtTermGlobal_set_historie_vor_update_cdbi")
    public rq000.bsl
    rcL = cdtTermGlobal_set_historie_vor_update_cdbi(r000P, TRUE, cAES_UPDATE)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler aus cdtTermGlobal_set_historie_vor_update_cdbi rc=" ## rcL
        return on_error(FAILURE)
    }

    call md_set_modified(r000P, "fi_nr")
    call md_set_modified(r000P, "fklz")

    // 11a) Update r000
    rcL = bu_cdbi_update(r000P, FALSE, FALSE, FALSE)
    switch (rcL) {
        case SQL_OK:
            call md_clear_modified(r000P)
            break
        case SQLE_NO_FIELDS:
            log LOG_DEBUG, LOGFILE, "Keine geänderten Felder für den Update erkannt..."
            return on_error(FAILURE)
        case FAILURE:
            log LOG_DEBUG, LOGFILE, "Fehler bu_cdbi_update"
            return on_error(FAILURE)
        case SQLNOTFOUND:
            // Fertigungsauftrag %s nicht vorhanden
            return on_error(FAILURE, "r0000000", rt010_fklz, rt010_prot)
        case SQLE_ROWLOCKED:
            // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
            return on_error(FAILURE, "r0000002", rt010_fklz, rt010_prot)
        else:
            // Fehler beim Ändern in Tabelle %s
            return on_error(FAILURE, "APPL0004", "r000", rt010_prot)
    }


    // 12) Kein Abstellen Aktionssatz in r115 mit TKZ, da dieser immer vorhanden sein muss
    //     (da Aufruf aus rh110 bzw. rv110)


    // 13) ggf. Änderung r115.mkz
    //     oder:
    //     300304501:
    //     - Bei Storno eine Änderung des aktuellen Funktionscodes des Aktionssatzes auf FU_BEDR=1
    if (rt010_fu_bedr == cFUBEDR_STORNO \
    &&  rt010_menge   == 0.0) {
        rcL = rt010_update_fu_bedr_r115(r000P)
        if (rcL != OK) {
            return FAILURE
        }
    }
    else if (mengenaenderungL == TRUE \
    &&       rt010_mkz        != MKZ_JA) {
        rcL = rt010_update_mkz_r115(r000P)
        if (rcL != OK) {
            return FAILURE
        }
    }


    // 14) Protokollierung in Logfile der Bedarfsrechnung
    public termLogging.bsl
    call termLogging_nettobedarf_rt010(r000P, rt010_fu_bedr, rt010_tkz, endtermin_geaendertL)
    unload termLogging.bsl

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_r000_abs
#
# Satz in Tabelle "r000" ändern nach Absetzen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_update_r000_abs(R000CDBI r000_absP)
{
    int rcL
    cdt menge_abgL = DoubleBU_new()


    menge_abgL=>value = rt010_menge_abg_abs->memo1
    if (menge_abgL=>value == rt010_menge_abg_abs) {
        return OK
    }

    log LOG_DEBUG, LOGFILE, "menge_abg von >" ## rt010_menge_abg_abs->memo1 ## "< auf >" ## rt010_menge_abg_abs ## "< geändert (fklz >" ## rt010_fklz_abs ## "<)"
    if (defined(r000_absP) != TRUE) {
        r000_absP = bu_cdbi_new("r000")
    }
    r000_absP=>fi_nr     = FI_NR1
    r000_absP=>fklz      = rt010_fklz_abs
    r000_absP=>menge_abg = rt010_menge_abg_abs

    // Änderungshistorie setzen
    public rq000.bsl
    rcL = cdtTermGlobal_set_historie_vor_update_cdbi(r000_absP, TRUE, cAES_UPDATE)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler aus cdtTermGlobal_set_historie_vor_update_cdbi rc=" ## rcL
        return on_error(FAILURE)
    }

    if (bu_cdbi_update(r000_absP, FALSE, TRUE, FALSE) != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r000", rt010_prot)
    }
    call md_clear_modified(r000_absP)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_r000_abschl
#
# Satz in Tabelle "r000" ändern nach Abschlußarbeiten
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_update_r000_abschl(rcodeP, R000CDBI r000P)
{
    int      rcL
    boolean  aenderungL = FALSE
    date     terminL


    // CDBI-Instanz erzeugen
    // 300349432 - Performance
    log LOG_DEBUG, LOGFILE, "rt010_fklz >" ## rt010_fklz ## "<"
    if (defined(r000P) != TRUE \
    ||  r000P=>fklz    != rt010_fklz \
    ||  r000P=>fi_nr   != FI_NR1) {
        r000P = bu_cdbi_new("r000")
        r000P=>fi_nr = FI_NR1
        r000P=>fklz  = rt010_fklz
    }
    else {
        call md_clear_modified(r000P)
    }


    if (rt010_fkfs->memo1 != rt010_fkfs) {
        log LOG_DEBUG, LOGFILE, "fkfs von >" ## rt010_fkfs->memo1 ## "< auf >" ## rt010_fkfs ## "< geändert"
        r000P=>fkfs = rt010_fkfs
        aenderungL  = TRUE
    }

    if (rt010_fkfs_a->memo1 != rt010_fkfs_a) {
        log LOG_DEBUG, LOGFILE, "fkfs_a von >" ## rt010_fkfs_a->memo1 ## "< auf >" ## rt010_fkfs_a ## "< geändert"
        r000P=>fkfs_a = rt010_fkfs_a
        aenderungL    = TRUE
    }

    if (rt010_aenddr->memo1 != rt010_aenddr) {
        log LOG_DEBUG, LOGFILE, "aenddr von >" ## rt010_aenddr->memo1 ## "< auf >" ## rt010_aenddr ## "< geändert"
        r000P=>aenddr = rt010_aenddr
        aenderungL    = TRUE
    }

    if (rt010_kostst->memo1 != rt010_kostst) {
        log LOG_DEBUG, LOGFILE, "kostst von >" ## rt010_kostst->memo1 ## "< auf >" ## rt010_kostst ## "< geändert"
        r000P=>kostst = rt010_kostst
        aenderungL    = TRUE
    }

    if (rt010_arbplatz->memo1 != rt010_arbplatz) {
        log LOG_DEBUG, LOGFILE, "arbplatz von >" ## rt010_arbplatz->memo1 ## "< auf >" ## rt010_arbplatz ## "< geändert"
        r000P=>arbplatz = rt010_arbplatz
        aenderungL      = TRUE
    }

    if (rt010_ncprognr->memo1 != rt010_ncprognr) {
        log LOG_DEBUG, LOGFILE, "ncprognr von >" ## rt010_ncprognr->memo1 ## "< auf >" ## rt010_ncprognr ## "< geändert"
        r000P=>ncprognr = rt010_ncprognr
        aenderungL      = TRUE
    }

    if (rt010_fam->memo1 != rt010_fam) {
        log LOG_DEBUG, LOGFILE, "fam von >" ## rt010_fam->memo1 ## "< auf >" ## rt010_fam ## "< geändert"
        r000P=>fam = rt010_fam
        aenderungL = TRUE
    }

    if (rt010_kn_reihenfolge->memo1 != rt010_kn_reihenfolge) {
        log LOG_DEBUG, LOGFILE, "kn_reihenfolge von >" ## rt010_kn_reihenfolge->memo1 ## "< auf >" ## rt010_kn_reihenfolge ## "< geändert"
        r000P=>kn_reihenfolge = rt010_kn_reihenfolge
        aenderungL            = TRUE
    }

    if (rt010_milest_verf->memo1 != rt010_milest_verf) {
        log LOG_DEBUG, LOGFILE, "milest_verf von >" ## rt010_milest_verf->memo1 ## "< auf >" ## rt010_milest_verf ## "< geändert"
        r000P=>milest_verf = rt010_milest_verf
        aenderungL         = TRUE
    }

    if (rt010_stlidentnr->memo1 != rt010_stlidentnr) {
        log LOG_DEBUG, LOGFILE, "stlidentnr von >" ## rt010_stlidentnr->memo1 ## "< auf >" ## rt010_stlidentnr ## "< geändert"
        r000P=>stlidentnr = rt010_stlidentnr
        aenderungL        = TRUE
    }

    if (rt010_stlvar->memo1 != rt010_stlvar) {
        log LOG_DEBUG, LOGFILE, "stlvar von >" ## rt010_stlvar->memo1 ## "< auf >" ## rt010_stlvar ## "< geändert"
        r000P=>stlvar = rt010_stlvar
        aenderungL    = TRUE
    }

    if (rt010_stlnr->memo1 != rt010_stlnr) {
        log LOG_DEBUG, LOGFILE, "stlnr von >" ## rt010_stlnr->memo1 ## "< auf >" ## rt010_stlnr ## "< geändert"
        r000P=>stlnr = rt010_stlnr
        aenderungL   = TRUE
    }

    if (rt010_staltern->memo1 != rt010_staltern) {
        log LOG_DEBUG, LOGFILE, "staltern von >" ## rt010_staltern->memo1 ## "< auf >" ## rt010_staltern ## "< geändert"
        r000P=>staltern = rt010_staltern
        aenderungL      = TRUE
    }

    if (rt010_datvon_stl->memo1 != NULL) {
        terminL = @to_date(rt010_datvon_stl->memo1, DATEFORMAT0)
    }
    if (@date(terminL) != @date(rt010_datvon_stl)) {
        log LOG_DEBUG, LOGFILE, "datvon_stl von >" ## rt010_datvon_stl->memo1 ## "< auf >" ## rt010_datvon_stl ## "< geändert"
        r000P=>datvon_stl = rt010_datvon_stl
        aenderungL        = TRUE
    }

    if (rt010_aendnr_stl->memo1 != rt010_aendnr_stl) {
        log LOG_DEBUG, LOGFILE, "aendnr_stl von >" ## rt010_aendnr_stl->memo1 ## "< auf >" ## rt010_aendnr_stl ## "< geändert"
        r000P=>aendnr_stl = rt010_aendnr_stl
        aenderungL        = TRUE
    }

    if (rt010_dataen_stl->memo1 != NULL) {
        terminL = @to_date(rt010_dataen_stl->memo1, DATEFORMAT1)
    }
    if (@time(terminL) != @time(rt010_dataen_stl)) {
        log LOG_DEBUG, LOGFILE, "dataen_stl von >" ## rt010_dataen_stl->memo1 ## "< auf >" ## rt010_dataen_stl ## "< geändert"
        r000P=>dataen_stl = rt010_dataen_stl
        aenderungL        = TRUE
    }

    if (rt010_txt_stl->memo1 != rt010_txt_stl) {
        log LOG_DEBUG, LOGFILE, "txt_stl von >" ## rt010_txt_stl->memo1 ## "< auf >" ## rt010_txt_stl ## "< geändert"
        r000P=>txt_stl = rt010_txt_stl
        aenderungL     = TRUE
    }

    if (rt010_aplidentnr->memo1 != rt010_aplidentnr) {
        log LOG_DEBUG, LOGFILE, "aplidentnr von >" ## rt010_aplidentnr->memo1 ## "< auf >" ## rt010_aplidentnr ## "< geändert"
        r000P=>aplidentnr = rt010_aplidentnr
        aenderungL        = TRUE
    }

    if (rt010_aplvar->memo1 != rt010_aplvar) {
        log LOG_DEBUG, LOGFILE, "aplvar von >" ## rt010_aplvar->memo1 ## "< auf >" ## rt010_aplvar ## "< geändert"
        r000P=>aplvar = rt010_aplvar
        aenderungL    = TRUE
    }

    if (rt010_aplnr->memo1 != rt010_aplnr) {
        log LOG_DEBUG, LOGFILE, "aplnr von >" ## rt010_aplnr->memo1 ## "< auf >" ## rt010_aplnr ## "< geändert"
        r000P=>aplnr = rt010_aplnr
        aenderungL   = TRUE
    }

    if (rt010_agaltern->memo1 != rt010_agaltern) {
        log LOG_DEBUG, LOGFILE, "agaltern von >" ## rt010_agaltern->memo1 ## "< auf >" ## rt010_agaltern ## "< geändert"
        r000P=>agaltern = rt010_agaltern
        aenderungL      = TRUE
    }

    if (rt010_datvon_apl->memo1 != NULL) {
        terminL = @to_date(rt010_datvon_apl->memo1, DATEFORMAT0)
    }
    if (@date(terminL) != @date(rt010_datvon_apl)) {
        log LOG_DEBUG, LOGFILE, "datvon_apl von >" ## rt010_datvon_apl->memo1 ## "< auf >" ## rt010_datvon_apl ## "< geändert"
        r000P=>datvon_apl = rt010_datvon_apl
        aenderungL        = TRUE
    }

    if (rt010_aendnr_apl->memo1 != rt010_aendnr_apl) {
        log LOG_DEBUG, LOGFILE, "aendnr_apl von >" ## rt010_aendnr_apl->memo1 ## "< auf >" ## rt010_aendnr_apl ## "< geändert"
        r000P=>aendnr_apl = rt010_aendnr_apl
        aenderungL        = TRUE
    }

    if (rt010_dataen_apl->memo1 != NULL) {
        terminL = @to_date(rt010_dataen_apl->memo1, DATEFORMAT0)
    }
    if (@time(terminL) != @time(rt010_dataen_apl)) {
        log LOG_DEBUG, LOGFILE, "dataen_apl von >" ## rt010_dataen_apl->memo1 ## "< auf >" ## rt010_dataen_apl ## "< geändert"
        r000P=>dataen_apl = rt010_dataen_apl
        aenderungL        = TRUE
    }

    if (rt010_txt_apl->memo1 != rt010_txt_apl) {
        log LOG_DEBUG, LOGFILE, "txt_apl von >" ## rt010_txt_apl->memo1 ## "< auf >" ## rt010_txt_apl ## "< geändert"
        r000P=>txt_apl = rt010_txt_apl
        aenderungL     = TRUE
    }

    // Wenn keine Änderung an r000, dann kein Update
    if (aenderungL == FALSE) {
        log LOG_DEBUG, LOGFILE, "Kein Update auf r000 für fklz >" ## rt010_fklz ## "< da kein Feld geändert wurde..."
        return OK
    }
    log LOG_DEBUG, LOGFILE, "Update auf r000 für fklz >" ## rt010_fklz ## "<..."


    // Änderungshistorie setzen
    public rq000.bsl
    rcL = cdtTermGlobal_set_historie_vor_update_cdbi(r000P, TRUE, cAES_UPDATE)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler aus cdtTermGlobal_set_historie_vor_update_cdbi rc=" ## rcL
        return on_error(FAILURE)
    }

    // Todo FV@OB/JK: BU_1 wird hier niemals geliefert, was tun? Storno (fkfs 9) wäre BU_0...
    // Bei Storno das kn_terminiert und kn_term_verschoben zurücksetzen
    if (rcodeP == BU_1) {
        r000P=>kn_terminiert    = KN_TERMINIERT_NEIN
        r000P=>kn_term_verschob = KN_TERM_VERSCHOB_NEIN
    }

    call md_set_modified(r000P, "fi_nr")
    call md_set_modified(r000P, "fklz")

    rcL = bu_cdbi_update(r000P, FALSE, TRUE, FALSE)
    if (rcL != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r000", rt010_prot)
    }
    call md_clear_modified(r000P)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_delete_r039
#
# Löschen der Referenzsätze
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_delete_r039()
{
    dbms sql delete from r039 \
                   where r039.fi_nr = :+FI_NR1 and \
                     r039.fklz  = :+rt010_fklz

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Löschen in Tabelle %s.
        return on_error(FAILURE, "APPL0005", "r039", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_get_r100_uebg
#
# Lesen und Sperren übergeordnetes Material
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_get_r100_uebg()
{
    vars lock

    rt010_uebzt_sek_uebg = NULL

    if !(dm_is_cursor("rt010_lock_r100")) {
        dbms declare rt010_lock_r100 cursor for select \
                    r100.fklz, \
                    r100.aufnr, \
                    r100.aufpos, \
                    r100.ufklz, \
                    r100.fmfs, \
                    r100.fmfs_a, \
                    r100.menge, \
                    r100.menge_abg, \
                    r100.menge_abg, \
                    r100.menge_agl, \
                    r100.menge_ent, \
                    r100.sbterm, \
                    r100.fsterm_w, \
                    r100.seterm_w, \
                    r100.pos_herk, \
                    r100.uebzt_sek \
             from   r100 :MSSQL_FOR_UPDATE \
             where  r100.fi_nr  = ::FI_NR1 and \
                r100.fmlz   = ::fmlz \
             :FOR_UPDATE

        dbms with cursor rt010_lock_r100 alias \
                                          rt010_fklz_uebg, \
                                          rt010_aufnr_uebg, \
                                          rt010_aufpos_uebg, \
                                          rt010_ufklz_uebg, \
                                          rt010_fmfs_uebg, \
                                          rt010_fmfs_a_uebg, \
                                          rt010_menge_uebg, \
                                          rt010_menge_abg_uebg, \
                                          rt010_menge_abg_alt, \
                                          rt010_menge_agl_uebg, \
                                          rt010_menge_ent_uebg, \
                                          rt010_sbterm_uebg, \
                                          rt010_fsterm_w_uebg, \
                                          rt010_seterm_w_uebg, \
                                          rt010_pos_herk_uebg, \
                                          rt010_uebzt_sek_uebg
    }

    lock = TRUE
    while (lock == TRUE) {
        dbms with cursor rt010_lock_r100 execute using FI_NR1, rt010_fmlz_uebg
        if (SQL_CODE == SQLNOTFOUND) {
            // Fertigungsmaterial %s nicht vorhanden
            return on_error(FAILURE, "r1000000", rt010_fklz_uebg, rt010_prot)
        }
        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsmaterial %s von einem anderen Benutzer gesperrt
            call bu_msg("r1000002", rt010_fklz_uebg)
            next
        }
        if (SQL_CODE != SQL_OK) {
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r100", rt010_prot)
        }
        lock = FALSE
    }

    // Gelesene Werte merken
    rt010_ufklz_uebg->memo1     = rt010_ufklz_uebg
    rt010_menge_abg_uebg->memo1 = rt010_menge_abg_uebg
    rt010_fmfs_uebg->memo1      = rt010_fmfs_uebg
    rt010_fmfs_a_uebg->memo1    = rt010_fmfs_a_uebg

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_r100_uebg
#
# übergeordnetes Material updaten nach Verteilen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_update_r100_uebg(R100CDBI r100P)
{
    int      rcL
    boolean  aenderungL = FALSE
    double   mengeL


    // 1) Update übergeordnetes Material:
    log LOG_DEBUG, LOGFILE, "rt010_fmlz_uebg >" ## rt010_fmlz_uebg ## "<"
    if (defined(r100P) != TRUE) {
        r100P = bu_cdbi_new("r100")
    }
    call md_clear_modified(r100P)
    r100P=>fi_nr     = FI_NR1
    r100P=>fmlz      = rt010_fmlz_uebg

    if (rt010_ufklz_uebg->memo1 != rt010_ufklz_uebg) {
        log LOG_DEBUG, LOGFILE, "ufklz_uebg von >" ## rt010_ufklz_uebg->memo1 ## "< auf >" ## rt010_ufklz_uebg ## "< geändert"
        r100P=>ufklz = rt010_ufklz_uebg
        aenderungL   = TRUE
    }

    mengeL = rt010_menge_abg_uebg->memo1 + 0
    if (mengeL != rt010_menge_abg_uebg) {
        log LOG_DEBUG, LOGFILE, "menge_abg_uebg von >" ## rt010_menge_abg_uebg->memo1 ## "< auf >" ## rt010_menge_abg_uebg ## "< geändert"
        r100P=>menge_abg = rt010_menge_abg_uebg
        aenderungL       = TRUE
    }

    if (rt010_fmfs_uebg->memo1 != rt010_fmfs_uebg) {
        log LOG_DEBUG, LOGFILE, "fmfs_uebg von >" ## rt010_fmfs_uebg->memo1 ## "< auf >" ## rt010_fmfs_uebg ## "< geändert"
        r100P=>fmfs  = rt010_fmfs_uebg
        aenderungL   = TRUE
    }

    if (rt010_fmfs_a_uebg->memo1 != rt010_fmfs_a_uebg) {
        log LOG_DEBUG, LOGFILE, "fmfs_a_uebg von >" ## rt010_fmfs_a_uebg->memo1 ## "< auf >" ## rt010_fmfs_a_uebg ## "< geändert"
        r100P=>fmfs_a = rt010_fmfs_a_uebg
        aenderungL    = TRUE
    }


    if (aenderungL == TRUE) {
        // Änderungshistorie setzen
        public rq100.bsl
        rcL = cdtTermGlobal_set_historie_vor_update_cdbi(r100P, TRUE, cAES_UPDATE)
        if (rcL != OK) {
            log LOG_DEBUG, LOGFILE, "Fehler aus cdtTermGlobal_set_historie_vor_update_cdbi rc=" ## rcL
            return on_error(FAILURE)
        }

        call md_set_modified(r100P, "fi_nr")
        call md_set_modified(r100P, "fmlz")

        rcL = bu_cdbi_update(r100P, FALSE, FALSE, FALSE)
        if (rcL != SQL_OK) {
            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "r100", rt010_prot)
        }
    }
    else {
        log LOG_DEBUG, LOGFILE, "Kein Update auf r100 für fmlz >" ## rt010_fmlz_uebg ## "< da kein Feld geändert wurde..."
    }


    // 2) Wertefluss
    log LOG_DEBUG, LOGFILE,"2 * rt010_fu_bedr >:rt010_fu_bedr< * rt010_menge >:rt010_menge< * rt010_ufklz_uebg >:rt010_ufklz_uebg<"
    log LOG_DEBUG, LOGFILE,"3 * rt010_menge_verteilbar >:rt010_menge_verteilbar<"

    if (rt010_fu_bedr == cFUBEDR_STORNO && rt010_menge == 0 || \
        rt010_ufklz_uebg == NULL) {
        rcL = rt010_set_cm130("1")
        if (rcL != OK) {
            return FAILURE
        }
    }
    else if (rt010_menge_verteilbar > 0) {
        rt010_disstufe_uebg = rt010_disstufe

        rcL = rt010_set_cm130("3")
        if (rcL != OK) {
            return FAILURE
        }
    }


    // 3) Verknüpfungen
    if (R_VKN >= "0") {
        public rq1004.bsl

        vars verknuepfungDiffL = new verknuepfungDiffRq1004()

        verknuepfungDiffL=>fi_nr = FI_NR1
        verknuepfungDiffL=>fmlz = rt010_fmlz_uebg
        // rt010_ufklz_uebg ist NULL, wenn der Satz gelöscht wird
        verknuepfungDiffL=>fklz = rt010_fklz
        verknuepfungDiffL=>bestnr = ""
        verknuepfungDiffL=>bestpos = 0
        verknuepfungDiffL=>lfdnr_eintl = 0
        verknuepfungDiffL=>kn_beddecker = KN_BEDDECKER_AUFTRAGSBEZUG
        verknuepfungDiffL=>menge_diff = -rt010_menge_abg_uebg
        rcL = verknuepfungRq1004Setzen(verknuepfungDiffL)
        if ( \
            rcL  < OK && \
            rcL != -5 && \
            rcL != -3 \
        ) {
             // Fehler beim Einfügen in Tabelle >%s<.
             return on_error(FAILURE, "APPL0003", "r1004", rt010_prot)
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_sel_g000
#
# Lesen Teilestammdaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sel_g000()
{
    if !(dm_is_cursor("rt010_read_g000")) {
        dbms declare rt010_read_g000 cursor for \
             select  g040.ts, \
                     g023.kzstl, \
                     g023.kzapl, \
                     g000.kn_variant, \
                     g040.datloe, \
                     g023.ts_w, \
                     g043.ts_m, \
                     g043.einkaeufer, \
                     g020.dispn \
               from  g040, g000, g043, g023, g020 \
              where  g040.fi_nr    = ::FI_G000 and \
                 g040.identnr  = ::identnr and \
                 g040.var      = ::var and \
                 g043.fi_nr    = ::FI_NR1 and \
                 g043.identnr  = g040.identnr and \
                 g043.var      = g040.var and \
                 g000.fi_nr    = g040.fi_nr and \
                 g000.identnr  = g040.identnr and \
                 g023.fi_nr    = g043.fi_nr and \
                 g023.werk     = ::werk and \
                 g023.identnr  = g043.identnr and \
                 g023.var      = g043.var and \
                 g020.fi_nr    = g023.fi_nr and \
                 g020.werk     = g023.werk and \
                 g020.identnr  = g023.identnr and \
                 g020.var      = g023.var and \
                 g020.lgnr     = ::lgnr


        dbms with cursor rt010_read_g000 alias \
                    rt010_ts, \
                    rt010_kzstl, \
                    rt010_kzapl, \
                    rt010_kn_variant, \
                    rt010_datloe, \
                    rt010_ts_w, \
                    rt010_ts_m, \
                    rt010_einkaeufer, \
                    rt010_dispn
    }

    dbms with cursor rt010_read_g000 execute using FI_G000, rt010_identnr, rt010_var, FI_NR1, rt010_werk, rt010_lgnr

    // Wenn das Teil jetzt nicht gefunden wird, dann kann es nur
    // noch daran liegen, dass kein Lagersatz vorhanden ist.

    if (SQL_CODE == SQLNOTFOUND) {
        // Prüfen, ob Teilestamm vorhanden und gültig für Firma / Standort
        if (Cidentnr_varPi(rt010_identnr, rt010_var, NULL, rt010_werk, TRUE) != OK) {
            return on_error(WARNING, NULL, NULL, rt010_prot)
        }

        // Teilestamm Lager %s nicht vorhanden
        return on_error(WARNING, "g0200010", rt010_identnr, rt010_prot)
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "g000", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_g020
#
# Korrigieren Bestellbestand
# - der Bestellbestand muß um die abgesetzte Menge vermindert werden
# - bei simulaativem Auftrag simulativer Bestellbestand
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_update_g020()
{
    vars sim

    // bei simulativem Auftrag simulativen Bestellbestand verändern
    if (rt010_fkfs == FSTATUS_SIM) {
        sim = TRUE //sim = "_sim"
    }
    else {
        sim = FALSE //sim = NULL
    }

    //  bestell:(sim) = bestell:(sim) - ( :+rt010_menge_abgesetzt )

    call rt010_bundle_lt110()
    if (lt110_rvb_fortschreiben(rt010_lt110_handle, sim) < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Summen der übergeordneten Bedarfssätze zu einem FA ermitteln.
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_sel_sum_uebg(p_fklz)
{
    string dummyL


    if (dm_is_cursor("rt010_sum_uebg") != TRUE) {
        dbms declare rt010_sum_uebg cursor for \
            select \
                r100.ufklz, \
                sum(r100.menge - r100.menge_abg - r100.menge_agl), \
                sum(r100.menge_ent), \
                sum(r100.menge_res) \
            from \
                r100 \
            where \
                r100.fi_nr    = ::_1 and \
                r100.ufklz    = ::_2 and \
                r100.identnr  = ::_3 and \
                r100.var      = ::_4 and \
                r100.pos_herk <> '3' \
            group by \
                r100.ufklz \
            union all \
            select \
                r100.ufklz, \
                sum(r100.menge - r100.menge_abg), \
                sum(0), \
                sum(0) \
            from \
                r100 \
            where \
                r100.fi_nr    = ::_5 and \
                r100.ufklz    = ::_6 and \
                r100.identnr  = ::_7 and \
                r100.var      = ::_8 and \
                r100.pos_herk = '3' \
            group by \
                r100.ufklz
        dbms with cursor rt010_sum_uebg alias \
            dummyL, \
            rt010_sum_bed_uebg, \
            rt010_sum_ent_uebg,\
            rt010_sum_res_uebg
    }
    dbms with cursor rt010_sum_uebg execute using \
        FI_NR1, \
        p_fklz, \
        rt010_identnr, \
        rt010_var, \
        FI_NR1, \
        p_fklz, \
        rt010_identnr, \
        rt010_var

    if (rt010_sum_bed_uebg == "") {
        rt010_sum_bed_uebg = 0
        rt010_sum_ent_uebg = 0
        rt010_sum_res_uebg = 0
    }

    if (SQL_CODE == SQLNOTFOUND) {
        rt010_sum_bed_uebg = 0
        rt010_sum_ent_uebg = 0
        rt010_sum_res_uebg = 0
        return OK
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r100", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_sel_v110
#
# Lesen Kundenauftragsposition für auftragsbezogene Stammdaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sel_v110()
{

    if !(dm_is_cursor("rt010_read_v110")) {
        dbms declare rt010_read_v110 cursor for \
             select  v110.aufnr, \
                     v110.aufpos, \
                     v110.kn_freigabe \
               from  v110 \
              where  v110.aufnr    = ::aufnr and \
                 v110.vvorgart = :+cVVORGART_AUFTRAG and \
                 v110.aufpos   = ::aufpos and \
                 v110.seblpos  = 0

        dbms with cursor rt010_read_v110 alias rt010_aufnr_v110, \
                                               rt010_aufpos_v110, \
                                               rt010_kn_freigabe_v110
    }
    dbms with cursor rt010_read_v110 execute using rt010_aufnr, \
                                                   rt010_aufpos

    if (SQL_CODE == SQLNOTFOUND) {
        return OK
    }
    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "v110", rt010_prot)
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_sel_f010
#
# Lesen Referenztabelle für auftragsbezogene Stammdaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_sel_f010()
{

    if !(dm_is_cursor("rt010_read_f010")) {
        dbms declare rt010_read_f010 cursor for \
             select  f010.identnr, \
                     f010.var, \
                     f010.aufst_apl, \
                     f010.aufst_stl, \
                     f010.aufst_emstufig, \
                     f010.kn_gen_stl, \
                     f010.kn_gen_apl, \
                     f010.stlstat, \
                     f010.aplstat \
               from  f010 \
              where  f010.fi_nr      = ::FI_NR1 and \
                 f010.aufnr      = ::aufnr and \
                 f010.aufpos     = ::aufpos and \
                 f010.art        = :+cSTDART_AUFTRAG and \
                 f010.altern     = ::altern

        dbms with cursor rt010_read_f010 alias rt010_aufst_identnr, \
                                               rt010_aufst_var, \
                                               rt010_aufst_apl, \
                                               rt010_aufst_stl, \
                                               rt010_aufst_emstufig, \
                                               rt010_aufst_kn_gen_stl, \
                                               rt010_aufst_kn_gen_apl, \
                                               rt010_aufst_stlstat, \
                                               rt010_aufst_aplstat
    }
    dbms with cursor rt010_read_f010 execute using FI_NR1, \
                                                  rt010_aufnr, \
                                                  rt010_aufpos, \
                                                  rt010_altern

    if (SQL_CODE == SQLNOTFOUND) {
        return OK
    }
    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "f010", rt010_prot)
    }

    return OK
}

# prüfen, ob Stückliste vorhanden
#-----------------------------------------------------------------------------------------------------------------------
boolean proc rt010_check_stl()
{
    int vorhandenL = 0

    if (rt010_stlnr > 0) {
        if (dm_is_cursor("rt010_chk_f100") != TRUE) {
            dbms declare rt010_chk_f100 cursor for \
                 select  count(*) \
                   from  f100 \
                  where  f100.fi_nr = ::_1 and \
                         f100.stlnr = ::_2

            dbms with cursor rt010_chk_f100 alias \
                vorhandenL
        }

        dbms with cursor rt010_chk_f100 execute using \
            FI_F100, \
            rt010_stlnr

        switch (SQL_CODE) {
            case SQL_OK:
                break
            case SQLNOTFOUND:
            else:
                vorhandenL = 0
                break
        }
    }

    return (vorhandenL > 0)
}

# Lesen Stücklistenkopfdaten
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_sel_f100()
{
    if (dm_is_cursor("rt010_read_f100") != TRUE) {
        dbms declare rt010_read_f100 cursor for \
             select  f100.stlidentnr, \
                     f100.stlvar, \
                     f100.altern, \
                     f100.datvon, \
                     f100.stlstat, \
                     f100.txt, \
                     f100.dataen, \
                     f100.aendnr \
               from  f100 \
              where  f100.fi_nr = ::_1 and \
                     f100.stlnr = ::_2

        dbms with cursor rt010_read_f100 alias \
            rt010_stlidentnr_f100, \
            rt010_stlvar_f100, \
            rt010_altern_f100, \
            rt010_datvon_f100, \
            rt010_stlstat_f100, \
            rt010_txt_f100, \
            rt010_dataen_f100, \
            rt010_aendnr_f100
    }

    dbms with cursor rt010_read_f100 execute using \
        FI_F100, \
        rt010_stlnr

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "f100", rt010_prot)
    }

    return OK
}

# prüfen, ob Arbeitsplan vorhanden
#-----------------------------------------------------------------------------------------------------------------------
boolean proc rt010_check_apl()
{
    int vorhandenL = 0


    if (rt010_aplnr > 0) {
        if (dm_is_cursor("rt010_chk_f200") != TRUE) {
            dbms declare rt010_chk_f200 cursor for \
                 select  count(*) \
                   from  f200 \
                  where  f200.fi_nr = ::_1 and \
                         f200.aplnr = ::_2

            dbms with cursor rt010_chk_f200 alias \
                vorhandenL
        }

        dbms with cursor rt010_chk_f200 execute using \
            FI_F200, \
            rt010_aplnr

        switch (SQL_CODE) {
            case SQL_OK:
                break
            case SQLNOTFOUND:
            else:
                vorhandenL = 0
                break
        }
    }

    return (vorhandenL > 0)
}

# Lesen Arbeitsplankopfdaten
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_sel_f200()
{
    if (dm_is_cursor("rt010_read_f200") != TRUE) {
        dbms declare rt010_read_f200 cursor for \
             select  f200.aplidentnr, \
                     f200.aplvar, \
                     f200.altern, \
                     f200.datvon, \
                     f200.menge_ab, \
                     f200.kostst, \
                     f200.arbplatz, \
                     f200.ncprognr, \
                     f200.fam, \
                     f200.kn_reihenfolge, \
                     f200.milest_verf, \
                     f200.aplstat, \
                     f200.txt, \
                     f200.dataen, \
                     f200.aendnr \
               from  f200 \
              where  f200.fi_nr  = ::_1 and \
                 f200.aplnr      = ::_2

        dbms with cursor rt010_read_f200 alias \
            rt010_aplidentnr_f200, \
            rt010_aplvar_f200, \
            rt010_altern_f200, \
            rt010_datvon_f200, \
            rt010_menge_ab_f200, \
            rt010_kostst_f200, \
            rt010_arbplatz_f200, \
            rt010_ncprognr_f200, \
            rt010_fam_f200, \
            rt010_kn_reihenfolge_f200, \
            rt010_milest_verf_f200, \
            rt010_aplstat_f200, \
            rt010_txt_f200, \
            rt010_dataen_f200, \
            rt010_aendnr_f200
    }

    dbms with cursor rt010_read_f200 execute using \
        FI_F200, \
        rt010_aplnr

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "f200", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_insert_r025
#
# Satz für Fertigungsauftrag in die Aktionstabelle r025 abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_insert_r025()
{
    call bu_noerr()

    dbms sql insert into r025 ( \
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
            :+rt010_werk, \
            :+rt010_fklz, \
            :+rt010_freigabe, \
            :+rt010_aufnr, \
            :+rt010_aufpos, \
            '4', \
            :+rt010_R_MATPR, \
            :+LOGNAME, \
            0, \
            0, \
            :+NULL, \
            :+NULL \
          )

    if (SQL_CODE == SQLE_DUPKEY) {
        return WARNING
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r025", rt010_prot)
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_r025
#
# Satz in Tabelle r025 updaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_update_r025()
{
    vars lock(1)

    lock = TRUE
    while (lock == TRUE) {
        dbms sql update r025 set \
                fu_freig = '4', \
                fu_matpr = :+rt010_R_MATPR, \
                logname  = :+LOGNAME, \
                kz_matpr = '0' \
              where r025.fi_nr  = :+FI_NR1 and \
                r025.fklz   = :+rt010_fklz and \
                r025.jobid <= 0

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Aktion Auftragsfreigabe %s von einem anderen Benutzer gesperrt
            call bu_msg("r0250002", rt010_fklz)
            next
        }

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "r025", rt010_prot)
        }

        lock = FALSE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_insert_r725
#
# Satz für Fertigungsauftrag in die Aktionstabelle r025 abstellen
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_insert_r725()
{
    vars kzdruckL

    if (R_DR_VERS_Rt010 == NULL) {
        kzdruckL = "1"
    }
    else {
        kzdruckL = R_DR_VERS_Rt010
    }

    call bu_noerr()

    dbms sql insert into r725 \
                      (fi_nr, \
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
                       kn_dr_ls) \
                   values \
                      (:+FI_NR1, \
                       :+rt010_werk, \
                       :+rt010_lgnr, \
                       0, \
                       :+LOGNAME, \
                       :CURRENT, \
                       :+NULL, \
                       :+rt010_fklz, \
                       '4', \
                       :+kzdruckL, \
                       :+rt010_aufnr, \
                       :+rt010_aufpos, \
                       '0', \
                       '0')

    if (SQL_CODE == SQLE_DUPKEY) {
        // Satz %s bereits vorhanden.
        return on_error(FAILURE, "APPL0001", "", rt010_prot)
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r725", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_update_r725
#
# Satz in Tabelle r025 updaten
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_update_r725()
{
    vars lock

    lock = TRUE
    while (lock == TRUE) {
        dbms sql update r725 set \
                        r725.fu_freig = '4', \
                        r725.logname  = :+LOGNAME \
                  where r725.fi_nr = :+FI_NR1 and \
                    r725.fklz  = :+rt010_fklz and \
                    r725.jobid <= 0

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "r725", rt010_prot)
        }

        lock = FALSE
    }

    return OK
}


#-----------------------------------------------------------------------------------------------------------------------
# rt010_proto
#
# Satz für Fertigungsauftrag in die Protokolltabelle r016 abstellen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_proto(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    int jobidL

    if (rt010_werk == NULL) {
        rt010_werk = 0
    }

    if (rt010_fsterm == NULL) {
        rt010_fsterm = BU_DATE0
    }
    if (rt010_fsterm_uhr == NULL) {
        rt010_fsterm_uhr = BU_DATE0
    }

    if (rt010_fsterm_w == NULL) {
        rt010_fsterm_w = BU_DATE0
    }
    if (rt010_fsterm_w_uhr == NULL) {
        rt010_fsterm_w_uhr = BU_DATE0
    }

    if (rt010_seterm == NULL) {
        rt010_seterm = BU_DATE0
    }
    if (rt010_seterm_uhr == NULL) {
        rt010_seterm_uhr = BU_DATE0
    }

    if (rt010_seterm_w == NULL) {
        rt010_seterm_w = BU_DATE0
    }
    if (rt010_seterm_w_uhr == NULL) {
        rt010_seterm_w_uhr = BU_DATE0
    }

    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r016")

    jobidL = JOBID + 0

    log LOG_DEBUG, LOGFILE, "r016.fklz >" ## rt010_fklz ## "<"

    dbms sql insert into r016 ( \
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
             fklz, \
             aufnr, \
             aufpos, \
             identnr, \
             var, \
             lgnr, \
             aart, \
             fkfs, \
             fsterm, \
             fsterm_uhr, \
             fortsetz_dat, \
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
             fu_bedr, \
             mkz, \
             tkz, \
             kn_aend_fa \
          ) values ( \
             :CURRENT, \
             :+FI_NR1, \
             :+rt010_werk, \
             :+LOGNAME, \
             :+TTY, \
             :+screen_name, \
             :+msg_nr, \
             :+msg_typ, \
             :+msg_text, \
             :+prt_ctrl, \
             :+jobidL, \
             :+rt010_fklz, \
             :+rt010_aufnr, \
             :+rt010_aufpos, \
             :+rt010_identnr, \
             :+rt010_var, \
             :+rt010_lgnr, \
             :+rt010_aart, \
             :+rt010_fkfs, \
             :+rt010_fsterm, \
             :+rt010_fsterm_uhr, \
             :+rt010_fortsetz_dat, \
             :+rt010_fortsetz_uhr, \
             :+rt010_seterm, \
             :+rt010_seterm_uhr, \
             :+rt010_fsterm_w, \
             :+rt010_fsterm_w_uhr, \
             :+rt010_seterm_w, \
             :+rt010_seterm_w_uhr, \
             :+rt010_menge, \
             :+rt010_termstr, \
             :+rt010_termart, \
             :+rt010_fu_bedr, \
             :+rt010_mkz, \
             :+rt010_tkz, \
             :+rt010_kn_aend_fa \
          )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r016", NULL)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_receive_rt010(string fu_bedrP)
{
    receive bundle "b_rt010" data \
        rt010_fklz, \
        rt010_fu_bedr, \
        rt010_mkz, \
        rt010_tkz, \
        rt010_werk, \
        rt010_konflikt, \
        rt010_kn_aend_fa


    if (defined(fu_bedrP) != TRUE \
    ||  fu_bedrP           == "") {
        fu_bedrP = rt010_fu_bedr
    }


    if (cod_kn_aend_fa_gefuellt(rt010_kn_aend_fa) != TRUE) {
        public cdtTermGlobal.bsl
        rt010_kn_aend_fa = cdtTermGlobal_ermitteln_kn_aend_fa_default(boa_cdt_get(name_cdtTermGlobal_rt010), fu_bedrP)
        unload cdtTermGlobal.bsl
    }

    // Merker, ob Bedarfsrechnung teilweise durchgeführt werden soll.
    rt010_lo_teil = BEDR_AUFL_STATUS_BEIDES

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_send_rt010
#
# Bundle von "rt010" senden
# - gesendet werden alle Felder, die in "rt010" verändert werden
#   können
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_send_rt010()
{
    send bundle "b_rt010_s" data \
                    rt010_fu_bedr, \
                    rt010_mkz, \
                    rt010_tkz, \
                    rt010_konflikt, \
                    rt010_aufnr, \
                    rt010_aufpos, \
                    rt010_fkfs, \
                    rt010_fkfs_a, \
                    rt010_menge, \
                    rt010_menge_abg, \
                    rt010_menge_aus, \
                    rt010_menge_offen, \
                    rt010_fsterm, \
                    rt010_seterm, \
                    rt010_fsterm_w, \
                    rt010_seterm_w, \
                    rt010_dlzeit, \
                    rt010_vzzeit, \
                    rt010_termart, \
                    rt010_stlidentnr, \
                    rt010_stlvar, \
                    rt010_stlnr, \
                    rt010_datvon_stl, \
                    rt010_aplidentnr, \
                    rt010_aplvar, \
                    rt010_aplnr, \
                    rt010_datvon_apl, \
                    rt010_kz_fix, \
                    rt010_kn_aend_fa

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_send_dt510
#
# Senden des Bundles "b_dt510"
#-----------------------------------------------------------------------------------------------------------------------

int proc rt010_send_dt510()
{
    send    bundle   "b_dt510" data \
              rt010_identnr, \
                      rt010_var, \
                      rt010_werk, \
                      rt010_lgnr, \
                      NULL
}

#-----------------------------------------------------------------------------------------------------------------------
# proc rt010_bundle_lt110()
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_bundle_lt110()
{
    rt010_menge_abgesetzt = (-1) * rt010_menge_abgesetzt

    send bundle "b_lt110" data rt010_identnr, \
                               rt010_var, \
                               FALSE, \
                               rt010_werk, \
                               rt010_lgnr, \
                               rt010_menge_abgesetzt, \
                               NULL

    rt010_menge_abgesetzt = (-1) * rt010_menge_abgesetzt
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_proto_kb(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    if (rt010_proto(rcP, prt_ctrlP, msg_nrP, msg_zusatzP) != OK) {
        return FAILURE
    }

    if (rt010_kanbannr != NULL) {
        if (rt010_proto_d816(rcP) != OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_proto_d816(rcP)
{
    vars lo_rt010_fmlz

    if (cod_aart_versorg(rt010_aart) == TRUE) {
        dbms alias lo_rt010_fmlz
        dbms sql select r100.fmlz \
                   from r100 \
                  where r100.fi_nr = :+FI_NR1 and \
                    r100.fklz  = :+rt010_fklz
        dbms alias
    }
    else {
        lo_rt010_fmlz = NULL
    }
    dbms alias rt010_dispn
    dbms sql select g020.dispn \
               from g020 \
              where g020.fi_nr   = :+FI_NR1 and \
                g020.werk    = :+rt010_werk and \
                g020.lgnr    = :+rt010_lgnr and \
                g020.identnr = :+rt010_identnr and \
                g020.var     = :+rt010_var
    dbms alias

    if (rt010_kanbananfnr == NULL) {
        rt010_kanbananfnr = 0
    }
    if (rt010_aufpos == NULL) {
        rt010_aufpos = 0
    }

    call bu_noerr()

    dbms sql insert into d816 \
                (fi_nr, \
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
                 vorschlnr) \
             values \
                (:+FI_NR1, \
                 :CURRENT, \
                 :+rt010_werk, \
                 0, \
                 :+LOGNAME, \
                 :+rt010_kanbananfnr, \
                 :+rt010_kanbannr, \
                 :+rt010_kostst, \
                 :+rt010_identnr, \
                 :+rt010_var, \
                 :+rt010_lgnr, \
                 :+rt010_lgber, \
                 :+rt010_lgfach, \
                 :+BU_DATE0, \
                 :+BU_DATE0, \
                 :+BU_DATE0, \
                 '0', \
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
                 :+rt010_einkaeufer, \
                 :+rt010_dispn, \
                 :+rt010_fklz, \
                 :+lo_rt010_fmlz, \
                 :+NULL, \
                 0, \
                 :+rt010_aufnr, \
                 :+rt010_aufpos, \
                 0)

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "d816", NULL)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_merkmale_delete
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_merkmale_delete()
{
    int rcL

    if (G_MERKMAL == "0") {
        return OK
    }

    /* Löschen Merkmale bei aes=1 oder bei aes=3, wenn sich die identnr geändert hat. */

    /* Objektid lesen */
    if !dm_is_cursor("rt010_objektid") {
        dbms declare rt010_objektid cursor for \
             select r000.objektid \
             from r000 \
             where r000.fi_nr   = ::fi_nr and \
               r000.fklz    = ::fklz
        dbms with cursor rt010_objektid alias rt010_objektid
    }

    dbms with cursor rt010_objektid execute using FI_NR1, rt010_fklz

    if (rt010_objektid == NULL) {
        return OK
    }

    rt010_gm790_handle = bu_load_modul("gm790", rt010_gm790_handle, NULL)
    if (rt010_gm790_handle <= 0) {
        return on_error(FAILURE)
    }

    call gm790_activate(rt010_gm790_handle)
    call gm790_init()
    fklzGm790EA     = rt010_fklz    // @bsldoc.ignore
    fi_nrGm790EA    = FI_NR1        // @bsldoc.ignore

    rcL = gm790_loeschen_fklz()
    if (rcL < OK) {
        call bu_msg_errmsg("Gm790", NULL)
        call gm790_deactivate(rt010_gm790_handle)
        return on_error(FAILURE)
    }
    else if (rcL > OK) {
        call bu_msg_errmsg("Gm790", NULL)
        call rt010_proto(rcL, $NULL, $NULL, $NULL)
    }
    rt010_objektid = NULL
    call gm790_deactivate(rt010_gm790_handle)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_set_cm130(aesStrukturP)
{
    int rcL

    log LOG_DEBUG, LOGFILE,\
        "aesStrukturP >" ## aesStrukturP ## "< " ## \
        "C_KTR_AKTIV >" ## C_KTR_AKTIV ## "< " ## \
        "rt010_aart >" ## rt010_aart ## "<"

    if (C_KTR_AKTIV != "1" || \
        (cod_aart_nosek(rt010_aart) && aesStrukturP == "1") || \
        (rt010_disstufe == NULL && aesStrukturP == "1")) {
        return OK
    }

    rt010_cm130 = bu_load_modul("cm130", rt010_cm130)
    call bu_assert(rt010_cm130 >= 0)
    call cm130_activate(rt010_cm130)
    call cm130_init()

    log LOG_DEBUG, LOGFILE,"3 * rt010_kosttraeger >:rt010_kosttraeger< * rt010_identnr >:rt010_identnr< * rt010_var >:rt010_var<"
    log LOG_DEBUG, LOGFILE,"4 * rt010_fklz->c1311_ufklz >:rt010_fklz< * rt010_fmlz_uebg->c1311_fmlz >:rt010_fmlz_uebg< * rt010_fklz_uebg->c1311_fklz >:rt010_fklz_uebg<"
    log LOG_DEBUG, LOGFILE,"5 * rt010_ufklz_uebg >:rt010_ufklz_uebg< * rt010_disstufe_uebg >:rt010_disstufe_uebg< * rt010_disstufe >:rt010_disstufe<"

    ufklzCm130   = rt010_fklz

    kosttraegerCm130 = rt010_kosttraeger
    fmlzCm130        = rt010_fmlz_uebg
    identnrCm130     = rt010_identnr
    varCm130         = rt010_var
    fklzCm130        = rt010_fklz_uebg

    if (rt010_ufklz_uebg != NULL) {
        disstufeCm130 = rt010_disstufe_uebg
    }
    else {
        disstufeCm130 = rt010_disstufe
    }

    mengeCm130       = rt010_menge_uebg
    menge_aglCm130   = rt010_menge_agl_uebg
    menge_abgCm130   = rt010_menge_abg_uebg
    menge_entCm130   = 0
    aesCm130         = aesStrukturP

    rcL = cm130_struktur()
    call bu_msg_errmsg("cm130")
    call cm130_deactivate(rt010_cm130)
    if (rcL < OK) {
        return on_error(FAILURE)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_vorkalk_uebg_abg
#
# Vorkalkulation für übergeordnetes Material mit abgesetzter Menge
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_vorkalk_uebg_abg()
{
    int rcL

    // Nur Kalkulation aufrufen, wenn abgesetzte Menge sich geändert hat
    // Ändert sich die Menge im untergeordneten FA, so werden die Soll-
    // Kosten über diesen und über die Strukturverdichtung geändert

    if (rt010_menge_abg_uebg == rt010_menge_abg_alt) {
        log LOG_DEBUG, LOGFILE, "keine Änderung der abgesetzten Menge"
        return OK
    }

    rt010_kt410_abg_handle = bu_load_tmodul("kt410", rt010_kt410_abg_handle)
    if (rt010_kt410_abg_handle < 0) {
        return FAILURE
    }
    rcL = kt410_abgesetzt(rt010_kt410_abg_handle, rt010_fmlz_uebg, rt010_menge_abg_alt + 0)
    if (rcL < OK) {
        // Fehler bei Vorkalkulation überg. Bedarf
        call on_error(OK, "r1000503", "", rt010_prot)
        return FAILURE
    }
    if (rcL != OK) {
        // Hinweis(e) bei Vorkalkulation überg. Bedarf
        call on_error(OK, "r1000513", "", rt010_prot)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Satz in Tabelle "r115" einfügen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_insert_r115()
{
    string freigabeL

    log LOG_DEBUG, LOGFILE, "rt010_insert_r110 = rt010_da = <:rt010_da> R_VKN <:R_VKN> rt010_identnr <:rt010_identnr><:rt010_var><:rt010_werk><:rt010_lgnr>"

    // Der Aufruf erfolgt aus dem Absetzen heraus, d.h.
    // a) die da = "1"
    // b) kn_nettobedarf = "1" oder "2"
    // damit fallen die Bedingungen für das Abstellen eines Aktionssatzes bei
    // R_VKN = "0" komplett weg

    if (R_VKN                == "0" || \
        rt010_kn_nettobedarf == "1" || \
        rt010_kn_nettobedarf == "2") {
        return OK
    }

    freigabeL = bu_getenv("R_FREIGABE")

    call bu_noerr()

//TODO: über rq115
    dbms sql insert into r115 ( \
             fi_nr, \
             werk, \
             fklz, \
             freigabe, \
             aufnr, \
             aufpos, \
             fu_bedr, \
             logname, \
             mkz, \
             tkz, \
             kn_aend_fa, \
             jobid, \
             vstat, \
             kz_fhl, \
             identnr, \
             var, \
             lgnr \
          ) values ( \
             :+FI_NR1, \
             :+rt010_werk, \
             :+NULL, \          // fklz
             :+freigabeL, \
             :+NULL, \          // aufnr
             0, \               // aufpos
             :+cFUBEDR_NETTO, \
             :+LOGNAME, \
             :+MKZ_NEIN, \
             :+cTKZ_STRUKTUR, \
             :+KN_AEND_FA_OHNE, \
             0, \               // jobid
             :+NULL, \          // vstat
             :+NULL, \          // kz_fhl
             :+rt010_identnr, \
             :+rt010_var, \
             :+rt010_lgnr )

    if (SQL_CODE == SQLE_DUPKEY) {
        return OK
    }
    else if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r115", rt010_prot)
    }

    start_rh1004Fertig = FALSE

    log LOG_DEBUG, LOGFILE, "rt010_insert_r110 = inserted row in table r115"

    return OK
}

/**
 * Ermitteln, ob eine Terminbestätigung notwendig ist
 *
 * @return TRUE
 * @return FALSE
 **/
boolean proc rt010_termin_bestaetigen_noetig()
{
    if (rt010_menge <= 0.0) {
        return FALSE
    }

    // Mengen-/Terminänderungen am Primärauftrag
    if (rt010_chk_tk_erforderlich() != TRUE) {
        return FALSE
    }

    if (rt010_fu_bedr == cFUBEDR_EINPLAN \
    ||  rt010_fu_bedr == cFUBEDR_MTAEND \
    ||  rt010_fu_bedr == cFUBEDR_TAUSCH) {
        if (rt010_termstr == cTERMSTR_RUECKW \
        &&  rt010_pruefe_aktionsatz_rueckw() == FALSE) {
            // Reine Rückwärtsterminierung und kein Aktionssatz mehr vorhanden
            return TRUE
        }
        else if (rt010_termstr == cTERMSTR_MITTEL \
        && rt010_pruefe_aktionsatz_rueckw() == FALSE \
        && rt010_pruefe_aktionsatz_vorw() == FALSE) {
            // Mittelpunktterminierung ohne Konflikte
            return TRUE
        }
        else if (cod_aart_primaer(rt010_aart) == TRUE \
        && rt010_termstr != cTERMSTR_RUECKW) {
            return TRUE
        }
    }
    else if (rt010_fu_bedr == cFUBEDR_VORW) {
        if (cod_aart_primaer(rt010_aart) == TRUE) {
            // Alle Terminierungsarten, die eine Vorwärtsterminierung initiieren und Primärauftrag
            return TRUE
        }
    }

    return FALSE
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefe_aktionsatz_rueckw()
{
    if (dm_is_cursor("SelR115Rt010Rueckw") == FALSE) {
        dbms declare SelR115Rt010Rueckw cursor for \
            select count(*) \
              from r115 \
             where r115.aufnr   =  ::aufnr and \
               r115.aufpos  =  ::aufpos and \
               r115.fi_nr   =  :+FI_NR1 and \
               r115.werk    =  :+werk and \
               r115.fklz    <> ::fklz and \
               r115.fu_bedr <> :+cFUBEDR_NETTO and \
               r115.fu_bedr <> :+cFUBEDR_VORW and \
               r115.fu_bedr <> :+cFUBEDR_RUECKW and \
               r115.kz_fhl  <> '1'

        dbms with cursor SelR115Rt010Rueckw alias jamint

        cursorRt010[++] = "SelR115Rt010Rueckw"
    }

    dbms with cursor SelR115Rt010Rueckw execute using rt010_aufnr, \
                                                     rt010_aufpos, \
                                                     rt010_fklz

    if (jamint > 0) {
        return TRUE
    }

    return FALSE
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_pruefe_aktionsatz_vorw()
{
    if (dm_is_cursor("SelR115Rt010Vorw") == FALSE) {
        dbms declare SelR115Rt010Vorw cursor for \
            select count(*) \
              from r115 \
             where r115.aufnr   =  ::aufnr and \
               r115.aufpos  =  ::aufpos and \
               r115.fi_nr   =  :+FI_NR1 and \
               r115.werk    =  :+werk and \
               r115.fklz    <> ::fklz and \
               r115.fu_bedr <> :+cFUBEDR_NETTO and \
               r115.kz_fhl  <> '1'

        dbms with cursor SelR115Rt010Vorw alias jamint

        cursorRt010[++] = "SelR115Rt010Vorw"
    }

    dbms with cursor SelR115Rt010Vorw execute using rt010_aufnr, \
                                                   rt010_aufpos, \
                                                   rt010_fklz

    if (jamint > 0) {
        return TRUE
    }

    return FALSE
}

#-----------------------------------------------------------------------------------------------------------------------
# rt010_chk_tk_erforderlich
# - Prüfung, ob eine Terminklärung durchgeführt werden muss
# - verwendete Daten fklz
#
# - ReturnCode       TRUE  - Terminklärung ist erforderlich, v170 ist offen
#                    FALSE - Terminklärung ist nicht erforderlich
#
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_chk_tk_erforderlich()
{
    vars cntVorhandenL
    vars whereFiNrL

    if (dm_is_cursor("cntV170Rt010") != TRUE) {
        if (cod_vereinfachte_firmenkopplung(fi_nr, FALSE) == "0") {
            whereFiNrL = " and v1101.fi_nr = :+fi_nr "
        }

        dbms declare cntV170Rt010 cursor for \
            select count(*) \
              from v170, \
                  v1101, \
                  r100 \
             where v170.fi_nr        = ::FI_NR1 and \
               v170.aufnr        = v1101.aufnr and \
               v170.aufpos       = v1101.aufpos and \
               v170.seblpos      = v1101.seblpos and \
               v170.st_termklaer = :+cST_TERMKLAER_OFFEN \
               :whereFiNrL and \
               v1101.fmlz        = r100.fmlz and \
               r100.fi_nr        = v170.fi_nr and \
               r100.ufklz        = ::fklz

        dbms with cursor cntV170Rt010 alias cntVorhandenL

        cursorRt010[++] = "cntV170Rt010"
    }

    dbms with cursor cntV170Rt010 execute using FI_NR1, \
                                                rt010_fklz_prim

    if (cntVorhandenL > 0) {
        return TRUE
    }
    return FALSE
}

// 300156122 (Fehler 5)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_check_termin(fldDatumP)
{
    if (fldDatumP == NULL) {
        return OK
    }

    vars firstL = FALSE
    if (handleGm300Rt010 <= 0) {
        firstL = TRUE
    }

    handleGm300Rt010 = bu_load_modul("gm300", handleGm300Rt010, NULL)
    if (handleGm300Rt010 <= 0) {
        return OK
    }

    call gm300_activate(handleGm300Rt010)

    if (firstL == TRUE) {
        call gm300_init()
        fi_nrGm300E = fi_nr
        werkGm300E = rt010_werk

        // einmalig den zu verwendenden Kalender ermitteln
        if (gm300_kalender_ermitteln() != OK) {
            call gm300_deactivate(handleGm300Rt010)
            return OK
        }
    }

    call gm300_init()
    opcodeGm300E = "get"
    datumGm300E = :(fldDatumP)
    flagFktGm300E = FALSE
    if (gm300_datum_all() != OK) {
        call gm300_init()
        opcodeGm300E = "next"
        datumGm300E = :(fldDatumP)
        flagFktGm300E = FALSE

        if (gm300_datum() == OK) {
            if (:(fldDatumP) != datumGm300A) {
                // 300167497
                // Der Termin >%1< des Fertigungsauftrages >%2< wurde vom >%3< auf den >%4< verschoben, da dazwischen im Kalender >%5< keine Kapazität frei ist.
                call on_error(INFO, "r2000314", fldDatumP(7) ## "^" ## rt010_fklz ## "^" ## :(fldDatumP) ## "^" ## datumGm300A ## "^" ## kalidGm300EA, rt010_prot)

                :(fldDatumP) = datumGm300A
                log LOG_DEBUG, LOGFILE, "rt010_check_termin(:fldDatumP) - Nächster gültiger Kalendertag: >" ## datumGm300A ## "<"
            }
        }
    }

    call gm300_deactivate(handleGm300Rt010)

    return OK
}

// 300170253 (Fehler 1)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_check_r100()
{
    vars countFlagL

    dbms alias countFlagL
    dbms sql select count(*) \
             from r100 \
             where r100.fi_nr = :+FI_NR1 and \
               r100.fklz  = :+rt010_fklz
    dbms alias

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r100", rt010_prot)
    }
    if (countFlagL > 0) {
        // Satz in Tabelle %s kann nicht gelöscht werden, da Satz in Tabelle %s noch vorhanden ist.
        return on_error(FAILURE, "APPL1003", "r000^r100", rt010_prot)
    }

    return OK
}

// 300170253 (Fehler 1)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_check_r200()
{
    vars countFlagL

    dbms alias countFlagL
    dbms sql select count(*) \
             from r200 \
             where r200.fi_nr = :+FI_NR1 and \
               r200.fklz  = :+rt010_fklz
    dbms alias

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r200", rt010_prot)
    }
    if (countFlagL > 0) {
        // Satz in Tabelle %s kann nicht gelöscht werden, da Satz in Tabelle %s noch vorhanden ist.
        return on_error(FAILURE, "APPL1003", "r000^r200", rt010_prot)
    }

    return OK
}

#proc neu--------------------------------

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_aufheben_fixierungen_system(cdtGq300 standortkalenderP)
{
    int  rcL
    cdt  cdtRq000L

    public rq000.bsl
    cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz, standortkalenderP)

    call rq000_set_fu_bedr_uebergeben(cdtRq000L, rt010_fu_bedr)
    call rq000_set_tkz_uebergeben(cdtRq000L, rt010_tkz)
    call rq000_set_clear_message(cdtRq000L, TRUE)

    rcL = rq000_aufheben_fixierung_systemseitig_mit_speichern(cdtRq000L)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rq000_aufheben_fixierung_systemseitig_mit_speichern rc=" ## rcL

        // Im Fehler fall immer alle Meldungen in Protokolltabelle speichern...
        call rq000_speichern_protokoll(cdtRq000L, BU_0, FALSE)
        return rcL
    }

    // Im OK-Fall nur die für die Bedarfsrechnung relevanten Meldungen speichern...
    rcL = rq000_speichern_protokoll(cdtRq000L, BU_4, FALSE)
    if (rcL < OK) {
        log LOG_DEBUG, LOGFILE, "Fehler rq000_speichern_protokoll rc=" ## rcL
        return rcL
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt010_check_fu_bedr9()
{
    vars rcodeL
    vars fu_bedrL

    dbms alias fu_bedrL
    dbms sql select r115.fu_bedr \
             from r115 \
             where r115.fi_nr    = :+FI_NR1 and \
               r115.werk     = :+werk and \
               r115.fklz     = :+rt010_fklz and \
               r115.identnr  = :+NULL and \
               r115.var      = :+NULL and \
               r115.lgnr     = 0
    dbms alias

    if (SQL_CODE == SQLNOTFOUND) {
        rcodeL = FALSE
    }
    else if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r115", rt010_prot)
    }
    else {
        if (fu_bedrL == cFUBEDR_VORW) {
            rcodeL = TRUE
        }
        else {
            rcodeL = FALSE
        }
    }
    log LOG_DEBUG, LOGFILE, "rcode >" ## rcodeL ## "<"

    return rcodeL
}

/**
 * Setzen des Terminierungskennzeichens des Fertigungsauftrages
 *
 * @param kn_terminiertP        Neues Terminierungskennzeichen
 * @param rcodeP                Return-Code der (vorangegangenen) Modulfunktion
 * @param [r000P]               CDBI-Instanz der R000
 * @return OK                   Kennzeichen geändert
 * @return INFO                 Kennzeichen nicht geändert
 * @return FAILURE              Fehler
 **/
int proc rt010_setzen_kn_terminiert_fa(string kn_terminiertP, int rcodeP, R000CDBI r000P)
{
    int      rcL
    cdtRq000 cdtRq000L
    string   kn_terminiertL


    if (rt010_fklz              == "" \
    ||  defined(kn_terminiertP) != TRUE \
    ||  kn_terminiertP          == "") {
        return INFO
    }

//TODO: Cursor
    dbms alias kn_terminiertL
    dbms sql select r000.kn_terminiert \
             from r000 \
             where r000.fi_nr = :+FI_NR1 \
             and   r000.fklz  = :+rt010_fklz
    dbms alias

    if (kn_terminiertL == kn_terminiertP) {
        log LOG_DEBUG, LOGFILE, "fklz >" ## rt010_fklz ## "< war schon auf >" ## kn_terminiertP ## "< eingestellt..."
        return INFO
    }

    // 300240086: Den Rollback nur bei einem FAILURE;
    // Bei rc > 0 (z.B. BU_2) keinen machen, da sonst der Protokollsatz in r016 nicht geschrieben wird.
    if (rcodeP       == FAILURE \
    &&  SQL_IN_TRANS == TRUE) {
        log LOG_DEBUG, LOGFILE, "rcodeP >" ## rcodeP ## "< -> rollback..."
        call bu_rollback()
    }


    public rq000.bsl
    if (defined(r000P) == TRUE \
    &&  r000P=>fi_nr   == FI_NR1 \
    &&  r000P=>fklz    == rt010_fklz) {
        cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, "", $NULL)
        call rq000_set_r000(cdtRq000L, r000P, FALSE)
    }
    else {
        cdtRq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz, $NULL)
    }

    call md_clear_modified(cdtRq000L)
    call md_set_modified(cdtRq000L=>r000, "fi_nr")
    call md_set_modified(cdtRq000L=>r000, "fklz")

    call rq000_set_kn_terminiert(cdtRq000L, kn_terminiertP)

    rcL = rq000_update_cdbi(cdtRq000L, cdtRq000L=>r000)
    if (rcL != OK) {
        log LOG_DEBUG, LOGFILE, "ReturnCode aus rq000_update_cdbi rc=" ## rcL
        // Im Fehler fall immer alle Meldungen in Protokolltabelle speichern.
        call rq000_speichern_protokoll(cdtRq000L, BU_0, FALSE)
        return on_error(FAILURE)
    }

    return OK
}

/**
 * Diese Methode ermittelt, ob beim Fertigungsauftrag eine Baukastenüberlappung vorliegt oder nicht.
 *
 * Benötigte Felder:
 * - rt010_fklz                 Fertigungs-Kopfleitzahl
 * - rt010_aart                 Auftragsart
 * - rt010_uebzt_sek_uebg       Überlappzeit in Sekunden aus dem (übergeordneten) Materials
 *
 * @param standortkalenderP     Standortkalender
 * @param [r000P]               CDBI-Instanz der r000
 * @return TRUE                 Baukastenüberlappung vorhanden
 * @return FALSE                Keine Baukastenüberlappung vorhanden
 **/
boolean proc rt010_is_baukastenueberlappung(cdtGq300 standortkalenderP, R000CDBI r000P)
{
    int      rcL
    cdtRq000 rq000L
    boolean  baukastenueberlappungL = FALSE


    if (cod_aart_sek(rt010_aart) == TRUE) {
        if (rt010_uebzt_sek_uebg > 0) {
            baukastenueberlappungL = TRUE
        }
        else if (rt010_uebzt_sek_uebg == 0) {
            baukastenueberlappungL = FALSE
        }
        else if (rt010_fklz != "") {
            public rq000.bsl
            if (defined(r000P) == TRUE) {
                // 300349432
                rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, "", standortkalenderP)
                call rq000_set_r000(rq000L, r000P, FALSE)
            }
            else {
                rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz, standortkalenderP)
            }
            call rq000_set_clear_message(rq000L, TRUE)

            rcL = rq000_is_baukastenueberlappung(rq000L)
            if (rcL != OK) {
                call rq000_ausgeben_meldungen(rq000L, BU_0)
                return FAILURE
            }

            baukastenueberlappungL = rq000_get_baukastenueberlappung(rq000L)
        }
    }


    log LOG_DEBUG, LOGFILE, "baukastenueberlappung >" ## baukastenueberlappungL ## "<"
    return baukastenueberlappungL
}

/**
 * Löscht nicht verwendete auftragsbezogene Stammdaten
 *
 * @return  OK
 * @return  FAILURE
 **/
int proc rt010_loeschen_auftragsbez_stammdaten_ohne_verwendung()
{
    BaugruppeFt010 bgrL
    F010CDBI f010L
    int rcL

    log LOG_DEBUG, LOGFILE, ""

    if (rt010_load_ft010() != OK) {
        return FAILURE
    }

    f010L = bu_cdbi_new("f010")
    switch (ft010_lesen_steuersatz_auftagsbez(rt010_ft010_handle, rt010_aufnr, rt010_aufpos, rt010_altern, f010L)) {
        case OK:
            break
        case WARNING: // Kein Steuersatz (und damit keine auftragsbezogenen Stammdaten) vorhanden
            return OK
        else:
            return on_error(FAILURE)
    }

    bgrL          = bu_cdt_new("BaugruppeFt010")
    bgrL=>identnr = rt010_identnr
    bgrL=>var     = rt010_var
    bgrL=>stlnr   = rt010_stlnr
    bgrL=>aplnr   = rt010_aplnr

    rcL = ft010_loeschen_vorgangsbez_struktur_ohne_verwendung(rt010_ft010_handle, f010L, bgrL, TRUE, TRUE, TRUE)
    log LOG_DEBUG, LOGFILE, "Zurück aus ft010 mit Returncode >" ## rcL ## "<"
    switch (rcL) {
        case OK:
        case INFO:
        case WARNING:
            break
        else:
            return on_error(FAILURE)
    }

    return OK
}

/**
 * Lädt das Modul ft010
 *
 * @return OK
 * @return FAILURE
 **/
int proc rt010_load_ft010()
{
    rt010_ft010_handle = bu_load_tmodul("ft010", rt010_ft010_handle, NULL, "2", "rt010_proto")
    if (rt010_ft010_handle < OK) {
        return FAILURE
    }

    return OK
}

/**
 * Diese Methode ändert das r115.mkz
 *
 * rt010_fklz
 * rt010_fu_bedr
 * rt010_tkz
 * rt010_aufnr
 * rt010_aufpos
 * rt010_aart
 * rt010_fkfs
 * rt010_fkfs_a
 * rt010_freigabe
 * rt010_werk
 *
 * @param [r000P]           CDBI-Instanz zur r000 zu rt010_fklz
 * @return OK
 * @return FAILURE          Fehler
 * @see                     {@code rt010_update_fu_bedr_r115}
 * @see                     {@code rt010_insert_r115}
 * @example
 **/
int proc rt010_update_mkz_r115(R000CDBI r000P)
{
    int     rcL
    cdt     rq115L
    boolean status_ignorierenL = FALSE

    if (rt010_fklz    == NULL \
    ||  rt010_fu_bedr == cFUBEDR_NETTO) {
        return OK
    }
    log LOG_DEBUG, LOGFILE, "Änderung mkz >" ## rt010_fklz ## "< auf >" ## rt010_mkz ## "<"

    public rq115.bsl
    rq115L = rq115_new(boa_cdt_get(name_cdtTermGlobal_rt010), NULL)
    call rq115_set_fi_nr(rq115L, FI_NR1)
    call rq115_set_werk(rq115L, rt010_werk)
    call rq115_set_fklz(rq115L, rt010_fklz)
    call rq115_set_aes(rq115L, rt010_fu_bedr)
    call rq115_set_mkz(rq115L, rt010_mkz)
    call rq115_set_tkz(rq115L, rt010_tkz)
    call rq115_set_rkz(rq115L, RKZ_UNDEFINIERT)
    call rq115_set_kn_aend_fa(rq115L, rt010_kn_aend_fa)
    call rq115_set_aufnr(rq115L, rt010_aufnr)
    call rq115_set_aufpos(rq115L, rt010_aufpos)
    call rq115_set_aart(rq115L, rt010_aart)
    call rq115_set_fkfs(rq115L, rt010_fkfs)
    call rq115_set_fkfs_a(rq115L, rt010_fkfs_a)
    call rq115_set_freigabe(rq115L, rt010_freigabe)
    call rq115_set_r000(rq115L, r000P)
    call rq115_set_jobid(rq115L, $NULL) // 300370156: Damit in der Bedarfsrechnung/Nettobedarfsrechnung immer die aktuelle JOBID im rq115 gesetzt wird
    call rq115_set_feinplanung(rq115L, FALSE)
    call rq115_set_art_protokoll(rq115L, F_ART_PROTOKOLL_FA)

    rcL = rq115_terminierung(rq115L, status_ignorierenL)
    switch (rcL) {
        case OK:
        case BU_3:
        case BU_4:
            break
        case INFO:          // r000 nicht vorhanden
        case FAILURE:
        else:
            log LOG_DEBUG, LOGFILE, "Fehler rq115_terminierung rc=" ## rcL
            return on_error(FAILURE)
    }

    return OK
}

/**
 * Diese Methode ändert den Funktionscode FU_BEDR in r115 beim Stornieren eines abgesetzten FA
 *
 * rt010_fklz
 * rt010_fu_bedr
 * rt010_mkz
 *
 * @param [r000P]           CDBI-Instanz zur r000 zu rt010_fklz
 * @return OK
 * @return FAILURE          Fehler
 * @see                     {@code rt010_update_mkz_r115}
 * @see                     {@code rt010_insert_r115}
 * @example
 **/
int proc rt010_update_fu_bedr_r115(R000CDBI r000P)
{
    int     rcL
    cdt     rq115L


    if (rt010_fklz    == "" \
    ||  rt010_fu_bedr == cFUBEDR_NETTO) {
        return OK
    }
    log LOG_DEBUG, LOGFILE, "Änderung Funktionscode >" ## rt010_fklz ## "<"

    public rq115.bsl
    rq115L = rq115_new(boa_cdt_get(name_cdtTermGlobal_rt010), NULL)
    call rq115_set_fi_nr(rq115L, FI_NR1)
    call rq115_set_werk(rq115L, rt010_werk)
    call rq115_set_fklz(rq115L, rt010_fklz)
    call rq115_set_aes(rq115L, rt010_fu_bedr)
    call rq115_set_mkz(rq115L, rt010_mkz)
    call rq115_set_tkz(rq115L, rt010_tkz)
    call rq115_set_rkz(rq115L, RKZ_UNDEFINIERT)
    call rq115_set_kn_aend_fa(rq115L, rt010_kn_aend_fa)
    call rq115_set_aufnr(rq115L, rt010_aufnr)
    call rq115_set_aufpos(rq115L, rt010_aufpos)
    call rq115_set_aart(rq115L, rt010_aart)
    call rq115_set_fkfs(rq115L, rt010_fkfs)
    call rq115_set_fkfs_a(rq115L, rt010_fkfs_a)
    call rq115_set_freigabe(rq115L, rt010_freigabe)
    call rq115_set_reset_kn_terminiert(rq115L, FALSE)
    call rq115_set_r000(rq115L, r000P)
    call rq115_set_jobid(rq115L, $NULL) // 300370156: Damit in der Bedarfsrechnung/Nettobedarfsrechnung immer die aktuelle JOBID im rq115 gesetzt wird
    call rq115_set_clear_message(rq115L, TRUE)
    call rq115_set_feinplanung(rq115L, FALSE)
    call rq115_set_art_protokoll(rq115L, F_ART_PROTOKOLL_FA)

    // 300314029:
    // Bei Status "1" darf der Aktionssatz in rh110 nach dem Absetzen nicht gelöscht werden.
    // Es muss ein Update auf FU_BEDR=1 (Storno) gemacht werden, damit der Fa auch gelöscht wird.

    rcL = rq115_terminierung(rq115L, cdtTermGlobal_is_bedarfsrechnung(rq115L))
    switch (rcL) {
        case OK:
        case BU_3:
            log LOG_DEBUG, LOGFILE, "Es wurde ein Aktionssatz in r115 zu fklz >" ## rt010_fklz ## "< angelegt/geändert rc=" ## rcL
            break
        case BU_4:
            log LOG_DEBUG, LOGFILE, "Es wurde ein Aktionssatz in r115 zu fklz >" ## rt010_fklz ## "< nix angelegt/geändert rc=" ## rcL
            break
        case INFO:          // r000 nicht vorhanden
            log LOG_DEBUG, LOGFILE, "Es wurde kein Aktionssatz in r115 zu fklz >" ## rt010_fklz ## "< geändert, da r000 nicht vorhanden!"
            return on_error(FAILURE)
        case FAILURE:
        else:
            log LOG_DEBUG, LOGFILE, "Fehler rq115_terminierung rc=" ## rcL
            return on_error(FAILURE)
    }

    return OK
}

/**
 * Diese Methode prüft, ob der Vortag das Arbeitsende "0 Uhr" (d.h. "24 Uhr") hat
 *
 * Input:
 * - rt010_sbterm_uebg
 *
 * @param standortkalenderP     Standortkalender
 * @return TRUE                 Der Vortag zu "rt010_sbterm_uebg" endet um "0 Uhr"
 * @return FALSE                Der Vortag zu "rt010_sbterm_uebg" endet nicht um "0 Uhr" oder ist keine AT
 **/
boolean proc rt010_is_0uhr_vortag(cdtGq300 standortkalenderP)
{
    int  rcL
    date vortagL
    date arbeitsende_vortagL
    date datumL              = rt010_sbterm_uebg
    boolean is_0uhrL         = FALSE


    if (rt010_sbterm_uebg == "") {
        log LOG_DEBUG, LOGFILE, ">rt010_sbterm_uebg< nicht übergeben -> FALSE"
        return FALSE
    }


    // Vortag zu "rt010_sbterm_uebg" ermitteln
    vortagL = @to_date(@time(datumL) - UMR_TAG2SEC)


    // Arbeitsende des Vortages ermitteln
    public gq300.bsl
    call gq300_set_datum_date(standortkalenderP, vortagL)
    call gq300_set_clear_message(standortkalenderP, FALSE)

    rcL = gq300_ermitteln_arbeitsende(standortkalenderP, TRUE)
    switch (rcL) {
        case OK:        // Vortag ist ein AT
            arbeitsende_vortagL = gq300_get_datuhr_neu_date(standortkalenderP)
            break
        case INFO:      // Vortag ist keine AT
        case WARNING:
        case FAILURE:
        else:
            arbeitsende_vortagL = $NULL
            break
    }

    if (defined(arbeitsende_vortagL) == TRUE) {
        // Endet die AZ am Vortag im "24 Uhr" (d.h. "0 Uhr")?
        call gq300_set_datuhr_date(standortkalenderP, arbeitsende_vortagL)
        call gq300_set_clear_message(standortkalenderP, FALSE)
        is_0uhrL = gq300_is_0uhr(standortkalenderP)
    }


    return is_0uhrL
}

/**
 * Diese Methode prüft, ob der neue Endtermin vor dem Starttermin liegt und setzt diesen ggf. korrekt
 *
 * Es muss vorher geprüft werden, ob sich der Endtermin überhaupt geändert hat. Nur wenn ja, dann diese
 * Methode aufrufen!
 *
 * @return OK           Starttermine wurden geändert
 * @return INFO         Starttermine wurden nicht geändert
 * @return FAILURE      Fehler
 * @see                 {@code rt010_pruefen_struktur_starttermin_gegen_endtermin}
 * @see                 {@code rt000_pruefen_termine_bauk_gegen_arbeitszeit}
 * @example
 **/
int proc rt010_pruefen_starttermin_gegen_endtermin()
{
    vars    rq000L
    int     rcodeL
    int     angearbeitetL


    // Laden FA-Modul inkl. Lesen FA-Daten
    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz, $NULL)

    call rq000_set_fklz(rq000L, rt010_fklz)
    call rq000_set_fsterm_uhr(rq000L, rt010_fsterm_uhr)
    call rq000_set_fortsetz_uhr(rq000L, rt010_fortsetz_uhr)
    call rq000_set_seterm_uhr(rq000L, rt010_seterm_uhr)
    call rq000_set_fsterm(rq000L, rt010_fsterm)
    call rq000_set_fortsetz_dat(rq000L, rt010_fortsetz_dat)
    call rq000_set_seterm(rq000L, rt010_seterm)
    call rq000_set_fkfs(rq000L, rt010_fkfs)
    call rq000_set_fkfs_a(rq000L, rt010_fkfs_a)
    call rq000_set_richtung(rq000L, EINL_RICHTUNG_RUECKW)   // immer Rückwärtsterminierung da immer der seterm geändert wurde
    call rq000_set_clear_message(rq000L, TRUE)

    rcodeL = rq000_pruefen_starttermin_gegen_endtermin(rq000L, TRUE)
    switch (rcodeL) {
        case OK:        // Änderung Start-/Fortsetztermin notwendig
            angearbeitetL = rq000_get_angearbeitet(rq000L)
            if (angearbeitetL == TRUE) {
                if (rq000_get_fortsetz_uhr(rq000L) != rt010_fortsetz_uhr \
                ||  rq000_get_fortsetz_dat(rq000L) != rt010_fortsetz_dat) {
                    rt010_fortsetz_uhr = rq000_get_fortsetz_uhr(rq000L)
                    rt010_fortsetz_dat = rq000_get_fortsetz_dat(rq000L)
                    log LOG_DEBUG, LOGFILE, "rt010_fortsetz_uhr >" ## rt010_fortsetz_uhr ## "<"
                    log LOG_DEBUG, LOGFILE, "rt010_fortsetz_dat >" ## rt010_fortsetz_dat ## "<"
                }
                else {
                    // keine tatsächliche Änderung der Struktur-Starttermine
                    rcodeL = INFO
                }
            }
            else {
                if (rq000_get_fsterm_uhr(rq000L) != rt010_fsterm_uhr \
                ||  rq000_get_fsterm(rq000L)     != rt010_fsterm) {
                    rt010_fsterm_uhr = rq000_get_fsterm_uhr(rq000L)
                    rt010_fsterm     = rq000_get_fsterm(rq000L)
                    log LOG_DEBUG, LOGFILE, "rt010_fsterm_uhr >" ## rt010_fsterm_uhr ## "<"
                    log LOG_DEBUG, LOGFILE, "rt010_fsterm >" ## rt010_fsterm ## "<"
                }
                else {
                    // keine tatsächliche Änderung der Struktur-Starttermine
                    rcodeL = INFO
                }
            }
            break
        case INFO:      // Keine Termin-Änderung notwendig
            break
        case WARNING:
        case FAILURE:
        else:
            if (SQL_IN_TRANS == TRUE) {
                call bu_rollback()
            }
            call rq000_speichern_protokoll(rq000L, BU_0, FALSE)
            return FAILURE
    }

    log LOG_DEBUG, LOGFILE, "rcode >" ## rcodeL ## "<"
    return rcodeL
}

/**
 * Diese Methode prüft, ob der neue Endtermin vor dem Starttermin liegt und setzt diesen ggf. korrekt
 *
 * Es muss vorher geprüft werden, ob sich der Endtermin überhaupt geändert hat. Nur wenn ja, dann diese
 * Methode aufrufen!
 *
 * @return OK           Starttermine wurden geändert
 * @return INFO         Starttermine wurden nicht geändert
 * @return FAILURE      Fehler
 * @see                 rt010_pruefen_starttermin_gegen_endtermin
 * @example
 **/
int proc rt010_pruefen_struktur_starttermin_gegen_endtermin()
{
    int      rcodeL
    cdtRq000 rq000L


    // Laden FA-Modul inkl. Lesen FA-Daten
    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz, $NULL)

    call rq000_set_fklz(rq000L, rt010_fklz)
    call rq000_set_fsterm_w_uhr(rq000L, rt010_fsterm_w_uhr)
    call rq000_set_seterm_w_uhr(rq000L, rt010_seterm_w_uhr)
    call rq000_set_fsterm_w(rq000L, rt010_fsterm_w)
    call rq000_set_seterm_w(rq000L, rt010_seterm_w)
//    call rq000_set_termstr(rq000L, rt010_termstr)
    call rq000_set_termart(rq000L, rt010_termart)
    call rq000_set_fkfs(rq000L, rt010_fkfs)
    call rq000_set_fkfs_a(rq000L, rt010_fkfs_a)
    call rq000_set_aart(rq000L, rt010_aart)
    call rq000_set_richtung(rq000L, EINL_RICHTUNG_RUECKW)   // immer Rückwärtsterminierung da immer der seterm geändert wurde
    call rq000_set_clear_message(rq000L, TRUE)
    call rq000_set_aufrufer(rq000L, "rt010")

    rcodeL = rq000_pruefen_strukturtermine_mit_uhrzeit(rq000L)
    switch (rcodeL) {
        case OK:        // Änderung Start-/Fortsetztermin notwendig
            if (rq000_get_fsterm_w_uhr(rq000L) != rt010_fsterm_w_uhr \
            ||  rq000_get_fsterm_w(rq000L)     != rt010_fsterm_w) {
                rt010_fsterm_w_uhr = rq000_get_fsterm_w_uhr(rq000L)
                rt010_fsterm_w     = rq000_get_fsterm_w(rq000L)
            }
            else {
                // keine Änderung der Struktur-Starttermine
                rcodeL = INFO
            }
            break
        case WARNING:
        case FAILURE:
        else:
            if (SQL_IN_TRANS == TRUE) {
                call bu_rollback()
            }
            call rq000_speichern_protokoll(rq000L, BU_0, FALSE)
            return FAILURE
    }

    log LOG_DEBUG, LOGFILE, "rcode >" ## rcodeL ## "<"
    return rcodeL
}

/**
 * Diese Methode prüft, ob der übergeordnete FA lt. Status noch verschoben werden darf oder nicht
 *
 * Es wird keine Meldung über rq000 ausgegeben (Sie wird weiter oben erzeugt).
 *
 * @ldb_in rt010_fklz_uebg
 * @ldb_in rt010_tkz
 * @param [standortkalenderP]   Standortkalender
 * @return TRUE                 überg. FA darf verschoben werden
 * @return FALSE                überg. FA darf nicht verschoben werden
 * @see                         {@code rq000_terminaenderung_erlaubt}
 * @example
 **/
boolean proc rt010_terminaenderung_erlaubt_uebg(cdtGq300 standortkalenderP, R000CDBI r000P)
{
    cdtRq000 rq000L
    boolean  terminaenderung_erlaubtL
    boolean  tkz0_pruefen_neinL       = FALSE
    int      meldung_neinL            = BU_0

    if (rt010_fklz_uebg == "") {
        return TRUE
    }

    public rq000.bsl

    if (defined(r000P) == TRUE \
    &&  r000P=>fklz    == rt010_fklz_uebg) {
        rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, "", standortkalenderP)
        call rq000_set_r000(rq000L, r000P, FALSE)
    }
    else {
        rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt010), FI_NR1, rt010_fklz_uebg, standortkalenderP)
    }

    call rq000_set_tkz_uebergeben(rq000L, rt010_tkz)
    call rq000_set_clear_message(rq000L, TRUE)

    terminaenderung_erlaubtL = rq000_terminaenderung_erlaubt(rq000L, meldung_neinL, tkz0_pruefen_neinL)
    call rq000_speichern_protokoll(rq000L, BU_0, FALSE)

    log LOG_DEBUG, LOGFILE, "terminaenderung_erlaubt >" ## terminaenderung_erlaubtL ## "<"
    return terminaenderung_erlaubtL
}

/**
 * Setzt eine logische Sperre für den Fertigungsauftrag mit der übergebenen FKLZ.
 *
 * @param   fklzP   FKLZ des Fertigungsauftrags
 * @return  OK      Fertigungsauftrag erfolgreich gesperrt
 * @return  FAILURE Fertigungsauftrag konnte nicht gesperrt werden
 **/
int proc rt010_tx_lock(string fklzP)
{
    int iL


    log LOG_DEBUG, LOGFILE, "fklzP=<:(fklzP)>"
    for iL = 1 while (iL <= tx_fklz_grdRt010->num_occurrences) step 1 {
        if (tx_fklz_grdRt010[iL] == fklzP) {
            log LOG_DEBUG, LOGFILE, "iL=<:(iL)>"
            return OK
        }
    }

    // FKLZ darf weder von dieser Session, noch von einer anderen gesperrt sein!
    if (bu_lock("r000", fklzP, FI_NR1, FALSE) != OK) {
        return on_error(FAILURE)
    }
    tx_fklz_grdRt010[++] = fklzP

    return OK
}

/**
 * Entfernt alle Sperren, die im Laufe der Verarbeitung gesetzt wurden.
 *
 * @return  OK  Erfolg
 **/
int proc rt010_tx_unlock_all()
{
    int iL


    log LOG_DEBUG, LOGFILE, tx_fklz_grdRt010->num_occurrences ## " Lock(s)"
    for iL = tx_fklz_grdRt010->num_occurrences while (iL >= 1) step -1 {
        log LOG_DEBUG, LOGFILE, "tx_fklz_grdRt010[:(iL)]=<:(tx_fklz_grdRt010[iL])>"
        call bu_unlock("r000", tx_fklz_grdRt010[iL], FI_NR1)
        tx_fklz_grdRt010[iL] = ""
    }

    return OK
}

/**
 * Diese Methode aktualisiert die Daten der übergebenen R000-CDBI-Instanz mit den Modul-Daten
 *
 * @param r000P             CDBI-Instanz der r000
 * @param nur_geaenderteP   Nur geänderte Felder übernehmen (TRUE) oder alle Felder übernehmen (FALSE)
 * @param clear_modifiedP   Modified-Flag der geänderten felder zurücksetzen (TRUE) oder nicht (FALSE)
 * @return OK               Daten wurden übernommen
 * @return INFO             Daten wurden nicht übernommen
 * @return FAILURE          Fehler
 **/
int proc rt010_daten_2_r000cdbi(R000CDBI r000P, boolean nur_geaenderteP, boolean clear_modifiedP)
{
    int    iL
    int    anzahL = 0
    string fldnameL
    string fldname_ldbL
    string is_keyL
    string wert_altL
    string wert_neuL


    if (defined(r000P) != TRUE \
    ||  r000P=>fi_nr   != FI_NR1 \
    ||  r000P=>fklz    != rt010_fklz) {
        return INFO
    }

    anzahL = md_get_fieldcount(r000P)
    if (anzahL <= 0) {
        return INFO
    }


    for iL = 1 while (iL <= anzahL) step 1 {
        // Key-Felder überspringen
        is_keyL  = md_annotation_value(r000P, iL, "db.isKey")
        if (is_keyL == "1") {
            next
        }

        // Feldnamen ermitteln und ggf. (besonderer) Felder überspringen
        fldnameL = md_get_field_name(r000P, iL)
        if (fldnameL == "uuid") {
            next
        }

        // Prüfen, ob es das Feld auch im rt010.ldb gibt. Wenn nein, dann nix im CDBI tun.
        fldname_ldbL = "rt010_" ## fldnameL
        if (sm_prop_id("rt010.ldb!" ## fldname_ldbL) < 0) {
            next
        }


        // Das bei int-Werten die 0 und "" in BOA (leider) das Gleiche sind, muss der Feldinhelt in String-Felder
        // umgeladen werden.
        wert_altL = r000P=>:(fldnameL)
        wert_neuL = :(fldname_ldbL)


        // Nur geänderte oder alle Felder übernehmen
        if (nur_geaenderteP == TRUE \
        &&  wert_altL       == wert_neuL) {
            next
        }


        // Wert übernehmen
        r000P=>:(fldnameL) = :(fldname_ldbL)


        // Modified-Flag des geänderten Feldes ggf. zurücksetzen
        if (clear_modifiedP == TRUE) {
            call md_clear_modified(r000P, fldnameL)
        }
    }

    return OK
}


