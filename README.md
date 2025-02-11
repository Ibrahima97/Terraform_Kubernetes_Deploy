#Mode Opératoire

##Prérequis et Installations :
- **Git** : normalement disponible par défaut sur les machines de la DIN, sinon à installer à partir du centre logiciel en utilisant TotoiseGit.

- **Rancher Desktop** : à installer à partir du centre logiciel.

- **Terraform** : à télécharger à partir de [ce lien](https://developer.hashicorp.com/terraform/install#windows) (fichier binaire AMD64), puis créez une variable d'environnement avec le nom "Terraform" qui pointe vers le dossier décompressé.

- **IDE (Optionnel)** : Utilisez Visual Studio Code avec l'extension HashiCorp Terraform.

Pour exécuter le projet en local sur Windows :

##Mise en place de l'environnement :
1. Commencez par clone le repo pour obtenir les fichiers de configuration Terraform (.tf) en local sur votre machine.
```
git clone https://DIN-SmartMobility@dev.azure.com/DIN-SmartMobility/ETM%20-%20Virtualisation/_git/ETM%20-%20Virtualisation
```
2. Pour que Airflow détecte les fichiers DAGs à orchestrer, vous devez suivre les étapes suivantes :
- Créer un repository git où vous allez mettre vous fichier DAGs,
- Modifier le Helm Chart d'Airflow sous Terraform/modules/airflow/values.yaml, en indiquant le lien vers le repo git contenant les fichiers DAGs (ligne 2600, variable gitSync:repo). Par exemple :
```
repo: https://dev.azure.com/DIN-SmartMobility/ETM%20-%20Virtualisation/_git/Airflow%20Test%20DAGs
```
Pour plus d'informations sur ce fichier Helm Chart et sur le deploiment de Airflow sur Kubernetes en général, vous pouvez consulter [ce repo git](https://github.com/airflow-helm/charts/tree/main/charts/airflow).
- Modifier le fichier terraform.tfvars en indiquant l'utilisateur Git du repo créé, ainsi que le token Git que vous devez créer en suivant [ces étapes](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows).
- Placer les fichiers DAG Airflow que vous souhaitez orchestrer sous ce repo, Airflow va effectuer des pull automatique pour les récupérer et aussi récupérer les modifications de code en fur et à mesure de vos devs.

3. Pour installer l'environnement, nous allons faire appel à Terraform. Ouvrez un terminal Windows et placez-vous dans le dossier contenant le fichier main.tf de Terraform.
- Initialisez le projet Terraform :
```
terraform init
```
- Vérifiez le plan d'exécution :
```
terraform plan
```
- Exécutez les actions proposées dans le plan :
```
terraform apply
```
##Vérification de l'installation de l'environnement :
1. Vous pouvez explorer l'interface Airflow à l'aide de Rancher Desktop :
- En allant sur l'onglet **Port Forwarding** de Rancher. 
- Ensuite, en exposant le pod **airflow-web** sur un port disponible (par exemple 8081), 
- L'interface web airflow sera disponible sur votre navigateur en utilisant l'URL: http://localhost:8081/ et Login: admin, Mot de passe: admin 
2. Vérifiez que le DAG hello_world_dag_repo est bien listé parmi les DAGs détecté par Airflow (c'est le DAG file présent sur le repo exemple proposé dans l'étape 2).
3. Exécutez-le et vérifiez la création du fichier JSON hello_world.json en suivant les étapes suivantes :
- Commencer par recuperer le nom du pod worker à l'aide de la commande ci-dessous :
```
kubectl get pods -n airflow
```
- Acceder au pod en executant la commande suivante, puis lister les fichiers (par exemple si le worker s'appelle **airflow-worker-0**) :
```
kubectl exec --stdin --tty airflow-worker-0 -n airflow -- /bin/bash
ls
```
Si le fichier hello_world.json existe parmi les fichiers listés, le DAG airflow s'est bien executé. 

Vous pouvez aussi consulter les fichier dags au niveau du dossier dags/repo.
##Destruction de l'environnement :
Détruisez toute l'infrastructure déployée par Terraform lorsqu'elle n'est plus utilisée :
```
terraform destroy
```