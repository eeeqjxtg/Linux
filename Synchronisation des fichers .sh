#!/bin/bash
#Entrer les chemins a synchroniser
echo "Ecrivez le primier fichier"
read ari
echo "Ecrivez le deuxieme document"
read oph
infoA=`ls -l $ari | awk '{print $0}'`
infoB=`ls -l $oph | awk '{print $0}'`
infoC=`cat journal`

#Determiner le type de chemin

#Les deux chemins sont des fichiers

m=`ls -l $ari | cut -c 1`
n=`ls -l $oph | cut -c 1`

if test "$m"="-" -a "$n"="-"
then 
  if test ! -s ./journal
  then 

    if test $ari -nt $oph
    then
      echo `ls -l $ari` > ./journal
      echo $ari >> ./journal
      cp -r -p $ari $oph
    else
      echo `ls -l $oph` > ./journal
      echo $oph >> ./journal
      cp -r -p $oph $ari
    fi

  else
  
  if [ "$infoA"="$infoC" -a "$infoB"!="$infoC" ]
  then
    cp -r -p $oph $ari
    echo `ls -l $oph` > ./journal
    echo $oph >> ./journal

  elif [ "$infoA"!="$infoC" -a "$infoB"="$infoC" ]
  then
    cp -r -p $ari $oph
    echo `ls -l $ari` > ./journal
    echo $ari >> ./journal

  elif [ "$infoA"="$infoC" -a "$infoB"="$infoC" ]
  then 
    exit 0

  elif [ "$infoA"!="$infoC" -a "$infoB"!="$infoC" ]
  then 
    echo il y a un conflit !
  fi
fi
fi

# Les chemins sont de différents types

if [ -d $ari ] && [ -f $oph ]
then
  echo ils ne sont pas de meme type
fi

if [ -d $oph ] && [ -f $ari ]
then
  echo ils ne sont pas de meme type
fi

#Les deux chemins sont des repertoires

if [ -d $ari ] && [ -d $oph ]
then

  if [ ! -e $ari ] || [ ! -e $oph ]
  then
    echo $ari ou $oph n\'existe pas !
  exit 
  fi

#Definir les fonctions de synchronisation

function mysync() {

for i in `find $1 | sed -n '2,$p'`
#Afficher la deuxieme rangee a la derniere rangée

#Recupere tous les fichiers et sous-repertoires sous le repertoire
do
  bchemin=`echo $i | sed "s#$1#$2#'`
#Obtenir tous les fichiers et sous-repertoires sous le repertoire
  
  if [ -d $i ]
  then
    if [ ! -e $bchemin ]
#Si ce repertoire nexiste pas dans B, creer-en un
    then
      mkdir -p $bchemin
    fi
    else
    if [ -e $bchemin ]
    then
  
      if [ $i -nt $bchemin ]
      then
        cp -f -p $i $bchemin
      fi
      else
        cp -p $i $bchemin
      fi
fi
done
}

mysync $ari $oph
mysync $oph $ari
echo `ls -l $ari` > ./journal
echo `ls -l $oph` >> ./journal
fi


