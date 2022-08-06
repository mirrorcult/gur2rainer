package game.tas
{
    import game.tas.TASCommand;
    import game.tas.TASParser;
    import flash.filesystem.File;
    import game.engine.Level;

    public class TASUtility
    {       
         // Converts a string of GTAS inputs to a vector of uint keycodes.
        public static function FromGTASInputs(gtas:String) : Vector.<uint>
        {
            return new Vector.<uint>();
        }

        // Converts a vector of uint keycodes to a string of GTAS inputs.
        public static function ToGTASInputs(inputs:Vector.<uint>) : String
        {
            return "";
        }

        public static function GetGTASFileName(level:Level, framecount:uint) : String
        {
            return level.toString() + "_" + framecount + ".gtas";
        }

        public static function GetGTASFileDirectory(level:Level) : File
        {
            var prefix:String = level.getPrefix();
            var parentDir:File = File.applicationDirectory;
            var desiredDir:File = parentDir.resolvePath("TAS").resolvePath(prefix);
            return desiredDir;
        }

        public static function GetGTASFile(level:Level, framecount:uint) : File
        {
            var dir:File = GetGTASFileDirectory(level);
            var name:String = GetGTASFileName(level, framecount);
            return dir.resolvePath(name);
        }

        // Warning: does create directory.
        public static function GetFastestGTASFile(level:Level) : File
        {
            var dir:File = GetGTASFileDirectory(level);
            dir.createDirectory();

            var highest:uint = 0;
            var fastest:File = null;
            for each (var file:File in dir.getDirectoryListing())
            {
                if (file.extension != "gtas") continue;
                var fc:uint = GetFrameCountFromFile(file);
                if (fc > highest) fastest = file;
            }

            return fastest;
        }

        public static function GetFrameCountFromFile(file:File) : uint
        {
            var name:String = file.name;
            if (name.lastIndexOf("_") == -1)
                return 0;
            
            var frameCount:String = name.substring(name.lastIndexOf("_") + 1, name.length);
            return parseInt(frameCount);
        }
    }

}