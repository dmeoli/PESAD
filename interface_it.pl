%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		interface_it.pl
%                                                                           
%	description:
%		Il modulo interface_it si occupa di gestire l'interfaccia del sistema esperto.
%                                       									    
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


decodifica(paziente, 'Selezionare la fascia d''eta'' del paziente') :- !.
spiega(paziente, 'La fascia d''eta'' del paziente e'' importante per differenziare, aggiungere o escludere dei sintomi per alcune diagnosi') :- !.
decodifica(bambino, '0-9') :- !.
decodifica(adolescente, '10-17') :- !.
decodifica(adulto, '>=18') :- !.

decodifica(escalation_ansia_o_forte_paura, 'Vive brevi momenti caratterizzati da una rapida escalation dell''ansia o da una forte paura') :- !.
spiega(escalation_ansia_o_forte_paura, 'Mi serve per verificare la presenza di attacco di panico') :- !.

decodifica(palpitazioni, 'Avverte palpitazioni al cuore o elevata frequenza cardiaca') :- !.
spiega(palpitazioni, 'La presenza di palpitazioni potrebbe essere indice di attacco di panico') :- !.

decodifica(sudorazione, 'Mostra una sudorazione eccessiva') :- !.
spiega(sudorazione, 'La presenza di sudorazione potrebbe essere indice di attacco di panico') :- !.

decodifica(tremore, 'Ha tremori fini o a grandi scosse') :- !.
spiega(tremore, 'La presenza di tremori potrebbe essere indice di attacco di panico') :- !.

decodifica(dispnea, 'Ha fiato corto o difficolta'' respiratorie') :- !.
spiega(dispnea, 'La presenza di difficolta'' respiratorie potrebbe essere indice di attacco di panico') :- !.

decodifica(asfissia, 'Si sente come se stesse soffocando o come se non potesse deglutire') :- !.
spiega(asfissia, 'La presenza di asfissia potrebbe essere indice di attacco di panico') :- !.

decodifica(dolore_al_petto, 'Prova dolore o fastidio al petto') :- !.
spiega(dolore_al_petto, 'La presenza di dolore o fastidio al petto potrebbe essere indice di attacco di panico') :- !.

decodifica(nausea, 'Ha disturbi di stomaco o nausea o dolori addominali') :- !.
spiega(nausea, 'La presenza di nausea o dolori addominali potrebbe essere indice di attacco di panico') :- !.

decodifica(testa_leggera, 'Avverte sensazioni di sbandamento o di testa leggera') :- !.
spiega(testa_leggera, 'La presenza di sensazioni di sbandamento o testa leggera potrebbe essere indice di attacco di panico') :- !.

decodifica(derealizzazione, 'Percepisce il mondo come un qualcosa di irreale') :- !.
spiega(derealizzazione, 'Percepire il mondo in maniera irreale potrebbe essere indice di attacco di panico oppure potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(depersonalizzazione, 'Si sente come distaccato da se stesso') :- !.
spiega(depersonalizzazione, 'Sentirsi distaccato da se stessi potrebbe essere indice di attacco di panico oppure potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(paura_di_impazzire, 'Ha timore di perdere il controllo o di impazzire') :- !.
spiega(paura_di_impazzire, 'La paura di impazzire potrebbe essere indice di attacco di panico') :- !.

decodifica(paura_di_morire, 'Teme di stare per morire') :- !.
spiega(paura_di_morire, 'La paura di morire potrebbe essere indice di attacco di panico') :- !.

decodifica(parestesie, 'Prova sensazioni di torpore o di formocolio') :- !.
spiega(parestesie, 'La presenza di parestesie potrebbe essere indice di attacco di panico') :- !.

decodifica(brividi_o_vampate_calore, 'Prova brividi o vampate di calore') :- !.
spiega(brividi_o_vampate_calore, 'La presenza di brividi o vampate di calore potrebbe essere indice di attacco di panico') :- !.

decodifica(tipo_attacco, 'Quando si manifesta il disagio') :- !.
spiega(tipo_attacco, 'Individuare una relazione fra l''esordio dell''attacco e la presenza di fattori scatenanti situazionali permette di distinguere un attacco di panico provocato da un attacco di panico inaspettato') :- !.
decodifica(attacco_inaspettato, 'All''improvviso ed in maniera spontanea') :- !.
decodifica(attacco_provocato, 'Subito dopo l''esposizione o nell''attesa di un fattore scatenante') :- !.

decodifica(comportamento_protettivo, 'Cerca di proteggersi dagli attacchi accertandosi anticipatamente della presenza di presidi medici o di uscite di sicurezza nei pressi in cui staziona') :- !.
spiega(comportamento_protettivo, 'Il fatto che il paziente metta in atto un comportamento protettivo potrebbe essere indice di ansia anticipatoria, la quale fa propendere verso il disturbo di panico') :- !.

decodifica(comportamento_evitante, 'Limita o evita attivita'' o spostamenti a piedi o per mezzi di trasporto') :- !.
spiega(comportamento_evitante, 'Il fatto che il paziente metta in atto un comportamento evitante potrebbe essere indice di ansia anticipatoria, la quale fa propendere verso il disturbo di panico') :- !.

decodifica(preoccupazione_conseguenze_attacchi_ansia, 'Si preoccupa eccessivamente circa le conseguenze che possono derivare dai diversi attacchi d''ansia') :- !.
spiega(preoccupazione_conseguenze_attacchi_ansia, 'Il fatto che il paziente si preoccupi delle conseguenze di un attacco di panico potrebbe essere indice di ansia anticipatoria, la quale fa propendere verso il disturbo di panico') :- !.

decodifica(preoccupazione_nuovi_attacchi_ansia, 'E'' persistentemente preoccupato di avere nuovi attacchi d''ansia') :- !.
spiega(preoccupazione_nuovi_attacchi_ansia, 'Il fatto che il paziente tenda ad aver paura di nuovi attacchi d''ansia potrebbe essere indice di ansia anticipatoria, la quale fa propendere verso il disturbo di panico') :- !.

decodifica(frequenza_attacchi_di_panico, 'Quanti attacchi d''ansia ricorda di aver subito') :- !.
spiega(frequenza_attacchi_di_panico, 'La presenza di almeno due attacchi di panico confermerebbe la diagnosi a favore del disturbo di panico') :- !.
decodifica(uguale_minore_uno, '<= 1') :- !.
decodifica(da_due_a_cinque, '>= 2 & < 5') :- !.
decodifica(piu_di_cinque, '>= 5') :- !.

decodifica(durata_sintomi, 'Da quanto tempo persistono i sintomi') :- !.
spiega(durata_sintomi, 'Con la durata dei sintomi e'' possibile prendere in considerazione alcune diagnosi piuttosto che altre') :- !.
decodifica(meno_due_giorni, '< 2 giorni') :- !.
decodifica(due_giorni_meno_un_mese, '>= 2 giorni & < 1 mese') :- !.
decodifica(un_mese_meno_tre_mesi, '>= 1 mese & < 3 mesi') :- !.
decodifica(tre_mesi_meno_sei_mesi, '>= 3 mesi & < 6 mesi') :- !.
decodifica(sei_mesi_piu, '>= 6 mesi') :- !.

decodifica(paura_agorafobica, 'Avverte una sensazione di paura o grave disagio quando si ritrova in ambienti non familiari o in luoghi aperti o affollati') :- !.
spiega(paura_agorafobica, 'Mi serve per verificare la presenza di agorafobia') :- !.

decodifica(fobia_uscite, 'Ha paura o evita di uscire di casa da solo') :- !.
spiega(fobia_uscite, 'La paura o l''evitamento pervasivo verso le uscite di casa rappresenterebbe un indizio a favore dell''agorafobia') :- !.

decodifica(fobia_luoghi_affollati, 'Ha paura o evita di frequentare luoghi affollati (per es., cinema, supermercati, ristoranti, discoteche)') :- !.
spiega(fobia_luoghi_affollati, 'La paura o l''evitamento pervasivo verso la frequentazione di luoghi affollati rappresenterebbe un indizio a favore dell''agorafobia') :- !.

decodifica(fobia_lunghe_file, 'Si sente a disagio quando si trova bloccato in una lunga coda') :- !.
spiega(fobia_lunghe_file, 'Il disagio per le lunghe code rappresenterebbe un indizio a favore dell''agorafobia') :- !.

decodifica(fobia_solitudine, 'Ha timore o evita di restare da solo in diverse circostanze') :- !.
spiega(fobia_solitudine, 'La paura o l''evitamento pervasivo verso la solitudine rappresenterebbe un indizio a favore dell''agorafobia') :- !.

decodifica(fobia_mezzi_trasporto, 'Ha paura o evita di viaggiare in auto o di prendere autobus, treni o aerei') :- !.
spiega(fobia_mezzi_trasporto, 'La paura o l''evitamento pervasivo verso i mezzi di trasporto indirizzerebbe la diagnosi a favore dell''agorafobia o della fobia specifica situazionale') :- !.

decodifica(fobia_spazi_stretti_o_chiusi, 'Ha paura o evita di accedere in luoghi chiusi o stretti come gli ascensori, i ponti o le gallerie') :- !.
spiega(fobia_spazi_stretti_o_chiusi, 'La paura o l''evitamento pervasivo verso gli spazi stretti o chiusi indirizzerebbe la diagnosi a favore dell''agorafobia o della fobia specifica situazionale') :- !.

decodifica(tipo_ansia, 'Per quale motivo e'' fortemente in ansia') :- !.
spiega(tipo_ansia, 'A seconda del motivo che caratterizza il manifestarsi dall''ansia si possono prendere in esame alcuni disturbi piuttosto che altri') :- !.
decodifica(difficolta_allontanamento_o_indisponibilita_aiuto, 'Per il timore di non poter allontanarsi o chiedere aiuto in caso di attacco d''ansia') :- !.
decodifica(imbarazzo_in_pubblico, 'Per il timore di poter rimanere imbarazzato in pubblico') :- !.
decodifica(pericolo_salute,'Per il timore di poter mettere in serio pericolo la propria salute') :- !.
decodifica(attesa_apprensiva, 'Per il timore di non riuscire ad affrontare circostanze abitudinarie o piccoli contrattempi di giornata') :- !.
decodifica(altro_tipo_ansia, 'Per altro') :- !.

decodifica(tipo_reazione_fobica, 'Come si comporta nei confronti delle situazioni temute') :- !.
spiega(tipo_reazione_fobica, 'Capire il comportamento che il paziente mette in atto verso le situazioni temute consentirebbe di rafforzare o diminuire la probabilita'' a favore di una diagnosi fobica') :- !.
decodifica(evitamento, 'Cerca di evitarle il piu'' possibile') :- !.
decodifica(sopportazione_con_disagio, 'Si sforza di sopportarle vivendo, pero'', dei momenti di intenso disagio') :- !.
decodifica(sopportazione_senza_problemi, 'Le sopporta senza alcun problema') :- !.

decodifica(paura_fobica_prestazionale, 'Teme le situazioni in cui i suoi atteggiamenti o le sue prestazioni sono esposte al giudizio altrui') :- !.
spiega(paura_fobica_prestazionale, 'Mi serve per verificare la presenza di fobia sociale') :- !.

decodifica(paura_fobica_sociale, 'Avverte un eccessivo disagio quando si ritrova a contatto con altre persone in contesti non familiari') :- !.
spiega(paura_fobica_sociale, 'Mi serve per verificare la presenza di fobia sociale') :- !.

decodifica(fobia_parlare_agire_pubblicamente, 'Ha paura o evita di parlare o esibirsi in pubblico') :- !.
spiega(fobia_parlare_agire_pubblicamente, 'La paura o l''evitamento verso il parlare o l''agire in pubblico rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_usare_telefono_pubblicamente, 'Ha paura o evita di usare il telefono in pubblico') :- !.
spiega(fobia_usare_telefono_pubblicamente, 'La paura o l''evitamento verso l''uso del telefono in pubblico rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_mangiare_bere_pubblicamente, 'Ha paura o evita di mangiare o bere in presenza di gente estranea') :- !.
spiega(fobia_mangiare_bere_pubblicamente, 'La paura o l''evitamento verso il mangiare o il bere in pubblico rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_scrivere_firmare_pubblicamente, 'Ha paura o evita di scrivere o firmare in pubblico') :- !.
spiega(fobia_scrivere_firmare_pubblicamente, 'La paura o l''evitamento verso lo scrivere o il firmare in pubblico rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_essere_osservato_pubblicamente, 'Ha paura o evita di essere osservato mentre svolge una attivita''') :- !.
spiega(fobia_essere_osservato_pubblicamente, 'La paura o l''evitamento verso lo svolgimento delle attivita'' in pubblico rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_frequentare_bagni_pubblici, 'Ha paura o evita di servirsi di una toilette pubblica') :- !.
spiega(fobia_frequentare_bagni_pubblici, 'La paura o l''evitamento verso l''uso della toilette pubblica rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_entrare_stanza_affollata, 'Ha paura o evita di entrare in una stanza affollata oppure in cui tutti sono gia'' seduti') :- !.
spiega(fobia_entrare_stanza_affollata, 'La paura o l''evitamento verso l''accesso in stanze affollate rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_presentarsi_estranei, 'Avverte un marcato disagio nel presentarsi o nell''essere presentato a gente estranea') :- !.
spiega(fobia_presentarsi_estranei, 'Il disagio avvertito nel presentarsi o nell''essere presentato a gente estranea rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_incontrare_autorita, 'Ha paura o evita di incontrare o parlare con persone autorevoli') :- !.
spiega(fobia_incontrare_autorita, 'La paura o l''evitamento verso gli incontri con gente autorevole rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_partecipare_festa, 'Ha paura o evita di andare ad una festa o partecipare ad una festa in suo onore') :- !.
spiega(fobia_partecipare_festa, 'La paura o l''evitamento verso le partecipazioni a delle feste rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_ricevere_ospiti, 'Ha paura o evita di ricevere degli ospiti in casa') :- !.
spiega(fobia_ricevere_ospiti, 'La paura o l''evitamento verso l''accoglienza degli ospiti in casa rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_parlare_estranei, 'Ha paura o evita di parlare con gente non familiare') :- !.
spiega(fobia_parlare_estranei, 'La paura o l''evitamento verso l''intrattenersi in conversazioni con persone non familiari rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(fobia_incontrare_sesso_opposto, 'Ha paura o evita di avvicinarsi a persone dell''altro sesso o di incontrare persone da cui e'' attratto') :- !.
spiega(fobia_incontrare_sesso_opposto, 'La paura o l''evitamento verso gli incontri con persone da cui si e'' attratti o dell''altro sesso rappresenterebbe un indizio a favore della fobia sociale') :- !.

decodifica(paura_fobica_specifica, 'Capita di avere una eccessiva paura nei confronti di determinati oggetti o specifiche situazioni') :- !.
spiega(paura_fobica_specifica, 'Mi serve per verificare la presenza di fobia specifica') :- !.

decodifica(fobia_ragni, 'Ha paura dei ragni') :- !.
spiega(fobia_ragni, 'L''aracnofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_uccelli, 'Ha paura degli uccelli') :- !.
spiega(fobia_uccelli, 'L''ornitofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_rettili_o_serpenti, 'Ha paura dei rettili o dei serpenti') :- !.
spiega(fobia_rettili_o_serpenti, 'L''herpetofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_topi, 'Ha paura dei topi') :- !.
spiega(fobia_topi, 'La musofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_cani_o_gatti, 'Ha paura dei cani o dei gatti') :- !.
spiega(fobia_cani_o_gatti, 'La cinofobia o l''ailurofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_insetti, 'Ha paura degli insetti') :- !.
spiega(fobia_insetti, 'L''entomofobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_api_o_calabroni, 'Ha paura delle api o dei calabroni') :- !.
spiega(fobia_api_o_calabroni, 'L''apifobia farebbe propendere per una diagnosi di fobia specifica di tipo animali') :- !.

decodifica(fobia_temporali, 'Ha paura dei temporali') :- !.
spiega(fobia_temporali, 'La brontofobia farebbe propendere per una diagnosi di fobia specifica di tipo ambiente naturale') :- !.

decodifica(fobia_altezze, 'Ha paura delle grandi altezze o delle sporgenze') :- !.
spiega(fobia_altezze, 'L''acrofobia farebbe propendere per una diagnosi di fobia specifica di tipo ambiente naturale') :- !.

decodifica(fobia_buio, 'Ha paura del buio o dell''oscurita''') :- !.
spiega(fobia_buio, 'La scotofobia farebbe propendere per una diagnosi di fobia specifica di tipo ambiente naturale') :- !.

decodifica(fobia_acqua, 'Ha paura dell''acqua profonda o dei grandi corsi d''acqua') :- !.
spiega(fobia_acqua, 'L''idrofobia farebbe propendere per una diagnosi di fobia specifica di tipo ambiente naturale') :- !.

decodifica(fobia_sangue_o_ferite, 'Ha paura del sangue o di profonde ferite') :- !.
spiega(fobia_sangue_o_ferite, 'L''emofobia o la traumatofobia farebbe propendere per una diagnosi di fobia specifica di tipo sangue-iniezioni-ferite') :- !.

decodifica(fobia_aghi_o_iniezioni, 'Ha paura degli aghi o delle iniezioni') :- !.
spiega(fobia_aghi_o_iniezioni, 'La belonefobia o la tripanofobia farebbe propendere per una diagnosi di fobia specifica di tipo sangue-iniezioni-ferite') :- !.

decodifica(fobia_medicazioni_invasive, 'Ha paura delle procedure mediche invasive') :- !.
spiega(fobia_medicazioni_invasive, 'La fobia per le medicazioni invasive farebbe propendere per una diagnosi di fobia specifica di tipo sangue-iniezioni-ferite') :- !.

decodifica(fobia_malattie_o_soffocamento, 'Ha paura di contrarre una malattia o di soffocare') :- !.
spiega(fobia_malattie_o_soffocamento, 'La patofobia o la pnigofobia farebbe propendere per una diagnosi di fobia specifica di altro tipo') :- !.

decodifica(fobia_vomito, 'Ha paura del vomito o del vomitare') :- !.
spiega(fobia_vomito, 'L''emetofobia farebbe propendere per una diagnosi di fobia specifica di altro tipo') :- !.

decodifica(fobia_boati_o_rumori_forti, 'Ha paura dei boati o dei forti rumori') :- !.
spiega(fobia_boati_o_rumori_forti, 'La liguirofobia farebbe propendere per una diagnosi di fobia specifica di altro tipo') :- !.

decodifica(fobia_maschere, 'Ha paura dei personaggi in maschera o dei clown') :- !.
spiega(fobia_maschere, 'La coulrofobia farebbe propendere per una diagnosi di fobia specifica di altro tipo') :- !.

decodifica(fobia_morte, 'Ha paura della morte o dei patimenti che la precedono') :- !.
spiega(fobia_morte, 'La tanatofobia o la necrofobia farebbe propendere per una diagnosi di fobia specifica di altro tipo') :- !.

decodifica(insight_eccesso_o_irragionevolezza_paura_fobica, 'Riconosce che la paura nei confronti della situzione fobica e'' eccessiva o irragionevole') :- !.
spiega(insight_eccesso_o_irragionevolezza_paura_fobica, 'Il riconoscimento dell''eccesso o della irragionevolezza della paura da parte del paziente farebbe supporre la presenza di un disturbo fobico') :- !.

decodifica(disagio_lavorativo, 'Il disturbo causa un disagio significativo nelle attivita'' lavorative o scolastiche') :- !.
spiega(disagio_lavorativo, 'Una interferenza importante dell''ansia con il lavoro o lo studio farebbe supporre la presenza di un disagio marcato e significativo nel paziente') :- !.

decodifica(disagio_sociale, 'A causa del disturbo tende ad evitare situazioni o relazioni sociali') :- !.
spiega(disagio_sociale, 'Una interferenza importante dell''ansia con la vita sociale farebbe supporre la presenza di un disagio marcato e significativo nel paziente') :- !.

decodifica(disagio_comportamentale, 'Modifica le sue abitudini o il suo comportamento in modo da evitare che il disturbo si manifesti nuovamente') :- !.
spiega(disagio_comportamentale, 'Una interferenza importante dell''ansia con il funzionamento comportamentale farebbe supporre la presenza di un disagio marcato e significativo nel paziente') :- !.

decodifica(trauma, 'Ha vissuto, ha assistito o si e'' confrontato con un evento che ha comportato morte, lesioni gravi o altre minacce alla integrita'' fisica sua o di altri') :- !.
spiega(trauma, 'L''esposizione ad un evento traumatico consentirebbe di prendere in considerazione la presenza di un trauma psicologico, il quale rappresentrebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(comportamento_disorganizzato, 'Subito dopo l''evento traumatico ha avuto un comportamento disorganizzato') :- !.
spiega(comportamento_disorganizzato, 'Una risposta all''evento, espressa mediante un comportamento disorganizzato, permetterebbe la conferma del trauma psicologico, inteso come sintomo a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(agitazione, 'Subito dopo l''evento traumatico si e'' sentito continuamente agitato o turbato') :- !.
spiega(agitazione, 'Una risposta all''evento, espressa mediante una significativa agitazione, permetterebbe la conferma del trauma psicologico, inteso come sintomo a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(sentimento_orrore, 'Subito dopo l''evento traumatico ha provato una sensazione di intensa paura o di orrore') :- !.
spiega(sentimento_orrore, 'Una risposta all''evento, espressa mediante sintomi di paura o orrore, permetterebbe la conferma del trauma psicologico, inteso come sintomo a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(sentimento_impotenza, 'Subito dopo il trauma si e'' sentito impotente o impossibilitato ad agire autonomamente') :- !.
spiega(sentimento_impotenza, 'Una risposta all''evento, espressa mediante sentimenti di impotenza, permetterebbe la conferma del trauma psicologico, inteso come sintomo a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(manifestazione_ricordi_associati_trauma, 'Ricorda in continuazione momenti spiacevoli e intrusivi dell''evento') :- !.
spiega(manifestazione_ricordi_associati_trauma, 'La manifestazione di ricordi spiacevoli associati al trauma farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(manifestazione_giochi_associati_trauma, 'Manifesta ripetitivamente dei giochi in cui vengono espressi singoli aspetti riguardanti il trauma') :- !.
spiega(manifestazione_giochi_associati_trauma, 'La manifestazione di giochi ripetitivi in cui vengono espressi temi o aspetti riguardanti il trauma farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(manifestazione_sogni_associati_trauma, 'Fa dei sogni sgradevoli durante i quali viene ripetuto o rappresentato l''evento traumatico') :- !.
spiega(manifestazione_sogni_associati_trauma, 'La manifestazione di sogni spiacevoli associati al trauma farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(manifestazione_sogni_spaventosi, 'Fa dei sogni spaventosi o dal contenuto non riconoscibile') :- !.
spiega(manifestazione_sogni_spaventosi, 'La manifestazione di sogni spaventosi o dal contenuto non riconoscibile farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(ripresentazione_trauma, 'Presenta delle illusioni, allucinazioni o flashback inerenti l''evento traumatico') :- !.
spiega(ripresentazione_trauma, 'Il verificarsi di diverse sensazioni illusive o allusive o di epsiodi dissociativi di flashback farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(manifestazione_rappresentazioni_ripetitive, 'Vive continuamente delle rappresentazioni specifiche del trauma') :- !.
spiega(manifestazione_rappresentazioni_ripetitive, 'La manifestazione di rappresentazioni ripetitive specifiche associate al trauma farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(disagio_psicologico_fattori_caratterizzanti_trauma, 'Presenta un disagio psicologico intenso quando rivive situazioni associate all''evento traumatico') :- !.
spiega(disagio_psicologico_fattori_caratterizzanti_trauma, 'La presenza di un intenso disagio psicologico, all''esposizione a fattori scatenanti interni o esterni che sono associati all''evento traumatico, farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(reattivita_fisiologica, 'Presenta una marcata reattivita'' fisiologica dovuta all''esposizione a fattori che simbolizzano o assomigliano a qualche aspetto dell''evento traumatico') :- !.
spiega(reattivita_fisiologica, 'La presenza di reattivita'' fisiologica in seguito all''esposizione a fattori associati al trauma farebbe dedurre il rivivere l''evento traumatico, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(evitamento_pensieri_o_sensazioni_o_conversazioni_associati_trauma, 'Evita di focalizzare la mente su pensieri o sensazioni associati al trauma o di partecipare a conversazioni inerenti l''evento traumatico') :- !.
spiega(evitamento_pensieri_o_sensazioni_o_conversazioni_associati_trauma, 'Gli sforzi messi in atto per evitare pensieri, sensazioni o conversazioni riguardanti il trauma farebbero dedurre l''evitamento persistente degli stimoli associati con il trauma, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(evitamento_attivita_o_luoghi_o_persone_associate_trauma, 'Tende ad evitare attivita'', situazioni o persone che evocano il ricordo del trauma') :- !.
spiega(evitamento_attivita_o_luoghi_o_persone_associate_trauma, 'Gli sforzi messi in atto per evitare attivita'', luoghi o persone che evocano ricordi del trauma farebbero dedurre l''evitamento persistente degli stimoli associati con il trauma, il quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(riduzione_interesse_attivita, 'Presenta una marcata riduzione dell''interesse o della partecipazione ad attivita'' ritenute precedentemente piacevoli') :- !.
spiega(riduzione_interesse_attivita, 'La presenza di una marcata riduzione dell''interesse o della partecipazione ad attivita'' ritenute precedentemente piacevoli farebbe dedurre l''attenuazione della reattivita'' generale, la quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress') :- !.

decodifica(sentimento_estraneita, 'Tende ad essere distaccato o ad estraniarsi dagli altri') :- !.
spiega(sentimento_estraneita, 'La presenza di sentimenti di distacco o di estraneita'' farebbe dedurre l''attenuazione della reattivita'' generale, la quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress oppure potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(affettivita_ridotta, 'Avverte una riduzione della propria gamma emotiva o della propria sensibilita''') :- !.
spiega(affettivita_ridotta, 'La presenza di una affettivita'' ridotta farebbe dedurre l''attenuazione della reattivita'', la quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress oppure potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(diminuzione_prospettive_future, 'Si aspetta prospettive negative sul suo futuro o sui suoi desideri') :- !.
spiega(diminuzione_prospettive_future, 'La presenza di sentimenti di diminuzione delle prospettive future farebbe dedurre l''attenuazione della reattivita'' generale, la quale rappresenterebbe un indizio a favore del disturbo post-traumatico da stress') :- !.

decodifica(alterazione_sonno, 'Ha seria difficolta'' ad addormentarsi o a mantenere a lungo il sonno') :- !.
spiega(alterazione_sonno, 'L''alterazione del sonno potrebbe essere un sintomo tipico di aumentato arousal riscontrabile nel disturbo post-traumatico da stress o acuto da stress oppure potrebbe essere un indizio a favore del disturbo d''ansia generalizzato''') :- !.

decodifica(irritabilita, 'Si sente particolarmente irritabile o presenta spesso scoppi di collera') :- !.
spiega(irritabilita, 'L''irritabilita'' potrebbe essere un sintomo tipico di aumentato arousal riscontrabile nel disturbo post-traumatico da stress o acuto da stress oppure potrebbe essere un indizio a favore del disturbo d''ansia generalizzato') :- !.

decodifica(difficolta_concentrarsi, 'Incontra seri problemi nel concentrarsi o nell''eseguire banalissime attivita''') :- !.
spiega(difficolta_concentrarsi, 'La difficolta'' a concentrarsi potrebbe essere un sintomo tipico di aumentato arousal riscontrabile nel disturbo post-traumatico da stress o acuto da stress oppure potrebbe essere un indizio a favore del disturbo d''ansia generalizzato') :- !.

decodifica(ipervigilanza, 'E'' costantemente teso o propenso a controllare tutte le possibili fonti di pericolo derivanti dall''ambiente circostante') :- !.
spiega(ipervigilanza, 'L''ipervigilanza potrebbe essere un sintomo tipico di aumentato arousal riscontrabile nel disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(allarme_esagerato, 'Si allarma o si preoccupa, con facilita'', per situazioni non sospette') :- !.
spiega(allarme_esagerato, 'Le esagerate risposte di allarme potrebbero essere un sintomo tipico di aumentato arousal riscontrabile nel disturbo post-traumatico da stress o acuto da stress') :- !.

decodifica(riduzione_consapevolezza_ambientale, 'Avverte una sensazione di stordimento o una riduzione della consapevolezza dell''ambiente circostante') :- !.
spiega(riduzione_consapevolezza_ambientale, 'La riduzione della consapevolezza dell''ambiente circostante potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(amnesia_dissociativa, 'Tende a dimenticare aspetti importanti del trauma') :- !.
spiega(amnesia_dissociativa, 'L''amnesia dissociativa potrebbe essere un sintomo tipico della dissociazione riscontrabile nel disturbo acuto da stress') :- !.

decodifica(esordio_sintomi, 'I sintomi sono comparsi in seguito all''evento traumatico') :- !.
spiega(esordio_sintomi, 'Il tempo che intercorre tra l''evento traumatico e l''esordio dei sintomi potrebbe aiutare a distinguere tra un tipo di disturbo post-traumatico da stress ed il disturbo acuto da stress') :- !.
decodifica(meno_un_mese, 'Si, dopo < 1 mese') :- !.
decodifica(un_mese_meno_sei_mesi, 'Si, dopo >= 1 mese & < 6 mesi') :- !.
decodifica(sei_mesi_o_piu, 'Si, dopo >= 6 mesi') :- !.
decodifica(no_esordio, 'No') :- !.

decodifica(ansia_ossessiva, 'Si sente minacciato dal ricorrente presentarsi alla mente di pensieri, impulsi o immagini che vengono vissuti in maninera intrusiva ed inappropriata') :- !.
spiega(ansia_ossessiva, 'Mi serve per verificare la presenza di un disturbo ossessivo-compulsivo') :- !.

decodifica(ansia_compulsiva, 'Si sente continuamente obbligato a mettere in atto dei precisi comportamenti o dei rituali mentali al fine di prevenire alcuni eventi o situazioni temuti') :- !.
spiega(ansia_compulsiva, 'Mi serve per verificare la presenza di un disturbo ossessivo-compulsivo') :- !.

decodifica(preoccupazione_controllo_ossessioni_compulsioni, 'E'' costantemente in ansia per paura di non riuscire a tenere sotto controllo tali pensieri, immagini o impulsi') :- !.
spiega(preoccupazione_controllo_ossessioni_compulsioni, 'La presenza di preoccupazioni relative al controllo delle ossessioni-compulsioni fa propendere per il disturbo ossessivo-compulsivo') :- !.

decodifica(insight_eccesso_o_irragionevolezza_ossessioni_compulsioni, 'Riconosce che le ossessioni o le compulsioni di cui soffre sono eccessive o irragionevoli') :- !.
spiega(insight_eccesso_o_irragionevolezza_ossessioni_compulsioni, 'La variabilita'' di insight sull''eccesso o sulla irragionevolezza delle proprie ossessioni o compulsioni permette di distinguere il disturbo ossessivo-compulsivo dal disturbo ossessivo-compulsivo con scarso insight') :- !.
decodifica(insight_nullo, 'No') :- !.
decodifica(insight_alto, 'Si') :- !.
decodifica(insight_basso, 'Si, ma solo in circostanze di non pericolo o quando ne parla con il medico') :- !.

decodifica(spreco_tempo, 'Il ricorrere di questi fastidiosi pensieri o il mettere in atto comportamenti necessari a prevenire alcuni eventi comportano lo spreco di una quantita'' di tempo considerevole') :- !.
spiega(spreco_tempo, 'Il verificarsi di uno spreco di tempo interessante rappresenterebbe un indizio a favore del disturbo ossessivo-compulsivo') :- !.

decodifica(o_c_ferire_fisicamente_o_verbalmente, 'Ha timore di poter ferire fisicamente o verbalmente senza alcun motivo se stesso o altre persone in qualsiasi momento') :- !.
spiega(o_c_ferire_fisicamente_o_verbalmente, 'Avere l''ossessione-compulsione di ferire qualcuno farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto aggressivo') :- !.

decodifica(o_c_fare_cose_imbarazzanti, 'Ha timore di poter fare cose molto imbarazzanti in presenza di altre persone') :- !.
spiega(o_c_fare_cose_imbarazzanti, 'Avere l''ossessione-compulsione di fare cose molto imbarazzanti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto aggressivo') :- !.

decodifica(o_c_provocare_incidenti, 'Teme di poter provocare gravi incidenti stradali o domestici') :- !.
spiega(o_c_provocare_incidenti, 'Avere l''ossessione-compulsione di provocare gravi incidenti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto aggressivo') :- !.

decodifica(o_c_contaminazione_oggetti_o_animali_o_persone, 'Ha paura di toccare, avvicinarsi o entrare in contatto con alcune persone, animali o oggetti per timore di ammalarsi') :- !.
spiega(o_c_contaminazione_oggetti_o_animali_o_persone, 'Avere l''ossessione-compulsione di contaminarsi al contatto con oggetti, animali o persone farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo da contaminazione') :- !.

decodifica(o_c_contaminazione_germi_o_malattie_o_secrezioni_o_feci, 'Ha paura di contaminarsi a causa del contatto con germi, malattie, feci o secrezioni corporee') :- !.
spiega(o_c_contaminazione_germi_o_malattie_o_secrezioni_o_feci, 'Avere l''ossessione-compulsione di contaminarsi al contatto con germi, malattie, feci o secrezioni corporee farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo da contaminazione') :- !.

decodifica(o_c_contaminazione_posti_o_luoghi_contaminati, 'Evita di frequentare posti considerati contaminati come sale di attese, bagni pubblici, telefoni pubblici o luoghi considerati ad alto tasso di inquinamento') :- !.
spiega(o_c_contaminazione_posti_o_luoghi_contaminati, 'Avere l''ossessione-compulsione di contaminarsi, frequentando posti o luoghi ritenuti inquinanti, farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo da contaminazione') :- !.

decodifica(o_c_pulizia_ambiente, 'Sente la necessita'' di pulire continuamente la casa o gli oggetti di uso comune') :- !.
spiega(o_c_pulizia_ambiente, 'Avere l''ossessione-compulsione di pulire ambienti ed oggetti di uso comune farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo da contaminazione') :- !.

decodifica(o_c_pulizia_personale, 'Si sente obbligato ad indossare guanti ed indumenti particolari o a lavarsi continuamente al fine di evitare la contaminazione') :- !.
spiega(o_c_pulizia_personale, 'Avere l''ossessione-compulsione di pulire ambienti ed oggetti di uso comune farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo da contaminazione') :- !.

decodifica(o_c_atti_sessuali, 'E''angosciato da pensieri intrusivi di atti sessuali verso estranei, parenti, amici o bambini') :- !.
spiega(o_c_atti_sessuali, 'Avere l''ossessione-compulsione per gli atti sessuali farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto sessuale') :- !.

decodifica(o_c_immagini_pornografiche,'E'' angustiato dal ricorrente presentarsi alla mente di immagini pornografiche') :- !.
spiega(o_c_immagini_pornografiche, 'Avere l''ossessione-compulsione per le immagini pornografiche farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto sessuale') :- !.

decodifica(o_c_omosessualita, 'Ha timore di diventare omosessuale o evita di guardare o parlare con persone dello stesso sesso in modo da autorassicurarsi di non essere omosessuale') :- !.
spiega(o_c_omosessualita, 'Avere l''ossessione-compulsione per l''omossessualita farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto sessuale') :- !.

decodifica(o_c_collezionare_oggetti_inutili,'Ha difficolta'' nel buttar via degli oggetti anche se si ritengono inutili') :- !.
spiega(o_c_collezionare_oggetti_inutili, 'Avere l''ossessione-compulsione di collezionare oggetti inutili farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo accumulo') :- !.

decodifica(o_c_spazi_vuoti, 'Tende ad occupare ogni angolo o spazio vuoto fino a far diventare la casa o la stanza ingombra di collezioni') :- !.
spiega(o_c_spazi_vuoti, 'Avere l''ossessione-compulsione di riempire tutti gli spazi vuoti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo accumulo') :- !.

decodifica(o_c_controllare_rifiuti, 'Sente la necessita'' di ispezionare i rifiuti prima di gettarli') :- !.
spiega(o_c_controllare_rifiuti, 'Avere l''ossessione-compulsione di controllare i rifiuti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo accumulo') :- !.

decodifica(o_c_recuperare_oggetti_da_terra, 'Ha degli impulsi a recuperare qualsiasi oggetto da terra') :- !.
spiega(o_c_recuperare_oggetti_da_terra, 'Avere l''ossessione-compulsione di recuperare oggetti da terra farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo accumulo') :- !.

decodifica(o_c_bestemmie, 'Ha paura di pronunciare frasi blasfeme o teme di essere punito per averle pensate') :- !.
spiega(o_c_bestemmie, 'Avere l''ossessione-compulsione per le bestemmie farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto religioso') :- !.

decodifica(o_c_sacrilegio, 'Ha timore di aver involontariamente omaggiato figure diaboliche') :- !.
spiega(o_c_sacrilegio, 'Avere l''ossessione-compulsione per i sacrilegi farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto religioso') :- !.
 
decodifica(o_c_moralita, 'Si preoccupa in continuazione sulla propria moralita''') :- !.
spiega(o_c_moralita, 'Avere l''ossessione-compulsione per la moralita'' farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto religioso') :- !.

decodifica(o_c_credo_religioso, 'Teme di fallire o eseguire in maniera errata i rituali previsti dal proprio credo religioso') :- !.
spiega(o_c_credo_religioso, 'Avere l''ossessione-compulsione per i credi religiosi farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto religioso') :- !.

decodifica(o_c_preghiere, 'Sente l''eccessiva necessita'' di pregare o trovare rassicurazioni in figure religiose') :- !.
spiega(o_c_preghiere, 'Avere l''ossessione-compulsione per le preghiere farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo a contenuto religioso') :- !.

decodifica(o_c_disagio_disordine,'Si sente a disagio quando gli oggetti vengono riarrangiati o messi fuori posto da altri') :- !.
spiega(o_c_disagio_disordine, 'Avere l''ossessione-compulsione per il disordine farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo ordine e simmetria') :- !.

decodifica(o_c_ordine_oggetti, 'Si sofferma continuamente a controllare che tutti gli oggetti siano in ordine o a risistemare gli oggetti fuori posto per diverso tempo') :- !.
spiega(o_c_ordine_oggetti, 'Avere l''ossessione-compulsione di ordinare o controllare continuamente gli oggetti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo ordine e simmetria') :- !.

decodifica(o_c_simmetria, 'Sente la necessita'' di disporre taluni oggetti in un dato ordine o in maniera simmetrica') :- !.
spiega(o_c_simmetria, 'Avere l''ossessione-compulsione di disporre simmetricamente gli oggetti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo ordine e simmetria') :- !.

decodifica(o_c_controllo_forme_corporee, 'Controlla costantemente le proprie forme corporee') :- !.
spiega(o_c_controllo_forme_corporee, 'Avere l''ossessione-compulsione per le forme corporee farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo somatico') :- !.

decodifica(o_c_giudizio_altrui_aspetto_fisico, 'Teme eccessivamente le reazioni degli altri sul proprio aspetto fisico') :- !.
spiega(o_c_giudizio_altrui_aspetto_fisico, 'Avere l''ossessione-compulsione per il giudizio che altre persone possono avere sul proprio aspetto fisico farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo somatico') :- !.

decodifica(o_c_parole_superstiziose, 'Ha paura di dire o pensare certe parole per le conseguenze negative che possono derivare dal farlo') :- !.
spiega(o_c_parole_superstiziose, 'Avere l''ossessione-compulsione per le parole superstiziose farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo superstizioso') :- !.

decodifica(o_c_colori_simboli_o_numeri_superstiziosi, 'Fa costantemente attenzione all''uso di alcuni colori, numeri o simboli per paura che portino sfortuna') :- !.
spiega(o_c_colori_simboli_o_numeri_superstiziosi, 'Avere l''ossessione-compulsione relativa all''uso di colori, simboli o numeri superstiziosi farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo superstizioso') :- !.

decodifica(o_c_credenze_superstiziose, 'Mette in atto comportamenti sulla base di credenze supertiziose') :- !.
spiega(o_c_credenze_superstiziose, 'Avere l''ossessione-compulsione relativa alle credenze superstiziose farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo superstizioso') :- !.

decodifica(o_c_rifare_cose, 'Capita di dover rifare alcune cose piu'' di una volta fino a quando crede di averle fatte perfettamente') :- !.
spiega(o_c_rifare_cose, 'Avere l''ossessione-compulsione di rifare delle cose piu'' volte farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo perfezione e responsabilita''') :- !.

decodifica(o_c_controllo_errori, 'Si ritrova spesso a controllare di non aver commesso disattenzioni per paura che possa accadere qualcosa di brutto') :- !.
spiega(o_c_controllo_errori, 'Avere l''ossessione-compulsione per il controllo degli errori o delle disattenzioni farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo perfezione e responsabilita''') :- !.

decodifica(o_c_dire_cose_insensate, 'Ha costantemente paura di dire qualcosa di sbagliato o di insensato') :- !.
spiega(o_c_dire_cose_insensate, 'Avere l''ossessione-compulsione di dire cose sbagliate o insensate farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo perfezione e responsabilita''') :- !.

decodifica(o_c_scadenze, 'Teme in modo sproporzionato di non riuscire a completare un compito o di non rispettare alcune scadenze') :- !.
spiega(o_c_scadenze, 'Avere l''ossessione-compulsione per le scadenze farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo perfezione e responsabilita''') :- !.

decodifica(o_c_numero_morsi, 'Sente la necessita'' di mangiar sempre una stessa quantita'' di bocconi indipendentemente dal tipo di cibo') :- !.
spiega(o_c_numero_morsi, 'Avere l''ossessione-compulsione per il cibo farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo vario') :- !.

decodifica(o_c_rumori, 'Si sente facilmente infastidito da certi suoni e rumori come ticchettii, ronzii o boati') :- !.
spiega(o_c_rumori, 'Avere l''ossessione-compulsione per alcuni suoni o rumori farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo vario') :- !.

decodifica(o_c_toccare, 'Sente l''impellente bisogno di toccare o strofinare ripetutamente determinati oggetti') :- !.
spiega(o_c_toccare, 'Avere l''ossessione-compulsione di toccare o strofinare oggetti farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo vario') :- !.

decodifica(o_c_conteggi, 'Tende a contate determinati oggetti come gradini, piani di appartamenti, auto in file o altro') :- !.
spiega(o_c_conteggi, 'Avere l''ossessione-compulsione di contare in determinate circostanze farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo vario') :- !.

decodifica(o_c_ricordi, 'Sente il desiderio di ricordare o memorizzare slogan, targhe, nomi, parole o avvenimenti') :- !.
spiega(o_c_ricordi, 'Avere l''ossessione-compulsione di ricordare o memorizzare alcune cose farebbe propendere per una diagnosi di disturbo ossessivo-compulsivo di tipo vario') :- !.

decodifica(preoccupazione_circostanze_abitudinarie_o_piccoli_imprevisti, 'Negli ultimi mesi ha raggiunto livelli eccessivi di preoccupazione relativamente a circostanze quotidiane, abitudinarie o a piccoli imprevisti di minima entita''') :- !.
spiega(preoccupazione_circostanze_abitudinarie_o_piccoli_imprevisti, 'Mi serve per verificare la presenza di ansia generalizzata') :- !.

decodifica(difficolta_controllo_preoccupazione, 'Ha seria difficolta'' nel controllare la preoccupazione o nell''impedire che i pensieri preoccupanti interferiscano con l''attenzione necessaria ai compiti da svolgere nella giornata') :- !.
spiega(difficolta_controllo_preoccupazione, 'La presenza di una significativa difficolta'' nel controllo della preoccupazione consentirebbe di indirizzare la diagnosi verso il disturbo d''ansia generalizzato') :- !.

decodifica(irrequietezza, 'Si sente spesso irrequieto, teso o con i nervi a fior di pelle') :- !.
spiega(irrequietezza, 'L''irrequietezza sarebbe un indizio a favore del disturbo d''ansia generalizzato') :- !.

decodifica(facile_affaticabilita, 'Si stanca facilmente anche dopo attivita'' che richiedono uno sforzo non particolarmente rilevante') :- !.
spiega(facile_affaticabilita, 'La facile affaticabilita'' sarebbe un indizio a favore del disturbo d''ansia generalizzato') :- !.

decodifica(tensione_muscolare, 'Ha sperimentato di recente sintomi tipici di tensione muscolare come disturbi di stomaco, agitazione, o incapacita'' a stare fermo') :- !.
spiega(tensione_muscolare, 'La tensione muscolare sarebbe un indizio a favore del disturbo d''ansia generalizzato') :- !.

decodifica(condizione_medica, 'E'' affetto da una condizione medica debilitante') :- !.
spiega(condizione_medica, 'La presenza di una malattia debilitante consentirebbe di prendere in esame il disturbo d''ansia dovuto ad una condizione medica generale piuttosto che altri disturbi d''ansia primari') :- !.

decodifica(esordio_sintomi_successivo_esordio_malattia, 'I sintomi sono comparsi dopo l''esordio della condizione medica') :- !.
spiega(esordio_sintomi_successivo_esordio_malattia, 'Un esordio dei sintomi successivo all''esordio della malattia darebbe prova di una correlazione eziologica tra la condizione medica ed il disturbo d''ansia') :- !.

decodifica(rafforzamento_sintomi_in_seguito_esacerbazione_malattia, 'Ha riscontrato un rafforzamento dei sintomi in seguito all''aggravarsi della condizione medica') :- !.
spiega(rafforzamento_sintomi_in_seguito_esacerbazione_malattia, 'Un rafforzamento dei sintomi in seguito all''esacerbazione della malattia darebbe prova di una correlazione eziologica tra la condizione medica ed il disturbo d''ansia') :- !.

decodifica(indebolimento_sintomi_in_seguito_remissione_malattia, 'Ha riscontrato un indebolimento dei sintomi in seguito alla remissione della condizione medica') :- !.
spiega(indebolimento_sintomi_in_seguito_remissione_malattia, 'Un indebolimento dei sintomi in seguito alla remissione della malattia darebbe prova di una correlazione eziologica tra la condizione medica ed il disturbo d''ansia') :- !.

decodifica(intossicazione_o_astinenza_sostanza, 'Di recente, e'' stato interessato da una forma di intossicazione o astinenza da sostanze') :- !.
spiega(intossicazione_o_astinenza_sostanza, 'Il verificarsi di una forma di intossicazione o astinenza da sostanze consentirebbe di prendere in esame il disturbo d''ansia indotto da sostanze piuttosto che altri disturbi d''ansia primari') :- !.

decodifica(assunzione_farmaco_o_esposizione_tossina, 'Di recente, ha assunto dei farmaci diversi dai soliti o e'' stato esposto a tossine pericolose') :- !.
spiega(assunzione_farmaco_o_esposizione_tossina, 'L''aver assunto un farmaco o l''essersi esposti a delle tossine consentirebbe di prendere in esame il disturbo d''ansia indotto da sostanze piuttosto che altri disturbi d''ansia primari') :- !.

decodifica(esordio_sintomi_successivo_esordio_uso_sostanze_o_farmaci, 'I sintomi sono comparsi dopo aver fatto uso della sostanza o del farmaco') :- !.
spiega(esordio_sintomi_successivo_esordio_uso_sostanze_o_farmaci, 'Un esordio dei sintomi successivo all''uso della sostanza o del farmaco darebbe prova di una correlazione eziologica tra la sostanza o il farmaco ed il disturbo d''ansia') :- !.

decodifica(correlazione_sintomi_sostanze_o_farmaci, 'I sintomi sono strettamente correlati al tipo o alla quantita'' della sostanza usata o alla durata dell''uso del farmaco') :- !.
spiega(correlazione_sintomi_sostanze_o_farmaci, 'La presenza di sintomi sostanzialmente proporzionati, rispetto a quanto ci si attenderebbe dato il tipo o la quantita'' di sostanza usata o la durata dell''uso stesso, darebbe prova di una correlazione eziologica tra la sostanza o il farmaco ed il disturbo d''ansia') :- !.

decodifica(agorafobia_senza_anamnesi_di_disturbo_di_panico, 'Agorafobia Senza Anamnesi di Disturbo di Panico') :- !.

decodifica(fobia_specifica_tipo_animali, 'Fobia Specifica di Tipo "Animali"') :- !.

decodifica(fobia_specifica_tipo_ambiente_naturale, 'Fobia Specifica di Tipo "Ambiente Naturale"') :- !.

decodifica(fobia_specifica_tipo_sangue_iniezioni_ferite, 'Fobia Specifica di Tipo "Sangue-Iniezioni-Ferite"') :- !.

decodifica(fobia_specifica_tipo_situazionale, 'Fobia Specifica di Tipo "Situazionale"') :- !.

decodifica(fobia_specifica_tipo_altro, 'Fobia Specifica di Tipo "Altro"') :- !.

decodifica(fobia_sociale_generalizzata, 'Fobia Sociale Generalizzata') :- !.

decodifica(fobia_sociale_circoscritta, 'Fobia Sociale Circoscritta') :- !.

decodifica(disturbo_di_panico_senza_agorafobia, 'Disturbo di Panico senza Agorafobia') :- !.

decodifica(disturbo_di_panico_con_agorafobia, 'Disturbo di Panico con Agorafobia') :- !.

decodifica(disturbo_ossessivo_compulsivo_aggressioni, 'Disturbo Ossessivo-Compulsivo a Contenuto Aggressivo') :- !.

decodifica(disturbo_ossessivo_compulsivo_aggressioni_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo a Contenuto Aggressivo con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_contaminazioni, 'Disturbo Ossessivo-Compulsivo da Contaminazione') :- !.

decodifica(disturbo_ossessivo_compulsivo_contaminazioni_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo da Contaminazione con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_sesso, 'Disturbo Ossessivo-Compulsivo a Contenuto Sessuale') :- !.

decodifica(disturbo_ossessivo_compulsivo_sesso_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo a Contenuto Sessuale con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_accumulo, 'Disturbo Ossessivo-Compulsivo di Tipo Accumulo') :- !.

decodifica(disturbo_ossessivo_compulsivo_accumulo_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo di Tipo Accumulo con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_religione, 'Disturbo Ossessivo-Compulsivo a Contenuto Religioso') :- !.

decodifica(disturbo_ossessivo_compulsivo_religione_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo a Contenuto Religioso con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_ordine_e_simmetria, 'Disturbo Ossessivo-Compulsivo di Tipo Ordine e Simmetria') :- !.

decodifica(disturbo_ossessivo_compulsivo_ordine_e_simmetria_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo di Tipo Ordine e Simmetria con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_somatico, 'Disturbo Ossessivo-Compulsivo di Tipo Somatico') :- !.

decodifica(disturbo_ossessivo_compulsivo_somatico_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo di Tipo Somatico con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_superstizione, 'Disturbo Ossessivo-Compulsivo di Tipo Superstizioso') :- !.

decodifica(disturbo_ossessivo_compulsivo_superstizione_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo di Tipo Superstizioso con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita, 'Disturbo Ossessivo-Compulsivo di Tipo Perfezione e Responsabilita''') :- !.

decodifica(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo di Tipo Perfezione e Responsabilita'' con Scarso Insight') :- !.

decodifica(disturbo_ossessivo_compulsivo_vario, 'Disturbo Ossessivo-Compulsivo con Contenuto Vario') :- !.

decodifica(disturbo_ossessivo_compulsivo_vario_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo con Contenuto Vario con Scarso Insight') :- !.

decodifica(disturbo_post_traumatico_da_stress_acuto_ad_esordio_ritardato, 'Disturbo Post-Traumatico da Stress Acuto ad Esordio Ritardato') :- !.

decodifica(disturbo_post_traumatico_da_stress_cronico_ad_esordio_ritardato, 'Disturbo Post-Traumatico da Stress Cronico ad Esordio Ritardato') :- !.

decodifica(disturbo_post_traumatico_da_stress_acuto, 'Disturbo Post-Traumatico da Stress Acuto') :- !.

decodifica(disturbo_post_traumatico_da_stress_cronico, 'Disturbo Post-Traumatico da Stress Cronico') :- !.

decodifica(disturbo_acuto_da_stress, 'Disturbo Acuto da Stress') :- !.

decodifica(disturbo_ansia_generalizzato, 'Disturbo d''Ansia Generalizzato') :- !.

decodifica(disturbo_ansia_dovuto_a_condizione_medica_generale_con_ansia_generalizzata, 'Disturbo d''Ansia Dovuto ad una Condizione Medica Generale con Ansia Generalizzata') :- !.

decodifica(disturbo_ansia_dovuto_a_condizione_medica_generale_con_attacchi_di_panico, 'Disturbo d''Ansia Dovuto ad una Condizione Medica Generale con Attacchi di Panico') :- !.

decodifica(disturbo_ansia_dovuto_a_condizione_medica_generale_con_sintomi_ossessivo_compulsivi, 'Disturbo d''Ansia Dovuto ad una Condizione Medica Generale con Sintomi Ossessivo-Compulsivi') :- !.

decodifica(disturbo_ansia_indotto_da_sostanze_con_ansia_generalizzata, 'Disturbo d''Ansia Indotto da Sostanze con Ansia Generalizzata') :- !.

decodifica(disturbo_ansia_indotto_da_sostanze_con_attacchi_di_panico, 'Disturbo d''Ansia Indotto da Sostanze con Attacchi di Panico') :- !.
 
decodifica(disturbo_ansia_indotto_da_sostanze_con_sintomi_ossessivo_compulsivi, 'Disturbo d''Ansia Indotto da Sostanze con Sintomi Ossessivo-Compulsivi') :- !.

decodifica(disturbo_ansia_indotto_da_sostanze_con_sintomi_fobici, 'Disturbo d''Ansia Indotto da Sostanze con Sintomi Fobici') :- !.

decodifica(disturbo_di_panico, 'Disturbo di Panico') :- !.

decodifica(agorafobia, 'Agorafobia' ) :- !.

decodifica(fobia_specifica, 'Fobia Specifica') :- !.

decodifica(fobia_sociale, 'Fobia Sociale') :- !.

decodifica(disturbo_acuto_da_stress, 'Disturbo Acuto da Stress') :- !.

decodifica(disturbo_post_traumatico_da_stress, 'Disturbo Post Traumatico da Stress') :- !.

decodifica(disturbo_ossessivo_compulsivo, 'Disturbo Ossessivo-Compulsivo') :- !.

decodifica(disturbo_ossessivo_compulsivo_con_scarso_insight, 'Disturbo Ossessivo-Compulsivo con Scarso Insight') :- !.

decodifica(disturbo_ansia_generalizzato, 'Disturbo d''Ansia Generalizzato') :- !.

decodifica(alterazione_indotta_da_sostanza_associata, 'Alterazione Indotta da Sostanza Associata') :- !.

decodifica(condizione_medica_generale_associata, 'Condizione Medica Generale Associata') :- !.

decodifica(tipo_animali, 'Tipo Animali') :- !.

decodifica(tipo_ambiente_naturale, 'Tipo Ambiente Naturale') :- !.

decodifica(tipo_sangue_iniezioni_ferite, 'Tipo Sangue-Iniezioni-Ferite') :- !.

decodifica(tipo_situazionale, 'Tipo Situazionale') :- !.

decodifica(tipo_altro, 'Tipo Altro') :- !.

decodifica(tipo_generalizzata, 'Tipo Generalizzata') :- !.

decodifica(tipo_circoscritta, 'Tipo Circoscritta') :- !.

decodifica(tipo_aggressivo, 'Tipo Aggressivo') :- !.

decodifica(tipo_contaminativo, 'Tipo Contaminativo') :- !.

decodifica(tipo_sessuale, 'Tipo Sessuale') :- !.

decodifica(tipo_accumulativo, 'Tipo Accumulativo') :- !.

decodifica(tipo_religioso, 'Tipo Religioso') :- !.

decodifica(tipo_ordine_e_simmetria, 'Tipo Ordine e Simmetria') :- !.

decodifica(tipo_somatico, 'Tipo Somatico') :- !.

decodifica(tipo_superstizioso, 'Tipo Superstizioso') :- !.

decodifica(tipo_perfezione_e_responsabilita, 'Tipo Perfezione e Responsabilita''') :- !.

decodifica(tipo_vario, 'Tipo Vario') :- !.

decodifica(tipo_acuto, 'Tipo Acuto') :- !.

decodifica(tipo_acuto_ad_esordio_ritardato, 'Tipo Acuto ad Esordio Ritardato') :- !.

decodifica(tipo_cronico, 'Tipo Cronico') :- !.

decodifica(tipo_cronico_ad_esordio_ritardato, 'Tipo Cronico ad Esordio Ritardato') :- !.

decodifica(attacco_di_panico_inaspettato, 'Attacco di Panico Inaspettato') :- !.

decodifica(attacco_di_panico_causato_dalla_situazione, 'Attacco di Panico Causato dalla Situazione') :- !.

decodifica(trauma_psicologico, 'Trauma Psicologico') :- !.

decodifica(condizione_medica_generale, 'Condizione Medica Generale') :- !.

decodifica(evidenza_eziologica_condizione_medica_e_ansia, 'Evidenza Eziologica tra Condizione Medica e Disturbo d''Ansia') :- !.

decodifica(evidenza_eziologica_sostanza_o_farmaco_e_ansia, 'Evidenza Eziologica tra Sostanza o Farmaco e Disturbo d''Ansia') :- !.

decodifica(intossicazione_astinenza_sostanza_o_assunzione_farmaco, 'Intossicazione/Astinenza da Sostanza o Assunzione di Farmaco') :- !.

decodifica(riconoscimento_eccesso_o_irragionevolezza_fobia, 'Riconoscimento Eccesso o Irragionevolezza della Fobia') :- !.

decodifica(alto_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni, 'Alto Riconoscimento Eccesso o Irragionevolezza delle Ossessioni-Compulsioni') :- !.

decodifica(basso_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni, 'Basso Riconoscimento Eccesso o Irragionevolezza delle Ossessioni-Compulsioni') :- !.

decodifica(ansia_anticipatoria_situazioni_panico, 'Ansia Anticipatoria per le Situazioni di Panico') :- !.

decodifica(evitamento_stimoli_associati_trauma, 'Evitamento degli Stimoli Associati al Trauma') :- !.

decodifica(disagio_significativo, 'Disagio Significativo') :- !.

decodifica(attenuazione_reattivita_generale, 'Attenuazione della Reattivita'' Generale') :- !.

decodifica(ansia_ossessiva_compulsiva, 'Ansia Ossessiva-Compulsiva') :- !.

decodifica(dissociazione, 'Dissociazione') :- !.

decodifica(evento_traumatico_rivissuto, 'Evento Traumatico Rivissuto') :- !.

decodifica(arousal_aumentato, 'Arousal Aumentato') :- !.

decodifica(ansia_generalizzata, 'Ansia Generalizzata') :- !.

decodifica(ansia_agorafobica, 'Ansia Agorafobica') :- !.

decodifica(ansia_fobica_specifica, 'Ansia Fobica Specifica') :- !.

decodifica(ansia_fobica_sociale, 'Ansia Fobica Sociale') :- !.

decodifica(evitamento_o_sopportazione_con_disagio, 'Evitamento o Sopportazione con Disagio delle Situazioni Temute') :- !.

decodifica(fobia_animali, 'Fobia degli Animali') :- !.

decodifica(fobia_ambiente_naturale, 'Fobia dell''Ambiente Naturale') :- !.

decodifica(fobia_sangue_iniezioni_ferite, 'Fobia del Sangue, delle Iniezioni o delle Ferite') :- !.

decodifica(fobia_situazioni, 'Fobia delle Situazioni Particolari') :- !.

decodifica(fobia_altro, 'Fobia di Altro') :- !.

decodifica(fobia_generalizzata, 'Fobia Generalizzata') :- !.

decodifica(fobia_circoscritta, 'Fobia Circoscritta') :- !.

decodifica(ossessioni_compulsioni_aggressioni, 'Ossessioni-Compulsioni per le Aggressioni') :- !.

decodifica(ossessioni_compulsioni_contaminazione, 'Ossessioni-Compulsioni per la Contaminazione') :- !.

decodifica(ossessioni_compulsioni_sesso, 'Ossessioni-Compulsioni per il Sesso') :- !.

decodifica(ossessioni_compulsioni_accumulo, 'Ossessioni-Compulsioni per l''Accumulo') :- !.

decodifica(ossessioni_compulsioni_religione, 'Ossessioni-Compulsioni per la Religione') :- !.

decodifica(ossessioni_compulsioni_ordine_e_simmetria, 'Ossessioni-Compulsioni per l''Ordine e la Simmetria') :- !.

decodifica(ossessioni_compulsioni_corpo, 'Ossessioni-Compulsioni per il Corpo') :- !.

decodifica(ossessioni_compulsioni_superstizione, 'Ossessioni-Compulsioni per la Superstizione') :- !.

decodifica(ossessioni_compulsioni_perfezione_e_responsabilita, 'Ossessioni-Compulsioni per la Perfezione e la Responsabilita''') :- !.

decodifica(ossessioni_compulsioni_vario, 'Ossessioni-Compulsioni Varie') :- !.

decodifica(frequenti_attacchi_di_panico, 'Frequenti Attacchi di Panico') :- !.

decodifica(durata_due_giorni_meno_un_mese, 'Durata da almeno 2 giorni a meno di 1 mese') :- !.

decodifica(durata_almeno_un_mese, 'Durata di almeno di 1 mese') :- !.

decodifica(durata_un_mese_meno_tre_mesi, 'Durata da almeno 1 mese a meno di 3 mesi') :- !.

decodifica(durata_almeno_tre_mesi, 'Durata di almeno 3 mesi') :- !.

decodifica(durata_almeno_sei_mesi, 'Durata di almeno 6 mesi') :- !.

decodifica(esordio_entro_un_mese, 'Esordio entro 1 mese dal Trauma') :- !.

decodifica(esordio_entro_sei_mesi, 'Esordio entro 5 mesi dal Trauma') :- !.

decodifica(esordio_almeno_sei_mesi_dopo, 'Esordio almeno 6 mesi dopo il Trauma') :- !.


decodifica(presentazione_sistema, '---------------------------------------------------------\n-- Prolog Expert System on Anxiety Disorders (PESAD)\n\n--	autore Donato Meoli\n--	versione Agosto 2019\n---------------------------------------------------------\n') :- !.

decodifica(errore_risposta, 'Risposta errata, rispondere nuovamente') :- !.

decodifica(errore_comando, 'Comando digitato errato, riprovare nuovamente ') :- !.

decodifica(errore_certezza, 'Valore di certezza errato, inserire un valore ') :- !.

decodifica(diagnosi, '***************************************************DIAGNOSI***************************************************') :- !.

decodifica(certezza, ' con grado di certezza ') :- !.

decodifica(fatti, '***************************************************FATTI***************************************************') :- !.

decodifica(comandi_disponibili, 'Comandi disponibili:') :- !.

decodifica(comando_investigazione, '	investigazione.	- Avvia l''investigazione completa dei disturbi;') :- !.

decodifica(comando_controllo, '	controllo.	- Avvia il controllo di un singolo disturbo;') :- !.

decodifica(comando_fatti, '	fatti.		- Visualizza i fatti asseriti;') :- !.
	
decodifica(comando_aiuto, '	aiuto.		- Visualizza l''elenco dei comandi disponibili;') :- !.

decodifica(comando_pulisci, '	pulisci.	- Pulisce la memoria;') :- !.

decodifica(comando_chiudi, '	chiudi.		- Chiude l''interfaccia grafica.') :- !.

decodifica(richiesta_certezza, 'Indicare il grado di certezza ') :- !.

decodifica(indicazione_certezza, '(da 0.0 a 1.0)') :- !.

decodifica(indicazione_risposta_si_no, '(si, no)') :- !.

decodifica(richiesta_opzione, 'Digitare il codice corrispondente all''opzione scelta') :- !.

decodifica(richiesta_goal, 'Quale dei seguenti disturbi si vuole controllare') :- !.

decodifica(risultato_diagnosi, 'Il paziente soffre di ') :- !.

decodifica(richiesta_come_controllo, 'Vuoi sapere come e'' stato dedotto') :- !.

decodifica(richiesta_come_investigazione, 'Vuoi sapere come sono stati dedotti') :- !.

decodifica(vero, ' e'' vero con CF ') :- !.

decodifica(falso, ' e'' falso con CF ') :- !.

decodifica(dedotto, ' e'' stato dedotto da') :- !.

decodifica(detto, ' e'' stato detto') :- !.

decodifica(codice, ' Codice: ') :- !.

decodifica(sintomo, 'Sintomo') :- !.

decodifica(X,Y) :- X = Y.

spiega(X,Y) :- X = Y.


