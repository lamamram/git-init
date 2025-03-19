# git push rejetté par git

## cas de la réécriture d'historique

* `git reset | rebase | commit --amend | cherry-picking`

### sur une branche inidividuelle

`git push -f`

### sur une branche commune

* dans ce cas il faut retrouver les commmits avant la transformation de l'historique locale

```bash
git reflog
git stash -u
git reset [--hard | --mixed] stash@{index}
git stash pop
### RESOLUTION SI CONFLIT !!!
```

## cas d'un push sans avoir fait un pull préalable

### setup

1. config

```bash
git config --global merge.ff false
git config --global pull.ff only
```

2. dépôts

* le dépôt courant: 

```bash
git init
git add . && git commit -m "root-commit"
```

* dépôt distant (cf `../server-git.md`)
* dépôt alternatif:

```bash
cd ..
git clone git@<subject>.lan:app.git
```

### manip

1. dépôt alternatif: 

```bash
echo -e "\nalt update\n" > alt.txt
git add . && git commit -m "alt update"
git push origin main
```

2. dépôt courant: 

```bash
echo -e "\nmy update\n" >> content.txt
git add . && git commit -m "my update"
git push origin main
### REJECTED !!!! ###
```

> *git ne peut pas incorporer le commit "my update"*
> *car le commit "alt update" déjà poussé sur le dépôt distant*
> *n'a pas de relation enfant <=> parent avec le premier*

### résolution

* `git pull`

> *pb à cause de la configuration no-ff sur merge et ff only sur pull*
> *on ne veut pas de commit de fusion sur un pull !!!*

* `git pull --rebase`

> *remplace le merge par un rebase dans le pull (fetch && rebase)*
> *OK: place le commit "alt update" AVANT "my update"*