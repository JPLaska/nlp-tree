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

 <xsl:key name="idkey" match="t|nt" use="@id"/>



 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

 </xsl:template>



 <xsl:template match="s">

   <xsl:apply-templates select="graph/nonterminals/nt" mode="follow" />
 
 </xsl:template>



 <xsl:template match="nt" mode="follow">

   <xsl:value-of select="@cat" />
   <xsl:text> -> </xsl:text>

   <xsl:apply-templates select="edge" />

   <xsl:text>&#10;</xsl:text>

 </xsl:template>



 <xsl:template match="edge">

   <xsl:apply-templates select="key('idkey',@idref)" mode="print" />

 </xsl:template>



 <xsl:template match="nt" mode="print">

   <xsl:value-of select="@cat" />
   <xsl:text> </xsl:text>

 </xsl:template>



 <xsl:template match="t" mode="print">

   <xsl:value-of select="@pos" />
   <xsl:text> </xsl:text>

 </xsl:template>


 
</xsl:stylesheet>
