<?xml version="1.0" encoding="ISO-8859-1"?>


 <!-- ===============================================================
      Conversion of the XML-format into bracketing format
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

   <xsl:apply-templates select="body/s"/>

 </xsl:template>


 <!-- Sentence node: print id and process root node of the sentence -->

 <xsl:template match="s">

   <xsl:text>%% Sentence </xsl:text>
   <xsl:value-of select="@id"/>
   <xsl:text>&#x0A;&#x0A;(</xsl:text>

   <xsl:apply-templates select="graph"/>

   <xsl:text> )&#x0A;&#x0A;</xsl:text>
 
 </xsl:template>



 <xsl:template match="graph">

   <xsl:apply-templates select="key('idkey',@root)"/>
 
 </xsl:template>



 <!-- Inner node: print all feature values and edge label, and process node childs -->

 <xsl:template match="nt">

  <xsl:param name="label"></xsl:param>

  <xsl:text>&#x20;(</xsl:text>


     <xsl:for-each select="attribute::*">

       <xsl:if test="local-name(.) != 'id'">

         <xsl:value-of select="."/>

         <xsl:if test="position()!=last()">
           <xsl:text>-</xsl:text>
         </xsl:if>

       </xsl:if>

     </xsl:for-each>


  <xsl:if test="$label and (string-length($label)>0) and ($label!='--')">
     <xsl:text>-</xsl:text>
     <xsl:value-of select="$label"/>
  </xsl:if>

  <xsl:apply-templates select="edge"/>

  <xsl:text>)</xsl:text>

 </xsl:template>



 <!-- Outer node: print feature values and edge label  -->

 <xsl:template match="t" >

  <xsl:param name="label"></xsl:param>

  <xsl:text>&#x20;(</xsl:text>
    
    <xsl:value-of select="@pos"/>

      <xsl:if test="$label and (string-length($label)>0) and ($label!='--')">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$label"/>
      </xsl:if>

    <xsl:text>&#x20;</xsl:text>
    <xsl:value-of select="@word"/>

  <xsl:text>)</xsl:text>

 </xsl:template>
 


 <!-- Edge label: Process child node, transfer label as parameter -->

 <xsl:template match="edge">

   <xsl:apply-templates select="key('idkey',@idref)">

     <xsl:with-param name="label"><xsl:value-of select="@label"/></xsl:with-param>
  
   </xsl:apply-templates>

 </xsl:template>


 
</xsl:stylesheet>
