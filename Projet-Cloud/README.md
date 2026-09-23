# Documentation du Projet

## Provider Choisi

Le provider choisi est AWS. Ce choix est justifié par le fait qu'AWS est le leader historique parmi les cloud providers car couvrant actuellement, selon les données de Synergy Research Group, 28% de part du marché mondial.

## Services Choisis

- Le premier service est EC2
- Le deuxième service est S3

## Justification du Choix des Services

- **Amazon EC2 :** Représente la brique fondamentale de calcul (compute) dans le cloud. Son choix permet de manipuler le cycle de vie dynamique d'une infrastructure virtuelle (création, exécution, arrêt, destruction) et d'évaluer la gestion des dépendances réseau et de sécurité dans Floci via Terraform.
- **Amazon S3 :** Représente la brique incontournable de stockage d'objets. Ce service a été retenu pour sa simplicité de déclaration dans Terraform et sa hiérarchie de fichiers explicite, idéale pour valider rapidement la persistance des données et la bonne visibilité des ressources au sein de Floci UI.

---

## Lancement de Floci

Le choix a été fait d'installer et d'exécuter Floci via **Docker Compose** (`docker-compose.yaml`).

### Pourquoi ce choix ?

- **Simplification de la configuration :** Permet une gestion centralisée et propre des variables d'environnement AWS nécessaires au service.
- **Pratique des conteneurs :** Met en application les concepts de gestion de conteneurs.
- **Dépendance Docker sous-jacente :** Lors du premier essai d'installation via le script CLI (`curl -fsSL https://floci.io/install.sh | sh`), l'exécution de `floci start` nécessitait déjà le moteur Docker. Utiliser directement Docker Compose s'est donc imposé comme la solution la plus directe et contrôlée.

### Démarrage du service

Pour télécharger l'image (si non présente localement) et démarrer le conteneur en une seule commande :

```bash
docker compose up -d
```

## Lancement de Floci UI

L'interface graphique **Floci UI** est directement embarquée dans l'image Docker officielle de Floci :

```text
floci/floci:2.1.0
```

Il n'est donc pas nécessaire de déployer un conteneur supplémentaire pour l'interface graphique. Le conteneur Floci fournit à la fois l'émulation des services AWS et l'interface permettant de visualiser les ressources créées.

### Accès à l'interface

L'UI est servie sur le même port que le service Floci. Dans le fichier docker-compose.yaml, le port 4566 du conteneur est publié sur le port 4566 de la machine hôte.

Pour démarrer Floci, exécutez :

```bash
docker compose up -d
```

Vérifiez ensuite que le conteneur est bien en cours d'exécution :

```bash
docker compose ps
```

Si le conteneur est correctement démarré, l'interface graphique est accessible depuis votre navigateur à l'adresse suivante : [**http://localhost:4566**](http://localhost:4566)

---

## Configuration de Terraform

Avant d'exécuter Terraform, assurez-vous que les prérequis suivants sont installés :

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker](https://docs.docker.com/get-docker/)
- Docker Compose

### Structure du projet

La configuration Terraform est organisée sous formes de modules afin de garantir la configuration des services AWS :

```text
.
├── docker-compose.yaml
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── locals.tf
│   ├── variables.tf
│   ├── outputs.tf
│   │
│   └── modules/
│       ├── ec2/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       └── s3/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
└── README.md

```

### Configuration du provider AWS

Terraform utilise le provider officiel **AWS** (`hashicorp/aws`) pour gérer les ressources de l'infrastructure.

La configuration du provider est définie dans [`terraform/providers.tf`](./terraform/providers.tf).

Dans ce projet, Terraform est configuré pour communiquer avec **Floci** plutôt qu'avec l'infrastructure AWS réelle. Les endpoints des services utilisés sont redirigés vers l'instance locale de Floci :

- **Amazon EC2** → `http://localhost:4566`
- **Amazon S3** → `http://localhost:4566`

Des identifiants fictifs sont également utilisés, car aucune authentification auprès d'un compte AWS réel n'est nécessaire dans l'environnement émulé.

Certaines vérifications normalement effectuées par le provider AWS sont désactivées afin de permettre son utilisation avec l'émulateur local.

La configuration complète et les paramètres utilisés sont disponibles dans [`terraform/providers.tf`](./terraform/providers.tf).

Le fonctionnement général peut être résumé ainsi :

```text
Terraform
    │
    │ AWS Provider
    ▼
localhost:4566
    │
    ▼
  Floci
   ├── EC2
   └── S3
```

Ainsi, les ressources déclarées dans Terraform sont provisionnées dans l'environnement AWS simulé localement par Floci, sans nécessiter de compte AWS réel.

## Commandes Terraform

### Initialisation (`terraform init`)

Avant toute opération, placez-vous dans le répertoire Terraform :

```bash
cd terraform
```

Initialisez ensuite le projet avec :

```bash
terraform init
```

Cette commande initialise le répertoire de travail Terraform et installe les providers nécessaires au projet.

### Validation (`terraform validate`)

Vérifiez que la configuration Terraform est correcte :

```bash
terraform validate
```

Cette commande permet de détecter les erreurs de syntaxe et de vérifier que la configuration est valide avant de poursuivre le déploiement.

### Planification (`terraform plan`)

Avant d'appliquer les changements, générez un plan d'exécution :

```bash
terraform plan
```

Cette commande présente les modifications que Terraform prévoit d'effectuer, sans modifier les ressources existantes.

Elle permet notamment de vérifier les ressources EC2 et S3 qui seront créées.

### Application (`terraform apply`)

Pour déployer les ressources définies dans la configuration Terraform :

```bash
terraform apply
```

Terraform affiche le plan d'exécution et demande une confirmation avant d'effectuer les modifications.

Saisissez **yes** pour confirmer l'application de la configuration.

Les ressources sont alors créées dans l'environnement AWS émulé par Floci.

### Destruction (`terraform destroy`)

Une fois les tests terminés, les ressources peuvent être supprimées avec :

```bash
terraform destroy
```

Terraform affiche les ressources qui seront supprimées et demande une confirmation.

Saisissez **yes** pour confirmer leur suppression.

Cette commande permet de nettoyer les ressources créées par Terraform dans l'environnement Floci.

---

## Vérification des ressources dans Floci UI

Après l'exécution de `terraform apply`, les ressources peuvent être vérifiées directement depuis l'interface graphique de Floci.

Accédez à l'interface depuis votre navigateur :

[**Accéder à Floci UI**](http://localhost:4566)

### Vérification de la ressource EC2

Dans Floci UI, accédez au service **EC2** afin de vérifier que l'instance définie dans le module [`ec2`](./terraform/modules/ec2/) a bien été créée.

Vérifiez notamment :

- la présence de l'instance ;
- son identifiant ;
- son état ;
- les informations réseau associées.

### Vérification de la ressource S3

Accédez ensuite au service **S3** afin de vérifier que le bucket défini dans le module [`s3`](./terraform/modules/s3/) est présent.

Vérifiez notamment :

- la présence du bucket ;
- son nom ;
- son contenu, le cas échéant.

Cette vérification permet de confirmer visuellement que les ressources déclarées dans Terraform ont bien été provisionnées dans l'environnement AWS émulé par Floci.
