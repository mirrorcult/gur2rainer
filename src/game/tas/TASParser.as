package game.tas
{
    import game.tas.TASCommand;
    import mx.utils.StringUtil;

    public class TASParser
    {
        // Parses a GTAS string into a vector of TAS commands.
        public static function ParseGTAS(data:String) : Vector.<TASCommand>
        {
            var commands:Vector.<TASCommand> = new Vector.<TASCommand>();

            for each (var line:String in data.split("\n"))
            {
                // Remove spaces.
                line = StringUtil.trim(line);
                if (line == "")
                {
                    // Empty case.
                    commands.push(new TASCommand(TASCommand.INPUT, ""));
                    continue;
                }

                // should probably integrate this better but whatever.
                if (line.indexOf(TOKEN_SEED_BOSS_THRUST) == 0)
                {
                    var thrusts: Vector.<Number> = new Vector.<Number>;
                    // cut 1 more to cut the comma
                    var nums: String = line.substring(TOKEN_SEED_BOSS_THRUST.length + 1);

                    while (nums.length != 0)
                    {
                        // expected format is like
                        // thrusts,0.3,0.54,0.1,0.9999
                        // which gets cut to 0.3,0.54,0.1,0.9999 before it gets here
                        var commaPlace:int = nums.indexOf(",");
                        if (commaPlace == -1) commaPlace = nums.length;
                        var n:Number = parseFloat(nums.substring(0, commaPlace));
                        // clamp to {0, 0.1}
                        thrusts.push(Math.min(Math.max(n, 0), 0.1));
                        nums = nums.substring(Number.min(commaPlace + 1, nums.length));
                    }

                    commands.push(new TASCommand(TASCommand.THRUSTS, thrusts));
                    continue;
                }

                var first:String = line.charAt(0);

                switch (first)
                {
                    case TOKEN_COMMENT:
                        continue;
                    case TOKEN_TIMESCALE:
                    {
                        var value:Number = GetTimescaleValue(line);
                        commands.push(new TASCommand(TASCommand.TIMESCALE, value));
                        continue;
                    }
                    case TOKEN_FRAMEHOLD:
                    {
                        // Empty case, but with a framehold.
                        var emptyFramehold:int = GetFrameholdValue(line);
                        for (var i:int = 0; i < emptyFramehold; i++)
                        {
                            commands.push(new TASCommand(TASCommand.INPUT, ""));
                        }
                        continue;
                    }
                }

                // Parse as a normal input with or without framehold.
                var framehold:int = GetFrameholdValue(line);
                var chars:String = GetCharactersUntilFramehold(line);

                if (!TASUtility.ValidateGTASInputs(chars)) continue;

                for (var j:int = 0; j < framehold; j++)
                {
                    commands.push(new TASCommand(TASCommand.INPUT, chars));
                }
            }

            return commands;
        }

        private static function GetTimescaleValue(line:String):Number
        {
            return parseFloat(line.substring(1));
        }

        private static function GetCharactersUntilFramehold(line:String):String
        {
            var commaPlace:int = line.indexOf(",");
            if (commaPlace == -1) return line;

            return line.substring(0, commaPlace);
        }

        private static function GetFrameholdValue(line:String):int
        {
            var commaPlace:int = line.indexOf(",");
            if (commaPlace == -1) return 1; // it gets -1 so this is intended i swear!!

            return parseInt(line.substring(commaPlace + 1));
        }

        // Converts a buffer of TAS commands into a maximally efficient (w/ frameholds) GTAS representation
        public static function EmitGTAS(buffer:Vector.<TASCommand>) : String
        {
            var gtas:String = "";

            for (var i:int = 0; i < buffer.length - 1; i++)
            {
                if (buffer[i].Type == TASCommand.THRUSTS)
                {
                    gtas += TOKEN_SEED_BOSS_THRUST;
                    var t:Vector.<Number> = buffer[i].Data as Vector.<Number>;
                    for each (var n:Number in t)
                    {
                        gtas += ",";
                        gtas += n.toString();
                    }
                }
                if (buffer[i].Type == TASCommand.TIMESCALE)
                {
                    gtas += ("*" + (buffer[i].Data as Number));
                }
                else if (buffer[i].Type == TASCommand.INPUT)
                {
                    var d:String = buffer[i].Data as String;
                    gtas += d;
                    var acc:int = 1;

                    for (var j:int = i + 1; j < buffer.length - 1; j++)
                    {
                        if (buffer[j].Type != TASCommand.INPUT) break;
                        if (buffer[j].Data as String != d) break;
                        acc++;
                        i = j;
                    }

                    if (acc > 1) gtas += "," + acc;
                }

                gtas += "\n";
            }

            return gtas;
        }

        public static const TOKEN_COMMENT:String = "#";
        public static const TOKEN_TIMESCALE:String = "*";
        public static const TOKEN_FRAMEHOLD:String = ",";
        public static const TOKEN_SEED_BOSS_THRUST:String = "seedBossThrusts"
    }
}