<?xml version="1.0"?>

<!--
 * mod_dav_svn xsl2html index transformation script
 * derived from the subversion distrib files
 *
 * @author glaszig at gmail dot com
 * @link github.com/glaszig
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html"/>

  <!-- DEFINE YOUR SVN WEB ROOT BELOW -->
  <xsl:variable name="svnroot" select="'/'" />

  <xsl:template match="*"/>

  <xsl:template match="svn">
    <html>
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <xsl:value-of select="index/@base" />
          <xsl:if test="string-length(index/@name) != 0">
            <xsl:value-of select="index/@name"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="index/@path"/>
        </title>
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous" />
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script type="text/javascript" src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" type="text/css" href="//raw.githubusercontent.com/pduh/svn/master/svnindex/svnindex.css"/>
<style>
.dir, .file { margin-top: 1em;  margin-bottom: 1em; }
</style>
      </head>
      <body>
        <div class="svn">
          <xsl:apply-templates/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="index">
    <h3 class="path">
      <xsl:if test="@base">
        <xsl:element name="a">
          <xsl:attribute name="href">/</xsl:attribute>
          <xsl:attribute name="class">glyphicon glyphicon-home</xsl:attribute>
        </xsl:element>
      </xsl:if>
      <xsl:call-template name="SplitText">
        <xsl:with-param name="inputString" select="substring(concat(@base, @path), 1)"/>
        <xsl:with-param name="lastPart" select="substring($svnroot, 2)"/>
      </xsl:call-template>
    </h3>
    <ul>
      <xsl:apply-templates select="dir"/>
      <xsl:apply-templates select="file"/>
    </ul>

  </xsl:template>

  <xsl:template match="dir">
    <li class="dir">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:attribute name="class">text-primary</xsl:attribute>
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:element>
    </li>
  </xsl:template>

  <xsl:template match="file">
    <li class="file">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:attribute name="class">text-success</xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </li>
  </xsl:template>

  <xsl:template name="SplitText">
    <xsl:param name="inputString"/>
    <xsl:param name="lastPart" />

    <xsl:choose>
      <xsl:when test="substring-after($inputString,'/') != ''">
        /
        <xsl:call-template name="insertAnchor">
          <xsl:with-param name="url" select="concat($lastPart, '/', substring-before($inputString,'/'))"/>
          <xsl:with-param name="title" select="substring-before($inputString,'/')"/>
        </xsl:call-template>

        <!-- recursion -->
        <xsl:call-template name="SplitText">
          <xsl:with-param name="inputString" select="substring-after($inputString,'/')"/>
          <xsl:with-param name="lastPart" select="concat($lastPart, '/',  substring-before($inputString,'/'))" />
        </xsl:call-template>

      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$inputString = ''">
            <xsl:text>...</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- last recursion -->
            <span class="pseudo">
              <xsl:if test="@base">
              /
              </xsl:if>
              <xsl:value-of select="translate($inputString, '/', '')"/>
              <xsl:if test="@base">
                <span class="badge">
                  <xsl:value-of select="@rev"/>
                </span>
              </xsl:if>
              </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- template for inserting an html a element -->
  <xsl:template name="insertAnchor">
    <xsl:param name="url" />
    <xsl:param name="title" />

    <xsl:element name="a">
      <!-- href attribute -->
      <xsl:attribute name="href">
        <xsl:value-of select="$url"/>
      </xsl:attribute>
      <xsl:value-of select="$title"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>