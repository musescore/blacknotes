//=============================================================================
//  Black notes : Paint all notes in black 
//  http://musescore.org/en/project/blacknotes
//
//  Copyright (C)2010 Nicolas Froment (lasconic)
//  Copyright (C)2014 Jörn Eichler (heuchi)
//  Copyright (C)2012-2024 Joachim Schmitz (Jojo-Schmitz)
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

import QtQuick 2.9
//import QtQuick.Dialogs 1.2
import MuseScore 3.0

MuseScore {
   version:  "3.0"
   description: qsTr("This plugin paints all chords and rests in black")
   menuPath: "Plugins.Notes.Color Notes in Black"
   //4.4 title: "Color Notes in Black"
   //4.4 thumbnailName: "color_notes.png"
   //4.4 categoryCode: "color-notes"

   Component.onCompleted : {
      if (mscoreMajorVersion >= 4 && mscoreMinorVersion <= 3) {
         title = "Color Notes in Black";
         thumbnailName = "color_notes.png";
         categoryCode = "color-notes";
      }
   }

   MessageDialog {
      id: versionError
      visible: false
      title: qsTr("Unsupported MuseScore Version")
      text: qsTr("This plugin needs MuseScore 3.0.2 or later")
      onAccepted: {
         (typeof(quit) === 'undefined' ? Qt.quit : quit)()
         }
      }

   function blackenElement(element) {
      if (element.type === Element.REST)
         element.color = "black"
      else if (element.type === Element.CHORD) {
         if (element.stem)
            element.stem.color = "black"
         if (element.hook)
            element.hook.color = "black"
         if (element.beam)
            element.beam.color = "black"
         if (element.stemSlash)
            element.stemSlash.color = "black"
         }
      else if (element.type === Element.NOTE) {
         element.color = "black"
         if (element.accidental)
            element.accidental.color = "black"
         if (element.tieBack)
            element.tieBack.color = "black"
         for (var i = 0; i < element.dots.length; i++) {
            if (element.dots[i])
               element.dots[i].color = "black"
            }
         }
      else
         console.log("Unknown element type: " + element.type)
      }

   // Apply the given function to all chords and rests in selection
   // or, if nothing is selected, in the entire score
   function applyToChordsAndRestsInSelection(func) {
      var cursor = curScore.newCursor()
      cursor.rewind(Cursor.SELECTION_START)
      var startStaff
      var endStaff
      var endTick
      var fullScore = false
      if (!cursor.segment) { // no selection
         fullScore = true
         startStaff = 0 // start with 1st staff
         endStaff = curScore.nstaves - 1 // and end with last
         }
      else {
         startStaff = cursor.staffIdx;
         cursor.rewind(Cursor.SELECTION_END)
         if (cursor.tick === 0) {
            // this happens when the selection includes
            // the last measure of the score.
            // rewind(Cursor.SELECTION_END) goes behind the last segment
            // (where there's none) and sets tick=0
            endTick = curScore.lastSegment.tick + 1
            }
         else
            endTick = cursor.tick
         endStaff = cursor.staffIdx
         }
      console.log(startStaff + " - " + endStaff + " - " + endTick)
      for (var staff = startStaff; staff <= endStaff; staff++) {
         for (var voice = 0; voice < 4; voice++) {
            cursor.rewind(Cursor.SELECTION_START) // sets voice to 0
            cursor.voice = voice //voice has to be set after goTo
            cursor.staffIdx = staff
            if (fullScore)
               cursor.rewind(Cursor.SCORE_START) // if no selection, beginning of score

            while (cursor.segment && (fullScore || cursor.tick < endTick)) {
               if (cursor.element) {
                  if (cursor.element.type === Element.REST)
                     func(cursor.element)
                  else if (cursor.element.type === Element.CHORD) {
                     func(cursor.element)
                     var graceChords = cursor.element.graceNotes;
                     for (var i = 0; i < graceChords.length; i++) {
                        // iterate through all grace chords
                        func(graceChords[i])
                        var gnotes = graceChords[i].notes
                        for (var j = 0; j < graceChords[i].notes.length; j++)
                           func(graceChords[i].gnotes[j])
                        }
                     var notes = cursor.element.notes
                     for (var k = 0; k < notes.length; k++) {
                        var note = notes[k]
                        func(note)
                        }
                     }
                  cursor.next()
                  }
               }
            }
         }
      }

   onRun: {
      console.log("Hello, Black Notes")
      // check MuseScore version
      if ((mscoreMajorVersion < 3) || ((mscoreMajorVersion == 3 && mscoreMinorVersion == 0 && mscoreUpdateVersion <= 1)))
         versionError.open();
      else {
         curScore.startCmd();
         applyToChordsAndRestsInSelection(blackenElement);
         curScore.endCmd();
         }
      (typeof(quit) === 'undefined' ? Qt.quit : quit)()
      }
}
