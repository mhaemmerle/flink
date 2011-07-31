package flink.core

import java.io.{FileInputStream, DataOutputStream, FileOutputStream, ByteArrayOutputStream}
import java.io.File
import flink.util.RelativePathFinder

object PackageWriter {
  def write(baseDir: File, targetUrl: String, files: Array[File], compress: Boolean) = {
    val relativeTargetFile = RelativePathFinder.getRelativePath(new File(targetUrl).getCanonicalPath, baseDir.getCanonicalPath)
    println("Create package '" + relativeTargetFile + "'")
    
    val outputStream = new DataOutputStream(new FileOutputStream(targetUrl))
    outputStream.writeInt(files.length)
    outputStream.writeBoolean(compress)
    
    var totalSourceSize:Int = 0
    var totalTargetSize:Int = 0
    
    for (i <- 0 until files.length) {
      val sourceBytes = getBytesFrom(files(i).getAbsolutePath)
      var targetBytes = sourceBytes

      if (compress)
        targetBytes = Compressor.compress(sourceBytes)

      val relativeFileUrl = RelativePathFinder.getRelativePath(files(i).getCanonicalPath, baseDir.getCanonicalPath)
      val fileData = new FileData
      fileData.sourceUrl = relativeFileUrl
      fileData.targetBytes = targetBytes
      
      FileWriter.write(outputStream, fileData)
      
      printFileAdded(relativeFileUrl, sourceBytes, targetBytes, compress)
      
      totalSourceSize += sourceBytes.length
      totalTargetSize += targetBytes.length
    }
    
    outputStream flush
    
    println("DONE " + files.length + " files, " + getCompressionString(totalSourceSize, totalTargetSize))
  }

  private def getBytesFrom(sourceUrl: String) = {
    val input = new FileInputStream(sourceUrl)
    val output = new ByteArrayOutputStream
    val buffer = new Array[Byte](0x8000)
    var bytesRead = 0

    bytesRead = input.read(buffer)

    while (bytesRead >= 0) {
      output.write(buffer, 0, bytesRead)
      bytesRead = input.read(buffer)
    }

    output.close()
    output.toByteArray()
  }
  
  private def printFileAdded(sourceUrl: String, sourceBytes: Array[Byte], targetBytes: Array[Byte], compressed: Boolean) = {
    val uncompressedSize = sourceBytes.size
    val compressedSize = targetBytes.size
	
    println(" + '" + sourceUrl + "': " + getCompressionString(uncompressedSize, compressedSize))
  }
  
  private def getCompressionString(uncompressedSize: Int, compressedSize: Int) = {
     val compressionRate = 100 - (compressedSize.toFloat * 100 / uncompressedSize.toFloat).toInt;
     var output = uncompressedSize / 1024 + "Kb"
     if (compressedSize < uncompressedSize) {
    	 output += " -> " + compressedSize / 1024 + "Kb (" + compressionRate + "%)"
     }
     output
  }
}