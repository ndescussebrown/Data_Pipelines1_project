<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ndb="http://NDBtouroperator.fr/myvocabulary#">
	<xsl:output method="xml" indent="yes"/>
<!-- THIS STYLESHEET RETURNS ALL CLIENT WITH THEIR ID, NAME, TOURS THEY ARE BOOKED ON AND CORRESPONDING DATES -->

  <xsl:template match="/" >
    {"CLIENTS":[
	<xsl:apply-templates select="//ndb:TOURS"/>
  </xsl:template>

	<xsl:template match="//ndb:TOURS">

	<xsl:for-each select="//ndb:CLIENT">
		<xsl:variable name="clientparam" select="@clientid" /> 
		{"id": "<xsl:value-of select="@clientid"/>",
		"CLIENTNAME":
		{"LASTNAME": "<xsl:value-of select="ndb:CLIENTLASTNAME"/>",
		"FIRSTNAME": "<xsl:value-of select="ndb:CLIENTFIRSTNAME"/>"},
		"TOURS": [
		<xsl:for-each select="//ndb:TOUR[ndb:INSTANCES/ndb:INSTANCE/ndb:CLIENTS/ndb:TOURCLIENT[@clientref=$clientparam]]">
			{"TOURNAME": "<xsl:value-of select="ndb:TOURNAME"/>",
			"TOURDATE": "<xsl:value-of select="ndb:INSTANCES/ndb:INSTANCE/ndb:START_DATE"/>"}
			<xsl:if test="position() != last()">,</xsl:if>
			</xsl:for-each>
			]}
		<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
		]}
  </xsl:template>  
  </xsl:stylesheet>