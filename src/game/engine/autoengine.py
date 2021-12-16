from os import listdir
from os.path import isfile, join

leveltext = """package game.engine
{
   import mx.core.ByteArrayAsset;

   [Embed(source="../../assets/binaryData/STUFFHERE.bin", mimeType="application/octet-stream")]
   public class STUFFHERE extends ByteArrayAsset
   {
      public function STUFFHERE()
      {
         super();
      }
   }
}
"""

soundtext = """package game.engine
{
   import mx.core.SoundAsset;

   [Embed(source = "../../assets/sounds/STUFFHERE.mp3", mimeType = "audio/mpeg")]
   public class STUFFHERE extends SoundAsset
   {
      public function STUFFHERE()
      {
         super();
      }
   }
}
"""

onlyfiles = [f for f in listdir(".") if isfile(join(".", f))]

for file in onlyfiles:

    if ("Assets_L" in file or "Assets_H" in file or "Assets_E" in file):
        continue
        with open(file, "w") as f:
            replace = leveltext.replace("STUFFHERE", file[:-3])
            f.write(replace)

    if (("Assets_V" in file
        or "Assets_S" in file
        or "Assets_M" in file)
       and "_S2" not in file and "_S3" not in file):
        print(file[:-3])
        with open(file, "w") as f:
            replace = soundtext.replace("STUFFHERE", file[:-3])
            f.write(replace)
