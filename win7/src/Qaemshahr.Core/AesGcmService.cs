using System;
using System.IO;
using System.Security.Cryptography;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.Crypto.Modes;
using Org.BouncyCastle.Crypto.Parameters;

namespace Qaemshahr.Core
{
    /// <summary>قالب باینری: nonce(12) + ciphertext + tag.</summary>
    public static class AesGcmService
    {
        public const int NonceLength = 12;
        const int TagBits = 128;
        const int StreamChunk = 64 * 1024;

        public static byte[] Encrypt(byte[] key, byte[] plaintext, byte[] aad = null)
        {
            if (key == null || key.Length != AppConstants.AesKeyLength)
                throw new CryptographicException("طول کلید AES نامعتبر است");
            var nonce = new byte[NonceLength];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(nonce);

            var cipher = new GcmBlockCipher(new AesEngine());
            cipher.Init(true, new AeadParameters(new KeyParameter(key), TagBits, nonce, aad ?? new byte[0]));
            var output = new byte[cipher.GetOutputSize(plaintext.Length)];
            var len = cipher.ProcessBytes(plaintext, 0, plaintext.Length, output, 0);
            len += cipher.DoFinal(output, len);

            var result = new byte[NonceLength + len];
            Buffer.BlockCopy(nonce, 0, result, 0, NonceLength);
            Buffer.BlockCopy(output, 0, result, NonceLength, len);
            return result;
        }

        public static byte[] Decrypt(byte[] key, byte[] payload, byte[] aad = null)
        {
            if (payload == null || payload.Length < NonceLength + 16)
                throw new CryptographicException("داده رمزنگاری‌شده نامعتبر است");
            var nonce = new byte[NonceLength];
            Buffer.BlockCopy(payload, 0, nonce, 0, NonceLength);
            var cipherText = new byte[payload.Length - NonceLength];
            Buffer.BlockCopy(payload, NonceLength, cipherText, 0, cipherText.Length);

            var cipher = new GcmBlockCipher(new AesEngine());
            cipher.Init(false, new AeadParameters(new KeyParameter(key), TagBits, nonce, aad ?? new byte[0]));
            var output = new byte[cipher.GetOutputSize(cipherText.Length)];
            var len = cipher.ProcessBytes(cipherText, 0, cipherText.Length, output, 0);
            len += cipher.DoFinal(output, len);
            if (len == output.Length)
                return output;
            var trimmed = new byte[len];
            Buffer.BlockCopy(output, 0, trimmed, 0, len);
            return trimmed;
        }

        /// <summary>رمزنگاری فایل‌به‌فایل بدون نگه داشتن کل محتوا در RAM.</summary>
        public static void EncryptFile(byte[] key, string inputPath, string outputPath, byte[] aad = null)
        {
            if (key == null || key.Length != AppConstants.AesKeyLength)
                throw new CryptographicException("طول کلید AES نامعتبر است");
            var nonce = new byte[NonceLength];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(nonce);

            var cipher = new GcmBlockCipher(new AesEngine());
            cipher.Init(true, new AeadParameters(new KeyParameter(key), TagBits, nonce, aad ?? new byte[0]));
            var inBuf = new byte[StreamChunk];
            var outBuf = new byte[cipher.GetUpdateOutputSize(StreamChunk) + 32];

            using (var input = new FileStream(inputPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
            using (var output = new FileStream(outputPath, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                output.Write(nonce, 0, nonce.Length);
                int read;
                while ((read = input.Read(inBuf, 0, inBuf.Length)) > 0)
                {
                    var n = cipher.ProcessBytes(inBuf, 0, read, outBuf, 0);
                    if (n > 0)
                        output.Write(outBuf, 0, n);
                }
                var final = cipher.DoFinal(outBuf, 0);
                if (final > 0)
                    output.Write(outBuf, 0, final);
            }
        }

        public static void DecryptFile(byte[] key, string inputPath, string outputPath, byte[] aad = null)
        {
            if (key == null || key.Length != AppConstants.AesKeyLength)
                throw new CryptographicException("طول کلید AES نامعتبر است");
            using (var input = new FileStream(inputPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
            {
                if (input.Length < NonceLength + 16)
                    throw new CryptographicException("داده رمزنگاری‌شده نامعتبر است");
                var nonce = new byte[NonceLength];
                if (input.Read(nonce, 0, NonceLength) != NonceLength)
                    throw new CryptographicException("داده رمزنگاری‌شده نامعتبر است");

                var cipher = new GcmBlockCipher(new AesEngine());
                cipher.Init(false, new AeadParameters(new KeyParameter(key), TagBits, nonce, aad ?? new byte[0]));
                var inBuf = new byte[StreamChunk];
                var outBuf = new byte[cipher.GetUpdateOutputSize(StreamChunk) + 32];

                using (var output = new FileStream(outputPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    int read;
                    while ((read = input.Read(inBuf, 0, inBuf.Length)) > 0)
                    {
                        var n = cipher.ProcessBytes(inBuf, 0, read, outBuf, 0);
                        if (n > 0)
                            output.Write(outBuf, 0, n);
                    }
                    var final = cipher.DoFinal(outBuf, 0);
                    if (final > 0)
                        output.Write(outBuf, 0, final);
                }
            }
        }
    }
}
