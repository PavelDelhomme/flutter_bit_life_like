// PLUGIN - Politique & Gouvernance
// Catégorie : Politique / Société / Géopolitique

// Résumé global :
// Simule l’ensemble des mécanismes politiques : élections, gouvernance, lois, institutions, partis, diplomatie, coups d'État.
// Le joueur peut devenir maire, président, dictateur ou militant, et influencer la société à travers des lois, budgets, réformes.


// -------------------------------
// TODO Politique & élections
// - Créer ou rejoindre un parti politique
// - Se présenter à des élections (locale, nationale)
// - Faire campagne, participer à des débats
// - Gérer un programme politique (idéologie, lois clés)
// - Proposer, voter et modifier des lois
// - Affecter le budget de l’État par ministère
// - Statistiques : popularité, influence, finances, fatigue
// - Conditions : réputation, éducation, citoyenneté, appuis
// - Interface de campagne, courbes de sondage, districts électoraux
// - Réformes du système électoral (mode de scrutin, seuils, durée des mandats)
// - Possibilité d’élections anticipées, vote obligatoire ou électronique
// - Scandales électoraux, manipulation, fraudes, annulation d’élection

// -------------------------------
// TODO Système législatif
// - Déposer des projets de loi
// - Commissions parlementaires et amendements
// - Débats interactifs / narratifs
// - Votation à l’assemblée ou par décret
// - Blocages politiques, motions de censure
// - Historique des lois et impact social
// - Constitution de départ selon régime
// - Cour constitutionnelle, veto présidentiel
// - Type de lois : ordinaire, organique, référendaire
// - Droit d’initiative populaire (référendum citoyen)
// - Interface de dépôt/amendement/abrogation des lois

// -------------------------------
// TODO Institutions & régimes
// - Simuler plusieurs types de régimes (république, monarchie, dictature)
// - Gérer les institutions (présidence, ministères, parlement…)
// - Créer ou réformer une constitution
// - Carte des libertés publiques (expression, presse, syndicat…)
// - Curseur d’autoritarisme / démocratie
// - Équilibre des pouvoirs (exécutif, législatif, judiciaire, militaire)
// - Structure territoriale : État unitaire, fédéral, régions autonomes
// - Suppression ou renforcement des contre-pouvoirs
// - Instaurer l’état d’urgence ou suspendre les institutions

// -------------------------------
// TODO Ministères & politiques publiques
// - Nommer ministres (joueur ou PNJ)
// – Allouer le budget, fixer les objectifs par secteur
// - Gérer crises : pandémie, cyberattaque, émeutes…
// – Mesures spécifiques : école obligatoire, remboursement santé, etc.
// - Statistiques par domaine (santé, éducation, armée…)
// - Incidents à traiter ou prévenir par ministère
// - Interface de tableau ministériel et alertes sectorielles
// - Gestion sectorielle : culture, énergie, logement, écologie, recherche
// - Évolution des indicateurs par ministère (alphabétisation, CO2, criminalité…)

// -------------------------------
// TODO Opposition & mouvements sociaux
// - Partis d’opposition (créés par PNJ)
// - Manifestations, grèves, campagnes de contestation
// - Négociations, blocages, coalitions
// - Influence de lobbies, religions, groupes extrêmes
// - Simulation du rapport de forces à l’assemblée
// - Organisation ou répression de manifestations
// - Timeline de mobilisation sociale
// - Usage des forces de l’ordre : CRS, armée, police politique
// - Gestion du soutien populaire / réaction internationale

// -------------------------------
// TODO Diplomatie & relations internationales
// - Envoyer ambassadeurs, diplomates
// - Signer traités, accords commerciaux ou militaires
// - Gérer crises diplomatiques, guerres, espionnage
// - Influence du droit international sur les lois locales
// - Carte diplomatique interactive
// - Réputation internationale, soutien ou isolement
// - Impact des lois internes sur les relations extérieures
// - Accords climatiques, droits humains, ONG internationales
// - Sommet diplomatique, sanctions, ruptures, OTAN/ONU-like

// -------------------------------
// TODO Coup d’État & instabilité politique
// - Simulation d’un coup d’État (tentative, réussite, échec)
// - Répression, exil, exécution des opposants
// - Création d’une milice privée
// - Transition vers un régime militaire ou retour à la démocratie
// - Indicateur de stabilité politique
// - Phases : alerte, tentative, résolution
// - Gestion des groupes paramilitaires, loi martiale
// - Déploiement de troupes, loyauté de l’armée
// - Réactions internationales, sanctions, reconnaissance ou non du nouveau régime

// -------------------------------
// TODO Corruption & lobbying
// - Corrompre ou être corrompu : pots-de-vin, faveurs, influence
// - Lien avec entreprises, mafias, groupes d’intérêt
// - Réputation publique VS réputation occulte
// - Mini-jeu de gestion de crise médiatique
// - Carte des réseaux d’influence
// - Acceptation ou refus de pots-de-vin, chantage, scandales
// - Contrats publics, financement de campagne illégal, promesses contre services
// - ONG anticorruption, agences de transparence, enquête journalistique

// -------------------------------
// TODO Post-guerre & justice internationale
// - Reconstruction post-conflit : infrastructures, réfugiés, économie
// - Procès pour crimes de guerre (PNJ ou joueur)
// – Tribunal international / local
// - Démobilisation ou maintien de l’armée / milices
// - Baromètre de réconciliation nationale
// - Réintégration des miliciens ou maintien des milices
// - Carte des zones à reconstruire, priorisation
// - Accord de paix, réparations, tribunal, sanctions
// - Campagne de reconstruction, diplomatie post-conflit
// - Mémoriaux, processus de vérité et réconciliation

// -------------------------------
// TODO UI / Données
// - Panneau de gouvernance (budget, satisfaction, diplomatie)
// - Interface de création / modification des lois
// - Carte des relations internationales
// - Timeline politique et historique des mandats
// - Sondages, opinion publique, segments par classe/groupe
// - Réseau PNJ politiques et influence
// - Carte stratégique, panel de commandement, suivi d’instabilité
// - Interface budgétaire glisser-déposer
// - Table diplomatique avec options d’alliance, guerre, traité
// - Journal officiel, graphiques d’opinion, baromètre de stabilité
// - Indicateurs clés : taux d’approbation, tensions, réputation, libertés publiques

// -------------------------------
// TODO Compatibilités plugins
// - Criminalité : poursuites contre dirigeants, lois répressives
// - Justice : système constitutionnel, procès politiques
// - Santé : gestion du ministère de la santé, pandémie
// - Économie : lois fiscales, budget public, nationalisations
// - Médias : contrôle de l'information, propagande
// - Intelligence artificielle : gouvernance automatisée
// - Réseaux sociaux : mobilisation citoyenne, fake news
// - Entreprises : influence via lobbying ou contrats publics
// - Fiscalité : lois votées, taux d’impôts, niches et réforme fiscale
// - Guerre : alignement politique, causes de conflits, sanctions
