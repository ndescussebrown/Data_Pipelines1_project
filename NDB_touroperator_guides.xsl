<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ndb="http://NDBtouroperator.fr/myvocabulary#">
	<xsl:output method="xml" indent="yes"/>
<!-- THIS STYLESHEET RETURNS ALL GUIDES WITH THEIR ID AND NAME AND ALL TOURS THAT THEY HAVE ASSIGNED TO THEM-->

  <xsl:template match="/" >
    <GUIDES>
	<xsl:apply-templates select="//ndb:TOURS"/>
    </GUIDES>
  </xsl:template>

	<xsl:template match="//ndb:TOURS">

	<xsl:for-each select="//ndb:GUIDE">
		<GUIDE>
		<xsl:variable name="guideparam" select="@guideid" /> 
		<ID>
		<xsl:attribute name="id" >
				<xsl:value-of select="@guideid"/>
			</xsl:attribute >
		</ID>
		<GUIDE_NAME>
				<xsl:value-of select="."/>
		</GUIDE_NAME>
		<xsl:for-each select="//ndb:TOUR[ndb:INSTANCES/ndb:INSTANCE/ndb:TOURGUIDE[@guideref=$guideparam]]">
			<TOUR>
				<xsl:value-of select="ndb:TOURNAME"/>
			</TOUR>
		</xsl:for-each>
		<xsl:if test="count(//ndb:TOUR[ndb:INSTANCES/ndb:INSTANCE/ndb:TOURGUIDE[@guideref=$guideparam]])=0" >
			<TOUR>This guide doesn't have any tour assigned</TOUR>
		</xsl:if>
		</GUIDE>
	</xsl:for-each>

  </xsl:template>
  
  
  
  </xsl:stylesheet>