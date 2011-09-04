//=============================================================================
//  Black notes : Paint all notes in black 
//  http://musescore.org/en/project/blacknotes
//
//  Copyright (C)2010 Nicolas Froment (lasconic)
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================

//---------------------------------------------------------
//    init
//---------------------------------------------------------

function init()
      {
      }

//-------------------------------------------------------------------
//    run
//-------------------------------------------------------------------

function run()
      {
      var black = new QColor(0, 0, 0);
      var cursor = new Cursor(curScore);
      for (var staff = 0; staff < curScore.staves; ++staff) {
            cursor.staff = staff;
            for (var v = 0; v < 4; v++) {
                  cursor.voice = v;
                  cursor.rewind();  // set cursor to first chord/rest

                  while (!cursor.eos()) {
                        if (cursor.isChord()) {
                              var chord = cursor.chord();
                              var n     = chord.notes;
                              for (var i = 0; i < n; i++) {
                                    var note   = chord.note(i);
                                    note.color = new QColor(black);
                                    }
                              }
                        cursor.next();
                        }
                  }
            }
      }

var mscorePlugin = {
      menu: 'Plugins.Color notes in black',
      init: init,
      run:  run
      };

mscorePlugin;
