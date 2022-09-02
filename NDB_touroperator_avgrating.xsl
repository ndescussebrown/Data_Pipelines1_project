<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ndb="http://NDBtouroperator.fr/myvocabulary#">
  <!-- THIS STYLESHEET RETURNS TOUR RATINGS AVERAGES PER CONTINENT -->
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:key name="keycontinent" match="//ndb:CONTINENT" use="@contid" /> 
  <xsl:key name="refcontinent" match="ndb:TOUR/ndb:DEST_CONTINENT" use="@contidref" /> 
  <xsl:key name="keytype" match="//ndb:TYPE" use="@typeid" /> 
  <xsl:key name="reftype" match="ndb:TOUR/ndb:TOUR_TYPE" use="@typeidref" /> 
  <xsl:key name="keybudget" match="//ndb:BUDGET" use="@budgid" /> 
  <xsl:key name="refbudget" match="ndb:TOUR/ndb:TOUR_BUDGET" use="@budgidref" /> 
  <xsl:key name="keycountry" match="//ndb:COUNTRY" use="@countid" /> 
  <xsl:key name="refcountry" match="ndb:TOUR/ndb:DEST_CONTINENT/ndb:DEST_COUNTRY" use="@countidref" /> 
  <xsl:key name="keyguide" match="//ndb:GUIDE" use="@guideid" /> 
  <xsl:key name="refguide" match="ndb:TOUR/ndb:INSTANCES/ndb:INSTANCE/ndb:TOURGUIDE" use="@guideref" /> 
  
  
  <xsl:template match="/" >
    <html>
    <body>
	<xsl:apply-templates select="//ndb:TOURS"/>
    </body>
    </html>
  </xsl:template>
  
  
  
  <xsl:template match="//ndb:TOURS">
  	<h1>Average Tour rating Per Continent</h1>
	<xsl:for-each select="ndb:CONTINENT">
		<xsl:variable name="contparam" select="@contid" />
		<li>
		<xsl:text>For continent </xsl:text><xsl:value-of select="." /><xsl:text>, the average tour rating is: </xsl:text>
		<xsl:choose>
			  <xsl:when test="count(//ndb:TOUR[ndb:DEST_CONTINENT[@contidref=$contparam]]/ndb:RATINGS) = 0">
				<xsl:text>No tour or rating available yet</xsl:text><br/><br/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="round((sum(//ndb:TOUR[ndb:DEST_CONTINENT[@contidref=$contparam]]/ndb:RATINGS/ndb:RATING)div(count(//ndb:TOUR[ndb:DEST_CONTINENT[@contidref=$contparam]]/ndb:RATINGS/ndb:RATING)))*10)div(10)"/><br/><br/>
			  </xsl:otherwise>
		</xsl:choose>
		</li>
		</xsl:for-each>
  </xsl:template>
  
  
    
  
  	<xsl:template match="ndb:DEST_CONTINENT">
			<xsl:variable name="contparam" select="@contidref" />
			<xsl:apply-templates select="//ndb:CONTINENT[@contid=$contparam]" />
	</xsl:template>
	
	<xsl:template match="ndb:CONTINENT[@contid]">
			<xsl:value-of select='.'/>
	</xsl:template> 

	<xsl:template match="ndb:RATING">
			<xsl:value-of select='.'/>
	</xsl:template> 

</xsl:stylesheet>
