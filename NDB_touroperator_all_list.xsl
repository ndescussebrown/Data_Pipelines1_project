<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ndb="http://NDBtouroperator.fr/myvocabulary#">
<!-- THIS STYLESHEET RETURNS ALL AVAILABLE TOURS IN A SIMPLE TEXT FORMAT INCLUDING ALL AVAILABLE START DATES AND PRICE RANGE-->
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:key name="keycontinent" match="//ndb:CONTINENT" use="@contid" /> 
  <xsl:key name="refcontinent" match="ndb:TOUR/ndb:DEST_CONTINENT" use="@contidref" /> 
  <xsl:key name="keycountry" match="//ndb:COUNTRY" use="@countid" /> 
  <xsl:key name="refcountry" match="ndb:TOUR/ndb:DEST_CONTINENT/ndb:DEST_COUNTRY" use="@countidref" /> 
  <xsl:key name="keytype" match="//ndb:TYPE" use="@typeid" /> 
  <xsl:key name="reftype" match="ndb:TOUR/ndb:TOUR_TYPE" use="@typeidref" /> 
  <xsl:key name="keybudget" match="//ndb:BUDGET" use="@budgid" /> 
  <xsl:key name="refbudget" match="ndb:TOUR/ndb:TOUR_BUDGET" use="@budgidref" /> 
  <xsl:key name="keyguide" match="//ndb:GUIDE" use="@guideid" /> 
  <xsl:key name="refguide" match="ndb:TOUR/ndb:INSTANCES/ndb:INSTANCE/ndb:TOURGUIDE" use="@guideref" /> 
  
  <xsl:template match="/">
    <html>
      <head>
	<title>
	  La liste des tours
	</title>
      </head>
      <body style="background-color: #FFFF99;">
	<h1 style="color:#CE205F;text-align:center;font-size:300%;font-family:californian fb"><xsl:value-of select="count(//ndb:TOUR)" /> tours currently on offer by NDBTourOperators </h1><br/><br/>
	<blockquote style="color:#3B2FA2;text-align:left;font-size:100%;font-family:californian fb">
		<xsl:apply-templates select="//ndb:TOUR">	
			<xsl:sort select="ndb:TOURNAME" order="ascending"/>		
		</xsl:apply-templates>
	</blockquote>
      </body>
    </html>
  </xsl:template>
  
  
		<xsl:template match="ndb:TOUR">
	
			<xsl:apply-templates select="ndb:TOURNAME"/>
			<xsl:apply-templates select="ndb:DEST_CONTINENT/ndb:DEST_COUNTRY"/>
			<xsl:apply-templates select="ndb:TOUR_TYPE"/>
			<xsl:apply-templates select="ndb:TOUR_BUDGET"/>
			<xsl:apply-templates select="ndb:DURATION"/>
			<xsl:apply-templates select="ndb:INSTANCES" />
			<xsl:apply-templates select="ndb:FLIGHTS"/> 
			<xsl:apply-templates select="ndb:TRANSFERS"/> 
			<xsl:apply-templates select="ndb:RATINGS"/> 
			<xsl:apply-templates select="ndb:DESCRIPTION"/>
		</xsl:template>
  
		<xsl:template match="ndb:TOURNAME"> 
			<block style="color:#3B2FA2;text-align:left;font-size:150%;font-family:californian fb"><xsl:value-of select="."/></block><br/>
		</xsl:template> 
		<xsl:template match="ndb:DEST_CONTINENT/ndb:DEST_COUNTRY">
			<xsl:text> Where? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
			<xsl:variable name="countparam" select="@countidref" />
			<xsl:apply-templates select="//ndb:COUNTRY[@countid=$countparam]" /><br/>
		</xsl:template>
		<xsl:template match="ndb:TOUR_TYPE">
			<xsl:text> What? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="@typeid"/>
			<xsl:variable name="typeparam" select="@typeidref" />
			<xsl:apply-templates select="//ndb:TYPE[@typeid=$typeparam]" /><br/>
		</xsl:template> 
		<xsl:template match="ndb:TOUR_BUDGET">
			<xsl:text> Comfort? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="@budgid"/>
			<xsl:variable name="budgetparam" select="@budgidref" />
			<xsl:apply-templates select="//ndb:BUDGET[@budgid=$budgetparam]" /><br/>
		</xsl:template> 
		<xsl:template match="ndb:DESCRIPTION">
		<xsl:choose>
			  <xsl:when test=". = ''">
				<xsl:text> Details? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Coming soon!</xsl:text><xsl:value-of select="."/><br/><br/><hr/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:text> Details? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="."/><br/><br/><hr/>
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:template>
	

		<xsl:template match="ndb:START_DATE">
			<xsl:text> When do I leave? &#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="."/><br/>
		</xsl:template> 
		<xsl:template match="ndb:DURATION">
			<xsl:text> How long? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="."/><br/>
		</xsl:template> 
		
		


		<xsl:template match="ndb:INSTANCES">
			<xsl:text> What dates? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>  
			<xsl:variable name="listdate">
				<xsl:call-template name="ndb:ListDepartures">
					<xsl:with-param name="ListDepartures" select="ndb:INSTANCE/ndb:START_DATE" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$listdate" /><br/>
			
			<xsl:text> How much? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; from €</xsl:text>  
			<xsl:variable name="minprice">
				<xsl:call-template name="ndb:MinPrice">
					<xsl:with-param name="MinPrice" select="ndb:INSTANCE/ndb:PRICE" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$minprice" />
			<xsl:text> to €</xsl:text>
			<xsl:variable name="maxprice">
				<xsl:call-template name="ndb:MaxPrice">
					<xsl:with-param name="MaxPrice" select="ndb:INSTANCE/ndb:PRICE" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$maxprice" /><br/>

		</xsl:template>
		
	<!-- THE BELOW TEMPLATE LISTS ALL AVAILABLE START DATES FOR THE TOUR -->			
		<xsl:template name="ndb:ListDepartures">

			<xsl:param name="ListDepartures"/>
			<xsl:choose>
				<xsl:when test="$ListDepartures">
					<xsl:variable name="firstdeparture" select="$ListDepartures[1]"/>
					<xsl:variable name="otherDepartures">
						<xsl:call-template name="ndb:ListDepartures">
							<xsl:with-param name="ListDepartures" select="$ListDepartures[position() != 1]"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
					<xsl:when test="$otherDepartures != ''">
						<xsl:value-of select="concat($firstdeparture,'/',$otherDepartures)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($firstdeparture,$otherDepartures)"/>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise />
			</xsl:choose>
		</xsl:template> 
		
	<!-- THE BELOW TEMPLATE CALCULATES THE MAX PRICE FOR THAT TOUR ACROSS ALL AVAILABLE START DATES -->	
		<xsl:template name="ndb:MaxPrice">

			<xsl:param name="MaxPrice"/>
			<xsl:choose>
				<xsl:when test="$MaxPrice">
					<xsl:variable name="firstprice" select="$MaxPrice[1]"/>
					<xsl:variable name="otherPrices">
						<xsl:call-template name="ndb:MaxPrice">
							<xsl:with-param name="MaxPrice" select="$MaxPrice[position() != 1]"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
					<xsl:when test="$firstprice &gt; $otherPrices">
						<xsl:value-of select="$firstprice"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$otherPrices"/>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:template> 
		
		<!-- THE BELOW TEMPLATE CALCULATES THE MIN PRICE FOR THAT TOUR ACROSS ALL AVAILABLE START DATES -->		
		<xsl:template name="ndb:MinPrice">

			<xsl:param name="MinPrice"/>
			<xsl:choose>
				<xsl:when test="$MinPrice">
					<xsl:variable name="firstminprice" select="$MinPrice[position()=last()]"/>
					<xsl:variable name="otherminPrices">
						<xsl:call-template name="ndb:MinPrice">
							<xsl:with-param name="MinPrice" select="$MinPrice[position() != last()]"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
					<xsl:when test="$firstminprice &lt; $otherminPrices">
						<xsl:value-of select="$firstminprice"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$otherminPrices"/>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>100000</xsl:otherwise>   <!-- ADDING A FICTIONAL VALUE HERE TO BREAK THE CHOOSE LOOP AFTER LAST ELEMENT _ VALUE NEEDS TO BE GREATER THAN THE MIN VALUE OF ALL TOURS-->
			</xsl:choose>
		</xsl:template> 
			
		<xsl:template match="ndb:FLIGHTS">
		<xsl:text> Flights included? &#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>  
		<xsl:choose>
			  <xsl:when test=". = 1">
				<xsl:text>Yes</xsl:text><br/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:text>No</xsl:text><br/>
			  </xsl:otherwise>
		</xsl:choose> 
		</xsl:template>	

		<xsl:template match="ndb:TRANSFERS">
		<xsl:text> Transfers included? &#160;&#160;</xsl:text>  
		<xsl:choose>
			  <xsl:when test=". = 1">
				<xsl:text>Yes</xsl:text><br/>
			  </xsl:when>
			  <xsl:otherwise>
				 <xsl:text>No</xsl:text><br/>
			  </xsl:otherwise>
		</xsl:choose> 
		</xsl:template>			
	
	
	<!--> THE BELOW TEMPLATE CALCULATE THE AVERAGE OF ALL RATINGS RECEIVED FROM CLIENTS FOR THAT PARTICULAR TOUR -->
		<xsl:template match="ndb:RATINGS">
			<xsl:text> Average rating? &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>  
			<xsl:variable name="totalrating">
				<xsl:call-template name="ndb:SumRatings">
					<xsl:with-param name="listRatings" select="ndb:RATING" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="round((($totalrating)div(count(ndb:RATING)))*10)div(10)" /><br/>
		</xsl:template>
		
		<xsl:template name="ndb:SumRatings">

			<xsl:param name="listRatings"/>
			<xsl:choose>
				<xsl:when test="$listRatings">
					<xsl:variable name="rating" select="$listRatings[1]"/>
					<xsl:variable name="otherRatings">
						<xsl:call-template name="ndb:SumRatings">
							<xsl:with-param name="listRatings" select="$listRatings[position() != 1]"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$rating+$otherRatings"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:template> 
			
		
		<xsl:template match="ndb:CONTINENT[@contid]">
			<xsl:value-of select='.'/>
		</xsl:template> 
		
		<xsl:template match="ndb:COUNTRY[@countid]">
			<xsl:value-of select='.'/>
		</xsl:template> 
		
		<xsl:template match="ndb:TYPE[@typeid]">
			<xsl:value-of select='.'/>
		</xsl:template> 
		
		<xsl:template match="ndb:BUDGET[@budgid]">
			<xsl:value-of select='.'/>
		</xsl:template> 
		
		<xsl:template match="ndb:GUIDE[@guideid]">
			<xsl:value-of select='.'/>
		</xsl:template> 
		
</xsl:stylesheet>
