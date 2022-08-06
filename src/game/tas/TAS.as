package game.tas
{
    import game.tas.TASCommand;
    import game.tas.TASParser;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.html.__HTMLScriptArray;

    public class TAS
    {
        // Stores commands to be saved later.
        public var RecordBuffer:Vector.<TASCommand>;

        // Stores the commands currently being played back.
        public var PlaybackBuffer:Vector.<TASCommand>;

        // The current index into the playback buffer. Not necessarily related to framecount.
        private var _idx:uint;

        private var _frameCount:uint;

        private var _recording:Boolean = false;
        private var _playingBack:Boolean = false;

        public function TAS()
        {
            RecordBuffer = new Vector.<TASCommand>;
            PlaybackBuffer = new Vector.<TASCommand>;
        }

        public function Update() : void
        {
            _frameCount++;

            if (_recording)
            {
                if (_playingBack && _idx < PlaybackBuffer.length)
                {
                    RecordBuffer.push(PlaybackBuffer[_idx]);
                }

                // Take inputs from flashpunk, if there are any.
                // Don't overwrite
            }

            if (_idx >= PlaybackBuffer.length)
            {
                _playingBack = false;
                return;
            }

            if (_playingBack)
            {
                Execute();

                // Is there a next command to process?
                var c:TASCommand = Peek();
                while (c)
                {
                    // Check next command. See if we need to execute it immediately (i.e not an input command that needs to wait a frame).
                    if (PlaybackBuffer[_idx].Type == TASCommand.INPUT) break;

                    _idx++;
                    Execute()
                    c = Peek();
                }
            }

            _idx++;
        }

        private function Peek() : TASCommand
        {
            if (_idx < PlaybackBuffer.length - 1)
            {
                return PlaybackBuffer[_idx + 1];
            }

            return null;
        }

        private function Execute() : void
        {
            var c:TASCommand = PlaybackBuffer[_idx];

            switch (c.Type)
            {
                case TASCommand.INPUT:
                {
                    // Convert current command to inputs, then send to flashpunk.
                    var v:Vector.<uint> = TASUtility.FromGTASInputs(c.Data as String);
                    break;
                }
                case TASCommand.TIMESCALE:
                {
                    // TODO
                    break;
                }
            }
        }

        /* Write/Read/Start/Stop API */

        // Writes the record buffer into a GTAS file, then flushes it.
        public function Write(file:File) : void
        {
            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeUTF(TASParser.EmitGTAS(PlaybackBuffer));
            fileStream.close();
            FlushRecording();
        }

        // Does not flush record buffer. Job of the caller.
        public function StartRecording() : void
        {
            _recording = true;
        }

        // Empties the recording buffer and stops recording inputs.
        public function FlushRecording() : void
        {
            RecordBuffer = new Vector.<TASCommand>();
            _recording = false;
        }

        // Loads a GTAS file into the playback buffer.
        // Flushes playback but does not start playback.
        public function Load(file:File) : void
        {
            FlushPlayback();
            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            PlaybackBuffer = TASParser.ParseGTAS(fileStream.readUTF());
            fileStream.close();
        }

        // Does not flush playback buffer. Job of the caller.
        public function StartPlayback() : void
        {
            _playingBack = true;
        }

        // Empties the playback buffer and stops playing back inputs.
        public function FlushPlayback() : void
        {
            PlaybackBuffer = new Vector.<TASCommand>();
            _idx = 0;
            _playingBack = false;
        }

        /* End */

        /* Get/Set Input Commands */

        public function get CurInput() : String
        {
            if (_idx >= PlaybackBuffer.length) return "";
            // This shouldn't actually be possible, but might as well.
            if (PlaybackBuffer[_idx].Type != TASCommand.INPUT) return "";

            return PlaybackBuffer[_idx].Data as String;
        }

        public function set CurInput(data:String) : void
        {
            if (_idx >= PlaybackBuffer.length) return;
            // This shouldn't actually be possible, but might as well.
            if (PlaybackBuffer[_idx].Type != TASCommand.INPUT) return;

            PlaybackBuffer[_idx].Data = data;
        }

        // Find whatever the next input command's data is. Not necessarily the 'next' command.
        public function get NextInput() : String
        {
            for (var i:int = _idx + 1; i < PlaybackBuffer.length - 1; i++)
            {
                if (PlaybackBuffer[i].Type != TASCommand.INPUT) continue;
                return PlaybackBuffer[i].Data as String;
            }

            return "";
        }

        // Set the next input command's data to whatever. Not necessarily the 'next' command.
        public function set NextInput(data:String) : void
        {
            for (var i:int = _idx + 1; i < PlaybackBuffer.length - 1; i++)
            {
                if (PlaybackBuffer[i].Type != TASCommand.INPUT) continue;
                PlaybackBuffer[i].Data = data;
                return;
            }
        }

        /* End */
    }
}