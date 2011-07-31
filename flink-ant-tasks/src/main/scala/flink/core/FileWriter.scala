package flink.core

import java.io.DataOutput

object FileWriter {
  
  /**
   * Stream format:
   * 	integer		size fileName
   * 	bytes		fileName
   * 	boolean		compressed
   * 	integer		size content
   * 	bytes		content
   */
  def write(outputStream: DataOutput, fileData: FileData) = {
    val sourceUrlBytes = fileData.sourceUrl.getBytes("UTF8")
    outputStream.writeInt(sourceUrlBytes.size)
    outputStream.write(sourceUrlBytes)
    outputStream.writeInt(fileData.targetBytes.size)
    outputStream.write(fileData.targetBytes)
  }
}