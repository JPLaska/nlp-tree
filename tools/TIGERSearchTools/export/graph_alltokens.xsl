<?xml version="1.0" encoding="ISO-8859-1"?>


 <!-- ===============================================================
      Conversion of the XML-format into sentence format
      ===============================================================
      Wolfgang Lezius, IMS, University of Stuttgart, Germany, 05/2001
      =============================================================== -->



<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xlink="http://www.w3.org/1999/xlink"
                              xmlns:xml="http://www.w3.org/XML/1998/namespace"
>

 
 <xsl:output method="text" encoding="ISO-8859-1" />



 <!-- Sentence node: print id and process root node of the sentence -->


 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

 </xsl:template>



 <xsl:template match="s" >
 
   <xsl:text>Corpus graph: </xsl:text>
   <xsl:value-of select="@id" />
   <xsl:text>&#10;&#10;</xsl:text>

   <xsl:apply-templates select="graph/terminals/t" />

   <xsl:text>&#10;&#10;</xsl:text>
 
 </xsl:template>



 <xsl:template match="t" >

   <xsl:value-of select="@word"/>

   <xsl:if test="position()!=last()">
      <xsl:text> </xsl:text>
   </xsl:if>

 </xsl:template>


 
</xsl:stylesheet>
