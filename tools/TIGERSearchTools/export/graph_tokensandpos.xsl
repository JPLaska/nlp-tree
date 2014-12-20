<?xml version="1.0" encoding="ISO-8859-1"?>


 <!-- ===============================================================
      Conversion of the XML-format into id + sentence + pos format
      Ex: 
      negra_1: Mögen/VMFIN Puristen/NN aller/PIDAT Musikbereiche/NN ...
      ===============================================================
 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xlink="http://www.w3.org/1999/xlink"
                              xmlns:xml="http://www.w3.org/XML/1998/namespace"
>

 
 <xsl:output method="text" encoding="ISO-8859-1" />


 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

 </xsl:template>



 <!-- Sentence node: print id and process root node of the sentence -->

 <xsl:template match="s">

   <!-- print ID -->
   <xsl:value-of select="@id"/>
   <xsl:text>: </xsl:text>


   <xsl:apply-templates select="graph/terminals/t"/>
   <xsl:text>&#10;&#10;</xsl:text>
 
 </xsl:template>



 <xsl:template match="t">

   <xsl:value-of select="@word"/>
   <xsl:text>/</xsl:text>

   <xsl:value-of select="@pos"/>
   <xsl:text></xsl:text>

   <xsl:if test="position()!=last()">
      <xsl:text> </xsl:text>
   </xsl:if>

 </xsl:template>


 
</xsl:stylesheet>
