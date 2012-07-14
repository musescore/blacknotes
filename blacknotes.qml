//=============================================================================
//  Black notes : Paint all notes in black 
//  http://musescore.org/en/project/blacknotes
//
//  Copyright (C)2010 Nicolas Froment (lasconic)
//  Copyright (C)2012 Joachim Schmitz (Jojo-Schmitz)
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

MuseScore {
   menuPath: 'Plugins.Notes.Color notes in black'
   onRun: {
      if (typeof curScore === 'undefined')
            Qt.quit;
      
      var black = "#000000";
      var cursor = curScore.newCursor();
      for (var track = 0; track < curScore.ntracks; ++track) {
         cursor.track = track;
         cursor.rewind(0);  // set cursor to first chord/rest

         while (cursor.segment) {
            if (cursor.element && cursor.element.type == MScore.CHORD) {
               var notes = cursor.elements.notes;
               for (var i = 0; i < notes.length; i++) {
                  var note   = notes[i];
                  note.color = black;
               }
            }
            cursor.next();
         }
      } // end loop tracks

      Qt.quit();
   } // end onRun
}
