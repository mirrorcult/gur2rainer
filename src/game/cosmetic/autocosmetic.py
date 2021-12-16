from os import listdir
from os.path import isfile, join

text = """package game.cosmetic
{
   import mx.core.BitmapAsset;
   [Embed(source="../../assets/images/game.cosmetic.STUFFHERE.png")]
   public class STUFFHERE extends BitmapAsset
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
    if ("_Img" not in file):
        continue

    with open(file, "w") as f:
        replace = text.replace("STUFFHERE", file[:-3])
        f.write(replace)
