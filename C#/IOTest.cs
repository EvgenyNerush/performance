using System;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;

namespace IOTest
{
    class IOTest
    {
        static void Main(string[] args)
        {
            int N = 2000000;
            int i = 0;
            Random random = new Random();
            List<float> rands = new List<float>();

            Stopwatch stw = Stopwatch.StartNew();

            while (i < N)
            {
                float r1 = Convert.ToSingle(random.NextDouble());
                float r2 = Convert.ToSingle(random.NextDouble());

                if (r2 < Math.Asin(Math.Sqrt(r1)) / (Math.PI / 2))
                {
                    rands.Add(r1);
                    ++i;
                }
            }

            TimeSpan genTime = stw.Elapsed;
            stw.Restart();

            using (StreamWriter sw = new StreamWriter("generated_rand_numbers"))
            {
                for (i = 0; i < N; ++i)
                {
                    sw.WriteLine(rands[i]);
                }
            }

            TimeSpan outTime = stw.Elapsed;
            stw.Restart();

            float sum = 0;
            using (StreamReader sr = new StreamReader("generated_rand_numbers"))
            {
                var line = string.Empty;
            
                if (null != sr)
                {
                    while (null != (line = sr.ReadLine()))
                    {
                        sum += Convert.ToSingle(line);
                    }
                }
            }

            TimeSpan inTime = stw.Elapsed;
            stw.Stop();

            Console.WriteLine("io.cs");
            Console.WriteLine("result = {0}", sum / N);
            Console.WriteLine("generation took = {0} s", genTime.TotalSeconds);
            Console.WriteLine("o time = {0} s", outTime.TotalSeconds);
            Console.WriteLine("i time = {0} s", inTime.TotalSeconds);
        }
    }
}
