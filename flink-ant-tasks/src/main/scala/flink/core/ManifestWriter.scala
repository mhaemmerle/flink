package flink.core

import java.io.{ DataInputStream, FileInputStream, File, FileOutputStream }
import scala.collection.mutable.ArrayBuffer
import flink.util.RelativePathFinder

object ManifestWriter {
  var output: String = ""
  var totalPackCount: Int = 0
  var totalFileCount: Int = 0

  def write(baseDir: File, targetUrl: String, packFiles: Array[File]) = {
    output = ""
    totalFileCount = 0
    totalPackCount = 0

    for (packFile <- packFiles)
      readPackage(baseDir, packFile)

    writeManifest(targetUrl)
    
    println("Manifest '" + targetUrl + "' created (listing " + totalPackCount + " packs with " + totalFileCount + " files)")
  }

  private def readPackage(baseDir: File, packFile: File) = {
    val packPath = packFile.getAbsolutePath()
    val relativePackUrl = RelativePathFinder.getRelativePath(packFile.getCanonicalPath, baseDir.getCanonicalPath)
    totalPackCount += 1
    writeLine("%%" + relativePackUrl)

    val inputStream = new DataInputStream(new FileInputStream(packPath))
    val fileAmount = inputStream.readInt
    val compressed = inputStream.readBoolean

    for (i <- 0 until fileAmount) {
      totalFileCount += 1
      writeLine(FileReader.read(inputStream).sourceUrl)
    }
  }

  private def writeManifest(targetUrl: String) = {
    val outputStream = new FileOutputStream(targetUrl)
    val bytes = output.getBytes

    outputStream.write(Compressor.compress(bytes))
    outputStream.flush
  }

  private def writeLine(line: String) = {
    output += line + "\r\n"
  }
}