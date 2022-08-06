package game.tas
{
    import game.tas.TASCommand;
    import game.tas.TASParser;
    import flash.filesystem.File;

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
    }

}