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

        public static function GetGTASFileName(level:Level, time:uint) : String
        {
            return level.toString() + "_" + time + ".gtas";
        }

        // Does not create the directory.
        public static function GetGTASFileDirectory(level:Level) : File
        {
            var prefix:String = level.getPrefix();
            var parentDir:File = File.applicationStorageDirectory;
            var desiredDir:File = parentDir.resolvePath("TAS").resolvePath(prefix);
            return desiredDir;
        }

        // Does not create its directory.
        public static function GetGTASFile(level:Level, time:uint) : File
        {
            var dir:File = GetGTASFileDirectory(level);
            var name:String = GetGTASFileName(level, time);
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
                var fc:uint = GetTimeFromFile(file);
                if (fc > highest) fastest = file;
            }

            return fastest;
        }

        public static function GetTimeFromFile(file:File) : uint
        {
            var name:String = file.name;
            if (name.lastIndexOf("_") == -1)
                return 0;
            
            var frameCount:String = name.substring(name.lastIndexOf("_") + 1, name.length);
            return parseInt(frameCount);
        }
    }

}