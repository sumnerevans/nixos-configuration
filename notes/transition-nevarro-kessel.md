Stop all matrix services:

```
systemctl stop mjolnir pantalaimon-mjolnir quotesfilebot standupbot matrix-synapse.target heisenbridge linkedin-matrix
```

Run the postgres backup service:

```
systemctl start postgresqlBackup.service
```

Copy all of the data over to kessel:

```
rsync -rv mjolnir matrix-synapse private quotesfilebot standupbot \
  kessel.nevarro.space:/var/lib
```

```
rsync -rv /var/backup/postgresql/all.sql.gz kessel.nevarro.space:/tmp/all.sql.gz
```

Restore postgres on kessel:

```
su postgres
gunzip -c /tmp/all.sql.gz | psql
```

Push new configuration to `master`
