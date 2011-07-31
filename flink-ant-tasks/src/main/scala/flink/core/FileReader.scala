package flink.core

import java.io.{DataInput, InputStreamReader, ByteArrayInputStream}

object FileReader {
  
  def read(inputStream: DataInput) = {
    var fileData: FileData = new FileData
    val urlSize: Int = inputStream.readInt()
    val urlBytes: Array[Byte] = new Array(urlSize)
    inputStream.readFully(urlBytes, 0, urlSize)
    fileData.sourceUrl = new String(urlBytes, "UTF-8")
    val dataLength: Int = inputStream.readInt()
    val bytes: Array[Byte] = new Array(dataLength)
    inputStream.readFully(bytes, 0, dataLength)
    fileData.targetBytes = bytes
    
    fileData
  }
}