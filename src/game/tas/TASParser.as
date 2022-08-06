package game.tas
{
    import game.tas.TASCommand;

    public class TASParser
    {
        // Parses a GTAS string into a vector of TAS commands.
        public static function ParseGTAS(data:String) : Vector.<TASCommand>
        {
            return new Vector.<TASCommand>();
        }

        // Converts a buffer of TAS commands into a maximally efficient (framehold) GTAS representation
        public static function EmitGTAS(buffer:Vector.<TASCommand>) : String
        {
            return "";
        }

        public static const TOKEN_COMMENT:String = "#";
        public static const TOKEN_TIMESCALE:String = "*";
        public static const TOKEN_FRAMEHOLD:String = ",";
    }
}