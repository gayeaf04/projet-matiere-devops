# Déploiement Kubernetes — Stack LLM (Ollama + Open WebUI)

**Environnement :** Minikube (macOS, driver Docker) — Namespace `llama-chat`
**Stack :** Ollama, Open WebUI, NGINX Ingress Controller

---

## 📌 Présentation

Ce dépôt contient la migration d'une stack LLM initialement définie avec **Docker Compose** vers un déploiement **Kubernetes** local (Minikube), en appliquant les pratiques de production : isolation via Namespace, stockage persistant (PVC), gestion des ressources CPU/RAM, sondes de santé (probes) à trois niveaux, configuration découplée (ConfigMap), et exposition externe via Service NodePort et Ingress.

La stack comprend deux services :
1. **Ollama** — moteur d'inférence servant les modèles LLM (`llama3.2:3b`, `mistral:7b`, `gemma3:4b`).
2. **Open WebUI** — interface web de chat, communiquant avec Ollama.

---

## 📁 Structure du dépôt

```text
.
├── k8s/
│   ├── namespace.yaml              # Namespace llama-chat
│   ├── configmap.yaml              # OLLAMA_BASE_URL et variables de configuration
│   ├── ollama-pvc.yaml             # Stockage persistant modèles LLM (10Gi -> 30Gi)
│   ├── open-webui-pvc.yaml         # Stockage persistant base de données WebUI (1Gi)
│   ├── ollama-deployment.yaml      # Deployment Ollama (probes, ressources, volume)
│   ├── ollama-service.yaml         # Service ClusterIP "ollama" (port 11434)
│   ├── open-webui-deployment.yaml  # Deployment Open WebUI (probes, ressources, volume)
│   ├── open-webui-service.yaml     # Service NodePort (8080:30080)
│   └── ingress.yaml                # Ingress NGINX (llama.local)
│
├── rapport/
│   └── rapport-projet-k8s.pdf      # Rapport technique complet
│
├── screens/                        # Captures de validation
│
├── docker-compose.yaml             # Stack d'origine (point de départ)
└── README.md
```

---

## 🚀 Déploiement

### Prérequis

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) installé
- `kubectl` configuré
- Docker Desktop actif

### 1. Démarrer Minikube et activer l'Ingress

```bash
minikube start
minikube addons enable ingress
```

### 2. Appliquer les manifestes

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/ollama-pvc.yaml
kubectl apply -f k8s/open-webui-pvc.yaml
kubectl apply -f k8s/ollama-deployment.yaml
kubectl apply -f k8s/ollama-service.yaml
kubectl apply -f k8s/open-webui-deployment.yaml
kubectl apply -f k8s/open-webui-service.yaml
kubectl apply -f k8s/ingress.yaml
```

### 3. Vérifier le déploiement

```bash
kubectl get all -n llama-chat
kubectl get pvc -n llama-chat
```

Les deux Pods doivent être `Running` avec `READY 1/1`, et les deux PVC `Bound`.

### 4. Télécharger les modèles dans le Pod Ollama

```bash
kubectl exec -it deploy/ollama-deployment -n llama-chat -- ollama pull llama3.2:3b
kubectl exec -it deploy/ollama-deployment -n llama-chat -- ollama pull mistral:7b
kubectl exec -it deploy/ollama-deployment -n llama-chat -- ollama pull gemma3:4b
```

### 5. Accéder à Open WebUI

**Option A — via Ingress**

```bash
echo "127.0.0.1 llama.local" | sudo tee -a /etc/hosts
minikube tunnel
```

Puis ouvrir : `http://llama.local`

**Option B — via NodePort**

```bash
minikube service open-webui-service -n llama-chat --url
```

---

## 🛡️ Bonnes pratiques appliquées

- **Requests/Limits** définis sur chaque conteneur, dimensionnés selon la capacité réelle du nœud Minikube.
- **Probes** (`startupProbe`, `readinessProbe`, `livenessProbe`) adaptées à chaque service : `exec` (`ollama list`) pour Ollama, `httpGet` (`/health`) pour Open WebUI.
- **Stockage persistant** via PVC, avec redimensionnement dynamique (`allowVolumeExpansion`) sur le PVC Ollama.
- **Configuration découplée** via ConfigMap plutôt que codée en dur.
- **Images pinnées** à une version fixe (`ollama:0.33.2`, `open-webui:v0.11.3`), pas de tags mouvants (`latest`/`main`).
- **Ingress NGINX** en complément du NodePort pour un accès via nom de domaine local.

---

## 📸 Validation

Les captures d'écran de validation (Pods/Services, PVC, interface Open WebUI, prompts sur les 3 modèles) sont disponibles dans `screens/`.

## 📄 Rapport technique

Le rapport complet (architecture, comparaison Docker Compose vs Kubernetes, rôle de chaque ressource, incidents rencontrés) est disponible dans `rapport/rapport-projet-k8s.pdf`.