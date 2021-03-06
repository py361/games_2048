NB. 2048 game engine
NB. Used by the various User Interfaces (ui*.ijs) scripts

NB. When loaded the script should randomly set the random seed otherwise
NB. the same sequence of new numbers will result in each fresh J session.
verb define ''
 try.
   require 'guid'
   tmp=. _2 (3!:4) , guids 1
 catch.             NB. general/misc/guid.ijs not available
   tmp=. >:<.0.8*0 60 60 24 31#.0 0 0 0 _1+|.<.}.6!:0 ''
 end.
 ([ 9!:1) tmp       NB. set random initial random seed
)

coclass 'g2048'
Target=: 2048

new2048=: verb define
  Gridsz=: 4 4
  Points=: Score=: 0
  Grid=: newnum^:2 ] Gridsz $ 0
)

newnum=: verb define
  num=. 2 4 {~ 0.1 > ?0      NB. 10% chance of 4
  idx=. 4 $. $. 0 = y        NB. indicies of 0s
  if. #idx do.               NB. handle full grid
    idx=. ,/ ({~ 1 ? #) idx  NB. choose an index
    num (<idx)} y
  else. return. y
  end.
)

mskmerge=: [: >/\.&.|. 2 =/\ ,&_1
mergerow=: ((* >:) #~ _1 |. -.@]) mskmerge
scorerow=: +/@(+: #~ mskmerge)

compress=: -.&0
toLeft=: 1 :'4&{.@(u@compress)"1'
toRight=: 1 : '_4&{.@(u@compress&.|.)"1'
toUp=: 1 : '(4&{.@(u@compress)"1)&.|:'
toDown=: 1 : '(_4&{.@(u@compress&.|.)"1)&.|:'

move=: conjunction define
  Points=: +/@, v Grid
  update newnum^:(Grid -.@-: ]) u Grid
)

left=: 3 :'(mergerow toLeft) move (scorerow toLeft)'
right=: 3 :'(mergerow toRight) move (scorerow toRight)'
up=: 3 :'(mergerow toUp) move (scorerow toUp)'
down=: 3 :'(mergerow toDown) move (scorerow toDown)'

noMoves=: (0 -.@e. ,)@(mergerow toRight , mergerow toLeft , mergerow toUp ,: mergerow toDown)
hasWon=: Target e. ,

eval=: verb define
  Score=: Score + Points
  Points=: 0
  isend=. (noMoves , hasWon) y
  msg=. isend # 'You lost!!';'You Won!!'
  isend=. +./ isend
  isend;msg
)

update=: verb define
  Grid=: y       NB. update global Grid
  'isend msg'=. eval y
  showGrid y
  showScore 'Score: ',(": Score)
  if. isend do.
    endGame msg
  end.
  empty''
)

endGame=: showScore=: showGrid=: echo
