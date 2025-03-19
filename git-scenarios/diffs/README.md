# déterminer les diffs

* setup: déplacer le dossier en dehors du dépôt cicd-dev + 
```
git init && git add . && git commit -m "root-commit"
```

## en mode fichier

* voir une modification élémentaire ou "hunk", avec ses marges internes (padding) 
  + `git diff --no-index base.txt hunk.txt`
* voir la **nb MAXIMUM de lignes** entre deux modifs inclus dans un seul hunk : 
  + `git diff --no-index base2.txt hunk2.txt`
* voir la **nb MINIMUM de lignes** entre deux modifs constituant deux hunks :
  + `git diff --no-index base3.txt hunk3.txt`

## diffs à un paramètre

* index vs working copie vs dépôt
  + `git diff`: index vs copie
  + `git diff --cached`: dépôt vs index
  + `git diff HEAD`: dépôt vs copie

```bash
cp base.txt content.txt
# RIEN par défaut en première modif avant commit
git diff;git diff --cached;git diff HEAD
git add content.txt
# RIEN dans le dépôt Mais QQCH dans l'index
git diff --cached
git commit -m "add content"
git diff;git diff --cached;git diff HEAD
# RIEN : copie == index == dépôt
cp base3.txt content.txt
git diff;git diff HEAD
# QQCH
git diff --cached
# RIEN: index == dépôt
git commit -m "MAJ content"
###
cp hunk3.txt content.txt
git add -p
# > y et n
git diff
# QQCH : le hunk non ajouté !!
git diff --cached
# QQCH : le hunk ajouté mais pas encore commité !!
git diff HEAD
# QQCH : les deux hunks non commités !!


```
## diff pour un fichier particulier

* `git diff [...] ... -- <file>`

## diff à 2 paramètres

* `git diff hash1 hash2` ou `git diff branch1 branch2`
* 
