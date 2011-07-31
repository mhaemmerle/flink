package flink.core

import java.io.ByteArrayOutputStream
import java.util.zip.Deflater

object Compressor {
  def compress(sourceBytes: Array[Byte]) = {
    val compressedBytes = new ByteArrayOutputStream
    val buffer = new Array[Byte](0x8000)
    var bytesCompressed = 0;

    val compressor = new Deflater(Deflater.BEST_COMPRESSION)
    compressor.setInput(sourceBytes)
    compressor.finish()

    do {
      bytesCompressed = compressor.deflate(buffer)
      compressedBytes.write(buffer, 0, bytesCompressed)
    } while (0 != bytesCompressed)

    compressedBytes.close()
    compressedBytes.toByteArray()
  }
}