<?xml version="1.0"?>

<!--
 * @author peterduh at gmail dot com
 * @link github.com/pduh/svn
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html"
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    omit-xml-declaration="yes"
    encoding="UTF-8"
    indent="yes" />

  <xsl:template match="*"/>

<!-- svn -->

  <xsl:template match="svn">
    <html>
      <head>
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
        <link type="text/css" rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link type="text/css" rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous" />
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script type="text/javascript" src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <!-- link type="text/css" rel="stylesheet" href="/svn/svnindex/svnindex.css" / -->
<style>
.updir{list-style-type:none;}
.dir{list-style-type:disc;}
.file{list-style-type:circle;}
.dir, .file {margin-top:1em;margin-bottom:1em;}
</style>
      </head>
      <body>
        <div class="svn">
          <xsl:apply-templates/>
        </div>
      </body>
    </html>
  </xsl:template>

<!-- index -->

  <xsl:template match="index">

    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <xsl:if test="@base != '' and @path != '/'">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-navbar-collapse-1" aria-expanded="false">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
          </xsl:if>
          <a class="navbar-brand" href="/"><span class="glyphicon glyphicon-home"></span></a>
          <xsl:if test="@base != ''">
            <xsl:call-template name="updir_link" />
            <xsl:call-template name="CurLink"/>
            <a class="navbar-brand visible-xs-block"><span class="badge"><xsl:value-of select="@rev"/></span></a>
          </xsl:if>
        </div>

        <div class="collapse navbar-collapse" id="bs-navbar-collapse-1">
          <ul class="nav navbar-nav">
            <xsl:call-template name="NavLink"/>
            <xsl:if test="@base != ''">
              <li class="hidden-xs">
                <p class="navbar-text"><span class="badge"><xsl:value-of select="@rev"/></span></p>
              </li>
            </xsl:if>
          </ul>
        </div>
      </div>
    </nav>

    <ul>
      <xsl:apply-templates select="updir"/>
      <xsl:apply-templates select="dir"/>
      <xsl:apply-templates select="file"/>
    </ul>

  </xsl:template>

<!-- updir_link -->

  <xsl:template name="updir_link">
    <xsl:element name="a">
      <xsl:attribute name="class">glyphicon glyphicon-arrow-left navbar-brand visible-xs-block</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="/svn/index/updir/@href"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

<!-- updir -->

  <xsl:template match="updir">
    <xsl:element name="li">
      <xsl:attribute name="class">updir hidden-xs</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="class">glyphicon glyphicon-arrow-left</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>

  </xsl:template>

<!-- dir -->

  <xsl:template match="dir">
    <xsl:element name="li">
      <xsl:attribute name="class">dir</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="class">text-primary</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>

<!-- file -->

  <xsl:template match="file">
    <xsl:element name="li">
      <xsl:attribute name="class">file</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="class">text-success</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

<!-- NavLink -->

  <xsl:template name="NavLink">
    <xsl:call-template name="breadcrumbs">
      <xsl:with-param name="str" select="concat(@base, @path)" />
      <xsl:with-param name="sep" select="'/'" />
      <xsl:with-param name="bas" select="''" />
    </xsl:call-template>
  </xsl:template>

<!-- breadcrumbs -->

  <xsl:template name="breadcrumbs">
    <xsl:param name="str" />
    <xsl:param name="sep" />
    <xsl:param name="bas" />
    <xsl:variable name="first-item"
      select="normalize-space( substring-before( concat( $str, $sep), $sep))" />
    <xsl:variable name="rest" select="normalize-space( substring-after( $str, $sep))" />

    <xsl:if test="$first-item">
      <xsl:element name="li">
        <xsl:element name="a">
          <xsl:if test="$rest = ''">
            <xsl:attribute name="class">hidden-xs</xsl:attribute>
          </xsl:if>
          <xsl:if test="@base != ''">
            <xsl:attribute name="href">
              <xsl:value-of select="concat($bas, '/', $first-item)"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$first-item" />
        </xsl:element>
      </xsl:element>

      <xsl:call-template name="breadcrumbs">
        <xsl:with-param name="str" select="$rest" />
        <xsl:with-param name="sep" select="$sep"/>
        <xsl:with-param name="bas" select="concat($bas, '/', $first-item)"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>


<!-- CurLink  -->

  <xsl:template name="CurLink">
   <xsl:call-template name="get_last_item">
     <xsl:with-param name="str" select="concat(@base,@path)" />
     <xsl:with-param name="sep" select="'/'" />
     <xsl:with-param name="bas" select="''" />
   </xsl:call-template>

  </xsl:template>

<!-- get_item -->

  <xsl:template name="get_last_item">
    <xsl:param name="str" />
    <xsl:param name="sep" />
    <xsl:param name="bas" />

    <xsl:variable name="first-item"
      select="normalize-space( substring-before( concat( $str, $sep), $sep))" />
    <xsl:variable name="rest" select="normalize-space( substring-after( $str, $sep))" />
    <xsl:if test="$first-item">
      <xsl:choose>

        <xsl:when test="$rest = ''">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat($bas, '/', $first-item)"/>
              </xsl:attribute>
              <xsl:attribute name="class">navbar-brand visible-xs-block</xsl:attribute>
              <xsl:value-of select="$first-item" />
            </xsl:element>
        </xsl:when>

        <xsl:otherwise>
          <xsl:call-template name="get_last_item">
            <xsl:with-param name="str" select="$rest"/>
            <xsl:with-param name="sep" select="$sep"/>
            <xsl:with-param name="bas" select="concat($bas, '/', $first-item)"/>
          </xsl:call-template>
        </xsl:otherwise>

      </xsl:choose>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
