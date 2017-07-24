import java.io.*;
import javax.sound.midi.*;
import javax.sound.midi.Track;

void setup() {
  MidiFileReader player=new MidiFileReader("LJARDIN.mid");
}

class MidiFileReader {
  MidiFileReader(String name) {
    try {
      FileInputStream in=new FileInputStream(name);
      Sequence sequence = MidiSystem.getSequence(in);
      Track[] tracks = sequence.getTracks();

      for (int i=0; i<tracks.length; i++) {
        println("track: " + i);
        for (int j=0; j<tracks[i].size(); j++) {
          MidiEvent event = tracks[i].get(j);
          MidiMessage message = event.getMessage();
          byte[] messages = message.getMessage();


          if ((messages[0] & 0xF0) == 0x90) {
            //note on(0x90)
            String line = "";
            if ((0xFF & messages[2]) != 0) line = "on";
            else line = "off";
            

            line += ",  tick: " + event.getTick();
            line += ",  message: " + (0xFF & messages[0]);
            line += ",  pitch: " + (0xFF & messages[1]);
            line += ",  velocity: " + (0xFF & messages[2]);
            println(line);

          } else if ((messages[0] & 0xF0) == 0x80) {
            //note off (0x80)
            String line = "off";
            line += ",  tick: " + event.getTick();
            line += ",  message: " + (0xFF & messages[0]);
            line += ",  pitch: " + (0xFF & messages[1]);
            line += ",  velocity: " + (0xFF & messages[2]);
            println(line);
          }
        }
      }      
      in.close();
    }
    catch(Exception e) {
      println(e);
    }
  }
}