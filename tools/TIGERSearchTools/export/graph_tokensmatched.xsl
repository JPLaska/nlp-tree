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

 <xsl:key name="idkey" match="t|nt" use="@id"/>



 <!-- Sentence node: print id and process root node of the sentence -->


 <xsl:template match="corpus">

   <xsl:apply-templates select="body/s" />

 </xsl:template>



 <xsl:template match="s" >

   <xsl:text>Corpus graph: </xsl:text>
   <xsl:value-of select="@id" />
   <xsl:text>&#10;&#10;</xsl:text>

   <xsl:for-each select="matches/match">

     <xsl:apply-templates select="//s/graph/terminals/t" mode="terminals">

       <xsl:with-param name="matchroot" select="@subgraph"/>

     </xsl:apply-templates>

     <xsl:text>&#10;&#10;</xsl:text>

   </xsl:for-each>
 
 </xsl:template>



 <xsl:template match="t" mode="terminals">

   <xsl:param name="matchroot"/>

   <xsl:apply-templates select="key('idkey',$matchroot)" mode="find">

     <xsl:with-param name="tofind" select="@id" />

   </xsl:apply-templates>

 </xsl:template>



 <xsl:template match="t" mode="find">

   <xsl:param name="tofind"/>

   <xsl:if test="@id=$tofind">

     <xsl:value-of select="@word" />
     <xsl:text> </xsl:text>

   </xsl:if>

 </xsl:template>



 <xsl:template match="nt" mode="find">

   <xsl:param name="tofind"/>

   <xsl:for-each select="edge">

     <xsl:apply-templates select="key('idkey',@idref)" mode="find">

       <xsl:with-param name="tofind" select="$tofind" />

     </xsl:apply-templates>

   </xsl:for-each>

 </xsl:template>


 
</xsl:stylesheet>
