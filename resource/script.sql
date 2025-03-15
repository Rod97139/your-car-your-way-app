CREATE DATABASE IF NOT EXISTS yourcaryourway;

-- Utilisation de la base de données
USE yourcaryourway;

-- Table des catégories de véhicules (norme ACRISS)
CREATE TABLE CATEGORIE (
                         categorie_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         code_acriss VARCHAR(4) NOT NULL UNIQUE,
                         description VARCHAR(255) NOT NULL,
                         capacite INTEGER NOT NULL,
                         type_carburant VARCHAR(50) NOT NULL,
                         climatisation BOOLEAN NOT NULL DEFAULT FALSE,
                         transmission VARCHAR(50) NOT NULL,
                         created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des agences
CREATE TABLE AGENCE (
                      agence_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                      nom VARCHAR(100) NOT NULL,
                      adresse VARCHAR(255) NOT NULL,
                      ville VARCHAR(100) NOT NULL,
                      pays VARCHAR(100) NOT NULL,
                      telephone VARCHAR(20) NOT NULL,
                      email VARCHAR(100) NOT NULL,
                      statut VARCHAR(20) NOT NULL DEFAULT 'active',
                      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des véhicules
CREATE TABLE VEHICULE (
                        vehicule_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        agence_id BIGINT UNSIGNED NOT NULL,
                        immatriculation VARCHAR(20) NOT NULL UNIQUE,
                        marque VARCHAR(50) NOT NULL,
                        modele VARCHAR(50) NOT NULL,
                        categorie_id BIGINT UNSIGNED NOT NULL,
                        statut VARCHAR(20) NOT NULL DEFAULT 'disponible',
                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        CONSTRAINT fk_vehicule_agence FOREIGN KEY (agence_id) REFERENCES AGENCE(agence_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                        CONSTRAINT fk_vehicule_categorie FOREIGN KEY (categorie_id) REFERENCES CATEGORIE(categorie_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des clients
CREATE TABLE CLIENT (
                      client_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                      email VARCHAR(100) NOT NULL UNIQUE,
                      password_hash VARCHAR(255) NOT NULL,
                      nom VARCHAR(100),
                      prenom VARCHAR(100),
                      date_naissance DATE,
                      adresse VARCHAR(255),
                      telephone VARCHAR(20),
                      email_verified BOOLEAN NOT NULL DEFAULT FALSE,
                      date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      date_modification TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des offres de location (relation avec VEHICULE au lieu de CATEGORIE)
CREATE TABLE OFFRE (
                     offre_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                     agence_depart BIGINT UNSIGNED NOT NULL,
                     agence_retour BIGINT UNSIGNED NOT NULL,
                     vehicule_id BIGINT UNSIGNED NOT NULL, -- Changé de categorie_id à vehicule_id
                     date_depart DATETIME NOT NULL,
                     date_retour DATETIME NOT NULL,
                     tarif DECIMAL(10, 2) NOT NULL,
                     disponible BOOLEAN NOT NULL DEFAULT TRUE,
                     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                     updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                     CONSTRAINT fk_offre_agence_depart FOREIGN KEY (agence_depart) REFERENCES AGENCE(agence_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                     CONSTRAINT fk_offre_agence_retour FOREIGN KEY (agence_retour) REFERENCES AGENCE(agence_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                     CONSTRAINT fk_offre_vehicule FOREIGN KEY (vehicule_id) REFERENCES VEHICULE(vehicule_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                     CONSTRAINT check_offre_dates CHECK (date_retour > date_depart)
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des réservations (suppression de vehicule_id car il est maintenant dans l'offre)
CREATE TABLE RESERVATION (
                           reservation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           client_id BIGINT UNSIGNED NOT NULL,
                           offre_id BIGINT UNSIGNED NOT NULL,
                           date_debut DATETIME NOT NULL,
                           date_fin DATETIME NOT NULL,
                           statut VARCHAR(20) NOT NULL DEFAULT 'en attente',
                           prix_total DECIMAL(10, 2) NOT NULL,
                           date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           date_modification TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           CONSTRAINT fk_reservation_client FOREIGN KEY (client_id) REFERENCES CLIENT(client_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                           CONSTRAINT fk_reservation_offre FOREIGN KEY (offre_id) REFERENCES OFFRE(offre_id) ON DELETE RESTRICT ON UPDATE CASCADE,
                           CONSTRAINT check_reservation_dates CHECK (date_fin > date_debut)
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des paiements
CREATE TABLE PAIEMENT (
                        paiement_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        reservation_id BIGINT UNSIGNED NOT NULL,
                        montant DECIMAL(10, 2) NOT NULL,
                        devise VARCHAR(3) NOT NULL DEFAULT 'EUR',
                        methode VARCHAR(50) NOT NULL,
                        reference_externe VARCHAR(100),
                        statut VARCHAR(20) NOT NULL,
                        date_paiement TIMESTAMP NULL,
                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        CONSTRAINT fk_paiement_reservation FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des contacts avec le service client
CREATE TABLE CONTACT_SERVICE_CLIENT (
                                      contact_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                      client_id BIGINT UNSIGNED,
                                      email VARCHAR(100) NOT NULL,
                                      sujet VARCHAR(255) NOT NULL,
                                      message TEXT NOT NULL,
                                      type_contact VARCHAR(20) NOT NULL, -- 'asynchrone' ou 'synchrone'
                                      statut VARCHAR(20) NOT NULL DEFAULT 'non traité',
                                      date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      date_modification TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      CONSTRAINT fk_contact_client FOREIGN KEY (client_id) REFERENCES CLIENT(client_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
