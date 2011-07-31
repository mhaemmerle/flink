package flink.util

import scala.util.control.Breaks._
import java.io.File
import java.util.regex.Pattern

object RelativePathFinder {

  def getRelativePath(targetPath: String, basePath: String, pathSeparator: String): String = {
    val base = basePath.split(Pattern.quote(pathSeparator), -1);
    val target = targetPath.split(Pattern.quote(pathSeparator), 0);

    var common = ""
    var commonIndex = 0

    def findCommon {
      for (i <- 0 until target.length if i < base.length) {
        if (target(i).equals(base(i))) {
          common += target(i) + pathSeparator
          commonIndex += 1
        } else {
          return
        }
      }
    }

    findCommon

    if (commonIndex == 0)
      targetPath

    var relative: String = ""
    if (commonIndex != base.length) {
      val numDirsUp = base.length - commonIndex - 1;
      for (i <- 1 to numDirsUp) {
        relative += ".." + pathSeparator
      }
    }

    relative += targetPath.substring(common.length())
    relative
  }

  def getRelativePath(targetPath: String, basePath: String): String = {
    getRelativePath(targetPath, basePath, System.getProperty("file.separator"))
  }
}