# Runbook — Restauration SQL

## Objectif

Ce runbook décrit la procédure de restauration d'une base SQL Server sauvegardée par le CronJob Kubernetes `sql-data-backup`.

## Préconditions

- Le namespace `m2cloud` existe.
- Le pod `sql-data-0` est en état `Running`.
- Le CronJob `sql-data-backup` a produit au moins un fichier `.bak`.
- Une fenêtre de maintenance est validée avant restauration.

## Vérifier l'état SQL

    kubectl get statefulset,pod,pvc,cronjob,job -n m2cloud | grep -E "sql|backup"

## Lister les sauvegardes

    kubectl exec -n m2cloud sql-data-0 -- ls -lh /var/opt/mssql/data/*.bak

## Restaurer une base

Exemple pour la base `dotnetgigs.applicants` :

    kubectl exec -n m2cloud sql-data-0 -- /opt/mssql-tools/bin/sqlcmd \
      -S localhost \
      -U sa \
      -P "$MSSQL_SA_PASSWORD" \
      -Q "ALTER DATABASE [dotnetgigs.applicants] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; RESTORE DATABASE [dotnetgigs.applicants] FROM DISK = N'/var/opt/mssql/data/NOM_DU_BACKUP.bak' WITH REPLACE; ALTER DATABASE [dotnetgigs.applicants] SET MULTI_USER;"

Selon l'image utilisée, `sqlcmd` peut être disponible dans :

- `/opt/mssql-tools/bin/sqlcmd` ;
- `/opt/mssql-tools18/bin/sqlcmd`.

## Vérifier après restauration

    kubectl get pods -n m2cloud
    kubectl logs deploy/applicants-api -n m2cloud --tail=100
    kubectl logs deploy/jobs-api -n m2cloud --tail=100
    make smoke

## Points de vigilance

- Une sauvegarde n'a de valeur que si la restauration est testée.
- Le PVC ne remplace pas une vraie stratégie de sauvegarde.
- En production, les backups doivent être externalisés.
- Le RPO/RTO doit être validé avec le métier.
