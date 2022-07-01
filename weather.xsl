<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
<xsl:template match="weather">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simpleA4" page-height="26cm" page-width="23cm" margin-top="1cm" margin-bottom="1cm" margin-left="1cm" margin-right="1cm" background="blue">
          <fo:region-body background-color="#add8e6" />

<!--
          <fo:region-before background-color="yellow" extent="2cm"/>
          <fo:region-start background-color="green" extent="2cm"/>
          <fo:region-after background-color="red" extent="2mm"/>
          <fo:region-end background-color="#d2b48c" extent="5mm"/>
-->
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simpleA4">

        <fo:flow flow-name="xsl-region-body">

          <fo:block font-size="14pt" >
          <fo:table table-layout="fixed" width="100%" border-collapse="separate">    
            <fo:table-column column-width="8.5cm"/>
            <fo:table-column column-width="7cm"/>

            <fo:table-body>
              <xsl:apply-templates select="header"/>

            </fo:table-body>

          </fo:table>
          </fo:block>
		  
          <fo:block font-size="14pt">
          <fo:table table-layout="fixed" width="100%" border-collapse="separate">    
            <fo:table-column column-width="3.5cm"/>
            <fo:table-column column-width="0.5cm"/>
            <fo:table-column column-width="6.5cm"/>
            <fo:table-column column-width="2.5cm"/>
            <fo:table-column column-width="0.5cm"/>
            <fo:table-column column-width="6.5cm"/>
            <fo:table-body>

              <xsl:apply-templates select="current"/>
              <xsl:apply-templates select="minline"/>
              <xsl:apply-templates select="maxline"/>
              <xsl:apply-templates select="hostline"/>
            </fo:table-body>

          </fo:table>
          </fo:block>
          <xsl:apply-templates select="forecast"/>
		  
		  
        </fo:flow>

      </fo:page-sequence>
     </fo:root>
</xsl:template>


    <xsl:template match="header">

<!--
    <fo:table-row>   
      <fo:table-cell>
        <fo:block font-weight="bold" font-size="20pt">
          <xsl:value-of select="todaydate"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

    <fo:table-row>   
      <fo:table-cell>
        <fo:block text-align="right">&#160; </fo:block>
      </fo:table-cell>
    </fo:table-row>
-->
    <fo:table-row>   
      <fo:table-cell>
        <fo:block font-weight="bold" font-size="20pt">
          <xsl:value-of select="cityname"/>
        </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block font-weight="bold" font-size="20pt">
          <xsl:value-of select="weatherdesc"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

    <fo:table-row>   
      <fo:table-cell>
        <fo:block font-weight="bold" font-size="16pt">
          <xsl:value-of select="nowtime"/>
        </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <xsl:variable name="picfile" select="weatherpic"/>
        <fo:block  font-size="16pt">
          <fo:external-graphic src="file:{$picfile}"/> 
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
	
	
  </xsl:template>

    <xsl:template match="current">
	
    <fo:table-row>   

      <fo:table-cell>
        <fo:block font-weight="bold" text-align="right">Temp: </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>
 
     <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="temp"/>
        </fo:block>
      </fo:table-cell>
     
    </fo:table-row>
    <fo:table-row>   
     <fo:table-cell>
        <fo:block text-align="right">&#160; </fo:block>
      </fo:table-cell> 
    </fo:table-row>   

	</xsl:template>

    <xsl:template match="minline">
    <fo:table-row>   

      <fo:table-cell>
        <fo:block font-weight="bold"  text-align="right">Min Temp: </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="mintemp"/>
        </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block font-weight="bold" text-align="right">Sunrise: </fo:block>
      </fo:table-cell>
	  
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="sunrise"/>
        </fo:block>
      </fo:table-cell>
     
    </fo:table-row>
  </xsl:template>


    <xsl:template match="maxline">
    <fo:table-row>   

      <fo:table-cell>
        <fo:block font-weight="bold" text-align="right">Max Temp: </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="maxtemp"/>
        </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block font-weight="bold" text-align="right">Sunset: </fo:block>
      </fo:table-cell>
	  
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="sunset"/>
        </fo:block>
      </fo:table-cell>
     
    </fo:table-row>
  </xsl:template>


    <xsl:template match="hostline">
    <fo:table-row>   

      <fo:table-cell>
        <fo:block font-weight="bold"  text-align="right">Hostname: </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="hostname"/>
        </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block font-weight="bold" text-align="right">IP Addr: </fo:block>
      </fo:table-cell>
	  
      <fo:table-cell>
        <fo:block> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block text-align="left">
          <xsl:value-of select="ipaddr"/>
        </fo:block>
      </fo:table-cell>
     
    </fo:table-row>
  </xsl:template>

    <xsl:template match="single">
    <fo:table-row>   

      <fo:table-cell>

                     <fo:block> </fo:block>
<!--
                     <xsl:variable name="picfile" select="weatherpic"/>
                     <fo:block width="100pt" height="100pt" content-width="50pt" content-height="50pt" > 
                       <fo:external-graphic src="http://openweathermap.org/img/wn/10d.png"/>
                     </fo:block>
-->

      </fo:table-cell>

      <fo:table-cell>
        <fo:block> <xsl:value-of select="date"/> </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block text-align="left"> <xsl:value-of select="time"/> </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> <xsl:value-of select="temp"/> </fo:block>
      </fo:table-cell>
     
      <fo:table-cell>
        <fo:block> <xsl:value-of select="humidity"/> </fo:block>
      </fo:table-cell>
	  
      <fo:table-cell>
        <fo:block> <xsl:value-of select="wind"/> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block> <xsl:value-of select="desc"/> </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <xsl:variable name="iconfile" select="icon"/>
        <fo:block  font-size="16pt">
          <fo:external-graphic src="file:{$iconfile}"/>
        </fo:block>
      </fo:table-cell>
     
    </fo:table-row>
  </xsl:template>

  <xsl:template match="forecast">

	<fo:table table-layout="fixed" width="100%" border-collapse="separate">    
            <fo:table-column column-width="1cm"/>		<!-- space-->
            <fo:table-column column-width="2.7cm"/>		<!-- date-->
            <fo:table-column column-width="2.3cm"/>		<!-- time-->
            <fo:table-column column-width="2cm"/>		<!-- temp-->
            <fo:table-column column-width="3cm"/>		<!-- humidity-->
            <fo:table-column column-width="2cm"/>		<!-- wind-->
            <fo:table-column column-width="4cm"/>		<!-- desc-->
            <fo:table-column column-width="3cm"/>		<!-- pressure-->

            <fo:table-body>

                 <fo:table-row>   					<!-- blank line -->
                   <fo:table-cell>
                     <fo:block font-weight="bold" > &#160; </fo:block>
                   </fo:table-cell>
                 </fo:table-row>   

                 <fo:table-row>   					<!-- blank line -->
                   <fo:table-cell>
                     <fo:block font-weight="bold" > &#160; </fo:block>
                   </fo:table-cell>
                 </fo:table-row>   

                 <fo:table-row>   					<!-- blank line -->
                   <fo:table-cell>
                     <fo:block font-weight="bold" > </fo:block>
                   </fo:table-cell>
                 </fo:table-row>   



                 <fo:table-row >					<!-- header line -->
                   <fo:table-cell>
                     <fo:block font-weight="bold" > </fo:block>
                   </fo:table-cell>

                   <fo:table-cell>
                     <fo:block font-weight="bold" > Date </fo:block>
                   </fo:table-cell>
                  
                   <fo:table-cell>
                     <fo:block font-weight="bold" > Time </fo:block>
                   </fo:table-cell>
                  
                   <fo:table-cell>
                     <fo:block font-weight="bold" > Temp </fo:block>
                   </fo:table-cell>
             
                   <fo:table-cell>
                     <fo:block font-weight="bold" > Humidity </fo:block>
                   </fo:table-cell>
             	  
                   <fo:table-cell>
                     <fo:block font-weight="bold" > Wind </fo:block>
                   </fo:table-cell>
             
                   <fo:table-cell>
                     <fo:block font-weight="bold" > Description </fo:block>
                   </fo:table-cell>

                   <fo:table-cell>
                     <fo:block font-weight="bold" > </fo:block>
                   </fo:table-cell>
                  
                 </fo:table-row>

		<xsl:apply-templates />

            </fo:table-body>
	</fo:table>

  </xsl:template>

</xsl:stylesheet>
