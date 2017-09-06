using System;
using System.Linq;
using System.IO;
using System.IO.Compression;
using System.Text;
using Newtonsoft.Json;
using Superpower;
using Superpower.Parsers;

namespace project
{
    class Program
    {
        static void Main(string[] args)
        {
            string json = @"{'Phrase': 'Hello, World! - json'}";
            var account = JsonConvert.DeserializeObject<dynamic>(json);
            Console.WriteLine(account.Phrase);

            TextParser<string> identifier =
                from first in Character.EqualTo('\'')
                from phrase in Character.Except('\'').AtLeastOnce()
                from last in Character.EqualTo('\'')
                select new string(phrase);
            var id = identifier.Parse("'Hello, World! - superpower'");
            Console.WriteLine(id);

			Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            var bytes = Encoding.GetEncoding(1252).GetBytes("Hello, World! - encoding");
            Console.WriteLine(Encoding.GetEncoding(1252).GetString(bytes));

            bytes = Compress(bytes);
            bytes = Decompress(bytes, true);

            Console.WriteLine(Encoding.GetEncoding(1252).GetString(bytes).Replace("encoding","compression"));

        }
        public static byte[] Decompress(byte[] toDecompress, bool addHeader = false)
        {
            byte[] header = addHeader
                ? new byte[] { 0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x03 }
                : new byte[] { };

            byte[] n = new byte[toDecompress.Length + header.Length];
            Array.Copy(header, 0, n, 0, header.Length);
            Array.Copy(toDecompress, 0, n, header.Length, toDecompress.Length);

            using (MemoryStream compressed = new MemoryStream(n))
            using (GZipStream compressor = new GZipStream(compressed, CompressionMode.Decompress))
            {
                MemoryStream res = new MemoryStream();
                byte[] buffer = new byte[1024];
                int nRead;
                while ((nRead = compressor.Read(buffer, 0, buffer.Length)) > 0)
                {
                    res.Write(buffer, 0, nRead);
                }
                return res.ToArray();
            }
        }

        public static byte[] Compress(byte[] toCompress, bool removeHeader = true)
        {
            using (MemoryStream compressed = new MemoryStream())
            using (GZipStream compressor = new GZipStream(compressed, CompressionLevel.Optimal, false))
            {
                compressor.Write(toCompress, 0, toCompress.Length);
                compressor.Flush();
                byte[] result = compressed.ToArray();
                return removeHeader ? result.Skip(10).ToArray() : result;
            }
        }
    }
}
