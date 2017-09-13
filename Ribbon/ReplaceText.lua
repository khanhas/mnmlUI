function replacetext()
  scale = tonumber(SKIN:GetVariable('Scale'))
  text= string.upper(SKIN:GetMeasure('MeasureWeekDay'):GetStringValue())
  font = SELF:GetOption('FontFace')
  fontsize = SKIN:ParseFormula('('..SELF:GetOption('FontSize')..')')
  realFontSize = math.ceil(fontsize*100/70)
  X = 215*scale
  Y = 190*scale
  file = io.open(SKIN:MakePathAbsolute(SELF:GetOption("SVGfile")), "w")

  ParameterTable ={}
  for parameter in string.gmatch(SELF:GetOption('Curve'),"%d+") do ParameterTable[#ParameterTable+1] = parameter*scale end

  template={
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>",
    "<svg",
    "xmlns:dc=\"http://purl.org/dc/elements/1.1/\"",
    "xmlns:cc=\"http://creativecommons.org/ns#\"",
    "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"",
    "xmlns:svg=\"http://www.w3.org/2000/svg\"",
    "xmlns=\"http://www.w3.org/2000/svg\"",
    "xmlns:xlink=\"http://www.w3.org/1999/xlink\"",
    "version=\"1.1\"",
    "width=\"1920\"",
    "height=\"1080\"",
    "id=\"svg2\">",
    "<defs",
    "id=\"defs4\" />",
    "<metadata",
    "id=\"metadata7\">",
    "<rdf:RDF>",
    "<cc:Work",
    "rdf:about=\"\">",
    "<dc:format>image/svg+xml</dc:format>",
    "<dc:type",
    "rdf:resource=\"http://purl.org/dc/dcmitype/StillImage\" />",
    "<dc:title></dc:title>",
    "</cc:Work>",
    "</rdf:RDF>",
    "</metadata>",
    "<text",
    "text-anchor=\"middle\"",
    "id=\"maintext\"",
    "xml:space=\"preserve\"",
    "style=\"font-size:"..realFontSize.."px;font-style:normal;font-weight:normal;fill:#FF0000;font-family:"..font.."\"",
    "id=\"maintext\"><textPath",
    "xlink:href=\"#path39\"",
    "startOffset=\"50%\"><tspan>"..text.."</tspan></textPath></text>",
    "<path",
    "style=\"fill:none;stroke:#000000;stroke-width:0px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"",
    "d=\"M "..ParameterTable[1].." "..ParameterTable[2].." Q "..ParameterTable[5].." "..ParameterTable[6].." "..ParameterTable[3].." "..ParameterTable[4].."\"",
    "id=\"path39\"/>",
    "</svg>"
  }
  file:write(table.concat(template, "\n"))
  file:close()
  
  SKIN:Bang('[!Commandmeasure ScriptVectorConverter "ClearAllShapePath()"][!CommandMeasure Inkscape "Run"]')

end