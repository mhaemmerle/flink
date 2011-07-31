package flink.ant

import flink.util.RelativePathFinder
import java.io.File
import org.apache.tools.ant.Task
import org.apache.tools.ant.types.FileSet
import org.apache.tools.ant.types.resources.FileResource
import scala.collection.mutable.ArrayBuffer
import flink.core.PackageWriter

class PackTask extends Task {
  var compress = true
  var flashDir = ""
  var targetFile = ""
  var filesets = new ArrayBuffer[FileSet]()

  override def execute() {
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
    
    PackageWriter.write(mainDir, targetFile, files, compress)
  }

  def setCompress(value: Boolean) {
    compress = value
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