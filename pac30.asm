MOVING_SPRITES      = $00                                   ; Comment this line out to disable ghosts from moving
; G^Ray Defender
; 11/11/2015
;
; 12/19/15
; Adding logic to make ghosts smarter,
; make them follow pac-man
;
; Logic to eat the ghosts Part 1
;  * blue time mode added
; 12/22/15
; Logic to eat the ghosts Part 2
;  * blue time duration
;  * make ghosts move away from pac-clone
; 01/11/16
; Add eyes logic to make ghost move back to ghost cage
; once it has been 'eaten'
;01/16/16 Make pac-clone move in last direction of travel
; even if input is not given
;if wall is hit in attempted direction make pac-clone
;continue along previous path until end of path
; * Bug fixes
; * 1/19/16 Add Comments, formatting & change variable names
; * 1/22/16 Fix program crash in RAND sub
; * Change ghosts to turn back to 1,2,3,4 after blue time
; * reformat code 20,20,20 - spacing wise
; * Add scoring routine for dots and power pills
; * 1/23/16 Add score for eating ghosts
; * 1/25/16 Add level logic
; * 1/26/16 Add Ready text
; * 1/27/16 add pac-death noooo
; * Bug Fixes
; * 2/3/16 Fix Warp Tunnel Logic and Keyboard press logic
; * Previously had separate warp code for ghosts vs pac-clone
; * 2/27/16 Add Ghost sprites
; *         add eye sprites
; * 3/9 Add flashing energizers
; * 3/15 Animate Ghost death and fix related problems
; * 3/19 Change dot color after certain number of ghost moves
; * 4/1/16 Implement Map transition effect
; * 4/2/16 Fix bug where ghosts refuse to enter cage (if wall
; * char is not directly above ghost cage)
; *4/22/16 Fix boost values after level 14
; * add one digit to the score
; * Fix bug if energizer is eaten last
; * 5/09/16 Implement Speed boost and super speed boost
; * 5/11/16 Implement Random opposite move for ghosts
; * 5/12/16 Fix bug g$len was being stomped on
; turns out g$ variables needs to be 5 bytes
; or a check to be sure the len is not >3 |so just made 5 bytes
; rather than adding an extra check, thats the trade off made
; 06/23/16 - Worked on ch levels
; 06/24/16 - added fruit to the mix but no score indictors just yet
; 07/16/16 - Change code to support user defined character sets
; 09/03/16 - Fix bug where fruit counts same as dots
; 09/10/16 - Implement Bonus rewards for completing challenge screens
; 09/11/16 - Quash some bugs including wait for input before start game
; 10/01/16 - Add joystick input on port 2
; 12/17/16 - REMOVE COLOR DATA FROM GAME MAPS
;============================================================
;  Quick code to create auto execute program from basic
;============================================================
#region Charset & Sprites & Maps
*=$2000
charset
incbin              "charset.bin"               ; Created with CBM Char editor
*=$3000

; Pac_facing_up_mouth_open
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Pac_Facing_up_mouth_closing
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$66
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Pac_mouth_closed
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Pac_Facing_down_-_mouth_open
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$00
                    BYTE                $00

; Pac_Facing_down_-_mouth_closing
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$66
                    BYTE                $00,$00,$00
                    BYTE                $00


; Pac_Facing_left_-_mouth_open
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$7C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$1F
                    BYTE                $00,$00,$07
                    BYTE                $00,$00,$07
                    BYTE                $00,$00,$1F
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$7C
                    BYTE                $00

; Pac_Facing_left_-_mouth_closing
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$7F
                    BYTE                $00,$00,$07
                    BYTE                $00,$00,$07
                    BYTE                $00,$00,$7F
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00


; Pac_Facing_right_-_mouth_open
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3E
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$F8
                    BYTE                $00,$00,$E0
                    BYTE                $00,$00,$E0
                    BYTE                $00,$00,$F8
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3E
                    BYTE                $00

; Pac_Facing_right_-_mouth_closing
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$FE
                    BYTE                $00,$00,$E0
                    BYTE                $00,$00,$E0
                    BYTE                $00,$00,$FE
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Ghost_looking_up
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$5A
                    BYTE                $00,$00,$DB
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$A5
                    BYTE                $00

; Ghost_looking_down
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$DB
                    BYTE                $00,$00,$DB
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$A5
                    BYTE                $00

; Ghost_moving_left
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$5A
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$AB
                    BYTE                $00,$00,$55
                    BYTE                $00

; Ghost_Moving_Right
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$5A
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$D5
                    BYTE                $00,$00,$AA
                    BYTE                $00

; Eyes_looking_left
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$62
                    BYTE                $00,$00,$B5
                    BYTE                $00,$00,$F5
                    BYTE                $00,$00,$62
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$42
                    BYTE                $00

; Eyes_looking_right
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$46
                    BYTE                $00,$00,$AD
                    BYTE                $00,$00,$AF
                    BYTE                $00,$00,$46
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$42
                    BYTE                $00

; Eyes_Looking_up
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$A5
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$42
                    BYTE                $00

; Eyes_Looking_Down
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$A5
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$42
                    BYTE                $00

; Dying_Pac_Facing_Up_-_mouth_open_
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_2
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$81
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$E7
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_3
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$81
                    BYTE                $00,$00,$C3
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_4
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$FF
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_5
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$7E
                    BYTE                $00,$00,$3C
                    BYTE                $00,$00,$18
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_6
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$18
                    BYTE                $00,$00,$18
                    BYTE                $00,$00,$18
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_7
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$08
                    BYTE                $00,$00,$08
                    BYTE                $00,$00,$08
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_8
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$08
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_9
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$14
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$14
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_10
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$08
                    BYTE                $00,$00,$22
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$22
                    BYTE                $00,$00,$08
                    BYTE                $00,$00,$00
                    BYTE                $00

; Dying_Pac_Facing_Up_-_Dying_11
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$14
                    BYTE                $00,$00,$42
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$81
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$81
                    BYTE                $00,$00,$42
                    BYTE                $00,$00,$14
                    BYTE                $00

; 100_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$02,$77
                    BYTE                $00,$06,$55
                    BYTE                $00,$02,$55
                    BYTE                $00,$02,$55
                    BYTE                $00,$02,$55
                    BYTE                $00,$02,$55
                    BYTE                $00,$07,$77
                    BYTE                $00

; 200_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$07,$77
                    BYTE                $00,$01,$55
                    BYTE                $00,$01,$55
                    BYTE                $00,$07,$55
                    BYTE                $00,$04,$55
                    BYTE                $00,$04,$55
                    BYTE                $00,$07,$77
                    BYTE                $00

; 400_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$05,$77
                    BYTE                $00,$05,$55
                    BYTE                $00,$05,$55
                    BYTE                $00,$07,$55
                    BYTE                $00,$01,$55
                    BYTE                $00,$01,$55
                    BYTE                $00,$01,$77
                    BYTE                $00

; 800_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$07,$77
                    BYTE                $00,$05,$55
                    BYTE                $00,$05,$55
                    BYTE                $00,$07,$55
                    BYTE                $00,$05,$55
                    BYTE                $00,$05,$55
                    BYTE                $00,$07,$77
                    BYTE                $00

; 1600_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$26,$77
                    BYTE                $00,$64,$55
                    BYTE                $00,$24,$55
                    BYTE                $00,$27,$55
                    BYTE                $00,$25,$55
                    BYTE                $00,$25,$55
                    BYTE                $00,$77,$77
                    BYTE                $00

; 3200_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$77,$77
                    BYTE                $00,$11,$55
                    BYTE                $00,$11,$55
                    BYTE                $00,$77,$55
                    BYTE                $00,$14,$55
                    BYTE                $00,$14,$55
                    BYTE                $00,$77,$77
                    BYTE                $00

; 4000_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$57,$77
                    BYTE                $00,$55,$55
                    BYTE                $00,$55,$55
                    BYTE                $00,$75,$55
                    BYTE                $00,$15,$55
                    BYTE                $00,$15,$55
                    BYTE                $00,$17,$77
                    BYTE                $00

; 5000_point_sprite
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$77,$77
                    BYTE                $00,$45,$55
                    BYTE                $00,$45,$55
                    BYTE                $00,$75,$55
                    BYTE                $00,$15,$55
                    BYTE                $00,$15,$55
                    BYTE                $00,$77,$77
                    BYTE                $00

; Double_sized_box_for_Draagns_Wrath
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $FF,$FF,$F0
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00,$00,$00
                    BYTE                $00

*=$4000

Map1_Data

; Screen 1 - Map 1 Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$30,$30,$30,$30,$30,$30,$30,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$30,$30,$30,$30,$30,$30,$30,$20,$20,$20,$20,$20
        BYTE    $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
        BYTE    $E3,$2A,$20,$20,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$E3,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$E3,$E3,$2E,$2E,$2E,$2E,$2A,$E3
        BYTE    $E3,$2E,$E3,$20,$E3,$2E,$E3,$E3,$E3,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$20,$E3,$2E,$E3,$2E,$2E,$2E,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$E3,$E3,$20,$2E,$2E,$2E,$2E,$2E,$20,$20,$E3,$20,$20,$2E,$2E,$2E,$2E,$2E,$20,$20,$E3,$2E,$E3
        BYTE    $E3,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$E3,$E3,$20,$20,$20,$E3,$20,$E3,$2E,$20,$20,$20,$E3,$E3,$20,$E3,$20,$E3,$20,$20,$20,$E3,$20,$E3,$20,$E3,$E3,$E3,$20,$E3,$2E,$E3
        BYTE    $E3,$20,$E3,$E3,$E3,$20,$20,$2E,$E3,$E3,$E3,$E3,$20,$E3,$20,$E3,$2E,$E3,$E3,$20,$E3,$20,$20,$E3,$20,$E3,$E3,$E3,$20,$E3,$20,$E3,$20,$E3,$E3,$E3,$20,$E3,$2E,$E3
        BYTE    $E3,$2E,$2E,$2E,$E3,$20,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$20,$20,$2A,$20,$20,$E3,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$20,$20,$20,$20,$E3,$20,$20,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$20,$20,$E3,$E3,$20,$E3,$E3,$E3,$20,$E3,$E3,$E3,$20,$E3,$E3,$E3,$E3,$20,$20,$2E,$2E,$E3,$20,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$20,$E3,$E3,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$E3,$20,$E3,$E3,$20,$E3,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$E3,$E3,$E3,$20,$E3,$2E,$E3,$E3,$20,$E3,$20,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$20,$20,$20,$20,$20,$20,$E3,$2E,$E3,$E3,$E3,$E3,$2E,$20,$20,$20,$20,$20,$20,$2E,$E3,$20,$20,$E3,$20,$E3,$E3,$E3,$E3,$E3,$E3,$20,$E3,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$E3,$20,$E3,$E3,$E3,$2E,$2E,$2E,$E3,$2E,$2E,$2E,$2E,$E3,$E3,$2D,$E3,$E3,$E3,$2E,$E3,$20,$E3,$E3,$20,$E3,$2E,$2E,$2E,$20,$2E,$2E,$2E,$2E,$2E,$E3
        BYTE    $20,$2E,$20,$2E,$E3,$20,$E3,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3,$E3,$20,$E3,$20,$20,$20,$20,$E3,$2E,$20,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$20
        BYTE    $E3,$2E,$E3,$2E,$E3,$20,$20,$2E,$E3,$E3,$E3,$2E,$20,$2E,$E3,$E3,$20,$E3,$E3,$E3,$E3,$E3,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$E3,$20,$E3,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$20,$20,$E3,$2E,$2E,$2E,$20,$2E,$E3,$2E,$2E,$2E,$20,$20,$20,$20,$20,$20,$20,$2E,$E3,$2E,$E3,$E3,$E3,$E3,$20,$E3,$E3,$E3,$E3,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$E3,$E3,$E3,$20,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$2E,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$E3,$2E,$E3,$E3,$E3,$E3,$20,$E3,$E3,$E3,$E3,$20,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$E3,$20,$E3,$E3,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3,$20,$E3,$E3,$E3,$20,$E3,$E3,$20,$E3,$E3,$E3,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$2E,$2E,$20,$2E,$E3
        BYTE    $E3,$2E,$2E,$2E,$2E,$2E,$E3,$20,$E3,$E3,$E3,$2E,$E3,$2E,$E3,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3,$20,$E3,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$20,$E3,$2E,$20,$2E,$2E,$2E,$2E,$2E,$20,$2E,$E3,$2E,$E3,$E3,$E3,$E3,$E3,$E3,$20,$E3,$2E,$20,$2E,$E3,$2E,$E3,$20,$E3,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$20,$20,$2E,$E3,$2E,$E3,$E3,$E3,$20,$E3,$2E,$E3,$2E,$20,$20,$20,$20,$20,$20,$20,$E3,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$2E,$2E,$E3,$2E,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2E,$E3,$E3,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$20,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$E3,$E3,$E3,$20,$E3,$2E,$20,$2E,$E3,$2E,$E3,$2E,$E3,$E3,$E3,$2E,$E3,$2E,$E3,$2E,$E3
        BYTE    $E3,$2A,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$2E,$2E,$20,$2E,$2E,$2E,$2E,$2E,$E3,$2E,$2E,$2A,$E3
        BYTE    $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

; Screen 2 - Map 2 Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $A0,$2A,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$20,$20,$20,$6C,$67,$20,$20,$20,$6E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$2E,$2E,$2A,$A0
        BYTE    $A0,$2E,$68,$6D,$69,$20,$6F,$2E,$70,$6D,$6D,$71,$2E,$70,$71,$20,$6B,$6A,$20,$66,$20,$20,$2E,$6F,$20,$6F,$2E,$70,$6D,$6D,$71,$2E,$6C,$2E,$61,$6D,$6D,$71,$2E,$A0
        BYTE    $A0,$2E,$6B,$64,$78,$20,$6C,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$20,$20,$6F,$2E,$6C,$20,$6E,$2E,$20,$20,$20,$2E,$2E,$6C,$2E,$6C,$2E,$2E,$2E,$2E,$A0
        BYTE    $A0,$2E,$20,$20,$6C,$20,$6C,$20,$6F,$20,$68,$6D,$6D,$69,$20,$68,$6D,$69,$2E,$6F,$20,$6E,$2E,$6C,$20,$20,$2E,$6F,$20,$6F,$2E,$68,$79,$2E,$6C,$2E,$6F,$20,$68,$A0
        BYTE    $A0,$2E,$6F,$20,$6E,$20,$6E,$20,$6E,$20,$6B,$64,$7E,$6A,$20,$6B,$5D,$67,$2E,$6C,$20,$20,$2E,$6C,$20,$6F,$2E,$6C,$20,$6E,$2E,$6B,$6A,$2E,$6C,$2E,$6C,$20,$65,$A0
        BYTE    $A0,$2E,$6C,$20,$20,$20,$20,$2E,$2E,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$6B,$6A,$2E,$6C,$20,$6F,$2E,$6E,$20,$6E,$2E,$6C,$20,$20,$2E,$2E,$2E,$2E,$6C,$2E,$6C,$20,$65,$A0
        BYTE    $A0,$2E,$5E,$62,$20,$68,$69,$2E,$70,$6D,$62,$2E,$6E,$2E,$6F,$2E,$2E,$2E,$2E,$6C,$20,$6C,$2E,$2E,$20,$20,$2E,$5E,$71,$20,$70,$6D,$62,$20,$6C,$2E,$6C,$20,$65,$A0
        BYTE    $A0,$2E,$2E,$6C,$20,$6C,$67,$2E,$20,$20,$6C,$2E,$20,$2E,$5E,$71,$20,$70,$6D,$5F,$20,$5E,$71,$2E,$68,$69,$2E,$2E,$2E,$2E,$2E,$2E,$6C,$20,$6E,$2E,$6E,$20,$65,$A0
        BYTE    $A0,$A0,$2E,$6E,$20,$6C,$67,$2E,$6F,$20,$6C,$2E,$6F,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$7B,$77,$71,$20,$61,$6D,$71,$2E,$6C,$20,$20,$2E,$2E,$2E,$6B,$A0
        BYTE    $A0,$A0,$2E,$20,$20,$6B,$78,$2E,$6C,$20,$6E,$2E,$6C,$2E,$70,$62,$2E,$61,$71,$2D,$70,$6D,$62,$2E,$6C,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$74,$71,$20,$70,$62,$2E,$2E,$A0
        BYTE    $20,$20,$2E,$6F,$20,$20,$6E,$2E,$6C,$20,$20,$2E,$6C,$2E,$2A,$6C,$2E,$6C,$20,$20,$20,$20,$6C,$2E,$6E,$2E,$6F,$2E,$6E,$2E,$6F,$20,$6E,$2E,$2E,$2E,$5E,$71,$2E,$20
        BYTE    $A0,$A0,$2E,$5E,$71,$20,$20,$2E,$7A,$63,$69,$2E,$6E,$2E,$70,$5F,$2E,$5E,$6D,$6D,$6D,$6D,$5F,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$6F,$2E,$2E,$2E,$2E,$A0
        BYTE    $A0,$20,$2E,$2E,$20,$20,$6F,$2E,$6C,$20,$6C,$2E,$20,$2E,$2E,$2E,$2E,$20,$20,$20,$20,$20,$20,$2E,$6F,$20,$6E,$20,$70,$6D,$5F,$2E,$68,$7C,$73,$6D,$6D,$71,$20,$A0
        BYTE    $A0,$20,$6F,$2E,$66,$20,$6C,$2E,$6B,$64,$6A,$2E,$68,$69,$2E,$70,$6D,$6D,$62,$20,$61,$6D,$71,$2E,$6C,$20,$20,$20,$20,$20,$20,$2E,$6C,$67,$2E,$2E,$2E,$2E,$2E,$A0
        BYTE    $A0,$20,$6C,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$2E,$2E,$65,$6C,$2E,$20,$20,$20,$6C,$20,$6C,$2E,$2E,$2E,$74,$71,$20,$70,$6D,$6D,$62,$2E,$6B,$6A,$2E,$68,$63,$69,$2E,$A0
        BYTE    $A0,$20,$6E,$20,$66,$2E,$6E,$2E,$68,$69,$20,$70,$76,$6A,$2E,$70,$71,$20,$6C,$20,$6C,$2E,$66,$20,$6E,$2E,$2E,$2E,$2E,$2E,$6C,$2E,$20,$20,$2E,$6C,$20,$6C,$2E,$A0
        BYTE    $A0,$20,$20,$20,$20,$2E,$2E,$2E,$6C,$67,$20,$20,$20,$20,$2E,$2E,$2E,$20,$6C,$20,$6C,$2E,$20,$20,$20,$2E,$70,$6D,$62,$2E,$6E,$2E,$68,$69,$2E,$6C,$20,$6C,$2E,$A0
        BYTE    $A0,$6D,$6D,$6D,$71,$20,$70,$6D,$76,$6A,$20,$70,$6D,$6D,$6D,$71,$2E,$68,$79,$20,$6C,$2E,$68,$7C,$71,$2E,$20,$20,$6C,$2E,$20,$2E,$6C,$67,$2E,$6C,$20,$6C,$2E,$A0
        BYTE    $A0,$2E,$2E,$2E,$2E,$2E,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$6B,$6A,$20,$6E,$2E,$6B,$78,$2E,$2E,$6F,$20,$6C,$2E,$6F,$2E,$6C,$67,$2E,$6C,$20,$6C,$2E,$A0
        BYTE    $A0,$2E,$70,$6D,$71,$2E,$6F,$2E,$70,$6D,$6D,$6D,$6D,$6D,$6D,$71,$2E,$20,$20,$20,$20,$2E,$2E,$6E,$2E,$70,$5F,$20,$6E,$2E,$6E,$2E,$6B,$6A,$2E,$6B,$64,$6A,$2E,$A0
        BYTE    $A0,$2A,$2E,$2E,$2E,$2E,$6C,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$68,$63,$63,$63,$69,$2E,$2E,$2E,$20,$20,$20,$20,$2E,$2E,$2E,$20,$20,$2E,$2E,$2E,$2E,$2A,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
; Screen 3 - Map 3 Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $A0,$2A,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$20,$20,$20,$20,$20,$A0,$2E,$2E,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2A,$A0
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$DE,$20,$EA,$A0,$A0,$A0,$20,$A0,$2E,$E4,$2E,$20,$2E,$EA,$A0,$EB,$20,$E4,$20,$EA,$A0,$A0,$A0,$A0,$A0,$A0,$EB,$2E,$E4,$2E,$A0
        BYTE    $A0,$2E,$A0,$20,$20,$20,$20,$DE,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$DE,$2E,$A0,$2E,$A0,$2E,$20,$20,$20,$20,$A0,$20,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E4,$2E,$A0
        BYTE    $A0,$2E,$A0,$20,$A0,$EB,$20,$DE,$20,$A0,$20,$EA,$A0,$2E,$A0,$2E,$2E,$2E,$A0,$2E,$A0,$2E,$EA,$A0,$A0,$A0,$A0,$20,$A0,$2E,$A0,$A0,$A0,$A0,$A0,$EB,$20,$20,$2E,$A0
        BYTE    $A0,$2E,$A0,$20,$A0,$2A,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$DE,$2E,$EA,$A0,$A0,$2E,$DE,$2E,$2E,$2E,$2E,$A0,$A0,$20,$A0,$2E,$A0,$20,$20,$20,$20,$20,$20,$A0,$2E,$A0
        BYTE    $A0,$2E,$DE,$20,$A0,$EB,$2E,$E4,$2E,$EA,$A0,$2E,$A0,$2E,$20,$2E,$20,$20,$20,$2E,$20,$2E,$A0,$A0,$2E,$A0,$A0,$20,$A0,$2E,$DE,$20,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$2E,$A0,$2E,$A0,$2E,$A0,$2E,$A0,$A0,$A0,$2E,$A0,$2E,$A0,$A0,$2E,$A0,$A0,$20,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$2E,$2E,$2E,$A0,$2E,$A0,$A0,$A0,$2E,$DE,$2E,$A0,$A0,$2E,$20,$20,$20,$A0,$A0,$20,$EA,$A0,$A0,$A0,$A0,$A0,$EB,$20,$A0
        BYTE    $A0,$2E,$A0,$20,$20,$20,$20,$20,$A0,$2E,$A0,$A0,$EB,$20,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E4,$20,$EA,$A0,$A0,$20,$DE,$2E,$2E,$2E,$A0,$20,$20,$20,$A0
        BYTE    $A0,$2E,$DE,$20,$A0,$A0,$A0,$20,$DE,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$2E,$A0,$A0,$2D,$A0,$A0,$A0,$2E,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$E4,$2E,$DE,$20,$EA,$A0,$A0
        BYTE    $20,$2E,$20,$20,$20,$20,$20,$2E,$2E,$2E,$EA,$A0,$A0,$2E,$A0,$A0,$2E,$A0,$20,$20,$20,$20,$A0,$2E,$A0,$A0,$2E,$A0,$A0,$A0,$A0,$A0,$20,$A0,$2E,$2E,$2E,$2E,$2E,$20
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$2E,$E4,$2E,$20,$20,$A0,$2E,$2E,$2E,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$DE,$2E,$2E,$A0,$2E,$2E,$2E,$A0,$20,$A0,$A0,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$2E,$A0,$20,$A0,$A0,$A0,$CC,$20,$20,$20,$20,$20,$20,$20,$2E,$2E,$2E,$A0,$A0,$2E,$E4,$2E,$A0,$20,$A0,$A0,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$DE,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$2E,$2E,$20,$20,$A0,$A0,$A0,$A0,$20,$E4,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$2E,$A0,$2E,$A0,$20,$20,$20,$20,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$20,$2E,$A0,$A0,$A0,$2E,$A0,$A0,$A0,$2E,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$20,$A0,$A0,$2E,$A0,$2E,$A0,$A0,$A0,$EB,$20,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$A0,$20,$A0,$2E,$A0,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$20,$2E,$A0,$20,$A0,$2E,$20,$20,$A0,$A0,$EB,$20,$A0,$2E,$D0,$A0,$20,$A0,$20,$20,$20,$DE,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$E4,$2E,$A0,$A0,$A0,$2E,$E4,$20,$DE,$20,$20,$20,$20,$2E,$2E,$20,$20,$A0,$EB,$EB,$20,$20,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$EB,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$A0,$20,$20,$20,$A0,$A0,$A0,$A0,$2E,$E4,$20,$20,$20,$20,$20,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$EB,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$20,$EA,$A0,$EB,$20,$DE,$20,$EA,$A0,$A0,$A0,$A0,$A0,$EB,$20,$EA,$A0,$EB,$20,$A0,$2E,$A0
        BYTE    $A0,$2A,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2A,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
; Screen 4 - map 4 Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $A0,$2A,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$2E,$2E,$A0,$A0,$A0,$A0,$20,$20,$20,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2A,$A0
        BYTE    $A0,$20,$E2,$E2,$E2,$E2,$2E,$2E,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$20,$20,$2E,$A0,$2E,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$20,$20,$20,$E2,$E2,$E2,$20,$A0,$A0,$20,$A0,$A0,$20,$A0,$2E,$A0,$A0,$A0,$A0,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$E2,$20,$E2,$2E,$A0,$2A,$A0,$A0,$A0,$20,$A0,$2E,$A0
        BYTE    $A0,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$A0,$2E,$2E,$A0,$A0,$A0,$2E,$A0,$A0,$A0,$A0,$A0,$2E,$E2,$E2,$E2,$2E,$A0,$2E,$2E,$2E,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$2E,$2E,$A0,$A0,$20,$A0,$A0,$A0,$A0,$2E,$A0,$20,$A0,$A0,$2E,$20,$20,$20,$2E,$2E,$A0,$20,$20,$20,$2E,$20,$20,$E2,$2E,$A0,$A0,$A0,$2E,$2E,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$20,$20,$20,$20,$A0,$20,$A0,$A0,$2E,$2E,$2E,$2E,$A0,$2E,$A0,$A0,$A0,$A0,$2E,$A0,$20,$A0,$A0,$2E,$A0,$20,$20,$2E,$2E,$2E,$A0,$A0,$A0,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$20,$A0,$A0,$2E,$A0,$2E,$A0,$20,$20,$A0,$2E,$2E,$2E,$2E,$A0,$2E,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$A0,$2E,$2E,$A0,$2E,$A0
        BYTE    $A0,$2E,$2E,$2E,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$2E,$2E,$2E,$A0,$A0,$A0,$A0,$2E,$A0,$A0,$2E,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$A0,$A0,$A0,$20,$20,$20,$20,$A0,$20,$A0,$2E,$A0,$20,$20,$20,$20,$20,$2E,$2E,$2E,$2E,$A0,$2E,$A0,$A0,$A0,$20,$A0,$20,$A0,$2E,$A0,$A0,$A0,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$2E,$2E,$A0,$20,$D0,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$20,$A0,$A0,$2D,$A0,$A0,$A0,$20,$A0,$A0,$2E,$2E,$2E,$A0,$20,$A0,$20,$20,$2E,$20,$20,$20,$2E,$A0
        BYTE    $20,$2E,$A0,$20,$E2,$2E,$A0,$20,$CF,$A0,$20,$20,$20,$2E,$2E,$20,$20,$A0,$20,$20,$20,$20,$A0,$20,$A0,$A0,$A0,$A0,$2E,$A0,$20,$A0,$A0,$A0,$2E,$A0,$A0,$A0,$2E,$20
        BYTE    $A0,$2E,$A0,$20,$E2,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$2E,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$20,$E4,$A0,$20,$A0,$2E,$A0,$20,$20,$20,$20,$2E,$A0,$2E,$2E,$2E,$A0
        BYTE    $A0,$2E,$20,$20,$E2,$E2,$E2,$E2,$20,$A0,$2E,$A0,$A0,$2E,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$A0,$2E,$A0,$20,$A0,$A0,$A0,$2E,$20,$2E,$A0,$A0,$A0
        BYTE    $A0,$2E,$A0,$20,$E2,$E2,$E2,$E2,$20,$A0,$2E,$2E,$A0,$2E,$A0,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$20,$A0,$20,$A0,$2E,$2E,$2E,$2E,$2E,$A0,$2E,$E2,$2E,$20,$20,$A0
        BYTE    $A0,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$2E,$A0,$2E,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$A0,$2E,$A0,$A0,$A0,$2E,$A0,$2E,$E2,$2E,$A0,$20,$A0
        BYTE    $A0,$2E,$A0,$2E,$E2,$2E,$A0,$A0,$2E,$2E,$A0,$2E,$2E,$2E,$20,$2E,$A0,$20,$A0,$A0,$20,$A0,$A0,$A0,$2E,$A0,$A0,$A0,$2E,$20,$20,$A0,$2E,$A0,$2E,$E2,$2E,$2E,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$E2,$2E,$A0,$A0,$A0,$2E,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$20,$20,$20,$20,$20,$20,$A0,$2E,$2E,$2E,$2E,$2E,$A0,$20,$A0,$2E,$A0,$2E,$E2,$E2,$E2,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$E2,$2E,$2E,$2E,$2E,$2E,$20,$20,$20,$20,$A0,$2E,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$20,$2E,$20,$2E,$2E,$E2,$E2,$2E,$A0
        BYTE    $A0,$2E,$20,$2E,$E2,$E2,$E2,$E2,$E2,$20,$A0,$A0,$A0,$20,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$A0,$2E,$A0,$A0,$2E,$E2,$E2,$2E,$A0
        BYTE    $A0,$2E,$A0,$2E,$E2,$E2,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$20,$A0,$2E,$A0,$A0,$2E,$E2,$E2,$2E,$A0
        BYTE    $A0,$2A,$20,$2E,$2E,$2E,$2E,$A0,$A0,$A0,$A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20,$20,$2E,$2E,$2E,$2E,$20,$20,$2A,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
; Screen 5 - Maze Craze Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
        BYTE    $E9,$20,$20,$20,$20,$E8,$E8,$E8,$E8,$E8,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E6,$20,$20,$20,$20,$20,$20,$20,$E6,$20,$20,$20,$20,$E6,$53,$53,$E9
        BYTE    $E9,$20,$E8,$E8,$20,$20,$20,$20,$20,$20,$20,$E8,$E8,$E8,$E8,$E8,$E8,$20,$E8,$E8,$E6,$E6,$20,$20,$20,$E6,$E6,$E6,$20,$E6,$20,$20,$20,$E6,$E6,$20,$20,$E6,$53,$E9
        BYTE    $E9,$20,$52,$E8,$E8,$E8,$E8,$20,$E8,$E8,$20,$E8,$E8,$E8,$20,$20,$20,$20,$51,$E8,$51,$20,$20,$E6,$20,$20,$20,$20,$20,$E6,$E6,$E6,$E6,$51,$E6,$E6,$20,$20,$20,$E9
        BYTE    $E9,$20,$E8,$E8,$51,$E8,$E8,$20,$E8,$E8,$20,$E8,$E8,$E8,$20,$E8,$E8,$E8,$E8,$E8,$E6,$20,$E6,$E6,$20,$E6,$52,$E6,$20,$20,$20,$20,$20,$20,$20,$E6,$E6,$E6,$20,$E9
        BYTE    $E9,$20,$E8,$20,$20,$20,$20,$20,$E8,$E8,$20,$52,$E8,$20,$20,$E8,$51,$E8,$53,$E8,$E6,$20,$E6,$E6,$20,$E6,$E6,$E6,$20,$E6,$E6,$E6,$20,$E6,$20,$20,$20,$E6,$20,$E9
        BYTE    $E9,$20,$E8,$20,$E8,$E8,$E8,$E8,$53,$E8,$20,$E8,$E8,$20,$E8,$E8,$51,$E8,$20,$20,$20,$20,$20,$E6,$20,$E6,$E6,$20,$20,$52,$52,$E6,$20,$E6,$E6,$E6,$20,$20,$20,$E9
        BYTE    $E9,$20,$E8,$20,$52,$52,$E8,$E8,$53,$E8,$20,$E8,$52,$20,$E8,$53,$53,$20,$20,$E8,$E6,$E6,$20,$20,$20,$20,$20,$20,$E6,$52,$E6,$E6,$20,$E6,$E6,$E6,$E6,$20,$E6,$E9
        BYTE    $E9,$20,$E8,$20,$E8,$E8,$E8,$2E,$2E,$E8,$20,$E8,$E8,$20,$E8,$E8,$E8,$20,$E8,$20,$20,$20,$20,$E6,$E6,$20,$E6,$20,$E6,$E6,$E6,$20,$20,$52,$E6,$E6,$20,$20,$E6,$E9
        BYTE    $E9,$20,$20,$20,$20,$20,$2E,$2E,$2E,$E8,$20,$E8,$E8,$20,$52,$E8,$E8,$20,$20,$20,$E6,$E6,$E6,$E6,$E6,$20,$E6,$20,$20,$20,$20,$20,$E6,$52,$51,$E6,$20,$E6,$E6,$E9
        BYTE    $E9,$20,$E8,$20,$E8,$E8,$2E,$2E,$2E,$E8,$20,$20,$20,$20,$E8,$E8,$51,$20,$E8,$20,$2E,$2E,$2E,$2E,$E6,$20,$20,$20,$E6,$E6,$E6,$20,$E6,$E6,$E6,$E6,$20,$E6,$53,$E9
        BYTE    $E9,$20,$20,$20,$E8,$E8,$E8,$E8,$E8,$E8,$20,$E8,$E8,$20,$E8,$E8,$E8,$20,$E8,$20,$E6,$53,$E6,$2E,$E6,$20,$E6,$E6,$E6,$52,$52,$20,$20,$20,$20,$20,$20,$20,$20,$E9
        BYTE    $E9,$20,$E8,$20,$20,$20,$20,$20,$E8,$2E,$2E,$2E,$E8,$20,$E8,$2E,$2E,$20,$20,$20,$E6,$E6,$E6,$2E,$E6,$20,$E6,$E6,$E6,$E6,$E6,$E6,$52,$E6,$E6,$E6,$E6,$20,$E6,$E9
        BYTE    $E9,$20,$E8,$E8,$E8,$E8,$E8,$20,$20,$2E,$E8,$2E,$E8,$20,$E8,$E8,$2E,$E8,$20,$E8,$E6,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E6,$E6,$E6,$E6,$2E,$2E,$E6,$20,$20,$E9
        BYTE    $E9,$20,$E8,$51,$51,$20,$20,$20,$E8,$2E,$2E,$2E,$E8,$20,$E8,$2E,$2E,$E8,$20,$E8,$20,$20,$E6,$E6,$E6,$E6,$20,$E6,$E6,$20,$51,$51,$51,$51,$2E,$2E,$2E,$E6,$20,$E9
        BYTE    $E9,$20,$E8,$E8,$E8,$20,$E8,$E8,$E8,$E8,$E8,$E8,$20,$20,$E8,$2E,$2E,$E8,$20,$20,$20,$E6,$E6,$2E,$2E,$E6,$20,$E6,$E6,$E6,$2E,$E6,$2E,$2E,$2E,$2E,$55,$E6,$20,$E9
        BYTE    $E9,$20,$E8,$E8,$20,$20,$20,$20,$20,$E8,$E8,$20,$20,$E8,$E8,$53,$2E,$53,$E8,$20,$E6,$E6,$2E,$54,$2E,$E6,$20,$20,$20,$E6,$E6,$E6,$E6,$E6,$2E,$2E,$2E,$E6,$20,$E9
        BYTE    $E9,$20,$20,$20,$20,$E8,$E8,$E8,$E8,$20,$20,$20,$E8,$E8,$51,$E8,$E8,$E8,$20,$20,$E6,$2E,$2E,$2E,$2E,$E6,$52,$E6,$20,$20,$20,$20,$20,$20,$E6,$E6,$E6,$20,$20,$E9
        BYTE    $E9,$20,$E8,$E8,$E8,$E8,$E8,$20,$20,$20,$E8,$E8,$52,$E8,$51,$E8,$52,$E8,$20,$E8,$E6,$E6,$E6,$E6,$2E,$E6,$E6,$E6,$54,$E6,$E6,$E6,$E6,$20,$20,$20,$20,$20,$E6,$E9
        BYTE    $E9,$20,$20,$20,$20,$20,$20,$20,$E8,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E6,$E6,$E6,$52,$E6,$E6,$E6,$E6,$E6,$E6,$20,$20,$E9
        BYTE    $E9,$20,$E8,$E8,$E8,$20,$E8,$E8,$E8,$E8,$51,$E8,$E8,$E8,$E8,$20,$E8,$E8,$E8,$E8,$E6,$51,$E6,$E6,$20,$E6,$20,$20,$20,$20,$20,$20,$20,$E6,$E6,$E6,$E6,$E6,$20,$E9
        BYTE    $E9,$20,$20,$20,$20,$20,$52,$52,$E8,$E8,$51,$E8,$E8,$E8,$51,$51,$51,$E8,$E8,$51,$51,$51,$E6,$E6,$51,$E6,$51,$E6,$E6,$E6,$E6,$E6,$20,$20,$20,$20,$20,$20,$20,$E9
        BYTE    $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
; Screen 6 - Dragons Wrath Screen data

        BYTE    $A0,$A0,$A0,$A0,$A0,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $A0,$20,$A0,$52,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$A0,$53,$20,$20,$53,$A0
        BYTE    $A0,$20,$20,$20,$20,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$51,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$A0,$A0,$51,$A0,$20,$20,$20,$20,$20,$20,$20,$A0,$51,$A0,$20,$A0,$52,$A0,$20,$20,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$20,$20,$20,$20,$53,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$A0,$A0,$51,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$51,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$A0,$51,$20,$20,$A0,$53,$20,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$A0,$20,$A0,$52,$A0,$20,$A0,$20,$A0,$51,$20,$20,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$20,$A0,$53,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$20,$20,$20,$A0,$20,$A0,$52,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$A0,$20,$A0,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$A0,$20,$20,$20,$20,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$20,$20,$A0,$20,$A0,$3A,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$A0,$A0,$53,$A0,$20,$20,$20,$A0,$51,$A0,$52,$A0,$3A,$A0,$20,$A0,$53,$A0,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$A0,$52,$A0,$20,$A0,$A0
        BYTE    $A0,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$3A,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$51,$A0,$20,$52,$A0
        BYTE    $A0,$A0,$20,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$53,$53,$51,$51,$A0,$20,$20,$20,$A0,$53,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$A0,$A0,$A0,$A0,$A0,$A0,$20,$FB,$FB,$FB,$20,$FB,$FB,$FB,$20,$FB,$FB,$FB,$20,$FB,$FB,$FB,$20,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$53,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$A0,$A0,$20,$20,$20,$20,$A0,$20,$FB,$53,$53,$20,$FB,$3A,$FB,$20,$FB,$3A,$FB,$20,$FB,$3A,$3A,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$53,$A0,$20,$20,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$FB,$51,$FB,$20,$FB,$FB,$FB,$20,$FB,$FB,$FB,$20,$FB,$3A,$53,$20,$A0,$20,$3A,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0
        BYTE    $A0,$20,$20,$20,$A0,$20,$20,$20,$A0,$20,$FB,$51,$FB,$20,$FB,$3A,$3A,$20,$FB,$52,$FB,$20,$FB,$3A,$3A,$20,$A0,$20,$20,$20,$A0,$58,$51,$51,$A0,$20,$20,$20,$20,$A0
        BYTE    $A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$FB,$FB,$FB,$20,$FB,$3A,$53,$20,$FB,$51,$FB,$20,$FB,$FB,$FB,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$20,$A0,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$51,$53,$20,$20,$20,$A0,$20,$20,$20,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0,$A0,$20,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$20,$A0,$20,$A0,$20,$20,$20,$A0,$52,$20,$20,$20,$20,$A0,$20,$20,$20,$A0,$20,$A0,$20,$20,$51,$A0,$51,$53,$20,$A0,$20,$A0,$52,$51,$20,$A0,$20,$51,$A0
        BYTE    $A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0
        BYTE    $A0,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$A0,$20,$A0,$20,$20,$20,$A0,$20,$20,$20,$20,$A0,$20,$20,$20,$20,$20,$20,$20,$53,$A0,$51,$51,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$53,$A0,$A0,$A0,$51,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$20,$A0,$A0,$20,$20,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$57,$A0,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
; Screen 7 - Carpals Tunnel Screen data

        BYTE    $20,$20,$20,$20,$20,$13,$03,$0F,$12,$05,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$08,$09,$3A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        BYTE    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$FF,$FF
        BYTE    $FF,$20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$FF,$FF
        BYTE    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$20,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$2E,$FF,$FF
        BYTE    $FF,$FF,$FF,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$FF,$FF
        BYTE    $FF,$2E,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$FF,$FF
        BYTE    $FF,$2E,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$20,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$20,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        BYTE    $FF,$2E,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$FF,$FF
        BYTE    $FF,$2E,$FF,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$2E,$FF,$2E,$2E,$FF,$FF
        BYTE    $FF,$2E,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$2E,$FF,$FF
        BYTE    $A0,$2E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$2E,$A0,$A0
        BYTE    $20,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$20
        BYTE    $A0,$2E,$FC,$9C,$2E,$A0,$2E,$A0,$A0,$A0,$2E,$FD,$9D,$2E,$A0,$2E,$EA,$A0,$A0,$2E,$FE,$9E,$2E,$A0,$2E,$EA,$A0,$A0,$2E,$FF,$9F,$2E,$A0,$2E,$EA,$A0,$A0,$2E,$A0,$20
        BYTE    $A0,$2E,$FC,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FD,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FE,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FF,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$20,$20
        BYTE    $A0,$2E,$FC,$2E,$EA,$A0,$EB,$2E,$A0,$A0,$2E,$FD,$2E,$EA,$A0,$EB,$2E,$A0,$A0,$2E,$FE,$2E,$EA,$A0,$EB,$2E,$A0,$A0,$2E,$FF,$2E,$EA,$A0,$EB,$2E,$A0,$A0,$2E,$A0,$A0
        BYTE    $A0,$2E,$FC,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FD,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FE,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$FF,$2E,$2E,$A0,$2E,$2E,$A0,$A0,$2E,$A0,$A0
        BYTE    $A0,$2E,$FC,$9C,$2E,$51,$2E,$EA,$A0,$A0,$2E,$FD,$9D,$2E,$52,$2E,$EA,$A0,$A0,$2E,$FE,$9E,$2E,$53,$2E,$EA,$A0,$A0,$2E,$FF,$9F,$2E,$54,$2E,$EA,$A0,$A0,$2E,$2E,$A0
        BYTE    $A0,$2E,$FC,$2E,$2E,$FC,$2E,$2E,$A0,$A0,$2E,$FD,$2E,$2E,$FD,$2E,$2E,$A0,$A0,$2E,$FE,$2E,$2E,$FE,$2E,$2E,$A0,$A0,$2E,$FF,$2E,$2E,$FF,$2E,$2E,$A0,$A0,$EB,$2E,$A0
        BYTE    $A0,$2E,$FC,$2E,$C2,$FC,$9C,$2E,$A0,$A0,$2E,$FD,$2E,$C3,$FD,$9D,$2E,$A0,$A0,$2E,$FE,$2E,$C4,$FE,$9E,$2E,$A0,$A0,$2E,$FF,$2E,$C5,$FF,$9F,$2E,$A0,$A0,$2E,$2E,$A0
        BYTE    $A0,$2E,$FC,$2E,$2E,$FC,$2E,$2E,$A0,$A0,$2E,$FD,$2E,$2E,$FD,$2E,$2E,$A0,$A0,$2E,$FE,$2E,$2E,$FE,$2E,$2E,$A0,$A0,$2E,$FF,$2E,$2E,$FF,$2E,$2E,$A0,$A0,$2E,$A0,$A0
        BYTE    $A0,$2E,$FC,$9C,$2E,$FC,$2E,$A0,$A0,$A0,$2E,$FD,$9D,$2E,$FD,$2E,$EA,$A0,$A0,$2E,$FE,$9E,$2E,$FE,$2E,$EA,$A0,$A0,$2E,$FF,$9F,$2E,$FF,$2E,$EA,$A0,$A0,$2E,$A0,$A0
        BYTE    $A0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$A0,$A0
        BYTE    $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

#endregion
*=$0801
                    byte                $0c, $08, $0a, $00, $9e, $20
                    byte                $33, $30, $34, $36, $34, $00
                    byte                $00,$00
#region Program Variables

junklskdfj          byte                $31,$31,$31
gh2_eyesmode        byte                00
gh2_bluetime        byte                00
gh2_cage_cntr       byte                00
gh2_exit_cage_flg   byte                00
gh2_xg              byte                0;39
gh2_yg              byte                0;12
gh2_gx              byte                0;18
gh2_gy              byte                0;12
gh2_pq$             byte                $00,$00
gh2_g$              byte                $00,$00,$00,$00,$00
gh2_pd$             byte                0;21
gh2_cdir            byte                0;21
gh2_pq$len          byte                00
gh2_g$len           byte                00
gh2_spctr           byte                00
gh2_sp_pos          byte                00

Cage_Xpos           byte                19
Cage_Ypos           byte                12
LEVEL_DONE          byte                00

gh1_gy              byte                0;10
gh1_gx              byte                0;39
gh1_pq$             byte                $00,$00
gh1_pq$len          byte                00
gh1_g$              byte                $00,$00,$00,$00,$00
gh1_g$len           byte                00
gh1_xg              byte                0; 39
gh1_yg              byte                0; 12
gh1_pr              byte                00
gh1_pr_cntr         byte                0
gh1_spctr           byte                00
gh1_pd$             byte                0
gh1_cdir            byte                0;4
gh1_bluetime        byte                00
gh1_eyesmode        byte                00
gh1_cage_cntr       byte                00
gh1_exit_cage_flg   byte                00
gh1_sp_pos          byte                00

gxminus1            byte                00
gxplus1             byte                00
gyminus1            byte                00
gyplus1             byte                00
gx                  byte                0
gy                  byte                00
pq$                 byte                $00,$00
pq$len              byte                00
junkaaa             byte                $FF,$FF,$FF,$FF,$FF,$FF
g$                  byte                $00,$00,$00,$00,$00
g$len               byte                00
junkbaa             byte                $FF,$FF,$FF,$FF,$FF,$FF
g$eyesmode          byte                00
g$cage_cntr         byte                00
g$bluetime          byte                00
g$exit_cage_flg     byte                00
xg                  byte                0
yg                  byte                0
pr_cntr             byte                0
ghost_pr            byte                3
pd$                 byte                0
cdir                byte                0

map_off_l           byte                $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$b8,$E0,$08,$30,$58,$80,$a8,$d0,$f8,$20,$48,$70,$98,$c0
map_off_h           byte                $04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07
TOP_ROW_SAVE        bytes               40  ; 40 bytes reserved to save off top row
                    
wall_dot            byte                46  ; period '.'
wall_spc            byte                32  ; space ' '


wall3__nrgzr        byte                42  ; asterisk '*'
pac_char            byte                60  ; Pac-Clone char
wall_cge            byte                45  ; '-' this is the cage minus char
superbonus          byte                00                 ; If this value changes then no super bonus is awarded after completing all three challenges successfully.
ATTRACT_MODE        byte                00
lbl_boost           Null                'speed boost!'
lbl_boost2          Null                'super speed!'
lbl_bonus           Null                'bonus award!'
lbl_superbonus      Null                'super bonus!'

;*****************************************************
gh3_gx              byte                0
gh3_gy              byte                0
gh3_pq$             byte                $00,$00
gh3_g$              byte                $00,$00,$00,$00,$00
gh3_xg              byte                0
gh3_yg              byte                0
gh3_pd$             byte                0
gh3_cdir            byte                0
gh3_pq$len          byte                00
gh3_g$len           byte                00
gh3_bluetime        byte                00
gh3_eyesmode        byte                00
gh3_cage_cntr       byte                00
gh3_exit_cage_flg   byte                00
gh3_spctr           byte                00
gh3_sp_pos          byte                00

gh4_gx              byte                0
gh4_gy              byte                0
gh4_pq$             byte                $00,$00
gh4_g$              byte                $00,$00,$00,$00,$00
gh4_xg              byte                0
gh4_yg              byte                0
gh4_pd$             byte                0
gh4_cdir            byte                0
gh4_pq$len          byte                00
gh4_g$len           byte                00
gh4_bluetime        byte                00
gh4_eyesmode        byte                00
gh4_cage_cntr       byte                00
gh4_exit_cage_flg   byte                00
gh4_spctr           byte                00
gh4_sp_pos          byte                00

gh5_gx              byte                32
gh5_gy              byte                14
gh5_pq$             byte                $00,$00
gh5_g$              byte                $00,$00,$00,$00,$00
gh5_xg              byte                11
gh5_yg              byte                12
gh5_pd$             byte                21
gh5_cdir            byte                4
gh5_pq$len          byte                00
gh5_g$len           byte                00
gh5_bluetime        byte                00
gh5_eyesmode        byte                00
gh5_cage_cntr       byte                00
gh5_exit_cage_flg   byte                00
gh5_spctr           byte                00
gh5_sp_pos          byte                00

ispacman            byte                00
userdirection       byte                00

SCORE_PARAM1        byte                00
SCORE_PARAM2        byte                00
SCORE_POS           = $40c                                  ; Position of First 0 in score from left
HISCORE_POS         = $41c

SCORE_COLOR         = $d810
SAVED_SCORE         byte                $30,$30,$30,$30,$30,$30,$30
HIGHSCORE_SCORE       byte                $30,$30,$30,$30,$30,$30,$30

GHOSTS_EATEN        byte                00                  ; Count Number of ghosts eaten per blue time
COLOR_CNTR          byte                15                  ; Number of screen flashes between levels
PACS_AVAIL          byte                3
FREE_MAN            byte                00
DEATH_FLAG          byte                00                   ; 1 if pac be dead
DOTS_EATEN          byte                00
TOTAL_DOTS_FLAG     byte                0
                                                            ; Needed since more than 255 dots on map
TOTAL_GH_FLAG       byte                0                                   ; Count how many moves 1 ghost has made
TOTAL_GH_MOVES      byte                0
DOT_POINTS          byte                01
DOT_DEC             byte                05

gh2_pr_cntr         byte                00                   ; Current GH priority counters
gh3_pr_cntr         byte                00                   ; These counters count up
gh4_pr_cntr         byte                00                   ; until they match the default priority
gh5_pr_cntr         byte                00                   ; then they get reset
rnd_move_counter    byte                00
sprite_counter      byte                00
gh2_bt_count        byte                255
gh3_bt_count        byte                50
gh4_bt_count        byte                50
gh5_bt_count        byte                50

gh2_pr              byte                00                   ; Current GH2 Priority
gh3_pr              byte                00                   ; Current GH3 Priority
gh4_pr              byte                00                   ; Current GH4 Priority
gh5_pr              byte                00                   ; Current GH5 Priority

gh2_flashon         byte                00
gh3_flashon         byte                00
gh4_flashon         byte                00
gh5_flashon         byte                00



curr_sprite         byte                00

sprxmap             byte                $00,$02,$04,$06,$08
sprmap2             byte                %00000001,%00000010,%00000100,%00001000,%00010000

sp_gh_dir           byte                SPR_ROOT+9,SPR_ROOT+10,SPR_ROOT+11,SPR_ROOT+12  ; ghosts up down left right
sp_eye_dir          byte                SPR_ROOT+15,SPR_ROOT+16,SPR_ROOT+13,SPR_ROOT+14  ; ghost eyes up down left right

sprcolor            byte                $1, $0a, $3, $2
close_mouth         byte                00                  ; Need mouth closed after level completion and right before play begins
spreyecolor         byte                $1,$1,$1,$1,14
Const_UP            byte                $57                  ;Currently matching
Const_DOWN          byte                $5a                  ;Getch return values
Const_LEFT          byte                $41                  ;for up down left right
Const_RIGHT         byte                $53
;*****************************************************
; Level Defaults
; First byte is level 1, second level 2, etc.
;*****************************************************
                                                            ;83,48,54,49
Const_TOTAL_DOTS    byte                83,48,54,49,111,72,135
;83,48,72,53,111,49,135,72                    ; Total number of dots on each map
ACTUAL_MAP_LEVELS   byte                00,00,04,01,01,01,06,02,02,02, 05,03,03,03,00,01,02 ; Play map 0 two times, map 1 three times, etc

;** defautl ghosts bluetime duration **
Const_gh2_bt_DEF    byte                160,160,00,60,60,60,00,50,40,35,00,30,25,20,15,10,05         ; Blue time Reset counter 1
Const_gh3_bt_DEF    byte                160,160,00,60,60,60,00,50,40,35,00,30,25,20,15,10,05         ; Blue time Reset counter 2
Const_gh4_bt_DEF    byte                160,160,00,60,60,60,00,50,40,35,00,30,25,20,15,10,05         ; Blue time Reset counter 3
Const_gh5_bt_DEF    byte                160,160,00,60,60,60,00,50,40,35,00,30,25,20,15,10,05         ; Blue time Reset counter 4
;** Flash ghosts length of time **
Const_gh2_bt_DEF2   byte                30,30,00,15,15,15,00,10,10,10,00,10,10,09,08,04,01         ; Blue time counter 1
Const_gh3_bt_DEF2   byte                60,60,00,15,15,15,00,12,12,12,00,12,12,10,08,05,01         ; Blue time counter 2
Const_gh4_bt_DEF2   byte                60,60,00,15,15,15,00,12,12,12,00,12,12,10,08,05,01         ; Blue time counter 3
Const_gh5_bt_DEF2   byte                60,60,00,15,15,15,00,12,12,12,00,12,12,10,08,05,01         ; Blue time counter

Const_gh2_DEF_PR    byte                01,12,12,11,11,10,10,09,02,07, 22,06,05,04,01,02,05         ; Priorities, give a break at high level
Const_gh3_DEF_PR    byte                11,10,10,10,09,10,10,09,08,07, 20,06,05,10,01,05,05         ;
Const_gh4_DEF_PR    byte                11,10,10,10,10,03,03,09,08,02, 20,06,09,04,01,04,05         ;
Const_gh5_DEF_PR    byte                11,10,09,09,10,10,10,02,08,07, 29,02,05,04,01,03,05

Const_Orig_boost    byte                09,07,07,06,06,06,06,05,05,05, 05,04,04,04,03,02,01 ; Used for pac clone only, for reseting back gh1_sp_boost_goal to orig values

gh1_sp_boost_goal   byte                09,07,06,06,06,06,05,05,05,05, 04,04,04,04,03,02,01
gh2_sp_boost_goal   byte                08,08,08,07,07,07,07,06,06,06, 18,05,05,05,04,03,01
gh3_sp_boost_goal   byte                07,10,10,05,09,09,09,07,04,07, 20,05,06,06,04,03,02
gh4_sp_boost_goal   byte                06,06,09,09,09,05,07,07,07,04, 19,03,03,06,04,03,01
gh5_sp_boost_goal   byte                09,10,10,09,09,09,09,04,07,07, 20,06,06,03,04,03,02
MAP_INDEX           byte                00                                                  ; Game Level defaults to 0, after calling RESET_LEVEL
SCREENS_CLEARED     byte                00
MAX_MAP_LEVELS      = 17                                    ; Maximum number of maps available
EnergizerColor      byte                01,01,00,02,02,02,00,01,01,01, 00,07,07,07,01,01,01 ; Energizer color for each game map
MAP_BG_COLOR        byte                12,15,00,12,08,12,06,12,12,11, 11,12,00,12,00,00,04 ; Middle BG color
MAP_BD_COLOR        byte                11,12,11,14,09,11,06,14,12,00, 11,00,12,00,11,12,11 ; Border color
GAME_SPEED          byte                44,43,43,42,41,40,40,39,38,36, 42,34,32,30,28,25,20
SCORE_COLOR_MAP     byte                00,00,01,01,00,00,01,01,01,01, 01,00,00,00,01,01,01 ; Score Color used on each map

PAC_Start_X         byte                19,19,07,19,19,19,01,19,19,19, 01,19,19,19,19,19,19
PAC_Start_Y         byte                14,14,22,14,14,14,03,14,14,14, 02,14,14,14,14,14,14

;actual_map-levels
GH1_Start_X         byte                18,18,05,18,18,18,19,18,18,18, 17,18,18,18,18,18,18 ; GHOST X, Y starting positions on each map
GH1_Start_Y         byte                12,12,03,12,12,12,06,12,12,12, 18,12,12,12,12,12,12
GH2_Start_X         byte                19,19,12,19,19,19,04,19,19,19, 22,19,19,19,19,19,19
GH2_Start_Y         byte                12,12,11,12,12,12,22,12,12,12, 06,12,12,12,12,12,12


GH3_Start_X         byte                20,20, 27,20,20,20,30,20,20,20, 28,20,20,20,20,20,20
GH3_Start_Y         byte                12,12, 17,12,12,12,22,12,12,12, 14,12,12,12,12,12,12
GH4_Start_X         byte                21,21, 29,21,21,21,19,21,21,21, 05,21,21,21,21,21,21
GH4_Start_Y         byte                12,12, 02,12,12,12,12,12,12,12, 22,12,12,12,12,12,12

;
Pac_SP_X            byte                20*08,20*08,08*08,20*08,20*08,20*08,02*08,20*08,20*08,20*08, 02*08,20*08,20*08,20*08,20*08,20*08,20*08
Pac_SP_Y            byte                149,149,213,149,149,149,061,149,149,149, 53,149,149,149,149,149,149
;
GH1_SP_X            byte                19*08,19*08,06*08,19*08,19*08,19*08,20*08,19*08,19*08,19*08, 18*08,19*08,19*08,19*08,19*08,19*08,19*08
GH1_SP_Y            byte                133,133,061,133,133,133,085,133,133,133, 181,133,133,133,133,133,133
GH2_SP_X            byte                20*08,20*08,13*08,20*08,20*08,20*08,05*08,20*08,20*08,20*08, 23*08,20*08,20*08,20*08,20*08,20*08,20*08
GH2_SP_Y            byte                133,133,125,133,133,133,213,133,133,133, 085,133,133,133,133,133,133
GH3_SP_X            byte                21*08,21*08, 28*08,21*08,21*08,21*08,31*08,21*08,21*08,21*08, 29*08,21*08,21*08,21*08,21*08,21*08,21*08
GH3_SP_Y            byte                133,133,173, 133,133,133,213,133,133,133, 149,133,133,133,133,133,133
GH4_SP_X            byte                22*08,22*08, 30*08,22*08,22*08,22*08,20*08,22*08,22*08,22*08, 06*08,22*08,22*08,22*08,22*08,22*08,22*08
GH4_SP_Y            byte                133,133,053, 133,133,133,133,133,133,133, 213,133,133,133,133,133,133,133

fruit1              = 81                                    ; fruit 1
fruit2              = 82                                    ; fruit 2
fruit3              = 83                                    ; fruit 3
fruit4              = 84                                    ; fruit 4
fruit5              = 85                                    ; fruit 5
fruit6              = 86                                    ; fruit 6
fruit7              = 87                                    ; fruit 7
fruit8              = 88                                    ; fruit 8

Fruit_Colors        byte                01,10,02,01,11,10,14,03
Fruit_Map_Ctr       byte                00                  ; Counter for fruit
FRUIT_ON_SCREEN     = $643                                  ; Physical location of fruit in center of map
FRUIT_CLR_SCREEN    = $da43                                 ; Color pos of fruit in center of map
CURRENT_FRUIT       byte                00
CURR_FRUIT_COLOR    byte                00
;Positions of all energizers on all maps
                                                            ; byte                $39,$39,$39,$39
ENG1                = $d851                                 ; These four energizers
ENG2                = $db71                                 ; are in the same positions
ENG3                = $d876                                 ; on all maps
ENG4                = $db96                                 ;
MAP1ENG5            = $d92b                                 ; The fifth energizer moves
MAP2ENG5            = $d9EE                                 ; around on the different
MAP3ENG5            = $d8f5                                 ; maps
MAP4ENG5            = $d8c0                                 ;

Energizer1Hi        byte                >ENG1,>ENG1,>ENG1,>ENG1,>ENG1,>ENG1,>ENG1,>ENG1
Energizer1Lo        byte                <ENG1,<ENG1,<ENG1,<ENG1,<ENG1,<ENG1,<ENG1,<ENG1
Energizer2Hi        byte                >ENG2,>ENG2,>ENG2,>ENG2,>ENG2,>ENG2,>ENG2,>ENG2
Energizer2Lo        byte                <ENG2,<ENG2,<ENG2,<ENG2,<ENG2,<ENG2,<ENG2,<ENG2
Energizer3Hi        byte                >ENG3,>ENG3,>ENG3,>ENG3,>ENG3,>ENG3,>ENG3,>ENG3
Energizer3Lo        byte                <ENG3,<ENG3,<ENG3,<ENG3,<ENG3,<ENG3,<ENG3,<ENG3
Energizer4Hi        byte                >ENG4,>ENG4,>ENG4,>ENG4,>ENG4,>ENG4,>ENG4,>ENG4
Energizer4Lo        byte                <ENG4,<ENG4,<ENG4,<ENG4,<ENG4,<ENG4,<ENG4,<ENG4
Energizer5Hi        byte                >MAP1ENG5,>MAP2ENG5,>MAP3ENG5,>MAP4ENG5,$d9,$d9,$d9,$d9
Energizer5Lo        byte                <MAP1ENG5,<MAP2ENG5,<MAP3ENG5,<MAP4ENG5,$2b,$2b,$2b,$2b
CHALLENGE_SCREEN    byte                00 ; If 1 then we are on a challenge map
PACMAPL             byte                <MAP1_DATA,<MAP2_DATA ,<MAP3_DATA ,<MAP4_DATA,<MAP5_DATA,<MAP6_DATA,<MAP7_DATA
PACMAPH             byte                >MAP1_DATA,>MAP2_DATA ,>MAP3_DATA ,>MAP4_DATA,>MAP5_DATA,>MAP6_DATA,>MAP7_DATA


MAP2_DATA           = MAP1_DATA+1000                        ; Address of second game map
MAP3_DATA           = MAP1_DATA+2000                        ; Address of third game map
MAP4_DATA           = MAP1_DATA+3000                        ; Address of forth game map
MAP5_DATA           = MAP1_DATA+4000
MAP6_DATA           = MAP1_DATA+5000
MAP7_DATA           = MAP1_DATA+6000

#endregion
#Region Macro Subs Located here
;*****************************************************
; Grab value of screen position located at x,y
; Store result in accumulator
;*****************************************************
defm                peekaxy
                    ldx                 /2                  ; X value
                    ldy                 /1                  ; Y Value
                    lda                 map_off_l,x         ; Load map low byte into $fb
                    sta                 $fb                 
                    lda                 map_off_h,x         ; Load map hig byte into $fc
                    sta                 $fc                 
                    lda                 ($fb),y             ; Load result into acc
                    endm
;*****************************************************
; This macro checks the character at position x,y
; to see if it matches a wall or not.
;wall_chk            gx,gyminus1,Const_DOWN,Const_UP,#1
;wall_chk            gxminus1,gy,Const_RIGHT,Const_LEFT,#2;
;*****************************************************
defm                wall_chk

                    ldx                 /2                  ; I realize these next 7 lines
                    ldy                 /1                  ; are my peekaxy macro

                    cpx                 Cage_Ypos           
                    bne                 @skip1              
                    cpy                 #40                 
                    beq                 @notwall            
@skip1              lda                 map_off_l,x         ; but CBM Prg Studio cannot
                    sta                 $fb                 ; nest the macro calls
                    lda                 map_off_h,x         
                    sta                 $fc                 
                    lda                 ($fb),y             
                    cmp                 wall_dot            ; Is it a dot?
                    beq                 @notwall            
                    cmp                 wall_spc            ; Is it a space?
                    beq                 @notwall            
                    cmp                 #fruit1             ; Is it a fruit 1
                    beq                 @notwall            
                    cmp                 #fruit2             ; Is it a fruit 2
                    beq                 @notwall            
                    cmp                 #fruit3             ; Is it a fruit 3
                    beq                 @notwall            
                    cmp                 #fruit4             ; Is it a fruit 4
                    beq                 @notwall            
                    cmp                 #fruit5             ; Is it a fruit 5
                    beq                 @notwall            
                    cmp                 #fruit6             ; Is it a fruit 6
                    beq                 @notwall            
                    cmp                 #fruit7             ; Is it a fruit 7
                    beq                 @notwall            
                    cmp                 #fruit8             ; Is it a fruit 8
                    beq                 @notwall            
                    cmp                 wall3__nrgzr        ; Is it an engerizer pill?
                    beq                 @notwall            
                    cmp                 wall_cge            ; Is it cage character '-'?
                    bne                 @bot                ; No charcters match then exit
                    lda                 ispacman            ; Don't let pac-clone
                    cmp                 #1                  ; into the ghost cage
                    beq                 @bot                ; quit if pac-clone hitting cage char
                    lda                 g$eyesmode          ;is eyemode activated?
                    cmp                 #1                  ;Yes then allow ghost into
                    beq                 @notwall            ;the ghost cage
                                                            ; So to get to this point we are
                    lda                 /5                  ; looking at cage char, not pac-man, eyesmode off
                    cmp                 #0                  ; This is saying if I am looking at the south wall
                    beq                 @bot                ; =ghost trying to enter cage, then do not allow entry into cage
                    lda                 g$exit_cage_flg     ;These lines prevent non eyes
                    cmp                 #1                  ;from entering ghost cage
                    bne                 @bot                
@notwall
                    lda                 pd$                 ;Load the previous direction
                    cmp                 /3                  ;make sure ghost does not move in
                    beq                 @bottom             ;previous direction so no quick back and forth movement

                    lda                 /4                  ;Load opposite direction
                    ldx                 g$len               ;
                    sta                 g$,x                ;Store as new possible direction of travel

                    inc                 g$len               

                    lda                 /5                  ;Load Last Param either 0,1,2,3,4
                    cmp                 #0                  ;0=check Up for wall
                    beq                 @zero               
                    lda                 /5                  
                    cmp                 #1                  ;1=check Down for wall
                    beq                 @one                
                    lda                 /5                  
                    cmp                 #2                  ;2=check Left for wall
                    beq                 @two                
                    lda                 /5                  
                    cmp                 #3                  ;3=check right for wall
                    beq                 @three              
@bot                jmp @bottom
@zero               lda                 gy                  ; The next 16 lines
                    cmp                 yg                  ; Determine if the new direction
                    bcs                 @bottom             ; of travel is a priority direction
                    jmp                 @cont               ; meaning a direction which will
@one                lda                 gy                  ; more quickly move the ghost
                    cmp                 yg                  ; toward the pac-clone
                    bcc                 @bottom             ;
                    jmp                 @cont               ;
@two                lda                 gx                  ;
                    cmp                 xg                  ;
                    bcc                 @bottom             ;
                    jmp                 @cont               ;
@three              lda                 gx                  ;
                    cmp                 xg                  ;
                    bcs                 @bottom             ;
                    jmp                 @cont               ;
@cont               lda                 /4                  ; Load new direction
                    ldx                 pq$len              ; Store as new priority direction
                    sta                 pq$,x               ; of travel
                    inc                 pq$len              ;
@bottom
                    nop
                    endm
;*****************************************************
; Variable Initilization Part 1
; Usage:
; move_ghosts_part1    gh1_pr_cntr, gh1_pq$, gh1_pd$, gh1_g$, gh1_gx, gh1_gy, gh1_xg, gh1_yg, gh1_pr,gh1_cdir, gh1_pq$len, gh1_g$len, gh1_eyesmode, gh1_cage_cntr, gh1_exit_cage_flg,SpriteIndex
; move_ghosts_part1    gh2_pr_cntr, gh2_pq$, gh2_pd$, gh2_g$, gh2_gx, gh2_gy, gh2_xg, gh2_yg, gh2_pr,gh2_cdir, gh2_pq$len, gh2_g$len, gh2_eyesmode, gh2_cage_cntr, gh2_exit_cage_flg,#01
;*****************************************************
defm                move_ghosts_part1
                    lda                 /1                  
                    sta                 pr_cntr             
                    lda                 /2                  
                    sta                 pq$                 
                    lda                 /2+1                
                    sta                 pq$+1               
                    lda                 /3                  
                    sta                 pd$                 
                    lda                 /4                  
                    sta                 g$                  
                    lda                 /4+1                
                    sta                 g$+1                
                    lda                 /4+2                
                    sta                 g$+2                
                    lda                 /5                  
                    sta                 gx                  
                    lda                 /6                  
                    sta                 gy                  
                    lda                 /7                  
                    sta                 xg                  
                    lda                 /8                  
                    sta                 yg                  
                    lda                 /9                  
                    sta                 ghost_pr            
                    lda                 /10                 
                    sta                 cdir                
                    lda                 /11                 
                    sta                 pq$len              
                    lda                 /12                 
                    sta                 g$len               
                    lda                 /13                 
                    sta                 g$eyesmode          
                    lda                 /14                 
                    sta                 g$cage_cntr         
                    lda                 /15                 
                    sta                 g$exit_cage_flg     
                    lda                 /16                 
                    sta                 curr_sprite         
                    jsr                 Check_Walls         



                    jsr                 MV_GHOST            

                    lda                 pr_cntr             
                    sta                 /1                  
                    lda                 pq$                 
                    sta                 /2                  
                    lda                 pq$+1               
                    sta                 /2+1                
                    lda                 pd$                 
                    sta                 /3                  
                    lda                 g$                  
                    sta                 /4                  
                    lda                 g$+1                
                    sta                 /4+1                
                    lda                 g$+2                
                    sta                 /4+2                
                    lda                 gx                  
                    sta                 /5                  
                    lda                 gy                  
                    sta                 /6                  
                    lda                 ghost_pr            
                    sta                 /9                  

                    lda                 cdir                
                    sta                 /10                 
                    lda                 pq$len              
                    sta                 /11                 
                    lda                 g$len               
                    sta                 /12                 
                                                            ; sta $428
                    endm
;*****************************************************
; Turn on Bluetime in event energizer or power pill
; is eaten.  That is determined prior to this macro call
; Usage:
; turn_on_btime       gh2_bluetime, gh2_eyesmode, Const_gh2_bt_DEF, gh2_bt_count, SpriteIndex,gh2_flashon
;*****************************************************
defm                turn_on_btime
                    lda                 /2                  ; Is eyesmode on?
                    cmp                 #1                  ; if so skip to bottom
                    beq                 @bottom             
                    lda                 #1                  ; Turn on
                    sta                 /1                  ; blue time
                                                            ;                                                            ;
                    ldx                 MAP_INDEX           ;
                    lda                 /3,x                ; Set Default Blue time
                    sta                 /4                  ; For current game level

                    lda                 #0                  
                    sta                 /6                  
                    sta                 flash_on            
                    sta                 flash_counter       
                    sta                 flash_counter2      
                    sta                 flash_white_blue    
                    ldy                 /5                  
                    ldx                 #4                  
                    jsr                 set_eye_color       
@bottom
                    endm
;*****************************************************
; Check if blue time is on
; and count how long it is on
;Usage:
;check_btime         gh2_bluetime, gh2_bt_count, Const_gh2_bt_DEF, Const_gh2_bt_DEF2, SpriteIndex,gh2_flashon
;*****************************************************
defm                check_btime
                    lda                 /1                  
                    cmp                 #1                  ; Is blue time on ?
                    bne                 @quit               ; No
                    ldx                 MAP_INDEX           
                    dec                 /2                  ; Decrease blue time Counter
                    lda                 /2                  
                    cmp                 /4,x                ; Fewer moves of blue time left
                    bne                 @ck_zero            ; if so then change ghost
                    lda                 #1                  ; Turn on Flash
                    sta                 /6                  

                    jmp                 @quit               
@ck_zero            cmp                 #0                  ; no more blue time left?
                    bne                 @quit               ; None left then quit
                    ldx                 MAP_INDEX           
                    lda                 /3,x                ; reset the blue time
                    sta                 /2                  ; counter,
                    lda                 #0                  
                    sta                 /1                  ; turn off blue time
                                                            ;lda                 #0                  ; Turn off flash
                    sta                 /6                  
                                                            ; jsr                 Spr_ghostcolor
                    ldy                 /5                  
                    jsr                 set_gh_color2       
@quit               nop
                    endm
;*****************************************************
;  Compare Ghost X and Y to Pac X and Y
;  If they are equal then check blue time
;  If blue time is on then Pac-Clone eats the ghost
;  (eating ghost turns them into eyes returning to cage
;  with high priority)
;  otherwise pac-clone should die.
;*****************************************************
;*************************************************************
;* Check of Pac-Clone is on top of a particular ghost
;* If this happens with blue time on the the ghost
;* should turn into eyesmode and return to the cage with high
;* priority
; Usage
;Collision          spritex, spritey, gh2_bluetime, gh2_eyesmode, gh2_xg, gh2_yg, gh2_pr, gh2_pr_cntr, spriteindex,SpriteBitpos
;*************************************************************
temp_val            byte                00
defm                Collision

                    lda                 /1                  ;
                    cmp                 $d000               ; Does Ghost X = Pac X  ?
                    bne                 @botabc             ; NO
                    lda                 /2                  
                    cmp                 $d001               ; Does Ghost Y = Pac Y ?
                    bne                 @botabc             ; No

                                                            ; Check if pac is on same side of map as ghost
                    lda                 $d010               ; test bit 1 against spritebitpos should be the same
                    and                 #%00000001          ; Test first bit - Pac on right side?
                    sta                 temp_val            ;

                    lda                 $d010               ;
                    and                 /10                 ; Check ghost bit - ghost on right side?

                    cmp                 #0                  ;
                    beq                 @_ha                ;
                    lda                 #1                  ;
@_ha                cmp                 temp_val        ;
                    bne                 @botabc             ;

                    lda                 /3                  ; Blue time on?
                    cmp                 #1                  ;
                    beq                 @eat_ghost          ; Yes
                    lda                 /4                  ; Eyes should not kill pac-clone
                    cmp                 #1                  
                    beq                 @botabc             
                    lda                 #1                  ; Pac-Clone dead now
                    sta                 DEATH_FLAG          
@botabc             jmp                 @bottom

@eat_ghost
                    lda                 /9                  
                    ldx                 #4                  ; Decimal position for the score
                    LDA                 /10                 ; Turn off pac during ready text printing
                    eor                 $d015               
                    sta                 $d015               

                    inc                 GHOSTS_EATEN        ; GHOST GOBBLED UP
                    lda                 GHOSTS_EATEN        
                    cmp                 #1                  
                    beq                 @BONUS1             
                    cmp                 #2                  
                    beq                 @BONUS2             
                    cmp                 #3                  
                    beq                 @BONUS3             
                    cmp                 #4                  
                    beq                 @BONUS4             
                    jmp                 @bottom             

@BONUS1             lda                 #1                  ; 100 points
                    jsr                 IncreaseScore       
                    ldx                 #SPR_ROOT+$1c       ; Display 100 point sprite
                    jsr                 display_bonus       
                    jmp                 @Score              

@BONUS2             lda                 #2                  ; 200 points
                    jsr                 IncreaseScore       
                    ldx                 #SPR_ROOT+$1d       ; Display 200 point sprite
                    jsr                 display_bonus       

                    jmp                 @Score              
@BONUS3             lda                 #4                  ; 400 points
                    jsr                 IncreaseScore       
                    ldx                 #SPR_ROOT+$1e       ; Display 400 point sprite
                    jsr                 display_bonus       

                    jmp                 @Score              
@BONUS4             lda                 #8                  ; 800 points
                    jsr                 IncreaseScore       
                    ldx                 #SPR_ROOT+$1f       ; Display 800 point sprite
                    jsr                 display_bonus       


                    ldx                 MAP_INDEX           
                    cpx                 #9                  ; Was only going to enable it in early levels
                    bcs                 @Score              


                    lda                 gh1_sp_boost_goal,x 
                    cmp                 #2                  
                    beq                 @boost2a            

                    lda                 #2                  
                    sta                 gh1_sp_boost_goal,x 
                    lda                 #0                  
                    sta                 gh1_sp_pos          
                    jsr                 print_boost         
                    jmp                 @Score              
@boost2a            lda                 _delay_5+1
                    cmp                 #30                 
                    beq                 @score              ;Already have both speed boosts?

                    lda                 #30                 
                    sta                 _delay_5+1          

                    jsr                 print_boost2        
@Score
                    LDA                 /10                 ; Turn off pac during ready text printing
                    eor                 $d015               
                    sta                 $d015               

                    lda                 #0                  ; Turn off bluetime
                    sta                 /3                  
                    lda                 #1                  ; Toggle Eyesmode
                    sta                 /4                  ;
                    sta                 g$eyesmode          

                    ldy                 /9                  
                    ldx                 /9                  
                    lda                 #0                  
                    sta                 gh2_flashon,y       

                    jsr                 set_eye_color       

                    lda                 Cage_Xpos           ; Tell eyes to move back
                    sta                 /5                  ; the ghost cage
                    lda                 Cage_Ypos           ;
                    sta                 /6                  ; at a high priority
                    lda                 #1                  ;HIGH_PR             ;Change priority of eyes to always move towards priority
                    sta                 /7                  
                    sta                 ghost_pr            
                    lda                 #0                  
                    sta                 /8                  ;Reset the Priority Counter to zero


@bottom             nop
                    endm

display_bonus

                    lda                 #1                  
                    sta                 gobble_on           
                    sei
                    stx                 $7f8                
                    jsr                 new_delay           
                    lda                 #0                  
                    sta                 gobble_on           
                    cli

                    rts

new_delay
                    ldx                 #$80                
                    jsr                 dly7                
                    rts
set_Nrgize_color
                    Energizer           Energizer1Lo,Energizer1Hi
                    Energizer           Energizer2Lo,Energizer2Hi
                    Energizer           Energizer3Lo,Energizer3Hi
                    Energizer           Energizer4Lo,Energizer4Hi
                    Energizer           Energizer5Lo,Energizer5Hi
                    rts

defm                Energizer

                                                            ;ACTUAL_MAP_LEVELS
                    ldy                 MAP_INDEX           
                                                            ;tay
                    lda                 ACTUAL_MAP_LEVELS,y 
                    tay
                    lda                 /1,y                
                    sta                 $fd                 
                    lda                 /2,y                
                    sta                 $fe                 

                    ldy                 #0                  
                    txa
                    sta                 ($fd),y             
@end
                    endm

set_eye_color
                    lda                 #$28                ; Ghost
                    sta                 $fb                 ; Sprite
                    lda                 #$d0                ; color
                    sta                 $fc                 ;
                    lda                 spreyecolor,x       
                    sta                 ($fb),y             
                    rts

set_gh_color2
                    lda                 #$d0                ;
                    sta                 $fc                 
                    lda                 #$28                
                    sta                 $fb                 
                    lda                 sprcolor,y          
                    sta                 ($fb),y             
                    rts

Spr_ghostcolor
                    lda                 #$28                ; Ghost
                    sta                 $fb                 ; Sprite
                    lda                 #$d0                ; color
                    sta                 $fc                 ;

                    ldy                 #4                  
color_lp            dey
                    lda                 sprcolor,y          
                    sta                 ($fb),y             ;
                    cpy                 #0                  
                    bne                 color_lp            
                    rts

set_flash_color
                    lda                 #$28                ; Ghost
                    sta                 $fb                 ; Sprite
                    lda                 #$d0                ; color
                    sta                 $fc                 ;


                    lda                 flash_white_blue    

                    cmp                 #1                  
                    beq                 _blue               
                    lda                 #0                  
                    sta                 flash_white_blue    
                    lda                 #1                  
                    jmp                 _white              
_blue               lda                 #14
_white              sta                 ($fb),y
                    rts
flash_white_blue    byte                00

;*****************************************************
;* Check to see if ghost is entering /exiting cage
;* If exiting then turn off eyes mode and change ghost char
;* And reset ghost priority
; usage:
;check_cage         gh2_eyesmode, gh2_exit_cage_flg, Const_gh2_DEF_PR, gh2_pr,gh2_bluetime,SpriteIndex
;*****************************************************
defm                check_cage
                    lda                 /1                  ; Eyes mode enabled?
                    cmp                 #0                  
                    beq                 @exit               ; If not exit
                    lda                 /5                  ; Bluetime enabled?
                    cmp                 #1                  ; If so exit
                    beq                 @exit               
                    lda                 gy                  
                    cmp                 Cage_Ypos           ; Is ghost in right vert position with cage
                    bne                 @exit               ; No? then exit
                    lda                 gx                  
                    cmp                 Cage_Xpos           ; Is ghost in right Horiz position with cage
                    bne                 @exit               ; No? then exit
                    lda                 #$0                 ; entering or exiting cage then reset flag
                    sta                 /2                  ; Reset the cage exit flag to 0
                    lda                 #0                  ; Ghost back in cage turn off eyes mode
                    sta                 /1                  
                                                            ; ldy                 /6
                    ldx                 /6                  
                    lda                 #0                  
                    sta                 g$eyesmode          
                    jsr                 Pick_Ghost_spr      
                    ldy                 /6                  
                    jsr                 set_gh_color2       
                                                            ;****fix - ghosts leaving cage had bad priority
                                                            ; Reset ghost priority when entering cage
                    ldx                 MAP_INDEX           
                    lda                 /3,x                
                    sta                 /4                  
@exit               nop
                    endm
;*****************************************************
; Once ghost is in cage, ensure it bounces back
; and forth at least two times before exiting
; thats what the g$cage_cntr var is for
; Usage:
; CageDrama           gh2_exit_cage_flg, gh2_bt_count, gh2_cage_cntr ,gh2_eyesmode, gh2_pr, gh2_yg, Const_gh2_DEF_PR, gh2_bt_DEF
;*****************************************************
defm                CageDrama
                    jsr                 cage_sides          ; Make sure ghosts move left and right within cage
                    lda                 g$cage_cntr         
                    cmp                 #3                  ; has ghost hit left side of cage 2 times?
                    bne                 @skp_bot            
                                                            ; Allow ghost to exit the cage
                    lda                 #1                  ; set the exit cage flag
                    sta                 /1                  ; allow ghost to exit the cage
                    ldx                 MAP_INDEX           
                    lda                 /8,x                
                    sta                 /2                  
                    lda                 #0                  ; Turn off Eyes mode
                    sta                 /4                  
                    lda                 #1                  
                    sta                 /6                  ; change the yg value so caged ghost will escape upwards
                    sta                 yg                  
                    ldx                 MAP_INDEX           
                    lda                 /7,x                ; reset to default priority ghost exiting cage
                    sta                 /5                  
                    sta                 ghost_pr            

                    lda                 #0                  
                    sta                 g$cage_cntr         ; reset cage counter to zero
@skp_bot            sta                 /3                  ; save acc back to cage counter
                    nop
                    endm



;*****************************************************
; This code tells the ghosts where
; Pac-clone is on the map but we dont want them
; To know where he is if bluetime is on, in fact
; this code tells the ghosts to run to the opposite
; side of the map relative to pac-clone if blue time is on
; updatexy            gh2_bluetime,gh2_eyesmode,gh2_xg,gh2_yg
;*****************************************************
defm                updatexy
                    lda                 /1                  ; Is bluetime on?
                    cmp                 #1                  ;
                    beq                 @thwart_gh          ; Yes then continue
                    lda                 /2                  ; Check if eyes mode is on
                    cmp                 #1                  ; if Yes then dont change xy destination points
                    beq                 @bot                
                    lda                 gh1_gx              ; Change Dest X and
                    sta                 /3                  
                    lda                 gh1_gy              ; Dest Y values of ghost
                    sta                 /4                  ; to follow Pac-clone
                    jmp                 @bot                
@thwart_gh          lda gh1_gx                              ; Blue time is on, so ghosts should be afraid
                    cmp                 Cage_Xpos           ; of Pac-Clone. Set the Dest X and Dest Y
                    bcs                 @skip               ; values of ghost to opposite side of map
                    lda                 #39                 ; relative to Pac-Clones current position
                    sta                 /3                  
                    jmp                 @ck_y               
@skip               lda #1                                  ; For example pac-clone is somewhere on right side of map
                    sta                 /3                  ; make ghosts move to left side setting Dest X
@ck_y               lda gh1_gy
                    cmp                 Cage_Ypos           ;Check if pac-clone is on top side of map
                    bcs                 @skip2              
                    lda                 #24                 ;if so set Dest Y to bottom part of map
                    sta                 /4                  
                    jmp                 @bot                
@skip2              lda #1                                  ;if not set Dest Y to top part of map
                    sta                 /4                  
@bot

                    endm
#endRegion
_draw_map6          drawmap_prep        MAP6_DATA,Map6color
                    jmp                 _done1              
_draw_map7
                    drawmap_prep        MAP7_DATA,Map7color 
                    jmp                 _done1              
;============================================================
;                     Main Program
;============================================================

*=$7700
                   ; jsr                 RESTORE_TOP_ROW       ; Initialize the score on the screen
                    lda                 #$18                ; Tell CPU
                    sta                 $d018               ; character set is $2000
                    jsr                 Init_Random         
                    jsr                 Pick_Map_to_Draw    
                    jsr                 Set_Interrupt       
                    jsr                 Prep_Level_One      ; Reset the Game Level and set score to zero
                                                            ; lda #0
                                                            ; sta    close_mouth
                    lda                 wall_dot            
                    sta                 SEARCH_CHAR+1       

                    lda                 #$31                
                    sta HISCORE_POS+2
main_prg_lp
                    lda                 #42                 
                    sta                 $63f                
                    sta                 $647                

                    lda                 DEATH_FLAG          
                    beq                 _alive              ; Yes Pacs alive
                    lda                 CHALLENGE_SCREEN    
                    cmp                 #0                  
                    beq                 .heded              
                    jsr                 DEATH_ANIMATION     ; Animate Pac on death
                    jsr                 RESET_LEVEL         ; Reset the level
.donew_level        jsr                 _levelup

                    lda                 #0                  
                    sta                 DEATH_FLAG          

                    jmp                 main_prg_lp         
.heded              jsr                 HE_DEAD             ; Nooo say it aint so...
                    jmp                 main_prg_lp         
_alive

;**** MOVE GHOSTS *****
                    Jsr                 Move_ALL_Sprites    

                    lda                 LEVEL_DONE          
                    beq                 main_prg_lp         
                    jmp                 .donew_level        
get_key

                    jsr                 $ffe4               ; Input a key from the keyboard
ck_pressed          cmp                 Const_DOWN          ; down - z pressed
                    beq                 Move_that_Dir       
                    cmp                 Const_Right         ; up - w pressed
                    beq                 Move_that_Dir       
                    cmp                 Const_LEFT          ; left - a pressed
                    beq                 Move_that_Dir       
                    cmp                 Const_Up            ; right - s pressed
                    beq                 Move_that_Dir       
                    cmp                 #$54                ; T - Pressed
                    bne                 _Chk_joystick       ;
                    lda                 #1                  
                    sta                 LEVEL_DONE          
                    rts
Move_that_Dir       sta                 userdirection


                    rts

.FirstInput         jsr $ffe4                              ; These next 6 lines
                    beq                 _was_jy_pressed     ; test the keyboard
                    jmp                 ck_pressed          ; and joystick for input
_was_jy_pressed     lda                 $dc00               ; between levels to start game
                    cmp                 #$7f                ; Nothing pressed on joystick
                    beq                 .FirstInput         ;

_Chk_joystick       lda                 $dc00               ; Input from Joystick Port 2
                    cmp                 #$7d                ; Down
                    bne                 _ck_jy_up           
                    lda                 Const_Down          
                    jmp                 Move_that_Dir       
_ck_jy_up           cmp                 #$7e                ; Up
                    bne                 _ck_jy_left         
                    lda                 Const_Up            
                    jmp                 Move_that_Dir       
_ck_jy_left         cmp                 #$7b                ; Left
                    bne                 _ck_jy_right        
                    lda                 Const_Left          
                    jmp                 Move_that_Dir       
_ck_jy_right        cmp                 #$77                ; Right
                    bne                 _no_jy_pressed      
                    lda                 Const_Right         
                    jmp                 Move_that_Dir       
_no_jy_pressed      rts

_draw_map4          drawmap_prep        MAP4_DATA           ;,Map4color
                    jmp                 _done1              
_draw_map5          drawmap_prep        MAP5_DATA           ;,Map5color
                    jmp                 _done1              

Pick_Map_to_Draw
                    ldy                 MAP_INDEX           
                    lda                 ACTUAL_MAP_LEVELS,y 
                    cmp                 #0                  
                    beq                 _draw_map1          
                    cmp                 #1                  
                    beq                 _draw_mapaa         
                    cmp                 #2                  
                    beq                 _draw_mapab         
                    cmp                 #3                  
                    beq                 _draw_mapac         
                    cmp                 #4                  
                    beq                 _draw_5             
                    cmp                 #5                  
                    beq                 _draw_mapae         
                    jmp                 _draw_mapaf         
                    jmp                 _done1              
_draw_mapaa         jmp                 _draw_map2
_draw_mapab         jmp                 _draw_map3
_draw_mapac         jmp                 _draw_map4
_draw_5             jmp                 _draw_map5
_draw_mapae         jmp                 _draw_map6
_draw_mapaf         jmp                 _draw_map7
_draw_map1          drawmap_prep        MAP1_DATA           ;,Map1color
                    jmp                 _done1              
_draw_map2          drawmap_prep        MAP2_DATA           ;,Map2color                   
                    jmp                 _done1              
_draw_map3          drawmap_prep        MAP3_DATA           ;,Map3color
                    jmp                 _done1              
_done1              jsr                 drawmap
                    rts

;*****************************************************
; Check Left side for non pac ghosts only
;*****************************************************
ck_leftside
                    check_sides         Const_Left,#$ff,#39,#9*8
;*****************************************************
; Check right side for non pac ghosts only
;*****************************************************
ck_rightside
                    check_sides         Const_Right,#40,#00,#00

defm                check_sides
                    lda                 cdir                
                    cmp                 /1                  ; Checking Left or right side?
                    bne                 @the_end            
                    lda                 gy                  

                    cmp                 Cage_Ypos           
                    bne                 @the_end            
                    lda                 gx                  

                    cmp                 /2                  ; Check for edge
                    beq                 @wp                 
                    jmp                 @the_end            
@wp                 lda                 /3                 ; Set gx to Opposite side of map
                    sta                 gx                  

                    ldy                 curr_sprite         ;
                    lda                 #$d0                ; Warp Sprite
                    sta                 $fc                 ;
                    lda                 sprxmap,y           ;
                    sta                 $fb                 ;
                    lda                 $d010               
                    eor                 sprmap2,y           ; Toggle sprite past 255 flag
                    sta                 $d010               
                    lda                 /4                  ; Set Sprite X to opposite side of map
                    ldy                 #0                  
                    sta                 ($fb),y             ;
@the_end            rts
endm
eat_fruit1
                    lda                 #1                  
                    sta                 .fr1+1              
                    ldy                 #4                  
                                                            ;sta                 .fr2+1
                    lda                 #SPR_ROOT+$1c       
                    jmp                 .finish_fruit       
scan_dots
pacs_alive          peekaxy             gh1_gx,gh1_gy       ; Did Pac-Clone just eat
                    cmp                 wall3__nrgzr        ; the energizer?
                    beq                 Energize            ; NO, then skip
                    cmp                 wall_dot            
                    beq                 dots                
                    cmp                 #Fruit1             
                    beq                 eat_fruit1          
                    cmp                 #Fruit2             
                    bne                 .checkfr3           
                    jmp                 eat_fruit2          
.checkfr3           cmp                 #Fruit3
                    bne                 .checkfr4           
                    jmp                 eat_fruit3          
.checkfr4           cmp                 #Fruit4
                    bne                 .checkfr5           
                    jmp                 eat_fruit4          
.checkfr5           cmp                 #Fruit5
                    bne                 .checkfr6           
                    jmp                 eat_fruit5          
.checkfr6           cmp                 #Fruit6
                    bne                 .checkfr7           
                    jmp                 eat_fruit6          
.checkfr7           cmp                 #Fruit7
                    bne                 .checkfr8           
                    jmp                 eat_fruit7          
.checkfr8           cmp                 #Fruit8
                    bne                 _done_scan          

                    jmp                 eat_fruit8          

dots
                    lda                 DOT_POINTS          ; 10 points
                    ldx                 DOT_DEC             ; 4th decimal pos
                    jsr                 IncreaseScore       ; Give me points

                    LDA                 #10                 
                    STA                 SB                  
                    jsr                 dly4                
                    LDA                 #0                  
                    STA                 SB                  

                    jsr                 EAT_DOTS            ; Eat dots
                    bne                 _done_scan          
                    jmp                 _done_scan          
Energize
                    lda                 #1                  ; 100 points
                    ldx                 #4                  ; 4th decimal pos
                    jsr                 IncreaseScore       ; Increase score
                    jsr                 EAT_DOTS            ; Eat dots
                    bne                 .nolevelup          
                    jmp                 _done_scan          
.nolevelup

                    lda                 DOTS_EATEN          ; These three lines fix bug where
                    cmp                 #0                  ; energizer carries over to
                    beq                 _done_scan          ; next level when eaten last

                    lda                 #0                  ; Reset the ghosts Eaten Counter
                    sta                 GHOSTS_EATEN        ; Used for score purposes

                    lda                 gh2_bluetime        
                    ora                 gh3_bluetime        
                    ora                 gh4_bluetime        
                    ora                 gh5_bluetime        
                    cmp                 #1                  
                    beq                 .skip_rev           
                    jsr                 reverse_gh_dirs     
.skip_rev           jsr                 BLUE_TIME

_done_scan          jsr                 space               ; Replace dots,fruit,or energizer with a space
                    rts


eat_fruit2
                    lda                 #2                  
                    sta                 .fr1+1              
                    ldy                 #4                  
                    lda                 #SPR_ROOT+$1d       
                    jmp                 .finish_fruit       
eat_fruit3

                    lda                 #4                  
                    sta                 .fr1+1              
                    ldy                 #4                  
                    lda                 #SPR_ROOT+$1e       
                    jmp                 .finish_fruit       

eat_fruit4
                    lda                 #8                  
                    sta                 .fr1+1              
                    ldy                 #4                  
                    lda                 #SPR_ROOT+$1f       
                    jmp                 .finish_fruit       
eat_fruit5
                    lda                 #16                 
                    sta                 .fr1+1              
                    ldy                 #4                  
                    lda                 #SPR_ROOT+$20       
                    jmp                 .finish_fruit       
eat_fruit6
                    lda                 #32                 
                    sta                 .fr1+1              
                    ldy                 #4                  
                    lda                 #SPR_ROOT+$21       
                    jmp                 .finish_fruit       
eat_fruit7
                    lda                 #4                  
                    sta                 .fr1+1              
                    ldy                 #3                  
                    lda                 #SPR_ROOT+$22       
                    jmp                 .finish_fruit       
eat_fruit8
                    lda                 #5                  
                    sta                 .fr1+1              
                    ldy                 #3                  
                    lda                 #SPR_ROOT+$23       
.finish_fruit       sta                 .fr3+1
                    jsr                 eat_fruit           
                    rts
eat_fruit
                    jsr                 space               
.fr1                lda                 #00                  ; Point Value
                    tya
                    tax
                    jsr                 IncreaseScore       ; Increase score
.fr3                ldx                 #00                  ; Display point sprite
                    jsr                 display_bonus       
                    lda                 CHALLENGE_SCREEN    
                    beq                 @dontdisplay        ; On non challenge screen, fruit it not counted toward total dots eaten
                    jsr                 EAT_DOTS            ; Eat dots
@dontdisplay        nop
                    rts

#region MAIN PROGRAM SUBS



Move_ALL_Sprites
_top                inc                 sprite_counter      ; Keep track of each sprite moving 8 pixels at a time

                    jsr                 Boost_Algorithm     
;_Normal_Flow

                    jsr                 Move_Sprite1        

                    jsr                 delay_5             
ifdef               MOVING_SPRITES

                    jsr                 Move_Sprite2        
                    jsr                 delay_5             
                    jsr                 Move_Sprite3        
                    jsr                 delay_5             
                    jsr                 Move_Sprite4        
                    jsr                 delay_5             
                    jsr                 Move_Sprite5        
                    jsr                 delay_5             
else
                    jsr                 delay_5             
                    jsr                 delay_5             
                    jsr                 delay_5             
                    jsr                 delay_5             
endif

                    lda                 DEATH_FLAG          ;If dead, dont continue moving sprites
                    cmp                 #1                  
                    bne                 _cont1              

_donefornow         rts
_cont1              jsr                 get_key

                    lda                 sprite_counter      
                    cmp                 #8                  
                    bne                 _back_to_top        
                    lda                 #0                  
                    sta                 sprite_counter      
                    rts
_back_to_top        jmp                 _top
Move_Sprite1



                    Move_Sprite         gh1_cdir,gh1_pd$,gh1_spctr,$d000,$d001,#%00000001,gh1_sp_pos

challenge_only      rts
;****************** CODE BELOW only EXECUTES DURING CHALLENGE 'Dragons wrath' SCREEN ***********
;                   This code sort of emulates Atari 2600 Adventure catacombs
                    lda                 $d010               ; Move challenge sprite
                    and                 #%00000001          ; copying position of gpac
                    beq                 _notpast255         ;including code for past
                    lda                 $d010               ; the 255 position toggle
                    ora                 #%00100000          ; set bit to past 255
                    jmp                 _sk_sv              ;
_notpast255         lda                 $d010               ;
                    and                 #%11011111          ; clear the 255 bit for
_sk_sv              sta                 $d010               ; sprite 6
                    lda                 $d000               ;
                    sta                 $d00a               ;
                    lda                 $d001               ;
                    sta                 $d00b               ;
                    rts
;*******************************************************************************
Move_Sprite2

                    Move_Sprite         gh2_cdir,gh2_pd$,gh2_spctr,$d002,$d003,#%00000010,gh2_sp_pos

                    rts
Move_Sprite3

                    Move_Sprite         gh3_cdir,gh3_pd$,gh3_spctr,$d004,$d005,#%00000100,gh3_sp_pos

                    rts
Move_Sprite4

                    Move_Sprite         gh4_cdir,gh4_pd$,gh4_spctr,$d006,$d007,#%00001000,gh4_sp_pos

                    rts
Move_Sprite5

                    Move_Sprite         gh5_cdir,gh5_pd$,gh5_spctr,$d008,$d009,#%00010000,gh5_sp_pos

                    rts

;*************************************************************
; Each sprite has a counter, once a certain number is reached
; give the ghost a boost in speed, this value is determined
; by the current level played.
;*************************************************************
Boost_Algorithm
                    lda                 gh1_sp_pos          
                    LDY                 MAP_INDEX           
                    cmp                 gh1_sp_boost_goal,y 
                    bne                 _check2             
                    jsr                 Move_Sprite1        

                    lda                 #0                  
                    sta                 gh1_sp_pos          

_check2
                    lda                 gh2_eyesmode        
                    cmp                 #1                  
                    beq                 _fasteyes1          
                    lda                 gh2_sp_pos          
                    LDY                 MAP_INDEX           
                    cmp                 gh2_sp_boost_goal,y 
                    bcc                 _check3             

                    jsr                 Move_Sprite2        
                    jmp                 _reset1             

_fasteyes1
                    jsr                 Move_Sprite2        

_reset1             lda                 #0
                    sta                 gh2_sp_pos          

_check3             lda                 gh3_eyesmode
                    cmp                 #1                  
                    beq                 _fasteyes2          

                    lda                 gh3_sp_pos          
                    LDY                 MAP_INDEX           
                    cmp                 gh3_sp_boost_goal,y 
                    bcc                 _check4             
                    jsr                 Move_Sprite3        
                    jmp                 _reset2             
_fasteyes2          jsr                 Move_Sprite3
                    jsr                 Move_Sprite3        

_reset2             lda                 #0
                    sta                 gh3_sp_pos          

_check4             lda                 gh4_eyesmode
                    cmp                 #1                  
                    beq                 _fasteyes3          

                    lda                 gh4_sp_pos          
                    LDY                 MAP_INDEX           
                    cmp                 gh4_sp_boost_goal,y 
                    bcc                 _check5             
                    jsr                 Move_Sprite4        
                    jmp                 _reset3             
_fasteyes3          jsr                 Move_Sprite4
                    jsr                 Move_Sprite4        

_reset3             lda                 #0
                    sta                 gh4_sp_pos          
_check5             lda                 gh5_eyesmode
                    cmp                 #1                  
                    beq                 _fasteyes4          

                    lda                 gh5_sp_pos          
                    cmp                 gh5_sp_boost_goal   
                    bcc                 _done               

                    jsr                 Move_Sprite5        
                    jmp                 _reset4             
_fasteyes4          jsr                 Move_Sprite5
                    jsr                 Move_Sprite5        
_reset4             lda                 #0
                    sta                 gh5_sp_pos          
_done               rts
;*************************************************************

;*************************************************************
; Turn on blue time for all 4 ghosts
; Unless eyes mode is activated
;*************************************************************
BLUE_TIME
                    turn_on_btime       gh2_bluetime,gh2_eyesmode,Const_gh2_bt_DEF,gh2_bt_count,#0,gh2_flashon; Turn on blue time
                    turn_on_btime       gh3_bluetime,gh3_eyesmode,Const_gh3_bt_DEF,gh3_bt_count,#1,gh3_flashon; want to turn it on
                    turn_on_btime       gh4_bluetime,gh4_eyesmode,Const_gh4_bt_DEF,gh4_bt_count,#2,gh4_flashon; unless eyemode
                    turn_on_btime       gh5_bluetime,gh5_eyesmode,Const_gh5_bt_DEF,gh5_bt_count,#3,gh5_flashon; is activated
                    rts
;*************************************************************
; A collision occurs when a ghost runs into pac-clone
; One of two things should happen
;
; 1) Bluetime is enabled
; 2) Pac-Clone dies
;*************************************************************

Collisions
                    Collision           $d002,$d003,gh2_bluetime,gh2_eyesmode,gh2_xg,gh2_yg,gh2_pr,gh2_pr_cntr,#0,#%0000010
                    Collision           $d004,$d005,gh3_bluetime,gh3_eyesmode,gh3_xg,gh3_yg,gh3_pr,gh3_pr_cntr,#1,#%0000100
                    Collision           $d006,$d007,gh4_bluetime,gh4_eyesmode,gh4_xg,gh4_yg,gh4_pr,gh4_pr_cntr,#2,#%0001000
                    Collision           $d008,$d009,gh5_bluetime,gh5_eyesmode,gh5_xg,gh5_yg,gh5_pr,gh5_pr_cntr,#3,#%0010000
                    rts
;*************************************************************
; Move_Sprite
;Usage:
;                   Move_Sprite         gh1_cdir, gh1_pd$, gh1_spctr, $d000, $d001, #%0000001, gh1_sp_pos
;*************************************************************
defm                Move_Sprite
                    lda                 /6                  
                    cmp                 #1                  
                    bne                 @_skipfew           

                    lda                 /1                  
                    cmp                 /2                  
                    bne                 @_gh1               
                    jmp                 @_skipfew           

@_gh1
@glennx
                    lda                 #1                  
                    sta                 gobble_on           
                    lda                 #0                  ; Open mouth when moving, fixes
                    sta                 close_mouth         ; issues where pac starts out pointing up

@_gh2               jmp @Gh1

@_skipfew           inc                 /3
                    inc                 /7                  

@mv_Spritesub       lda                 /1
                    cmp                 Const_LEFT          
                    beq                 @sp_left            
                    cmp                 Const_Right         
                    beq                 @sp_right           
                    cmp                 Const_UP            
                    beq                 @sp_up              
                    cmp                 Const_DOWN          
                    beq                 @sp_down            
                    jmp                 @_lt                
@sp_up
                    dec                 /5                  
                    jmp                 @_lt                
@sp_down
                    inc                 /5                  
                    jmp                 @_lt                
@sp_right
                    inc                 /4                  
                    lda                 /4                  
                    cmp                 #00                 
                    bne                 @_rt                
                    lda                 $d010               
                    eor                 /6                  
                    sta                 $d010               
@_rt                jmp @_lt
@sp_left            dec                 /4
                    lda                 /4                  
                    cmp                 #$FF                
                    bne                 @_lt                
                    lda                 $d010               
                    eor                 /6                  
                    sta                 $d010               
@_lt
                    lda                 /3                  
                    cmp                 #8                  
                    bne                 @exit_sprite        

                    lda                 #0                  
                    sta                 /3                  
                    lda                 /6                  
                    cmp                 #%0000001           ;Pac-Clone
                    beq                 @Gh1                
                    cmp                 #%0000010           ;Ghost 1
                    beq                 @Gh2                
                    cmp                 #%0000100           ;Ghost 2
                    beq                 @Gh3                
                    cmp                 #%0001000           ;Ghost 3
                    beq                 @Gh4                
                    cmp                 #%0010000           ;Ghost 4
                    beq                 @Gh5                

@Gh1
                    jsr                 Collisions          
                    jsr                 mv_Ghost1           
                    jmp                 @exit_sprite        
@Gh2                jsr                 Collisions
                    jsr                 mv_Ghost2           
                    jmp                 @exit_sprite        
@Gh3                jsr                 Collisions
                    jsr                 mv_Ghost3           
                    jmp                 @exit_sprite        
@Gh4                jsr                 Collisions
                    jsr                 mv_Ghost4           
                    jmp                 @exit_sprite        
@Gh5
                    jsr                 Collisions          
                    jsr                 mv_Ghost5           
@exit_sprite        jsr                 Collisions
                    endm

mv_Ghost1
                    jsr                 scan_dots           
                    lda                 ATTRACT_MODE        ; These two lines control if Attract_mode is 1 then
                    bne                 .attracton          ; Move pac-clone around randomly

                    lda                 #1                  
                    sta                 ispacman            

                    lda                 #0                  
                    sta                 gh1_pd$             
                    jmp                 .skipatt            
.attracton          lda                 #0
                    sta                 gobble_on           

.skipatt            move_ghosts_part1   gh1_pr_cntr,gh1_pq$,gh1_pd$,gh1_g$,gh1_gx,gh1_gy,gh1_xg,gh1_yg,gh1_pr,gh1_cdir,gh1_pq$len,gh1_g$len,gh1_eyesmode,gh1_cage_cntr,gh1_exit_cage_flg,#00
                                                            ;***********************************************
                                                            ;** Make ghosts follow Pac-CLone
                    updatexy            gh2_bluetime,gh2_eyesmode,gh2_xg,gh2_yg
                    updatexy            gh3_bluetime,gh3_eyesmode,gh3_xg,gh3_yg
                    updatexy            gh4_bluetime,gh4_eyesmode,gh4_xg,gh4_yg
                    updatexy            gh5_bluetime,gh5_eyesmode,gh5_xg,gh5_yg

                    lda                 #0                  
                    sta                 ispacman            
                    rts
mv_Ghost2
                    move_ghosts_part1   gh2_pr_cntr,gh2_pq$,gh2_pd$,gh2_g$,gh2_gx,gh2_gy,gh2_xg,gh2_yg,gh2_pr,gh2_cdir,gh2_pq$len,gh2_g$len,gh2_eyesmode,gh2_cage_cntr,gh2_exit_cage_flg,#01
                    check_cage          gh2_eyesmode,gh2_exit_cage_flg,Const_gh2_DEF_PR,gh2_pr,gh2_bluetime,#0
                    check_btime         gh2_bluetime,gh2_bt_count,Const_gh2_bt_DEF,Const_gh2_bt_DEF2,#0,gh2_flashon
                    CageDrama           gh2_exit_cage_flg,gh2_bt_count,gh2_cage_cntr,gh2_eyesmode,gh2_pr,gh2_yg,Const_gh2_DEF_PR,Const_gh3_bt_DEF
                    jsr                 Count_GH_Moves      
                    rts
mv_Ghost3
                    move_ghosts_part1   gh3_pr_cntr,gh3_pq$,gh3_pd$,gh3_g$,gh3_gx,gh3_gy,gh3_xg,gh3_yg,gh3_pr,gh3_cdir,gh3_pq$len,gh3_g$len,gh3_eyesmode,gh3_cage_cntr,gh3_exit_cage_flg,#02
                    check_cage          gh3_eyesmode,gh3_exit_cage_flg,Const_gh3_DEF_PR,gh3_pr,gh3_bluetime,#1
                    check_btime         gh3_bluetime,gh3_bt_count,Const_gh3_bt_DEF,Const_gh3_bt_DEF2,#1,gh3_flashon
                    CageDrama           gh3_exit_cage_flg,gh3_bt_count,gh3_cage_cntr,gh3_eyesmode,gh3_pr,gh3_yg,Const_gh3_DEF_PR,Const_gh3_bt_DEF
                    rts
mv_Ghost4
                    move_ghosts_part1   gh4_pr_cntr,gh4_pq$,gh4_pd$,gh4_g$,gh4_gx,gh4_gy,gh4_xg,gh4_yg,gh4_pr,gh4_cdir,gh4_pq$len,gh4_g$len,gh4_eyesmode,gh4_cage_cntr,gh4_exit_cage_flg,#03
                    check_cage          gh4_eyesmode,gh4_exit_cage_flg,Const_gh4_DEF_PR,gh4_pr,gh4_bluetime,#2
                    check_btime         gh4_bluetime,gh4_bt_count,Const_gh4_bt_DEF,Const_gh4_bt_DEF2,#2,gh4_flashon
                    CageDrama           gh4_exit_cage_flg,gh4_bt_count,gh4_cage_cntr,gh4_eyesmode,gh4_pr,gh4_yg,Const_gh4_DEF_PR,Const_gh4_bt_DEF
                    rts
mv_Ghost5
                    move_ghosts_part1   gh5_pr_cntr,gh5_pq$,gh5_pd$,gh5_g$,gh5_gx,gh5_gy,gh5_xg,gh5_yg,gh5_pr,gh5_cdir,gh5_pq$len,gh5_g$len,gh5_eyesmode,gh5_cage_cntr,gh5_exit_cage_flg,#04
                    check_cage          gh5_eyesmode,gh5_exit_cage_flg,Const_gh5_DEF_PR,gh5_pr,gh5_bluetime,#3
                    check_btime         gh5_bluetime,gh5_bt_count,Const_gh5_bt_DEF,Const_gh5_bt_DEF2,#3,gh5_flashon
                    CageDrama           gh5_exit_cage_flg,gh5_bt_count,gh5_cage_cntr,gh5_eyesmode,gh5_pr,gh5_yg,Const_gh5_DEF_PR,Const_gh5_bt_DEF
                    rts

swap_direction
                    cmp                 Const_Up            
                    beq                 .ck_up              
                    cmp                 Const_Down          
                    beq                 .ck_down            
                    cmp                 Const_Left          
                    beq                 .ck_left            
.right              lda                 Const_Left ; Default right so swap to left
                    rts
.ck_up              lda                 Const_Down
                    rts
.ck_down            lda                 Const_Up
                    rts
.ck_left            lda                 Const_Right
                    rts

reverse_gh_dirs                                             ; Reverse all ghosts EXCEPT when Eyes mode is activated!
                    lda                 gh2_eyesmode        
                    bne                 .check_gh3          
                    lda                 gh2_pd$             
                    jsr                 swap_direction      
                    sta                 gh2_pd$             

.check_gh3          lda                 gh3_eyesmode
                    bne                 .check_gh4          

                    lda                 gh3_pd$             
                    jsr                 swap_direction      
                    sta                 gh3_pd$             

.check_gh4          lda                 gh4_eyesmode
                    bne                 .check_gh5          

                    lda                 gh4_pd$             
                    jsr                 swap_direction      
                    sta                 gh4_pd$             

.check_gh5          lda                 gh5_eyesmode
                    bne                 .done_exit          

                    lda                 gh5_pd$             
                    jsr                 swap_direction      
                    sta                 gh5_pd$             
.done_exit          rts


; Change dot colors based on a certain number of moves
; Dots will change to red then to green
;
fruit_on_levels     byte                00,01,00,02,03,04,00,05,06,07,00,08 ; records the order of fruits,00-indicates challenge map

Fruit_Levels        byte                fruit1,fruit2,fruit3,fruit4,fruit5,fruit6,fruit7,fruit8
Count_GH_Moves

                    inc                 rnd_move_counter    
                    lda                 rnd_move_counter    
                    cmp                 #50                 
                    bne                 _cont_gh_move       
                    lda                 #0                  
                    sta                 rnd_move_counter    

                    lda                 CHALLENGE_SCREEN    ; No fruit on challenge screens
                    bne                 _skip_placing_fr    

                    inc                 Fruit_Map_Ctr       
                    lda                 Fruit_Map_Ctr       
                    cmp                 #2                  ; Place first Fruit
                    beq                 _place_fruit        
                    cmp                 #4                  ; Remove first Fruit
                    beq                 _erase_fruit        
                    cmp                 #6                  ; Place 2nd Fruit
                    beq                 _place_fruit        
                    cmp                 #8                  ; Remove 2nd Fruit
                    beq                 _erase_fruit        
                    jmp                 _skip_placing_fr    
_erase_fruit        lda                 #$20                ; Space
                    sta                 FRUIT_ON_SCREEN     
                    jmp                 _skip_placing_fr    

_place_fruit        lda                 CURRENT_FRUIT
                    sta                 FRUIT_ON_SCREEN     
                    lda                 CURR_FRUIT_COLOR    
                    sta                 FRUIT_CLR_SCREEN    
_skip_placing_fr
                    jsr                 reverse_gh_dirs     

_cont_gh_move       inc                 TOTAL_GH_MOVES
                    lda                 TOTAL_GH_MOVES      
                    cmp                 #0                  
                    bne                 _check_moves        
                    inc                 TOTAL_GH_FLAG       
_check_moves        lda                 TOTAL_GH_FLAG
                    cmp                 #1                  
                    bne                 __check2            
                    lda                 TOTAL_GH_MOVES      
                    cmp                 #200                
                    beq                 _First_col_chg      
                    rts
__check2            cmp                 #2
                    bne                 _end_count          
                    lda                 TOTAL_GH_MOVES      
                    cmp                 #100                
                    beq                 _sec_col_chg        

_end_count          rts
_First_col_chg
                    lda                 #4                  
                    sta                 SEARCH_COLOR        
                    lda                 #6                  ;Make just wall dots change color
                    sta                 _self_mod1+1        ;

                    jsr                 Change_Map_Color    
                    lda                 #5                  ; 5 points
                    sta                 DOT_POINTS          
                    lda                 #6                  ; 6th decimal pos
                    sta                 DOT_DEC             
                    rts
_sec_col_chg
                    lda                 #5                  
                    sta                 SEARCH_COLOR        

                    jsr                 Change_Map_Color    
                    lda                 #1                  ; 1 point
                    sta                 DOT_POINTS          
                    lda                 #6                  ; 6th decimal pos
                    sta                 DOT_DEC             

                    rts
;============================================================
;                          Check for Walls
; This section of code checks up/down/left/right for walls
; in order to determine the direction that can be travelled in.
; it sets up a string g$ that looks something like this:
; g$="udl" - Means ghost can move up/down/left
; it aslo sets up priority direction that ghost can move in.
; that string looks something like this:
; pq$="dl" (subset of g$) - means down/left are pr directions which
; will move the ghost closer to the target
;============================================================
Check_Walls
                    lda                 #0                  ; Reset
                    sta                 g$                  ; all
                    sta                 g$+1                ; g$ values
                    sta                 g$+2                
                    sta                 pq$                 ; Reset all
                    sta                 pq$+1               ; pq$ values
                    sta                 g$len               
                    sta                 pq$len              
                    ldy                 gy                  ; Set up
                    dey
                    sty                 gyminus1            ; gy - 1
                    ldy                 gy                  
                    iny
                    sty                 gyplus1             ; gy + 1
                    wall_chk            gx,gyminus1,Const_DOWN,Const_UP,#1; Check wall directly above ghost

                    wall_chk            gx,gyplus1,Const_UP,Const_DOWN,#0; Check wall directly below ghost

                    ldy                 gx                  ; Set up
                    dey

@skp                sty                 gxminus1            ; gx - 1
                    ldy                 gx                  
                    iny
                    sty                 gxplus1             ; gx + 1
                    wall_chk            gxminus1,gy,Const_RIGHT,Const_LEFT,#2; Check wall to left of ghost

                    wall_chk            gxplus1,gy,Const_LEFT,Const_RIGHT,#3; Check wall to right of ghost

                    rts
;*****************************************************
; scan the possible directions pac-clone can move
; if there is a match with the accumulater than
; return 'beq' otherwise return 'bne'
;*****************************************************
Can_Move_This_Dir?
                    ldx                 #0                  ; Check if pac-clone hits a wall_dot
loop                cmp                 g$,x                ; needed for sprite mouth to stay open on hit
                    beq                 ext_sub             
                    inx
                    cpx                 g$len               
                    bne                 loop                
                    ldx                 #1                  ;These two lines are here because
                    cpx                 #2                  ;need to set the BNE flag to return 'bne'
ext_sub             rts
;*****************************************************
;This sub is heart of the entire program
;It is responsible for actually moving all objects
;on the map
;*****************************************************
MV_GHOST
                    lda                 ispacman            
                    cmp                 #1                  ; Have to check if this is Pac-clone
                    bne                 notpacman           ; if so then do not pick a dir of travel

                    lda                 userdirection       ; Check can pclone move in user direction
                    jsr                 Can_Move_This_Dir?  ; Can the we travel in the selected dir?
                    beq                 match2              ;
                    lda                 cdir                ; This keeps pacclone moving in current dir of travel
                    jsr                 Can_Move_This_Dir?  ;Check can pclone move in current dir of travel
                    beq                 match2              ; Match means 'yes'                                                            ; No match mean return
                    rts
match2
                    sta                 g$                  ; Store the requested
                    sta                 cdir                ;
                    ldy                 #0                  ;
                    sty                 g$len               ;
                    tax
                    tya
                    pha
                    txa                                     ; push direction
                    jmp                 ck_1                ;
notpacman
                    lda                 g$eyesmode          ; the entrance to ghost cage
                    cmp                 #1                  ;
                    bne                 not_cage            ; make sure eyes mode is on
                    peekaxy             gx,gyplus1          ; This code here will force
                    cmp                 wall_cge            ; ghost eyes to move down
                    bne                 not_cage            ; if directly over

                    lda                 #0                  
                    pha
                    lda                 Const_DOWN          ; Load Down Value
                    sta                 cdir                ;fixes bug where sprite ghost does not move into cage
                    sta                 g$                  ;This sta fixes 2nd bug where ghost does not move into cage when no wall directly above cage entrance

                    inc                 gy                  ; force ghost into ghost cage
                    ldx                 #1                  
                    jmp                 .gskip              

;***
; Pick a direction of travel either a priority dir
; Or a random dir based on possible choices of dir
;*****************************************************
not_cage

                    inc                 pr_cntr             ; Increment priority counter
                    lda                 pr_cntr             ; Do we have a match with the
                    cmp                 ghost_pr            ; Current Priority?
                    bne                 random              ; No? then move randomly
                                                            ; Yes? Then move in priority dir
_zzzz               lda                 #0                  ; Reset the Priority counter
                    sta                 pr_cntr             
                    lda                 pq$                 ; Load priority direction
                    cmp                 #0                  ; Make sure there is one
                    beq                 random              
                    lda                 pq$                 ; Make the ghost
                    sta                 g$                  ; Move randomly in the direction

                    lda                 pq$+1               ; of priority
                    sta                 g$+1                

                    lda                 pq$len              
                    sta                 g$len               

random                                                      ; Randomly move ghost
                    jsr                 RAND                ; in one of the possible
                    pha                                     ; directions of travel
                    tax                                     ; push direction
                    lda                 g$,x                ;
                    sta                 cdir                ;


;*****************************************************
;These lines are executed by ghosts (and pac-clone when in attract mode)
                    jsr                 change_gx_gy        ; Change gx, gy based on current direction of travel

.gskip              lda                 ATTRACT_MODE        ; (these 4 lines set/fix direction sprite of pac-clone sprite during attract_mode)
                    beq                 .xkip1              ; skip if attract mode is off
                    lda                 curr_sprite         ; 0 = Pac-clone
                    beq                 ck_1                ; SO if attract_mode=1 and curr_sprite is pac_clone then fix direction of sprite to be correct random direction
.xkip1              jsr                 Pick_Ghost_Spr      ; skip the pick_ghost_spr
                    jmp                 .tobot              

;**************************************************
;These lines are executed by Pac-Clone
ck_1                jsr                 change_gx_gy        ; Change gx, gy based on current direction of travel
                    txa                                     ; X should be 0-3 for up,down,left,right
                    jsr                 Setup_Pacdir        ; Orient Pac-Clone sprite to proper direction
                    jsr                 ck_rightside        
.pskip              lda                 #0                  ; Turn gobble on
                    sta                 gobble_on           
.tobot              pla                                     ; Pull Direction down
                    tax
                    lda                 g$,x                ;
                    sta                 pd$                 
                                                            ;  jsr                 Check_Walls         ; get new g$len, g$
done                rts

change_gx_gy
.xck_1              cmp                 Const_UP            ; UP
                    bne                 .xck_2              
                    dec                 gy                  ; Decrease Y value
                    ldx                 #0                  
                    rts
.xck_2              cmp                 Const_DOWN          ; DOWN
                    bne                 .xck_3              
                    inc                 gy                  ; Increase Y value
                    ldx                 #1                  
                    rts
.xck_3              cmp                 Const_LEFT          ; LEFT
                    bne                 .xck_4              
                    dec                 gx                  ; Decrease X value

                    ldx                 #2                  
                    jsr                 ck_leftside         
                    rts
.xck_4              cmp                 Const_RIGHT         ; RIGHT
                    bne                 .done               
                    inc                 gx                  ; Increase X value
                    ldx                 #3                  
                    jsr                 ck_rightside        
.done               rts

; Created this macro to make program code above more readable
Setup_Pacdir

                    cmp                 #0                  
                    beq                 .xup                
                    cmp                 #1                  
                    beq                 .xdown              
                    cmp                 #2                  
                    beq                 .xleft              
                    cmp                 #3                  
                    beq                 .xright             

                    rts

.xup

                    lda                 spr_up              
                    sta                 int_sprite_byte     
                    lda                 spr_up+1            
                    sta                 int_sprite_byte+1   
                    lda                 spr_up+2            
                    sta                 int_sprite_byte+2   
                    rts

.xdown
                    lda                 spr_down            
                    sta                 int_sprite_byte     
                    lda                 spr_down+1          
                    sta                 int_sprite_byte+1   
                    lda                 spr_down+2          
                    sta                 int_sprite_byte+2   
                    rts

.xleft

                    lda                 spr_left            
                    sta                 int_sprite_byte     
                    lda                 spr_left+1          
                    sta                 int_sprite_byte+1   
                    lda                 spr_left+2          
                    sta                 int_sprite_byte+2   
                    rts

.xright
                    lda                 spr_right           
                    sta                 int_sprite_byte     
                    lda                 spr_right+1         
                    sta                 int_sprite_byte+1   
                    lda                 spr_right+2         
                    sta                 int_sprite_byte+2   
                    rts

Pick_Ghost_spr                                              ;eyeball ghost direction

                    ldy                 curr_sprite         
                    lda                 #$07                
                    sta                 $fc                 
                    lda                 #$f8                
                    sta                 $fb                 
                    lda                 g$eyesmode          
                    cmp                 #1                  
                    beq                 .xover              
                    lda                 sp_gh_dir,x         
                    jmp                 .xover2             
.xover              lda                 sp_eye_dir,x
.xover2             sta                 ($fb),y

done_2a             rts

mpart1              byte                00,00


defm                drawmap_prep                            ; Pass down which map to load
                    ldy                 #>/1                
                    sty                 _mpart1+2           
                    iny
                    sty                 _mpart2+2           
                    iny
                    sty                 _mpart3+2           
                    iny
                    sty                 _mpart4+2           
                    lda                 #</1                
                    sta                 _mpart1+1           
                    sta                 _mpart2+1           
                    sta                 _mpart3+1           
                    sta                 _mpart4+1           
endm

drawmap
                    ldx                 MAP_INDEX           
                    lda                 MAP_BG_COLOR,x      
                    sta                 53281               
                    lda                 MAP_BD_COLOR,x      
                    sta                 53280               
                    

                    ldy                 #0                  
_mpart1             lda                 $0000,y             ;Self modifying code part1
                    sta                 $400,y              
                    jsr                 char_color          
                    sta                 $d800,y             
                    iny
                    bne                 _mpart1             

_mpart2             lda                 $0000,y
                    sta                 $500,y              
                    jsr                 char_color          
                    sta                 $d900,y             
                    iny
                    bne                 _mpart2             

_mpart3             lda                 $0002,y
                    sta                 $600,y              
                    jsr                 char_color          
                    sta                 $da00,y             
                    iny
                    bne                 _mpart3             
;
_mpart4             lda                 $0003,y
                    sta                 $700,y              
                    jsr                 char_color          
                    sta                 $db00,y             
                    iny
                    cpy                 #$e7                
                    bne                 _mpart4             
                    jsr                 Blank_toprow        ; CHange score color
                    jsr                 RESTORE_TOP_ROW     ; top line
                    
                    rts

.color_wht          lda                 #1 ; White - Cage exit color
                    rts
.color_cya          lda                 #3 ; CYAN - Wall color map 1
                    rts
.color_dgr          lda                 #5 ; Dark Green - Maze Craze green walls
                    rts
.color_dbl          lda                 #6 ; Dark Blue - Maze Craze border color
                    rts
.color_yel          lda                 #7 ; Yellow - dot color
                    rts
.color_blk          lda                 #0 ; Black - used on map 3
                    rts
.color_red          lda                 #2 ; RED - Fruit 3 color
                    rts

char_color          cmp                 Wall_dot
                    beq                 .color_yel            
                    cmp                 #227                ; Map 1 Cyan color
                    beq                 .color_cya            
                    cmp                 wall_cge            ; All Non chlnge screen maps
                    beq                 .color_lgr             
                    cmp                 #222                ; Map 3
                    beq                 .color_blk  
                    cmp                 #fruit1                                  
                    beq                 .color_wht             
                    cmp                 #fruit2                                  
                    beq                 .color_pnk
                    cmp                 #fruit3                                  
                    beq                 .color_red             
                    cmp                 #fruit4                                  
                    beq                 .color_wht             
                    cmp                 #fruit5                                  
                    beq                 .color_dgr
                    cmp                 #fruit6                                  
                    beq                 .color_pnk            
                    cmp                 #fruit7                                  
                    beq                 .color_lbl            
                    cmp                 #fruit8                                  
                    beq                 .color_cya                                
                    
                    cmp                 #233                ; Maze Craze border color dark blue
                    beq                 .color_dbl            
                    cmp                 #230                ; Maze craze white walls
                    beq                 .color_wht
                    cmp                 #232                ; Chaos Fruit Grab Green left side
                    beq                 .color_dgr            
             
                    cmp                 #252                ; Carpels Tunnel
                    beq                 .color_pnk            
                    cmp                 #253                ; Carpels Tunnel
                    beq                 .color_yel            
                    cmp                 #254                ; Carpels Tunnel
                    beq                 .color_wht          
                    cmp                 #255                ; Carpels Tunnel
                    beq                 .color_lgray           
                    cmp                 #156                ; Carpels Tunnel
                    beq                 .color_pnk            
                    cmp                 #157                ; Carpels Tunnel
                    beq                 .color_red             
                    cmp                 #158                ; Carpels Tunnel
                    beq                 .color_wht             
                    cmp                 #159                ; Carpels Tunnel
                    beq                 .color_lgray             
                    cmp                 #194                ; Carpels Tunnel
                    beq                 .color_pnk           
                    cmp                 #195                ; Carpels Tunnel
                    beq                 .color_yel            
                    cmp                 #196                ; Carpels Tunnel
                    beq                 .color_wht             
                    cmp                 #197                ; Carpels Tunnel
                    beq                 .color_lgray            
                    cmp                 #251                ; Dragons Wrath GPAC color
                    beq                 .color_blk            
                    cmp                 #58                 ; Dragons Wrath colon
                    beq                 .color_yel             
                    cmp                 #226                ; Map 4
                    beq                 .color_dgray
.SM_CH_Dflt         lda                 #2                  ; A few maps change the default color
                    rts

.color_pnk          lda                 #10 ; Pink
                    rts
.color_dgray        lda                 #11 ; Dark grey used on map 4
                    rts
.color_lgr          lda                 #13 ; Light Green - Cage wall color
                    rts
.color_lbl          lda                 #14 ; Light Blue - Fruit 7 color
                    rts
.color_lgray        lda                 #15 ; Light Grey - Carpels Tunnel
                    rts
;============================================================
Init_Random
                    LDA                 #$FF                ; maximum frequency value
                    STA                 $D40E               ; voice 3 frequency low byte
                    STA                 $D40F               ; voice 3 frequency high byte
                    LDA                 #$80                ; noise waveform, gate bit off
                    STA                 $D412               ; voice 3 control register
                    rts
RAND                lda                 g$len               ; These two lines
                    beq                 dont_crash          ; prevent program crash
                    LDA                 $D41B               ; get random value from 0-255
                    CMP                 g$len               ; narrow random result down
                                                            ; to between zero - g$len
                    BCC                 dont_crash          ; ~ to 0-3
                    jmp                 RAND                
dont_crash          rts
;============================================================
;*************************************************************
; This sub adapted from
; http://www.retroremakes.com/remaketalk/index.php?p=/discussion/2391/how-to-write-a-c64-game-in-several-steps/p1
; Thank you!!
;
;increases score by A
;note that the score is only shown; not held in a variable
;
; Example score: 6543210
; Loading X as 0 gives us the first digit '6'
; Loading X as 1 give us the second digit '5' and so on
; To add 500 to the score load X with #4 and load Acc with #5, call sub
; To add 3000 to score load X with #3 and load Acc with #3, call sub
; To add 10 load X with #5 and load Acc with #1
;*************************************************************
IncreaseScore
                    sta                 SCORE_PARAM1        
                    stx                 SCORE_PARAM2        
.IncreaseBy1
                    ldx                 SCORE_PARAM2        
.IncreaseDigit      inc                 SCORE_POS,x         

.SM_HIGHSC1         ;inc                 HISCORE_POS,x   - SELF MODIFIED
                    nop
                    nop
                    nop
                    lda                 SCORE_POS,x         
                    cmp                 #58                 ; The number past 9 in C64 ascii
                    bne                 .IncreaseBy1Done    
                    lda                 #48                 ; '0' character
                    sta                 SCORE_POS,x      
.SM_HIGHSC2         ;sta                 HISCORE_POS,x   - SELF MODIFIED 
                    nop
                    nop
                    nop
                    dex
                    bne                 .IncreaseDigit      
                    ldx                 SCORE_PARAM2        
                    jmp                 .donehere
                    
.IncreaseBy1Done
                    lda                 FREE_MAN            
                    cmp                 #1                  
                    beq                 .cont               
.check_award
                    lda                 SCORE_POS+2               ; 10,000 digit position
                    cmp                 #$31                
                    bne                 .cont               

                    INC                 FREE_MAN            
                    inc                 PACS_AVAIL          
                    txa
                    pha
                    jsr                 dsp_pacs            
                    pla
                    tax

.cont               dec                 SCORE_PARAM1
                    bne                 .IncreaseBy1        
.donehere          
.SM_NOTNEEDED       jsr                 CheckForHighscore   
                    ldx                 SCORE_PARAM2        ; Restore X register
                    rts
;------------------------------------------------------------
;check if the player got a new highscore entry
;------------------------------------------------------------

CheckForHighscore   ldy                 #0                  
                    ldx                 #0                                      
.CheckNextDigit     lda                 SCORE_POS,x
                    cmp                 HISCORE_POS,y   
                    bcc                 .NotHigher          
                    bne                 .IsHigher                                                                       
                    iny                                     ;need to check next digit
                    inx
                    cpx                 #7                  ;HIGHSCORE_SCORE_SIZE
                    beq                 .IsHigher           
                    jmp                 .CheckNextDigit     
.NotHigher          rts

.IsHigher           
                    lda #$FE            ; SELF MODIFYING TO INC HIGHSCORE,x
                    sta                 .SM_HIGHSC1         
                    lda                 #<HISCORE_POS
                    sta                 .SM_HIGHSC1+1                           
                    lda                 #>HISCORE_POS
                    sta                 .SM_HIGHSC1+2       
                    LDA #$9D            ; SELF MODIFYING TO STA HIGHSCORE,x 
                    sta                 .SM_HIGHSC2        
                    lda                 #<HISCORE_POS    
                    sta                 .SM_HIGHSC2+1        
                    lda                 #>HISCORE_POS
                    sta                 .SM_HIGHSC2+2        

                    lda                 #$EA                
                    sta                 .SM_NOTNEEDED       
                    sta                 .SM_NOTNEEDED+1       
                    sta                 .SM_NOTNEEDED+2 

                    ldx                 #7                ; First time high score is set   
.smloop             lda                 SCORE_POS-1,x     ; Need to copy current score    
                    sta                 HISCORE_POS-1,x   ; to the high score.     
                    dex
                    bne .smloop                    
                    rts 
;*************************************************************
; Ensure ghosts inside the cage bounce back and forth
; If they hit the left side increment the cage counter
; and set the course to go right
; If they hit the right side set the course to go back left
;*************************************************************
cage_sides
                    lda                 gy                  ;
                    cmp                 Cage_Ypos           ;
                    bne                 exit_sub            ;
                    lda                 gx                  ;
                    cmp                 #18                 ; Left side of cage
                    beq                 .xset_right         ;
                    cmp                 #21                 ; Right Side of cage
                    beq                 .xset_left          ;
exit_sub            rts
.xset_right
                    inc                 g$cage_cntr         ; Increment this counter every time the ghost hits the left side of the cage
                    lda                 Const_LEFT          ; Set previous direction to LEFT
                    sta                 pd$                 
                    lda                 Const_RIGHT         ; Set new direction to move RIGHT
                    sta                 cdir                ;
                    rts
.xset_left
                    lda                 Const_RIGHT         ; Set previous direction to RIGHT
                    sta                 pd$                 
                    lda                 Const_Left          ; Set new direction to move LEFT
                    sta                 cdir                ;
@bott               rts
;*************************************************************
; Redraw color just the border of the map with the value
; stored in SEARCH_COLOR variable
; SEARCH_CHAR
;*************************************************************

Change_Map_Color
                    lda                 #$04                
                    sta                 _scn_ptr2+2         
                    lda                 #$d8                
                    sta                 _scn_ptr+2          

                    ldx                 #$00                
main_lp1            ldy                 #$00
loop2


_scn_ptr2           lda                 $0400,y
SEARCH_CHAR         cmp                 wall_dot            ; Self modifying to change character to search for default is wall_dot
_self_mod1          bne                 skip_aa

issrch              lda                 SEARCH_COLOR        ;
_scn_ptr            sta                 $d800,y             ;
skip_aa             dey
                    bne                 loop2               
                    inc                 _scn_ptr2+2         
                    inc                 _scn_ptr+2          
                    inx
                    cpx                 #4                  
                    bne                 main_lp1            
                    rts

;*************************************************************
dly
                    ldx                 #8                  
def_2               ldy                 #0
loop_xx             jsr                 delay
                    dey
                    bne                 loop_xx             
                    dex
                    bne                 def_2               
                    rts

;***DELAY ***
dly4
                    nop
                    nop
def_2ab             ldx                 #50
loop_xxab           jsr                 delay
                    dex
                    cpx                 #0                  
                    bne                 loop_xxab           
                    rts
;***DELAY ***
delay_5
                    nop
                    nop
_delay_5            ldx                 #25
loop_xxabc          jsr                 delay
                    dex
                    cpx                 #0                  
                    bne                 loop_xxabc          
                    rts

;***DELAY ***
dly5
loop_xxab1          jsr                 delay
                    dex
                    cpx                 #0                  
                    bne                 loop_xxab1          
                    rts

dly7
loop_xxab12         jsr                 delay_longer
                    dex
                    cpx                 #0                  
                    bne                 loop_xxab12         
                    rts

;*************************************************************
; Make the screen flash different colors after completing
; a level
;*************************************************************
SEARCH_COLOR        byte                00  ; Color to change object to

FLASH_SCREEN
                    lda                 #0                  ;Make all characters change colors
                    sta                 _self_mod1+1        ;
                    lda                 #3                  ; Number of flashes
                    sta                 COLOR_CNTR          
loop3               dec                 COLOR_CNTR
                    lda                 #3                  
                    sta                 SEARCH_COLOR        
                    jsr                 Change_Map_Color    
                    jsr                 dly                 
                    lda                 #0                  
                    sta                 SEARCH_COLOR        
                    jsr                 Change_Map_Color    
                    jsr                 dly                 
                    lda                 COLOR_CNTR          
                    bne                 loop3               
                    rts
delay               txa
                    pha
                    tya
                    pha
                    ldy                 #3                  
del_lp2             ldx                 #1
del_lp1
                    dex
                    cpx                 #0                  
                    bne                 del_lp1             
                    dey
                    cpy                 #0                  
                    bne                 del_lp2             
                    pla
                    tay
                    pla
                    tax
                    rts

delay_longer        txa
                    pha
                    tya
                    pha
                    ldy                 #3                  
del_lp2a            ldx                 #$ff
del_lp1a
                    dex
                    cpx                 #0                  
                    bne                 del_lp1a            
                    dey
                    cpy                 #0                  
                    bne                 del_lp2a            
                    pla
                    tay
                    pla
                    tax
                    rts


;*************************************************************
; Reset the Game Level and set score to zero
;*************************************************************
Prep_Level_One

                    lda                 MAP_INDEX           ; make these equal in case
                    sta                 SCREENS_CLEARED     ; We jumped ahead in code variables

                    jsr                 RESET_LEVEL         
                    rts
;*************************************************************
; Upgrade to the next level
; Set the Ghost Priority &
; defaults to the new prioriy
; Dont need to reset btime counter here
; instead it is done when btime is enabled
;*************************************************************

RESET_LEVEL
                    lda                 MAP_INDEX           
                    cmp                 #2                  ; Map 2 is chaos challenge screen
                    beq                 _is_ch_scr          
                    cmp                 #6                  ; Map 6 is Carpals Tunnel ch screen
                    beq                 _is_ch_scr          
                    cmp                 #$0a                ; Map 10 is Dragons Wrath ch screen
                    beq                 _is_ch_scr          
                    lda                 #0                  
                    sta                 CHALLENGE_SCREEN    ; reset challenge screen
                    jmp                 _notchlng           
_is_ch_scr          lda                 #1
                    sta                 CHALLENGE_SCREEN    
_notchlng
                    lda                 #1                  ; Close Mouth
                    sta                 close_mouth         
                    lda                 #0                  
                    sta                 LEVEL_DONE          
                    sta                 Fruit_Map_Ctr       
                    sta                 rnd_move_counter    
                    jsr                 Dsp_Fruit_Level     
                    lda                 #0                  
                    sta                 FLASH_ONLY          
                    sta                 gxminus1            
                    sta                 gxplus1             
                    sta                 gyminus1            
                    sta                 gyplus1             
                    sta                 gx                  
                    sta                 gy                  
                    sta                 pq$                 
                    sta                 pq$len              
                    sta                 g$                  
                    sta                 g$len               
                    sta                 g$eyesmode          
                    sta                 g$cage_cntr         
                    sta                 g$bluetime          
                    sta                 g$exit_cage_flg     
                    sta                 xg                  
                    sta                 yg                  
                    sta                 pr_cntr             
                    sta                 ghost_pr            
                    sta                 pd$                 
                    sta                 cdir                

                    lda                 Const_gh2_DEF_PR,x  ;Grabbing the next
                    sta                 gh2_pr              ; et of priorities
                    lda                 Const_gh3_DEF_PR,x  ;Slightly more difficult
                    sta                 gh3_pr              ;For the next level
                    lda                 Const_gh4_DEF_PR,x  
                    sta                 gh4_pr              
                    lda                 Const_gh5_DEF_PR,x  
                    sta                 gh5_pr              
                    lda                 SCREENS_CLEARED     
                    cmp                 #13                 
                    bcc                 _here               ; Stay fast speed
                                                            ;sta                 gh1_sp_boost_goal,x
                    lda                 #4                  
                    sta                 gh1_sp_boost_goal+8 ; Reset these values because they are changed after level 14
                    sta                 gh1_sp_boost_goal+9 
                    sta                 gh1_sp_boost_goal+10
                    lda                 #3                  
                    sta                 gh1_sp_boost_goal+11
                    lda                 #2                  
                    sta                 gh1_sp_boost_goal+12
                    lda                 #1                  
                    sta                 gh1_sp_boost_goal+13

_here
                    ldx                 MAP_INDEX           
                    lda                 GAME_SPEED,x        
                    sta                 _delay_5+1          

                    lda                 #0                  ;Reset Dots Eaten
                                                            ;sta                 DOTS_EATEN          ;
                                                            ;lda                 #0
                                                            ;sta                 TOTAL_DOTS_FLAG     ;
                    sta                 gh1_pr_cntr         
                    sta                 gh2_pr_cntr         
                    sta                 gh3_pr_cntr         
                    sta                 gh4_pr_cntr         
                    sta                 gh5_pr_cntr         

                    ldx                 MAP_INDEX           
                    lda                 GH1_Start_X,x       
                    sta                 gh2_gx              
                    lda                 GH1_Start_Y,x       
                    sta                 gh2_gy              
                    lda                 GH2_Start_X,x       
                    sta                 gh3_gx              
                    lda                 GH2_Start_Y,x       
                    sta                 gh3_gy              
                    lda                 GH3_Start_X,x       
                    sta                 gh4_gx              
                    lda                 GH3_Start_Y,x       
                    sta                 gh4_gy              
                    lda                 GH4_Start_X,x       
                    sta                 gh5_gx              
                    lda                 GH4_Start_Y,x       
                    sta                 gh5_gy              

;xxxx
                    lda                 #$33                

                    lda                 PAC_Start_X,x       
                    sta                 gh1_gx              
                    lda                 PAC_Start_Y,x       
                    sta                 gh1_gy              

                    lda                 Pac_SP_X,x          
                    sta                 $d000               
                    lda                 Pac_SP_Y,x          
                    sta                 $d001               

                    lda                 #0                  
                    jsr                 dsp_pacs            
                    LDA                 #%11011110          ; Turn off pac during ready text printing
                    sta                 $d015               
                    lda                 #0                  
                    sta                 $d010               

                    Jsr                 Reset_Sprite        
                    lda                 CHALLENGE_SCREEN    
                    cmp                 #1                  
                    bne                 prt_ready           ; Not a challenge screen then print ready!

                    lda                 #0                  
                    sta                 ENG_FLASH_ON        ; Turn off flashing energizers
                    lda                 MAP_INDEX           
                    cmp                 #6                  ; Map 6 has more than 255 dots
                    beq                 .dontdothat         
                    lda                 #1                  ; Emulate more that 255 dots eaten
                    sta                 TOTAL_DOTS_FLAG     ;
.dontdothat         lda                 DEATH_FLAG          ; Are you dead?
                    cmp                 #1                  
                    bne                 .chlng              ; No..
                    jsr                 print_failed        ; So if you die on challenge screen then print 'failed'
                    jsr                 RESTORE_TOP_ROW       ;
                    inc                 superbonus          ; Changing the value to >0 disables any 'superbonus'
                    rts

.chlng              jsr                 print_challenge
                    LDA                 #$FF                ; Turn on all sprites
                    sta                 $d015               

                    lda                 MAP_INDEX           ; Challenge Map 10 is the one we want to enable extra sprite
                    cmp                 #$0a                
                    bne                 skp_cont            
                    lda                 #$ea                ; Execute the shadow sprite code for chlnge screen EA is NOP instruction
                    sta                 challenge_only      

                    lda                 #SPR_ROOT+36        
                    sta                 $7fd                
                    lda                 $d000               
                    sta                 $d00a               
                    lda                 $d001               
                    sta                 $d00b               
                    lda                 #%00100000          ; Sprite 6
                    sta                 $d01b               ; Make sprite 6 transparent
                    sta                 $d017               ; Double Height
                    sta                 $d01d               ; Double Width

                    LDA                 #$ff                ; Turn on all sprites
                    sta                 $d015               
                    lda                 #15                 ; Set Box color
                    sta                 $d02c               
                    jmp                 skp_cont            
prt_ready
                    lda                 #$60                ; RTS - do not execute some code if not challenge screen
                    sta                 challenge_only      

                    lda                 #1                  
                    sta                 ENG_FLASH_ON        
                    jsr                 print_ready         
                    LDA                 #$df                ; All sprites on but sprite 6 the shadow sprite for challenge screen
                    sta                 $d015               

skp_cont
                    lda                 #0                  
                    sta                 gh1_pr              
                    sta                 gh1_g$              
                    sta                 gh2_g$              
                    sta                 gh3_g$              
                    sta                 gh4_g$              
                    sta                 gh5_g$              
                    sta                 gh1_pq$             
                    sta                 gh2_pq$             
                    sta                 gh3_pq$             
                    sta                 gh4_pq$             
                    sta                 gh5_pq$             
                    sta                 gh2_flashon         
                    sta                 gh3_flashon         
                    sta                 gh4_flashon         
                    sta                 gh5_flashon         
                    sta                 gh2_bt_count        
                    sta                 gh3_bt_count        
                    sta                 gh4_bt_count        
                    sta                 gh5_bt_count        

                    sta                 gh2_g$len           
                    sta                 gh3_g$len           
                    sta                 gh4_g$len           
                    sta                 gh5_g$len           
                    sta                 gh2_pq$len          
                    sta                 gh3_pq$len          
                    sta                 gh4_pq$len          
                    sta                 gh5_pq$len          
                    sta                 gh1_pd$             
                    sta                 gh2_pd$             
                    sta                 gh5_pd$             

                    lda                 #0                  
                    sta                 userdirection       
                    sta                 gh1_cdir            
                    lda                 Const_left          
                    sta                 gh5_cdir            
                    sta                 gh3_cdir            
                    sta                 gh3_g$              
                    sta                 gh3_pq$             
                    sta                 gh3_pd$             
                    lda                 Const_RIGHT         
                    sta                 gh2_cdir            
                    sta                 gh4_cdir            


                    sta                 gh4_g$              
                    sta                 gh4_pd$             
                    lda                 #0                  
                    sta                 gh2_bluetime        
                    sta                 gh3_bluetime        
                    sta                 gh4_bluetime        
                    sta                 gh5_bluetime        
                    sta                 gh2_eyesmode        
                    sta                 gh3_eyesmode        
                    sta                 gh4_eyesmode        
                    sta                 gh5_eyesmode        


                    STA                 gh2_pr_cntr         
                    STA                 gh3_pr_cntr         
                    STA                 gh4_pr_cntr         
                    STA                 gh5_pr_cntr         

                    sta                 gh2_cage_cntr       
                    sta                 gh3_cage_cntr       
                    sta                 gh4_cage_cntr       
                    sta                 gh5_cage_cntr       
                    lda                 #0                  
                    sta                 gh2_exit_cage_flg   
                    sta                 gh3_exit_cage_flg   
                    sta                 gh4_exit_cage_flg   
                    sta                 gh5_exit_cage_flg   
                    jsr                 mv_Ghost2           
                    jsr                 mv_Ghost3           
                    jsr                 mv_Ghost4           
                    jsr                 mv_Ghost5           

                    lda                 #1                  
                    sta                 Gobble_on           

#region delay
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    jsr                 dly4                
                    ldy                 #0                  
clear_buffer        jsr                 $ffe4
                    dey
                    bne                 clear_buffer        

#endregion

                    lda                 #1                  ; Close Mouth
                    sta                 close_mouth         
                    jsr                 .FirstInput         ; Waits for first input before game starts
                    rts

print_boost         lda                 #<lbl_boost
                    sta                 _lbl_loop+1         
                    lda                 #>lbl_boost         
                    sta                 _lbl_loop+2         
                    jsr                 _print_loop         
                    rts
print_bonus         lda                 #<lbl_bonus
                    sta                 _lbl_loop+1         
                    lda                 #>lbl_bonus         
                    sta                 _lbl_loop+2         
                    jsr                 _print_loop         
                    rts

print_superbonus    lda                 #<lbl_superbonus
                    sta                 _lbl_loop+1         
                    lda                 #>lbl_superbonus    
                    sta                 _lbl_loop+2         
                    jsr                 _print_loop         
                    rts

print_boost2        lda                 #<lbl_boost2
                    sta                 _lbl_loop+1         
                    lda                 #>lbl_boost2        
                    sta                 _lbl_loop+2         
                    jsr                 _print_loop         
                    rts

_print_loop         jsr Blank_toprow  
                    sei
                    
                    ldx                 #0                  
_lbl_loop           lda                 lbl_boost,x
                    cmp                 #0                  
                    beq                 _quit               
                    sta                 $40e,x              ; Hard coded start position
                    lda                 #7                  
                    sta                 $d80e,x             
                    inx
                    jmp                 _lbl_loop           
_quit
                    jsr                 new_delay           
                    jsr                 new_delay           
                    jsr                 new_delay           
                                        
                    jsr RESTORE_TOP_ROW 
                    cli
                    rts
                    
defm                RESTORE_ROW       ; Made quick macro to use for top and bottom rows                    
                    ldx                 MAP_INDEX           
                    lda                 SCORE_COLOR_MAP,x
                    tay
                    ldx                 #40                 
                    
@smloopb            lda                 TOP_ROW_SAVE-1,x                          
                    sta                 /1,x 
                    tya
                    sta                 /2,x                                    
                    dex
                    bne                 @smloopb            
endm 
                    
RESTORE_TOP_ROW                                             ; To make room for text printed across top
                    RESTORE_ROW         $3ff,$d7ff          
                    rts
RESTORE_BOT_ROW
                    RESTORE_ROW         $7bf,$dbbf          
                    rts

;*************************************************************
; Print ready in the center of the map right before
; play begins
;*************************************************************
lbl_ready           Null                'ready!'
lbl_challenge1      Null                'chaos fruit grab!'
lbl_challenge2      Null                'carpals tunnel'
lbl_challenge3      Null                'dragons wrath'
lbl_failed          Null                'failed!'

print_failed                                                ; Set up pointers to print ready text at specific location

                    lda                 #<lbl_failed        
                    sta                 get_char+1          

                    lda                 #>lbl_failed        
                    sta                 get_char+2          
                    lda                 #$10                
                    jmp                 .into_it2           

print_ready                                                 ; Set up pointers to print ready text at specific location

                    lda                 #<lbl_ready         
                    sta                 get_char+1          
                    lda                 #>lbl_ready         
                    sta                 get_char+2          
                    lda                 #$41                
                    sta                 put_char+1          
                    sta                 prt_color+1         
                    lda                 #$06                
                    sta                 put_char+2          
                    lda                 #$da                
                    sta                 prt_color+2         
                    jsr                 print_text       ; Skip the first sub           
                    rts
                    
print_challenge     jsr Blank_toprow                       ; Set up pointers to print challenge text at specific location on screen
                    lda                 Map_Index           
                    cmp                 #2                  
                    beq                 .print_ch1          
                    cmp                 #6                  
                    beq                 .print_ch2          
                    lda                 #<lbl_challenge3    
                    sta                 get_char+1          
                    lda                 #>lbl_challenge3    
                    jsr                 .into_it  
                    jsr                 RESTORE_TOP_ROW            
                    
                    rts
.print_ch1          lda                 #<lbl_challenge1
                    sta                 get_char+1          
                    lda                 #>lbl_challenge1    
                    jmp                 .into_it            
.print_ch2          lda                 #<lbl_challenge2
                    sta                 get_char+1          
                    lda                 #>lbl_challenge2    
                                                           
.into_it            sta                 get_char+2
                    lda                 #$0c                
.into_it2           sta                 put_char+1
                    sta                 prt_color+1         
                    lda                 #$04                
                    sta                 put_char+2          
                    lda                 #$10                
                    lda                 #$d8                
                    sta                 prt_color+2         
                    jsr                 print_text   
                    jsr                 RESTORE_TOP_ROW            
                    rts

print_text          ldx                 #0
lbl_loop            jsr                 get_char

                    cmp                 #0                  
                    beq                 .xnext_loop         
print_dest          jsr                 put_char
                    lda                 #7                  
prt_color           sta                 $da41,x
                    inx
                    txa
                    pha
                    jsr                 dly                 
                    pla
                    tax
                    jmp                 lbl_loop            
.xnext_loop
                    jsr                 dly                 
                    jsr                 dly                 
                    jsr                 dly                 
                    jsr                 dly                 
                    ldx                 #0                  
lbl_loop2           jsr                 get_char
                    cmp                 #0                  
                    beq                 .xquit              
                    lda                 #$20                
Erase_dest          jsr                 put_char
                    inx
                    jmp                 lbl_loop2           

get_char            lda                 lbl_ready,x
                    rts
put_char            sta                 $641,x              ; Hard coded start position
.xret               rts
.xquit
                    rts
Blank_toprow                                                ; Save off top row of screen and blank it out                     
                    ldx                 #40                 ; To make room for text printed across top
.smloopa            lda                 $3ff,x              
                    sta                 TOP_ROW_SAVE-1,x                          
                    lda                 #$20               ; Space character                                       
                    sta                 $3ff,x             
                    dex
                    bne                 .smloopa            
                    rts

dsp_pacs            ldx                 #0
                    lda                 pac_char            
lbl_pacs            sta                 $7c0,x
                    pha
                    ldy                 MAP_INDEX           
                    lda                 #7                  
                    sta                 $dbc0,x             
                    pla
                    inx
                    cpx                 PACS_AVAIL          
                    bcc                 lbl_pacs            
                    lda                 #$20                
                    cpx                 #8                  
                    bne                 lbl_pacs            
                    rts

fruit_posns         byte                $e7,$e6,$e5,$e4,$e3,$e2,$e1,$e0

Dsp_Fruit_Level
                    lda                 CHALLENGE_SCREEN    ; No fruit on challenge screens
                    bne                 _exit1              
                    ldy                 #0                  
_loop               lda                 fruit_on_levels,y
                    tax
                    lda                 fruit_posns,x       
                    sta                 Fr_Bottom_right+1   
                    sta                 Fr_Color_bot+1      
                    lda                 Fruit_Levels,x      
Fr_Bottom_right     sta                 $07e7
                    sta                 CURRENT_FRUIT       
                    lda                 Fruit_Colors,x      
Fr_Color_bot        sta                 $dbe7
                    sta                 CURR_FRUIT_COLOR    
                    cpy                 SCREENS_CLEARED     
                    beq                 _exit1              
                    iny
                    cpy                 #10                 
                    bne                 _loop               
_exit1              rts


;*************************************************************
; Actions taken when pac-clone is dead:
; Clear dath flag, decrease available free men
; Do the death animation and do a level reset
;*************************************************************
HE_DEAD

                    lda                 #0                  ; No Pacs dead
                    sta                 DEATH_FLAG          ; Reset flag
                    dec                 PACS_AVAIL          ; Decrease avail lives
                    lda                 PACS_AVAIL          
                    cmp                 #0                  ; Is game over?
                    beq                 _Game_Over          ; Right now program freezes after last man...
                    jsr                 DEATH_ANIMATION     ; Animate Pac on death

_not_chlng          jsr                 RESET_LEVEL         ; Reset the level

                    ldx                 MAP_INDEX           ;
                    lda                 Const_Orig_boost,x  ; Reset boost speed to normal after death
                                                            ;
                    sta                 gh1_sp_boost_goal,x ;
                    lda                 GAME_SPEED,x        ;
                    sta                 _delay_5+1          ;

                    rts
_Game_Over
_junk               jmp                 _junk

;*************************************************************
; Simulate death of pac-clone by changing out characters
; with small delay between
;*************************************************************
DEATH_ANIMATION
                    lda                 #1                  
                    sta                 FLASH_ONLY          
                    lda                 #1                  ; Turn off all GHOSTS
                    sta                 $d015               
                    ldx                 #$ff                
                    jsr                 dly5                
                    jsr                 dly5                

                    jsr                 dly5                


                    ldy                 #SPR_ROOT+17        ; Pac-Mouth-Open facing up
_death_lp           sty                 $07f8
                    ldx                 #$50                
                    jsr                 dly6                
                    iny
                    cpy                 #SPR_ROOT+28        
                    bne                 _death_lp           
                    rts
dly6
                    jsr                 dly5                
                    jsr                 dly5                
                    jsr                 dly5                
                    jsr                 dly5                
                    jsr                 dly5                
                    jsr                 dly5                
                    jsr                 dly5                
                    rts
;*************************************************************
; Eat Dots
;*************************************************************
SB                  = 54296

EAT_DOTS


                    inc                 DOTS_EATEN          ; Eat a dot
                    lda                 TOTAL_DOTS_FLAG     

                    cmp                 #1                  
                    bne                 _eat_first_255      

                    ldx                 MAP_INDEX           
                    lda                 ACTUAL_MAP_LEVELS,x 
                    tax
                    lda                 DOTS_EATEN          

                    cmp                 Const_TOTAL_DOTS,x  
                    beq                 .rtn                ; level up
                    rts

_eat_first_255      lda                 DOTS_EATEN          ;
                    cmp                 #255                ; Are all dots eaten?
                    bne                 .exitsub            ; No
                    inc                 TOTAL_DOTS_FLAG     
.xxdone             lda                 #0
                    beq                 .exitsub            
.exitsub            rts

.rtn                lda #1
                    sta                 LEVEL_DONE          
                    cmp                 #1                  
                    rts
_levelup
                    lda                 #1                  
                    sta                 Gobble_on           
                    sta                 close_mouth         

                    lda                 #0                  
                    sta                 gh2_flashon         
                    sta                 gh3_flashon         
                    sta                 gh4_flashon         
                    sta                 gh5_flashon         
                    sta                 flash_on            
                    sta                 TOTAL_GH_FLAG       
                    sta                 TOTAL_GH_MOVES      
                    sta                 TOTAL_DOTS_FLAG     
                    sta                 DOTS_EATEN          
                    lda                 #5                  
                    sta                 DOT_DEC             
                    lda                 #1                  
                    sta                 DOT_POINTS          
                    sta                 $d015               ;Only Pac-Clone at map end

                    lda                 DEATH_FLAG          
                    bne                 .notdead            
                    lda                 CHALLENGE_SCREEN    
                    beq                 .cont5              

                    ldx                 #2                  ; these three lines
                    lda                 int_sprite_byte,x   ; cose pac mouth
                    sta                 $7f8                ;

                    lda                 MAP_INDEX           
                    cmp                 #$0a                
                    bne                 .regularbonus       

                    lda                 superbonus          
                    bne                 .regularbonus       

                    jsr                 print_superbonus    
                    lda                 #25                 ; 25=250,000
                    ldx                 #2                  ; 10000 decimal pos
                    jsr                 IncreaseScore       ; Increase score
                    inc                 PACS_AVAIL          ; Award FREE MAN
                    jsr                 dsp_pacs            
                    jmp                 .cont5              ; One bonus is enough


.regularbonus       jsr                 print_bonus


                    lda                 #5                  ; 5=50,000
                    ldx                 #2                  ; 10000 decimal pos
                    jsr                 IncreaseScore       ; Increase score
                    inc                 PACS_AVAIL          ; Award FREE MAN
                    jsr                 dsp_pacs            

.cont5              sei
                    jsr                 FLASH_SCREEN        ; Yes, do the screen flash
                                                            ;sei

.notdead            inc                 SCREENS_CLEARED
                    inc                 MAP_INDEX           
                    lda                 MAP_INDEX           
                    cmp                 #MAX_MAP_LEVELS     
                    bne                 _DONT_RESET_MAPX    

                    lda                 #11                 ; Reset back a few maps
                    sta                 MAP_INDEX           ;
                                                            ;jmp _not_ch_scr
_DONT_RESET_MAPX

_not_ch_scr         lda                 #0
                    sta                 $d015               

                    lda                 DEATH_FLAG          

                    cmp                 #1                  
                    bne                 _skipthis           
                    jsr                 Pick_Map_to_Draw    

                    jmp                 .around             


_skipthis
                    jsr                 DRAW_NEXT_MAP       

.around             lda                 #254

                    sta                 SEARCH_COLOR        
                    jsr                 RESET_LEVEL         
                    rts
#endregion
space
                    lda                 wall_spc            
                    sta                 .saveacc+1          
                    ldx                 gh1_gy              ; X value
                    lda                 map_off_l,x         ; Load map low byte into $fb
                    sta                 .newvalue+1         
                    lda                 map_off_h,x         ; Load map high byte into $fc
                    sta                 .newvalue+2         
.saveacc            lda                 #00
                    ldx                 gh1_gx              
.newvalue           sta                 $ffff,x             ; Store result in screen memory
                    rts

Reset_Sprite
                    lda                 #0                  
                    sta                 gh1_sp_pos          
                    sta                 gh2_sp_pos          
                    sta                 gh3_sp_pos          
                    sta                 gh4_sp_pos          
                    sta                 gh5_sp_pos          
                    sta                 gh1_spctr           
                    sta                 gh2_spctr           
                    sta                 gh3_spctr           
                    sta                 gh4_spctr           
                    sta                 gh5_spctr           

                    lda                 #SPR_ROOT+12        
                    sta                 $07f9               ; sprite 2
                    jsr                 Spr_ghostcolor      

                    lda                 #SPR_ROOT+11        
                    sta                 $07fA               ; sprite 3
                    lda                 #SPR_ROOT+12        
                    sta                 $07fb               ; sprite 4
                    lda                 #SPR_ROOT+11        
                    sta                 $07fc               ; sprite 5

                    ldx                 MAP_INDEX           
                    lda                 Pac_SP_X,x          
                    sta                 $d000               
                    lda                 Pac_SP_Y,x          
                    sta                 $d001               
                    lda                 GH1_SP_X,x          
                    sta                 $d002               ; Ghost 1 X Position

                    lda                 GH1_SP_Y,x          
                    sta                 $d003               ; Ghost 1 Y Position
                    lda                 GH2_SP_X,x          
                    sta                 $d004               ; Ghost 2 X Position
                    lda                 GH2_SP_Y,x          
                    sta                 $d005               ; Ghost 2 Y Position
                    lda                 GH3_SP_X,x          
                    sta                 $d006               ; Ghost 3 X Position
                    lda                 GH3_SP_Y,x          
                    sta                 $d007               ; Ghost 3 Y Position
                    lda                 GH4_SP_X,x          
                    sta                 $d008               ; Ghost 4 X Position
                    lda                 GH4_SP_Y,x          
                    sta                 $d009               ; Ghost 4 Y Position

                    lda                 #7                  ;make the int_sprite yellow
                    sta                 $d027               


                    lda                 #0                  
                    sta                 gh2_flashon         
                    sta                 gh3_flashon         
                    sta                 gh4_flashon         
                    sta                 gh5_flashon         

                    sta                 int_counter         
                    lda                 #0                  
                    sta                 flash_on            
                    sta                 flash_counter       
                    sta                 flash_counter2      
                    sta                 flash_counter4      
                    sta                 flash_white_blue    
                    rts

Set_Interrupt
                    sei                                     ; disable interrupts
                    lda                 #<intcode           ; get low byte of target routine
                    sta                 788                 ; put into interrupt vector
                    lda                 #>intcode           ; do the same with the high byte
                    sta                 789                 
                    cli                                     ; re-enable interrupts
                                                            ; return to caller
_no_int                                                     ;  stx                 int_spr_high        ;
                    jsr                 Reset_Sprite        
                                                            ; lda                 int_sprite_byte
                                                            ; lda                 int_sprite_byte+1
                                                            ;  lda                 int_sprite_byte+2
                    ldx                 #2                  
                    lda                 int_sprite_byte,x   
                    sta                 $7f8                

                    rts
;*************************************************************
intcode             = *
                    pha
                    lda                 ENG_FLASH_ON        
                    cmp                 #1                  
                    bne                 _cont               

                    inc                 flash_counter4      
                    lda                 flash_counter4      
                    cmp                 #12                 
                    bne                 _cont               
                    lda                 #0                  
                    sta                 flash_counter4      

                    inc                 int_nrgize          
                    lda                 int_nrgize          
                    cmp                 #2                  
                    beq                 _rst_nrgy           
                    ldx                 MAP_INDEX           
                    lda                 EnergizerColor,x    
                    tax
                    jsr                 Set_Nrgize_color    

                    jmp                 _cont               
_rst_nrgy           lda                 #0
                    sta                 int_nrgize          
                    ldx                 MAP_INDEX           
                    lda                 MAP_BG_COLOR,x      
                    tax

                    jsr                 Set_Nrgize_color    


_cont               lda                 FLASH_ONLY
                    cmp                 #1                  
                    bne                 _is_int             
                    jmp                 end                 

_is_int
                    lda                 Gobble_on           

                    cmp                 #0                  
                    beq                 skip2               
                    lda                 close_mouth         
                    cmp                 #0                  
                    beq                 _normal             

                    ldx                 #2                  ; mouth closed
                    lda                 int_sprite_byte,x   
                    sta                 $7f8                

                    jmp                 flash_check         
end_jmp             jmp                 end

_normal
                    ldx                 #0                  ; mouth open
                    lda                 int_sprite_byte,x   
                    sta                 $7f8                
                    jmp                 flash_check         

skip2               inc                 int_counter
                    lda                 int_counter         
                    cmp                 #3                  
                    bne                 flash_check         

                    lda                 #0                  
                    sta                 int_counter         
                    inc                 int_sprite          
                    ldx                 int_sprite          
                    cpx                 #3                  ; int_spr_high
                    bne                 int_skip            
                    ldx                 #0                  
                    stx                 int_sprite          
int_skip            lda                 int_sprite_byte,x
                    sta                 $07f8               
flash_check
                    inc                 flash_counter2      
                    lda                 flash_counter2      
                    cmp                 #20                 
                    bne                 end                 
                    inc                 flash_white_blue    
                    lda                 #0                  
                    sta                 flash_counter2      

                    Int_Flash           gh2_flashon,#0      ; Make Ghost 1 flash
test_2              Int_Flash           gh3_flashon,#1      ; Make Ghost 2 flash
test_3              Int_Flash           gh4_flashon,#2      ; Make Ghost 3 flash
test_4              Int_Flash           gh5_flashon,#3      ; Make Ghost 4 flash

_end_flash          lda                 flash_counter
                    cmp                 #2                  
                    bcc                 _inc                
                    lda                 #0                  
                    sta                 flash_on            
                    lda                 #0                  
                    sta                 flash_counter       
_inc                inc                 flash_counter
@_end_here          nop


end                 pla
done_with_int       jmp                 $ea31

;Created this marco to make Interrupt flashing code more readable
defm                Int_Flash
                    lda                 /1                  
                    cmp                 #1                  
                    bne                 @end                
                    inc                 flash_on            
                    ldy                 /2                  
                    jsr                 set_flash_color     
@end
endm

int_nrgize          byte                00
int_param           byte                00
int_counter         byte                00
;int_sprite          byte                $f8,$f9,$fa,$fb
;int_spr_low         byte                00
;int_spr_high        byte                00
int_sprite          byte                00
;int_spr_index       byte                00

Gobble_on           byte                00
SPR_ROOT            = ($3000/64)                            ; Sprite data starts at $3000
int_sprite_byte     byte                SPR_ROOT,SPR_ROOT+1,SPR_ROOT+2
spr_up              byte                SPR_ROOT,SPR_ROOT+1,SPR_ROOT+2
spr_down            byte                SPR_ROOT+3,SPR_ROOT+4,SPR_ROOT+2
spr_left            byte                SPR_ROOT+5,SPR_ROOT+6,SPR_ROOT+2
spr_right           byte                SPR_ROOT+7,SPR_ROOT+8,SPR_ROOT+2

flash_counter       byte                00
flash_on            byte                00
flash_counter2      byte                00
flash_counter4      byte                00
FLASH_ONLY          byte                00
ENG_FLASH_ON        byte                00 ; energizer flash on toggle

MAP2L               byte                00  ; New Mapl being switched to
MAP2H               byte                00  ;
map2cl              byte                00
map2ch              byte                00

DRAW_MAP4
                    ldy                 #0                  
_inner1a            lda                 $428,y
                    sta                 $400,y              
                    lda                 $d828,y             
                    sta                 $d800,y             
                    iny
                    bne                 _inner1a            
_inner1b            lda                 $528,y
                    sta                 $500,y              
                    lda                 $d928,y             
                    sta                 $d900,y             
                    iny
                    bne                 _inner1b            
_inner1c            lda                 $628,y
                    sta                 $600,y              
                    lda                 $da28,y             
                    sta                 $da00,y             
                    iny
                    bne                 _inner1c            
_inner1d            lda                 $728,y
                    sta                 $700,y              
                    lda                 $db28,y             
                    sta                 $db00,y             
                    iny
                    cpy                 #$c0                
                    bne                 _inner1d            
                    ldy                 #0                  
_inner2a            lda                 MAP2L               ; Load map low byte into $fb
                    sta                 _mapxy+1            
                    lda                 MAP2H               
                    sta                 _mapxy+2            ; Load map hig byte into $fc
_mapxy              lda                 $ffff,y             ; Value changed above
                    sta                 $7c0,y              
                    jsr                 char_color          
                    sta                 _mapcxy+1           
_mapcxy             lda                 #$00                
                    sta                 $dbc0,y             
                    iny
                    cpy                 #40                 
                    bne                 _inner2a            
                    clc
                    lda                 map2l               
                    adc                 #40                 
                    sta                 map2l               
                    bcc                 _skip_carrya        
                    inc                 map2h               
_skip_carrya
                    clc
                    lda                 map2cl              
                    adc                 #40                 
                    sta                 map2cl              
                    bcc                 _skip_carryb        
                    inc                 map2ch              
_skip_carryb        rts

PrepMap_nLevel                                              ; Sets up temp pointers MAP2L,MAP2H,Map2CH,map2cl
                                                            ; to draw bottom line of new map during drawing map transition
                    ldx                 MAP_INDEX           
                    cpx                 #3                  
                    beq                 .lvl_map2           
                    cpx                 #6                  
                    beq                 .lvl_dflt           
                    cpx                 #7                  
                    beq                 .lvl_map3           
                    cpx                 #10                 
                    beq                 .lvl_map10          
                    cpx                 #11                 ; Needed after 17 levels are completed reset back to level 11
                    beq                 .lvl_map10          
                    cpx                 #16                 
                    beq                 .lvl_map3           
                    jmp                 .cont_prep          

.lvl_dflt           lda                 #2
                    sta                 .SM_CH_Dflt+1      
                    jmp                 .cont_prep          
.lvl_map2           lda                 #6
                    sta                 .SM_CH_Dflt+1      
                    jmp                 .cont_prep          
.lvl_map3           lda                 #0
                    sta                 .SM_CH_Dflt+1      
                    jmp                 .cont_prep          
.lvl_map10          lda                 #11
                    sta                 .SM_CH_Dflt+1      

.cont_prep          lda                 MAP_BG_COLOR,x
                    sta                 53281               
                    lda                 MAP_BD_COLOR,x      
                    sta                 53280               

                    ldx                 MAP_INDEX           
                    lda                 ACTUAL_MAP_LEVELS,x 
                    tax

                    lda                 PACMAPH,x           
                    sta                 MAP2H               
                    lda                 PACMAPL,x           
                    sta                 MAP2L               
                    rts
DRAW_NEXT_MAP                                               ; There is a SEI above this at the label .cont5
                    jsr                 PrepMap_nLevel      ; Prep Map for Next level
                    jsr                 Blank_toprow          
                    jsr                 draw_map4           
                    jsr                 RESTORE_BOT_ROW                       
                    
                    ldx                 #0                  
@loop_map
                    jsr                 draw_map4           
                    inx
                    cpx                 #24                 
                    bne                 @loop_map           
                    cli
                    rts