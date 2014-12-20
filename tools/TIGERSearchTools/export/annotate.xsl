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



 <!-- Corpus node: process root node of the sentence -->

 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

   <xsl:text> </xsl:text>

 </xsl:template>


 <!-- Sentence node: print graph number -->

 <xsl:template match="s" >
 
   <xsl:choose>

      <xsl:when test="starts-with(@id,'s')">
         <xsl:value-of select="substring-after(@id,'s')" />
      </xsl:when>

      <xsl:otherwise>
         <xsl:value-of select="@id" />
      </xsl:otherwise>

   </xsl:choose>

 </xsl:template>



</xsl:stylesheet>
