<?xml version="1.0" encoding="ISO-8859-1"?>


 <!-- ===============================================================
      ===============================================================
 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xlink="http://www.w3.org/1999/xlink"
                              xmlns:xml="http://www.w3.org/XML/1998/namespace"
>

 
 <!-- Output format is text output encoded in ISO-8859-1 -->

 <xsl:output method="text" encoding="ISO-8859-1" />


 <!-- Unfortunately, the id() function to follow idref links sometimes
      does not work properly (depending on the XML parser).
      The key() function is used instead. It defines that a special
      function called idkey is working on @id attribute in t and nt elements. -->

 <xsl:key name="idkey" match="t|nt" use="@id"/>




 <!-- Root node -->

 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

 </xsl:template>


 <!-- Sentence node: print id and process root node of the sentence -->

 <xsl:template match="s">

   <!-- print sentence_id  -->
   <xsl:value-of select="@id"/>
   <xsl:text>:&#10;&#10;</xsl:text>

   <!-- print sentence -->
   <xsl:apply-templates select="graph/terminals/t"/>

   <!-- print matches -->
   <xsl:apply-templates select="matches/match"/>

   <xsl:text>&#10;</xsl:text>
   <xsl:text>----------------------------------------------------------</xsl:text>
   <xsl:text>&#10;</xsl:text>

 </xsl:template>
 


 <xsl:template match="match">
 <xsl:text>&#10;</xsl:text>

   <!-- print variable name -->
   <xsl:for-each select="variable">
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>:&#09;</xsl:text>

      <!-- look for string covered by variable -->
      <xsl:apply-templates select="key('idkey',@idref)"/>

   </xsl:for-each>
 </xsl:template>


 <!-- non-terminals: walk down the tree -->
 <xsl:template match="nt">
   <xsl:for-each select="edge">
     <xsl:apply-templates select="key('idkey',./@idref)"/>
   </xsl:for-each>
 </xsl:template>

 <!-- terminals: print words -->
 <xsl:template match="t">

   <xsl:value-of select="@word"/>
   <xsl:text> </xsl:text>
 </xsl:template>



</xsl:stylesheet>
