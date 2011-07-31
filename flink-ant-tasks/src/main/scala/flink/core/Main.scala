package flink.core

import java.io.{DataInputStream, FileInputStream, File}

object Main {
  val BASE_PATH = "../../ConfigPackerClient/bin/"

  def main(args: Array[String]) {
    println("Hello world");
    
    writePackage("packs/configurations.pack", "config", true)
    writePackage("packs/swfs.pack", "swf", false)
    
    writeManifest("packs/.manifest", "packs")
  }
  
  private def writePackage(targetUrl: String, sourceFolder: String, compress: Boolean = true) = {
    val files = recursiveListFiles(new File(BASE_PATH + sourceFolder))
    PackageWriter.write(new File(BASE_PATH), BASE_PATH + targetUrl, files, compress)
  }
  
  private def writeManifest(targetUrl: String, sourceFolder: String) = {
    val files = recursiveListFiles(new File(BASE_PATH + sourceFolder))
    ManifestWriter.write(new File(BASE_PATH), BASE_PATH + targetUrl, files)
  }

  private def recursiveListFiles(folder: File): Array[File] = {
    val these = folder.listFiles
    these ++ these.filter(_.isDirectory).flatMap(recursiveListFiles)
  }
}