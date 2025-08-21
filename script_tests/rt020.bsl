#-----------------------------------------------------------------------------------------------------------------------
# Modul Auftragsfreigabe
#-----------------------------------------------------------------------------------------------------------------------
#
# Beschreibung:
# -------------
#
# Dieses Modul beinhaltet Funktionen für die Freigabe von
#
#   - Fertigungsaufträgen
#   - Fertigungsmaterialien
#   - Fertigungsarbeitsgängen
#
#
# Funktionen:
# -----------
#
# rt020_first_entry   Laden des LDB und Initialisierung
# rt020_entry         Aktivieren des LDB
# rt020_exit          Deaktivieren des LDB
# rt020_last_exit     Abschließen und entfernen des LDB
#
# rt020_freigabe      Freigabe eines Fertigungsauftrags
# rt020_freigabe_mat  Freigabe eines Fertigungsmaterials
# rt020_freigabe_ag   Freigabe eines Fertigungsarbeitsgangs
#
# rt020_protokoll     Protokollsatz für Fertigungsauftrag schreiben
# rt020_protokoll_mat Protokollsatz für Fertigungsmaterial schreiben
# rt020_protokoll_ag  Protokollsatz für Fertigungsarbeitsgang schreiben
#
#
# benutzte Variablen aus "appl.ldb"
# ----------------------------------
#
# - /-
#
#
# Parameter:
# ----------
#
# handle      LDB-Handle zur Speicherung im rufenden Modul/ Programm/ Maske
#
#
# Bundles:    b_rt020     Daten für Fertigungsauftrag
# --------    b_rt020_mat Daten für Fertigungsmaterial
#             b_rt020_ag  Daten für Fertigungsarbeitsgang
#
#
# LDB:
# ----
#
# rt020.ldb   Enthält Daten für die Verarbeitung und Protokollierung
#
#
# Aufgerufene Module:
# -------------------
#
# rq200       Übergabe Arbeitsgangdaten an WS-Schnittstelle
# kt431       Nachkalkulation Material
# vt110r      Setzen Freigabestatus in Kundenauftragsposition
#
# offene Punkte:
# - Protokollierung auf BM-Ebene einführen (siehe ##1)
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# - Laden und aktivieren des LDB
# - Funktion "first_entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_first_entry()
{
    vars handleL
    vars cdtTermGlobalL


    handleL = sm_ldb_load("rt020.ldb")
    if (handleL < 0) {
        return FAILURE
    }
    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, TRUE)

    name_cdtTermGlobal_rt020 = "cdtTermGlobalRt020_" ## handleL

    // Kontext Terminierungsmodul einmalig erzeugen
    public cdtTermGlobal.bsl
    cdtTermGlobalL = cdtTermGlobal_new(FALSE)
    unload cdtTermGlobal.bsl
    call boa_cdt_put(cdtTermGlobalL, name_cdtTermGlobal_rt020)

    // eigenes Handle sichern
    rt020_rt020_handle = handleL

    rt020_lt110_handle = NULL
    public lt110.bsl
    rt020_lt110_handle = lt110_first_entry("rt020_proto")
    if (rt020_lt110_handle < 0) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    public vt110r.bsl
    rt020_vt110r_handle = vt110r_first_entry("2", "rt020_proto")
    if (rt020_vt110r_handle < 0) {
        call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Parameter lesen
    rt020_R_MATBUCH_START = bu_getenv("R_MATBUCH_START")
    rt020_R_DR_ST         = bu_getenv("R_DR_ST")
    rt020_R_DR_AG         = bu_getenv("R_DR_AG")
    rt020_R_DR_LHS        = bu_getenv("R_DR_LHS")
    rt020_R_DR_MES        = bu_getenv("R_DR_MES")
    rt020_R_DR_BL         = bu_getenv("R_DR_BL")
    rt020_R_SERIE_STORNO  = bu_getenv("R_SERIE_STORNO")
    L_LGBER_VORRt020      = bu_getenv("L_LGBER_VOR")
    L_LGFACH_VORRt020     = bu_getenv("L_LGFACH_VOR")
    rt020_R_KOMM_DRUCK    = bu_getenv("R_KOMM_DRUCK")
    rt020_R_KOMM_DRUCK_VA = bu_getenv("R_KOMM_DRUCK_VA")
    D_LAGER_BEZUG         = bu_getenv("D_LAGER_BEZUG")
    L_ST_KOMMAENDRt020    = bu_getenv("L_ST_KOMMAEND")

    rt020_werk     = werk
    rt020_werk_mat = werk
    rt020_werk_ag  = werk

    bearbRt020 = JOBID
    if (bearbRt020 <= 0) {
        bearbRt020 = bu_getnr("JOBID")
    }

    // MCS Einstellungen Firmennummern
    bFirmenkopplungRt020 = cod_vereinfachte_firmenkopplung(fi_nr, FALSE)

    call sm_ldb_h_state_set(handleL, LDB_ACTIVE, FALSE)

    return handleL
}

#-----------------------------------------------------------------------------------------------------------------------
# - aktivieren des LDB
# - Funktion "entry" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_entry(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    public lt110:(EXT)
    call lt110_entry(rt020_lt110_handle)

    public vt110r:(EXT)
    call vt110r_entry(rt020_vt110r_handle)

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# - aktivieren des LDB
# - Funktion "exit" der untergeordneten Module aufrufen
# - deaktivieren des LDB
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_exit(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    public lt110:(EXT)
    call lt110_exit(rt020_lt110_handle)

    public vt110r:(EXT)
    call vt110r_exit(rt020_vt110r_handle)

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# - aktivieren des LDB
# - Funktion "last_exit" der untergeordneten Module aufrufen
# - deaktivieren und entladen des LDB
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_last_exit(handle)
{
    vars kontext_cacheL
    vars i1L
    vars fertKommL = FALSE
    vars versKommL = FALSE
    vars inTransL = FALSE


    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    public lt110:(EXT)
    call lt110_last_exit(rt020_lt110_handle)
    rt020_lt110_handle = NULL
    unload lt110:(EXT)

    call fertig_unload_modul("lm100", lm100_handleRt020)
    lm100_handleRt020 = NULL

    rt020_kt431_handle = bu_unload_tmodul("kt431", rt020_kt431_handle)

    public vt110r:(EXT)
    call vt110r_last_exit(rt020_vt110r_handle)
    rt020_vt110r_handle = NULL

    // Autom. Start Nettobedarfsrechnung, wenn R_START_NETTOBEDARF = "1"
    call fertig_start_rh1004()

    call fertig_unload_modul("rm131", rm131_handleRt020)
    rm131_handleRt020 = NULL

    call fertig_unload_modul("lm820", rt020_lm820_handle)
    rt020_lm820_handle = NULL

    call bu_unload_tmodul("rt231", rt020_handle_rt231)
    rt020_handle_rt231 = NULL

    // Kalendermodul entladen
    call bu_unload_modul("gm300", rt020_handle_gm300)
    rt020_handle_gm300 = NULL

    if (dm_is_cursor("rt020_u_r026") == TRUE) {
        dbms close cursor rt020_u_r026
    }
    if (dm_is_cursor("rt020_r000_mat") == TRUE) {
        dbms close cursor rt020_r000_mat
    }
    if (dm_is_cursor("rt020_read_r035") == TRUE) {
        dbms close cursor rt020_read_r035
    }
    if (dm_is_cursor("rt020_read_r000") == TRUE) {
        dbms close cursor rt020_read_r000
    }
    if (dm_is_cursor("rt020_read_r100") == TRUE) {
        dbms close cursor rt020_read_r100
    }
    if (dm_is_cursor("rt020_read_r200") == TRUE) {
        dbms close cursor rt020_read_r200
    }
    if (dm_is_cursor("rt020_read_g020") == TRUE) {
        dbms close cursor rt020_read_g020
    }
    if (dm_is_cursor("rt020_read_d400") == TRUE) {
        dbms close cursor rt020_read_d400
    }
    if (dm_is_cursor("rt020_r200_kz") == TRUE) {
        dbms close cursor rt020_r200_kz
    }
    if (dm_is_cursor("rt020_read_f300b") == TRUE) {
        dbms close cursor rt020_read_f300b
    }
    if (dm_is_cursor("rt020_g020_mat") == TRUE) {
        dbms close cursor rt020_g020_mat
    }
    if (dm_is_cursor("rt020_get_l020") == TRUE) {
        dbms close cursor rt020_get_l020
    }
    if (dm_is_cursor("rt020_get_l82010") == TRUE) {
        dbms close cursor rt020_get_l82010
    }
    if (dm_is_cursor("rt020_get_l82030") == TRUE) {
        dbms close cursor rt020_get_l82030
    }
    if (dm_is_cursor("rt020_l820xxcur") == TRUE) {
        dbms close cursor rt020_l820xxcur
    }
    if (dm_is_cursor("rt020_get_serie") == TRUE) {
        dbms close cursor rt020_get_serie
    }
    if (dm_is_cursor("rt020_cur_komm") == TRUE) {
        dbms close cursor rt020_cur_komm
    }
    if (dm_is_cursor("rt020_cur_agbest") == TRUE) {
        dbms close cursor rt020_cur_agbest
    }
    if (dm_is_cursor("rt020_r200_fremd") == TRUE) {
        dbms close cursor rt020_r200_fremd
    }
    if (dm_is_cursor("count_r232_rt020C") == TRUE) {
        dbms close cursor count_r232_rt020C
    }
    if (dm_is_cursor("count_r235_rt020C") == TRUE) {
        dbms close cursor count_r235_rt020C
    }
    call bu_cdbi_cursor_delete("r115", "")
    call bu_cdbi_cursor_delete("r025", "")


    // Druck Kommissionierung
    if ( \
        rt020_R_KOMM_DRUCK(2, 1)    >= "1" || \
        rt020_R_KOMM_DRUCK_VA(2, 1) >= "1" \
    ) {
        fertKommL = FALSE
        versKommL = FALSE

        // Start nur, wenn auch Sätze für VA/Fertigung erstellt wurden
        call sm_n_1clear_array("stringtab")

        dbms alias stringtab
        dbms sql \
            select distinct \
                l820.kn_komm_nr \
            from \
                l820 \
            where \
                l820.fi_nr = :+FI_NR1 and \
                l820.bearb = :+bearbRt020
        dbms alias

        for i1L = 1 while (i1L <= stringtab->num_occurrences) step 1 {
            // Versorgung
            if ( \
                stringtab[i1L](1, 1) == "1" && \
                rt020_R_KOMM_DRUCK_VA(2, 1) >= "1" \
            ) {
                versKommL = TRUE
            }
            // Fertigung
            if ( \
                stringtab[i1L](1, 1) == "2" && \
                rt020_R_KOMM_DRUCK(2, 1) >= "1" \
            ) {
                fertKommL = TRUE
            }
        }

        if ( \
            fertKommL == TRUE || \
            versKommL == TRUE \
        ) {
            // Aufruf rr722 mit jobid
            inTransL = FALSE

            call sm_n_1clear_array("partab")
            partab[11] = "0"            // Druck Komm-Liste
            partab[13] = "3"            // Start über jobid/bearbRt020
            partab[14] = "0"            // "1", wenn R_VA_LS == "1"
            partab[15] = LANG_EXT
            partab[16] = bearbRt020

            // Druck über Kommissionierbereiche?
            if ( \
                rt020_R_KOMM_DRUCK(3, 1)    == "1" || \
                rt020_R_KOMM_DRUCK_VA(3, 1) == "1" \
            ) {
                partab[18] = "1"
            }
            else {
                partab[18] = "0"
            }

            if (SQL_IN_TRANS != TRUE) {
                if (bu_begin() != OK) {
                    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
                    return FAILURE
                }
                inTransL = TRUE
            }

            call bu_job("rr722", NULL, NULL, NULL, NULL, NULL, "!l")

            if (inTransL == TRUE) {
                call bu_commit()
            }
        }
    }

    public rq1004.bsl
    call verknuepfungRq1004Unload()
    unload rq1004.bsl

    kontext_cacheL = name_cdtTermGlobal_rt020
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    // q-Module der Terminierung entladen
    call fertig_unload_terminierungsmodule($NULL, kontext_cacheL)

    call sm_ldb_h_unload(handle)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno eines Fertigungsauftrags
# - Lesen und Prüfen Fertigungsauftrag
# - Freigabe des Fertigungsauftrags
# - Protokollierung, wenn ok und Parameter gesetzt
#
# Returns: FAILURE, WARNING, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_freigabe(handleP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
    call rt020_receive_rt020()

    // Auftragsfreigabe wird durchgeführt
    call bu_msg("ral00117")

    // Prüfen "fu_freig"
    if ( \
        rt020_fu_freig != "4" && \
        rt020_fu_freig != "1" \
    ) {
        // Falscher Funktionscode bei Aufruf Modul %s
        call on_error(FAILURE, "ral00901", "rt020", "rt020_proto")
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Lesen und Prüfen Fertigungsauftrag
    rcL = rt020_get()
    if (rcL != OK) {
        dbms close cursor rt020_lock_r000
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    // Gm300 aktivieren
    if (rt020_load_gm300(fi_nr, rt020_werk) != OK) {
        dbms close cursor rt020_lock_r000
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Seriennummern generieren (falls erforderlich)
    if (cod_aart_versorg(rt020_aart) != TRUE) {
        if (rt020_serienverwaltung() < OK) {
            dbms close cursor rt020_lock_r000
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    // Freigabe Fertigungsauftrag
    if (rt020_fa() < OK) {
        dbms close cursor rt020_lock_r000
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Protokollierung, wenn per Parameter gewünscht
    if (prt_ok == TRUE) {
        // Initialisierung der globalen Message-Felder für die OK-Meldung
        call fertig_fehler_init_globale_felder(TRUE)
        if (rt020_proto(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
            dbms close cursor rt020_lock_r000
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    dbms close cursor rt020_lock_r000
    msg d_msg ""
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno eines Fertigungsmaterials
# - Lesen und Prüfen Fertigungsmaterial
# - Freigabe des Fertigungsmaterials
# - Protokollierung, wenn ok und Parameter gesetzt
#
# Returns: FAILURE, WARNING, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_freigabe_mat(handleP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
    call rt020_receive_rt020_mat()

    // Materialfreigabe wird durchgeführt
    call bu_msg("ral00118")

    // Prüfen "fu_freig"
    if ( \
        rt020_fu_freig_mat != "4" && \
        rt020_fu_freig_mat != "1" \
    ) {
       // Falscher Funktionscode bei Aufruf Modul %s
        call on_error(FAILURE, "ral00901", "rt020", "rt020_proto_mat")
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Lesen und Prüfen Fertigungsmaterial
    rcL = rt020_get_mat(FALSE)
    if (rcL != OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    // Gm300 aktivieren
    if (rt020_load_gm300(fi_nr, rt020_werk_mat) != OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Freigabe Fertigungsmaterial
    if (rt020_mat() < OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Protokollierung, wenn per Parameter gewünscht
    if (prt_ok == TRUE) {
        // Initialisierung der globalen Message-Felder für die OK-Meldung
        call fertig_fehler_init_globale_felder(TRUE)

        if (rt020_proto_mat(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
            dbms close cursor rt020_lock_r100
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    dbms close cursor rt020_lock_r100
    msg d_msg ""
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno eines Fertigungsarbeitsgangs
# - Lesen und Prüfen Fertigungsarbeitsgang
# - Freigabe des Fertigungsarbeitsgangs
# - Protokollierung, wenn ok und Parameter gesetzt
#
# Returns: FAILURE, WARNING, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_freigabe_ag(handleP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)
    call rt020_receive_rt020_ag()

    // Arbeitsgangfreigabe wird durchgeführt
    call bu_msg("ral00119")

    // Prüfen "fu_freig"
    if ( \
        rt020_fu_freig_ag != "4" && \
        rt020_fu_freig_ag != "1" \
    ) {
        // Falscher Funktionscode bei Aufruf Modul %s
        call on_error(FAILURE, "ral00901", "rt020", "rt020_proto_ag")
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Lesen und Prüfen Fertigungsarbeitsgang
    rcL = rt020_get_ag()
    if (rcL != OK) {
        dbms close cursor rt020_lock_r200
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    // Freigabe Fertigungsarbeitsgang
    if (rt020_ag() < OK) {
        dbms close cursor rt020_lock_r200
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Protokollierung, wenn per Parameter gewünscht
    if (prt_ok == TRUE) {
        // Initialisierung der globalen Message-Felder für die OK-Meldung
        call fertig_fehler_init_globale_felder(TRUE)
        if (rt020_proto_ag(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
            dbms close cursor rt020_lock_r200
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    dbms close cursor rt020_lock_r200
    msg d_msg ""
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Returns: FAILURE, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_update_protokoll_erg(fklzP, verarb_ergP)
{
    // Ergebnis in Protokollsätzen updaten
    if (dm_is_cursor("rt020_u_r026") != TRUE) {
        dbms declare rt020_u_r026 cursor for \
            update \
                r026 \
            set \
                r026.verarb_erg = ::_1 \
            where \
                r026.fi_nr = ::_2 and \
                r026.jobid = ::_3 and \
                r026.fklz  = ::_4
    }
    dbms with cursor rt020_u_r026 execute using \
        verarb_ergP, \
        FI_NR1, \
        JOBID, \
        fklzP

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Ansteuerung Protokollierung Fertigungsauftrag vom rufenden Programm aus
#
# Returns: FAILURE, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_protokoll(handle, KANBAN, prt_ctrlP)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    call rt020_receive_rt020()

    // lesen Fertigungsauftrag für Protokollierung
    if (rt020_sel_r000() < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    if (KANBAN == TRUE) {
        if (rt020_proto_kb($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
            call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }
    else {
        if (rt020_proto($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
            call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
            return FAILURE
        }
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Ansteuerung Protokollierung Fertigungsmaterial vom rufenden Programm aus
#
# Returns: FAILURE, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_protokoll_mat(handle, string prt_ctrlP)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    call rt020_receive_rt020_mat()

    // lesen Material für Protokollierung
    if (rt020_sel_r100() < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    if (rt020_proto_mat($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Ansteuerung Protokollierung Fertigungsarbeitsgang vom rufenden Programm aus
#
# Returns: FAILURE, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_protokoll_ag(handle, string prt_ctrlP)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)

    call rt020_receive_rt020_ag()

    // lesen Arbeitsgang für Protokollierung
    if (rt020_sel_r200() < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    if (rt020_proto_ag($NULL, prt_ctrlP, $NULL, $NULL) < OK) {
        call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Prüfen Fertigungsauftrag
# - Fertigungsauftrag lesen mit Satzschutz
# - Prüfung, ob Freigabe Fertigungsauftrag möglich
#   . Status darf nicht "0" sein
#   . Status darf nicht "2" sein
#   . fu_freig = "4" --> Status muß "3" sein
#   . fu_freig = "1" --> Status muß "4" sein
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get()
{
    int rcL

    // Lesen Fertigungsauftrag mit Satzschutz
    rcL = rt020_get_r000()
    if (rcL != OK) {
        return rcL
    }

    // Prüfung Fertigungstatus
    if (rt020_fkfs == FSTATUS_SIM) {
        // Fertigungsstatus darf nicht 0 sein
        return on_error(WARNING, "r0000233", "", "rt020_proto_kb")
    }

    if (rt020_fkfs == FSTATUS_AUSGESETZT) {
        // Fertigungsstatus darf nicht 2 sein
        return on_error(WARNING, "r0000234", "", "rt020_proto_kb")
    }

    if (rt020_fu_freig == "4" && rt020_fkfs != FSTATUS_TERMINIERT) {
        // Fertigungsstatus muß 3 sein
        return on_error(WARNING, "r0000207", "", "rt020_proto_kb")
    }

    if (rt020_fu_freig == "1" && rt020_fkfs != FSTATUS_FREIGEGEBEN) {
        // Fertigungsstatus muß 4 sein
        return on_error(WARNING, "r0000208", "", "rt020_proto_kb")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Prüfen Fertigungsmaterial
# - Fertigungsmaterial lesen mit Satzschutz
# - Prüfung, ob Freigabe Fertigungsmaterial möglich
#   . Status darf nicht "0" sein
#   . Status darf nicht "2" sein
#   . fu_freig = "4" --> Status muß "3" sein, bzw. "4" bei Aufruf der Zusatzfunktionen Freigabe Mat
#   . fu_freig = "1" --> Status muß "4" sein
#                    --> Status muß "7" sein bei Schüttgut
#
# Funktionsparameter:
# zusatzP - TRUE - Lesen und nach Verarbeitung der Materialfreigabe zur Reservierung / Storno-Reservierung
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_mat(boolean zusatzP)
{
    int rcL


    // Lesen Fertigungsmaterial mit Satzschutz
    rcL = rt020_get_r100()
    if (rcL != OK) {
        return rcL
    }

    // Prüfung Materialstatus
    if (rt020_fmfs == FSTATUS_SIM) {
        // Materialstatus darf nicht 0 sein
        return on_error(WARNING, "r1000214", "", "rt020_proto_mat")
    }

    if (rt020_fmfs == FSTATUS_AUSGESETZT) {
        // Materialstatus darf nicht 2 sein
        return on_error(WARNING, "r1000215", "", "rt020_proto_mat")
    }

    if ( \
        rt020_fu_freig_mat == "4" && \
        ( \
            ( \
                zusatzP    == TRUE && \
                rt020_fmfs != FSTATUS_RESERVIERT \
            ) || \
            ( \
                zusatzP    != TRUE && \
                rt020_fmfs != FSTATUS_DISPONIERT && \
                ( \
                    rt020_fmfs      != FSTATUS_RESERVIERT || \
                    rt020_menge_res <= 0 \
                ) \
            ) \
        ) \
    ) {
        // Materialstatus muß 3 sein
        return on_error(WARNING, "r1000200", "", "rt020_proto_mat")
    }

    if (rt020_fu_freig_mat == "1") {
        if ( \
            cod_kzmat_kosten(rt020_kzmat) == TRUE && \
            rt020_fmfs != FSTATUS_RESERVIERT \
        ) {
            // Materialstatus muß 4 sein
            return on_error(WARNING, "r1000201", "", "rt020_proto_mat")
        }

        if ( \
            cod_kzmat_schuettgut(rt020_kzmat) == TRUE && \
            rt020_fmfs != FSTATUS_ENTNOMMEN \
        ) {
            // Materialstatus muß 7 sein
            return on_error(WARNING, "r1000208", "", "rt020_proto_mat")
        }

        // Ist die Kommissionierliste schon freigegeben (gedruckt, [teil-]entnommen), darf nicht mehr storniert werden.
        if ( \
            komm_nrRt020 != "" && \
            st_komm_nrRt020 >= L_ST_KOMMAENDRt020 \
        ) {
            if (cod_aart_versorg(rt020_aart) == TRUE) {
                // Die Freigabe des Versorgungsauftrags kann nicht storniert
                // werden, da er einer freigegebenen Kommissionierliste zugeordnet ist!
                return on_error(WARNING, "r7200117", "", "rt020_proto_mat")
            }
            else {
                // Die Freigabe des Fertigungsmaterials kann nicht storniert werden,
                // da es einer freigegebenen Kommissionierliste zugeordnet ist!
                return on_error(WARNING, "r1000165", "", "rt020_proto_mat")
            }
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Prüfen Fertigungsarbeitsgang
# - Fertigungsarbeitsgang lesen mit Satzschutz
# - Arbeitsplatzdaten lesen (kn_sammel_lhs)
# - Prüfung, ob Freigabe Fertigungsarbeitsgang möglich
#   . Status darf nicht "0" sein
#   . Status darf nicht "2" sein
#   . fu_freig = "4" --> Status muß "3" sein
#   . fu_freig = "1" --> Status muß "4" sein
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_ag()
{
    int rcL

    // Lesen Fertigungsarbeitsgang mit Satzschutz
    rcL = rt020_get_r200()
    if (rcL != OK) {
        return rcL
    }

    // Lesen Arbeitsplatzdaten
    rcL = rt020_sel_f300()
    if (rcL != OK) {
        return rcL
    }

    // Prüfung Arbeitsgangstatus
    if (rt020_fafs == "0") {
        // Arbeitsgangstatus darf nicht 0 sein
        return on_error(WARNING, "r2000233", "", "rt020_proto_ag")
    }

    if (rt020_fafs == "2") {
        // Arbeitsgangstatus darf nicht 2 sein
        return on_error(WARNING, "r2000234", "", "rt020_proto_ag")
    }

    if (rt020_fu_freig_ag == "4" && rt020_fafs != "3") {
        // Arbeitsgangstatus muß "3" sein
        return on_error(WARNING, "r2000200", "", "rt020_proto_ag")
    }

    if (rt020_fu_freig_ag == "1" && rt020_fafs != "4") {
        // Arbeitsgangstatus muß "4" sein
        return on_error(WARNING, "r2000201", "", "rt020_proto_ag")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Aufruf lq080 zur Batchgenerierung von Seriennummern
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_serienverwaltung()
{
    double benoetigtL
    boolean n_benoetigte_loeschenL


    // Keine sinnvolle Menge?
    if (rt020_menge_brutto < 0.0) {
        return OK
    }

    if (cod_aart_reparatur(rt020_aart) == TRUE) {
        return OK
    }

    if (rt020_fu_freig == "1") {
        // Bei Stornierung der Freigabe kann die Zuordnung zu bereits generierten Seriennummern aufgehoben werden.
        benoetigtL = 0.0
        // Bei Stornierung der Freigabe können bereits generierte Seriennummern gelöscht werden.
        n_benoetigte_loeschenL = rt020_R_SERIE_STORNO == "0"
    }
    else {
        // Ansonsten muss die benötigte Menge berücksichtigt werden.
        benoetigtL = rt020_menge_brutto
    }

    // Abgleich durchführen
    if ( \
        fertig_abgleich_seriennummern( \
            rt020_identnr, \
            rt020_var, \
            rt020_lgnr, \
            rt020_aufnr, \
            rt020_aufpos, \
            rt020_fklz, \
            @to_int(benoetigtL), \
            n_benoetigte_loeschenL \
        ) != OK \
    ) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno Fertigungsauftrag
# - Anstoß Druck Fertigungspapiere
# - Anstoß Materialbereitstellung
# - Übergabe an Werkstattsteuerung
# - Fertigungsstatus  auf "4" bzw. "3" setzen
# - Freigabestatus in Kundenauftragsposition aktualisieren
# - Uebergabe an Werkstattsteuerung
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_fa()
{
    int     rcL
    vars    rq000L
    boolean mit_speichernL = TRUE

    // Nicht für Versorgungsaufträge
    if (cod_aart_versorg(rt020_aart) != TRUE) {
        // Anstoß Druck FA-Papiere
        if (rt020_druck() < OK) {
            return FAILURE
        }

        // Anstoß Materialbereitstellung
        if (rt020_bereitstellung() < OK) {
            return FAILURE
        }
    }

    // Setzen FA-Status inkl. Update Fertigungsauftrag (r000)
    public rq000.bsl
    rq000L = rq000_new(boa_cdt_get(name_cdtTermGlobal_rt020), FI_NR1, rt020_fklz, $NULL)

    call rq000_set_fklz(rq000L, rt020_fklz)
    call rq000_set_fi_nr(rq000L, FI_NR1)
    call rq000_set_fkfs(rq000L, rt020_fkfs)
    call rq000_set_aart(rq000L, rt020_aart)
    call rq000_set_freigabe(rq000L, rt020_freigabe)
    call rq000_set_clear_message(rq000L, TRUE)

    rcL = rq000_setzen_status_freigabe(rq000L, rt020_fu_freig, mit_speichernL)
    switch (rcL) {
        case OK:     // Status wurde geändert
            rt020_fkfs = rq000_get_fkfs(rq000L)
            break
        case INFO:  // Status wurde nicht geändert
            break
        case WARNING:
        case FAILURE:
        else:
            if (BATCH != TRUE) {
                call rq000_ausgeben_meldungen(rq000L, BU_0, TRUE, TRUE)
            }

            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "r000", "rt020_proto")
    }


    // Kanbanauftragsdaten aktualisieren
    if (rt020_set_kanban() < OK) {
        return FAILURE
    }

    // Freigabestatus in Kundenauftragsposition aktualisieren
    if (rt020_uebg() < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno Fertigungsmaterial
# - Unterscheidung nach Schüttgutkennzeichen
#   . für "kzmat" <= "5" (Kosten) wird der Reservierungsbestand verändert
#     Der Materialstatus geht auf "4" bzw. "3"
#   . für "kzmat" >= "5" (Schüttgut) geht der Materialstatus auf "7" bzw. "3" und
#     das Material gilt als entnommen.
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_mat()
{
    // Ggf. Initialisierung des Kennzeichens für die Feinplanung
    if (rt020_kn_ws_mat == "") {
        rt020_kn_ws_mat = KN_WS_KEINE
    }

    // kein Schüttgut
    if (cod_kzmat_kosten(rt020_kzmat) == TRUE) {
        // Setzen Materialstatus
        if (rt020_fu_freig_mat == "4") {
            rt020_fmfs = FSTATUS_RESERVIERT
        }
        else if (rt020_fu_freig_mat == "1") {
            rt020_fmfs = FSTATUS_DISPONIERT
        }
    }

    // Schüttgut
    if (cod_kzmat_schuettgut(rt020_kzmat) == TRUE) {
        // Schüttgutentnahme wenn keine Versorgung
        if (!cod_aart_versorg(rt020_aart)) {
            if (rt020_schuettgut() < OK) {
                return FAILURE
            }

            // Setzen Materialstatus
            switch (rt020_fu_freig_mat) {
                case "4":
                    rt020_fmfs = FSTATUS_ENTNOMMEN
                    break
                case "1":
                    rt020_fmfs = FSTATUS_DISPONIERT
                    break
            }
        }
        else {
            // Setzen Materialstatus
            switch (rt020_fu_freig_mat) {
                case "4":
                    rt020_fmfs = FSTATUS_RESERVIERT
                    break
                case "1":
                    rt020_fmfs = FSTATUS_DISPONIERT
                    break
            }
        }
    }

    // Ticket 3001745:
    // Weder Kosten noch Schüttgut => immer freigeben
    if ( \
        cod_kzmat_kosten(rt020_kzmat) != TRUE && \
        cod_kzmat_schuettgut(rt020_kzmat) != TRUE \
    ) {
        // Setzen Materialstatus
        switch (rt020_fu_freig_mat) {
            case "4":
                rt020_fmfs = FSTATUS_RESERVIERT
                break
            case "1":
                rt020_fmfs = FSTATUS_DISPONIERT
                break
        }
    }

    // Update Material
    if (rt020_update_r100() < OK) {
        return FAILURE
    }

    // Update Lagerstamm
    if (rt020_update_g020() < OK) {
        return FAILURE
    }

    // Setzen d205-Satz auf Eilbestellung, wenn ein Versorgungsauftrag mit kn_sobe = 3 (Eilbestellung) freigegeben wird
    if ( \
        rt020_pos_herk == "6" && \
        rt020_fmfs     == FSTATUS_RESERVIERT && \
        rt020_kn_sobe  == "3" \
    ) {
        if (rt020_set_d205() < OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe/ Freigabestorno Fertigungsarbeitsgang
# - sofern AG mit Zeiten
#   . Periodenbelastung umlasten, sofern AG mit Zeiten
#   . Übergabe an Werkstattsteuerung,
# - Arbeitsgangstatus auf "4" bzw. "3" setzen
# - Freigabe für Betriebsmittel durchführen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_ag()
{
    int    anzahlL
    int    bestposL
    int    kontoL
    string bestnrL
    string whereL   = ""
    string usingL   = "rt020_falz"


    if (rt020_uebergeben_an_werkstattsteuerung() != OK) {
        return FAILURE
    }

    // setzen Arbeitsgang-Status
    if (rt020_fu_freig_ag == "4") {
        rt020_fafs = FSTATUS_FREIGEGEBEN
    }
    else if (rt020_fu_freig_ag == "1") {
        rt020_fafs = FSTATUS_TERMINIERT
    }

    // Für Fremdarbeitsgänge prüfen, ob evtl. schon Bestellpositionen vorhanden sind -> wenn ja, Status "4" ==> "5"
    // 300145076
    // Status des AG = "5" setzen, wenn eine Bestellposition vorhanden ist
    if (cod_agbs_fremd(rt020_agbs) == TRUE) {
        if (bFirmenkopplungRt020 == "0") {
            whereL   = " and e110.fi_nr = ::fi_nr "
            usingL ##= ", fi_nr"
        }
        else {
            whereL   = " and e110.fi_nr > 0 "
        }

        if (dm_is_cursor("rt020_cur_agbest") != TRUE) {
            dbms declare rt020_cur_agbest cursor for \
                select \
                    e110.bestnr, \
                    e110.bestpos, \
                    e100.konto \
                from \
                    e110, \
                    e100 \
                where \
                    e110.falz   = ::_1 and \
                    e100.fi_nr  = e110.fi_nr and \
                    e100.bestnr = e110.bestnr \
                    :whereL
            dbms with cursor rt020_cur_agbest alias \
                bestnrL, \
                bestposL, \
                kontoL
        }
        dbms with cursor rt020_cur_agbest execute using :usingL

        if (bestnrL           != "" \
        &&  rt020_fafs        == FSTATUS_FREIGEGEBEN \
        &&  rt020_fu_freig_ag == "4") {
            anzahlL = rt020_falz_best->num_occurrences
            if (anzahlL <= 0) {
                anzahlL = 1
            }
            rt020_falz_best[anzahlL]     = rt020_falz
            rt020_werk_best[anzahlL]     = rt020_werk
            rt020_konto_best[anzahlL]    = kontoL
            rt020_kostst_best[anzahlL]   = rt020_kostst
            rt020_arbplatz_best[anzahlL] = rt020_arbplatz
            rt020_bestnr_best[anzahlL]   = bestnrL
            rt020_bestpos_best[anzahlL]  = bestposL
        }
    }

    // Update Arbeitsgang
    if (rt020_update_r200() < OK) {
        return FAILURE
    }

    // Freigabe der Betriebsmittel zum Arbeitsgang durchführen
    if (rt020_betriebsmittel() < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Schuettgutentnahme
# - Entnahmemenge errechnen
# - Nachkalkulation Schüttgut (WARNING --> FAILURE)
# - Entnahme verbuchen im Material
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_schuettgut()
{
    int  rcL
    vars rt020_handle
    vars kt431_handle


    // Entnahmemenge errechnen
    if (rt020_fu_freig_mat == "4") {
        rt020_menge_ent_meld = rt020_menge_offen
    }
    else if (rt020_fu_freig_mat == "1") {
        rt020_menge_ent_meld = rt020_menge_ent
    }

    rt020_kt431_handle = bu_load_tmodul("kt431", rt020_kt431_handle)
    if (rt020_kt431_handle < 0) {
        // Bei Bedarf Transaktion schliessen
        if (SQL_IN_TRANS == TRUE) {
            call bu_rollback()
        }
        return FAILURE
    }

    // Aufruf Nachkalkulation Schüttgut
    // WARNING soll nicht in FAILURE umgewandelt werden
    warn_2_failRt020 = warn_2_fail
    warn_2_fail    = FALSE

    call rt020_send_kt431()

    rt020_handle = rt020_rt020_handle
    kt431_handle = rt020_kt431_handle

    call sm_ldb_h_state_set(rt020_handle, LDB_ACTIVE, FALSE)

    // auch bei r000.kalk gleich 5 Istkosten berechnen!
    rcL = kt431_nachkalk_mat(kt431_handle, TRUE)

    call sm_ldb_h_state_set(rt020_handle, LDB_ACTIVE, TRUE)

    if (rcL < OK) {
        // Bei Bedarf Transaktion schliessen
        if (SQL_IN_TRANS == TRUE) {
            call bu_rollback()
        }

        // Fehler bei Nachkalkulation Schüttgut
        call on_error(OK, "r1000502", "", "rt020_proto_mat")
        warn_2_fail = warn_2_failRt020
        return FAILURE
    }
    else if (rcL != OK) {
        // Hinweis bei Nachkalkulation Schüttgut
        call on_error(OK, "r1000512", "", "rt020_proto_mat")
    }

    warn_2_fail = warn_2_failRt020

    // Entnahme verbuchen im Material
    // 20040629 BEB
    if (rt020_fu_freig_mat == "4") {
        rt020_menge_ent   = rt020_menge_offen
        rt020_menge_offen = 0
        rt020_menge_dis   = 0

        call gm300_activate(rt020_handle_gm300)
        call gm300_init()
        opcodeGm300E = "today"

        // Datum ermitteln
        if (gm300_datum() != OK) {
            call bu_msg_errmsg("Gm300")
            call gm300_deactivate(rt020_handle_gm300)
            return on_error(FAILURE, "", "", "rt020_proto")
        }

        rt020_rueck_dat = datumGm300A
        call gm300_deactivate(rt020_handle_gm300)
    }
    else if (rt020_fu_freig_mat == "1") {
        rt020_menge_ent   = 0
        rt020_menge_offen = rt020_menge
        rt020_menge_dis   = rt020_menge
        rt020_rueck_dat   = ""
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Erhöhen bzw. Vermindern Reservierungsbestand je nach fu_freig
# - Reservierungsbestand erhöhen bzw. vermindern
# - Update Lagerstamm 0
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_reservierung()
{
    int rcL

    // Physische Reservierung durchführen
    rcL = rt020_lm100_reservierung()
    if (rcL < OK) {
        return on_error(rcL)
    }

    // Mengen berechnen
    if (rt020_fu_freig_mat == "4") {
        rt020_menge_dis    = rt020_menge_dis - rt020_menge_res_lm100
        rt020_menge_res    = rt020_menge_res + rt020_menge_res_lm100
        rt020_reserve_diff = rt020_menge_dis
        rt020_vormerk_diff = (-1) * rt020_menge_res_lm100
    }
    else if (rt020_fu_freig_mat == "1") {
        // Auch menge_dis und menge_res müssen bei der Stornierung korrigiert werden
        rt020_reserve_diff = (-1) * rt020_menge_dis
        rt020_vormerk_diff = rt020_menge_res_lm100
        rt020_menge_dis = rt020_menge_dis + rt020_menge_res_lm100
        rt020_menge_res = rt020_menge_res - rt020_menge_res_lm100
    }

    if ( \
        rt020_kn_sobe == "1" || \
        rt020_kn_sobe == "2" \
    ) {
        rt020_vormerk_diff = 0
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabe aller Betriebsmittel zu einem Fertigungsarbeitsgang
# - Cursor über alle Betriebsmittel eines Fertigungsarbeitsgangs, die
#   noch nicht verarbeitet wurden
# - Positionen einzeln verarbeiten
#   . Fertigungsbetriebsmittel lesen
#   . Betriebsmittelstatus setzen
#   . Fertigungsbetriebsmittel updaten
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_betriebsmittel()
{
    string where_bm


    // where-Bedingung
    if (rt020_fu_freig_ag == "4") {
        where_bm = " and r500.bmfs = '3' "
    }
    if (rt020_fu_freig_ag == "1") {
        where_bm = " and r500.bmfs = '4' "
    }

    // Cursor über alle Betriebsmittel zum Fertigungsarbeitsgang
    dbms declare rt020_freig_bm cursor for \
        select \
            r500.lfdnr \
        from \
            r500 \
        where \
            r500.fi_nr = :+FI_NR1 and \
            r500.falz  = :+rt020_falz \
            :where_bm \
        order by \
            r500.lfdnr
    dbms with cursor rt020_freig_bm alias rt020_lfdnr
    dbms with cursor rt020_freig_bm execute

    while (SQL_CODE == SQL_OK) {
        // Fertigungsbetriebsmittel lesen
        if (rt020_get_r500() < OK) {
            dbms close cursor rt020_lock_r500
            dbms with cursor rt020_freig_bm alias
            dbms close cursor rt020_freig_bm
            return FAILURE
        }

        // setzen Betriebsmittel-Status
        if (rt020_fu_freig_ag == "4") {
            rt020_bmfs = "4"
        }
        else if (rt020_fu_freig_ag == "1") {
            rt020_bmfs = "3"
        }

        // Update Betriebsmittel
        if (rt020_update_r500() < OK) {
            dbms close cursor rt020_lock_r500
            dbms with cursor rt020_freig_bm alias
            dbms close cursor rt020_freig_bm
            return FAILURE
        }
        dbms close cursor rt020_lock_r500
        dbms with cursor rt020_freig_bm continue
    }

    if (SQL_CODE != SQLNOTFOUND) {
        dbms with cursor rt020_freig_bm alias
        dbms close cursor rt020_freig_bm
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r500", "rt020_proto_bm")
    }

    dbms with cursor rt020_freig_bm alias
    dbms close cursor rt020_freig_bm

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Anstoß Druck Fertigungspapiere
# - fu_freig == "4"
#   Schreiben Aktionssatz Druck FA-Papiere in Tabelle r065
# - fu_freig == "1"
#   Löschen Aktionssatz Druck FA-Papiere aus Tabelle r065
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_druck()
{
    // Schreiben oder Löschen abhängig von fu_freig
    if (rt020_fu_freig == "4") {
        if (rt020_insert_r065() < OK) {
            return FAILURE
        }
    }
    else if (rt020_fu_freig == "1") {
        if (rt020_delete_r065() < OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Anstoß Materialbereitstellung bei Freigabe und wenn Parameter ent-
# sprechend sitzt durch Einfügen Satz in Tabelle r035
# - "nr" vergeben durch "select (max) + 1"
# - Insert
# - solange DUPKEY, weiter hochzählen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_bereitstellung()
{
    vars dupkey


    // nur, wenn Freigabe und Parameter entsprechend sitzt
    if ( \
        rt020_fu_freig != "4" || \
        rt020_matbuch != "1" \
    ) {
        return OK
    }

    // "nr" vergeben
    if (!dm_is_cursor("rt020_read_r035")) {
        dbms declare rt020_read_r035 cursor for \
            select \
                max(r035.nr) \
            from \
                r035 \
            where \
                r035.fi_nr = ::_1
        dbms with cursor rt020_read_r035 alias rt020_nr_r035
    }
    dbms with cursor rt020_read_r035 execute using FI_NR1

    if (rt020_nr_r035 == "") {
        rt020_nr_r035 = 0
    }

    // Satz einfügen, bei "DUPKEY" wird geschleift
    dupkey = TRUE
    while (dupkey == TRUE) {
        rt020_nr_r035 = rt020_nr_r035 + 1

        // 20040629 BEB
        call gm300_activate(rt020_handle_gm300)
        call gm300_init()
        opcodeGm300E = "today"

        // Datum ermitteln
        if (gm300_datum() != OK) {
            call bu_msg_errmsg("Gm300")
            call gm300_deactivate(rt020_handle_gm300)
            return on_error(FAILURE, "", "", "rt020_proto")
        }

        rt020_rueck_dat = datumGm300A
        call gm300_deactivate(rt020_handle_gm300)

        call bu_noerr()

        dbms sql \
            insert into \
                r035 \
            ( \
                r035.datuhr, \
                r035.fi_nr, \
                r035.werk, \
                r035.logname, \
                r035.tty, \
                r035.maske, \
                r035.nr, \
                r035.fklz, \
                r035.aufnr, \
                r035.aufpos, \
                r035.disstufe, \
                r035.fu_matrm, \
                r035.fu_agrm, \
                r035.fu_farm, \
                r035.menge, \
                r035.rueck_dat, \
                r035.jobid, \
                r035.art_matrm \
            ) \
            values ( \
                :CURRENT, \
                :+FI_NR1, \
                :+rt020_werk, \
                :+LOGNAME, \
                :+TTY, \
                :+screen_name, \
                :+rt020_nr_r035, \
                :+rt020_fklz, \
                :+rt020_aufnr, \
                :+rt020_aufpos, \
                :+rt020_disstufe, \
                '8', \
                :+NULL, \
                :+NULL, \
                :+rt020_menge_brutto, \
                :+rt020_rueck_dat, \
                0, \
                'R' \
            )

        if (SQL_CODE == SQLE_DUPKEY) {
            next
        }
        if (SQL_CODE != SQL_OK) {
            // Fehler beim Einfügen in Tabelle >%s<.
            return on_error(FAILURE, "APPL0003", "r035", "rt020_proto")
        }

        dupkey = FALSE
    }

    if (rt020_R_MATBUCH_START == "1") {
        call sm_n_1clear_array("partab")
        partab[1] = LOGNAME
        partab[7] = rt020_fklz
        call bu_job("rh035", NULL, NULL)
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Aktualisieren des Freigabekennzeichens in den Kundenauftragspositionen
# zu den übergeordneten Bedarfen
# - nur bei Auftragsart "K" (Kundenaufträge)
# - nur bei Freigabe oder Stornierung
# - lesen aller übergeordneten Materialien zum Fertigungsauftrag
# - Aktualisieren des Freigabekennzeichens in der Kundenauftragsposition
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_uebg()
{
    // nur bei Auftragsart "K" (Kundenauftrag) und Versorgungsaufträgen
    if ( \
        rt020_aart != "1" && \
        rt020_aart != "9" \
    ) {
        return OK
    }

    // nur bei Freigabe oder Stornierung
    if ( \
        rt020_fu_freig != "4" && \
        rt020_fu_freig != "1" \
    ) {
        return OK
    }

    // Cursor über alle übergeordneten Materialien zum Fertigungsauftrag
    dbms declare rt020_mat_uebg cursor for \
        select \
            r100.fmlz \
        from \
            r100 \
        where \
            r100.fi_nr    = :+FI_NR1 and \
            r100.ufklz    = :+rt020_fklz and \
            r100.identnr  = :+rt020_identnr and \
            r100.var      = :+rt020_var and \
            r100.pos_herk = '4' \
        union \
        select \
            r100.fmlz \
        from \
            r100 \
        where \
            r100.fi_nr    = :+FI_NR1 and \
            r100.ufklz    = :+rt020_fklz and \
            r100.identnr  = :+rt020_identnr and \
            r100.var      = :+rt020_var and \
            r100.pos_herk = '5'
    dbms with cursor rt020_mat_uebg alias rt020_fmlz_uebg
    dbms with cursor rt020_mat_uebg execute

    while (SQL_CODE == SQL_OK) {
        // Aktualisierung des Freigabestatus in der Kundenauftragsposition
        if (rt020_status_uebg() < OK) {
            dbms close cursor rt020_mat_uebg
            return FAILURE
        }
        dbms with cursor rt020_mat_uebg continue
    }

    // Bei Versorgungsaufträgen keine Fehlermeldung
    if (SQL_CODE != SQLNOTFOUND && rt020_aart != "9") {
        dbms close cursor rt020_mat_uebg
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r100", "rt020_proto")
    }

    dbms close cursor rt020_mat_uebg

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Freigabestatus in Kundenauftragsposition setzen
# - bei Freigabe    --> "5"
# - bei Stornierung --> "4"
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_status_uebg()
{
    int    rcL
    string kn_freigabeL
    string stornoL


    // bei Freigabe "5", bei Stornierung "4"
    if (rt020_fu_freig == "4") {
        kn_freigabeL = "5"
        stornoL      = "0"
    }
    else {
        kn_freigabeL = "4"
        stornoL      = "1"
    }

    // Aufruf "vt110r_status"
    send bundle "b_vt110r_status" data \
        NULL, \
        NULL, \
        NULL, \
        rt020_fmlz_uebg, \
        kn_freigabeL, \
        stornoL, \
        rt020_fklz, \
        NULL

    rcL = vt110r_status(rt020_vt110r_handle)
    if (rcL < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Sperren Fertigungsauftrag
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_r000()
{
    vars lock

    dbms declare rt020_lock_r000 cursor for \
        select \
            r000.aufnr, \
            r000.aufpos, \
            r000.identnr, \
            r000.var, \
            r000.aart, \
            r000.fkfs, \
            r000.fsterm, \
            r000.seterm, \
            r000.disstufe, \
            r000.freigabe, \
            r000.matbuch, \
            (r000.menge + r000.menge_aus), \
            r000.werk, \
            r000.kanbannr, \
            r000.kanbananfnr, \
            r000.lgnr \
        from \
            r000 :MSSQL_FOR_UPDATE \
        where \
            r000.fi_nr = :+FI_NR1 and \
            r000.fklz  = :+rt020_fklz \
        :FOR_UPDATE
    dbms with cursor rt020_lock_r000 alias \
        rt020_aufnr, \
        rt020_aufpos, \
        rt020_identnr, \
        rt020_var, \
        rt020_aart, \
        rt020_fkfs, \
        rt020_fsterm, \
        rt020_seterm, \
        rt020_disstufe, \
        rt020_freigabe, \
        rt020_matbuch, \
        rt020_menge_brutto, \
        rt020_werk, \
        rt020_kanbannr, \
        rt020_kanbananfnr, \
        rt020_lgnr

    lock = TRUE
    while (lock == TRUE) {
        dbms with cursor rt020_lock_r000 execute

        if (SQL_CODE == SQLNOTFOUND) {
            dbms with cursor rt020_lock_r000 alias
            // Fertigungsauftrag %s nicht vorhanden
            return on_error(WARNING, "r0000000", rt020_fklz, "rt020_proto")
        }

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsauftrag %s von einem anderen Benutzer gesperrt
            call bu_msg("r0000002", rt020_fklz)
            next
        }

        if (SQL_CODE != SQL_OK) {
            dbms with cursor rt020_lock_r000 alias
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r000", "rt020_proto")
        }

        lock = FALSE
    }
    dbms with cursor rt020_lock_r000 alias

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen Fertigungsauftrag für Protokollierung
# - wenn nicht vorhanden, wird keine Meldung erzeugt
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_sel_r000()
{
    if (!dm_is_cursor("rt020_read_r000")) {
        dbms declare rt020_read_r000 cursor for \
            select \
                r000.aufnr, \
                r000.aufpos, \
                r000.identnr, \
                r000.var, \
                r000.aart, \
                r000.fkfs, \
                r000.fsterm, \
                r000.seterm,\
                r000.kanbannr, \
                r000.kanbananfnr, \
                r000.werk, \
                r000.lgnr \
            from \
                r000 \
            where \
                r000.fi_nr  = ::FI_NR1 and \
                r000.fklz   = ::rt020_fklz
        dbms with cursor rt020_read_r000 alias \
            rt020_aufnr, \
            rt020_aufpos, \
            rt020_identnr, \
            rt020_var, \
            rt020_aart, \
            rt020_fkfs, \
            rt020_fsterm, \
            rt020_seterm, \
            rt020_kanbannr, \
            rt020_kanbananfnr, \
            rt020_werk, \
            rt020_lgnr
    }
    dbms with cursor rt020_read_r000 execute using \
        FI_NR1, \
        rt020_fklz

    if (SQL_CODE == SQLNOTFOUND) {
        return WARNING
    }
    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r000", "rt020_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# - Lagersteuerungskennzeichen lesen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_sel_g020()
{
    if (!dm_is_cursor("rt020_read_g020")) {
        dbms declare rt020_read_g020 cursor for \
            select \
                g020.lgsteuer \
            from \
                g020 \
            where \
                g020.fi_nr   = ::_1 and \
                g020.identnr = ::_2 and \
                g020.var     = ::_3 and \
                g020.werk    = ::_4 and \
                g020.lgnr    = ::_5
       dbms with cursor rt020_read_g020 alias rt020_lgsteuer
    }
    dbms with cursor rt020_read_g020 execute using \
        FI_NR1, \
        rt020_identnr_mat, \
        rt020_var_mat, \
        rt020_werk_mat, \
        rt020_lgnr

    if (SQL_CODE == SQLNOTFOUND) {
        // Variantenstamm Werksbezug %s nicht vorhanden!
        return on_error(FAILURE, "g0230000", ":rt020_identnr-:rt020_var -- :rt020_werk", "rt020_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Sperren Fertigungsmaterial
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_r100()
{
    vars lock
    vars lgberG020L
    vars lgfachG020L


    // 20040629 BEB
    dbms declare rt020_lock_r100 cursor for \
        select \
            r100.fklz, \
            r100.stpos, \
            r100.stposlfd, \
            r100.vv_pos, \
            r100.aufnr, \
            r100.aufpos, \
            r100.identnr, \
            r100.var, \
            r100.fmfs, \
            r100.menge, \
            r100.menge_ent, \
            r100.menge_offen, \
            r100.menge_dis, \
            r100.menge_res, \
            r100.sbterm, \
            r100.kzmat, \
            r100.werk, \
            r100.lgnr, \
            r100.lgber, \
            r100.lgfach, \
            r100.charge, \
            r100.chargen_pflicht, \
            r100.kn_lgres, \
            r100.kn_ws, \
            r100.da, \
            r100.rueck_dat, \
            r100.kn_sobe, \
            r100.pos_herk, \
            r100.agpos \
        from \
            r100 :MSSQL_FOR_UPDATE \
        where \
            r100.fi_nr = :+FI_NR1 and \
            r100.fmlz  = :+rt020_fmlz \
        :FOR_UPDATE
    dbms with cursor rt020_lock_r100 alias \
        rt020_fklz, \
        rt020_stpos, \
        rt020_stposlfd, \
        rt020_vv_pos, \
        rt020_aufnr, \
        rt020_aufpos, \
        rt020_identnr_mat, \
        rt020_var_mat, \
        rt020_fmfs, \
        rt020_menge, \
        rt020_menge_ent, \
        rt020_menge_offen, \
        rt020_menge_dis, \
        rt020_menge_res, \
        rt020_sbterm, \
        rt020_kzmat, \
        rt020_werk_mat, \
        rt020_lgnr, \
        rt020_lgber, \
        rt020_lgfach, \
        rt020_charge, \
        rt020_chargen_pflicht, \
        rt020_kn_lgres, \
        rt020_kn_ws_mat, \
        rt020_da, \
        rt020_rueck_dat, \
        rt020_kn_sobe, \
        rt020_pos_herk, \
        rt020_agpos

    lock = TRUE
    while (lock == TRUE) {
        dbms with cursor rt020_lock_r100 execute

        if (SQL_CODE == SQLNOTFOUND) {
            dbms with cursor rt020_lock_r100 alias
            // Fertigungsmaterial %s nicht vorhanden
            return on_error(WARNING, "r1000000", rt020_fmlz, "rt020_proto_mat")
        }

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsmaterial %s von einem anderen Benutzer gesperrt
            call bu_msg("r1000002", rt020_fmlz)
            next
        }

        if (SQL_CODE != SQL_OK) {
            dbms with cursor rt020_lock_r100 alias
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r100", "rt020_proto_mat")
        }

        lock = FALSE
    }

    dbms with cursor rt020_lock_r100 alias

    if (dm_is_cursor("rt020_g020_mat") != TRUE) {
        vars fldDismengeL
        vars fromG023L
        vars whereG023L

        if (D_LAGER_BEZUG == "1") {
            fldDismengeL = " :SQL_DISMENGE"
        }
        else {
            fldDismengeL = " :SQL_DISMENGE_G023"
            fromG023L    = ", g023 "
            whereG023L   = " and g023.fi_nr   = g020.fi_nr " ## \
                           " and g023.werk    = g020.werk " ## \
                           " and g023.identnr = g020.identnr " ## \
                           " and g023.var     = g020.var"
        }

        dbms declare rt020_g020_mat cursor for \
            select \
                g020.lgber, \
                g020.lgfach, \
                :*fldDismengeL, \
                g020.lgsteuer \
            from \
                g020 \
                :fromG023L \
            where \
                g020.fi_nr   = ::_1 and \
                g020.werk    = ::_2 and \
                g020.lgnr    = ::_3 and \
                g020.identnr = ::_4 and \
                g020.var     = ::_5 \
                :whereG023L
        dbms with cursor rt020_g020_mat alias \
            lgberG020L, \
            lgfachG020L, \
            rt020_dismenge, \
            rt020_lgsteuer
    }
    dbms with cursor rt020_g020_mat execute using \
        FI_NR1, \
        rt020_werk_mat, \
        rt020_lgnr, \
        rt020_identnr_mat, \
        rt020_var_mat

    if (rt020_lgber == "") {
        rt020_lgber = lgberG020L
    }
    if (rt020_lgfach == "") {
        rt020_lgfach = lgfachG020L
    }
    if ( \
        L_LGBER_VORRt020 != "" && \
        rt020_lgsteuer > 0 \
    ) {
        rt020_lgber  = L_LGBER_VORRt020
        rt020_lgfach = L_LGFACH_VORRt020
    }

    if (rt020_fklz_meld != rt020_fklz) {
        // Übergebene Fertigungsauftragsleitzahl ist falsch!
        return on_error(FAILURE, "r0000114", "(:rt020_fklz_meld / :rt020_fklz)", "rt020_proto_mat")
    }

    if (!dm_is_cursor("rt020_r000_mat")) {
        dbms declare rt020_r000_mat cursor for \
            select \
                r000.chargen_pflicht, \
                r000.lgnr, \
                r000.aart \
            from \
                r000 \
            where \
                r000.fi_nr = ::_1 and \
                r000.fklz = ::_2
        dbms with cursor rt020_r000_mat alias \
            rt020_chargen_pflicht_r000, \
            rt020_lgnr_r000, \
            rt020_aart
    }
    dbms with cursor rt020_r000_mat execute using \
        FI_NR1, \
        rt020_fklz

    if (!dm_is_cursor("rt020_l820xxcur")) {
        // Sortierung über die st_komm_nr, da beim Storno bei mehreren zugeordneten Kommissionierlisten der höchste
        // Status relevant ist
        dbms declare rt020_l820xxcur cursor for \
            select \
                l82010.komm_nr, \
                l82010.lfdnr, \
                l820.kn_komm_nr, \
                l820.st_komm_nr \
            from \
                l82010, \
                l820 \
            where \
                l82010.fi_nr = ::_1 and \
                l82010.fmlz  = ::_2 and \
                l820.fi_nr   = l82010.fi_nr and \
                l820.komm_nr = l82010.komm_nr and \
                l820.st_komm_nr < '8' \
            union all \
            select \
                l82030.komm_nr, \
                l82030.lfdnr, \
                l820.kn_komm_nr, \
                l820.st_komm_nr \
            from \
                l82030, \
                l820 \
            where \
                l82030.fi_nr = ::_3 and \
                l82030.fmlz  = ::_4 and \
                l820.fi_nr   = l82030.fi_nr and \
                l820.komm_nr = l82030.komm_nr and \
                l820.st_komm_nr < '8' \
            order by \
                4
        dbms with cursor rt020_l820xxcur alias \
            komm_nrRt020, \
            lfdnrRt020, \
            kn_komm_nrRt020, \
            st_komm_nrRt020
    }
    dbms with cursor rt020_l820xxcur execute using \
        FI_NR1, \
        rt020_fmlz, \
        FI_NR1, \
        rt020_fmlz

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen Fertigungsmaterial für Protokollierung
# - wenn nicht vorhanden, wird keine Meldung erzeugt
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_sel_r100()
{
    if (!dm_is_cursor("rt020_read_r100")) {
        dbms declare rt020_read_r100 cursor for \
            select \
                r100.fklz, \
                r100.stpos, \
                r100.stposlfd, \
                r100.vv_pos, \
                r100.aufnr, \
                r100.aufpos, \
                r100.identnr, \
                r100.var, \
                r100.fmfs, \
                r100.menge, \
                r100.menge_offen, \
                r100.menge_dis, \
                r100.menge_res, \
                r100.sbterm \
            from \
                r100 \
            where \
                r100.fi_nr = ::_1 and \
                r100.fmlz  = ::_2
        dbms with cursor rt020_read_r100 alias \
            rt020_fklz, \
            rt020_stpos, \
            rt020_stposlfd, \
            rt020_vv_pos, \
            rt020_aufnr, \
            rt020_aufpos, \
            rt020_identnr_mat, \
            rt020_var_mat, \
            rt020_fmfs, \
            rt020_menge, \
            rt020_menge_offen, \
            rt020_menge_dis, \
            rt020_menge_res, \
            rt020_sbterm
    }
    dbms with cursor rt020_read_r100 execute using \
        FI_NR1, \
        rt020_fmlz

    if (SQL_CODE == SQLNOTFOUND) {
        return WARNING
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r100", "rt020_proto_mat")
    }

    if (rt020_fklz_meld != rt020_fklz) {
        // Übergebene Fertigungsauftragsleitzahl ist falsch!
        return on_error(FAILURE, "r0000114", "(:rt020_fklz_meld / :rt020_fklz)", "rt020_proto_mat")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Update Fertigungsmaterial
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_update_r100()
{
//TODO: Ersetzen Update auf r100 inkl. Protokollierung und b930-Satz mit "rq100_update_mat_komplex"

    if (fertig_schreibenProtokollsatzR100(cAES_NONE, FI_NR1, rt020_fmlz) != OK) {
        return on_error(FAILURE)
    }

    dbms sql \
        update \
            r100 \
        set \
            r100.fmfs = :+rt020_fmfs, \
            r100.menge_ent = :+rt020_menge_ent, \
            r100.menge_offen = \
                case \
                    when (:+rt020_fmfs >= '7') then 0 \
                    when (r100.menge > 0) and (r100.menge - :+rt020_menge_ent) < 0 then 0 \
                    when (r100.menge < 0) and (r100.menge - :+rt020_menge_ent) > 0 then 0 \
                    else (r100.menge - :+rt020_menge_ent) \
                end, \
            r100.menge_dis = \
                case \
                    when (:+rt020_fmfs >= '7') then 0 \
                    when (r100.menge > 0) and (r100.menge - :+rt020_menge_ent - r100.menge_res) < 0 then 0 \
                    when (r100.menge < 0) and (r100.menge - :+rt020_menge_ent - r100.menge_res) > 0 then 0 \
                    else (r100.menge - :+rt020_menge_ent - r100.menge_res) \
                end, \
            r100.kn_ws = :+rt020_kn_ws_mat, \
            r100.aenddr = '0', \
            r100.rueck_dat = :+rt020_rueck_dat, \
            r100.dataen = :CURRENT, \
            r100.useraen = :+LOGNAME, \
            r100.aendnr = r100.aendnr + 1 \
        where \
            r100.fi_nr = :+FI_NR1 and \
            r100.fmlz  = :+rt020_fmlz

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r100", "rt020_proto_mat")
    }

    if (fertig_schreibenProtokollsatzR100(cAES_UPDATE, FI_NR1, rt020_fmlz) != OK) {
        return on_error(FAILURE)
    }

    if (fertig_abstellen_material_transaktionssatz(cAES_UPDATE, FI_NR1, rt020_fmlz) != OK) {
        return on_error(FAILURE)
    }

    if ( \
        rt020_fu_freig_mat != "1" || \
        rt020_vormerk_diff >= 0 \
    ) {
        return OK
    }

    public rq1004.bsl

    vars verknuepfungL = new verknuepfungFmlzRq1004()

    verknuepfungL=>fi_nr        = FI_NR1
    verknuepfungL=>fmlz         = rt020_fmlz
    verknuepfungL=>menge_diff   = rt020_vormerk_diff * (-1)
    if (verknuepfungFmlzRq1004Aufheben(verknuepfungL) < OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r1004", "rt020_proto_mat")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Sperren Fertigungsarbeitsgang
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_r200()
{
    boolean lockL = TRUE


    dbms declare rt020_lock_r200 cursor for \
        select \
            r200.fklz, \
            r200.agpos, \
            r200.splitnr, \
            r200.aufnr, \
            r200.aufpos, \
            r200.identnr, \
            r200.var, \
            r200.kostst, \
            r200.arbplatz, \
            r200.fsterm, \
            r200.seterm, \
            r200.agben, \
            r200.agbs, \
            r200.fafs, \
            r200.kn_ws, \
            r200.werk \
        from \
            r200 :MSSQL_FOR_UPDATE \
        where \
            r200.fi_nr = :+FI_NR1 and \
            r200.falz  = :+rt020_falz \
        :FOR_UPDATE
    dbms with cursor rt020_lock_r200 alias \
        rt020_fklz, \
        rt020_agpos, \
        rt020_splitnr, \
        rt020_aufnr, \
        rt020_aufpos, \
        rt020_identnr, \
        rt020_var, \
        rt020_kostst, \
        rt020_arbplatz, \
        rt020_fsterm_ag, \
        rt020_seterm_ag, \
        rt020_agben, \
        rt020_agbs, \
        rt020_fafs, \
        rt020_kn_ws_ag, \
        rt020_werk

    while (lockL == TRUE) {
        dbms with cursor rt020_lock_r200 execute
        if (SQL_CODE == SQLNOTFOUND) {
            dbms with cursor rt020_lock_r200 alias
            // Fertigungsarbeitsgang %s nicht vorhanden
            return on_error(WARNING, "r2000000", rt020_falz, "rt020_proto_ag")
        }
        else if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsarbeitsgang %s von einem anderen Benutzer gesperrt
            call bu_msg("r2000002", rt020_falz)
            next
        }
        else if (SQL_CODE != SQL_OK) {
            dbms with cursor rt020_lock_r200 alias
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r200", "rt020_proto_ag")
        }

        lockL = FALSE
    }
    dbms with cursor rt020_lock_r200 alias


    if (rt020_fklz_meld != rt020_fklz) {
        // Übergebene Fertigungsauftragsleitzahl ist falsch!
        return on_error(FAILURE, "r0000114", "(:rt020_fklz_meld / :rt020_fklz)", "rt020_proto_mat")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen Fertigungsarbeitsgang für Protokollierung
# - wenn nicht vorhanden, wird keine Meldung erzeugt
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_sel_r200()
{
    if (!dm_is_cursor("rt020_read_r200")) {
        dbms declare rt020_read_r200 cursor for \
            select \
                r200.fklz, \
                r200.agpos, \
                r200.splitnr, \
                r200.aufnr, \
                r200.aufpos, \
                r200.identnr, \
                r200.var, \
                r200.kostst, \
                r200.arbplatz, \
                r200.fsterm, \
                r200.seterm, \
                r200.agben, \
                r200.fafs \
            from \
                r200 \
            where \
                r200.fi_nr = ::_1 and \
                r200.falz  = ::_2
        dbms with cursor rt020_read_r200 alias \
            rt020_fklz, \
            rt020_agpos, \
            rt020_splitnr, \
            rt020_aufnr, \
            rt020_aufpos, \
            rt020_identnr, \
            rt020_var, \
            rt020_kostst, \
            rt020_arbplatz, \
            rt020_fsterm_ag, \
            rt020_seterm_ag, \
            rt020_agben, \
            rt020_fafs
    }
    dbms with cursor rt020_read_r200 execute using \
        FI_NR1, \
        rt020_falz

    if (SQL_CODE == SQLNOTFOUND) {
        return WARNING
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "r200", "rt020_proto_ag")
    }

    if (rt020_fklz_meld != rt020_fklz) {
        // Übergebene Fertigungsauftragsleitzahl ist falsch!
        return on_error(FAILURE, "r0000114", "(:rt020_fklz_meld / :rt020_fklz)", "rt020_proto_mat")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Update Fertigungsarbeitsgang
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_update_r200()
{
    int      rcL
    R200CDBI r200L


    r200L = bu_cdbi_new("r200")
    r200L=>fi_nr  = FI_NR1
    r200L=>falz   = rt020_falz
    r200L=>fafs   = rt020_fafs
    r200L=>kn_ws  = rt020_kn_ws_ag
    r200L=>aenddr = "0"

    rcL = bu_cdbi_update(r200L)
    if (rcL != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r200", "rt020_proto_ag")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen Arbeitsplatzdaten zum Arbeitsgang
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_sel_f300()
{
    if ( \
        rt020_kostst <= 0 || \
        rt020_arbplatz == "" \
    ) {
        rt020_kn_sammel_lhs = "0"
        return OK
    }

    // Nur bei AG-Beschaffungsschlüssel "Eigen"
    if (cod_agbs_eigen(rt020_agbs) == FALSE) {
        rt020_kn_sammel_lhs = "0"
        return OK
    }

    if (!dm_is_cursor("rt020_read_f300b")) {
        dbms declare rt020_read_f300b cursor for \
            select \
                f300.kn_sammel_lhs \
            from \
                f300 \
            where \
                f300.fi_nr    = ::_1 and \
                f300.werk     = ::_2 and \
                f300.kostst   = ::_3 and \
                f300.arbplatz = ::_4
        dbms with cursor rt020_read_f300b alias rt020_kn_sammel_lhs
    }
    dbms with cursor rt020_read_f300b execute using \
        FI_NR1, \
        rt020_werk, \
        rt020_kostst, \
        rt020_arbplatz

    if (SQL_CODE == SQLNOTFOUND) {
        // Arbeitsplatz %s nicht vorhanden!
        return on_error(FAILURE, "f3000000", ":rt020_kostst-:rt020_arbplatz", "rt020_proto_ag")
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Lesen in Tabelle %s.
        return on_error(FAILURE, "APPL0006", "f300", "rt020_proto_ag")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Lesen und Sperren Fertigungsbetriebsmittel
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_get_r500()
{
    vars lock


    dbms declare rt020_lock_r500 cursor for \
        select \
            r500.identnr \
        from \
            r500 :MSSQL_FOR_UPDATE \
        where \
            r500.fi_nr = :+FI_NR1 and \
            r500.falz  = :+rt020_falz and \
            r500.lfdnr = :+rt020_lfdnr \
        :FOR_UPDATE
    dbms with cursor rt020_lock_r500 alias rt020_bmidentnr

    lock = TRUE
    while (lock == TRUE) {
        dbms with cursor rt020_lock_r500 execute

        if (SQL_CODE == SQLNOTFOUND) {
            dbms with cursor rt020_lock_r500 alias
            // Fertigungsbetriebsmittel %s nicht vorhanden
            return on_error(WARNING, "r5000000", rt020_falz ## " " ## rt020_lfdnr, "rt020_proto_bm")
        }

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Fertigungsbetriebsmittel %s von einem anderen Benutzer gesperrt
            call bu_msg("r5000002", rt020_falz ## " " ## rt020_lfdnr)
            next
        }

        if (SQL_CODE != SQL_OK) {
            dbms with cursor rt020_lock_r200 alias
            // Fehler beim Lesen in Tabelle %s.
            return on_error(FAILURE, "APPL0006", "r500", "rt020_proto_bm")
        }

        lock = FALSE
    }

    dbms with cursor rt020_lock_r500 alias

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Update Fertigungsbetriebsmittel
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_update_r500()
{
    dbms sql \
        update \
            r500 \
        set \
            r500.bmfs = :+rt020_bmfs \
        where \
            r500.fi_nr = :+FI_NR1 and \
            r500.falz  = :+rt020_falz and \
            r500.lfdnr = :+rt020_lfdnr

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "r500", "rt020_proto_bm")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Update Lagerstamm (Reservierungsbestand)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_update_g020()
{
    call rt020_bundle_lt110()
    if (lt110_rvb_fortschreiben(rt020_lt110_handle) != OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Schreiben Aktionssatz Druck Fertigungspapiere in Tabelle r065
# wenn bereits vorhanden --> OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_insert_r065()
{
    call bu_noerr()

    dbms sql \
        insert into \
            r065 \
        ( \
            r065.fi_nr, \
            r065.werk, \
            r065.fu_druck, \
            r065.fklz, \
            r065.logname, \
            r065.freigabe, \
            r065.aufnr, \
            r065.aufpos, \
            r065.dr_st, \
            r065.dr_ag, \
            r065.dr_lhs, \
            r065.agpos_von, \
            r065.agpos_bis, \
            r065.dr_mes, \
            r065.stpos_von, \
            r065.stpos_bis, \
            r065.dr_bl, \
            r065.kz_dnr, \
            r065.jobid, \
            r065.auspraeg \
        ) \
        values ( \
            :+FI_NR1, \
            :+rt020_werk, \
            '4', \
            :+rt020_fklz, \
            :+LOGNAME, \
            :+rt020_freigabe, \
            :+rt020_aufnr, \
            :+rt020_aufpos, \
            :+rt020_R_DR_ST, \
            :+rt020_R_DR_AG, \
            :+rt020_R_DR_LHS, \
            0, \
            9999, \
            :+rt020_R_DR_MES, \
            0, \
            9999, \
            :+rt020_R_DR_BL, \
            '0', \
            0, \
            :+NULL \
        )

    if (SQL_CODE == SQLE_DUPKEY) {
        return OK
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r065", "rt020_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Löschen Aktionssatz Druck Fertigungspapiere aus Tabelle r065
# - wenn nicht vorhanden --> OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_delete_r065()
{
    vars lock


    lock = TRUE
    while (lock == TRUE) {
        dbms sql \
            delete from \
                r065 \
            where \
                r065.fi_nr    =  :+FI_NR1 and \
                r065.fu_druck =  '4' and \
                r065.fklz     =  :+rt020_fklz and \
                r065.jobid    <= 0

        if (SQL_CODE == SQLE_ROWLOCKED) {
            // Aktion Druck FA-Papiere %s von einem anderen Benutzer gesperrt
            call bu_msg("r0650002")
            next
        }

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Löschen in Tabelle %s.
            return on_error(FAILURE, "APPL0005", "r065", "rt020_proto")
        }

        lock = FALSE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Bundle für "rt020" empfangen (Fertigungsauftrag)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_receive_rt020()
{
    receive bundle "b_rt020" data \
        rt020_fklz, \
        rt020_fu_freig, \
        rt020_fu_matpr

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Bundle für "rt020" empfangen (Fertigungsmaterial)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_receive_rt020_mat()
{
    receive bundle "b_rt020_mat" data \
        rt020_fmlz, \
        rt020_fklz_meld, \
        rt020_fu_freig_mat

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Bundle für "rt020" empfangen (Fertigungsarbeitsgang)
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_receive_rt020_ag()
{
    receive bundle "b_rt020_ag" data \
        rt020_falz, \
        rt020_fklz_meld, \
        rt020_fu_freig_ag

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Bundle an "kt431" senden
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_send_kt431()
{
   vars storno


    // Abhängig von fu_freig wird storno geladen
    if (rt020_fu_freig_mat == "4") {
        storno = 0
    }
    else if (rt020_fu_freig_mat == "1") {
        storno = 1
    }

    send bundle "b_kt431_mat" data \
        storno, \
        "0", \
        rt020_fklz, \
        rt020_fmlz, \
        rt020_menge_ent, \
        rt020_menge_ent_meld, \
        "0", \
        rt020_lgnr

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Satz für Fertigungsauftrag in die Protokolltabelle r026 abstellen
# - die zuletzt protokollierte fklz wird zwischengespeichert
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r026")

    if (rt020_werk <= 0) {
        rt020_werk = werk
    }

    dbms sql \
        insert into \
            r026 \
        ( \
            r026.datuhr, \
            r026.fi_nr, \
            r026.werk, \
            r026.logname, \
            r026.tty, \
            r026.maske, \
            r026.msg_nr, \
            r026.msg_typ, \
            r026.msg_text, \
            r026.prt_ctrl, \
            r026.jobid, \
            r026.fklz, \
            r026.aufnr, \
            r026.aufpos, \
            r026.identnr, \
            r026.var, \
            r026.aart, \
            r026.fkfs, \
            r026.fsterm, \
            r026.seterm, \
            r026.fu_freig, \
            r026.fu_matpr \
        ) \
        values ( \
            :CURRENT, \
            :+FI_NR1, \
            :+rt020_werk, \
            :+LOGNAME, \
            :+TTY, \
            :+screen_name, \
            :+msg_nr, \
            :+msg_typ, \
            :+msg_text, \
            :+prt_ctrl, \
            :+JOBID, \
            :+rt020_fklz, \
            :+rt020_aufnr, \
            :+rt020_aufpos, \
            :+rt020_identnr, \
            :+rt020_var, \
            :+rt020_aart, \
            :+rt020_fkfs, \
            :+rt020_fsterm, \
            :+rt020_seterm, \
            :+rt020_fu_freig, \
            :+rt020_fu_matpr \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r026")
    }

    // Zwischenspeichern fklz
    rt020_prt_fklz = rt020_fklz

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Satz in die Protokolltabelle r126 abstellen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto_mat(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r126")

    dbms sql \
        insert into \
            r126 \
        ( \
            r126.datuhr, \
            r126.fi_nr, \
            r126.werk, \
            r126.logname, \
            r126.tty, \
            r126.maske, \
            r126.msg_nr, \
            r126.msg_typ, \
            r126.msg_text, \
            r126.prt_ctrl, \
            r126.jobid, \
            r126.fmlz, \
            r126.fklz, \
            r126.stpos, \
            r126.stposlfd, \
            r126.aufnr, \
            r126.aufpos, \
            r126.identnr, \
            r126.var, \
            r126.fmfs, \
            r126.menge, \
            r126.menge_offen, \
            r126.sbterm, \
            r126.fu_freig, \
            r126.vv_pos \
        ) \
        values ( \
            :CURRENT, \
            :+FI_NR1, \
            :+rt020_werk_mat, \
            :+LOGNAME, \
            :+TTY, \
            :+screen_name, \
            :+msg_nr, \
            :+msg_typ, \
            :+msg_text, \
            :+prt_ctrl, \
            :+JOBID, \
            :+rt020_fmlz, \
            :+rt020_fklz, \
            :+rt020_stpos, \
            :+rt020_stposlfd, \
            :+rt020_aufnr, \
            :+rt020_aufpos, \
            :+rt020_identnr_mat, \
            :+rt020_var_mat, \
            :+rt020_fmfs, \
            :+rt020_menge, \
            :+rt020_menge_offen, \
            :+rt020_sbterm, \
            :+rt020_fu_freig_mat, \
            :+rt020_vv_pos \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r126")
    }

    // Protokollieren Fertigungsauftrag, wenn noch nicht protokolliert
    if (rt020_fklz != rt020_prt_fklz) {
        // dazu lesen Fertigungsauftrag
        if (rt020_sel_r000() < OK) {
            return FAILURE
        }
        if ( \
            prt_ctrl != PRT_CTRL_FEHLER && \
            prt_ctrl != PRT_CTRL_HINWEIS \
        ) {
            // Initialisierung der globalen Message-Felder für die OK-Meldung
            call fertig_fehler_init_globale_felder(TRUE)
            if (rt020_proto(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
                return FAILURE
            }
        }
        else {
            // Fehler-/ Hinweise bei Fertigungsmaterial aufgetreten
            call bu_get_msg("ral00141")
            if (rt020_proto(OK, PRT_CTRL_HINWEIS, $NULL, $NULL) < OK) {
                return FAILURE
            }
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Satz in Protokolltabelle r226 abstellen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto_ag(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    prt_ctrl = fertig_fehler_prt_ctrl(prt_ctrlP, rcP, "r226")

    dbms sql \
        insert into \
            r226 \
        ( \
            r226.datuhr, \
            r226.fi_nr, \
            r226.werk, \
            r226.logname, \
            r226.tty, \
            r226.maske, \
            r226.msg_nr, \
            r226.msg_typ, \
            r226.msg_text, \
            r226.prt_ctrl, \
            r226.jobid, \
            r226.falz, \
            r226.fklz, \
            r226.agpos, \
            r226.splitnr, \
            r226.aufnr, \
            r226.aufpos, \
            r226.identnr, \
            r226.var, \
            r226.agben, \
            r226.kostst, \
            r226.arbplatz, \
            r226.fafs, \
            r226.fsterm, \
            r226.seterm, \
            r226.fu_freig \
        ) \
        values ( \
            :CURRENT, \
            :+FI_NR1, \
            :+rt020_werk, \
            :+LOGNAME, \
            :+TTY, \
            :+screen_name, \
            :+msg_nr, \
            :+msg_typ, \
            :+msg_text, \
            :+prt_ctrl, \
            :+JOBID, \
            :+rt020_falz, \
            :+rt020_fklz, \
            :+rt020_agpos, \
            :+rt020_splitnr, \
            :+rt020_aufnr, \
            :+rt020_aufpos, \
            :+rt020_identnr, \
            :+rt020_var, \
            :+rt020_agben, \
            :+rt020_kostst, \
            :+rt020_arbplatz, \
            :+rt020_fafs, \
            :+rt020_fsterm_ag, \
            :+rt020_seterm_ag, \
            :+rt020_fu_freig_ag \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "r226")
    }

    // Protokollieren Fertigungsauftrag, wenn noch nicht protokolliert
    if (rt020_fklz != rt020_prt_fklz) {
        // dazu lesen Fertigungsauftrag
        if (rt020_sel_r000() < OK) {
            return FAILURE
        }
        if ( \
            prt_ctrl != PRT_CTRL_FEHLER && \
            prt_ctrl != PRT_CTRL_HINWEIS \
        ) {
            // Initialisierung der globalen Message-Felder für die OK-Meldung
            call fertig_fehler_init_globale_felder(TRUE)
            if (rt020_proto(OK, PRT_CTRL_OK, $NULL, $NULL) < OK) {
                return FAILURE
            }
        }
        else {
            // Fehler-/ Hinweise bei Fertigungsarbeitsgang aufgetreten
            call bu_get_msg("ral00142")
            if (rt020_proto(OK, PRT_CTRL_HINWEIS, $NULL, $NULL) < OK) {
                return FAILURE
            }
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Satz in Protokolltabelle r526 abstellen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto_bm(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    // hier muss später ein Insert in die Tabelle "r526" erfolgen
    // stattdessen erfolgt derzeit nur ein Aufruf der AG-Protokollierung
    // dieser Aufruf entfällt später
    if (rt020_proto_ag(rcP, prt_ctrlP, msg_nrP, msg_zusatzP) < OK) {
        return FAILURE
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_bundle_lt110()
{
    send bundle "b_lt110" data \
        rt020_identnr_mat, \
        rt020_var_mat, \
        FALSE, \
        rt020_werk_mat, \
        rt020_lgnr, \
        NULL, \
        NULL

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_send_lm100(stornoP)
{
    identnrLm100EA = rt020_identnr_mat
    varLm100EA = rt020_var_mat
    mengeLm100EA = rt020_menge_res_diff
    stornoLm100EA = stornoP
    chargeLm100EA = rt020_charge
    reservnrLm100EA = rt020_reservnr
    werkLm100EA = rt020_werk_mat
    if (rt020_lgnr != "") {
        lgnrLm100EA = rt020_lgnr
    }
    lgberLm100EA = rt020_lgber
    lgfachLm100EA = rt020_lgfach
    lg_datLm100EA = ""
    chargen_pflichtLm100EA = rt020_chargen_pflicht
    res_alwaysLm100EA = TRUE
    delta_flagLm100EA = FALSE
    lg_sperr_flgLm100EA = TRUE

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_lm100_reservierung()
{
    vars rcodeL
    vars stornoL = FALSE
    vars i1L


    //wenn keine Physiche Reservierungen gemacht werden soll -> Funktion nicht durchfuehren
    rt020_menge_res_lm100 = 0

    if (rt020_kn_lgres == "0") {
        return OK
    }

    if ( \
        rt020_fu_freig_mat == "1" && \
        rt020_menge_res == 0 \
    ) {
        rt020_menge_res_diff = 0
        return OK
    }

    rt020_menge_res_diff = rt020_menge_dis
    if (rt020_fu_freig_mat == "1") {
        rt020_menge_res_diff = rt020_menge_res
        stornoL = TRUE
    }

    // Keine Reservierung notwendig
    if (rt020_menge_res_diff <= 0) {
        return OK
    }

    //Reservierung nur für chaotisch verwaltete Teile
    if (rt020_sel_g020() != OK) {
        return FAILURE
    }

    // generieren reservnr
    lm100_handleRt020 = fertig_load_modul("lm100", lm100_handleRt020)
    if (lm100_handleRt020 < 0) {
        return FAILURE
    }

    call lm100_activate(lm100_handleRt020)
    call lm100_init()

    rt020_kompid = "1"

    werkLm100EA = rt020_werk_mat
    kompidLm100EA = rt020_kompid
    fklzLm100EA = rt020_fklz
    fmlzLm100EA = rt020_fmlz
    aufnrLm100EA = rt020_aufnr
    aufposLm100EA = rt020_aufpos
    seblposLm100EA = ""
    lfdnr_eintlLm100EA = ""

    rcodeL = lm100_gen_reservnr()
    if (rcodeL < OK) {
        call bu_msg_errmsg("lm100")
        call lm100_deactivate(lm100_handleRt020)
        return rcodeL
    }

    rt020_reservnr = reservnrLm100EA

    // aufruf reservierung
    call lm100_init()

    call rt020_send_lm100(stornoL)

    warn_2_failRt020 = warn_2_fail
    warn_2_fail    = FALSE

    rcodeL = lm100_reservieren()

    if (rcodeL < OK) {
        call bu_msg_errmsg("lm100")
        call lm100_deactivate(lm100_handleRt020)
        warn_2_fail = warn_2_failRt020
        return fertig_fehler_proto(rcodeL, "rt020_proto", NULL)
    }
    else if (rcodeL > OK) {
        // Initialisierung der globalen Message-Felder
        call fertig_fehler_init_globale_felder(TRUE)
        call bu_msg_errmsg("lm100")
        call fertig_fehler_proto(rcodeL, "rt020_proto", PRT_CTRL_HINWEIS)
    }

    warn_2_fail = warn_2_failRt020

    rt020_menge_res_lm100 = menge_res_realLm100EA

    call sm_n_clear_array("rt020_lagereinheit_a")
    call sm_n_copyarray("rt020_lagereinheit_a", "lagereinheit_resLm100A")
    call sm_n_copyarray("rt020_menge_res_a", "menge_resLm100A")
    call sm_n_copyarray("rt020_reservnr_a", "reservnr_resLm100A")
    call sm_n_copyarray("rt020_reservnr_alt_a", "reservnr_altLm100A")

    if (rt020_menge_res_lm100 == 0 && lagereinheit_resLm100A->num_occurrences <= 0) {
        call lm100_deactivate(lm100_handleRt020)
        return OK
    }

    call lm100_deactivate(lm100_handleRt020)

    // Ermittlung Lagereinheiten und Mengen je Lagereinheit
    vars tabelleKommL
    vars komm_nrL
    vars lfdnrL
    vars cursorL

    if (komm_nrRt020 == "") {
        if (rt020_pos_herk(1, 1) <= "6") {
            tabelleKommL = "l82010"
            cursorL      = "rt020_get_l82010"
        }
        else {
            tabelleKommL = "l82030"
            cursorL      = "rt020_get_l82030"
        }

        if (!dm_is_cursor(cursorL)) {
            dbms declare :cursorL cursor for \
                select distinct \
                    :tabelleKommL.komm_nr, \
                    :tabelleKommL.lfdnr \
                from \
                    :tabelleKommL \
                where \
                    :tabelleKommL.fi_nr      = ::FI_NR1     and \
                    :tabelleKommL.fmlz       = ::rt020_fmlz and \
                    :tabelleKommL.st_komm_nr < :+ST_KOMM_NR_ABGESCHLOSSEN
            dbms with cursor :cursorL alias \
                komm_nrL, \
                lfdnrL
        }
        dbms with cursor :cursorL execute using \
            FI_NR1, \
            rt020_fmlz
    }
    else {
        komm_nrL = komm_nrRt020
        lfdnrL   = lfdnrRt020
    }

    while (komm_nrL != "") {
        if (rt020_fu_freig_mat == "4") {
            for i1L = 1 while (i1L <= rt020_lagereinheit_a->num_occurrences) step 1 {
                if (rt020_reservnr_a[i1L] == "*") {
                    next
                }

                dbms sql \
                    insert into \
                        l82020 \
                    ( \
                        l82020.fi_nr, \
                        l82020.komm_nr, \
                        l82020.lfdnr, \
                        l82020.lagereinheit, \
                        l82020.sb_schl, \
                        l82020.menge, \
                        l82020.menge_ent, \
                        l82020.kommlinr, \
                        l82020.dataen, \
                        l82020.useraen, \
                        l82020.datneu, \
                        l82020.userneu, \
                        l82020.aendnr \
                    ) \
                    values ( \
                        :+FI_NR1, \
                        :+komm_nrL, \
                        :+lfdnrL, \
                        :+rt020_lagereinheit_a[i1L], \
                        0, \
                        :+rt020_menge_res_a[i1L], \
                        0, \
                        0, \
                        :CURRENT, \
                        :+LOGNAME, \
                        :CURRENT, \
                        :+LOGNAME, \
                        0 \
                    )

                if (SQL_CODE != SQL_OK) {
                    // Fehler beim Einfügen in Tabelle >%s<.
                    return on_error(FAILURE, "APPL0003", "l82020", "rt020_proto")
                }
            }
        }
        else if (rt020_fu_freig_mat == "1") {
            for i1L = 1 while (i1L <= rt020_lagereinheit_a->num_occurrences) step 1 {
                if ( \
                    rt020_reservnr_a[i1L] == "*" && \
                    rt020_reservnr_a[i1L] != rt020_reservnr \
                ) {
                    next
                }

                dbms sql \
                    delete from \
                        l82020 \
                    where \
                        l82020.fi_nr    = :+FI_NR1 and \
                        l82020.komm_nr  = :+komm_nrL and \
                        l82020.lfdnr    = :+lfdnrL

                if (SQL_CODE != SQL_OK) {
                    // Fehler beim Löschen in Tabelle %s.
                    return on_error(FAILURE, "APPL0005", "l82020", "rt020_proto")
                }
            }
        }

        if (cursorL != "") {
            dbms with cursor :cursorL continue

            if (SQL_CODE != SQL_OK) {
                komm_nrL = ""
            }
        }
        else {
            komm_nrL = ""
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# - Daten Kanbanauftrag setzen
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_set_kanban()
{
    if (rt020_kanbannr == "") {
        return OK
    }

    if (rt020_fkfs == "4") {
        rt020_status = "4"
    }
    else {
        rt020_status = "3"
    }

    dbms sql \
        update \
            d810 \
        set \
            d810.status  = :+rt020_status, \
            d810.dataen  = :CURRENT, \
            d810.useraen = :+LOGNAME, \
            d810.aendnr  = d810.aendnr + 1 \
        where \
            d810.fi_nr       = :+FI_NR1 and \
            d810.kanbannr    = :+rt020_kanbannr and \
            d810.kanbananfnr = :+rt020_kanbananfnr

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "d810", "rt020_proto")
    }

    dbms sql \
        update \
            d800 \
        set \
            d800.datletzt = :CURRENT, \
            d800.dataen   = :CURRENT, \
            d800.useraen  = :+LOGNAME, \
            d800.aendnr   = d800.aendnr + 1 \
        where \
            d800.fi_nr    = :+FI_NR1 and \
            d800.kanbannr = :+rt020_kanbannr

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Ändern in Tabelle %s.
        return on_error(FAILURE, "APPL0004", "d800", "rt020_proto")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto_kb(rcP, string prt_ctrlP, string msg_nrP, string msg_zusatzP)
{
    if (rt020_proto(rcP, prt_ctrlP, msg_nrP, msg_zusatzP) != OK) {
        return FAILURE
    }

    if (rt020_kanbannr != "") {
        if (rt020_proto_d816(rcP) != OK) {
            return FAILURE
        }
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_proto_d816(rcP)
{
    vars lo_rt020_fmlz
    vars lo_dispn
    vars lo_einkaeufer
    vars lo_kostst


    if (cod_aart_versorg(rt020_aart) == TRUE) {
        dbms alias lo_rt020_fmlz
        dbms sql \
            select \
                r100.fmlz \
            from \
                r100 \
            where \
                r100.fi_nr = :+FI_NR1 and \
                r100.fklz  = :+rt020_fklz
        dbms alias
    }
    else {
        lo_rt020_fmlz = ""
    }
    dbms alias \
        lo_dispn, \
        lo_einkaeufer
    dbms sql \
        select \
            g020.dispn, \
            g043.einkaeufer \
        from \
            g020, \
            g043 \
        where \
            g020.fi_nr   = :+FI_NR1 and \
            g020.werk    = :+rt020_werk and \
            g020.lgnr    = :+rt020_lgnr and \
            g020.identnr = :+rt020_identnr and \
            g020.var     = :+rt020_var and \
            g043.fi_nr   = g020.fi_nr and \
            g043.identnr = g020.identnr and \
            g043.var     = g020.var
    dbms alias

    dbms alias lo_kostst
    dbms sql \
        select \
            d800.kostst \
        from \
            d800 \
        where \
            d800.fi_nr    = :+FI_NR1 and \
            d800.kanbannr = :+rt020_kanbannr
    dbms alias

    if (rt020_kanbananfnr == "") {
        rt020_kanbananfnr = 0
    }
    if (rt020_aufpos == "") {
        rt020_aufpos = 0
    }

    call bu_noerr()

    dbms sql \
        insert into \
            d816 \
        ( \
            d816.fi_nr, \
            d816.datuhr, \
            d816.werk, \
            d816.jobid, \
            d816.logname, \
            d816.kanbananfnr, \
            d816.kanbannr, \
            d816.kostst, \
            d816.identnr, \
            d816.var, \
            d816.lgnr, \
            d816.lgber, \
            d816.lgfach, \
            d816.fertig_dat, \
            d816.freig_dat, \
            d816.rueck_dat, \
            d816.bvor_art, \
            d816.soll_menge, \
            d816.ist_menge, \
            d816.status, \
            d816.kostst_akt, \
            d816.lfdnr_etik, \
            d816.kostst_q, \
            d816.lgnr_q, \
            d816.lgber_q, \
            d816.lgfach_q, \
            d816.msg_text, \
            d816.msg_typ, \
            d816.kz_verarb, \
            d816.kommentar, \
            d816.dataen, \
            d816.kbfehlerart, \
            d816.einkaeufer, \
            d816.dispn, \
            d816.fklz, \
            d816.fmlz, \
            d816.bestnr, \
            d816.bestpos, \
            d816.aufnr, \
            d816.aufpos, \
            d816.vorschlnr \
        ) \
        values ( \
            :+FI_NR1, \
            :CURRENT, \
            :+rt020_werk, \
            0, \
            :+LOGNAME, \
            :+rt020_kanbananfnr, \
            :+rt020_kanbannr, \
            :+lo_kostst, \
            :+rt020_identnr, \
            :+rt020_var, \
            :+rt020_lgnr, \
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
            :+lo_einkaeufer, \
            :+lo_dispn, \
            :+rt020_fklz, \
            :+lo_rt020_fmlz, \
            :+NULL, \
            0, \
            :+rt020_aufnr, \
            :+rt020_aufpos, \
            0 \
        )

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "d816")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_call_rm131()
{
    int rcL


    // keine Verarbeitung erforderlich
    if ( \
        rt020_fu_freig_mat != "4" || \
        rt020_kzmat != "4" \
    ) {
        return OK
    }

    // Eine Materialentnahme kann nicht sauber durchgeführt werden, deshalb wird rm131 nicht aufgerufen.
    // Durch den Rollback aus der fehlgeschlagenen Buchung würde die Freigabe rückgängig gemacht werden
    if ( \
        ( \
            rt020_kn_lgres  == "1" && \
            rt020_menge_res == 0 \
        ) || \
        ( \
            rt020_dismenge < rt020_menge_dis \
        ) \
    ) {
        return OK
    }

    // Laden Modul rm131
    rm131_handleRt020 = fertig_load_modul("rm131", rm131_handleRt020)
    if (rm131_handleRt020 < 0) {
        return FAILURE
    }

    call rm131_activate(rm131_handleRt020)
    call rm131_init()

    FI_NR1Rm131E       = FI_NR1
    fmlzRm131EA        = rt020_fmlz
    stornoRm131E       = "0"
    mengeZugangRm131EA = 0
    verarbModusRm131E = "1"

    rcL = rm131_verarbeiten()
    if (rcL < OK) {
        call bu_msg_errmsg("rm131")
        call rm131_deactivate(rm131_handleRt020)
        return fertig_fehler_proto(rcL, "rt020_proto", "")
    }
    if (rcL > OK) {
        call bu_msg_errmsg("rm131")
        call fertig_fehler_proto(rcL, "rt020_proto", PRT_CTRL_HINWEIS)
    }

    call bu_msg_errmsg("rm131")
    call rm131_deactivate(rm131_handleRt020)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Anstoß Bestellrechnung
# - Schreiben Aktionssatz in Tabelle "d205" mit kz_herk = "E"
# - wenn bereits vorhanden, update vorh. Satz mit "E"
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_set_d205()
{
    // Aktionssatz schreiben
    call bu_noerr()

    dbms sql \
        insert into \
            d205 \
        ( \
            d205.fi_nr, \
            d205.werk, \
            d205.identnr, \
            d205.var, \
            d205.lgnr, \
            d205.kz_herk \
        ) \
        values ( \
            :+FI_NR1, \
            :+rt020_werk_mat, \
            :+rt020_identnr_mat, \
            :+rt020_var_mat, \
            :+rt020_lgnr, \
            'E' \
        )

    if (SQL_CODE == SQLE_DUPKEY) {
        dbms sql \
            update \
                d205 \
            set \
                d205.kz_herk = 'E' \
            where \
                d205.fi_nr   = :+FI_NR1 and \
                d205.werk    = :+rt020_werk_mat and \
                d205.identnr = :+rt020_identnr_mat and \
                d205.var     = :+rt020_var_mat and \
                d205.lgnr    = :+rt020_lgnr

        if (SQL_CODE != SQL_OK) {
            // Fehler beim Ändern in Tabelle %s.
            return on_error(FAILURE, "APPL0004", "d205", "rt020_proto_mat")
        }
        return OK
    }

    if (SQL_CODE != SQL_OK) {
        // Fehler beim Einfügen in Tabelle >%s<.
        return on_error(FAILURE, "APPL0003", "d205", "rt020_proto_mat")
    }

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_load_gm300(fi_nrP, werkP)
{
    rt020_handle_gm300 = bu_load_modul("gm300", rt020_handle_gm300)
    if (rt020_handle_gm300 < 0) {
            return FAILURE
    }

    call gm300_activate(rt020_handle_gm300)
    call gm300_init()

    fi_nrGm300E = fi_nrP
    werkGm300E = werkP

    // einmalig den zu verwendenden Kalender ermitteln
    if (gm300_kalender_ermitteln() != OK) {
        call bu_msg_errmsg("Gm300")
        call gm300_deactivate(rt020_handle_gm300)
        return on_error(FAILURE, "", "", "rt020_proto")
    }

    call gm300_deactivate(rt020_handle_gm300)

    return OK
}

//300145076
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_beginnmeldung_falz(handleP)
{
    vars i1L


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    for i1L = 1 while (i1L <= rt020_falz_best->num_occurrences) step 1 {
        rt020_handle_rt231 = bu_load_tmodul("rt231", rt020_handle_rt231)
        if (rt020_handle_rt231 < 0) {
            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return on_error(FAILURE)
        }

        call rt020_send_rt231(i1L)

        warn_2_failRt020 = warn_2_fail
        warn_2_fail    = TRUE

        if (rt231_ag_rueckmeldung(rt020_handle_rt231, FALSE, $NULL, FALSE) < OK) {
            warn_2_fail = warn_2_failRt020
            call sm_n_clear_array("rt020_falz_best")

            call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
            return FAILURE
        }

        warn_2_fail = warn_2_failRt020
    }

    call sm_n_clear_array("rt020_falz_best")
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Bundle für "rt231" senden
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_send_rt231(occP)
{
    send bundle 'b_rt231' data \
        "5", \
        "F", \
        "5", \
        0, \
        rt020_falz_best[occP], \
        rt020_fklz, \
        rt020_rueck_dat, \
        rt020_konto_best[occP], \
        0, \
        0, \
        0, \
        0, \
        rt020_bestnr_best[occP], \
        rt020_bestpos_best[occP], \
        NULL, \
        NULL, \
        rt020_werk_best[occP], \
        rt020_kostst_best[occP], \
        rt020_arbplatz_best[occP], \
        NULL, \
        ""

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Initialisieren FA-Daten für die weitere Verarbeitung von AGs
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_init_fa(handle)
{
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, TRUE)
    call sm_n_clear_array("rt020_falz_best")
    call sm_ldb_h_state_set(handle, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Zusatzfunktionen Material nach Freigabe des FA
# - Reservierungen
# - Entnahme bei Zugang des Bedarfsdeckers
# - Kommissionierung
#
# Returns: FAILURE, WARNING, OK
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_zusatzfunkt_mat(handleP)
{
    int rcL


    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, TRUE)

    call rt020_receive_rt020_mat()

    // Materialfreigabe wird durchgeführt
    call bu_msg("ral00118")

    // Prüfen "fu_freig"
    if ( \
        rt020_fu_freig_mat != "4" && \
        rt020_fu_freig_mat != "1" \
    ) {
       // Falscher Funktionscode bei Aufruf Modul %s
        call on_error(FAILURE, "ral00901", "rt020", "rt020_proto_mat")
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Lesen und Prüfen Fertigungsmaterial
    rcL = rt020_get_mat(TRUE)
    if (rcL != OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return rcL
    }

    // Gm300 aktivieren
    if (rt020_load_gm300(fi_nr, rt020_werk_mat) != OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    // Freigabe Fertigungsmaterial
    if (rt020_res_ent_mat() < OK) {
        dbms close cursor rt020_lock_r100
        call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)
        return FAILURE
    }

    dbms close cursor rt020_lock_r100
    msg d_msg ""
    call sm_ldb_h_state_set(handleP, LDB_ACTIVE, FALSE)

    return OK
}

#-----------------------------------------------------------------------------------------------------------------------
# Reservierung, Kommissionierzuordnung, Entnahme nach Zugang des Bedarfsdeckers
#-----------------------------------------------------------------------------------------------------------------------
int proc rt020_res_ent_mat()
{
    vars fromL
    vars whereL
    vars parKommDruckL
    int  rcL


    if (cod_aart_versorg(rt020_aart) == TRUE) {
        parKommDruckL = rt020_R_KOMM_DRUCK_VA
    }
    else {
        parKommDruckL = rt020_R_KOMM_DRUCK

        if ( \
            rt020_agpos > 0 && \
            cod_pos_herk_versorgung(rt020_pos_herk) != TRUE \
        ) {
            if (!dm_is_cursor("rt020_r200_fremd")) {
                dbms declare rt020_r200_fremd cursor for \
                    select \
                        r200.agbs \
                    from \
                        r200 \
                    where \
                        r200.fi_nr = :+FI_NR1 and \
                        r200.fklz  = ::_1 and \
                        r200.agpos = ::_2
               dbms with cursor rt020_r200_fremd alias rt020_agbs
            }
            dbms with cursor rt020_r200_fremd execute using \
                rt020_fklz, \
                rt020_agpos
        }
        else {
            rt020_agbs = ""
        }

        // für Materialien, die einem Fremd-AG als Beistell-Materialien zugeordnet sind,
        // kann keine Kommissionierung durchgeführt werden.
        if ( \
            rt020_agpos > 0 && \
            cod_agbs_fremd(rt020_agbs) == TRUE && \
            ( \
              rt020_kzmat == "1" || \
              rt020_kzmat == "2" || \
              rt020_matbuch == "0" \
            ) && \
            parKommDruckL(4, 1) != "1" \
        ) {
            parKommDruckL = "0"
        }
    }

    // kein Schüttgut
    if (cod_kzmat_kosten(rt020_kzmat) == TRUE) {
        warn_2_failRt020 = warn_2_fail
        warn_2_fail    = FALSE

        // Reservierungsbestand erhöhen
        if (rt020_reservierung() < OK) {
            warn_2_fail = warn_2_failRt020
            return FAILURE
        }

        // Zuordnung zu einem Kommissioniervorgang
        if ( \
            komm_nrRt020 == NULL && \
            parKommDruckL(1, 1) >= "1" && \
            rt020_fu_freig_mat == "4" && \
            rt020_kzmat != "4" && \
            rt020_menge > 0 && \
            ( \
                rt020_matbuch == "0" || \
                ( \
                    rt020_kzmat == "1" || \
                    rt020_kzmat == "3" \
                ) || \
                cod_pos_herk_versorgung(rt020_pos_herk) == TRUE \
            ) \
        ) {
            // nur wenn keine physische Reservierung oder wenn (Teil-) Mengen reserviert werden konnten
            if ( \
                rt020_kn_lgres != "1" || \
                rt020_menge_res_lm100 > 0 || \
                parKommDruckL(1, 1) == "1" \
            ) {
                // Bei Versorgung wird zusätzlich nach Ziel-Lager eingeschränkt
                // d.h. je Ziel-Lager ein separater KommVorgang
                vars usingL
                vars lgnrR000L

                if (cod_pos_herk_versorgung(rt020_pos_herk) == TRUE) {
                    fromL = ", r000 "
                    whereL = " and r000.fi_nr = r100.fi_nr " ## \
                             " and r000.fklz  = r100.fklz  " ## \
                             " and r000.lgnr  = \:\:rt020_lgnr_r000 "
                    lgnrR000L = ", rt020_lgnr_r000 "
                }

                if (!dm_is_cursor("rt020_cur_komm")) {
                    dbms declare rt020_cur_komm cursor for \
                        select \
                            l820.komm_nr, \
                            l82010.lfdnr \
                        from \
                            l820, \
                            l82010, \
                            r100 \
                            :fromL \
                        where \
                            l820.fi_nr     = ::FI_NR1 and \
                            l820.bearb     = ::bearbRt020 and \
                            l82010.fi_nr   = l820.fi_nr and \
                            l82010.komm_nr = l820.komm_nr and \
                            r100.fi_nr     = l82010.fi_nr and \
                            r100.fmlz      = l82010.fmlz and \
                            r100.lgnr      = ::rt020_lgnr and \
                            r100.werk      = ::rt020_werk_mat \
                            :whereL \
                        union all \
                        select \
                            l820.komm_nr, \
                            l82030.lfdnr \
                        from \
                            l820, \
                            l82030, \
                            r100 \
                            :fromL \
                        where \
                            l820.fi_nr     = ::FI_NR1 and \
                            l820.bearb     = ::bearbRt020 and \
                            l82030.fi_nr   = l820.fi_nr and \
                            l82030.komm_nr = l820.komm_nr and \
                            r100.fi_nr     = l82030.fi_nr and \
                            r100.fmlz      = l82030.fmlz and \
                            r100.lgnr      = ::rt020_lgnr and \
                            r100.werk      = ::rt020_werk_mat \
                            :whereL \
                        order by \
                            2 desc
                    dbms with cursor rt020_cur_komm alias \
                        komm_nrRt020, \
                        lfdnrRt020
                }

                usingL = "   FI_NR1, bearbRt020, rt020_lgnr, rt020_werk_mat " ## lgnrR000L ## \
                         ", FI_NR1, bearbRt020, rt020_lgnr, rt020_werk_mat " ## lgnrR000L

                dbms with cursor rt020_cur_komm execute using :usingL

                if (komm_nrRt020 == "") {
                    lfdnrRt020 = 0
                }
                lfdnrRt020 = lfdnrRt020 + 10

                rt020_lm820_handle = fertig_load_modul("lm820", rt020_lm820_handle)
                if (rt020_lm820_handle < 0) {
                    warn_2_fail = warn_2_failRt020
                    return FAILURE
                }
                call lm820_activate(rt020_lm820_handle)
                call lm820_init()

                komm_nrLm820EA = komm_nrRt020
                lfdnrLm820EA = lfdnrRt020
                if (cod_pos_herk_verpack(rt020_pos_herk(1, 1)) == TRUE) {
                    verpackungLm820E = "1"
                    identnrLm820EA = rt020_identnr_mat
                }
                else {
                    verpackungLm820E = "0"
                }
                if ( \
                    rt020_pos_herk(1, 1) == "6" || \
                    rt020_pos_herk(1, 1) == "A" \
                ) {
                    kn_komm_nrLm820EA = "1"
                }
                else {
                    kn_komm_nrLm820EA = "2"
                }
                bearbLm820EA = bearbRt020
                fmlzLm820EA = rt020_fmlz

                if ( \
                    rt020_kn_lgres >= "1" && \
                    parKommDruckL(1, 1) == "2" \
                ) {
                    mengeLm820EA = rt020_menge_res_lm100
                }
                else {
                    mengeLm820EA = rt020_menge
                }
                vers_artLm820EA = 0
                aufnrLm820EA = rt020_aufnr
                aufposLm820EA = rt020_aufpos
                seblposLm820EA = 0
                lfdnr_eintlLm820EA = 0

                // Freigabe Kommissionierliste/-vorgang
                if (parKommDruckL(2, 1) == "1") {
                    st_komm_nrLm820EA = 4
                }

                rcL = lm820_1speichern()
                if (rcL != OK) {
                    warn_2_fail = warn_2_failRt020
                    call bu_msg_errmsg("lm820")
                    call lm820_deactivate(rt020_lm820_handle)
                    return rcL
                }

                call lm820_deactivate(rt020_lm820_handle)
            }
        }
        warn_2_fail = warn_2_failRt020

        // Setzen Materialstatus
        if (rt020_fu_freig_mat == "1") {
            if ( \
                kn_komm_nrRt020 != "9" && \
                komm_nrRt020    != "" \
            ) {
                if (rt020_pos_herk <= "6") {
                    dbms sql \
                        delete from \
                            l82010 \
                        where \
                            l82010.fi_nr      = :+FI_NR1 and \
                            l82010.fmlz       = :+rt020_fmlz and \
                            l82010.st_komm_nr < '4'

                    if (SQL_CODE != SQL_OK) {
                        // Fehler beim Löschen in Tabelle %s.
                        return on_error(FAILURE, "APPL0005", "l82010", "rt020_proto_mat")
                    }
                }
                else {
                    dbms sql \
                        delete from \
                            l82030 \
                        where \
                            l82030.fi_nr      = :+FI_NR1 and \
                            l82030.fmlz       = :+rt020_fmlz and \
                            l82030.st_komm_nr < '4'

                    if (SQL_CODE != SQL_OK) {
                        // Fehler beim Löschen in Tabelle %s.
                        return on_error(FAILURE, "APPL0005", "l82010", "rt020_proto_mat")
                    }
                }
            }
        }
    }

    // Update Material, um die dispositiv offene Menge zu aktualisieren
    if (rt020_update_r100() < OK) {
        return FAILURE
    }

    // Update Lagerstamm
    if (rt020_update_g020() < OK) {
        return FAILURE
    }

    warn_2_failRt020 = warn_2_fail
    warn_2_fail    = FALSE

    // Aufruf Materialentnahme zu kzmat = 4
    if (rt020_call_rm131() < OK) {
        warn_2_fail = warn_2_failRt020
        return FAILURE
    }

    warn_2_fail = warn_2_failRt020

    return OK
}

# proc Externe Methoden: INSERT_r025_aus_API------------------------------------------------------------------------

/**
 * Aktionssatz in r025 für die API abstellen
 *
 * Extern aufrufbare Methode
 *
 * @param r025P             Daten für den Insert in die r025:
 *                              [r025P=>fi_nr]
 *                              [r025P=>werk]
 *                              [r025P=>fklz]
 *                              [r025P=>aufnr]
 *                              [r025P=>aufpos]
 *                              [r025P=>freigabe]
 *                              [r025P=>fu_matpr]
 * @param r000P             FA-Daten:
 *                              r000P=>fi_nr
 *                              r000P=>werk
 *                              r000P=>fklz
 *                              r000P=>aufnr
 *                              r000P=>aufpos
 *                              r000P=>freigabe
 *                              r000P=>aart
 *                              r000P=>fkfs
 *                              r000P=>kneintl
 * @param start_freigabeP   Start rh020 (TRUE) oder kein Start rh020 (FALSE)
 * @param [fehler_textP]    Fehlertext als Instanz von "StringBU"
 * @return OK               Verarbeitung OK und FA-Daten waren gelesen
 *                          r025P=>fi_nr
 *                          r025P=>werk
 *                          r025P=>fklz
 *                          r025P=>aufnr
 *                          r025P=>aufpos
 *                          r025P=>freigabe
 *                          r025P=>fu_matpr
 *                          r025P=>jobid
 *                          r025P=>kz_fhl
 *                          r025P=>kz_matpr
 *                          r025P=>logname
 *                          r025P=>vstat
 *                          r025P=>uuid
 * @return WARNING          Validierungs-Fehler
 *                          fehler_textP=>value
 * @return FAILURE          Fehler
 *                          fehler_textP=>value
 **/
int proc rt020_insert_r025_api(R025CDBI r025P, R000CDBI r000P, boolean start_freigabeP, StringBU fehler_textP)
{
    int rcL


    if (defined(fehler_textP) != TRUE) {
        fehler_textP = StringBU_new()
    }


    // Übergabe-Daten prüfen
    rcL = rt020_pruefen_insert_r025_api(r025P, r000P, fehler_textP)
    switch (rcL) {
        case OK:
            break
        case WARNING:
            return WARNING
        case FAILURE:
        else:
            return FAILURE
    }


    // Einfügen r025_Satz
    rcL = rt020_insert_r025(r025P, fehler_textP)
    if (rcL != OK) {
        return FAILURE
    }


    // Aufruf rh020
    if (start_freigabeP == TRUE) {
        rcL = rt020_start_rh020(r025P)
        switch (rcL) {
            case OK:
            case INFO:
                break
            case FAILURE:
            else:
                return FAILURE
        }
    }

    return OK
}

/**
 * Ermittelt, ob eine FA-Freigabe erlaubt ist oder nicht
 *
 * @param r000P             FA-Daten
 * @param r000P             FA-Daten:
 *                              r000P=>fi_nr
 *                              r000P=>werk
 *                              r000P=>fklz
 *                              r000P=>aart
 *                              r000P=>fkfs
 *                              r000P=>freigabe
 *                              r000P=>kneintl
 * @param [fehler_textP]    Fehlertext als Instanz von "StringBU"
 * @return TRUE             FA-Freigabe kann erfolgen
 * @return FALSE            FA-Freigabe kann nicht erfolgen
 *                          [fehler_textP=>value]       (Fehlertext)
 * @see                     rt020_aktionssatz_r025_erlaubt
 * @see                     rt020_ist_stornofreigabe_fa
 **/
boolean proc rt020_ist_freigabe_fa(R000CDBI r000P, StringBU fehler_textP)
{
    R025CDBI r025L

    call bu_assert((defined(r000P) == TRUE), "r000P nicht übergeben!")

    r025L  = bu_cdbi_new("r025")
    r025L=>fu_freig = FU_FREIG_FREIGABE
    r025L=>fi_nr    = r000P=>fi_nr
    r025L=>werk     = r000P=>werk

    if (defined(fehler_textP) != TRUE) {
        fehler_textP = StringBU_new()
    }

    return rt020_aktionssatz_r025_erlaubt(r025L, r000P, fehler_textP, FALSE, TRUE, TRUE, FALSE, FALSE)
}

/**
 * Ermittelt, ob eine Storno-FA-Freigabe erlaubt ist oder nicht
 *
 * @param r000P             FA-Daten:
 *                              r000P=>fi_nr
 *                              r000P=>werk
 *                              r000P=>fklz
 *                              r000P=>aart
 *                              r000P=>fkfs
 *                              r000P=>freigabe
 *                              r000P=>kneintl
 * @param [fehler_textP]    Fehlertext als Instanz von "StringBU"
 * @return TRUE             Storno-FA-Freigabe kann erfolgen
 * @return FALSE            Storno-FA-Freigabe kann nicht erfolgen
 *                          [fehler_textP=>value]       (Fehlertext)
 * @see                     rt020_aktionssatz_r025_erlaubt
 * @see                     rt020_ist_freigabe_fa
 **/
boolean proc rt020_ist_stornofreigabe_fa(R000CDBI r000P, StringBU fehler_textP)
{
    R025CDBI r025L

    call bu_assert((defined(r000P) == TRUE), "r000P nicht übergeben!")

    r025L  = bu_cdbi_new("r025")
    r025L=>fu_freig = FU_FREIG_STORNO
    r025L=>fi_nr    = r000P=>fi_nr
    r025L=>werk     = r000P=>werk

    if (defined(fehler_textP) != TRUE) {
        fehler_textP = StringBU_new()
    }

    return rt020_aktionssatz_r025_erlaubt(r025L, r000P, fehler_textP, TRUE, TRUE, TRUE, TRUE, TRUE)
}

# proc Interne Methoden: INSERT_r025_aus_API------------------------------------------------------------------------

/**
 * Prüfender Übergabedaten an die Methode "rt020_insert_r025_api"
 *
 * @param r025P             Daten für den Insert in die r025
 *                          r025P=>fu_freig
 *                          [r025P=>fi_nr]
 *                          [r025P=>werk]
 *                          [r025P=>fklz]
 *                          [r025P=>aufnr]
 *                          [r025P=>aufpos]
 *                          [r025P=>freigabe]
 *                          [r025P=>fu_matpr]
 * @param r000P             FA-Daten
 *                          r000P=>fi_nr
 *                          r000P=>werk
 *                          r000P=>fklz
 *                          r000P=>aufnr
 *                          r000P=>aufpos
 *                          r000P=>freigabe
 *                          r000P=>aart
 *                          r000P=>fkfs
 *                          r000P=>kneintl
 * @param [fehler_textP]    Fehlertext als Instanz von "StringBU"
 * @return OK               OK und r000 war gelesen
 *                          r025P=>fi_nr
 *                          r025P=>werk
 *                          r025P=>fklz
 *                          r025P=>aufnr
 *                          r025P=>aufpos
 *                          r025P=>freigabe
 *                          r025P=>fu_matpr
 *                          r025P=>jobid      (Initialisierung)
 *                          r025P=>kz_fhl     (Initialisierung)
 *                          r025P=>kz_matpr   (Initialisierung)
 *                          r025P=>logname    (Initialisierung)
 *                          r025P=>vstat      (Initialisierung)
 * @return WARNING          Validierungs-Fehler
 *                          fehler_textP=>value
 * @return FAILURE          Fehler
 *                          fehler_textP=>value
 * @see                     api_fertigungsauftrag_priv_freigabe_fa_pruefen
 **/
int proc rt020_pruefen_insert_r025_api(R025CDBI r025P, R000CDBI r000P, StringBU fehler_textP)
{
    boolean stornoL

    log LOG_DEBUG, LOGFILE, "fklz >" ## r025P=>fklz ## "< / " \
                         ## "fu_freig >" ## r025P=>fu_freig ## "< / " \
                         ## "aufnr >" ## r025P=>aufnr ## "< / " \
                         ## "aufpos >" ## r025P=>aufpos ## "<"

    // Setzen FU_FREIG
    switch (r025P=>fu_freig) {
        case FU_FREIG_STORNO:           // Storno FA-Freigabe
            stornoL = TRUE
            break
        case FU_FREIG_FREIGABE:         // FA-Freigabe
            stornoL = FALSE
            break
        case $NULL:
        case "":
            // Pflichtfeld >%s< nicht gefüllt!
            fehler_textP=>value = bu_get_msg("APPL0290" , "fu_freig")
            return WARNING
        else:
            // Der Eintrag ist ungültig. (%s)
            fehler_textP=>value = bu_get_msg("APPL0100" , "fu_freig=" ## r025P=>fu_freig)
            return WARNING
    }


    // Prüfen und Setzen FKLZ
    if (defined(r000P=>fklz) != TRUE \
    ||  r000P=>fklz          == "") {
        // Pflichtfeld >%s< nicht gefüllt!
        fehler_textP=>value = bu_get_msg("APPL0290" , "r000.fklz")
        return WARNING
    }
    if (defined(r025P=>fklz) != TRUE \
    ||  r025P=>fklz          == "") {
        r025P=>fklz = r000P=>fklz
    }


    // Setzen AUFNR/AUFPOS
    if (defined(r025P=>aufnr) != TRUE \
    ||  r025P=>aufnr          == "") {
        r025P=>aufnr = r000P=>aufnr
    }
    if (defined(r025P=>aufnr) != TRUE \
    ||  r025P=>aufnr          == "") {
        // Pflichtfeld >%s< nicht gefüllt!
        fehler_textP=>value = bu_get_msg("APPL0290" , "aufnr")
        return WARNING
    }
    if (defined(r025P=>aufpos) != TRUE \
    ||  r025P=>aufpos          <= 0) {
        r025P=>aufpos = r000P=>aufpos
    }


    // Setzen FI_NR
    if (defined(r025P=>fi_nr) != TRUE \
    ||  r025P=>fi_nr          <= 0) {
        r025P=>fi_nr = r000P=>fi_nr
        if (defined(r025P=>fi_nr) != TRUE \
        ||  r025P=>fi_nr          <= 0) {
            r025P=>fi_nr = FI_NR1
        }
    }


    // Setzen WERK
    if (defined(r025P=>werk) != TRUE \
    ||  r025P=>werk          <= 0) {
        r025P=>werk = r000P=>werk
        if (defined(r025P=>werk) != TRUE \
        ||  r025P=>werk          <= 0) {
            r025P=>werk = werk
        }
    }


    // Setzen FREIGABE
    if (defined(r025P=>freigabe) != TRUE \
    ||  r025P=>freigabe          == "") {
        r025P=>freigabe = r000P=>freigabe
        if (defined(r025P=>freigabe) != TRUE \
        ||  r025P=>freigabe          == "") {
            r025P=>freigabe = bu_getenv("R_FREIGABE")
        }
    }


    // Setzen FU_MATPR
    if (r025P=>fu_freig == FU_FREIG_STORNO) {
        // Beim Storno der FA-Freigabe wird dieses Kennzeichen nicht berücksichtigt
        r025P=>fu_matpr = ""
    }
    else {
        if (defined(r025P=>fu_matpr) != TRUE \
        ||  r025P=>fu_matpr          == "") {
            r025P=>fu_matpr = bu_getenv("R_MATPR")
        }
    }


    // Initialisierungen
    r025P=>jobid      = 0
    r025P=>kz_fhl     = ""
    r025P=>kz_matpr   = "0"
    r025P=>logname    = LOGNAME
    r025P=>vstat      = ""


    log LOG_DEBUG, LOGFILE, "fi_nr >" ## r025P=>fi_nr ## "< / " \
                         ## "werk >" ## r025P=>werk ## "< / " \
                         ## "fu_matpr >" ## r025P=>fu_matpr ## "< / " \
                         ## "freigabe >" ## r025P=>freigabe ## "< / " \
                         ## "logname >" ## r025P=>logname ## "<"


    // Prüfungen analog re020, ob Aktionssatz abgestellt werden darf oder nicht
    if (rt020_aktionssatz_r025_erlaubt(r025P, r000P, fehler_textP, stornoL, TRUE, TRUE, TRUE, TRUE) != TRUE) {
        return WARNING
    }

    return OK
}

/**
 * Prüfungen analog re020, ob die FA-Freigabe bzw. die Storno-FA-Freigabe gemacht werden darf oder nicht
 *
 * @param r025P             Daten für den Insert in die r025
 *                          r025P=>fi_nr
 *                          r025P=>werk
 * @param r000P             FA-Daten
 *                          [r000P=>fi_nr]
 *                          [r000P=>werk]
 *                          r000P=>fklz
 *                          r000P=>aart
 *                          r000P=>fkfs
 *                          r000P=>freigabe
 *                          r000P=>kneintl
 * @param [fehler_textP]    Fehlertext als Instanz von "StringBU"
 * @param stornoP           FA-Freigabe (FALSE) oder Storno-FA-Freigabe (TRUE)
 * @param pruefen_r025P     Auf die Aktionstabelle r025 prüfen (TRUE) oder nicht (FALSE)
 * @param pruefen_r115P     Auf die Aktionstabelle r115 prüfen (TRUE) oder nicht (FALSE)
 * @param pruefen_r232P     Auf die Aktionstabelle r232 prüfen (TRUE) oder nicht (FALSE) -> nur bei stornoP=TRUE
 * @param pruefen_r235P     Auf die Aktionstabelle r235 prüfen (TRUE) oder nicht (FALSE) -> nur bei stornoP=TRUE
 * @return TRUE             Aktionssatz in r025 darf abgestellt werden
 * @return FALSE            Aktionssatz in r025 darf nicht abgestellt werden
 *                          fehler_textP=>value
 * @see                     api_fertigungsauftrag_priv_ist_freigabe_fa
 * @see                     api_fertigungsauftrag_priv_where_logische_filter
 **/
boolean proc rt020_aktionssatz_r025_erlaubt(R025CDBI r025P, R000CDBI r000P, StringBU fehler_textP, boolean stornoP, boolean pruefen_r025P, boolean pruefen_r115P, boolean pruefen_r232P, boolean pruefen_r235P)
{
    int      rcL
    int      fi_nrL
    int      werkL
    int      anzahl_r232L
    int      anzahl_r235L
    R115CDBI r115L
    R025CDBI r025L


    log LOG_DEBUG, LOGFILE, "stornoP >" ## stornoP ## "< / " \
                         ## "pruefen_r025P >" ## pruefen_r025P ## "< / " \
                         ## "pruefen_r115P >" ## pruefen_r115P ## "< / " \
                         ## "pruefen_r232P >" ## pruefen_r232P ## "< / " \
                         ## "pruefen_r235P >" ## pruefen_r235P ## "< / " \
                         ## "fklz >" ## r000P=>fklz ## "< / " \
                         ## "aart >" ## r000P=>aart ## "< / " \
                         ## "fkfs >" ## r000P=>fkfs ## "< / " \
                         ## "freigabe >" ## r000P=>freigabe ## "< / " \
                         ## "kneintl >" ## r000P=>kneintl ## "<"


    // Allgemeine Bedingungen (für FA-Freigabe und Storno-FA-Freigabe):
    if (cod_aart_nopsever(r000P=>aart) != TRUE) {
        // Der Eintrag ist ungültig. (%s)
        fehler_textP=>value = bu_get_msg("APPL0100", "aart=" ## r000P=>aart)
        return FALSE
    }

    if (r000P=>freigabe >= "9") {
        // Fertigungsauftrag >%1< kann nicht freigegeben werden!
        fehler_textP=>value = bu_get_msg("r0000283", r000P=>fklz)
        return FALSE
    }

    if (r000P=>kneintl == cKNEINTL_VORSCHAU) {
        // Fertigungsauftrag >%1< hat Liefereinteilung >%2< und kann deshalb nicht freigegeben werden!
        fehler_textP=>value = bu_get_msg("r0000284", r000P=>fklz ## "^" ## r000P=>kneintl)
        return FALSE
    }


    // Prüfung auf den FA-Status
    if (stornoP == TRUE) {
        if (r000P=>fkfs != FSTATUS_FREIGEGEBEN) {
            // Der Status des Fertigungsauftrags muss 4 sein!
            fehler_textP=>value = bu_get_msg("r0000208", "")
            return FALSE
        }
    }
    else {  // FA-Freigabe:
        if (r000P=>fkfs != FSTATUS_TERMINIERT) {
            // Der Status des Fertigungsauftrags muss 3 sein!
            fehler_textP=>value = bu_get_msg("r0000207", "")
            return FALSE
        }
    }


    // Ggf. Ermitteln Firma/Standort für Selektion Aktionssätze
    if (pruefen_r025P == TRUE \
    ||  pruefen_r115P == TRUE \
    ||  pruefen_r232P == TRUE \
    ||  pruefen_r235P == TRUE) {
        if (defined(r000P=>fi_nr) == TRUE \
        &&  r000P=>fi_nr          >  0) {
            fi_nrL = r000P=>fi_nr
        }
        else if (defined(r025P=>fi_nr) == TRUE \
             &&  r025P=>fi_nr          >  0) {
            fi_nrL = r025P=>fi_nr
        }
        else {
            fi_nrL = FI_NR1
        }

        if (defined(r000P=>werk) == TRUE \
        &&  r000P=>werk          >  0) {
            werkL = r000P=>werk
        }
        else if (defined(r025P=>werk) == TRUE \
             &&  r025P=>werk          >  0) {
            werkL = r025P=>werk
        }
        else {
            werkL = werk
        }
        log LOG_DEBUG, LOGFILE, "fi_nr >" ## fi_nrL ## "< / " \
                             ## "werk >" ## werkL ## "<"
    }


    if (pruefen_r025P == TRUE) {
        // Aktionssatz aus r025 immer prüfen
        r025L = bu_cdbi_new("r025")
        r025L=>fi_nr = fi_nrL
        r025L=>fklz  = r000P=>fklz
        rcL = bu_cdbi_read_cursor(r025L, "", FALSE, FALSE)
        switch (rcL) {
            case SQLNOTFOUND:
                break
            case SQL_OK:
                // Aktion Auftragsfreigabe >%1< vorhanden
                fehler_textP=>value = bu_get_msg("r0250001", r000P=>fklz)
                return FALSE
            case FAILURE:
            else:
                // Fehler beim Lesen in Tabelle %s
                fehler_textP=>value = bu_get_msg("APPL006", "r025 SQL_CODE=" ## rcL)
                return FALSE
        }
    }


    if (pruefen_r115P == TRUE) {
        // Aktionssatz aus r115 immer prüfen
        r115L = bu_cdbi_new("r115")
        r115L=>fi_nr   = fi_nrL
        r115L=>werk    = werkL
        r115L=>fklz    = r000P=>fklz
        r115L=>identnr = ""
        r115L=>var     = ""
        r115L=>lgnr    = 0
        rcL = bu_cdbi_read_cursor(r115L, "", FALSE, FALSE)
        switch (rcL) {
            case SQLNOTFOUND:
                break
            case SQL_OK:
                // Aktion Bedarfsrechnung >%1< vorhanden
                fehler_textP=>value = bu_get_msg("r1150001", r000P=>fklz)
                return FALSE
            case FAILURE:
            else:
                // Fehler beim Lesen in Tabelle %s
                fehler_textP=>value = bu_get_msg("APPL006", "r115 SQL_CODE=" ## rcL)
                return FALSE
        }
    }


    // Individuelle Bedingungen (nur für FA-Freigabe bzw. den Storno der FA-Freigabe):
    if (stornoP == TRUE) {
        if (pruefen_r235P == TRUE) {
            // Aktionssatz aus r235 prüfen (Es können mehrere Sätze pro FKLZ in r235 sein!)
            if (dm_is_cursor("count_r235_rt020C") != TRUE) {
                dbms declare count_r235_rt020C cursor for \
                    select count(*) \
                    from r235 \
                    where r235.fi_nr = ::_1 \
                    and   r235.fklz  = ::_2

                dbms with cursor count_r235_rt020C alias \
                    anzahl_r235L
            }
            dbms with cursor count_r235_rt020C execute using \
                fi_nrL, \
                r000P=>fklz
            if (SQL_CODE != SQL_OK) {
                // Fehler beim Lesen in Tabelle %s
                fehler_textP=>value = bu_get_msg("APPL006", "r235 SQL_CODE=" ## SQL_CODE)
                return FALSE
            }
            if (anzahl_r235L > 0) {
                // Aktionssätze für AG-Rückmeldung vorhanden - Auftragsfreigabe kann nicht storniert werden!
                fehler_textP=>value = bu_get_msg("r2350108", "")
                return FALSE
            }
        }


        if (pruefen_r232P == TRUE) {
            // Aktionssatz aus r232 prüfen
            // -> Es können mehrere Sätze pro FKLZ/FALZ in r232 sein!
            if (dm_is_cursor("count_r232_rt020C") != TRUE) {
                dbms declare count_r232_rt020C cursor for \
                    select count(*) \
                    from r200 \
                    join r232 on (r232.fi_nr = r200.fi_nr and r232.falz = r200.falz) \
                    where r200.fi_nr = ::_1 \
                    and   r200.fklz  = ::_2

                dbms with cursor count_r232_rt020C alias \
                    anzahl_r232L
            }
            dbms with cursor count_r232_rt020C execute using \
                fi_nrL, \
                r000P=>fklz
            if (SQL_CODE != SQL_OK) {
                // Fehler beim Lesen in Tabelle %s
                fehler_textP=>value = bu_get_msg("APPL006", "r232 SQL_CODE=" ## SQL_CODE)
                return FALSE
            }
            if (anzahl_r232L > 0) {
                // Aktionssätze für Arbeitsgangrückmeldung BDE vorhanden - Auftragsfreigabe kann nicht storniert werden!
                fehler_textP=>value = bu_get_msg("r2320126", "")
                return FALSE
            }
        }
    }

    return TRUE
}

/**
 * Insert in die Aktionstabele r025
 *
 * @param r025P         CDBI-Instanz der r025
 * @param fehler_textP  Fehlertext als Instanz von "StringBU"
 * @return OK
 * @return FAILURE      Fehler
 *                      fehler_textP=>value
 **/
int proc rt020_insert_r025(R025CDBI r025P, StringBU fehler_textP)
{
    int rcL


    if (defined(r025P) != TRUE) {
        return FAILURE
    }

    rcL = bu_cdbi_insert(r025P, TRUE, FALSE, FALSE)
    switch (rcL) {
        case SQL_OK:
        case SQLE_DUPKEY:
            break
        else:
            // Fehler beim Einfügen in Tabelle >%s<.
            fehler_textP=>value = bu_get_msg("APPL0003" , "r025")
            return FAILURE
    }

    return OK
}

/**
 * Start Verarbeitung der Freigabe über rh020
 *
 * @param r025P         CDBI-Instanz der r025
 * @return OK           rh020 wurde gestartet
 * @return INFO         rh020 wurde nicht gestartet
 * @return FAILURE      Fehler
 *                      fehler_textP=>value
 * @see                 api_fertigungsauftrag_priv_start_rh020
 * @see                 rj020 / rh020
 **/
int proc rt020_start_rh020(R025CDBI r025P)
{
    if (defined(r025P=>fklz) != TRUE \
    ||  r025P=>fklz          == "") {
        return INFO
    }


    partab[1] = r025P=>logname
    partab[2] = ""                  // aufnr_von
    partab[3] = ""                  // aufpos_von
    partab[4] = ""                  // aufnr_bis
    partab[5] = ""                  // aufpos_bis
    partab[6] = "4"                 // prio
    partab[7] = ""                  // undefiniert
    partab[8] = LANG_EXT
    partab[9] = ""                  // undefiniert
    partab[10] = cFERTIG_LISTE      // Vorlaufdaten oder Liste an Report übergeben
    partab[11] = r025P=>fklz        // Liste -> nur die eine FKLZ, d.h. nur der aktuelle FA


    // Aufruf rh020 nicht lokal
    call bu_job("rh020", $NULL, $NULL, $NULL, $NULL, $NULL, "!l")

    return OK
}

/**
 * Übergibt die Änderung an die Werkstattsteuerung
 *
 * @return OK
 * @return FAILURE
 **/
int proc rt020_uebergeben_an_werkstattsteuerung()
{
    int rcL
    string woher_wsL
    cdtRq200 rq200L
    cdt kontext_globalL
    cdtTermGlobal cdtTermGlobalL = $NULL

    // Ggf. Initialisierung des Kennzeichens für die Feinplanung
    if (rt020_kn_ws_ag == "") {
        rt020_kn_ws_ag = KN_WS_KEINE
    }

    switch (rt020_fu_freig_ag) {
        case FU_FREIG_FREIGABE:
            woher_wsL = "FREIGABE"
            break
        case FU_FREIG_STORNO:
            woher_wsL = "FREIGABE_STORNO"
            break
        else:
            break
    }

    if (!defined(cdtTermGlobalL)) {
        kontext_globalL = new cdtFertigKontextTerminierungGlobal()
        if (fertig_load_globale_daten_terminierung(kontext_globalL, TRUE) != OK) {
            call bu_rollback()
            return FAILURE
        }
        cdtTermGlobalL = kontext_globalL=>kontext
    }

    public rq200.bsl
    rq200L = rq200_new(cdtTermGlobalL, FI_NR1, werk, rt020_falz)
    call rq200_set_woher_ws(rq200L, woher_wsL)
    call rq200_set_aufrufer(rq200L, "rt020")
    call rq200_set_clear_message(rq200L, TRUE)
    rcL = rq200_werkstattsteuerung(rq200L)
    if (rcL != OK) {
        call bu_rollback()
        return FAILURE
    }
    call rq200_set_clear_message(rq200L, TRUE)
    call rq200_speichern_protokoll_funktion(rq200L, "", "", "", rcL ## ", $NULL")

    if (defined(cdtTermGlobalL)) {
        call fertig_unload_terminierungsmodule(cdtTermGlobalL, "")
    }

    return OK
}