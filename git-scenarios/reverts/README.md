# cas d'utilisations de revert

## setup

```bash
git init
cp base.txt content.txt
git add . && git commit -m "root-commit"
```

## que fait un revert

1. créer un commit

```bash
cp update.txt content.txt
git add content.txt && git commit -m "MAJ content"
```

2. considérer le diff

* `git diff HEAD~1 HEAD`

3. inverser et le diff 

```bash
git revert HEAD --no-edit
git diff HEAD~1 HEAD
```

## conflit de revert

1. créer deux commits

```bash
 cp update2.txt content.txt
 git add content.txt && git commit -m "NEW content"
 
 cp update3.txt content.txt
 git add content.txt && git commit -m "NEW UPDATE content"
```

2. on va inverser le premier => donc HEAD~1

* `git revert HEAD~1 --no-edit`

3. conflit !!

> créer un commit inversant les diffs entre **HEAD~2 et HEAD~1** est en *contradiction* avec l'**état de HEAD** !!

* 3 possibilités
  + `git revert --abort`: on annule et on réétudie le cas
  + `git revert --skip` : on créer le commit inversant HEAD~1 ET on écrase l'état HEAD (perte de données)
  + résolution de conflits: modifier les zones en conflit => `git add . && git revert --continue --no-edit`

> pourquoi --continue et non un commit ?
> si nous avons d'autres commits intermédiaires entre le nouveau commit inversé et le commit à inverser
> ici, il n'ya qu'un seul commit, mais on pourrait en avoir d'autres !!!
