NB. Qt wd GUI for 2048 game

Note 'Example commands to run'
  g2048Wd ''
)

g2048Wd_z_=: verb define
  a=. conew 'g2048wd'
  create__a y
)

loc_z_=: 3 : 'jpath > (4!:4 <''y'') { 4!:3 $0'  NB. pathname of script calling it
AddonPath=. fpath_j_ loc ''

require AddonPath,'/engine.ijs'
coclass 'g2048wd'
coinsert 'g2048'

BColors=: <;.1 , ];._2 (0 :0)
#cdc1b4#ffe4c3#fff4d3#ffdac3
#e7b08e#e7bf8e#ffc4c3#e7948e
#be7e56#be5e56#9c3931#701710
)
FColor=: <'#333333'

NB. Form definitions
NB. =========================================================
MSWD=: noun define
pc mswd escclose;pn "2048";
menupop "&Game";
menu new "&New Game";
menusep;
menu exit "&Quit";
menupopz;
menupop "&Direction";
menu leftm "Move Left" "Left";
menu rightm "Move Right" "Right";
menu upm "Move Up" "Up";
menu downm "Move Down" "Down";
menupopz;
menupop "&Help";
menu help "&Instructions";
menu about "&About";
menupopz;

cc g table flush;set g minwh 335 335;
bin hvhs;
cc up button;cn Up;
bin szhs;
cc left button; cn Left;
cc right button; cn Right;
bin szhs;
cc down button;cn Down;
bin szzv;
cc sval static right sunken;set sval wh 85 60;
bin m10zz;
set sval stylesheet *QLabel {font: 14pt "monospaced";};
)
NB. Text Nouns
NB. =========================================================

Instructions=: noun define
<h3>2048</h3>
Object:
   Create the number 2048 by merging numbers.
<p>
How to play:
  When 2 numbers the same touch, they merge.
  Continue merging until you create the number
  2048, or you cannot move any more.
<p>
  Move numbers using the buttons or arrow keys.
)

About=: noun define
2048 Game
Author: Ric Sherlock

Uses Qt Window Driver for GUI
)

NB. Methods
NB. =========================================================
create=: verb define
  wd MSWD
  startNew y
  wd 'pshow'
)

destroy=: verb define
  wd 'pclose'
  codestroy ''
)

mswd_exit_button=: destroy
mswd_close=: destroy
mswd_cancel=: destroy
mswd_resize=: 3 : 'showGrid Grid'

mswd_leftm_button=: mswd_left_button=: left
mswd_rightm_button=: mswd_right_button=: right
mswd_upm_button=: mswd_up_button=: up
mswd_downm_button=: mswd_down_button=: down

mswd_new_button=: startNew
mswd_help_button=: sminfo bind ('2048 Instructions';Instructions)
mswd_about_button=: sminfo bind ('About 2048';About)

NB. mswd_default =: 3 : 'smoutput wdq'
NB. mswd_g_mark=: verb define
NB. Posns=. _3 ]\ '1 01 20 12 1'
NB.  echo g
NB.  echo Posns i. g
NB.  left`right`up`down`]@.(Posns i. ]) g
NB.  wd 'set g select 1 1' NB. select position 1 1
NB. )

fmtTable=: verb define
  wd 'set g shape ',": Gridsz
  wd 'set g align ',": 1 $~ {: Gridsz
  wd 'set g type ',": ,0 $~ Gridsz
  wd 'set g enable 0'
  wd 'set g font SansSerif 20 bold'
  y
)

showGrid=: verb define
  tbl=. (y=0)} (8!:0 y) ,: <'""'
  wd 'set g data *', ' ' joinstring ,tbl
  bkgrd=. BColors {~ (* __&~:)@(%&^. 2:) ,y
  wd 'set g color ', ' ' joinstring ,bkgrd ,. FColor
  tblsz=. _99 ". wd 'get g wh'
  cellsz=. Gridsz <.@%~ tblsz-2
  wd 'set g colwidth ',": {.cellsz
  wd 'set g rowheight ',": {:cellsz
)

startNew=: update@fmtTable@new2048
showScore=: wd@('set sval text "' , ,&'"')
endGame=: wdinfo

NB. Auto-run UI
NB. =========================================================
cocurrent 'base'
g2048Wd ''
