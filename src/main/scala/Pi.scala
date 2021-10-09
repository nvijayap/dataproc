package com.example

import sys.process._
import scala.math.random
import org.apache.spark.sql.SparkSession

/**
 * Computes an approximation to pi
 */
object Pi {

  def main(args: Array[String]): Unit = {

    val spark = SparkSession.builder.appName("Spark Pi").getOrCreate()

    val slices = if (args.length > 0) args(0).toInt else 2

    val n = math.min(100000L * slices, Int.MaxValue).toInt // avoid overflow

    val sparkContext = spark.sparkContext

    val sparkVersion = sparkContext.version

    val scalaVersion = util.Properties.versionNumberString

    val javaVersion = System.getProperty("java.version")

    val os = "cat /etc/os-release" !!

    val count = sparkContext.parallelize(1 until n, slices).map { i =>
      val x = random * 2 - 1
      val y = random * 2 - 1
      if (x*x + y*y <= 1) 1 else 0
    }.reduce(_ + _)

    println("=======================================================================================")
    val versions = s"Spark ${sparkVersion}, Scala ${scalaVersion}, Java ${javaVersion} on -\n\n${os}"
    println(s"Pi is roughly ${4.0 * count / (n - 1)} - Computed using ${versions}")
    println("=======================================================================================")

    spark.stop()
  }

}
