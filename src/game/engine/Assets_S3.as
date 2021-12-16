package game.engine
{
   import mx.core.ByteArrayAsset;

   [Embed(source="../../assets/binaryData/Assets_S3.bin", mimeType="application/octet-stream")]
   public class Assets_S3 extends ByteArrayAsset
   {
      public function Assets_S3()
      {
         super();
      }
   }
}
