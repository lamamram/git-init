# cas d'utilisations de reset

> copier le dossier "resets" en dehors du dépôt local courant

```bash
git init
git add . && git commit -m "root-commit"
cat <<EOF > script1.txt
function1_1(){
  code1
  return
}

function1_2(){
  code2
  return
}
EOF
git add . && git commit -m "ajout script1.txt"

cat <<EOF > script2.txt
function2_1(){
  code3
  return
}

function2_2(){
  code4
  return
}
EOF
git add . && git commit -m "ajout script2.txt"

```

---

### supprimer des commits de l'historique et de la copie de travail

* ici on veut vraiment supprimer le code récent de l'application
* trop mauvais code / commits dans la mauvaise branche / ... / ?
 
```bash
git reset --hard HEAD~2
# voir l'historique: "ajout script1.txt" (ancien HEAD~1) a disparu
# voir l'historique: "ajout script2.txt" (ancien HEAD == ORIG_HEAD) a disparu
# voir l'historique: "root-commit" (nouveau HEAD)
git ll
# observer la copie de travail: les 2 scripts ont disparu
ll
```

---

### inverser le reset --hard

* les 2 commits ont disparu de *l'historique* MAIS **pas du dépôt** !!

```bash
# historique des positions du pointeur HEAD depuis le début du git init
# observer la signalétique HEAD@{n} => marque une structure de pile
# autrement dit les indices sont incrémentés chaque nouveau déplacement de HEAD
# autrement dit HASARDEUX
git reflog

# restaurer les 2 commits dans l'historique,
# en déplaçant HEAD sur ORIG_HEAD (l'ancien HEAD), ici HEAD@{1}
git reset --hard HEAD@{1}

# OU en utilisant les options avancées du show et le SHELL BASH
old_head=$(git show ORIG_HEAD --pretty=format:"%h" --no-patch)
echo "$old_head"
git reset --hard "$old_head"

```

---

### supprimer des commits de l'historique mais laissant intacte la copie de travail

* supprimer les commits MAIS on peut ou veut remanier le code depuis la copie de travail
* et reécrire de meilleurs commits

```bash
# disparition de l'historique
git reset HEAD~2

# MAIS pas de la copie de travail
# cela dit les fichiers concernés sont dans des états U , M , D ou R
git status
```

---

### réécriture

```bash
cat <<EOF > script1.txt
function1_1(){
  better_code1
  return
}

function1_2(){
  code2
  return
}
EOF
cat <<EOF > script2.txt
function2_2(){
  better_code4
  return
}
EOF
git add . && git commit -m "ajout de 2 scripts"

```

> PAS DE RESET ET PAR SUITE DE REECRITURE DE COMMITS 
> SUR DES COMMITS DEJA COMMITES
> SUR UNE BRANCHE COMMUNE (main/master)

---

### pas d'effet du reset sur les fichiers Untracked

```bash
echo "new_file" > new_file.txt

git reset --hard HEAD~1

# new_file est toujours là !!
git status
```

---

### reset --soft: effet curieux possibles

* `git reset --soft`: 
  + déplace HEAD
  + supprime les commits de l'historique
  + conserve la copie de travail **ET l'index AUSSI**

> permet de reprendre les fichiers ajoutés avant le commit du nouveau HEAD
> ET permet de reprendre les fichiers ajoutés juste avant le `reset --soft`

---

### statut curieux: MM 

* une modif non commitée sur un fichier 
* assis sur un commit ayant ajouté une modif M sur le même fichier

```bash
# remettre en jeu le commit des scripts
git reset --hard HEAD@{1}

# modif M dans un script2.txt
cat <<EOF >> script2.txt

function2_3(){
  code5
  return
}
EOF
git add . && git commit -m "ajout new_file.txt + MAJ script2.txt"
```

--- 

```bash
# nouvelle modif non commitée
cat <<EOF >> script2.txt

function2_4(){
  code6
  return
}
EOF

git reset --soft HEAD~1

# statut ambivalent
git status -s
```

---

### explication

> une partie de `script2.txt` est dans l'index et une autre est dans la copie !!!
> autres status ambivalents: `AM, MD, RD, ...`

```bash
# compléter le script2
git add script2.txt && git commit -m "ajout new_file.txt + vrai MAJ script2.txt"
```

> `git reset HEAD~1 && git add . && git commit -m "..."`: aurait fait la même chose
> `git add script2.txt && git commit --amend -m "..."`: aurait fait la même chose
> il faut vraiment une **raison impérieuse de conserver l'index** !!!
> correction critique sur une branche prod par ex