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

import QtQuick 2.0
import MuseScore 1.0

MuseScore {
   version: "1.0"
   description: "This plugin paints all notes in black"
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
            if (cursor.element) {
               var element = cursor.element;
               if (typeof element.color !== "undefined" && element.color != black)
                  element.color = black;
               if (element.type == Element.CHORD) {
                  var notes = element.notes;
                  for (var i = 0; i < notes.length; i++) {
                     var note   = notes[i];
                     if (note.color != black)
                        note.color = black;
                  }
               }
            }
            cursor.next();
         }
      } // end loop tracks

      Qt.quit();
   } // end onRun
}
