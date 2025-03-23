# gestion des dépôts distant

> copier le dossier "remotes" en dehors du dépôt local courant

## installer un dépôt git côté server

### se connecter sur un serveur (VM VirtualBox)

---

### créer un utilisateur git

1. `sudo useradd -m -U -s /bin/bash git`
2. changer d'utilisateur: `sudo su - git`

---

### créer le dépôt NU

* dépôt nu == **pas de copie de travail**

```bash
git config --global init.defaultBranch main
mkdir ~/app.git
cd ~/app.git
git init --bare
```

---

### créer le dossier SSH

```bash
mkdir ~/.ssh
# restreindre les droits au propriétaire
chmod 700 ~/.ssh
```

---

### créer les clés - côté client

* `ssh-keygen.exe -t ecdsa -f ~/.ssh/<pkey> -N "roottoor"`
* la paire de clé (pkey et pkey.pub) est logée dans le dossier `.ssh`
* du dossier utiliseur
* si ce dossier n'existe pas alors il sera créé automatiquement 

---

### placer la clé publique - côté serveur

* `ssh-copy-id ... | sshpass ...`
* OU 
   1. copier le contenu du fichier `~/.ssh/<pkey>.pub` (côté client)
   2. coller ce contenu dans le fichier `~/.ssh/authorized_keys` (côté serveur)
   3. restreindre les droits au propriétaire 
      + `chmod 600 ~/.ssh/authorized_keys`

---

### configurer l'utilisation de la clé privée - côté client

1. créer ou éditer le fichier `~/.ssh/config`
2. ajouter

```text
Host <ip.address.or.domain.name>
 IdentityFile "/c/Users/<user>/.ssh/<pkey>"
 UserKnownHostsFile /dev/null
 StrictHostKeyChecking no
```
3. tester la cnx ssh: 
   + `ssh git@<ip.address.or.domain.name>`

---

### configurer le dépôt distant dans le dépôt client

* `git remote add origin git@<ip.address.or.domain.name>:app.git`

---

### pousser les commits sur le dépôt distan en fonction de la branche

* `git push origin main`

---

## git push rejetté par git

> REGLE D'OR: faire un pull avant un push !!!

---

### cas de la réécriture d'historique

* `git reset | rebase | commit --amend | cherry-picking | ...`

#### sur une branche inidividuelle (feature)

`git push -f`

---

#### sur une branche commune (dev / main / preprod / prod )

* il faut **réparer l'historique**
* dans ce cas il faut **retrouver le commmit** avant la réécriture de l'historique locale

```bash
# trouver le commit le plus récent avant réécriture
git reflog
# s'il y a des modifs non commitées dans la copie
git stash -u
# restaurer ce commit
git reset [--hard | --mixed] stash@{index}
# restaurer les modifications stashées
git stash pop
### RESOLUTION SI CONFLIT !!!
```

---

### cas d'un push sans avoir fait un pull préalable

#### setup

##### 2 configs possibles

* autoriser le Fast-Forward
* ou non (ci-dessous)

```bash
# on veut des commits de fusion tout le temps en fusion
git config --global merge.ff false
# mais pas en pull !!! 
# car pull fait une fusion d' origin/<branch> dans <branch>
git config --global pull.ff only
```

---

##### dépôts

* le dépôt courant: 

```bash
git init
git add . && git commit -m "root-commit"
```

* créer un dépôt distant (cf `../server-git.md`)
* dépôt alternatif:

```bash
cd ..
git clone git@<ip.address.or.domain.name>:app.git
```

---

#### manip

1. dépôt alternatif: 

```bash
echo "alt update" > alt.txt
git add . && git commit -m "alt update"
git push origin main
```

---

2. dépôt courant: 

```bash
echo "my update" > content.txt
git add . && git commit -m "my update"
git push origin main
### REJECTED !!!! ###
```

---

3. problème

> *git ne peut pas incorporer le commit "my update"*
> *car le commit "alt update" déjà poussé sur le dépôt distant*
> *n'a pas de relation enfant <=> parent avec le premier*

---

#### résolution

* `git pull` : pour la config 1 Fast-Forward

> *pb à cause de la configuration no-ff sur merge et ff only sur pull*
> *on ne veut pas de commit de fusion sur un pull !!!*

* `git pull --rebase` : pour la config 2 non Fast-Forward

> *remplace le merge par un rebase dans le pull (fetch && rebase)*
> *OK: place le commit "alt update" AVANT "my update"*