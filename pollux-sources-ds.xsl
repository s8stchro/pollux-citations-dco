<?xml version="1.0" encoding="UTF-8"?>
<!--
Authors: Dr. Stelianos Chronopulous, Dirk Spöri
Summary: This script extracts all authors and groups of authors, grouped by book and section.
Version: 2023-06-10

Input:
The input must be an XML file with XML nodes annotating the sections, milestones and author(s).
The XML annotation format has been defined by Dr. Stelianos Chronopulous.

Output:
The output is a comma-separated CSV file with the columns:
- source: cited authority
- type: Indication if single author or group of authors
- segment-nr: @n of the milestone the cited source is part of
- book-nr: @n of the div3 the cited source is part of
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="text" encoding="UTF-8"/>
    <!-- modify to use a different column separator -->
    <xsl:variable name="separator" select="','"/>

    <xsl:template match="TEI">

      <!-- print column titles -->
      <xsl:text>Source</xsl:text>
      <xsl:value-of select="$separator"/>
      <xsl:text>Type</xsl:text>
      <xsl:value-of select="$separator"/>
      <xsl:text>segement-nr</xsl:text>
      <xsl:value-of select="$separator"/>
      <xsl:text>book-nr</xsl:text>

      <!-- new line -->
      <xsl:text>&#xA;</xsl:text>

      <!-- iterate over all references to persons or groups -->
      <xsl:for-each select="/TEI/text/body//*[name()='persName' or name()='orgName' or (name()='milestone' and not(@edRef='#lh1706'))]">
        <xsl:call-template name="author">
          <xsl:with-param name="separator"><xsl:value-of select="$separator"/></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:template>

    <!-- output formatted row -->
    <xsl:template name="author">
      <xsl:param name="separator"/>
      <xsl:variable name="self" select="."/>
      <xsl:variable name="ref" select="$self/@ref"/>

      <!-- source (author(s)'s ref) -->
      <xsl:value-of select="translate(replace($ref, ' #', ' or '), '#', '')"/>
      <xsl:value-of select="$separator"/>

      <!-- type -->
      <xsl:choose>
        <!-- single author -->
        <xsl:when test="$self/name()='persName'">
          <xsl:text>individual</xsl:text>
        </xsl:when>

        <!-- group of authors-->
        <xsl:when test="$self/name()='orgName'">
          <xsl:text>group</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$separator"/>

      <!-- section-nr -->
      <xsl:choose>
        <xsl:when test="$self/name()='milestone'">
          <xsl:value-of select="@n"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="preceding::milestone[1]/@n"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:value-of select="$separator"/>

      <!-- book-nr -->
      <xsl:value-of select="ancestor::div3/@n"/>

      <!-- new line -->
      <xsl:text>&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>