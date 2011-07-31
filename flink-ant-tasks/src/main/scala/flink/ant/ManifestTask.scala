package flink.ant

import java.io.File

import scala.collection.mutable.ArrayBuffer

import org.apache.tools.ant.types.resources.FileResource
import org.apache.tools.ant.types.FileSet
import org.apache.tools.ant.Task

import flink.core.ManifestWriter

class ManifestTask extends Task {
  var flashDir = ""
  var targetFile = ""
  var filesets = new ArrayBuffer[FileSet]()
    
  override def execute() = {
    val mainDir = new File(flashDir)
    val filesBuffer = new ArrayBuffer[File]()

    for (fileset <- filesets) {
      val iterator = fileset.iterator
      while (iterator.hasNext) {
        var file: FileResource = iterator.next.asInstanceOf[FileResource]
        filesBuffer += file.getFile
      }
    }
    
    val files = new Array[File](filesBuffer.length)
    filesBuffer.copyToArray(files)
    
    ManifestWriter.write(mainDir, targetFile, files)
  }
  
  def setFlashDir(value: String) {
    flashDir = value
  }
  
  def setTargetFile(value: String) {
    targetFile = value
  }

  def addFileset(fileset: FileSet) {
    filesets += fileset;
  }
}