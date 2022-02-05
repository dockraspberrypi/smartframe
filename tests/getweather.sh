
TMP=/var/tmp
export APPID=$OPENWEATERAPPID
CITYID=5115985 	# east new york
CITYID=5016450  	# anoka, MN
MEASUREMENT=metric
MEASUREMENT=imperial
OFFSET=7
MAXFORECAST=7
INST=/home/pi/smartframe


init()
{
  cp $INST/weather.xsl $TMP
}

geticons()
{
  icon=$1
  if [ ! -f ${icon}.png ]
  then
    echo fetching graphics for $icon
    wget http://openweathermap.org/img/wn/${icon}.png
    wget http://openweathermap.org/img/wn/${icon}@2x.png
    wget http://openweathermap.org/img/wn/${icon}@4x.png
  fi
}

getcurrentweather()
{
  CMD="api.openweathermap.org/data/2.5/weather?id=${CITYID}&appid=${APPID}&units=$MEASUREMENT"
  RET=`curl -s $CMD`
#  echo $RET | jq -r "." > current.json
}


setcurrentvalues()
{
  weatherdesc=`echo $RET | jq -r ".weather[0].description"`
  currenttemp=`echo $RET | jq -r ".main.temp"`
  expectedlow=`echo $RET | jq -r ".main.temp_min"`
  expectedhigh=`echo $RET | jq -r ".main.temp_max"`
  cityname=`echo $RET | jq -r ".name"`
  currenticon=`echo $RET | jq -r ".weather[0].icon"`

  sunriseDT=`echo $RET | jq -r ".sys.sunrise"`
  sunriseHH=`date --date=@$sunriseDT +'%H'`
  sunriseMM=`date --date=@$sunriseDT +'%M'`
  sunriseHH=$(($sunriseHH - $OFFSET))
  sunrise=$sunriseHH:$sunriseMM
  
  sunsetDT=`echo $RET | jq -r ".sys.sunset"`
  sunsetHH=`date --date=@$sunsetDT +'%H'`
  sunsetMM=`date --date=@$sunsetDT +'%M'`
  sunsetHH=$(($sunsetHH - $OFFSET))
  sunset=$sunsetHH:$sunsetMM

  currenttime=`echo $RET | jq -r ".dt"`
  currenttime=`date --date=@$currenttime +'%Y-%m-%d'`

  geticons $currenticon
}

getforecast() 
{
  CMD="api.openweathermap.org/data/2.5/forecast?id=${CITYID}&appid=${APPID}&units=$MEASUREMENT&cnt=$MAXFORECAST"
  RET=`curl -s $CMD`
#  echo $RET | jq -r "." > forecast.json
}

setforecastvalues()
{
  IDX=$1
  forecasttemp=`echo $RET | jq -r ".list[${IDX}].main.temp"`
  forecastdate=`echo $RET | jq -r ".list[${IDX}].dt"`
  forecasttime=`date --date=@$forecastdate +'%H-%M'`
  forecastdate=`date --date=@$forecastdate +'%Y-%m-%d'`

  forecastdesc=`echo $RET | jq -r ".list[${IDX}].weather[0].description"`
  forecasticon=`echo $RET | jq -r ".list[${IDX}].weather[0].icon"`
  forecastwind=`echo $RET | jq -r ".list[${IDX}].wind.speed"`
  forecastpressure=`echo $RET | jq -r ".list[${IDX}].main.pressure"`
  forecasthumidity=`echo $RET | jq -r ".list[${IDX}].main.humidity"`

  geticons $forecasticon
}

createweatherxml()
{
   getcurrentweather
   setcurrentvalues

   today=`date +'%Y-%m-%d'`
   now=`date +'%H:%M'`
   hostname=`hostname`
   ipaddr=`hostname -I | sed  's/ .*//'`

   OUTPUT="weather.xml"

   if [ $MEASUREMENT == "metric" ]
   then 
      degrees=C
   else
      degrees=F
   fi

   #
   # creates xml data file
   #
   weatherpic=${currenticon}@2x.png

   echo "<?xml version=\"1.0\"?>"                            >$OUTPUT
   echo "<weather>"                                          >>$OUTPUT
   echo "  <header>"                                         >>$OUTPUT
   echo "    <todaydate>$today</todaydate>"                  >>$OUTPUT
   echo "    <nowtime>$now</nowtime>"                        >>$OUTPUT
   echo "    <cityname>$cityname</cityname>"                 >>$OUTPUT
   echo "    <weatherdesc>$weatherdesc</weatherdesc>"        >>$OUTPUT
   echo "    <weatherpic>$weatherpic</weatherpic>"           >>$OUTPUT
   echo "  </header>"                                        >>$OUTPUT
   echo "  <current>"                                        >>$OUTPUT
   echo "    <temp>$currenttemp $degrees</temp>"             >>$OUTPUT
   echo "  </current>"                                       >>$OUTPUT
   echo "  <minline>"                                        >>$OUTPUT
   echo "    <mintemp>$expectedlow $degrees</mintemp>"       >>$OUTPUT
   echo "    <sunrise>$sunrise</sunrise>"                    >>$OUTPUT
   echo "  </minline>"                                       >>$OUTPUT
   echo "  <maxline>"                                        >>$OUTPUT
   echo "    <maxtemp>$expectedhigh $degrees</maxtemp>"      >>$OUTPUT
   echo "    <sunset>$sunset</sunset>"                       >>$OUTPUT
   echo "  </maxline>"                                       >>$OUTPUT

   echo "  <hostline>"                                       >>$OUTPUT
   echo "    <hostname>$hostname</hostname>"                 >>$OUTPUT
   echo "    <ipaddr>$ipaddr</ipaddr>"                       >>$OUTPUT
   echo "  </hostline>"                                      >>$OUTPUT

   getforecast

   echo "  <forecast>"                                       >>$OUTPUT

   idx=0
   lastdate=xxx
   while [ $idx -lt $MAXFORECAST ]
   do
     setforecastvalues $idx

     echo "     <single>"                                    >>$OUTPUT

     chk=`echo $lastdate | grep $forecastdate | wc -l`
     if [ $chk -eq 0 ]
     then
       echo "        <date>$forecastdate</date>"             >>$OUTPUT
     else
       echo "        <date></date>"                          >>$OUTPUT
     fi
     lastdate=$forecastdate

     echo "        <time>$forecasttime</time>"               >>$OUTPUT
     echo "        <temp>$forecasttemp</temp>"               >>$OUTPUT
     echo "        <pressure>$forecastpressure</pressure>"   >>$OUTPUT
     echo "        <humidity>$forecasthumidity</humidity>"   >>$OUTPUT
     echo "        <wind>$forecastwind</wind>"               >>$OUTPUT
     echo "        <desc>$forecastdesc</desc>"               >>$OUTPUT
     echo "        <icon>${forecasticon}.png</icon>"         >>$OUTPUT
     echo "     </single>"                                   >>$OUTPUT

     idx=$(($idx + 1))
   done

   echo "  </forecast>"                                      >>$OUTPUT
   echo "</weather>"                                         >>$OUTPUT
}

function createweatherpng()
{
   fop -xml $OUTPUT -xsl weather.xsl -png weather.png
}

init
cd $TMP
echo $APPID
createweatherxml
createweatherpng
