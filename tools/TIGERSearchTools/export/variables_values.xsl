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

   <xsl:text>----- Sentence </xsl:text>
   <xsl:value-of select="@id"/>
   <xsl:text> -----&#10;</xsl:text>

   <xsl:apply-templates select="matches/match"/>

   <xsl:text>&#10;&#10;</xsl:text>
 
 </xsl:template>



 <xsl:template match="match">

   <xsl:text>Match </xsl:text>
   <xsl:value-of select="position()"/>
   <xsl:text>&#10;</xsl:text>

   <xsl:apply-templates select="variable"/>

 </xsl:template>


 <xsl:template match="variable">

   <xsl:value-of select="@name"/>
   <xsl:text>  :=  </xsl:text>

   <xsl:value-of select="@idref"/>
   <xsl:text>:[</xsl:text>

   <xsl:apply-templates select="key('idkey',@idref)"/>

   <xsl:text>]</xsl:text>
   <xsl:text>&#10;</xsl:text>

 </xsl:template>


 <xsl:template match="t|nt">

     <xsl:for-each select="attribute::*">

       <xsl:if test="local-name(.) != 'id'">

         <xsl:value-of select="local-name(.)"/>
         <xsl:text>=&quot;</xsl:text>
         <xsl:value-of select="."/>
         <xsl:text>&quot;</xsl:text>

         <xsl:if test="position()!=last()">
           <xsl:text> &amp; </xsl:text>
         </xsl:if>

       </xsl:if>

     </xsl:for-each>


 </xsl:template>


 
</xsl:stylesheet>
