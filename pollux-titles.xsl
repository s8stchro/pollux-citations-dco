<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
   <xsl:output method="text"/>
   <xsl:strip-space elements="*"/>
   
   <xsl:variable name="root" select="/"/>
   
   <!-- CSV Header -->
   <xsl:template match="/">
      <xsl:text>book-nr,section-nr,title-ref,title-text,author&#10;</xsl:text>
      <xsl:apply-templates select="//tei:ab//tei:title[@ref]|//tei:milestone[not(@edRef) or @edRef='#b1900' or @edRef='#b1931']"/>
   </xsl:template>
   
   <!-- Template for <title> elements within <ab> and with @ref -->
   <xsl:template match="tei:ab//tei:title[@ref]">
      <!-- Fetching the 'book-nr', 'section-nr' and 'title-ref' -->
      <xsl:value-of select="ancestor::tei:div3/@n"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="preceding::tei:milestone[not(@edRef) or @edRef='#b1900' or @edRef='#b1931'][1]/@n"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="@ref"/>
      <xsl:text>,</xsl:text>
      
      <!-- Fetching the 'title-text' from the header -->
      <xsl:variable name="currentRef" select="substring(tokenize(@ref, ' ')[1], 2)"/> <!-- Get the first @ref -->
      <xsl:value-of select="$root/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl[@xml:id=$currentRef]/tei:title"/>
      <xsl:text>,</xsl:text>
      
      <!-- Fetching 'author' -->
      <xsl:for-each select="tokenize(@ref, ' ')">
         <xsl:variable name="currentRef" select="substring(., 2)"/> <!-- Remove '#' from each @ref -->
         <xsl:variable name="authorRef" select="$root/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl[@xml:id=$currentRef]/tei:author/@ref"/>
         <xsl:value-of select="$root/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listPerson/tei:person[@xml:id=substring($authorRef, 2)]/tei:persName/@nymRef"/>
         <xsl:if test="position() != last()">
            <xsl:text> or </xsl:text>
         </xsl:if>
      </xsl:for-each>
      
      <xsl:text>&#10;</xsl:text> <!-- Newline after each entry -->
   </xsl:template>
   
   <!-- Template for milestone without @edRef or with @edRef="#b1900" or @edRef="#b1931" -->
   <xsl:template match="tei:milestone[not(@edRef) or @edRef='#b1900' or @edRef='#b1931']">
      <!-- Fetching the 'book-nr' and 'section-nr' -->
      <xsl:value-of select="ancestor::tei:div3/@n"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="@n"/>
      
      <xsl:text>&#10;</xsl:text> <!-- Newline after each entry -->
   </xsl:template>
</xsl:stylesheet>
