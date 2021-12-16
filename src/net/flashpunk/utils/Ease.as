package net.flashpunk.utils
{
   public class Ease
   {
      
      private static const B4:Number = 2.5 / 2.75;
      
      private static const PI2:Number = Math.PI / 2;
      
      private static const EL:Number = 2 * PI / 0.45;
      
      private static const B1:Number = 1 / 2.75;
      
      private static const B2:Number = 2 / 2.75;
      
      private static const B3:Number = 1.5 / 2.75;
      
      private static const B5:Number = 2.25 / 2.75;
      
      private static const PI:Number = Math.PI;
      
      private static const B6:Number = 2.625 / 2.75;
       
      
      public function Ease()
      {
         super();
      }
      
      public static function sineOut(t:Number) : Number
      {
         return Math.sin(PI2 * t);
      }
      
      public static function backInOut(t:Number) : Number
      {
         t = t * 2;
         if(t < 1)
         {
            return t * t * (2.70158 * t - 1.70158) / 2;
         }
         t--;
         return (1 - --t * t * (-2.70158 * t - 1.70158)) / 2 + 0.5;
      }
      
      public static function quintOut(t:Number) : Number
      {
         return t-- * t * t * t * t + 1;
      }
      
      public static function quartIn(t:Number) : Number
      {
         return t * t * t * t;
      }
      
      public static function quadOut(t:Number) : Number
      {
         return -t * (t - 2);
      }
      
      public static function bounceInOut(t:Number) : Number
      {
         if(t < 0.5)
         {
            t = 1 - t * 2;
            if(t < B1)
            {
               return (1 - 7.5625 * t * t) / 2;
            }
            if(t < B2)
            {
               return (1 - (7.5625 * (t - B3) * (t - B3) + 0.75)) / 2;
            }
            if(t < B4)
            {
               return (1 - (7.5625 * (t - B5) * (t - B5) + 0.9375)) / 2;
            }
            return (1 - (7.5625 * (t - B6) * (t - B6) + 0.984375)) / 2;
         }
         t = t * 2 - 1;
         if(t < B1)
         {
            return 7.5625 * t * t / 2 + 0.5;
         }
         if(t < B2)
         {
            return (7.5625 * (t - B3) * (t - B3) + 0.75) / 2 + 0.5;
         }
         if(t < B4)
         {
            return (7.5625 * (t - B5) * (t - B5) + 0.9375) / 2 + 0.5;
         }
         return (7.5625 * (t - B6) * (t - B6) + 0.984375) / 2 + 0.5;
      }
      
      public static function quadIn(t:Number) : Number
      {
         return t * t;
      }
      
      public static function bounceIn(t:Number) : Number
      {
         t = 1 - t;
         if(t < B1)
         {
            return 1 - 7.5625 * t * t;
         }
         if(t < B2)
         {
            return 1 - (7.5625 * (t - B3) * (t - B3) + 0.75);
         }
         if(t < B4)
         {
            return 1 - (7.5625 * (t - B5) * (t - B5) + 0.9375);
         }
         return 1 - (7.5625 * (t - B6) * (t - B6) + 0.984375);
      }
      
      public static function quartOut(t:Number) : Number
      {
         return 1 - t-- * t * t * t;
      }
      
      public static function quintIn(t:Number) : Number
      {
         return t * t * t * t * t;
      }
      
      public static function sineIn(t:Number) : Number
      {
         return -Math.cos(PI2 * t) + 1;
      }
      
      public static function expoInOut(t:Number) : Number
      {
         return t < 0.5?Number(Math.pow(2,10 * (t * 2 - 1)) / 2):Number((-Math.pow(2,-10 * (t * 2 - 1)) + 2) / 2);
      }
      
      public static function cubeOut(t:Number) : Number
      {
         return 1 + --t * t * t;
      }
      
      public static function circIn(t:Number) : Number
      {
         return -(Math.sqrt(1 - t * t) - 1);
      }
      
      public static function quintInOut(t:Number) : Number
      {
         return (t = Number(t * 2)) < 1?Number(t * t * t * t * t / 2):Number(((t = Number(t - 2)) * t * t * t * t + 2) / 2);
      }
      
      public static function circInOut(t:Number) : Number
      {
         return t <= 0.5?Number((Math.sqrt(1 - t * t * 4) - 1) / -2):Number((Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2);
      }
      
      public static function sineInOut(t:Number) : Number
      {
         return -Math.cos(PI * t) / 2 + 0.5;
      }
      
      public static function bounceOut(t:Number) : Number
      {
         if(t < B1)
         {
            return 7.5625 * t * t;
         }
         if(t < B2)
         {
            return 7.5625 * (t - B3) * (t - B3) + 0.75;
         }
         if(t < B4)
         {
            return 7.5625 * (t - B5) * (t - B5) + 0.9375;
         }
         return 7.5625 * (t - B6) * (t - B6) + 0.984375;
      }
      
      public static function backOut(t:Number) : Number
      {
         return 1 - --t * t * (-2.70158 * t - 1.70158);
      }
      
      public static function quadInOut(t:Number) : Number
      {
         return t <= 0.5?Number(t * t * 2):Number(1 - --t * t * 2);
      }
      
      public static function quartInOut(t:Number) : Number
      {
         return t <= 0.5?Number(t * t * t * t * 8):Number((1 - (t = Number(t * 2 - 2)) * t * t * t) / 2 + 0.5);
      }
      
      public static function backIn(t:Number) : Number
      {
         return t * t * (2.70158 * t - 1.70158);
      }
      
      public static function cubeInOut(t:Number) : Number
      {
         return t <= 0.5?Number(t * t * t * 4):Number(1 + --t * t * t * 4);
      }
      
      public static function circOut(t:Number) : Number
      {
         return Math.sqrt(1 - (t - 1) * (t - 1));
      }
      
      public static function cubeIn(t:Number) : Number
      {
         return t * t * t;
      }
      
      public static function expoOut(t:Number) : Number
      {
         return -Math.pow(2,-10 * t) + 1;
      }
      
      public static function expoIn(t:Number) : Number
      {
         return Math.pow(2,10 * (t - 1));
      }
   }
}
