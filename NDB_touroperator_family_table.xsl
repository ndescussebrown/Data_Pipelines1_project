<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ndb="http://NDBtouroperator.fr/myvocabulary#"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
<!-- THIS STYLESHEET RETURNS ALL TOURS AVAILABLE FOR FAMILIES INCLUDING ALL AVAILABLE START DATES AND PRICE RANGE AND ORDERS THEM BY DURATION (SHORTEST TO LONGEST)-->
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:key name="keycontinent" match="//ndb:CONTINENT" use="@contid" /> 
  <xsl:key name="refcontinent" match="ndb:TOUR/ndb:DEST_CONTINENT" use="@contidref" /> 
  <xsl:key name="keytype" match="//ndb:TYPE" use="@typeid" /> 
  <xsl:key name="reftype" match="ndb:TOUR/ndb:TOUR_TYPE" use="@typeidref" /> 
  <xsl:key name="keybudget" match="//ndb:BUDGET" use="@budgid" /> 
  <xsl:key name="refbudget" match="ndb:TOUR/ndb:TOUR_BUDGET" use="@budgidref" /> 
  <xsl:key name="keycountry" match="//ndb:COUNTRY" use="@countid" /> 
  <xsl:key name="refcountry" match="ndb:TOUR/ndb:DEST_CONTINENT/ndb:DEST_COUNTRY" use="@countidref" /> 

	<xsl:template match="/">

		<html>
			<head> <title>Liste of family holidays</title> </head>
			<body>
				<h2>Liste of family holiday tours</h2>
				<table border="1" cellspacing="0">

					<tr bgcolor="33E9FF">

						<th align="left">TOUR NAME</th>
						<th align="left">DESTINATION</th>
						<th align="left">DURATION</th>
						<th align="left">BUDGET</th>
						<th align="left">AVAILABLE DATES</th>
						<th align="left">PRICE RANGE</th>
						<th align="left">AVERAGE RATING</th>
						<th align="left">DESCRIPTION</th>
					</tr>
			
     				
						  <xsl:apply-templates select="//ndb:TOUR[ndb:TOUR_TYPE[@typeidref='t7']]" >
							<xsl:sort select="ndb:DURATION" order="descending"/>
						  </xsl:apply-templates>

				</table>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="ndb:TOUR[ndb:TOUR_TYPE[@typeidref='t7']]"> 
		<tr bgcolor="FCFBE5">
			<td><xsl:apply-templates select="ndb:TOURNAME"/></td>
			<td><xsl:apply-templates select="ndb:DEST_CONTINENT/ndb:DEST_COUNTRY"/></td>
			<td><xsl:apply-templates select="ndb:DURATION"/></td>
			<td><xsl:apply-templates select="ndb:TOUR_BUDGET"/></td>
			<td><xsl:apply-templates select="ndb:INSTANCES/ndb:INSTANCE/ndb:START_DATE"/></td>
			<td><xsl:apply-templates select="ndb:INSTANCES"/></td>
			<td><xsl:apply-templates select="ndb:RATINGS"/></td>
			<td><xsl:apply-templates select="ndb:DESCRIPTION"/></td>
		</tr>
	</xsl:template>
	
		<xsl:template match="ndb:TOURNAME"> 
			<block style="color:red;text-align:left;font-size:150%;font-family:californian fb"><xsl:value-of select="."/></block>
		</xsl:template> 
		<xsl:template match="ndb:DEST_CONTINENT/ndb:DEST_COUNTRY">
			<xsl:variable name="countparam" select="@countidref" />
			<xsl:apply-templates select="//ndb:COUNTRY[@countid=$countparam]" />
		</xsl:template>
		<xsl:template match="ndb:TOUR_BUDGET">
			<xsl:variable name="budgetparam" select="@budgidref" />
			<xsl:apply-templates select="//ndb:BUDGET[@budgid=$budgetparam]" />
		</xsl:template>
		<xsl:template match="ndb:DESCRIPTION">
		<xsl:choose>
			  <xsl:when test=". = ''">
				<xsl:text>Not yet available</xsl:text>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="."/>
			  </xsl:otherwise>
		</xsl:choose>
		</xsl:template> 
		
		<xsl:template match="ndb:INSTANCES/ndb:INSTANCE/ndb:START_DATE">
			<xsl:variable name="listdate">
				<xsl:call-template name="ndb:ListDepartures">
					<xsl:with-param name="ListDepartures" select="." />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$listdate" /><br/>
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
		
		
		<xsl:template match="ndb:INSTANCES">
			<xsl:text> From €</xsl:text>
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
			<xsl:value-of select="$maxprice" />,<br/>
			<xsl:apply-templates select="../ndb:FLIGHTS" /><br/>
			<xsl:apply-templates select="../ndb:TRANSFERS" />
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
		<xsl:choose>
			  <xsl:when test=". = 1">
				<xsl:text>includes flights,</xsl:text>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:text>excludes flights</xsl:text>
			  </xsl:otherwise>
		</xsl:choose> 
		</xsl:template>	
		
		<xsl:template match="ndb:TRANSFERS">
		<xsl:choose>
			  <xsl:when test=". = 1">
				<xsl:text>includes transfers</xsl:text><br/>
			  </xsl:when>
			  <xsl:otherwise>
				 <xsl:text>excludes transfers</xsl:text><br/>
			  </xsl:otherwise>
		</xsl:choose> 
		</xsl:template>		
		
		<xsl:template match="ndb:RATINGS">
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

		<xsl:template match="ndb:START_DATE">
			<xsl:value-of select="."/>
		</xsl:template> 
		<xsl:template match="ndb:DURATION">
			<xsl:value-of select="."/>
		</xsl:template> 
		<xsl:template match="ndb:PRICE">
			<xsl:value-of select="."/>
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

</xsl:stylesheet>
